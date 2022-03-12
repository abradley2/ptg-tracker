module Theme exposing (..)

import Css exposing (..)
import Css.Media as Media exposing (..)


tabletUp : List Style -> Style
tabletUp =
    withMedia [ only screen [ Media.minWidth (px 768) ] ]


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
