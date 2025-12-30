-- =====================================================
-- MENU UPDATED WITH ESP ON/OFF TOGGLE
-- =====================================================

function CreateESPSection()
    -- ESP SECTION
    local espFrame = Instance.new("Frame")
    espFrame.Name = "ESP_Section"
    espFrame.Size = UDim2.new(0.9, 0, 0, 60)
    espFrame.Position = UDim2.new(0.05, 0, 0.5, 0)  -- Vị trí giữa menu
    espFrame.BackgroundColor3 = Color3.fromRGB(50, 30, 30)  -- Nền đỏ đậm
    espFrame.BackgroundTransparency = 0.2
    espFrame.Parent = MenuFrame
    
    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 8)
    espCorner.Parent = espFrame
    
    -- ESP Title
    local espTitle = Instance.new("TextLabel")
    espTitle.Text = "ESP HIGHLIGHT"
    espTitle.Size = UDim2.new(1, 0, 0, 20)
    espTitle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    espTitle.TextColor3 = Color3.white
    espTitle.Font = Enum.Font.GothamBold
    espTitle.TextSize = 12
    espTitle.Parent = espFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = espTitle
    
    -- ESP ON/OFF Button (Lớn - Chính)
    local espToggleBtn = Instance.new("TextButton")
    espToggleBtn.Name = "ESPToggle"
    espToggleBtn.Text = "ESP: OFF"
    espToggleBtn.Size = UDim2.new(0.45, 0, 0.55, 0)
    espToggleBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
    espToggleBtn.Font = Enum.Font.GothamBold
    espToggleBtn.TextSize = 12
    espToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)  -- Mặc định OFF
    espToggleBtn.TextColor3 = Color3.white
    espToggleBtn.Parent = espFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = espToggleBtn
    
    -- Team Check Toggle (nút phụ)
    local teamToggleBtn = Instance.new("TextButton")
    teamToggleBtn.Name = "TeamToggle"
    teamToggleBtn.Text = "TEAM"
    teamToggleBtn.Size = UDim2.new(0.20, 0, 0.55, 0)
    teamToggleBtn.Position = UDim2.new(0.55, 0, 0.35, 0)
    teamToggleBtn.Font = Enum.Font.Gotham
    teamToggleBtn.TextSize = 11
    teamToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    teamToggleBtn.TextColor3 = Color3.white
    teamToggleBtn.Parent = espFrame
    
    local teamCorner = Instance.new("UICorner")
    teamCorner.CornerRadius = UDim.new(0, 6)
    teamCorner.Parent = teamToggleBtn
    
    -- FOV Adjust (nếu đang ở Mode Silent)
    local fovAdjustBtn = Instance.new("TextButton")
    fovAdjustBtn.Name = "FOVAdjust"
    fovAdjustBtn.Text = "FOV " .. Config.FOVSize
    fovAdjustBtn.Size = UDim2.new(0.20, 0, 0.55, 0)
    fovAdjustBtn.Position = UDim2.new(0.80, 0, 0.35, 0)
    fovAdjustBtn.Font = Enum.Font.Gotham
    fovAdjustBtn.TextSize = 11
    fovAdjustBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    fovAdjustBtn.TextColor3 = Color3.white
    fovAdjustBtn.Parent = espFrame
    fovAdjustBtn.Visible = Config.Mode == 1  -- Chỉ hiện khi Silent Aim
    
    local fovCorner = Instance.new("UICorner")
    fovCorner.CornerRadius = UDim.new(0, 6)
    fovCorner.Parent = fovAdjustBtn
    
    -- ====== ESP TOGGLE CLICK HANDLER ======
    espToggleBtn.MouseButton1Click:Connect(function()
        Config.ESPEnabled = not Config.ESPEnabled
        ToggleESP(Config.ESPEnabled)
        
        -- Update button appearance
        if Config.ESPEnabled then
            espToggleBtn.Text = "ESP: ON"
            espToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)  -- Đỏ
            teamToggleBtn.Text = "TEAM"
        else
            espToggleBtn.Text = "ESP: OFF"
            espToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)   -- Xám
            teamToggleBtn.Text = "TEAM"
        end
    end)
    
    -- ====== TEAM TOGGLE CLICK HANDLER ======
    teamToggleBtn.MouseButton1Click:Connect(function()
        Config.TeamCheck = not Config.TeamCheck
        
        -- Update team check in ESP
        if Config.TeamCheck then
            teamToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)  -- Xanh
            teamToggleBtn.Text = "TEAM ✓"
        else
            teamToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)    -- Xám
            teamToggleBtn.Text = "TEAM"
        end
        
        -- Update existing highlights
        if Config.ESPEnabled then
            for player, highlight in pairs(PlayerHighlights) do
                if highlight and highlight.Enabled then
                    if Config.TeamCheck and IsSameTeamESP(player) then
                        highlight.FillColor = Config.ESPTeamColor
                        highlight.OutlineColor = Config.ESPTeamColor
                    else
                        highlight.FillColor = Config.ESPColor
                        highlight.OutlineColor = Config.ESPColor
                    end
                end
            end
        end
        
        print("[ESP] Team check: " .. (Config.TeamCheck and "ENABLED" or "DISABLED"))
    end)
    
    -- ====== FOV ADJUST CLICK HANDLER ======
    fovAdjustBtn.MouseButton1Click:Connect(function()
        Config.FOVSize = Config.FOVSize + 20
        if Config.FOVSize > 200 then
            Config.FOVSize = 40  -- Reset về nhỏ nhất
        end
        fovAdjustBtn.Text = "FOV " .. Config.FOVSize
        UpdateFOVCircle()
        print("[FOV] Size: " .. Config.FOVSize)
    end)
    
    -- Update ESP button state khi mở menu
    spawn(function()
        wait(0.1)
        if Config.ESPEnabled then
            espToggleBtn.Text = "ESP: ON"
            espToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        else
            espToggleBtn.Text = "ESP: OFF"
            espToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
        
        if Config.TeamCheck then
            teamToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
            teamToggleBtn.Text = "TEAM ✓"
        else
            teamToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            teamToggleBtn.Text = "TEAM"
        end
    end)
