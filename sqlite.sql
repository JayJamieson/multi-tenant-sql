CREATE TABLE IF NOT EXISTS organization (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS user (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    email VARCHAR(255) NOT NULL,
    -- add your user attributes here
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS membership (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    organization_id INTEGER NOT NULL,
    invited_by_user_id INTEGER,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at TEXT NOT NULL DEFAULT (datetime('now')),

    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (invited_by_user_id) REFERENCES user(id),
    FOREIGN KEY (organization_id) REFERENCES organization(id)
);

CREATE TRIGGER update_users_updated_at
AFTER UPDATE ON user
BEGIN
    UPDATE user SET updated_at = datetime('now') WHERE id = OLD.id;
END;

CREATE TRIGGER update_organization_updated_at
AFTER UPDATE ON organization
BEGIN
    UPDATE organization SET updated_at = datetime('now') WHERE id = OLD.id;
END;

CREATE TRIGGER update_membership_updated_at
AFTER UPDATE ON membership
BEGIN
    UPDATE organization SET updated_at = datetime('now') WHERE id = OLD.id;
END;
