module Application.Helper.View where

import Generated.Types
import IHP.ViewPrelude
import Web.Types

-- Here you can add functions which are available in all your views
renderExerciseWithMuscleGroupsForm :: [MuscleGroup] -> ExerciseWithMuscleGroups -> Html
renderExerciseWithMuscleGroupsForm allMuscleGroups exerciseWithMuscleGroups =
  formFor
    exercise
    [hsx|
    {textField #name}
    {renderMuscleGroupCheckboxGroup allMuscleGroups muscleGroups}
    {submitButton}

|]
  where
    ExerciseWithMuscleGroups {exercise, muscleGroups} = exerciseWithMuscleGroups
    renderMuscleGroupCheckboxGroup :: [MuscleGroup] -> [MuscleGroup] -> Html
    renderMuscleGroupCheckboxGroup allMuscleGroups exerciseMuscleGroups =
      [hsx|
        <fieldset>
          <legend>Muscle Groups</legend>
          {forEachWithIndex allMuscleGroups (renderMuscleGroupCheckbox exerciseMuscleGroups)}
        </fieldset>
      |]

    renderMuscleGroupCheckbox :: [MuscleGroup] -> (Int, MuscleGroup) -> Html
    renderMuscleGroupCheckbox selectedMuscleGroups (index, muscleGroup) =
      let checkboxId = "checkbox-muscleGroup-" <> show index
          checked = muscleGroup `elem` selectedMuscleGroups
       in [hsx|
          <div class="form-check">
            <!-- Would be super nice if I could just use the checkboxField here -->
            <!-- {checkboxField #muscleGroupIds} {fieldName = "muscleGroupIds"} -->
            <input class="form-check-input" type="checkbox" id={checkboxId} name="muscleGroupIds" value={muscleGroup.id} checked={checked}>
            <label class="form-check-label" for={checkboxId}>{muscleGroup.name}</label>
          </div>
      |]
