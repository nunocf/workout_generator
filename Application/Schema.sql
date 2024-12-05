CREATE FUNCTION set_updated_at_to_now() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language plpgsql;
-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE exercises (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    name TEXT NOT NULL
);
CREATE INDEX exercises_created_at_index ON exercises (created_at);
CREATE TRIGGER update_exercises_updated_at BEFORE UPDATE ON exercises FOR EACH ROW EXECUTE FUNCTION set_updated_at_to_now();
CREATE TABLE muscle_groups (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    name TEXT NOT NULL UNIQUE
);
CREATE INDEX muscle_groups_created_at_index ON muscle_groups (created_at);
CREATE TRIGGER update_muscle_groups_updated_at BEFORE UPDATE ON muscle_groups FOR EACH ROW EXECUTE FUNCTION set_updated_at_to_now();
