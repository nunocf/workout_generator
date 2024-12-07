module Web.View.Exercises.Index where

import Web.View.Prelude

data IndexView = IndexView
  { exercisesWithMuscleGroups :: [ExerciseWithMuscleGroups]
  }

instance View IndexView where
  html IndexView {..} =
    [hsx|
        {breadcrumb}

        <h1>Exercise list<a href={pathTo NewExerciseAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Exercise</th>
                        <th>Muscle Groups</th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody class="table-group-divider">{forEach exercisesWithMuscleGroups renderExercise}</tbody>
            </table>
            
        </div>
    |]
    where
      breadcrumb =
        renderBreadcrumb
          [ breadcrumbLink "Exercises" ExercisesAction
          ]

      renderExercise :: ExerciseWithMuscleGroups -> Html
      renderExercise (ExerciseWithMuscleGroups {exercise, muscleGroups}) =
        [hsx|
          <tr>
              <td><a href={ShowExerciseAction exercise.id}>{exercise.name}</a></td>
              <td class="d-flex gap-2">{forEach muscleGroups renderMuscleGroup}</td>
              <td><a href={EditExerciseAction exercise.id} class="text-muted">Edit</a></td>
              <td><a href={DeleteExerciseAction exercise.id} class="js-delete text-muted">Delete</a></td>
          </tr>
        |]

      renderMuscleGroup muscleGroup =
        [hsx|
          <a href={ShowMuscleGroupAction muscleGroup.id}>{muscleGroup.name}</a>
        |]
