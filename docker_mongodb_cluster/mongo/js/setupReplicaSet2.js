rs.add('mongos2r2.mongo.dev.docker:27017')
cfg = rs.conf()
cfg.members[0].host = 'mongos2r1.mongo.dev.docker:27017'
rs.reconfig(cfg)