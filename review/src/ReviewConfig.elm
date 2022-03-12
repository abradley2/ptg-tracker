module ReviewConfig exposing (config)

import NoPrimitiveTypeAlias
import Review.Rule exposing (Rule)


config : List Rule
config =
    [ NoPrimitiveTypeAlias.rule
    ]
