return {
   run = function(db)
      require "src.migrations.001_initialization"(db)
   end
}
