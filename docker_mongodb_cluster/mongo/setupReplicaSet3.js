rs.add('mongos3r2.mongo.dev.docker:27017')
cfg = rs.conf()
cfg.members[0].host = 'mongos3r1.mongo.dev.docker:27017'
rs.reconfig(cfg)