module Main exposing (..)

import Accessibility.Styled as H exposing (toUnstyled)
import Browser exposing (document)
import Css exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events as E
import I18Next exposing (Translations)
import Json.Decode as Decode exposing (Decoder, Value, decodeValue)
import Json.Decode.Extra as DecodeX
import Json.Encode as Encode
import OrderOfBattle
import Platform exposing (Program)
import Result.Extra as ResultX
import Roster
import TextInput
import Theme


type Msg
    = OrderOfBattleMsg OrderOfBattle.Msg
    | RosterMsg Roster.Msg


type alias Flags =
    { langEn : Translations
    , langEs : Translations
    }


flagsDecoder : Decoder Flags
flagsDecoder =
    Decode.map2
        Flags
        (Decode.field "langEn" I18Next.translationsDecoder)
        (Decode.field "langEs" I18Next.translationsDecoder)


defaultFlags : Flags
defaultFlags =
    { langEn = I18Next.initialTranslations
    , langEs = I18Next.initialTranslations
    }


type alias Model =
    { initError : Maybe Decode.Error
    , flags : Flags
    , orderOfBattle : OrderOfBattle.Model
    , roster : Roster.Model
    }


modelDecoder : Decoder Model
modelDecoder =
    Decode.succeed Model
        |> DecodeX.andMap (Decode.succeed Nothing)
        |> DecodeX.andMap (Decode.succeed defaultFlags)
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
                [ rosterForm model.roster
                    |> H.map RosterMsg
                ]
            ]
        ]
    ]


rosterForm : Roster.Model -> H.Html Roster.Msg
rosterForm model =
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
              , label = "Player Name"
              , id = "player-name"
              }
            , { value =
                    case model.armyName of
                        Roster.ArmyName armyName ->
                            armyName
              , onChange = Roster.ArmyName >> Roster.ArmyNameChanged
              , label = "Army Name"
              , id = "army-name"
              }
            , { value =
                    case model.faction of
                        Roster.Faction faction ->
                            faction
              , onChange = Roster.Faction >> Roster.FactionChanged
              , label = "Faction"
              , id = "faction"
              }
            , { value =
                    case model.subFaction of
                        Roster.SubFaction subFaction ->
                            subFaction
              , onChange = Roster.SubFaction >> Roster.SubFactionChanged
              , label = "Subfaction"
              , id = "sub-faction"
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
      , orderOfBattle = OrderOfBattle.init
      , roster = Roster.init
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
                { title = "PtG Trackeer"
                , body = List.map toUnstyled (body model)
                }
        }
