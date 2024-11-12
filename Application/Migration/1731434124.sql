ALTER TABLE exercises RENAME COLUMN muscle_group TO muscle_group_id;
DROP INDEX exercises_muscle_group_index;
ALTER TABLE exercises DROP CONSTRAINT exercise_muscle_group_id;
CREATE INDEX exercises_muscle_group_id_index ON exercises (muscle_group_id);
ALTER TABLE exercises ADD CONSTRAINT exercise_muscle_group_id_id FOREIGN KEY (muscle_group_id) REFERENCES muscle_groups (id) ON DELETE CASCADE;