end

function UpdateMainToggle()
    local mainToggle = MenuFrame:FindFirstChild("MainToggle")
    if not mainToggle then return end
    
    if Config.Mode == 1 then
        -- SILENT AIM MODE
        if Config.FOVEnabled then
            mainToggle.Text = "SILENT: ON"
            mainToggle.BackgroundColor3 = Color3.fromRGB(50, 180, 100)  -- Xanh lá
        else
            mainToggle.Text = "SILENT: OFF"
            mainToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)   -- Đỏ
        end
    else
        -- AIMLOCK MODE
        if Config.AimEnabled then
            mainToggle.Text = "AIMLOCK: ON"
            mainToggle.BackgroundColor3 = Color3.fromRGB(50, 120, 180)  -- Xanh dương
        else
            mainToggle.Text = "AIMLOCK: OFF"
            mainToggle.BackgroundColor3 = Color3.fromRGB(180, 50, 50)   -- Đỏ
        end
    end
end

-- =====================================================
-- UPDATE MAIN TOGGLE FUNCTION
-- =====================================================

function ToggleMainFeature()
    if Config.Mode == 1 then
        -- SILENT AIM TOGGLE
        Config.FOVEnabled = not Config.FOVEnabled
        UpdateFOVCircle()
        
        if Config.FOVEnabled then
            print("[Silent Aim] FOV Circle Enabled")
        else
            print("[Silent Aim] FOV Circle Disabled")
        end
    else
        -- AIMLOCK TOGGLE
        Config.AimEnabled = not Config.AimEnabled
        
        if Config.AimEnabled then
            CurrentTarget = GetClosestTorsoPlayer()
            print("[AimLock] Activated")
            print("Target: " .. (CurrentTarget and CurrentTarget.Name or "None"))
        else
            CurrentTarget = nil
            print("[AimLock] Deactivated")
        end
    end
    
    UpdateMainToggle()
end

-- =====================================================
-- UPDATE CREATE MAINToggles FUNCTION
-- =====================================================

