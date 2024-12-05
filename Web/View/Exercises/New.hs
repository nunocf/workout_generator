module Web.View.Exercises.New where

import Web.View.Prelude

data NewView = NewView
  { exercise :: Exercise,
    muscleGroups :: [MuscleGroup]
  }

instance CanSelect MuscleGroup where
  type SelectValue MuscleGroup = Id MuscleGroup
  selectValue muscleGroup = muscleGroup.id
  selectLabel muscleGroup = muscleGroup.name

instance View NewView where
  html NewView {..} =
    [hsx|
        {breadcrumb}
        <h1>New Exercise</h1>
        {renderForm exercise muscleGroups}
    |]
    where
      breadcrumb =
        renderBreadcrumb
          [ breadcrumbLink "Exercises" ExercisesAction,
            breadcrumbText "New Exercise"
          ]

renderForm :: Exercise -> [MuscleGroup] -> Html
renderForm exercise muscleGroups =
  formFor
    exercise
    [hsx|
    {textField #name}
    {renderMuscleGroupCheckboxGroup muscleGroups}
    {submitButton}

|]
  where
    renderMuscleGroupCheckboxGroup :: [MuscleGroup] -> Html
    renderMuscleGroupCheckboxGroup muscleGroups =
      [hsx|
        <fieldset>
          <legend>Muscle Groups</legend>
          {forEachWithIndex muscleGroups renderMuscleGroupCheckbox}
        </fieldset>
      |]

    renderMuscleGroupCheckbox :: (Int, MuscleGroup) -> Html
    renderMuscleGroupCheckbox (index, muscleGroup) =
      let checkboxId = "checkbox-muscleGroup-" <> show index
       in [hsx|
          <div class="form-check">
            <input class="form-check-input" type="checkbox" id={checkboxId} value={muscleGroup.id}>
            <label class="form-check-label" for={checkboxId}>{muscleGroup.name}</label>
          </div>
      |]
