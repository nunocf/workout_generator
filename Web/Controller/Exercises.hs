module Web.Controller.Exercises where

import Application.Helper.Controller qualified as ControllerHelper
import Web.Controller.Prelude
import Web.View.Exercises.Edit
import Web.View.Exercises.Index
import Web.View.Exercises.New
import Web.View.Exercises.Show

instance Controller ExercisesController where
  action ExercisesAction =
    do
      exercisesWithMuscleGroups <- ControllerHelper.fetchAllExercisesWithMuscleGroups

      render IndexView {..}
  action NewExerciseAction = do
    let exercise = newRecord
    muscleGroups <- query @MuscleGroup |> fetch
    render NewView {..}
  action ShowExerciseAction {exerciseId} = do
    exercise <- fetch exerciseId
    render ShowView {..}
  action EditExerciseAction {exerciseId} = do
    exerciseWithMuscleGroups <- ControllerHelper.fetchExerciseWithMuscleGroups exerciseId
    allMuscleGroups <- query @MuscleGroup |> fetch
    render EditView {..}
  action UpdateExerciseAction {exerciseId} = do
    exerciseWithMuscleGroups <- ControllerHelper.fetchExerciseWithMuscleGroups exerciseId
    allMuscleGroups <- query @MuscleGroup |> fetch
    exerciseWithMuscleGroups.exercise
      |> ifValid \case
        Left exercise -> render EditView {..}
        Right exercise -> do
          exercise <- exercise |> updateRecord
          setSuccessMessage "Exercise updated"
          redirectTo EditExerciseAction {..}
  action CreateExerciseAction = do
    muscleGroups <- query @MuscleGroup |> fetch
    let paramMuscleGroupIds = paramList @(Id MuscleGroup) "muscleGroupIds"
    newRecord @Exercise
      |> buildExercise
      |> ifValid \case
        Left exercise -> render NewView {..}
        Right exercise -> do
          withTransaction do
            exercise <- createRecord exercise
            exerciseMuscleGroups <- createExerciseMuscleGroups exercise paramMuscleGroupIds
            setSuccessMessage "Exercise created"

          redirectTo ExercisesAction
  action DeleteExerciseAction {exerciseId} = do
    exercise <- fetch exerciseId
    deleteRecord exercise
    setSuccessMessage "Exercise deleted"
    redirectTo ExercisesAction

buildExercise exercise =
  exercise
    |> fill @'["name"]
    |> validateField #name nonEmpty

createExerciseMuscleGroups exercise muscleGroupIds = do
  let exercisesMuscleGroupsToCreate =
        map
          ( \muscleGroupId ->
              newRecord @ExercisesMuscleGroup
                |> set #exerciseId (get #id exercise)
                |> set #muscleGroupId muscleGroupId
          )
          muscleGroupIds
  createMany exercisesMuscleGroupsToCreate
