module Select exposing (..)

import Accessibility.Styled as H
import Accessibility.Styled.Aria as Aria
import Css exposing (..)
import FocusMenu
import Html.Styled.Attributes as A
import Html.Styled.Events as E
import Theme


type alias Config item msg =
    { items : List item
    , itemLabel : item -> String
    , onSelect : item -> msg
    , selectedItem : Maybe item
    , id : String
    , label : String
    , onToggleMenu : Bool -> msg
    , menuOpen : Bool
    }


view : Config item msg -> H.Html msg
view config =
    let
        menuId =
            config.id ++ "-menu"

        focusMenuClass menuOpen =
            if menuOpen then
                A.css
                    [ maxHeight <| px 400
                    , overflow auto
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
            ]
        ]
        [ H.label
            [ A.id config.id
            ]
            [ H.text config.label
            ]
        , H.button
            [ Aria.controls [ menuId ]
            , Aria.labeledBy config.id
            , E.onClick (config.onToggleMenu <| not config.menuOpen)
            , A.css
                [ minHeight <| px 38
                , maxHeight <| px 38
                , borderWidth <| px 0
                ]
            ]
            [ Maybe.map config.itemLabel config.selectedItem
                |> Maybe.withDefault ""
                |> H.text
            ]
        , FocusMenu.view
            { additionalAttributes =
                [ A.id menuId
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
            List.map (option config) config.items
        ]


option : Config item msg -> item -> H.Html msg
option config item =
    H.button
        []
        [ H.text <| config.itemLabel item
        ]
