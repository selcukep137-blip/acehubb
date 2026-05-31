-- [[ ACE HUB - PREMIUM V14 (OFFICIAL LITE EDITION) ]]
_G.AutoWin = false

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Clean and professional window layout without emojis or personal language
local Window = Rayfield:CreateWindow({
   Name = "ACE HUB",
   LoadingTitle = "ACE HUB",
   LoadingSubtitle = "Anti-AFK & FPS Booster Premium",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- [[ GAME SERVICES ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- 🛡️ BACKGROUND MODULE: ANTI-AFK SYSTEM (Prevents Idle Disconnections)
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

-- Destination Finder (Locates the nearest valid win zone)
local function getFirstWinTarget()
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    local closestTarget = nil
    local shortestDistance = math.huge

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("TouchTransmitter") then
            local name = v.Name:lower()
            if name:match("win") or name:match("door") or name:match("finish") or name:match("gate") or name:match("pad") then
                local actualPart = v:IsA("TouchTransmitter") and v.Parent or v
                if actualPart and actualPart:IsA("BasePart") then
                    local distance = (rootPart.Position - actualPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestTarget = actualPart
                    end
                end
            end
        end
    end
    return closestTarget
end

-- MASTER LOOP (Disables collisions automatically during Auto Win)
RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    if character and _G.AutoWin then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- OPTIMIZED TWEEN NAVIGATION SERVICE
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoWin then
            pcall(function()
                local character = LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                local target = getFirstWinTarget()
                
                if rootPart and target and character:FindFirstChildOfClass("Humanoid").Health > 0 then
                    local distance = (rootPart.Position - target.Position).Magnitude
                    local tweenTime = distance / 350 
                    
                    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = target.CFrame * CFrame.new(0, 1.5, 0)})
                    
                    rootPart.Velocity = Vector3.new(0,0,0)
                    tween:Play()
                    tween.Completed:Wait()
                    task.wait(0.05)
                end
            end)
        end
    end
end)

-- [[ UI TABS ]]
local MainTab = Window:CreateTab("Main Menu", 4483362458)

-- [[ MAIN MENU ELEMENTS ]]
MainTab:CreateSection("Automation & Performance")

-- 1. FIRST ITEM: AUTO WIN
MainTab:CreateToggle({
   Name = "Auto Win (Method 1)",
   CurrentValue = false,
   Flag = "AutoWinToggle",
   Callback = function(Value)
      _G.AutoWin = Value
      if Value then
          Rayfield:Notify({Title = "ACE HUB", Content = "Auto Win loop has been activated.", Duration = 2})
      end
   end,
})

-- 2. SECOND ITEM: FPS BOOSTER
MainTab:CreateButton({
   Name = "FPS Booster & Anti-Lag",
   Callback = function()
       pcall(function()
           for _, v in pairs(workspace:GetDescendants()) do
               if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Sparkles") or v:IsA("Smoke") or v:IsA("Fire") then
                   v.Enabled = false
               elseif v:IsA("PostEffect") then
                   v.Enabled = false
               end
           end
           Rayfield:Notify({Title = "ACE HUB", Content = "Visual effects disabled. Performance optimized.", Duration = 3})
       end)
   end,
})

Rayfield:Notify({
   Title = "ACE HUB",
   Content = "Script loaded successfully.",
   Duration = 4,
})

