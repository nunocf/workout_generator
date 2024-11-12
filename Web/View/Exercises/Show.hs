module Web.View.Exercises.Show where
import Web.View.Prelude

data ShowView = ShowView { exercise :: Exercise }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Exercise</h1>
        <p>{exercise}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Exercises" ExercisesAction
                            , breadcrumbText "Show Exercise"
                            ]