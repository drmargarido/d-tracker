-- Controllers
local list_today_tasks = require "src.controller.list_today_tasks"

-- Exporters
local export_xml = require "src.exporter.xml"

return function(parser)
    local export_xml_parser = parser:command("export-today-xml")
    export_xml_parser:summary("Export today tasks to a xml file")

    export_xml_parser
        :option("-p --path", "Path to the file where to save the xml")
        :count("0-1")

    export_xml_parser:action(function(args, name)
        local today_tasks = list_today_tasks()
        if args.path then
            export_xml.write_xml_to_file(today_tasks, args.path)
        else
            print(export_xml.generate_xml(today_tasks))
        end
    end)
end
