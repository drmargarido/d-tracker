-- Controllers
local list_today_tasks = require "src.controller.list_today_tasks"

-- Exporters
local export_csv = require "src.exporter.csv"

return function(parser)
    local export_csv_parser = parser:command("export-today-csv")
    export_csv_parser:summary("Export today tasks to a csv file")

    export_csv_parser
        :option("-p --path", "Path to the file where to save the csv")
        :count("0-1")

    export_csv_parser:action(function(args, name)
        local today_tasks = list_today_tasks()
        if args.path then
            export_csv.write_xml_to_file(today_tasks, args.file)
        else
            print(export_csv.generate_csv(today_tasks))
        end
    end)
end
