module TextInput exposing (..)

import Accessibility.Styled as H
import Css exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events as E
import Theme


type alias Value =
    String


type alias Config msg =
    { value : Value
    , onChange : String -> msg
    , label : String
    , id : String
    }


view : Config msg -> H.Html msg
view config =
    H.div
        [ A.css
            [ display inlineFlex
            , flexDirection column
            , alignItems stretch
            ]
        ]
        [ H.label
            [ A.css
                [ display block
                , fontSize <| px 16
                , fontWeight bold
                , backgroundColor Theme.lightGreen
                , color Theme.softBlack
                , padding2 (px 8) (px 16)
                , fontWeight normal
                , borderBottom3 (px 1) solid Theme.darkGreen
                , borderTop3 (px 1) solid Theme.darkGreen
                ]
            ]
            [ H.text config.label
            ]
        , H.inputText
            config.value
            [ A.css
                [ borderColor transparent
                , borderWidth <| px 0
                , padding2 (px 0) (px 16)
                , height (px 38)
                , focus
                    [ outline3 (px 1) solid Theme.darkGreen
                    ]
                ]
            , A.id config.id
            , A.value config.value
            , E.onInput config.onChange
            ]
        ]
