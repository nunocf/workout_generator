module Web.View.MuscleGroups.New where
import Web.View.Prelude

data NewView = NewView { muscleGroup :: MuscleGroup }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New MuscleGroup</h1>
        {renderForm muscleGroup}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "MuscleGroups" MuscleGroupsAction
                , breadcrumbText "New MuscleGroup"
                ]

renderForm :: MuscleGroup -> Html
renderForm muscleGroup = formFor muscleGroup [hsx|
    {(textField #name)}
    {submitButton}

|]