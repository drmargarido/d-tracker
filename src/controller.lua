return {
    autocomplete_task = function(description)
        return {}
    end,
    add_task = function(description, project)
        return 0
    end,
    edit_task = function(task_id, field, new_value)
    end,
    delete_task = function(task_id)
    end,
    get_task_in_progress = function()
        return nil
    end,
    list_tasks = function(start_date, end_date)
        return {
            {
                id=1,
                project="D-Tracker",
                start_time="2019-11-17T11:09:25",
                end_time="2019-11-17T12:09:25",
                description="Creating build setup"
            },
            {
                id=2,
                project="D-Tracker",
                start_time="2019-11-17T13:09:25",
                end_time="2019-11-17T14:29:25",
                description="Requirements"
            },
            {
                id=3,
                project="D-Tracker",
                start_time="2019-11-17T15:29:25",
                end_time="2019-11-17T16:09:25",
                description="Development"
            },
            {
                id=4,
                project="D-Tracker",
                start_time="2019-11-17T17:09:25",
                end_time="2019-11-17T17:32:25",
                description="Testing"
            }
        }
    end
}