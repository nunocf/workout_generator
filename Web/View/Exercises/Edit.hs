module Web.View.Exercises.Edit where

import Application.Helper.View qualified as ViewHelper
import Web.View.Prelude

data EditView = EditView
  { exerciseWithMuscleGroups :: ExerciseWithMuscleGroups,
    allMuscleGroups :: [MuscleGroup]
  }

instance View EditView where
  html EditView {..} =
    [hsx|
        {breadcrumb}
        <h1>Edit Exercise</h1>
        {ViewHelper.renderExerciseWithMuscleGroupsForm allMuscleGroups exerciseWithMuscleGroups}
    |]
    where
      breadcrumb =
        renderBreadcrumb
          [ breadcrumbLink "Exercises" ExercisesAction,
            breadcrumbText "Edit Exercise"
          ]
