CREATE TABLE IF NOT EXISTS organization (
    id BIGSERIAL NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- using users for table name compared to SQLite and MySQL as user is a reserved word in Postgres
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    -- add your user attributes here
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS membership (
    id BIGSERIAL NOT NULL,
    user_id BIGINT,
    organization_id BIGINT NOT NULL,
    invited_by_user_id BIGINT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (invited_by_user_id) REFERENCES users(id),
    FOREIGN KEY (organization_id) REFERENCES organization(id),
    PRIMARY KEY (id)
);

-- Add the suppress redundant updates trigger to prevent unnecessary updates
-- z prefix is used to ensure this runs first
CREATE TRIGGER z_suppress_redundant_updates
BEFORE UPDATE ON organization
FOR EACH ROW
EXECUTE FUNCTION suppress_redundant_updates_trigger();

CREATE TRIGGER z_suppress_redundant_updates
BEFORE UPDATE ON membership
FOR EACH ROW
EXECUTE FUNCTION suppress_redundant_updates_trigger();

CREATE TRIGGER z_suppress_redundant_updates
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION suppress_redundant_updates_trigger();

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER zz_before_update_users
BEFORE UPDATE ON organization
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER zz_before_update_users
BEFORE UPDATE ON membership
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER zz_before_update_users
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
