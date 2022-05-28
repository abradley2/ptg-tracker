module Roster.QuestLog exposing (..)

import Accessibility.Styled as H
import Css exposing (..)
import Html.Styled.Attributes as A
import I18Next exposing (Translations)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Extra as DecodeX
import Json.Encode as Encode
import TextInput
import Translations.Roster


type alias Model =
    { currentQuest : CurrentQuest
    , questReward : QuestReward
    , questProgress : QuestProgress
    }


modelDecoder : Decoder Model
modelDecoder =
    Decode.succeed Model
        |> DecodeX.andMap (Decode.field "currentQuest" currentQuestDecoder)
        |> DecodeX.andMap (Decode.field "questReward" questRewardDecoder)
        |> DecodeX.andMap (Decode.field "questProgress" questProgressDecoder)


modelEncoder : Model -> Value
modelEncoder model =
    Encode.object
        [ ( "currentQuest", currentQuestEncoder model.currentQuest )
        , ( "questReward", questRewardEncoder model.questReward )
        , ( "questProgress", questProgressEncoder model.questProgress )
        ]


type CurrentQuest
    = CurrentQuest String


currentQuestDecoder : Decoder CurrentQuest
currentQuestDecoder =
    Decode.map CurrentQuest Decode.string


currentQuestEncoder : CurrentQuest -> Value
currentQuestEncoder (CurrentQuest currentQuest) =
    Encode.string currentQuest


type QuestReward
    = QuestReward String


questRewardDecoder : Decoder QuestReward
questRewardDecoder =
    Decode.map QuestReward Decode.string


questRewardEncoder : QuestReward -> Value
questRewardEncoder (QuestReward questReward) =
    Encode.string questReward


type QuestProgress
    = QuestProgress String


questProgressDecoder : Decoder QuestProgress
questProgressDecoder =
    Decode.map QuestProgress Decode.string


questProgressEncoder : QuestProgress -> Value
questProgressEncoder (QuestProgress questProgress) =
    Encode.string questProgress


type Msg
    = CurrentQuestChanged CurrentQuest
    | QuestRewardChanged QuestReward
    | QuestProgressChanged QuestProgress


init : Model
init =
    { currentQuest = CurrentQuest ""
    , questReward = QuestReward ""
    , questProgress = QuestProgress ""
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        CurrentQuestChanged currentQuest ->
            { model | currentQuest = currentQuest }

        QuestRewardChanged questReward ->
            { model | questReward = questReward }

        QuestProgressChanged questProgress ->
            { model | questProgress = questProgress }


view : List Translations -> Model -> H.Html Msg
view translations model =
    H.div
        [ A.css
            [ displayFlex
            , flexWrap wrap
            , margin <| px -8
            , justifyContent center
            ]
        ]
    <|
        List.map
            (TextInput.view
                >> List.singleton
                >> H.div
                    [ A.css
                        [ margin <| px 8
                        ]
                    ]
            )
            [ { id = "current-quest"
              , label = Translations.Roster.currentQuest translations
              , onChange = CurrentQuest >> CurrentQuestChanged
              , value =
                    case model.currentQuest of
                        CurrentQuest currentQuest ->
                            currentQuest
              }
            , { id = "quest-reward"
              , label = Translations.Roster.questReward translations
              , onChange = QuestReward >> QuestRewardChanged
              , value =
                    case model.questReward of
                        QuestReward questReward ->
                            questReward
              }
            , { id = "quest-progress"
              , label = Translations.Roster.questProgress translations
              , onChange = QuestProgress >> QuestProgressChanged
              , value =
                    case model.questProgress of
                        QuestProgress questProgress ->
                            questProgress
              }
            ]
