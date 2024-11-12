module Web.View.Exercises.New where

import Web.View.Prelude

data NewView = NewView
  { exercise :: Exercise,
    muscleGroups :: [MuscleGroup]
  }

instance CanSelect MuscleGroup where
  type SelectValue MuscleGroup = Id MuscleGroup
{- ORMOLU_DISABLE -}
  selectValue muscleGroup = muscleGroup.id
  selectLabel muscleGroup = muscleGroup.name
{- ORMOLU_ENABLE -}

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
    {(textField #name)}
    {(selectField #muscleGroup muscleGroups)}
    {submitButton}

|]

