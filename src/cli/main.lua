-- Database
local migrations = require "src.migrations.migrations"

-- Arguments parsing
local argparse = require "argparse.argparse"
local parser = argparse(
    "d-tracker-cli",
    "Command line interface to interact with the d-tracker"
)

-- Ensure database exist and is updated
migrations()

-- Register commands
require "src.cli.commands.list_today_tasks"(parser)
require "src.cli.commands.list_tasks"(parser)
require "src.cli.commands.list_projects"(parser)
require "src.cli.commands.delete_task"(parser)
require "src.cli.commands.add_task"(parser)
require "src.cli.commands.edit_task_time"(parser)
require "src.cli.commands.edit_task_description"(parser)
require "src.cli.commands.edit_task_project"(parser)
require "src.cli.commands.export_today_xml"(parser)
require "src.cli.commands.export_xml"(parser)
require "src.cli.commands.stop_in_progress"(parser)

-- Parse commands
parser:parse()
return 0
