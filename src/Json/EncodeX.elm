module Json.EncodeX exposing (..)

import Json.Encode as Encode
import String


encodeString : Encode.Value -> String
encodeString =
    Encode.encode 0 >> String.dropLeft 1 >> String.dropRight 1
