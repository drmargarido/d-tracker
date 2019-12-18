return {
    name = "DB initialization",
    execute = function(db)
        db:exec[[
            CREATE TABLE project (
                id INTEGER PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                CONSTRAINT p_name UNIQUE (name)
            );

            CREATE TABLE task (
                id INTEGER PRIMARY KEY,
                project_id INTEGER,
                start_time TEXT NOT NULL,
                end_time TEXT NULL,
                description TEXT NOT NULL,
                FOREIGN KEY(project_id) REFERENCES project(id)
            );

            CREATE TABLE migration (
                id INTEGER PRIMARY KEY,
                name VARCHAR(128) NOT NULL,
                CONSTRAINT m_name UNIQUE (name)
            );
        ]]
    end
}
