module Web.View.Exercises.New where

import Application.Helper.View qualified as ViewHelper
import Web.View.Prelude

data NewView = NewView
  { exerciseWithMuscleGroups :: ExerciseWithMuscleGroups,
    allMuscleGroups :: [MuscleGroup]
  }

instance View NewView where
  html NewView {..} =
    [hsx|
        {breadcrumb}
        <h1>New Exercise</h1>
        {ViewHelper.renderExerciseWithMuscleGroupsForm allMuscleGroups exerciseWithMuscleGroups}
    |]
    where
      breadcrumb =
        renderBreadcrumb
          [ breadcrumbLink "Exercises" ExercisesAction,
            breadcrumbText "New Exercise"
          ]
