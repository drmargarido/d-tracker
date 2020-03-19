-- Controllers
local stop_task = require "src.controller.stop_task"

return function(parser)
    parser
        :command("stop-in-progress")
        :summary("Stop the current task in progress")
        :action(function(args, name)
            local _, err = stop_task()
            if err then
                print(err)
            end

            return
        end)
end
