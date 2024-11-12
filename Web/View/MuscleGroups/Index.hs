module Web.View.MuscleGroups.Index where
import Web.View.Prelude

data IndexView = IndexView { muscleGroups :: [MuscleGroup] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewMuscleGroupAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>MuscleGroup</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach muscleGroups renderMuscleGroup}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "MuscleGroups" MuscleGroupsAction
                ]

renderMuscleGroup :: MuscleGroup -> Html
renderMuscleGroup muscleGroup = [hsx|
    <tr>
        <td>{muscleGroup}</td>
        <td><a href={ShowMuscleGroupAction muscleGroup.id}>Show</a></td>
        <td><a href={EditMuscleGroupAction muscleGroup.id} class="text-muted">Edit</a></td>
        <td><a href={DeleteMuscleGroupAction muscleGroup.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]