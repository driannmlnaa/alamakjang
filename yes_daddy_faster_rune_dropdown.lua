-- YES DADDY FASTER
-- Full GUI + Rune Dropdown
-- Crystal logic and rune RemoteEvent flow preserved for the user's own Roblox game.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

local screenGui
local infoGuiDisplayed = false

local mainFrame
local crystalButton
local runeButton
local closeButton
local logoButton

local runePanel
local runeScroll

local lastPosition = UDim2.new(0.5, -105, 0.36, -65)
local resetCooldown = false
local runeRunning = false
local tableOpen = true
local runePanelOpen = false

--------------------------------------------------
-- CRYSTAL
--------------------------------------------------

local function showNotification()
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Try to Die detected",
            Text = "Adding 6 seconds cooldown to avoid anti-cheat...",
            Duration = 3
        })
    end)
end

--------------------------------------------------
-- RUNE
--------------------------------------------------

local Event = game:GetService("ReplicatedStorage").Remotes.CrystalDropRequest

local runes = {
    "Haste Rune",
    "Storm Rune",
    "Weight Rune",
    "Fortune Rune",
    "Detonation Rune",
    "Preservation Rune",
    "Warmth Rune",
    "Excavator Rune",
    "Colossus Rune"
}

local selectedRunes = {}

for _, rune in ipairs(runes) do
    selectedRunes[rune] = false
end

local function getSelectedCount()
    local count = 0
    for _, rune in ipairs(runes) do
        if selectedRunes[rune] then
            count += 1
        end
    end
    return count
end

local function startRune()
    if runeRunning then
        return
    end

    if getSelectedCount() == 0 then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Rune",
                Text = "Select at least one rune first.",
                Duration = 2
            })
        end)
        return
    end

    runeRunning = true

    task.spawn(function()
        while runeRunning do
            for _, rune in ipairs(runes) do
                if selectedRunes[rune] then
                    Event:FireServer(rune)
                end
            end
            task.wait()
        end
    end)
end

--------------------------------------------------
-- HELPERS
--------------------------------------------------

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function gradient(parent, colors)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colors[1]),
        ColorSequenceKeypoint.new(0.5, colors[2] or colors[1]),
        ColorSequenceKeypoint.new(1, colors[3] or colors[#colors])
    })
    g.Parent = parent
    return g
end

local function styleButton(button)
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 21

    button.BackgroundColor3 = Color3.fromRGB(105,70,210)

    corner(button, 20)
    stroke(button, Color3.fromRGB(255,255,255), 1.2, 0.2)
    gradient(button, {
        Color3.fromRGB(78,55,220),
        Color3.fromRGB(120,65,205),
        Color3.fromRGB(180,75,185)
    })
end

--------------------------------------------------
-- RUNE PANEL
--------------------------------------------------

local function refreshRuneButton()
    if runeButton then
        local n = getSelectedCount()
        runeButton.Text = n > 0 and ("RUNE (" .. n .. ")") or "RUNE"
    end
end

local function refreshChecks()
    if not runeScroll then
        return
    end

    for _, row in ipairs(runeScroll:GetChildren()) do
        if row:IsA("TextButton") and row:GetAttribute("RuneName") then
            local rune = row:GetAttribute("RuneName")
            local check = row:FindFirstChild("Check")

            if check then
                check.Text = selectedRunes[rune] and "✓" or ""
                check.BackgroundColor3 = selectedRunes[rune]
                    and Color3.fromRGB(120,70,220)
                    or Color3.fromRGB(55,48,75)
            end
        end
    end
end

