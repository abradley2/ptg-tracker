module Roster.Vault exposing (..)

import Accessibility.Styled as H
import Accessibility.Styled.Aria as Aria
import Array exposing (Array)
import Css exposing (..)
import Html.Styled.Attributes as A
import Html.Styled.Events as E
import I18Next exposing (Translations)
import Icon
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Extra as DecodeX
import Json.Encode as Encode
import Theme
import Translations.Roster


type ArtefactsOfPower
    = ArtefactsOfPower (Array String)


artefactsOfPowerDecoder : Decoder ArtefactsOfPower
artefactsOfPowerDecoder =
    Decode.array Decode.string
        |> Decode.map ArtefactsOfPower


artefactsOfPowerEncoder : ArtefactsOfPower -> Value
artefactsOfPowerEncoder (ArtefactsOfPower artefactsOfPower) =
    Encode.array Encode.string artefactsOfPower


type UniqueEnhancements
    = UniqueEnhancements (Array String)


uniqueEnhancementsDecoder : Decoder UniqueEnhancements
uniqueEnhancementsDecoder =
    Decode.array Decode.string
        |> Decode.map UniqueEnhancements


uniqueEnhancementsEncoder : UniqueEnhancements -> Value
uniqueEnhancementsEncoder (UniqueEnhancements uniqueEnhancements) =
    Encode.array Encode.string uniqueEnhancements


type Spells
    = Spells (Array String)


spellsDecoder : Decoder Spells
spellsDecoder =
    Decode.array Decode.string
        |> Decode.map Spells


spellsEncoder : Spells -> Value
spellsEncoder (Spells spells) =
    Encode.array Encode.string spells


type Prayers
    = Prayers (Array String)


prayersDecoder : Decoder Prayers
prayersDecoder =
    Decode.array Decode.string
        |> Decode.map Prayers


prayersEncoder : Prayers -> Value
prayersEncoder (Prayers prayers) =
    Encode.array Encode.string prayers


type EndlessSpellsInvocations
    = EndlessSpellsInvocations (Array String)


endlessSpellsInvocationsDecoder : Decoder EndlessSpellsInvocations
endlessSpellsInvocationsDecoder =
    Decode.array Decode.string
        |> Decode.map EndlessSpellsInvocations


endlessSpellsInvocationsEncoder : EndlessSpellsInvocations -> Value
endlessSpellsInvocationsEncoder (EndlessSpellsInvocations spells) =
    Encode.array Encode.string spells


type Battalions
    = Battalions (Array String)


battalionsDecoder : Decoder Battalions
battalionsDecoder =
    Decode.array Decode.string
        |> Decode.map Battalions


battleBattalionsEncoder : Battalions -> Value
battleBattalionsEncoder (Battalions battalions) =
    Encode.array Encode.string battalions


type alias Model =
    { artefactsOfPower : ArtefactsOfPower
    , uniqueEnhancements : UniqueEnhancements
    , spells : Spells
    , prayers : Prayers
    , endlessSpellsInvocations : EndlessSpellsInvocations
    , battalions : Battalions
    }


modelDecoder : Decoder Model
modelDecoder =
    Decode.succeed Model
        |> DecodeX.andMap (Decode.field "artefactsOfPower" artefactsOfPowerDecoder)
        |> DecodeX.andMap (Decode.field "uniqueEnhancements" uniqueEnhancementsDecoder)
        |> DecodeX.andMap (Decode.field "spells" spellsDecoder)
        |> DecodeX.andMap (Decode.field "prayers" prayersDecoder)
        |> DecodeX.andMap (Decode.field "endlessSpellsInvocations" endlessSpellsInvocationsDecoder)
        |> DecodeX.andMap (Decode.field "battalions" battalionsDecoder)


modelEncoder : Model -> Value
modelEncoder model =
    Encode.object
        [ ( "artefactsOfPower", artefactsOfPowerEncoder model.artefactsOfPower )
        , ( "uniqueEnhancements", uniqueEnhancementsEncoder model.uniqueEnhancements )
        , ( "spells", spellsEncoder model.spells )
        , ( "prayers", prayersEncoder model.prayers )
        , ( "endlessSpellsInvocations", endlessSpellsInvocationsEncoder model.endlessSpellsInvocations )
        , ( "battalions", battleBattalionsEncoder model.battalions )
        ]


init : Model
init =
    { artefactsOfPower = ArtefactsOfPower (Array.repeat 6 "")
    , uniqueEnhancements = UniqueEnhancements (Array.repeat 6 "")
    , spells = Spells (Array.repeat 6 "")
    , prayers = Prayers (Array.repeat 6 "")
    , endlessSpellsInvocations = EndlessSpellsInvocations (Array.repeat 3 "")
    , battalions = Battalions (Array.repeat 6 "")
    }


type Msg
    = ArtefactsOfPowerChanged ArtefactsOfPower
    | UniqueEnhancementsChanged UniqueEnhancements
    | SpellsChanged Spells
    | PrayersChanged Prayers
    | EndlessSpellsInvocationsChanged EndlessSpellsInvocations
    | BattalionsChanged Battalions


