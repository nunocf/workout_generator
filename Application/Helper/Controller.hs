module Application.Helper.Controller where

import Data.Map qualified as Map
import Generated.Types
import IHP.ControllerPrelude
import Web.Types

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
