CREATE FUNCTION set_updated_at_to_now() RETURNS TRIGGER AS $$BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;$$ language PLPGSQL;
CREATE TABLE muscle_groups (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    name TEXT NOT NULL
);
ALTER TABLE muscle_groups ADD CONSTRAINT muscle_groups_name_key UNIQUE(name);
CREATE INDEX muscle_groups_created_at_index ON muscle_groups (created_at);
CREATE TRIGGER update_muscle_groups_updated_at BEFORE UPDATE ON muscle_groups FOR EACH ROW EXECUTE FUNCTION set_updated_at_to_now();

CREATE TABLE exercises (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now() NOT NULL,
    name TEXT NOT NULL,
    body_group UUID NOT NULL
);
CREATE INDEX exercises_created_at_index ON exercises (created_at);
CREATE TRIGGER update_exercises_updated_at BEFORE UPDATE ON exercises FOR EACH ROW EXECUTE FUNCTION set_updated_at_to_now();

CREATE INDEX exercises_body_group_index ON exercises (body_group);
ALTER TABLE exercises ADD CONSTRAINT exercise_muscle_group_id FOREIGN KEY (body_group) REFERENCES body_groups (id) ON DELETE CASCADE;
