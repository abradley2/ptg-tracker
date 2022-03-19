module Theme exposing (..)

import Css exposing (..)
import Css.Media as Media exposing (..)


printScreen : List Style -> Style
printScreen =
    withMedia [ only print [] ]


tabletUp : List Style -> Style
tabletUp =
    withMedia [ only screen [ Media.minWidth (px 768) ] ]


lightGrey : Color
lightGrey =
    hex "#e0e0e0"


grey : Color
grey =
    hex "#d3d3d3"


darkGrey : Color
darkGrey =
    hex "#a9a9a9"


lightGreen : Color
lightGreen =
    hex "#95c189"


darkGreen : Color
darkGreen =
    hex "#295016"


softBlack : Color
softBlack =
    hex "#181A18"


white : Color
white =
    hex "#FFFFFF"


offWhite : Color
offWhite =
    hex "#f5f5f5"


boxShadowLight : Style
boxShadowLight =
    boxShadow5 (px 1) (px 2) (px 4) (px 1) (rgba 0 0 0 0.12)
