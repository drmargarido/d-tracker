-- Utils
local validators = require "src.validators.base_validators"

-- Decorators
local decorators = require "src.decorators"
local use_db = decorators.use_db
local check_input = decorators.check_input

return check_input(
    {
        {validators.is_date},
        {validators.is_date}
    },
    use_db(function(db, start_date, end_date)
        -- To include the end_date one day is added
        end_date:adddays(1)

        local query = string.format(
            [[
                SELECT p.name as project, t.id, t.start_time, t.end_time, t.description
                FROM task as t
                LEFT JOIN project p ON p.id = t.project_id
                WHERE t.start_time > date('%s') AND t.start_time < date('%s')
                OR t.end_time > date('%s') AND t.end_time < date('%s')
                OR t.start_time > date('%s') AND t.end_time < date('%s')
            ]],
            start_date:fmt("${iso}"), end_date:fmt("${iso}"),
            start_date:fmt("${iso}"), end_date:fmt("${iso}"),
            start_date:fmt("${iso}"), end_date:fmt("${iso}")
        )

        local tasks = {}
        for row in db:nrows(query) do
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
