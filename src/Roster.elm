module Roster exposing (..)

import Accessibility.Styled as H
import Css exposing (..)
import Html.Styled.Attributes as A
import I18Next exposing (Translations)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Extra as DecodeX
import Json.Encode as Encode
import Json.EncodeX as EncodeX
import Roster.QuestLog as QuestLog
import Roster.Vault as Vault
import SelectMenu
import TextInput
import Translations.Roster


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
    , vault : Vault.Model
    , questLog : QuestLog.Model
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
        |> DecodeX.andMap (Decode.field "vault" Vault.modelDecoder)
        |> DecodeX.andMap (Decode.field "questLog" QuestLog.modelDecoder)


modelEncoder : Model -> Value
modelEncoder model =
    Encode.object
        [ ( "playerName", playerNameEncoder model.playerName )
        , ( "armyName", armyNameEncoder model.armyName )
        , ( "faction", factionEncoder model.faction )
        , ( "subFaction", subFactionEncoder model.subFaction )
        , ( "realmOfOrigin", Maybe.map realmOfOriginEncoder model.realmOfOrigin |> Maybe.withDefault Encode.null )
        , ( "startingSize", Maybe.map startingSizeEncoder model.startingSize |> Maybe.withDefault Encode.null )
        , ( "vault", Vault.modelEncoder model.vault )
        , ( "questLog", QuestLog.modelEncoder model.questLog )
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
    | VaultMsg Vault.Msg
    | QuestLogMsg QuestLog.Msg


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
    , vault = Vault.init
    , questLog = QuestLog.init
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
            { model
                | realmOfOrigin = Just realmOfOrigin
                , realmOfOriginSelectMenu =
                    SelectMenu.update
                        (SelectMenu.MenuToggled False)
                        model.realmOfOriginSelectMenu
            }

        StartingSizeChanged startingSize ->
            { model
                | startingSize = Just startingSize
                , startingSizeSelectMenu =
                    SelectMenu.update
                        (SelectMenu.MenuToggled False)
                        model.startingSizeSelectMenu
            }

        RealmOfOriginSelectMenuMsg selectMenuMsg ->
            { model
                | realmOfOriginSelectMenu =
                    SelectMenu.update selectMenuMsg model.realmOfOriginSelectMenu
            }

        StartingSizeSelectMenuMsg selectMenuMsg ->
            { model | startingSizeSelectMenu = SelectMenu.update selectMenuMsg model.startingSizeSelectMenu }

        VaultMsg vaultMsg ->
            { model | vault = Vault.update vaultMsg model.vault }

        QuestLogMsg questLogMsg ->
            { model | questLog = QuestLog.update questLogMsg model.questLog }


view : List Translations -> Model -> H.Html Msg
view translations model =
    let
        sectionHeight =
            minHeight <| calc (vh 100) minus (px 32)
    in
    H.div
        []
        [ H.div
            [ A.css
                [ sectionHeight
                , displayFlex
                , alignItems center
                , justifyContent center
                ]
            , A.style "page-break-after" "always"
            ]
            [ overviewSection translations model
            ]
        , H.div
            [ A.css
                [ sectionHeight
                , displayFlex
                , alignItems center
                , justifyContent center
                ]
            , A.style "page-break-after" "always"
            ]
            [ vaultSection translations model
            ]
        ]


vaultSection : List Translations -> Model -> H.Html Msg
vaultSection translations model =
    Vault.view translations model.vault
        |> H.map VaultMsg


overviewSection : List Translations -> Model -> H.Html Msg
overviewSection translations model =
    H.div
        [ A.css
            [ displayFlex
            , flexDirection column
            , alignItems center
            , marginTop (px -16)
            ]
        ]
    <|
        List.map
            (List.singleton
                >> H.div
                    [ A.css
                        [ paddingTop (px 16)
                        ]
                    ]
            )
        <|
            [ mainView translations model
            , QuestLog.view translations model.questLog
                |> H.map QuestLogMsg
            ]


mainView : List Translations -> Model -> H.Html Msg
mainView translations model =
    let
        textInputWrapper =
            List.singleton
                >> H.div
                    [ A.css
                        [ margin <| px 8
                        ]
                    ]
    in
    H.div
        [ A.css
            [ margin <| px -8
            , displayFlex
            , flexWrap wrap
            ]
        ]
    <|
        List.map (TextInput.view >> textInputWrapper)
            [ { value =
                    case model.playerName of
                        PlayerName playerName ->
                            playerName
              , onChange = PlayerName >> PlayerNameChanged
              , label = Translations.Roster.playerName translations
              , id = "player-name"
              }
            , { value =
                    case model.armyName of
                        ArmyName armyName ->
                            armyName
              , onChange = ArmyName >> ArmyNameChanged
              , label = Translations.Roster.armyName translations
              , id = "army-name"
              }
            , { value =
                    case model.faction of
                        Faction faction ->
                            faction
              , onChange = Faction >> FactionChanged
              , label = Translations.Roster.faction translations
              , id = "faction"
              }
            , { value =
                    case model.subFaction of
                        SubFaction subFaction ->
                            subFaction
              , onChange = SubFaction >> SubFactionChanged
              , label = Translations.Roster.subFaction translations
              , id = "sub-faction"
              }
            ]
            ++ List.map textInputWrapper
                [ SelectMenu.view model.realmOfOriginSelectMenu
                    { id = "realm-of-origin"
                    , selectedItemLabel =
                        Maybe.map
                            (realmOfOriginEncoder >> EncodeX.encodeString)
                            model.realmOfOrigin
                    , items =
                        [ { id = realmOfOriginId "realm-of-origin" Azir
                          , label = Azir |> realmOfOriginEncoder |> EncodeX.encodeString
                          , value = Azir
                          }
                        , { id = realmOfOriginId "realm-of-origin" Shyish
                          , label = Shyish |> realmOfOriginEncoder |> EncodeX.encodeString
                          , value = Shyish
                          }
                        ]
                    , label = Translations.Roster.realmOfOrigin translations
                    , onItemSelected = RealmOfOriginChanged
                    , toMsg = RealmOfOriginSelectMenuMsg
                    }
                , SelectMenu.view model.startingSizeSelectMenu
                    { id = "starting-size"
                    , selectedItemLabel =
                        Maybe.map
                            (startingSizeEncoder >> EncodeX.encodeString)
                            model.startingSize
                    , items =
                        [ { id = startingSizeId "starting-size" Size600
                          , label = Size600 |> startingSizeEncoder |> EncodeX.encodeString
                          , value = Size600
                          }
                        , { id = startingSizeId "starting-size" Size1000
                          , label = Size1000 |> startingSizeEncoder |> EncodeX.encodeString
                          , value = Size1000
                          }
                        , { id = startingSizeId "starting-size" Size1500
                          , label = Size1500 |> startingSizeEncoder |> EncodeX.encodeString
                          , value = Size1500
                          }
                        , { id = startingSizeId "starting-size" Size2000
                          , label = Size2000 |> startingSizeEncoder |> EncodeX.encodeString
                          , value = Size2000
                          }
                        ]
                    , label = Translations.Roster.startingSize translations
                    , onItemSelected = StartingSizeChanged
                    , toMsg = StartingSizeSelectMenuMsg
                    }
                ]
