module Roster exposing (..)

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Extra as DecodeX
import Json.Encode as Encode
import SelectMenu


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


realmOfOriginId : String -> RealmOfOrigin -> String
realmOfOriginId prefix realmOfOrigin =
    prefix
        ++ "-"
        ++ (case realmOfOrigin of
                Shyish ->
                    "shyish"

                Azir ->
                    "azir"
           )


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
    = Size600
    | Size1000
    | Size1500
    | Size2000


startingSizeId : String -> StartingSize -> String
startingSizeId prefix startingSize =
    prefix
        ++ "-"
        ++ (case startingSize of
                Size600 ->
                    "size-600"

                Size1000 ->
                    "size-1000"

                Size1500 ->
                    "size-1500"

                Size2000 ->
                    "size-2000"
           )


startingSizeDecoder : Decoder StartingSize
startingSizeDecoder =
    Decode.andThen
        (\val ->
            case val of
                "600" ->
                    Decode.succeed Size600

                "1000" ->
                    Decode.succeed Size1000

                "1500" ->
                    Decode.succeed Size1500

                "2000" ->
                    Decode.succeed Size2000

                _ ->
                    Decode.fail "Invalid StartingSize"
        )
        Decode.string


startingSizeEncoder : StartingSize -> Value
startingSizeEncoder startingSize =
    case startingSize of
        Size600 ->
            Encode.string "600"

        Size1000 ->
            Encode.string "1000"

        Size1500 ->
            Encode.string "1500"

        Size2000 ->
            Encode.string "2000"


type alias Model =
    { playerName : PlayerName
    , armyName : ArmyName
    , faction : Faction
    , subFaction : SubFaction
    , realmOfOrigin : Maybe RealmOfOrigin
    , realmOfOriginSelectMenu : SelectMenu.Model
    , startingSize : Maybe StartingSize
    , startingSizeSelectMenu : SelectMenu.Model
    }


modelDecoder : Decoder Model
modelDecoder =
    Decode.succeed Model
        |> DecodeX.andMap (Decode.field "playerName" playerNameDecoder)
        |> DecodeX.andMap (Decode.field "armyName" armyNameDecoder)
        |> DecodeX.andMap (Decode.field "faction" factionDecoder)
        |> DecodeX.andMap (Decode.field "subFaction" subFactionDecoder)
        |> DecodeX.andMap (Decode.field "realmOfOrigin" realmOfOriginDecoder |> Decode.nullable)
        |> DecodeX.andMap (Decode.succeed SelectMenu.init)
        |> DecodeX.andMap (Decode.field "startingSize" startingSizeDecoder |> Decode.nullable)
        |> DecodeX.andMap (Decode.succeed SelectMenu.init)


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
    | RealmOfOriginSelectMenuMsg SelectMenu.Msg
    | StartingSizeChanged StartingSize
    | StartingSizeSelectMenuMsg SelectMenu.Msg


init : Model
init =
    { playerName = PlayerName ""
    , armyName = ArmyName ""
    , faction = Faction ""
    , subFaction = SubFaction ""
    , realmOfOrigin = Nothing
    , realmOfOriginSelectMenu = SelectMenu.init
    , startingSize = Nothing
    , startingSizeSelectMenu = SelectMenu.init
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

        RealmOfOriginSelectMenuMsg selectMenuMsg ->
            { model
                | realmOfOriginSelectMenu =
                    SelectMenu.update selectMenuMsg model.realmOfOriginSelectMenu
            }

        StartingSizeSelectMenuMsg selectMenuMsg ->
            { model | startingSizeSelectMenu = SelectMenu.update selectMenuMsg model.startingSizeSelectMenu }
