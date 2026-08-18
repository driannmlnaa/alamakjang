local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local screenGui
local mainTable
local crystalButton
local runeButton
local takeAllButton
local closeButton
local logoD

local runeSelection
local runeClose

local lastPosition = UDim2.new(0.5, -95, 0.36, -65)

local resetCooldown = false
local runeRunning = false

--==================================================
-- RUNE LIST
--==================================================

local runes = {
    {
        display = "Haste",
        remote = "Haste Rune"
    },
    {
        display = "Storm",
        remote = "Storm Rune"
    },
    {
        display = "Weight",
        remote = "Weight Rune"
    },
    {
        display = "Fortune",
        remote = "Fortune Rune"
    },
    {
        display = "Detonation",
        remote = "Detonation Rune"
    },
    {
        display = "Preservation",
        remote = "Preservation Rune"
    },
    {
        display = "Warmth",
        remote = "Warmth Rune"
    },
    {
        display = "Excavator",
        remote = "Excavator Rune"
    },
    {
        display = "Colossus",
        remote = "Colossus Rune"
    }
}

--==================================================
-- RUNE SELECTION STATE
--==================================================

local selectedRunes = {
    ["Haste Rune"] = false,
    ["Storm Rune"] = false,
    ["Weight Rune"] = false,
    ["Fortune Rune"] = false,
    ["Detonation Rune"] = false,
    ["Preservation Rune"] = false,
    ["Warmth Rune"] = false,
    ["Excavator Rune"] = false,
    ["Colossus Rune"] = false
}

local runeButtons = {}

--==================================================
-- REMOTE
--==================================================

local runeEvent = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("CrystalDropRequest")


--==================================================
-- AUTO COLLECT
--==================================================

local AutoCollectEvent = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("AutoCollectRequest")

local DROP_FOLDER_NAME = "Drops"
local COLLECT_RANGE = 15

local autoCollectRunning = false
local requestedDrops = {}

local function getDropPosition(drop)
    if drop:IsA("BasePart") then
        return drop.Position
    end

    if drop:IsA("Model") then
        if drop.PrimaryPart then
            return drop.PrimaryPart.Position
        end

        local part = drop:FindFirstChildWhichIsA("BasePart")
        if part then
            return part.Position
        end
    end

    return nil
end

local function collectAllDrops()
    if autoCollectRunning then
        return
    end

    autoCollectRunning = true

    local dropFolder = Workspace:FindFirstChild(DROP_FOLDER_NAME)

    if not dropFolder then
        autoCollectRunning = false
        return
    end

    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")

    if not hrp then
        autoCollectRunning = false
        return
    end

    for _, drop in ipairs(dropFolder:GetChildren()) do
        if drop.Parent and not requestedDrops[drop] then
            local dropPosition = getDropPosition(drop)

            if dropPosition then
                local distance = (hrp.Position - dropPosition).Magnitude

                if distance <= COLLECT_RANGE then
                    requestedDrops[drop] = true
                    AutoCollectEvent:FireServer(drop)
                    task.wait(0.21)
                end
            end
        end
    end

    autoCollectRunning = false
end

local function trackDrop(drop)
    drop.AncestryChanged:Connect(function(_, parent)
        if not parent then
            requestedDrops[drop] = nil
        end
    end)
end

local dropFolder = Workspace:FindFirstChild(DROP_FOLDER_NAME)

if dropFolder then
    for _, drop in ipairs(dropFolder:GetChildren()) do
        trackDrop(drop)
    end

    dropFolder.ChildAdded:Connect(function(drop)
        trackDrop(drop)
    end)
end

--==================================================
-- NOTIFICATION
--==================================================

local function showAntiCheatNotification()

    pcall(function()

        StarterGui:SetCore("SendNotification", {
            Title = "Try to Die detected",
            Text = "Adding 6 seconds cooldown to avoid anti-cheat...",
            Duration = 3
        })

    end)

end

--==================================================
-- RUN SELECTED RUNES
--==================================================

