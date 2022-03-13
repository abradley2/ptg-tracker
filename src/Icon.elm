module Icon exposing (..)

import Accessibility.Styled exposing (Html, fromUnstyled)
import Svg exposing (path, svg)
import Svg.Attributes exposing (d, fill, viewBox)


expandMore : Html msg
expandMore =
    fromUnstyled <|
        svg
            [ viewBox "0 0 24 24"
            , fill "currentColor"
            ]
            [ path
                [ d "M16.59 8.59L12 13.17 7.41 8.59 6 10l6 6 6-6z"
                ]
                []
            ]


expandLess : Html msg
expandLess =
    fromUnstyled <|
        svg
            [ viewBox "0 0 24 24"
            , fill "currentColor"
            ]
            [ path
                [ d "M12 8l-6 6 1.41 1.41L12 10.83l4.59 4.58L18 14z"
                ]
                []
            ]
