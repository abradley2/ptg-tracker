module Main exposing (..)

import Accessibility.Styled as H exposing (toUnstyled)
import Accessibility.Styled.Role
import Browser exposing (document)
import Css exposing (..)
import Html.Styled.Attributes as A
import I18Next exposing (Translations)
import Json.Decode as Decode exposing (Decoder, Value, decodeValue)
import Json.Decode.Extra as DecodeX
import Json.Encode as Encode
import Language exposing (Language, LanguageId(..))
import OrderOfBattle
import Platform exposing (Program)
import Result.Extra as ResultX
import Roster
import SelectMenu
import TextInput
import Theme
import Translations.Roster


type Msg
    = OrderOfBattleMsg OrderOfBattle.Msg
    | RosterMsg Roster.Msg
    | SetLanguage LanguageId


type alias Flags =
    { languages : List Language }


flagsDecoder : Decoder Flags
flagsDecoder =
    Decode.map
        Flags
        (Decode.map2
            (\langEn langEs -> [ langEn, langEs ])
            (Decode.field "langEn" I18Next.translationsDecoder
                |> Decode.map (\translations -> ( En, translations ))
            )
            (Decode.field "langEs" I18Next.translationsDecoder
                |> Decode.map (\translations -> ( Es, translations ))
            )
        )


defaultFlags : Flags
defaultFlags =
    { languages = [] }


type alias Model =
    { initError : Maybe Decode.Error
    , flags : Flags
    , translations : List Translations
    , orderOfBattle : OrderOfBattle.Model
    , roster : Roster.Model
    }


modelDecoder : Model -> Decoder Model
modelDecoder initModel =
    Decode.succeed Model
        |> DecodeX.andMap (Decode.succeed initModel.initError)
        |> DecodeX.andMap (Decode.succeed initModel.flags)
        |> DecodeX.andMap (Decode.succeed initModel.translations)
        |> DecodeX.andMap (Decode.field "orderOfBattle" OrderOfBattle.modelDecoder)
        |> DecodeX.andMap (Decode.field "roster" Roster.modelDecoder)


modelEncoder : Model -> Value
modelEncoder model =
    Encode.object
        [ ( "orderOfBattle", OrderOfBattle.modelEncoder model.orderOfBattle )
        , ( "roster", Roster.modelEncoder model.roster )
        ]


body : Model -> List (H.Html Msg)
body model =
    [ H.div
        [ A.css
            [ overflow hidden
            , height <| vh 100
            , width <| vw 100
            , backgroundColor Theme.offWhite
            ]
        ]
        [ H.div
            [ A.css
                [ height <| vh 100
                , overflow hidden
                ]
            ]
            [ H.div
                [ A.css
                    [ backgroundColor Theme.lightGreen
                    , height <| px 64
                    ]
                ]
                []
            , H.div
                [ A.css
                    [ padding <| px 16
                    , height <| calc (vh 100) minus (px 64)
                    , overflow auto
                    ]
                ]
                [ rosterForm model.translations model.roster
                    |> H.map RosterMsg
                ]
            ]
        ]
    ]


rosterForm : List Translations -> Roster.Model -> H.Html Roster.Msg
rosterForm translations model =
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
                        Roster.PlayerName playerName ->
                            playerName
              , onChange = Roster.PlayerName >> Roster.PlayerNameChanged
              , label = Translations.Roster.playerName translations
              , id = "player-name"
              }
            , { value =
                    case model.armyName of
                        Roster.ArmyName armyName ->
                            armyName
              , onChange = Roster.ArmyName >> Roster.ArmyNameChanged
              , label = Translations.Roster.armyName translations
              , id = "army-name"
              }
            , { value =
                    case model.faction of
                        Roster.Faction faction ->
                            faction
              , onChange = Roster.Faction >> Roster.FactionChanged
              , label = Translations.Roster.faction translations
              , id = "faction"
              }
            , { value =
                    case model.subFaction of
                        Roster.SubFaction subFaction ->
                            subFaction
              , onChange = Roster.SubFaction >> Roster.SubFactionChanged
              , label = Translations.Roster.subFaction translations
              , id = "sub-faction"
              }
            ]
            ++ List.map textInputWrapper
                [ SelectMenu.view model.realmOfOriginSelectMenu
                    { id = "realm-of-origin"
                    , selectedItemLabel =
                        Maybe.map
                            (Roster.realmOfOriginEncoder >> Encode.encode 0)
                            model.realmOfOrigin
                    , items =
                        [ { id = Roster.realmOfOriginId "realm-of-origin" Roster.Azir
                          , label = Roster.Azir |> Roster.realmOfOriginEncoder |> Encode.encode 0
                          , value = Roster.Azir
                          }
                        , { id = Roster.realmOfOriginId "realm-of-origin" Roster.Shyish
                          , label = Roster.Shyish |> Roster.realmOfOriginEncoder |> Encode.encode 0
                          , value = Roster.Shyish
                          }
                        ]
                    , label = Translations.Roster.realmOfOrigin translations
                    , onItemSelected = Roster.RealmOfOriginChanged
                    , toMsg = Roster.RealmOfOriginSelectMenuMsg
                    }
                , SelectMenu.view model.startingSizeSelectMenu
                    { id = "starting-size"
                    , selectedItemLabel =
                        Maybe.map
                            (Roster.startingSizeEncoder >> Encode.encode 0)
                            model.startingSize
                    , items =
                        [ { id = Roster.startingSizeId "starting-size" Roster.Size600
                          , label = Roster.Size600 |> Roster.startingSizeEncoder |> Encode.encode 0
                          , value = Roster.Size600
                          }
                        , { id = Roster.startingSizeId "starting-size" Roster.Size1000
                          , label = Roster.Size1000 |> Roster.startingSizeEncoder |> Encode.encode 0
                          , value = Roster.Size1000
                          }
                        , { id = Roster.startingSizeId "starting-size" Roster.Size1500
                          , label = Roster.Size1500 |> Roster.startingSizeEncoder |> Encode.encode 0
                          , value = Roster.Size1500
                          }
                        , { id = Roster.startingSizeId "starting-size" Roster.Size2000
                          , label = Roster.Size2000 |> Roster.startingSizeEncoder |> Encode.encode 0
                          , value = Roster.Size2000
                          }
                        ]
                    , label = Translations.Roster.startingSize translations
                    , onItemSelected = Roster.StartingSizeChanged
                    , toMsg = Roster.StartingSizeSelectMenuMsg
                    }
                ]


init : Value -> ( Model, Cmd Msg )
init value =
    let
        flagsDecodeResult =
            decodeValue flagsDecoder value

        flags =
            Result.withDefault defaultFlags flagsDecodeResult
    in
    ( { initError = ResultX.error flagsDecodeResult
      , flags = flags
      , translations =
            Language.toTranslations
                En
                flags.languages
      , orderOfBattle = OrderOfBattle.init
      , roster = Roster.init
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetLanguage primaryLanguageId ->
            ( { model | translations = Language.toTranslations primaryLanguageId model.flags.languages }
            , Cmd.none
            )

        OrderOfBattleMsg orderOfBattleMsg ->
            ( { model | orderOfBattle = OrderOfBattle.update orderOfBattleMsg model.orderOfBattle }
            , Cmd.none
            )

        RosterMsg rosterMsg ->
            ( { model | roster = Roster.update rosterMsg model.roster }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program Value Model Msg
main =
    document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view =
            \model ->
                { title = "PtG Tracker"
                , body = List.map toUnstyled (body model)
                }
        }