local function runSelectedRunes()

    if runeRunning then
        return
    end

    runeRunning = true

    task.spawn(function()

        while true do

            if not runeRunning then
                break
            end

            if selectedRunes["Haste Rune"] then
                runeEvent:FireServer("Haste Rune")
            end

            if selectedRunes["Storm Rune"] then
                runeEvent:FireServer("Storm Rune")
            end

            if selectedRunes["Weight Rune"] then
                runeEvent:FireServer("Weight Rune")
            end

            if selectedRunes["Fortune Rune"] then
                runeEvent:FireServer("Fortune Rune")
            end

            if selectedRunes["Detonation Rune"] then
                runeEvent:FireServer("Detonation Rune")
            end

            if selectedRunes["Preservation Rune"] then
                runeEvent:FireServer("Preservation Rune")
            end

            if selectedRunes["Warmth Rune"] then
                runeEvent:FireServer("Warmth Rune")
            end

            if selectedRunes["Excavator Rune"] then
                runeEvent:FireServer("Excavator Rune")
            end

            if selectedRunes["Colossus Rune"] then
                runeEvent:FireServer("Colossus Rune")
            end

            task.wait(0)

        end

    end)

end

--==================================================
-- MAIN BUTTON STYLE
--==================================================

local function styleButton(button)

    button.BackgroundColor3 =
        Color3.fromRGB(78, 55, 110)

    button.BorderSizePixel = 0
    button.AutoButtonColor = false

    button.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    button.Font =
        Enum.Font.GothamBold

    button.TextSize = 14

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 9)

    corner.Parent =
        button

    local stroke =
        Instance.new("UIStroke")

    stroke.Color =
        Color3.fromRGB(220, 205, 255)

    stroke.Thickness = 1
    stroke.Transparency = 0.25

    stroke.Parent =
        button

    local gradient =
        Instance.new("UIGradient")

    gradient.Color =
        ColorSequence.new({

            ColorSequenceKeypoint.new(
                0,
                Color3.fromRGB(65, 48, 100)
            ),

            ColorSequenceKeypoint.new(
                0.5,
                Color3.fromRGB(85, 55, 105)
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(105, 60, 100)
            )

        })

    gradient.Rotation = 35
    gradient.Parent = button

end

--==================================================
-- DRAG SYSTEM
--==================================================

local function makeDraggable(frame, positionChanged)

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    frame.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1

            or input.UserInputType ==
            Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()

                if input.UserInputState ==
                    Enum.UserInputState.End then

                    dragging = false

                end

            end)

        end

    end)

    frame.InputChanged:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement

            or input.UserInputType ==
            Enum.UserInputType.Touch then

            dragInput = input

        end

    end)

    UserInputService.InputChanged:Connect(function(input)

        if not dragging then
            return
        end

        if input ~= dragInput then
            return
        end

        local delta =
            input.Position - dragStart

        local newPosition = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )

        frame.Position = newPosition

        if positionChanged then
            positionChanged(newPosition)
        end

    end)

end

--==================================================
-- UPDATE RUNE BUTTON
-- ONLY BACKGROUND CHANGES
-- TEXT DOES NOT CHANGE
--==================================================

local function updateRuneButton(remoteName)

    local button =
        runeButtons[remoteName]

    if not button then
        return
    end

    if selectedRunes[remoteName] then

        -- SELECTED
        button.BackgroundColor3 =
            Color3.fromRGB(125, 82, 205)

    else

        -- NOT SELECTED
        button.BackgroundColor3 =
            Color3.fromRGB(55, 49, 78)

    end

    -- TEXT ALWAYS STAYS THE SAME
    button.TextColor3 =
        Color3.fromRGB(210, 207, 225)

end

--==================================================
-- CREATE RUNE SELECTION
--==================================================

