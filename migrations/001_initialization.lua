local sqlite3 = require "lsqlite3"

return function(dbname)
    local db = sqlite3.open(dbname)
    db:exec[[
        CREATE TABLE project (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            CONSTRAINT u_name UNIQUE (name)
        );

        CREATE TABLE task (
            id INTEGER PRIMARY KEY,
            project_id INTEGER,
            start_time TEXT NOT NULL,
            end_time TEXT NULL,
            description TEXT NOT NULL,
            FOREIGN KEY(project_id) REFERENCES project(id)
        );
    ]]
end
