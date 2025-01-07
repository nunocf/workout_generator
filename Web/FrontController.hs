module Web.FrontController where

-- Controller Imports

import IHP.LoginSupport.Middleware
import IHP.RouterPrelude
import Web.Controller.Exercises
import Web.Controller.MuscleGroups
import Web.Controller.Prelude
import Web.Controller.Sessions
import Web.Controller.Static
import Web.Controller.Users
import Web.View.Layout (defaultLayout)

instance FrontController WebApplication where
  controllers =
    [ startPage NewSessionAction,
      parseRoute @SessionsController,
      -- Generator Marker
      parseRoute @UsersController,
      parseRoute @ExercisesController,
      parseRoute @MuscleGroupsController
    ]

instance InitControllerContext WebApplication where
  initContext = do
    setLayout defaultLayout
    initAutoRefresh
    initAuthentication @User
