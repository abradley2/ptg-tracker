module Roster.QuestLog exposing (..)

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Extra as DecodeX
import Json.Encode as Encode


type alias Model =
    { currentQuest : CurrentQuest
    , questReward : QuestReward
    , questProgress : QuestProgress
    }


modelDecoder : Model -> Decoder Model
modelDecoder _ =
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
