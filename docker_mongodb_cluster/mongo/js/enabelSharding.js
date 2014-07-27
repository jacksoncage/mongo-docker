db.runCommand( { enableSharding : "database" } );
sh.shardCollection( "database.testData", { _id: "hashed" } );