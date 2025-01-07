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
    let paramMuscleGroupIds = paramList @(Id MuscleGroup) "muscleGroupIds"
    allMuscleGroups <- query @MuscleGroup |> fetch
    exerciseWithMuscleGroups <- ControllerHelper.fetchExerciseWithMuscleGroups exerciseId
    let muscleGroups = selectedMuscleGroups allMuscleGroups paramMuscleGroupIds
    exerciseWithMuscleGroups.exercise
      |> buildExercise
      |> ifValid \case
        Left invalidExercise ->
          render
            EditView
              { exerciseWithMuscleGroups = ExerciseWithMuscleGroups invalidExercise muscleGroups,
                allMuscleGroups = allMuscleGroups
              }
        Right validExercise -> do
          withTransaction do
            updateRecord validExercise
            query @ExercisesMuscleGroup
              |> filterWhere (#exerciseId, exerciseId)
              |> fetch
              >>= deleteRecords
            createExercisesMuscleGroupsAssocs exerciseId (paramList "muscleGroupIds")

            setSuccessMessage "Exercise updated"
          redirectTo EditExerciseAction {..}
  action CreateExerciseAction = do
    let paramMuscleGroupIds = paramList @(Id MuscleGroup) "muscleGroupIds"
    allMuscleGroups <- query @MuscleGroup |> fetch
    let muscleGroups = selectedMuscleGroups allMuscleGroups paramMuscleGroupIds
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
            createExercisesMuscleGroupsAssocs createdExercise.id paramMuscleGroupIds

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

selectedMuscleGroups :: [MuscleGroup] -> [Id MuscleGroup] -> [MuscleGroup]
selectedMuscleGroups allMuscleGroups muscleGroupIds =
  Data.List.filter
    (\muscleGroup -> muscleGroup.id `elem` muscleGroupIds)
    allMuscleGroups