local function createRunePanel()
    runePanel = Instance.new("Frame")
    runePanel.Name = "RunePanel"
    runePanel.Size = UDim2.new(0,235,0,340)
    runePanel.Position = UDim2.new(0.5,-117,0.5,-170)
    runePanel.BackgroundColor3 = Color3.fromRGB(48,40,72)
    runePanel.BorderSizePixel = 0
    runePanel.Visible = false
    runePanel.ZIndex = 50
    runePanel.Parent = screenGui

    corner(runePanel, 10)
    stroke(runePanel, Color3.fromRGB(220,205,255), 1.4, 0.05)
    gradient(runePanel, {
        Color3.fromRGB(58,48,95),
        Color3.fromRGB(66,45,88),
        Color3.fromRGB(82,48,78)
    })

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-50,0,35)
    title.Position = UDim2.new(0,12,0,4)
    title.BackgroundTransparency = 1
    title.Text = "SELECT RUNES"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 51
    title.Parent = runePanel

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0,30,0,30)
    close.Position = UDim2.new(1,-36,0,5)
    close.Text = "×"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 25
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.BackgroundTransparency = 1
    close.AutoButtonColor = false
    close.ZIndex = 52
    close.Parent = runePanel

    runeScroll = Instance.new("ScrollingFrame")
    runeScroll.Size = UDim2.new(1,-20,0,220)
    runeScroll.Position = UDim2.new(0,10,0,43)
    runeScroll.BackgroundColor3 = Color3.fromRGB(39,34,57)
    runeScroll.BackgroundTransparency = 0.15
    runeScroll.BorderSizePixel = 0
    runeScroll.ScrollBarThickness = 4
    runeScroll.ScrollBarImageColor3 = Color3.fromRGB(170,120,235)
    runeScroll.CanvasSize = UDim2.new(0,0,0,0)
    runeScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    runeScroll.ZIndex = 51
    runeScroll.Parent = runePanel
    corner(runeScroll,8)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = runeScroll

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0,7)
    padding.PaddingBottom = UDim.new(0,7)
    padding.Parent = runeScroll

    for i, rune in ipairs(runes) do
        local row = Instance.new("TextButton")
        row.Name = "Rune_" .. i
        row.Size = UDim2.new(1,-12,0,38)
        row.Text = ""
        row.BackgroundColor3 = Color3.fromRGB(58,51,78)
        row.BorderSizePixel = 0
        row.AutoButtonColor = false
        row:SetAttribute("RuneName", rune)
        row.ZIndex = 52
        row.Parent = runeScroll

        corner(row,10)
        stroke(row, Color3.fromRGB(180,160,220), 1, 0.55)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,-52,1,0)
        label.Position = UDim2.new(0,12,0,0)
        label.BackgroundTransparency = 1
        label.Text = rune
        label.TextColor3 = Color3.fromRGB(245,245,250)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 53
        label.Parent = row

        local check = Instance.new("TextLabel")
        check.Name = "Check"
        check.Size = UDim2.new(0,27,0,27)
        check.Position = UDim2.new(1,-35,0.5,-13)
        check.BackgroundColor3 = Color3.fromRGB(55,48,75)
        check.BorderSizePixel = 0
        check.Text = ""
        check.TextColor3 = Color3.fromRGB(255,255,255)
        check.Font = Enum.Font.GothamBold
        check.TextSize = 18
        check.ZIndex = 53
        check.Parent = row

        corner(check,8)
        stroke(check, Color3.fromRGB(220,205,255), 1, 0.25)

        row.MouseButton1Click:Connect(function()
            selectedRunes[rune] = not selectedRunes[rune]
            refreshChecks()
            refreshRuneButton()
        end)
    end

    local selectAll = Instance.new("TextButton")
    selectAll.Size = UDim2.new(0.46,0,0,40)
    selectAll.Position = UDim2.new(0.04,0,1,-49)
    selectAll.Text = "SELECT ALL"
    selectAll.Font = Enum.Font.GothamBold
    selectAll.TextSize = 12
    selectAll.TextColor3 = Color3.fromRGB(255,255,255)
    selectAll.BackgroundColor3 = Color3.fromRGB(90,65,170)
    selectAll.BorderSizePixel = 0
    selectAll.AutoButtonColor = false
    selectAll.ZIndex = 52
    selectAll.Parent = runePanel
    corner(selectAll,12)
    stroke(selectAll, Color3.fromRGB(220,205,255), 1, 0.2)

    local clear = Instance.new("TextButton")
    clear.Size = UDim2.new(0.46,0,0,40)
    clear.Position = UDim2.new(0.50,0,1,-49)
    clear.Text = "CLEAR"
    clear.Font = Enum.Font.GothamBold
    clear.TextSize = 12
    clear.TextColor3 = Color3.fromRGB(255,255,255)
    clear.BackgroundColor3 = Color3.fromRGB(100,55,105)
    clear.BorderSizePixel = 0
    clear.AutoButtonColor = false
    clear.ZIndex = 52
    clear.Parent = runePanel
    corner(clear,12)
    stroke(clear, Color3.fromRGB(220,205,255), 1, 0.2)

    selectAll.MouseButton1Click:Connect(function()
        for _, rune in ipairs(runes) do
            selectedRunes[rune] = true
        end
        refreshChecks()
        refreshRuneButton()
    end)

    clear.MouseButton1Click:Connect(function()
        for _, rune in ipairs(runes) do
            selectedRunes[rune] = false
        end
        refreshChecks()
        refreshRuneButton()
    end)

    close.MouseButton1Click:Connect(function()
        runePanelOpen = false
        runePanel.Visible = false
    end)
