module Roster.Territories exposing (..)

import Accessibility.Styled as H
import Array exposing (Array)
import Css exposing (..)
import Html.Styled.Attributes as A
import I18Next exposing (Translations)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Extra as DecodeX
import Json.Encode as Encode
import Translations.Roster.Territories as Translations


territoryInit : Territory
territoryInit =
    { name = TerritoryName ""
    , territoryType = TerritoryType ""
    , upgraded = TerritoryUpgraded False
    }


type alias Territory =
    { name : TerritoryName
    , territoryType : TerritoryType
    , upgraded : TerritoryUpgraded
    }


territoryDecoder : Decoder Territory
territoryDecoder =
    Decode.succeed Territory
        |> DecodeX.andMap (Decode.field "name" territoryNameDecoder)
        |> DecodeX.andMap (Decode.field "territoryType" territoryTypeDecoder)
        |> DecodeX.andMap (Decode.field "upgraded" territoryUpgradedDecoder)


territoryEncoder : Territory -> Value
territoryEncoder territory =
    Encode.object
        [ ( "name", territoryNameEncoder territory.name )
        , ( "territoryType", territoryTypeEncoder territory.territoryType )
        , ( "upgraded", territoryUpgradedEncoder territory.upgraded )
        ]


type TerritoryName
    = TerritoryName String


territoryNameDecoder : Decoder TerritoryName
territoryNameDecoder =
    Decode.map TerritoryName Decode.string


territoryNameEncoder : TerritoryName -> Value
territoryNameEncoder (TerritoryName territoryName) =
    Encode.string territoryName


type TerritoryType
    = TerritoryType String


territoryTypeDecoder : Decoder TerritoryType
territoryTypeDecoder =
    Decode.map TerritoryType Decode.string


territoryTypeEncoder : TerritoryType -> Value
territoryTypeEncoder (TerritoryType territoryType) =
    Encode.string territoryType


type TerritoryUpgraded
    = TerritoryUpgraded Bool


territoryUpgradedDecoder : Decoder TerritoryUpgraded
territoryUpgradedDecoder =
    Decode.map TerritoryUpgraded Decode.bool


territoryUpgradedEncoder : TerritoryUpgraded -> Value
territoryUpgradedEncoder (TerritoryUpgraded territoryUpgraded) =
    Encode.bool territoryUpgraded


type StrongholdTerritories
    = StrongholdTerritories (Array Territory)


strongholdTerritoriesDecoder : Decoder StrongholdTerritories
strongholdTerritoriesDecoder =
    Decode.map StrongholdTerritories <| Decode.array territoryDecoder


strongholdTerritoriesEncoder : StrongholdTerritories -> Value
strongholdTerritoriesEncoder (StrongholdTerritories strongholdTerritories) =
    Encode.array territoryEncoder strongholdTerritories


type ImposingStrongholdTerritories
    = ImposingStrongholdTerritories (Array Territory)


imposingStrongholdTerritoriesDecoder : Decoder ImposingStrongholdTerritories
imposingStrongholdTerritoriesDecoder =
    Decode.map ImposingStrongholdTerritories <| Decode.array territoryDecoder


imposingStrongholdTerritoriesEncoder : ImposingStrongholdTerritories -> Value
imposingStrongholdTerritoriesEncoder (ImposingStrongholdTerritories imposingStrongholdTerritories) =
    Encode.array territoryEncoder imposingStrongholdTerritories


type MightyStrongholdTerritories
    = MightyStrongholdTerritories (Array Territory)


mightyStrongholdTerritoriesDecoder : Decoder MightyStrongholdTerritories
mightyStrongholdTerritoriesDecoder =
    Decode.map MightyStrongholdTerritories <| Decode.array territoryDecoder


mightyStrongholdTerritoriesEncoder : MightyStrongholdTerritories -> Value
mightyStrongholdTerritoriesEncoder (MightyStrongholdTerritories mightyStrongholdTerritories) =
    Encode.array territoryEncoder mightyStrongholdTerritories


type alias Model =
    { strongholdTerritories : StrongholdTerritories
    , imposingStrongholdTerritories : ImposingStrongholdTerritories
    , mightyStrongholdTerritories : MightyStrongholdTerritories
    }


modelDecoder : Decoder Model
modelDecoder =
    Decode.succeed Model
        |> DecodeX.andMap (Decode.field "strongholdTerritories" strongholdTerritoriesDecoder)
        |> DecodeX.andMap (Decode.field "imposingStrongholdTerritories" imposingStrongholdTerritoriesDecoder)
        |> DecodeX.andMap (Decode.field "mightyStrongholdTerritories" mightyStrongholdTerritoriesDecoder)


modelEncoder : Model -> Value
modelEncoder model =
    Encode.object
        [ ( "strongholdTerritories", strongholdTerritoriesEncoder model.strongholdTerritories )
        , ( "imposingStrongholdTerritories", imposingStrongholdTerritoriesEncoder model.imposingStrongholdTerritories )
        , ( "mightyStrongholdTerritories", mightyStrongholdTerritoriesEncoder model.mightyStrongholdTerritories )
        ]


type Msg
    = StrongholdTerritoriesChanged StrongholdTerritories
    | ImposingStrongholdTerritoriesChanged ImposingStrongholdTerritories
    | MightyStrongholdTerritoriesChanged MightyStrongholdTerritories


init : Model
init =
    { strongholdTerritories = StrongholdTerritories <| Array.repeat 3 territoryInit
    , imposingStrongholdTerritories = ImposingStrongholdTerritories <| Array.repeat 3 territoryInit
    , mightyStrongholdTerritories = MightyStrongholdTerritories <| Array.repeat 3 territoryInit
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        StrongholdTerritoriesChanged strongholdTerritories ->
            { model | strongholdTerritories = strongholdTerritories }

        ImposingStrongholdTerritoriesChanged imposingStrongholdTerritories ->
            { model | imposingStrongholdTerritories = imposingStrongholdTerritories }

        MightyStrongholdTerritoriesChanged mightyStrongholdTerritories ->
            { model | mightyStrongholdTerritories = mightyStrongholdTerritories }
