ALTER TABLE exercises RENAME COLUMN body_group TO muscle_group;
DROP INDEX exercises_body_group_index;
ALTER TABLE exercises DROP CONSTRAINT exercise_muscle_group_id;
CREATE INDEX exercises_muscle_group_index ON exercises (muscle_group);
ALTER TABLE exercises ADD CONSTRAINT exercise_muscle_group_id FOREIGN KEY (muscle_group) REFERENCES muscle_groups (id) ON DELETE CASCADE;