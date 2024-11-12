module Web.View.Exercises.Edit where

import Web.View.Prelude

data EditView = EditView {exercise :: Exercise}

instance View EditView where
  html EditView {..} =
    [hsx|
        {breadcrumb}
        <h1>Edit Exercise</h1>
        {renderForm exercise}
    |]
    where
      breadcrumb =
        renderBreadcrumb
          [ breadcrumbLink "Exercises" ExercisesAction,
            breadcrumbText "Edit Exercise"
          ]

renderForm :: Exercise -> Html
renderForm exercise =
  formFor
    exercise
    [hsx|
    {(textField #name)}
    {(textField #muscleGroup)}
    {submitButton}

|]

