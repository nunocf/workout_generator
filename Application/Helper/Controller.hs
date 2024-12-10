module Application.Helper.Controller where

import Data.ByteString qualified as ByteString
import Data.Map qualified as Map
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.Types (Query (Query))
import Generated.Types
import IHP.ControllerPrelude
import IHP.ModelSupport
import IHP.QueryBuilder
import Web.Types

instance CanCreate ExerciseWithMuscleGroups where
  create :: (?modelContext :: ModelContext) => ExerciseWithMuscleGroups -> IO ExerciseWithMuscleGroups
  create (ExerciseWithMuscleGroups {exercise, muscleGroups}) = do
    createdExercise <- create exercise
    let exercisesMuscleGroups :: [ExercisesMuscleGroup] =
          map
            ( \(muscleGroup) ->
                newRecord @ExercisesMuscleGroup
                  |> set #exerciseId (get #id createdExercise)
                  |> set #muscleGroupId (get #id muscleGroup)
            )
            muscleGroups
    exerciseMuscleGroups <- createMany exercisesMuscleGroups
    pure
      ( ExerciseWithMuscleGroups
          { muscleGroups = muscleGroups,
            exercise = exercise
          }
      )
  createMany :: (?modelContext :: ModelContext) => [ExerciseWithMuscleGroups] -> IO [ExerciseWithMuscleGroups]
  createMany [] = pure []
  createMany models = do
    createdExercises <- createMany (map (.exercise) models)
    let exercisesWithMuscleGroups = zip models createdExercises
    let exercisesMuscleGroups =
          concatMap
            ( \(model, createdExercise) ->
                map
                  ( \(muscleGroup) ->
                      newRecord @ExercisesMuscleGroup
                        |> set #exerciseId (get #id createdExercise)
                        |> set #muscleGroupId (get #id muscleGroup)
                  )
                  model.muscleGroups
            )
            exercisesWithMuscleGroups
    _ <- createMany exercisesMuscleGroups
    pure $
      zipWith
        ( \model createdExercise ->
            ExerciseWithMuscleGroups
              { exercise = createdExercise,
                muscleGroups = model.muscleGroups
              }
        )
        models
        createdExercises

-- | an `Exercise` with all associated MuscleGroups
fetchExerciseWithMuscleGroups :: (?modelContext :: ModelContext) => Id Exercise -> IO ExerciseWithMuscleGroups
fetchExerciseWithMuscleGroups exerciseId = do
  exercise <- fetch exerciseId

  muscleGroups <-
    query @MuscleGroup
      |> innerJoin @ExercisesMuscleGroup (#id, #muscleGroupId)
      |> filterWhereJoinedTable @ExercisesMuscleGroup (#exerciseId, exerciseId)
      |> fetch

  return $
    ExerciseWithMuscleGroups
      { exercise = exercise,
        muscleGroups = muscleGroups
      }

-- | an `Exercise` with all associated MuscleGroups
fetchAllExercisesWithMuscleGroups :: (?modelContext :: ModelContext) => IO [ExerciseWithMuscleGroups]
fetchAllExercisesWithMuscleGroups = do
  exercises <- query @Exercise |> fetch

  labeledMuscleGroups <-
    query @MuscleGroup
      |> innerJoin @ExercisesMuscleGroup (#id, #muscleGroupId)
      |> innerJoinThirdTable @Exercise @ExercisesMuscleGroup (#id, #exerciseId)
      |> labelResults @Exercise #id
      |> fetch

  let muscleGroupsByExerciseId :: Map (Id Exercise) [MuscleGroup] =
        foldr
          ( \labeledMuscleGroup acc ->
              Map.insertWith
                (++)
                labeledMuscleGroup.labelValue
                [labeledMuscleGroup.contentValue]
                acc
          )
          Map.empty
          labeledMuscleGroups

  let exercisesWithMuscleGroups =
        map
          ( \exercise ->
              ExerciseWithMuscleGroups
                { exercise = exercise,
                  muscleGroups = Map.findWithDefault [] exercise.id muscleGroupsByExerciseId
                }
          )
          exercises

  return $ exercisesWithMuscleGroups
