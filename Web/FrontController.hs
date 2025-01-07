module Web.FrontController where

import IHP.RouterPrelude
-- Controller Imports
import Web.Controller.Exercises
import Web.Controller.MuscleGroups
import Web.Controller.Prelude
import Web.Controller.Static
import Web.View.Layout (defaultLayout)

instance FrontController WebApplication where
  controllers =
    [ startPage ExercisesAction,
      -- Generator Marker
      parseRoute @ExercisesController,
      parseRoute @MuscleGroupsController
    ]

instance InitControllerContext WebApplication where
  initContext = do
    setLayout defaultLayout
    initAutoRefresh
