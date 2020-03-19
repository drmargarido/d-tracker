local list_projects = require "src.controller.list_projects"

return function(parser)
    parser
        :command("list-projects")
        :summary("Lists the projects available in the database")
        :action(function(args, name)
            local projects = list_projects()

            for _, project in ipairs(projects) do
                print(string.format("%d|%s", project.id, project.name))
            end
        end)
end
