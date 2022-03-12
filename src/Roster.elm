module Roster exposing (..)

import Json.Decode as Decode exposing (Decoder, Value)
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
    , realmOfOrigin : RealmOfOrigin
    , startingSize : StartingSize
    }


modelDecoder : Decoder Model
modelDecoder =
    Decode.map6
        Model
        (Decode.field "playerName" playerNameDecoder)
        (Decode.field "armyName" armyNameDecoder)
        (Decode.field "faction" factionDecoder)
        (Decode.field "subFaction" subFactionDecoder)
        (Decode.field "realmOfOrigin" realmOfOriginDecoder)
        (Decode.field "startingSize" startingSizeDecoder)


modelEncoder : Model -> Value
modelEncoder model =
    Encode.object
        [ ( "playerName", playerNameEncoder model.playerName )
        , ( "armyName", armyNameEncoder model.armyName )
        , ( "faction", factionEncoder model.faction )
        , ( "subFaction", subFactionEncoder model.subFaction )
        , ( "realmOfOrigin", realmOfOriginEncoder model.realmOfOrigin )
        , ( "startingSize", startingSizeEncoder model.startingSize )
        ]


type Msg
    = PlayerNameChanged PlayerName
    | ArmyNameChanged ArmyName
    | FactionChanged Faction
    | SubFactionChanged SubFaction
    | RealmOfOriginChanged RealmOfOrigin
    | StartingSizeChanged StartingSize


init : Model
init =
    { playerName = PlayerName ""
    , armyName = ArmyName ""
    , faction = Faction ""
    , subFaction = SubFaction ""
    , realmOfOrigin = Shyish
    , startingSize = Size500
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
            { model | realmOfOrigin = realmOfOrigin }

        StartingSizeChanged startingSize ->
            { model | startingSize = startingSize }