function CreateMainToggles()
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.9, 0, 0, 60)
    toggleFrame.Position = UDim2.new(0.05, 0, 0.33, 0)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = MenuFrame
    
    -- Main Toggle (Lớn - Chính)
    local mainToggle = Instance.new("TextButton")
    mainToggle.Name = "MainToggle"
    mainToggle.Size = UDim2.new(0.6, 0, 0.7, 0)
    mainToggle.Position = UDim2.new(0.2, 0, 0.15, 0)
    mainToggle.Font = Enum.Font.GothamBold
    mainToggle.TextSize = 13
    mainToggle.Parent = toggleFrame
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainToggle
    
    -- Info label
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Text = Config.Mode == 1 and "F8=Toggles Silent" or "F8=Toggles Aimlock"
    infoLabel.Size = UDim2.new(1, 0, 0, 15)
    infoLabel.Position = UDim2.new(0, 0, 0.8, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 10
    infoLabel.Parent = toggleFrame
    
    -- HotKeys label
    local hotkeyLabel = Instance.new("TextLabel")
    hotkeyLabel.Text = "HOTKEYS: F8=Main  F9=ESP  F10=Menu"
    hotkeyLabel.Size = UDim2.new(1, 0, 0, 15)
    hotkeyLabel.Position = UDim2.new(0, 0, 0.95, 0)
    hotkeyLabel.BackgroundTransparency = 1
    hotkeyLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    hotkeyLabel.Font = Enum.Font.Gotham
    hotkeyLabel.TextSize = 10
    hotkeyLabel.Parent = toggleFrame
    
    -- CLICK HANDLER
    mainToggle.MouseButton1Click:Connect(function()
        ToggleMainFeature()
    end)
    
    UpdateMainToggle()
end

-- =====================================================
-- HOTKEYS FOR ALL FEATURES
-- =====================================================

UserInputService.InputBegan:Connect(function(input)
    -- TOGGLE MENU (RightControl)
    if input.KeyCode == Config.MenuKey then
        if MenuFrame then
            MenuFrame.Visible = not MenuFrame.Visible
        end
    end
    
    -- HOTKEY F8: Toggle Main Feature
    if input.KeyCode == Enum.KeyCode.F8 then
        ToggleMainFeature()
    end
    
    -- HOTKEY F9: Toggle ESP
    if input.KeyCode == Enum.KeyCode.F9 then
        Config.ESPEnabled = not Config.ESPEnabled
        ToggleESP(Config.ESPEnabled)
        
        -- Update menu button nếu menu đang mở
        if MenuFrame and MenuFrame.Visible then
            local espToggle = MenuFrame:FindFirstChild("ESPToggle")
            if espToggle then
                if Config.ESPEnabled then
                    espToggle.Text = "ESP: ON"
                    espToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                else
                    espToggle.Text = "ESP: OFF"
                    espToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                end
            end
        end
        
        print("[HOTKEY] ESP: " .. (Config.ESPEnabled and "ON" or "OFF"))
    end
    
    -- HOTKEY F10: Toggle Team Check
    if input.KeyCode == Enum.KeyCode.F10 then
        Config.TeamCheck = not Config.TeamCheck
        
        if MenuFrame and MenuFrame.Visible then
            local teamToggle = MenuFrame:FindFirstChild("TeamToggle")
            if teamToggle then
                if Config.TeamCheck then
                    teamToggle.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
                    teamToggle.Text = "TEAM ✓"
                else
                    teamToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    teamToggle.Text = "TEAM"
                end
            end
        end
        
        print("[HOTKEY] Team Check: " .. (Config.TeamCheck and "ON" or "OFF"))
    end
end)

-- =====================================================
-- INITIALIZATION
-- =====================================================

function InitializeAllFeatures()
    -- Khởi tạo FOV circle
    if Drawing then
        CreateFOVCircle()
    else
        warn("Drawing library not available - FOV circle disabled")
    end
    
    -- Khởi tạo ESP connections
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function()
                wait(0.5)
                if Config.ESPEnabled then
                    CreatePlayerHighlight(player)
                end
            end)
            
            player.CharacterRemoving:Connect(function()
                RemovePlayerHighlight(player)
            end)
            
            -- Tạo ngay nếu đã có character
            if player.Character and Config.ESPEnabled then
                CreatePlayerHighlight(player)
            end
        end
    end
    
    -- Main update loop
    RunService.RenderStepped:Connect(function()
        -- Aimlock update
        if Config.AimEnabled and CurrentTarget then
            AimAtTorso()
        end
        
        -- Cập nhật target
        if Config.Mode == 2 and Config.AimEnabled then
            if not CurrentTarget or not IsValidDaHoodPlayer(CurrentTarget) then
                CurrentTarget = GetClosestTorsoPlayer()
            end
        end
        
        -- ESP update
        if Config.ESPEnabled then
            for player, highlight in pairs(PlayerHighlights) do
                if player.Parent then
                    UpdatePlayerHighlight(player)
                else
                    RemovePlayerHighlight(player)
                end
            end
        end
    end)
    
    -- Tạo menu
    MenuFrame = CreateMenu()
    
    print("===========================================")
    print("DAHOOD AIM SUITE LOADED SUCCESSFULLY")
    print("===========================================")
    print("FEATURES:")
    print("1. SILENT AIM (Mode 1) - F8 to toggle")
    print("2. AIMLOCK (Mode 2) - F8 to toggle")
    print("3. ESP HIGHLIGHT (Red) - F9 to toggle")
    print("4. TEAM CHECK - F10 to toggle")
    print("")
    print("MENU: RightControl to open/close")
    print("===========================================")
end

-- Chờ game load xong
wait(3)
InitializeAllFeatures()