local function createRuneSelection()

    runeSelection =
        Instance.new("Frame")

    runeSelection.Name =
        "RuneSelection"

    -- SMALLER CARD
    runeSelection.Size =
        UDim2.new(0, 190, 0, 145)

    runeSelection.Position =
        lastPosition

    runeSelection.BackgroundColor3 =
        Color3.fromRGB(29, 24, 46)

    runeSelection.BorderSizePixel = 0
    runeSelection.Visible = false
    runeSelection.Parent = screenGui

    --==================================================
    -- CARD CORNER
    --==================================================

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 11)

    corner.Parent =
        runeSelection

    --==================================================
    -- CARD STROKE
    --==================================================

    local stroke =
        Instance.new("UIStroke")

    stroke.Color =
        Color3.fromRGB(220, 205, 255)

    stroke.Thickness = 1.1
    stroke.Transparency = 0.08

    stroke.Parent =
        runeSelection

    --==================================================
    -- CARD GRADIENT
    --==================================================

    local gradient =
        Instance.new("UIGradient")

    gradient.Color =
        ColorSequence.new({

            ColorSequenceKeypoint.new(
                0,
                Color3.fromRGB(48, 40, 78)
            ),

            ColorSequenceKeypoint.new(
                0.5,
                Color3.fromRGB(58, 42, 76)
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(72, 43, 70)
            )

        })

    gradient.Rotation = 35
    gradient.Parent = runeSelection

    --==================================================
    -- TITLE
    --==================================================

    local title =
        Instance.new("TextLabel")

    title.Name =
        "Title"

    title.Size =
        UDim2.new(1, -40, 0, 23)

    title.Position =
        UDim2.new(0, 8, 0, 2)

    title.BackgroundTransparency = 1

    title.Text =
        "SELECT RUNES"

    title.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    title.Font =
        Enum.Font.GothamBold

    title.TextSize = 11

    title.TextXAlignment =
        Enum.TextXAlignment.Left

    title.Parent =
        runeSelection

    --==================================================
    -- CLOSE
    --==================================================

    runeClose =
        Instance.new("TextButton")

    runeClose.Name =
        "CloseButton"

    runeClose.Size =
        UDim2.new(0, 22, 0, 22)

    runeClose.Position =
        UDim2.new(1, -27, 0, 1)

    runeClose.BackgroundTransparency = 1

    runeClose.Text = "×"

    runeClose.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    runeClose.Font =
        Enum.Font.GothamBold

    runeClose.TextSize = 18

    runeClose.AutoButtonColor = false

    runeClose.Parent =
        runeSelection

    --==================================================
    -- SELECTION BACKGROUND
    --==================================================

    local selectionBackground =
        Instance.new("Frame")

    selectionBackground.Name =
        "SelectionBackground"

    -- SMALLER SELECTION AREA
    selectionBackground.Size =
        UDim2.new(1, -12, 0, 92)

    selectionBackground.Position =
        UDim2.new(0, 6, 0, 27)

    selectionBackground.BackgroundColor3 =
        Color3.fromRGB(39, 34, 60)

    selectionBackground.BorderSizePixel = 0
    selectionBackground.Parent = runeSelection

    local selectionCorner =
        Instance.new("UICorner")

    selectionCorner.CornerRadius =
        UDim.new(0, 7)

    selectionCorner.Parent =
        selectionBackground

    --==================================================
    -- 3 X 3 GRID
    --==================================================

    local grid =
        Instance.new("UIGridLayout")

    grid.CellSize =
        UDim2.new(0, 47, 0, 21)

    grid.CellPadding =
        UDim2.new(0, 3, 0, 3)

    grid.FillDirection =
        Enum.FillDirection.Horizontal

    grid.FillDirectionMaxCells =
        3

    grid.SortOrder =
        Enum.SortOrder.LayoutOrder

    grid.HorizontalAlignment =
        Enum.HorizontalAlignment.Center

    grid.VerticalAlignment =
        Enum.VerticalAlignment.Center

    grid.Parent =
        selectionBackground

    runeButtons = {}

    --==================================================
    -- RUNE BUTTONS
    --==================================================

    for index, rune in ipairs(runes) do

        local button =
            Instance.new("TextButton")

        button.Name =
            rune.display

        button.Size =
            UDim2.new(0, 47, 0, 21)

        button.BackgroundColor3 =
            Color3.fromRGB(55, 49, 78)

        button.BorderSizePixel = 0
        button.AutoButtonColor = false

        button.Text =
            rune.display

        -- TEXT NEVER CHANGES COLOR
        button.TextColor3 =
            Color3.fromRGB(210, 207, 225)

        button.Font =
            Enum.Font.GothamMedium

        button.TextSize = 7
        button.TextWrapped = true

        button.TextXAlignment =
            Enum.TextXAlignment.Center

        button.TextYAlignment =
            Enum.TextYAlignment.Center

        button.LayoutOrder =
            index

        button.Parent =
            selectionBackground

        --==================================================
        -- BUTTON CORNER
        --==================================================

        local buttonCorner =
            Instance.new("UICorner")

        buttonCorner.CornerRadius =
            UDim.new(0, 5)

        buttonCorner.Parent =
            button

        --==================================================
        -- BUTTON STROKE
        --==================================================

        local buttonStroke =
            Instance.new("UIStroke")

        buttonStroke.Name =
            "ButtonStroke"

        buttonStroke.Color =
            Color3.fromRGB(105, 93, 130)

        buttonStroke.Thickness = 0.7
        buttonStroke.Transparency = 0.4

        buttonStroke.Parent =
            button

        --==================================================
        -- CLICK
        --==================================================

        button.MouseButton1Click:Connect(function()

            selectedRunes[rune.remote] =
                not selectedRunes[rune.remote]

            updateRuneButton(rune.remote)

        end)

        runeButtons[rune.remote] =
            button

    end

    --==================================================
    -- ACTION FRAME
    --==================================================

    local actionFrame =
        Instance.new("Frame")

    actionFrame.Name =
        "ActionFrame"

    actionFrame.Size =
        UDim2.new(1, -12, 0, 20)

    actionFrame.Position =
        UDim2.new(0, 6, 0, 122)

    actionFrame.BackgroundTransparency = 1

    actionFrame.Parent =
        runeSelection

    --==================================================
    -- SELECT ALL
    --==================================================

    local selectAll =
        Instance.new("TextButton")

    selectAll.Name =
        "SelectAll"

    selectAll.Size =
        UDim2.new(0.48, 0, 1, 0)

    selectAll.Position =
        UDim2.new(0, 0, 0, 0)

    selectAll.Text =
        "SELECT ALL"

    selectAll.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    selectAll.Font =
        Enum.Font.GothamBold

    selectAll.TextSize = 7

    selectAll.BackgroundColor3 =
        Color3.fromRGB(88, 62, 155)

    selectAll.BorderSizePixel = 0
    selectAll.AutoButtonColor = false

    selectAll.Parent =
        actionFrame

    local selectCorner =
        Instance.new("UICorner")

    selectCorner.CornerRadius =
        UDim.new(0, 5)

    selectCorner.Parent =
        selectAll

    --==================================================
    -- RUN
    --==================================================

    local runButton =
        Instance.new("TextButton")

    runButton.Name =
        "Run"

    runButton.Size =
        UDim2.new(0.48, 0, 1, 0)

    runButton.Position =
        UDim2.new(0.52, 0, 0, 0)

    runButton.Text =
        "RUN"

    runButton.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    runButton.Font =
        Enum.Font.GothamBold

    runButton.TextSize = 7

    runButton.BackgroundColor3 =
        Color3.fromRGB(105, 70, 175)

    runButton.BorderSizePixel = 0
    runButton.AutoButtonColor = false

    runButton.Parent =
        actionFrame

    local runCorner =
        Instance.new("UICorner")

    runCorner.CornerRadius =
        UDim.new(0, 5)

    runCorner.Parent =
        runButton

    --==================================================
    -- SELECT ALL ACTION
    --==================================================

    selectAll.MouseButton1Click:Connect(function()

        for _, rune in ipairs(runes) do

            selectedRunes[rune.remote] = true

            updateRuneButton(rune.remote)

        end

    end)

    --==================================================
    -- RUN ACTION
    --==================================================

    runButton.MouseButton1Click:Connect(function()

        runSelectedRunes()

    end)

    --==================================================
    -- CLOSE
    --==================================================

    runeClose.MouseButton1Click:Connect(function()

        runeSelection.Visible = false

        mainTable.Visible = true

        mainTable.Position =
            lastPosition

    end)

    --==================================================
    -- DRAG
    --==================================================

    makeDraggable(
        runeSelection,

        function(newPosition)

            lastPosition =
                newPosition

        end
    )

