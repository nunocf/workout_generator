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
    let exerciseWithMuscleGroups =
          ExerciseWithMuscleGroups
            { exercise = newRecord,
              muscleGroups = []
            }

    allMuscleGroups <- query @MuscleGroup |> fetch

    render NewView {..}
  action ShowExerciseAction {exerciseId} = do
    exerciseWithMuscleGroups <- ControllerHelper.fetchExerciseWithMuscleGroups exerciseId
    render ShowView {..}
  action EditExerciseAction {exerciseId} = do
    exerciseWithMuscleGroups <- ControllerHelper.fetchExerciseWithMuscleGroups exerciseId
    allMuscleGroups <- query @MuscleGroup |> fetch
    render EditView {..}
  action UpdateExerciseAction {exerciseId} = do
    exerciseWithMuscleGroups <- ControllerHelper.fetchExerciseWithMuscleGroups exerciseId
    allMuscleGroups <- query @MuscleGroup |> fetch
    let paramMuscleGroupIds = paramList @(Id MuscleGroup) "muscleGroupIds"
    exerciseWithMuscleGroups.exercise
      |> ifValid \case
        Left exercise -> render EditView {..}
        Right exercise -> do
          withTransaction do
            exercise <- exercise |> updateRecord
            exercisesMuscleGroups <-
              query @ExercisesMuscleGroup
                |> filterWhere (#exerciseId, exercise.id)
                |> fetch

            deleteRecords exercisesMuscleGroups

            exerciseMuscleGroups <- createExerciseMuscleGroups exercise paramMuscleGroupIds
            setSuccessMessage "Exercise updated"
          redirectTo EditExerciseAction {..}
  action CreateExerciseAction = do
    allMuscleGroups <- query @MuscleGroup |> fetch
    let paramMuscleGroupIds = paramList @(Id MuscleGroup) "muscleGroupIds"
    newRecord @Exercise
      |> buildExercise
      |> ifValid \case
        Left exercise ->
          render
            NewView
              { exerciseWithMuscleGroups = ExerciseWithMuscleGroups {exercise, muscleGroups = []},
                allMuscleGroups
              }
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
  createMany exercisesMuscleGroupsToCreate
  where
    exercisesMuscleGroupsToCreate =
      map
        ( \muscleGroupId ->
            newRecord @ExercisesMuscleGroup
              |> set #exerciseId (get #id exercise)
              |> set #muscleGroupId muscleGroupId
        )
        muscleGroupIds
