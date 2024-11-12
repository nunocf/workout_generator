module Web.View.MuscleGroups.Show where
import Web.View.Prelude

data ShowView = ShowView { muscleGroup :: MuscleGroup }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show MuscleGroup</h1>
        <p>{muscleGroup}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "MuscleGroups" MuscleGroupsAction
                            , breadcrumbText "Show MuscleGroup"
                            ]