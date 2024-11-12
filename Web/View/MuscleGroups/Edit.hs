module Web.View.MuscleGroups.Edit where
import Web.View.Prelude

data EditView = EditView { muscleGroup :: MuscleGroup }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit MuscleGroup</h1>
        {renderForm muscleGroup}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "MuscleGroups" MuscleGroupsAction
                , breadcrumbText "Edit MuscleGroup"
                ]

renderForm :: MuscleGroup -> Html
renderForm muscleGroup = formFor muscleGroup [hsx|
    {(textField #name)}
    {submitButton}

|]