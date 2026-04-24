-- For YOUR game only - Auto-play NPC/bot system
local npc = script.Parent
local humanoid = npc:WaitForChild("Humanoid")

-- Simple auto-walk NPC for YOUR game
function autoWalk()
    local waypoints = {
        Vector3.new(0, 0, 10),
        Vector3.new(10, 0, 0),
        Vector3.new(0, 0, -10),
        Vector3.new(-10, 0, 0)
    }
    
    local currentWaypoint = 1
    
    while true do
        humanoid:MoveTo(waypoints[currentWaypoint])
        humanoid.MoveToFinished:Wait()
        currentWaypoint = currentWaypoint % #waypoints + 1
        task.wait(1)
    end
end

autoWalk()
