module ReviewConfig exposing (config)

import NoEtaReducibleLambdas
import NoMissingSubscriptionsCall
import NoPrematureLetComputation
import NoRecursiveUpdate
import NoRegex
import NoTestValuesInProductionCode
import NoUnused.CustomTypeConstructorArgs
import NoUnused.CustomTypeConstructors
import NoUnused.Dependencies
import NoUnused.Exports
import NoUnused.Modules
import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import NoUselessSubscriptions
import Review.Rule exposing (Rule, ignoreErrorsForDirectories)


config : List Rule
config =
    [ NoEtaReducibleLambdas.rule
        { lambdaReduceStrategy = NoEtaReducibleLambdas.AlwaysRemoveLambdaWhenPossible
        , argumentNamePredicate = always True
        }
    , NoPrematureLetComputation.rule
    , NoRegex.rule
    , NoRecursiveUpdate.rule
    , NoMissingSubscriptionsCall.rule
    , NoUnused.CustomTypeConstructorArgs.rule
    , NoUnused.CustomTypeConstructors.rule []
    , NoUnused.Dependencies.rule
    , NoUnused.Exports.rule
    , NoUnused.Modules.rule
    , NoUnused.Parameters.rule
    , NoUnused.Patterns.rule
    , NoUnused.Variables.rule
    , NoUselessSubscriptions.rule
    , NoTestValuesInProductionCode.rule
        (NoTestValuesInProductionCode.startsWith "test_")
    ]
        |> List.map (ignoreErrorsForDirectories [ "src/Translations" ])
