module Web.View.Exercises.Show where

import Web.View.Prelude

data ShowView = ShowView {exercise :: Include "muscleGroup" Exercise}

instance View ShowView where
  html ShowView {..} =
    [hsx|
        {breadcrumb}
        <h1>{exercise.name}</h1>
        <p>{exercise.muscleGroup.name}</p>

    |]
    where
      breadcrumb =
        renderBreadcrumb
          [ breadcrumbLink "Exercises" ExercisesAction,
            breadcrumbText "Show Exercise"
          ]
