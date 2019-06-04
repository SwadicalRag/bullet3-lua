local module = dofile("bin/bullet3.lua")

module.init()

local collisionConfiguration = module.bindings.btDefaultCollisionConfiguration()
local dispatcher = module.bindings.btCollisionDispatcher(collisionConfiguration)
local overlappingPairCache = module.bindings.btDbvtBroadphase()
local solver = module.bindings.btSequentialImpulseConstraintSolver()
local dynamicsWorld = module.bindings.btDiscreteDynamicsWorld(dispatcher, overlappingPairCache, solver, collisionConfiguration)

dynamicsWorld:setGravity(module.bindings.btVector3(0, -10, 0))
