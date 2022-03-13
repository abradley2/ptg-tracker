module Select exposing (..)

import Accessibility.Styled as H
import Accessibility.Styled.Aria as Aria
import Accessibility.Styled.Role as Role
import Css exposing (..)
import FocusMenu
import Html.Styled.Attributes as A
import Html.Styled.Events as E
import Icon
import Theme


type alias Config msg =
    { items : List (OptionConfig msg)
    , selectedItemLabel : Maybe String
    , id : String
    , label : String
    , onToggleMenu : Bool -> msg
    , menuOpen : Bool
    }


view : Config msg -> H.Html msg
view config =
    let
        menuId =
            config.id ++ "-menu"

        focusMenuClass menuOpen =
            if menuOpen then
                A.css
                    [ maxHeight <| px 400
                    , minHeight <| px 400
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
            , Aria.labelledBy config.id
            , Aria.hasListBoxPopUp
            , E.onClick (config.onToggleMenu <| not config.menuOpen)
            , A.css
                [ minHeight <| px 38
                , maxHeight <| px 38
                , borderWidth <| px 0
                , backgroundColor Theme.white
                , cursor pointer
                , position relative
                , textAlign left
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
        , FocusMenu.view
            { additionalAttributes =
                [ A.id menuId
                , Role.listBox
                , A.css
                    [ position absolute
                    , top <| pct 100
                    , left <| px 0
                    , right <| px 0
                    , marginTop <| px 8
                    , backgroundColor Theme.white
                    ]
                , focusMenuClass config.menuOpen
                ]
            , onRequestedClose = config.onToggleMenu False
            , show = config.menuOpen
            }
          <|
            List.map option config.items
        ]


type alias OptionConfig msg =
    { id : String
    , label : String
    , onSelect : msg
    }


option : OptionConfig msg -> H.Html msg
option config =
    H.button
        [ Role.option
        , A.id config.id
        , E.onClick config.onSelect
        , A.css
            [ width <| pct 100
            ]
        ]
        [ H.text config.label
        ]
