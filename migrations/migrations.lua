return {
   run = function(db)
      require "migrations.001_initialization"(db)
   end
}