update : Msg -> Model -> Model
update msg model =
    case msg of
        ArtefactsOfPowerChanged artefactsOfPower ->
            { model | artefactsOfPower = artefactsOfPower }

        UniqueEnhancementsChanged uniqueEnhancements ->
            { model | uniqueEnhancements = uniqueEnhancements }

        SpellsChanged spells ->
            { model | spells = spells }

        PrayersChanged prayers ->
            { model | prayers = prayers }

        EndlessSpellsInvocationsChanged endlessSpellsInvocations ->
            { model | endlessSpellsInvocations = endlessSpellsInvocations }

        BattalionsChanged battalions ->
            { model | battalions = battalions }


view : List Translations -> Model -> H.Html Msg
view translations model =
    H.div
        [ A.css
            [ margin (px -8)
            , displayFlex
            , flexWrap wrap
            ]
        ]
        [ H.div
            []
            [ vault
                { label = Translations.Roster.artefactsOfPower translations
                , id = "artefacts-of-power-vault"
                , items =
                    case model.artefactsOfPower of
                        ArtefactsOfPower artefactsOfPower ->
                            artefactsOfPower
                , onChange = ArtefactsOfPower >> ArtefactsOfPowerChanged
                }
            ]
        , H.div
            []
            [ vault
                { label = Translations.Roster.uniqueEnhancements translations
                , id = "unique-enhancements-vault"
                , items =
                    case model.uniqueEnhancements of
                        UniqueEnhancements uniqueEnhancements ->
                            uniqueEnhancements
                , onChange = UniqueEnhancements >> UniqueEnhancementsChanged
                }
            ]
        , H.div
            []
            [ vault
                { label = Translations.Roster.spells translations
                , id = "spells-vault"
                , items =
                    case model.spells of
                        Spells spells ->
                            spells
                , onChange = Spells >> SpellsChanged
                }
            ]
        , H.div
            []
            [ vault
                { label = Translations.Roster.prayers translations
                , id = "prayers-vault"
                , items =
                    case model.prayers of
                        Prayers prayers ->
                            prayers
                , onChange = Prayers >> PrayersChanged
                }
            ]
        , H.div
            []
            [ vault
                { label = Translations.Roster.endlessSpellsInvocations translations
                , id = "endless-spells-invocations-vault"
                , items =
                    case model.endlessSpellsInvocations of
                        EndlessSpellsInvocations endlessSpellsInvocations ->
                            endlessSpellsInvocations
                , onChange = EndlessSpellsInvocations >> EndlessSpellsInvocationsChanged
                }
            ]
        , H.div
            []
            [ vault
                { label = Translations.Roster.battalions translations
                , id = "battalions-vault"
                , items =
                    case model.battalions of
                        Battalions battalions ->
                            battalions
                , onChange = Battalions >> BattalionsChanged
                }
            ]
        ]


type alias VaultConfig =
    { id : String
    , label : String
    , items : Array String
    , onChange : Array String -> Msg
    }


vault : VaultConfig -> H.Html Msg
vault config =
    H.div
        [ A.css
            [ display inlineFlex
            , flexDirection column
            , margin (px 8)
            , width <| px 254
            ]
        ]
    <|
        H.div
            [ A.css
                [ backgroundColor Theme.lightGreen
                , borderTop3 (px 1) solid Theme.darkGreen
                , borderBottom3 (px 1) solid Theme.darkGreen
                , padding2 (px 8) (px 16)
                , paddingRight <| px 44
                , position relative
                ]
            ]
            [ H.span
                [ A.id config.id
                ]
                [ H.text config.label
                ]
            , H.div
                [ A.css
                    [ position absolute
                    , right <| px 4
                    , top <| px 0
                    , bottom <| px 0
                    , display inlineFlex
                    , alignItems center
                    ]
                ]
                [ H.button
                    [ A.css
                        [ width <| px 28
                        , height <| px 28
                        , margin <| px 4
                        , color Theme.white
                        , backgroundColor transparent
                        , borderWidth <| px 0
                        , cursor pointer
                        , focus
                            [ outline3 (px 1) solid Theme.white
                            ]
                        ]
                    , config.items
                        |> (\items -> Array.append items (Array.fromList [ "" ]))
                        |> config.onChange
                        |> E.onClick
                    ]
                    [ Icon.plus
                    ]
                ]
            ]
            :: (config.items
                    |> Array.toList
                    |> List.indexedMap
                        (\idx item ->
                            H.inputText
                                item
                                [ A.css
                                    [ borderColor transparent
                                    , borderWidth <| px 0
                                    , padding2 (px 0) (px 16)
                                    , height (px 38)
                                    , borderLeft3 (px 1) solid Theme.lightGreen
                                    , borderBottom3 (px 1) solid Theme.lightGreen
                                    , borderRight3 (px 1) solid Theme.lightGreen
                                    , focus
                                        [ borderBottom3 (px 1) solid Theme.darkGreen
                                        , outline none
                                        , backgroundColor Theme.lightGrey
                                        ]
                                    ]
                                , Aria.labelledBy config.id
                                , A.id <| config.id ++ "-entry-" ++ String.fromInt idx
                                , A.value item
                                , E.onInput
                                    (\val ->
                                        Array.set idx val config.items
                                            |> config.onChange
                                    )
                                ]
                        )
               )
