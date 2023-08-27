--Theres no ANTISTAFF so don't come crying to me if you get banned.
getgenv().bpfarm = true

if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded()
end

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Character = lp.Character or lp.CharacterAdded:Wait()
lp.CharacterAdded:Connect(function()
    Character = lp.Character
end)
local ccam = game.Workspace.CurrentCamera

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")

if game.PlaceId == 3527629287 then
    local framework = ReplicatedStorage:WaitForChild("Framework")

    local lib = require(framework:WaitForChild("Library"))
    local lNetwork = lib.Network
    local lShared = lib.Shared
    local GUID = lib.Functions.GenerateUID()

    local function loaded() --Checks if the player loaded
        return lib.Loaded
    end

    repeat wait() until loaded()

    local ldeployButton = lib.GUI.Menu.Side

    local debrisAssets = game.Workspace:WaitForChild("__DEBRIS")
    local thingsAssets = game.Workspace:WaitForChild("__THINGS")
    local variableAssets = game.Workspace:WaitForChild("__VARIABLES")

    local mapCache = thingsAssets:WaitForChild("MapCache")
    local guns = debrisAssets:WaitForChild("Guns")
    local projectiles = debrisAssets:WaitForChild("Projectiles")

    local outOfBound = Vector3.new(60, 106, 4418)

    local variables = {
        bluescore = variableAssets:WaitForChild("BlueScore"),
        doublecredits = variableAssets:WaitForChild("DoubleCredits"),
        endgame = variableAssets:WaitForChild("EndGame"),
        mapname = variableAssets:WaitForChild("MapName"),
        redscore = variableAssets:WaitForChild("RedScore"),
        roundtype = variableAssets:WaitForChild("RoundType"),
        secondsremaining = variableAssets:WaitForChild("SecondsRemaining")
    }

    local function gameHappening() --Checks if the game is still ongoing (Depreciated, use readyToPlay()... It's better.)
        if variables.secondsremaining.Value > 0 then
            return true
        else
            return false
        end
    end

    local function roundType() --Get the round type (ex: "FFA", "TDM", etc)
        return lShared.getRoundType()
    end
    local function readyToPlay() --Checks if the game is ready
        if roundType():lower() == "intermission" or roundType():lower() == "voting" then
            return false
        else
            return true
        end
    end

    local function spawned() --Checks if the player entered the game
        local status = false
        if lp:FindFirstChild("__SPAWNED") then
            status = true
        end
        return status
    end

    local function fireProjectile()
        --lNetwork.Fire("New Projectile", 1, GUID, math.floor(game.Workspace.DistributedGameTime))
    end

    local function clearMap() --Deletes the map (at least most of it)
        local mapAssets = game.Workspace:WaitForChild("__MAP")
        for _, v in pairs(mapAssets:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") or v:IsA("WedgePart") or v:IsA("CornerWedgePart") then
                v:Destroy()
            end
        end
        if mapCache:FindFirstChild("Ignore") then
            mapCache.Ignore:Destroy()
        end
        for _, v in pairs(projectiles:GetChildren()) do
            if v:IsA("Part") then
                v:Destroy()
            end
        end
    end

    local function LEGACYisTeam(character) --Checks for the team indicator in a player's head (legacy)
        local cHead = character:WaitForChild("Head")
        if cHead:FindFirstChild("TeamIndicator") then
            return true
        else
            return false
        end
    end

    local function isTeam(p) --Checks for the team value in a player
        if roundType():lower() == "ffa" then
            return false
        elseif p.Team ~= lp.Team then
            return false
        else
            return true
        end
    end

    local previousTracking = nil
    local function LEGACYlookForEnemy() --Looks for a player that doesn't have a team indicator (Legacy)
        local cCharacter = nil
        local potentialCharacters = Players:GetPlayers()
        for _, p in ipairs(potentialCharacters) do
            if p ~= lp then
                if p ~= previousTracking then
                    if p:FindFirstChild("__SPAWNED") then
                        if game.Workspace:FindFirstChild(tostring(p.Name)) then
                            cCharacter = game.Workspace[tostring(p.Name)]
                            if not cCharacter:FindFirstChild("ForceField") then
                                if not isTeam(cCharacter) then
                                    print("Tracking "..tostring(p.name))
                                    previousTracking = p
                                    return cCharacter
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local function lookForEnemy()
        local cCharacter = nil
        local potentialCharacters = guns:GetChildren()
        for _, p in ipairs(potentialCharacters) do
            if p.Name ~= lp.Name then
                if Players:FindFirstChild(p.Name) then
                    local potentialPlr = Players:FindFirstChild(p.Name)
                    local cCharacter = game.Workspace[tostring(p.Name)]
                    if not isTeam(potentialPlr) then
                        if not cCharacter:FindFirstChild("ForceField") then
                            print("Tracking "..tostring(p.name))
                            previousTracking = p
                            return cCharacter
                        end
                    end
                end
            end
        end
    end

    local tracking = lookForEnemy()
    local rconnection = RunService.RenderStepped:Connect(function(delta)
        if getgenv().bpfarm == true then
            if spawned() then
                spawn(function()
                    clearMap()
                end)
                Character:MoveTo(outOfBound)
                if gameHappening() then
                    if tracking ~= nil then
                        if tracking.Parent ~= nil then
                            if tracking.Parent == game.Workspace then
                                if tracking:FindFirstChild("Hitbox") then
                                    local h = tracking.Hitbox
                                    ccam.CFrame = CFrame.lookAt(h.Position - Vector3.new(5, 0 ,0), h.Position, h.CFrame.UpVector)
                                    fireProjectile()
                                end
                            else
                                tracking = lookForEnemy()
                            end
                        else
                            tracking = lookForEnemy()
                        end
                    else
                        tracking = lookForEnemy()
                    end
                end
            end
        end
    end)
else
    warn("Wrong game!!!")
end
