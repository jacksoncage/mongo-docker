db.runCommand( { enableSharding : "database" } );
sh.shardCollection( "database.stats", { _id: "hashed" } );