module Web.View.Exercises.New where
import Web.View.Prelude

data NewView = NewView { exercise :: Exercise }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Exercise</h1>
        {renderForm exercise}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Exercises" ExercisesAction
                , breadcrumbText "New Exercise"
                ]

renderForm :: Exercise -> Html
renderForm exercise = formFor exercise [hsx|
    {(textField #name)}
    {(textField #bodyGroup)}
    {submitButton}

|]