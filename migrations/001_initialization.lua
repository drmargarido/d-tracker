local sqlite3 = require "lsqlite3"

return function(dbname)
    local db = sqlite3.open(dbname)
    db:exec[[
        CREATE TABLE project (
            id INTEGER PRIMARY KEY,
            name VARCHAR(255)
        );

        CREATE TABLE task (
            id INTEGER PRIMARY KEY,
            project_id INTEGER,
            start_time TEXT,
            end_time TEXT,
            description TEXT,
            FOREIGN KEY(project_id) REFERENCES project(id)
        );
    ]]
end
