CREATE TYPE muscle_group AS ENUM ('quads', 'hamstrings', 'calves');
ALTER TABLE exercises ADD COLUMN muscle_groups muscle_group[] DEFAULT '{}' NOT NULL;
DROP TABLE exercises_muscle_groups;
DROP TABLE muscle_groups;
ALTER TABLE muscle_groups DROP CONSTRAINT muscle_groups_name_key;
DROP INDEX muscle_groups_created_at_index;
DROP TRIGGER update_muscle_groups_updated_at ON muscle_groups;

