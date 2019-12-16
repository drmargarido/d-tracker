local date = require "date.date"

return function(db)
   db:exec(string.format([[
       INSERT INTO project (name) VALUES ('D-Tracker');
       INSERT INTO project (name) VALUES ('Arglan2');

       INSERT INTO task (project_id, description, start_time, end_time) 
       VALUES (
           1,
           'Building of the dependencies',
           '2019-11-17T22:15:04',
           '2019-11-17T23:25:04'
       );

       INSERT INTO task (project_id, description, start_time, end_time) 
       VALUES (
           1,
           'Defining Milestones',
           '2019-11-17T23:32:04',
           '2019-11-17T23:55:04'
       );

       INSERT INTO task (project_id, description, start_time, end_time) 
       VALUES (
           2,
           'Development of the particle engine',
           '2019-11-23T11:15:04',
           '2019-11-23T15:02:23'
       );

       INSERT INTO task (project_id, description, start_time, end_time) 
       VALUES (
           2,
           'Development of the highscores server',
           '%sT00:01:04',
           '%sT00:03:23'
       );

       INSERT INTO task (project_id, description, start_time) 
       VALUES (
           2,
           'Deploy for GNU/Linux',
           '%s'
       );
   ]], date():fmt("%F"), date():fmt("%F"), date():fmt("${iso}") ))
end
