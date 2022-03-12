module OrderOfBattle exposing (..)

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Encode as Encode


type WarlordName
    = WarlordName String


warlordNameDecoder : Decoder WarlordName
warlordNameDecoder =
    Decode.map WarlordName Decode.string


warlordNameEncoder : WarlordName -> Value
warlordNameEncoder (WarlordName warlordName) =
    Encode.string warlordName


type WarlordScroll
    = WarlordScroll String


warlordScrollDecoder : Decoder WarlordScroll
warlordScrollDecoder =
    Decode.map WarlordScroll Decode.string


warlordScrollEncoder : WarlordScroll -> Value
warlordScrollEncoder (WarlordScroll warlordScroll) =
    Encode.string warlordScroll


type alias Model =
    { warlordName : WarlordName
    , warlordScroll : WarlordScroll
    }


modelDecoder : Decoder Model
modelDecoder =
    Decode.map2 Model
        (Decode.field "warlordName" warlordNameDecoder)
        (Decode.field "warlordScroll" warlordScrollDecoder)


modelEncoder : Model -> Value
modelEncoder model =
    Encode.object
        [ ( "warlordName", warlordNameEncoder model.warlordName )
        , ( "warlordScroll", warlordScrollEncoder model.warlordScroll )
        ]


init : Model
init =
    { warlordName = WarlordName "Grimnir"
    , warlordScroll = WarlordScroll "The God of War"
    }


type Msg
    = WarlordNameChanged WarlordName
    | WarlordScrollChanged WarlordScroll


update : Msg -> Model -> Model
update msg model =
    case msg of
        WarlordNameChanged warlordName ->
            { model | warlordName = warlordName }

        WarlordScrollChanged warlordScroll ->
            { model | warlordScroll = warlordScroll }
