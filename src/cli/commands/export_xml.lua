-- Controllers
local list_tasks = require "src.controller.list_tasks"

-- Exporters
local export_xml = require "src.exporter.xml"

-- Utils
local date = require "date.date"
local todate = require "src.utils".todate

return function(parser)
    local export_xml_parser = parser:command("export-xml")
    export_xml_parser:summary("Export tasks in a time range to a xml file")

    export_xml_parser
        :option("-p --path", "Path to the file where to save the xml")
        :count("0-1")

    export_xml_parser
        :option("-b --before", "Starting a number of days before today")
        :convert(tonumber)
        :count("0-1")

    export_xml_parser
        :option("-f --from", "From the given date")
        :convert(todate)
        :count("0-1")

    export_xml_parser
        :option("-t --to", "To the given date")
        :convert(todate)
        :count("0-1")

    export_xml_parser:action(function(args, name)
        local tasks, err
        if not args.before and (not args.from or not args.to) then
            print(export_xml_parser:get_usage())
            return
        end

        if args.before then
            local start_date = date():adddays(-args.before)
            tasks, err = list_tasks(start_date, date())
        end

        if args.from and args.to then
            tasks, err = list_tasks(args.from, args.to)
        end

        if err then
            print(err)
            return 1
        end

        if args.path then
            export_xml.write_xml_to_file(tasks, args.file)
        else
            print(export_xml.generate_xml(tasks))
        end
    end)
end