end

--==================================================
-- MAIN GUI
--==================================================

local function createMainGui()

    if screenGui then
        screenGui:Destroy()
    end

    screenGui =
        Instance.new("ScreenGui")

    screenGui.Name =
        "DRIANLOVEMALTE"

    screenGui.ResetOnSpawn = false

    screenGui.ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling

    screenGui.Parent =
        player:WaitForChild("PlayerGui")

    --==================================================
    -- MAIN TABLE
    --==================================================

    mainTable =
        Instance.new("Frame")

    mainTable.Name =
        "MainTable"

    mainTable.Size =
        UDim2.new(0, 190, 0, 175)

    mainTable.Position =
        lastPosition

    mainTable.BackgroundColor3 =
        Color3.fromRGB(29, 24, 46)

    mainTable.BorderSizePixel = 0
    mainTable.Parent = screenGui

    local tableCorner =
        Instance.new("UICorner")

    tableCorner.CornerRadius =
        UDim.new(0, 12)

    tableCorner.Parent =
        mainTable

    local tableStroke =
        Instance.new("UIStroke")

    tableStroke.Color =
        Color3.fromRGB(220, 205, 255)

    tableStroke.Thickness = 1.2
    tableStroke.Transparency = 0.08

    tableStroke.Parent =
        mainTable

    local tableGradient =
        Instance.new("UIGradient")

    tableGradient.Color =
        ColorSequence.new({

            ColorSequenceKeypoint.new(
                0,
                Color3.fromRGB(48, 40, 78)
            ),

            ColorSequenceKeypoint.new(
                0.5,
                Color3.fromRGB(58, 42, 76)
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(72, 43, 70)
            )

        })

    tableGradient.Rotation = 35
    tableGradient.Parent = mainTable

    --==================================================
    -- TITLE
    --==================================================

    local title =
        Instance.new("TextLabel")

    title.Name =
        "Title"

    title.Size =
        UDim2.new(1, -42, 0, 27)

    title.Position =
        UDim2.new(0, 10, 0, 3)

    title.BackgroundTransparency = 1

    title.Text =
        "DRIANLOVEMALTE"

    title.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    title.Font =
        Enum.Font.GothamBold

    title.TextSize = 14

    title.TextXAlignment =
        Enum.TextXAlignment.Left

    title.Parent =
        mainTable

    --==================================================
    -- CLOSE
    --==================================================

    closeButton =
        Instance.new("TextButton")

    closeButton.Name =
        "CloseButton"

    closeButton.Size =
        UDim2.new(0, 26, 0, 26)

    closeButton.Position =
        UDim2.new(1, -30, 0, 3)

    closeButton.Text = "×"

    closeButton.Font =
        Enum.Font.GothamBold

    closeButton.TextSize = 21

    closeButton.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    closeButton.BackgroundTransparency = 1
    closeButton.AutoButtonColor = false

    closeButton.Parent =
        mainTable

    --==================================================
    -- CRYSTAL
    --==================================================

    crystalButton =
        Instance.new("TextButton")

    crystalButton.Name =
        "CrystalButton"

    crystalButton.Size =
        UDim2.new(0, 170, 0, 40)

    crystalButton.Position =
        UDim2.new(0, 10, 0, 32)

    crystalButton.Text =
        "CRYSTAL"

    crystalButton.Parent =
        mainTable

    styleButton(crystalButton)

    --==================================================
    -- RUNE
    --==================================================

    runeButton =
        Instance.new("TextButton")

    runeButton.Name =
        "RuneButton"

    runeButton.Size =
        UDim2.new(0, 170, 0, 40)

    runeButton.Position =
        UDim2.new(0, 10, 0, 78)

    runeButton.Text =
        "RUNE"

    runeButton.Parent =
        mainTable

    styleButton(runeButton)

    --==================================================
    -- TAKE ALL
    --==================================================

    takeAllButton =
        Instance.new("TextButton")

    takeAllButton.Name =
        "TakeAllButton"

    takeAllButton.Size =
        UDim2.new(0, 170, 0, 40)

    takeAllButton.Position =
        UDim2.new(0, 10, 0, 124)

    takeAllButton.Text =
        "TAKE ALL"

    takeAllButton.Parent =
        mainTable

    styleButton(takeAllButton)

    --==================================================
    -- LOGO
    --==================================================

    logoD =
        Instance.new("TextButton")

    logoD.Name =
        "LogoD"

    logoD.Size =
        UDim2.new(0, 44, 0, 44)

    logoD.Position =
        lastPosition

    logoD.Text = "D"

    logoD.Font =
        Enum.Font.GothamBold

    logoD.TextSize = 24

    logoD.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    logoD.BackgroundColor3 =
        Color3.fromRGB(78, 55, 110)

    logoD.BorderSizePixel = 0
    logoD.AutoButtonColor = false
    logoD.Visible = false

    logoD.Parent =
        screenGui

    local logoGradient =
        Instance.new("UIGradient")

    logoGradient.Color =
        ColorSequence.new({

            ColorSequenceKeypoint.new(
                0,
                Color3.fromRGB(65, 48, 100)
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(105, 60, 100)
            )

        })

    logoGradient.Rotation = 35
    logoGradient.Parent = logoD

    local logoStroke =
        Instance.new("UIStroke")

    logoStroke.Color =
        Color3.fromRGB(230, 220, 255)

    logoStroke.Thickness = 1.2
    logoStroke.Transparency = 0.1

    logoStroke.Parent =
        logoD

    local logoCorner =
        Instance.new("UICorner")

    logoCorner.CornerRadius =
        UDim.new(0, 11)

    logoCorner.Parent =
        logoD

    --==================================================
    -- DRAG
    --==================================================

    makeDraggable(
        mainTable,

        function(newPosition)

            lastPosition =
                newPosition

        end
    )

    makeDraggable(
        logoD,

        function(newPosition)

            lastPosition =
                newPosition

        end
    )

    --==================================================
    -- CLOSE MAIN
    --==================================================

    closeButton.MouseButton1Click:Connect(function()

        mainTable.Visible = false

        logoD.Position =
            lastPosition

        logoD.Visible = true

    end)

    --==================================================
    -- OPEN MAIN
    --==================================================

    logoD.MouseButton1Click:Connect(function()

        logoD.Visible = false

        mainTable.Position =
            lastPosition

        mainTable.Visible = true

    end)

    --==================================================
    -- CRYSTAL
    --==================================================

    crystalButton.MouseButton1Click:Connect(function()

        if resetCooldown then
            return
        end

        resetCooldown = true

        if player.Character then
            player.Character:BreakJoints()
        end

        task.wait(6)

        resetCooldown = false

    end)

    --==================================================
    -- RUNE
    --==================================================

    runeButton.MouseButton1Click:Connect(function()

        mainTable.Visible = false

        runeSelection.Position =
            lastPosition

        runeSelection.Visible = true

    end)

    --==================================================
    -- TAKE ALL
    --==================================================

    takeAllButton.MouseButton1Click:Connect(function()
        collectAllDrops()
    end)

    --==================================================
    -- CREATE RUNE WINDOW
    --==================================================

    createRuneSelection()

end

--==================================================
-- CHARACTER ADDED
--==================================================

player.CharacterAdded:Connect(function()

    task.wait(0.5)

    local oldGui =
        player.PlayerGui:FindFirstChild(
            "DRIANLOVEMALTE"
        )

    if oldGui then
        oldGui:Destroy()
    end

    screenGui = nil
    runeRunning = false

    createMainGui()

end)

--==================================================
-- PLACE DETECTION
--==================================================

if game.PlaceId == 5901548022 then
    showAntiCheatNotification()
end

--==================================================
-- INITIALIZE
--==================================================

createMainGui()

screenGui.Enabled = true
