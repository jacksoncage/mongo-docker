rs.add('mongos1r2.mongo.dev.docker:27017');
cfg = rs.conf();
cfg.members[0].host = 'mongos1r1.mongo.dev.docker:27017';
rs.reconfig(cfg);