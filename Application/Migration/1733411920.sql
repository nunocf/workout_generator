CREATE TABLE exercises_muscle_groups (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    exercise_id UUID NOT NULL,
    muscle_group_id UUID NOT NULL
);
CREATE INDEX exercises_muscle_groups_exercise_id_index ON exercises_muscle_groups (exercise_id);
CREATE INDEX exercises_muscle_groups_muscle_group_id_index ON exercises_muscle_groups (muscle_group_id);
ALTER TABLE exercises_muscle_groups ADD CONSTRAINT exercises_muscle_groups_ref_exercise_id FOREIGN KEY (exercise_id) REFERENCES exercises (id) ON DELETE NO ACTION;
ALTER TABLE exercises_muscle_groups ADD CONSTRAINT exercises_muscle_groups_ref_muscle_group_id FOREIGN KEY (muscle_group_id) REFERENCES muscle_groups (id) ON DELETE NO ACTION;