end

--------------------------------------------------
-- CREATE GUI
--------------------------------------------------

local function createGui()
    if screenGui then
        screenGui:Destroy()
    end

    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ResetButtonGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainTable"
    mainFrame.Size = UDim2.new(0,210,0,142)
    mainFrame.Position = lastPosition
    mainFrame.BackgroundColor3 = Color3.fromRGB(48,40,72)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    corner(mainFrame,8)
    stroke(mainFrame, Color3.fromRGB(220,205,255),1.5,0.05)
    gradient(mainFrame,{
        Color3.fromRGB(58,48,95),
        Color3.fromRGB(66,45,88),
        Color3.fromRGB(82,48,78)
    })

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-45,0,30)
    title.Position = UDim2.new(0,12,0,3)
    title.BackgroundTransparency = 1
    title.Text = "YES DADDY FASTER"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 17
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = mainFrame

    closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0,28,0,28)
    closeButton.Position = UDim2.new(1,-33,0,4)
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 24
    closeButton.TextColor3 = Color3.fromRGB(255,255,255)
    closeButton.BackgroundTransparency = 1
    closeButton.AutoButtonColor = false
    closeButton.Parent = mainFrame

    crystalButton = Instance.new("TextButton")
    crystalButton.Size = UDim2.new(0,190,0,45)
    crystalButton.Position = UDim2.new(0,10,0,35)
    crystalButton.Text = "CRYSTAL"
    crystalButton.Parent = mainFrame
    styleButton(crystalButton)

    runeButton = Instance.new("TextButton")
    runeButton.Size = UDim2.new(0,190,0,45)
    runeButton.Position = UDim2.new(0,10,0,86)
    runeButton.Text = "RUNE"
    runeButton.Parent = mainFrame
    styleButton(runeButton)

    logoButton = Instance.new("TextButton")
    logoButton.Size = UDim2.new(0,48,0,48)
    logoButton.Position = lastPosition
    logoButton.Text = "D"
    logoButton.Font = Enum.Font.GothamBold
    logoButton.TextSize = 27
    logoButton.TextColor3 = Color3.fromRGB(255,255,255)
    logoButton.BackgroundColor3 = Color3.fromRGB(85,60,190)
    logoButton.BorderSizePixel = 0
    logoButton.AutoButtonColor = false
    logoButton.Visible = false
    logoButton.Parent = screenGui
    gradient(logoButton,{
        Color3.fromRGB(78,55,220),
        Color3.fromRGB(180,75,185)
    })
    stroke(logoButton,Color3.fromRGB(230,220,255),1.5,0.1)
    corner(logoButton,12)

    --------------------------------------------------
    -- DRAG MAIN
    --------------------------------------------------

    local dragging, dragStart, startPos = false, nil, nil

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            local newPosition = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            mainFrame.Position = newPosition
            lastPosition = newPosition
        end
    end)

    --------------------------------------------------
    -- DRAG LOGO
    --------------------------------------------------

    local logoDragging, logoDragStart, logoStartPos = false, nil, nil

    logoButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            logoDragging = true
            logoDragStart = input.Position
            logoStartPos = logoButton.Position
        end
    end)

    logoButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            logoDragging = false
            lastPosition = logoButton.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if logoDragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - logoDragStart
            local newPosition = UDim2.new(
                logoStartPos.X.Scale,
                logoStartPos.X.Offset + delta.X,
                logoStartPos.Y.Scale,
                logoStartPos.Y.Offset + delta.Y
            )
            logoButton.Position = newPosition
            lastPosition = newPosition
        end
    end)

    closeButton.MouseButton1Click:Connect(function()
        tableOpen = false
        mainFrame.Visible = false
        if runePanel then
            runePanel.Visible = false
            runePanelOpen = false
        end
        logoButton.Position = lastPosition
        logoButton.Visible = true
    end)

    logoButton.MouseButton1Click:Connect(function()
        tableOpen = true
        logoButton.Visible = false
        mainFrame.Position = lastPosition
        mainFrame.Visible = true
    end)

    crystalButton.MouseButton1Click:Connect(function()
        if resetCooldown then
            return
        end

        resetCooldown = true
        player.Character:BreakJoints()
        wait(6)
        resetCooldown = false
    end)

    runeButton.MouseButton1Click:Connect(function()
        if not runePanel then
            createRunePanel()
        end

        runePanelOpen = not runePanelOpen
        runePanel.Visible = runePanelOpen
    end)

    createRunePanel()
    screenGui.Enabled = false
