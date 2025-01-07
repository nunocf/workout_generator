module Web.Types where

import Generated.Types
import IHP.LoginSupport.Types
import IHP.ModelSupport
import IHP.Prelude

data WebApplication = WebApplication deriving (Eq, Show)

data StaticController = WelcomeAction deriving (Eq, Show, Data)

data MuscleGroupsController
  = MuscleGroupsAction
  | NewMuscleGroupAction
  | ShowMuscleGroupAction {muscleGroupId :: !(Id MuscleGroup)}
  | CreateMuscleGroupAction
  | EditMuscleGroupAction {muscleGroupId :: !(Id MuscleGroup)}
  | UpdateMuscleGroupAction {muscleGroupId :: !(Id MuscleGroup)}
  | DeleteMuscleGroupAction {muscleGroupId :: !(Id MuscleGroup)}
  deriving (Eq, Show, Data)

data ExercisesController
  = ExercisesAction
  | NewExerciseAction
  | ShowExerciseAction {exerciseId :: !(Id Exercise)}
  | CreateExerciseAction
  | EditExerciseAction {exerciseId :: !(Id Exercise)}
  | UpdateExerciseAction {exerciseId :: !(Id Exercise)}
  | DeleteExerciseAction {exerciseId :: !(Id Exercise)}
  deriving (Eq, Show, Data)

data SessionsController
  = NewSessionAction
  | CreateSessionAction
  | DeleteSessionAction
  deriving (Eq, Show, Data)

data ExerciseWithMuscleGroups
  = ExerciseWithMuscleGroups
  { exercise :: !Exercise,
    muscleGroups :: ![MuscleGroup]
  }
  deriving (Show)

instance HasNewSessionUrl User where
  newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = User
