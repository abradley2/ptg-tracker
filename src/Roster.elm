module Roster exposing (..)

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Extra as DecodeX
import Json.Encode as Encode


type PlayerName
    = PlayerName String


playerNameDecoder : Decoder PlayerName
playerNameDecoder =
    Decode.map PlayerName Decode.string


playerNameEncoder : PlayerName -> Value
playerNameEncoder (PlayerName playerName) =
    Encode.string playerName


type ArmyName
    = ArmyName String


armyNameDecoder : Decoder ArmyName
armyNameDecoder =
    Decode.map ArmyName Decode.string


armyNameEncoder : ArmyName -> Value
armyNameEncoder (ArmyName armyName) =
    Encode.string armyName


type Faction
    = Faction String


factionDecoder : Decoder Faction
factionDecoder =
    Decode.map Faction Decode.string


factionEncoder : Faction -> Value
factionEncoder (Faction faction) =
    Encode.string faction


type SubFaction
    = SubFaction String


subFactionDecoder : Decoder SubFaction
subFactionDecoder =
    Decode.map SubFaction Decode.string


subFactionEncoder : SubFaction -> Value
subFactionEncoder (SubFaction subFaction) =
    Encode.string subFaction


type RealmOfOrigin
    = Shyish
    | Azir


realmOfOriginDecoder : Decoder RealmOfOrigin
realmOfOriginDecoder =
    Decode.andThen
        (\val ->
            case val of
                "Shyish" ->
                    Decode.succeed Shyish

                "Azir" ->
                    Decode.succeed Azir

                _ ->
                    Decode.fail "Invalid RealmOfOrigin"
        )
        Decode.string


realmOfOriginEncoder : RealmOfOrigin -> Value
realmOfOriginEncoder realmOfOrigin =
    case realmOfOrigin of
        Shyish ->
            Encode.string "Shyish"

        Azir ->
            Encode.string "Azir"


type StartingSize
    = Size500
    | Size700
    | Size1000
    | Size1500
    | Size2000


startingSizeDecoder : Decoder StartingSize
startingSizeDecoder =
    Decode.andThen
        (\val ->
            case val of
                "Size500" ->
                    Decode.succeed Size500

                "Size700" ->
                    Decode.succeed Size700

                "Size1000" ->
                    Decode.succeed Size1000

                "Size1500" ->
                    Decode.succeed Size1500

                "Size2000" ->
                    Decode.succeed Size2000

                _ ->
                    Decode.fail "Invalid StartingSize"
        )
        Decode.string


startingSizeEncoder : StartingSize -> Value
startingSizeEncoder startingSize =
    case startingSize of
        Size500 ->
            Encode.string "Size500"

        Size700 ->
            Encode.string "Size700"

        Size1000 ->
            Encode.string "Size1000"

        Size1500 ->
            Encode.string "Size1500"

        Size2000 ->
            Encode.string "Size2000"


type alias Model =
    { playerName : PlayerName
    , armyName : ArmyName
    , faction : Faction
    , subFaction : SubFaction
    , realmOfOrigin : Maybe RealmOfOrigin
    , realmOfOriginSelectOpen : Bool
    , startingSize : Maybe StartingSize
    , startingSizeSelectOpen : Bool
    }


modelDecoder : Decoder Model
modelDecoder =
    Decode.succeed Model
        |> DecodeX.andMap (Decode.field "playerName" playerNameDecoder)
        |> DecodeX.andMap (Decode.field "armyName" armyNameDecoder)
        |> DecodeX.andMap (Decode.field "faction" factionDecoder)
        |> DecodeX.andMap (Decode.field "subFaction" subFactionDecoder)
        |> DecodeX.andMap (Decode.field "realmOfOrigin" realmOfOriginDecoder |> Decode.nullable)
        |> DecodeX.andMap (Decode.succeed False)
        |> DecodeX.andMap (Decode.field "startingSize" startingSizeDecoder |> Decode.nullable)
        |> DecodeX.andMap (Decode.succeed False)


modelEncoder : Model -> Value
modelEncoder model =
    Encode.object
        [ ( "playerName", playerNameEncoder model.playerName )
        , ( "armyName", armyNameEncoder model.armyName )
        , ( "faction", factionEncoder model.faction )
        , ( "subFaction", subFactionEncoder model.subFaction )
        , ( "realmOfOrigin", Maybe.map realmOfOriginEncoder model.realmOfOrigin |> Maybe.withDefault Encode.null )
        , ( "startingSize", Maybe.map startingSizeEncoder model.startingSize |> Maybe.withDefault Encode.null )
        ]


type Msg
    = PlayerNameChanged PlayerName
    | ArmyNameChanged ArmyName
    | FactionChanged Faction
    | SubFactionChanged SubFaction
    | RealmOfOriginChanged RealmOfOrigin
    | RealmOfOriginSelectToggled Bool
    | StartingSizeChanged StartingSize
    | StartingSizeSelectToggled Bool


init : Model
init =
    { playerName = PlayerName ""
    , armyName = ArmyName ""
    , faction = Faction ""
    , subFaction = SubFaction ""
    , realmOfOrigin = Nothing
    , realmOfOriginSelectOpen = False
    , startingSize = Nothing
    , startingSizeSelectOpen = False
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        PlayerNameChanged playerName ->
            { model | playerName = playerName }

        ArmyNameChanged armyName ->
            { model | armyName = armyName }

        FactionChanged faction ->
            { model | faction = faction }

        SubFactionChanged subFaction ->
            { model | subFaction = subFaction }

        RealmOfOriginChanged realmOfOrigin ->
            { model | realmOfOrigin = Just realmOfOrigin }

        StartingSizeChanged startingSize ->
            { model | startingSize = Just startingSize }

        RealmOfOriginSelectToggled realmOfOriginSelectOpen ->
            { model | realmOfOriginSelectOpen = realmOfOriginSelectOpen }

        StartingSizeSelectToggled startingSizeSelectOpen ->
            { model | startingSizeSelectOpen = startingSizeSelectOpen }
