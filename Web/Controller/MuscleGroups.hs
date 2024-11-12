module Web.Controller.MuscleGroups where

import Web.Controller.Prelude
import Web.View.MuscleGroups.Index
import Web.View.MuscleGroups.New
import Web.View.MuscleGroups.Edit
import Web.View.MuscleGroups.Show

instance Controller MuscleGroupsController where
    action MuscleGroupsAction = do
        muscleGroups <- query @MuscleGroup |> fetch
        render IndexView { .. }

    action NewMuscleGroupAction = do
        let muscleGroup = newRecord
        render NewView { .. }

    action ShowMuscleGroupAction { muscleGroupId } = do
        muscleGroup <- fetch muscleGroupId
        render ShowView { .. }

    action EditMuscleGroupAction { muscleGroupId } = do
        muscleGroup <- fetch muscleGroupId
        render EditView { .. }

    action UpdateMuscleGroupAction { muscleGroupId } = do
        muscleGroup <- fetch muscleGroupId
        muscleGroup
            |> buildMuscleGroup
            |> ifValid \case
                Left muscleGroup -> render EditView { .. }
                Right muscleGroup -> do
                    muscleGroup <- muscleGroup |> updateRecord
                    setSuccessMessage "MuscleGroup updated"
                    redirectTo EditMuscleGroupAction { .. }

    action CreateMuscleGroupAction = do
        let muscleGroup = newRecord @MuscleGroup
        muscleGroup
            |> buildMuscleGroup
            |> ifValid \case
                Left muscleGroup -> render NewView { .. } 
                Right muscleGroup -> do
                    muscleGroup <- muscleGroup |> createRecord
                    setSuccessMessage "MuscleGroup created"
                    redirectTo MuscleGroupsAction

    action DeleteMuscleGroupAction { muscleGroupId } = do
        muscleGroup <- fetch muscleGroupId
        deleteRecord muscleGroup
        setSuccessMessage "MuscleGroup deleted"
        redirectTo MuscleGroupsAction

buildMuscleGroup muscleGroup = muscleGroup
    |> fill @'["name"]
