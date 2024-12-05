module Web.Controller.Exercises where

import Web.Controller.Prelude
import Web.View.Exercises.Edit
import Web.View.Exercises.Index
import Web.View.Exercises.New
import Web.View.Exercises.Show

instance Controller ExercisesController where
  action ExercisesAction =
    do
      exercises <- query @Exercise |> fetch

      exercisesMuscleGroups <-
        query @ExercisesMuscleGroup
          |> filterWhereIn (#exerciseId, ids exercises)
          |> fetch

      muscleGroups <-
        query @MuscleGroup
          |> filterWhereIn (#id, map (.muscleGroupId) exercisesMuscleGroups)
          |> fetch

      render IndexView {..}
  action NewExerciseAction = do
    let exercise = newRecord
    muscleGroups <- query @MuscleGroup |> fetch
    render NewView {..}
  action ShowExerciseAction {exerciseId} = do
    exercise <- fetch exerciseId
    render ShowView {..}
  action EditExerciseAction {exerciseId} = do
    exercise <- fetch exerciseId
    render EditView {..}
  action UpdateExerciseAction {exerciseId} = do
    exercise <- fetch exerciseId
    exercise
      |> ifValid \case
        Left exercise -> render EditView {..}
        Right exercise -> do
          exercise <- exercise |> updateRecord
          setSuccessMessage "Exercise updated"
          redirectTo EditExerciseAction {..}
  action CreateExerciseAction = do
    muscleGroups <- query @MuscleGroup |> fetch
    let exercise = newRecord @Exercise
    exercise
      |> ifValid \case
        Left exercise -> render NewView {..}
        Right exercise -> do
          exercise <- exercise |> createRecord
          setSuccessMessage "Exercise created"
          redirectTo ExercisesAction
  action DeleteExerciseAction {exerciseId} = do
    exercise <- fetch exerciseId
    deleteRecord exercise
    setSuccessMessage "Exercise deleted"
    redirectTo ExercisesAction

buildExercise exercise =
  exercise
    |> fill @'["name", "muscleGroup"]
