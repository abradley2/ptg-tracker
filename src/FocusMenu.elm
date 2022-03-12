module FocusMenu exposing (..)

import Accessibility.Styled as H
import Html.Styled exposing (Attribute, node)
import Html.Styled.Attributes as A
import Html.Styled.Events as E
import Json.Decode as Decode


type alias Config msg =
    { show : Bool
    , onRequestedClose : msg
    , additionalAttributes : List (Attribute msg)
    }


view : Config msg -> List (H.Html msg) -> H.Html msg
view config =
    node "focus-menu"
        ([ A.attribute "show" <|
            if config.show then
                "true"

            else
                "false"
         , E.on "requestedclose" (Decode.succeed config.onRequestedClose)
         ]
            ++ config.additionalAttributes
        )
