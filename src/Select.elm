module Select exposing (..)

import Accessibility.Styled as H
import Accessibility.Styled.Aria as Aria
import Css exposing (..)
import FocusMenu
import Html.Styled.Attributes as A
import Html.Styled.Events as E


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
                A.css []

            else
                A.css []
    in
    H.div
        [ A.css
            [ display inlineFlex
            , flexDirection column
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
            ]
            [ Maybe.map config.itemLabel config.selectedItem
                |> Maybe.withDefault ""
                |> H.text
            ]
        , FocusMenu.view
            { additionalAttributes =
                [ A.id menuId, focusMenuClass config.menuOpen ]
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
