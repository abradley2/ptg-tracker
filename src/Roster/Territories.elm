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


type alias Model =
    { strongholdTerritories : Array Territory
    , imposingStrongholdTerritories : Array Territory
    , mightyStrongholdTerritories : Array Territory
    }


modelDecoder : Decoder Model
modelDecoder =
    Decode.succeed Model
        |> DecodeX.andMap (Decode.array territoryDecoder |> Decode.field "strongholdTerritories")
        |> DecodeX.andMap (Decode.array territoryDecoder |> Decode.field "imposingStrongholdTerritories")
        |> DecodeX.andMap (Decode.array territoryDecoder |> Decode.field "mightyStrongholdTerritories")


modelEncoder : Model -> Value
modelEncoder model =
    Encode.object
        [ ( "strongholdTerritories", Encode.array territoryEncoder model.strongholdTerritories )
        , ( "imposingStrongholdTerritories", Encode.array territoryEncoder model.imposingStrongholdTerritories )
        , ( "mightyStrongholdTerritories", Encode.array territoryEncoder model.mightyStrongholdTerritories )
        ]
