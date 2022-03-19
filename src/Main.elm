module Main exposing (..)

import Accessibility.Styled as H exposing (toUnstyled)
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
            [ width <| vw 100
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
                    , textAlign center
                    , height <| px 32
                    , lineHeight <| px 32
                    , fontSize <| px 20
                    , letterSpacing <| px 1.5
                    , textTransform uppercase
                    ]
                ]
                [ H.text <| Translations.Roster.title model.translations
                ]
            , H.div
                [ A.css
                    [ padding <| px 16
                    , paddingTop <| px 0
                    , height <| calc (vh 100) minus (px 32)
                    , overflow auto
                    ]
                ]
                [ Roster.view model.translations model.roster
                    |> H.map RosterMsg
                ]
            ]
        ]
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
