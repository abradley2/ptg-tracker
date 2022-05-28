module SelectMenu exposing (..)

import Accessibility.Styled as H
import Accessibility.Styled.Aria as Aria
import Accessibility.Styled.Role as Role
import Array
import Css exposing (..)
import Html.Styled exposing (node)
import Html.Styled.Attributes as A
import Html.Styled.Events as E
import Icon
import Json.Decode as Decode
import Theme


type alias Model =
    { focusIndex : Int
    , menuOpen : Bool
    }


type Msg
    = FocusIndexChanged Int
    | MenuToggled Bool


init : Model
init =
    { focusIndex = -1
    , menuOpen = False
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        FocusIndexChanged focusIndex ->
            { model | focusIndex = focusIndex }

        MenuToggled menuOpen ->
            { model | menuOpen = menuOpen, focusIndex = -1 }


type alias Config item msg =
    { items : List (OptionConfig item)
    , onItemSelected : item -> msg
    , selectedItemLabel : Maybe String
    , id : String
    , label : String
    , toMsg : Msg -> msg
    }


view : Model -> Config item msg -> H.Html msg
view model config =
    let
        menuId =
            config.id ++ "-menu"

        focusMenuClass menuOpen =
            if menuOpen then
                A.css
                    [ maxHeight <| px 400
                    , overflow auto
                    , Theme.boxShadowLight
                    ]

            else
                A.css
                    [ maxHeight <| px 0
                    , overflow hidden
                    ]
    in
    H.div
        [ A.css
            [ display inlineFlex
            , flexDirection column
            , position relative
            , width <| px 254
            ]
        ]
        [ H.label
            [ A.id config.id
            , A.css
                [ padding2 (px 8) (px 16)
                , backgroundColor Theme.lightGreen
                , borderBottom3 (px 1) solid Theme.darkGreen
                , borderTop3 (px 1) solid Theme.darkGreen
                ]
            ]
            [ H.text config.label
            ]
        , H.button
            [ Aria.controls [ menuId ]
            , Aria.labelledBy <| config.id ++ " " ++ config.id ++ "-selection"
            , Aria.hasListBoxPopUp
            , A.css
                [ minHeight <| px 38
                , maxHeight <| px 38
                , padding2 (px 8) (px 16)
                , borderWidth <| px 0
                , backgroundColor Theme.white
                , cursor pointer
                , position relative
                , textAlign left
                , focus
                    [ outline3 (px 1) solid Theme.darkGreen
                    ]
                ]
            ]
            [ H.span
                [ A.id <| config.id ++ "-selection" ]
                [ config.selectedItemLabel
                    |> Maybe.withDefault ""
                    |> H.text
                ]
            , H.div
                [ A.css
                    [ position absolute
                    , right <| px 4
                    , top <| px 0
                    , bottom <| px 0
                    , displayFlex
                    , alignItems center
                    , pointerEvents none
                    ]
                ]
                [ H.div
                    [ A.css
                        [ width <| px 32
                        , height <| px 32
                        , color Theme.darkGrey
                        ]
                    ]
                    [ Icon.expandMore
                    ]
                ]
            ]
        , node
            "select-menu"
            [ A.id menuId
            , Role.listBox
            , case config.items |> List.map .id |> Array.fromList |> Array.get model.focusIndex of
                Just activeDescendant ->
                    Aria.activeDescendant activeDescendant

                Nothing ->
                    A.attribute "data-attr" ""
            , A.css
                [ position absolute
                , top <| pct 100
                , left <| px 0
                , right <| px 0
                , marginTop <| px 4
                , backgroundColor Theme.white
                , zIndex <| int 1
                ]
            , focusMenuClass model.menuOpen
            , A.attribute "focusindex" (String.fromInt model.focusIndex)
            , A.attribute "show" <|
                if model.menuOpen then
                    "true"

                else
                    "false"
            , E.on "requestedopen" (Decode.succeed <| config.toMsg (MenuToggled True))
            , E.on "requestedclose" (Decode.succeed <| config.toMsg (MenuToggled False))
            , E.on "focusindexchanged" (Decode.map (FocusIndexChanged >> config.toMsg) (Decode.field "detail" Decode.int))
            , E.on "itemselected"
                (Decode.andThen
                    (\idx ->
                        case config.items |> Array.fromList |> Array.get idx of
                            Just item ->
                                Decode.succeed (config.onItemSelected item.value)

                            Nothing ->
                                Decode.fail ""
                    )
                    (Decode.field "detail" Decode.int)
                )
            ]
          <|
            List.indexedMap (option config model) config.items
        ]


type alias OptionConfig item =
    { id : String
    , label : String
    , value : item
    }


option : Config item msg -> Model -> Int -> OptionConfig item -> H.Html msg
option config model index optionConfig =
    H.button
        [ Role.option
        , A.id optionConfig.id
        , A.tabindex <| -1
        , A.css <|
            [ width <| pct 100
            , backgroundColor Theme.white
            , padding2 (px 8) (px 16)
            , borderWidth (px 0)
            , borderBottom3 (px 1) solid Theme.darkGreen
            , cursor pointer
            , hover
                [ backgroundColor Theme.lightGreen
                , color Theme.white
                ]
            ]
                ++ (if index == model.focusIndex then
                        [ backgroundColor Theme.lightGreen
                        , color Theme.white
                        ]

                    else
                        []
                   )
        ]
        [ H.text optionConfig.label
        ]
