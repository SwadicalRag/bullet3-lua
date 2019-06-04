local module = dofile("bin/bullet3.pure.min.lua")

module.init()

local collisionConfiguration = module.bindings.btDefaultCollisionConfiguration()
local dispatcher = module.bindings.btCollisionDispatcher(collisionConfiguration)
local overlappingPairCache = module.bindings.btDbvtBroadphase()
local solver = module.bindings.btSequentialImpulseConstraintSolver()
local dynamicsWorld = module.bindings.btDiscreteDynamicsWorld(dispatcher, overlappingPairCache, solver, collisionConfiguration)

dynamicsWorld:setGravity(module.bindings.btVector3(0, -10, 0))

local groundShape = module.bindings.btBoxShape(module.bindings.btVector3(50, 50, 50));

local groundTransform = module.bindings.btTransform();
groundTransform:setIdentity();
groundTransform:setOrigin(module.bindings.btVector3(0, -56, 0));

local bodies = {}
do
    local mass = 0;
    local localInertia = module.bindings.btVector3(0, 0, 0);
    local myMotionState = module.bindings.btDefaultMotionState(groundTransform);
    local rbInfo = module.bindings.btRigidBodyConstructionInfo(0, myMotionState, groundShape, localInertia);
    local body = module.bindings.btRigidBody(rbInfo);

    dynamicsWorld:addRigidBody(body);
    bodies[#bodies + 1] = body;
end

local boxShape = module.bindings.btBoxShape(module.bindings.btVector3(1, 1, 1));

local function resetPositions()
    local side = math.ceil(math.pow(50, 1/3));
    local i = 1;
    for x=0,side-1 do
        for y=0,side-1 do
            for z=0,side-1 do
                if (i == #bodies) then break end
                local body = bodies[i]; i = i + 1
                local origin = body:getWorldTransform():getOrigin();
                origin:setX((x - side/2)*(2.2 + math.random()));
                origin:setY(y * (3 + math.random()));
                origin:setZ((z - side/2)*(2.2 + math.random()) - side - 3);
                body:activate();
                local rotation = body:getWorldTransform():getRotation();
                rotation:setX(1);
                rotation:setY(0);
                rotation:setZ(0);
                rotation:setW(1);
            end
        end
    end
end

local function startUp()
    for i=1,50 do
        local startTransform = module.bindings.btTransform();
        startTransform:setIdentity();
        local mass = 1;
        local localInertia = module.bindings.btVector3(0, 0, 0);
        boxShape:calculateLocalInertia(mass, localInertia);

        local myMotionState = module.bindings.btDefaultMotionState(startTransform);
        local rbInfo = module.bindings.btRigidBodyConstructionInfo(mass, myMotionState, boxShape, localInertia);
        local body = module.bindings.btRigidBody(rbInfo);

        dynamicsWorld:addRigidBody(body);
        bodies[#bodies + 1] = body;
    end;

    resetPositions();
end

startUp()

local it = 0
local dt = 0.1
local lt = os.clock()
while true do
    it = it + 1
    dynamicsWorld:stepSimulation(dt, 2);

    if it >= 10 then
        print("TPS: ",10 / (os.clock() - lt))
        it = 0
        lt = os.clock()
    end
end
