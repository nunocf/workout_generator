module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController = WelcomeAction deriving (Eq, Show, Data)

data MuscleGroupsController
    = MuscleGroupsAction
    | NewMuscleGroupAction
    | ShowMuscleGroupAction { muscleGroupId :: !(Id MuscleGroup) }
    | CreateMuscleGroupAction
    | EditMuscleGroupAction { muscleGroupId :: !(Id MuscleGroup) }
    | UpdateMuscleGroupAction { muscleGroupId :: !(Id MuscleGroup) }
    | DeleteMuscleGroupAction { muscleGroupId :: !(Id MuscleGroup) }
    deriving (Eq, Show, Data)

data ExercisesController
    = ExercisesAction
    | NewExerciseAction
    | ShowExerciseAction { exerciseId :: !(Id Exercise) }
    | CreateExerciseAction
    | EditExerciseAction { exerciseId :: !(Id Exercise) }
    | UpdateExerciseAction { exerciseId :: !(Id Exercise) }
    | DeleteExerciseAction { exerciseId :: !(Id Exercise) }
    deriving (Eq, Show, Data)
