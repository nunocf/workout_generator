module Web.View.Exercises.Show where

import Web.View.Prelude

data ShowView = ShowView {exerciseWithMuscleGroups :: ExerciseWithMuscleGroups}

instance View ShowView where
  html ShowView {..} =
    [hsx|
        {breadcrumb}
        <h1>{exerciseWithMuscleGroups.exercise.name}</h1>
        <p>{forEach exerciseWithMuscleGroups.muscleGroups renderMuscleGroup}</p>

    |]
    where
      breadcrumb =
        renderBreadcrumb
          [ breadcrumbLink "Exercises" ExercisesAction,
            breadcrumbText "Show Exercise"
          ]
      renderMuscleGroup muscleGroup =
        [hsx|<li>{muscleGroup.name}</li>|]
