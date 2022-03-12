module Language exposing (..)

import I18Next exposing (Translations)


type LanguageId
    = En
    | Es


type alias Language =
    ( LanguageId, Translations )


toTranslations : LanguageId -> List Language -> List Translations
toTranslations primaryLanguageId =
    List.sortWith
        (\( langId, _ ) _ ->
            if langId == primaryLanguageId then
                GT

            else
                LT
        )
        >> List.filter
            (\( langId, _ ) ->
                langId == primaryLanguageId || langId == En
            )
        >> List.map Tuple.second
