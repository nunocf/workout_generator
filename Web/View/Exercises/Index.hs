module Web.View.Exercises.Index where
import Web.View.Prelude

data IndexView = IndexView { exercises :: [Exercise] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewExerciseAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Exercise</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach exercises renderExercise}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Exercises" ExercisesAction
                ]

renderExercise :: Exercise -> Html
renderExercise exercise = [hsx|
    <tr>
        <td>{exercise}</td>
        <td><a href={ShowExerciseAction exercise.id}>Show</a></td>
        <td><a href={EditExerciseAction exercise.id} class="text-muted">Edit</a></td>
        <td><a href={DeleteExerciseAction exercise.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]