module Web.View.MuscleGroups.Show where

import Web.View.Prelude

data ShowView = ShowView {muscleGroup :: MuscleGroup}

instance View ShowView where
  html ShowView {..} =
    [hsx|
        {breadcrumb}
        <h1>{muscleGroup.name}</h1>
        <p>{muscleGroup.createdAt |> timeAgo}</p>

    |]
    where
      breadcrumb =
        renderBreadcrumb
          [ breadcrumbLink "MuscleGroups" MuscleGroupsAction,
            breadcrumbText "Show MuscleGroup"
          ]