end

--------------------------------------------------
-- INFO GUI
--------------------------------------------------

local function createInfoGui()
    if infoGuiDisplayed or UserInputService.TouchEnabled then
        createGui()
        screenGui.Enabled = true
        return
    end

    infoGuiDisplayed = true

    local infoGui = Instance.new("ScreenGui")
    infoGui.Name = "InfoGui"
    infoGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,350,0,200)
    frame.Position = UDim2.new(0.5,-175,0.5,-100)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    frame.Parent = infoGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1,0,0.4,0)
    textLabel.Position = UDim2.new(0,0,0.2,0)
    textLabel.Text = "Press F to toggle"
    textLabel.TextColor3 = Color3.fromRGB(255,255,255)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 28
    textLabel.BackgroundTransparency = 1
    textLabel.Parent = frame

    local okButton = Instance.new("TextButton")
    okButton.Size = UDim2.new(0.6,0,0.3,0)
    okButton.Position = UDim2.new(0.2,0,0.55,0)
    okButton.Text = "OK"
    okButton.BackgroundColor3 = Color3.fromRGB(0,122,255)
    okButton.TextColor3 = Color3.fromRGB(255,255,255)
    okButton.Font = Enum.Font.GothamBold
    okButton.TextSize = 22
    okButton.Parent = frame

    corner(okButton,10)

    okButton.MouseButton1Click:Connect(function()
        infoGui:Destroy()
        createGui()
        screenGui.Enabled = true
    end)
end

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

local function toggleUI()
    if screenGui then
        screenGui.Enabled = not screenGui.Enabled
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        toggleUI()
    end
end)

--------------------------------------------------
-- CHARACTER ADDED
--------------------------------------------------

player.CharacterAdded:Connect(function()
    if player:FindFirstChild("PlayerGui") then
        local old = player.PlayerGui:FindFirstChild("ResetButtonGui")
        if old then
            old:Destroy()
        end
    end

    createInfoGui()
end)

--------------------------------------------------
-- NOTIFICATION
--------------------------------------------------

if game.PlaceId == 5901548022 then
    showNotification()
end

--------------------------------------------------
-- START
--------------------------------------------------

createInfoGui()
