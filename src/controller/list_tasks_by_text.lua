-- Utils
local validators = require "src.validators.base_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

return check_input(
    {
        {validators.is_date},
        {validators.is_date},
        {validators.is_text, validators.max_length(100)}
    },
    use_db(function(db, start_date, end_date, text)
        -- To include the end_date one day is added
        end_date:adddays(1)

        local query = [[
            SELECT p.name as project, t.id, t.start_time, t.end_time, t.description
            FROM task as t
            LEFT JOIN project p ON p.id = t.project_id
            WHERE (
                t.start_time > date(?) AND t.start_time < date(?)
                OR t.end_time > date(?) AND t.end_time < date(?)
                OR t.start_time > date(?) AND t.end_time < date(?)
            )
            AND (
                t.description LIKE ?
                OR p.name LIKE ?
            )
            ORDER BY t.start_time
        ]]

        local query_stmt = db:prepare(query)
        query_stmt:bind_values(
            start_date:fmt("${iso}"), end_date:fmt("${iso}"),
            start_date:fmt("${iso}"), end_date:fmt("${iso}"),
            start_date:fmt("${iso}"), end_date:fmt("${iso}"),
            "%"..text.."%", "%"..text.."%"
        )

        local tasks = {}
        for row in query_stmt:nrows(query) do
            table.insert(tasks, {
                id=row.id,
                project=row.project,
                start_time=row.start_time,
                end_time=row.end_time,
                description=row.description
            })
        end

        return tasks, nil
    end)
)
