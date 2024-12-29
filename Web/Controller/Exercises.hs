module Web.Controller.Exercises where

import Application.Helper.Controller qualified as ControllerHelper
import Data.List qualified
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
    let exerciseWithMuscleGroups = newRecord @ExerciseWithMuscleGroups
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
            exercise <- updateRecord exercise
            exercisesMuscleGroups <-
              query @ExercisesMuscleGroup
                |> filterWhere (#exerciseId, exercise.id)
                |> fetch

            deleteRecords exercisesMuscleGroups

            setSuccessMessage "Exercise updated"
          redirectTo EditExerciseAction {..}
  action CreateExerciseAction = do
    allMuscleGroups <- query @MuscleGroup |> fetch
    let paramMuscleGroupIds = paramList @(Id MuscleGroup) "muscleGroupIds"
    let muscleGroups =
          Data.List.filter
            (\muscleGroup -> muscleGroup.id `elem` paramMuscleGroupIds)
            allMuscleGroups
    newRecord @Exercise
      |> buildExercise
      |> ifValid \case
        Left invalidExercise ->
          render
            NewView
              { exerciseWithMuscleGroups = ExerciseWithMuscleGroups invalidExercise muscleGroups,
                allMuscleGroups = allMuscleGroups
              }
        Right validExercise -> do
          withTransaction do
            createdExercise <- createRecord validExercise
            createExercisesMuscleGroupsAssocs createdExercise.id (paramList "muscleGroupIds")

            setSuccessMessage "Create exercise and muscle group associations"
    redirectTo ExercisesAction
  action DeleteExerciseAction {exerciseId} = do
    withTransaction do
      deleteRecordById exerciseId
      query @ExercisesMuscleGroup
        |> findManyBy #exerciseId exerciseId
        >>= deleteRecords

    setSuccessMessage "Exercise deleted"
    redirectTo ExercisesAction

buildExercise exercise =
  exercise
    |> fill @'["name"]
    |> validateField (#name) nonEmpty

createExercisesMuscleGroupsAssocs ::
  (?modelContext :: ModelContext) => Id Exercise -> [Id MuscleGroup] -> IO ()
createExercisesMuscleGroupsAssocs exerciseId muscleGroupIds = do
  mapM_
    ( \muscleGroupId ->
        newRecord @ExercisesMuscleGroup
          |> set #exerciseId exerciseId
          |> set #muscleGroupId muscleGroupId
          |> createRecord
    )
    muscleGroupIds
