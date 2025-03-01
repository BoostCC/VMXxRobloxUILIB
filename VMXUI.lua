local VMXUILib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Constants
local HEADER_COLOR = Color3.fromRGB(9, 9, 11)
local BODY_COLOR = Color3.fromRGB(0, 0, 0)
local TOGGLE_COLOR = Color3.fromRGB(51, 51, 53)

-- Add asset IDs at the top
local ASSETS = {
    BORDER_EFFECT = "rbxassetid://97259191643686",
    CLOCK_ICON = "rbxassetid://132175659283716",
    KEY_ICON = "rbxassetid://130149033720748",
    MEMBERSHIP_ICON = "rbxassetid://72871307464995",
    CHECKMARK_ICON = "rbxassetid://113327020833903",
    DROPDOWN_ICON = "rbxassetid://98930286736725"
}

-- Utility Functions
local function createRoundedFrame(props)
    local frame = Instance.new("Frame")
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, props.radius or 2)
    corner.Parent = frame
    
    for prop, value in pairs(props) do
        if prop ~= "radius" then
            frame[prop] = value
        end
    end
    
    return frame
end

local function createLabel(text, props)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.Code
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.BackgroundTransparency = 1
    
    for prop, value in pairs(props or {}) do
        label[prop] = value
    end
    
    return label
end

local function HSVtoRGB(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    
    i = i % 6
    
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    
    return Color3.new(r, g, b)
end

local function RGBtoHSV(color)
    local r, g, b = color.R, color.G, color.B
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    v = max
    
    local d = max - min
    s = max == 0 and 0 or d / max
    
    if max == min then
        h = 0
    else
        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    
    return h, s, v
end

function VMXUILib.new(title)
    local window = {}
    local isOpen = false
    local elements = {}
    
    -- Create main GUI elements
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = createRoundedFrame({
        Name = "MainFrame",
        BackgroundColor3 = BODY_COLOR,
        BackgroundTransparency = 0.17,
        Size = UDim2.new(0, 300, 0, 400),
        Position = UDim2.new(0.5, -150, 0.5, -200),
        Parent = ScreenGui
    })

    -- Add border effect
    local BorderEffect = Instance.new("ImageLabel")
    BorderEffect.Image = ASSETS.BORDER_EFFECT
    BorderEffect.BackgroundTransparency = 1
    BorderEffect.Size = UDim2.new(0, 1471, 0, 127)
    BorderEffect.Position = UDim2.new(-0.014, 0, 0.887, 0)
    BorderEffect.Parent = ScreenGui
    BorderEffect.ImageTransparency = 0.7

    -- Add user info section
    local UserThumbnail = Instance.new("ImageLabel")
    UserThumbnail.Size = UDim2.new(0, 30, 0, 30)
    UserThumbnail.Position = UDim2.new(0.021, 0, 0.949, 0)
    UserThumbnail.Parent = ScreenGui
    -- Set thumbnail to player's avatar
    UserThumbnail.Image = Players:GetUserThumbnailAsync(
        Players.LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size420x420
    )

    -- Add watermark labels
    local Watermark = createLabel("VMX ROBLOX | FPS: 0", {
        Position = UDim2.new(0.006, 0, 0.012, 0),
        Size = UDim2.new(0, 153, 0, 27),
        TextStrokeTransparency = 0.4,
        Parent = ScreenGui
    })

    -- Add system time display
    local ClockIcon = Instance.new("ImageLabel")
    ClockIcon.Image = ASSETS.CLOCK_ICON
    ClockIcon.BackgroundTransparency = 1
    ClockIcon.Size = UDim2.new(0, 28, 0, 29)
    ClockIcon.Position = UDim2.new(0.168, 0, 0.950, 0)
    ClockIcon.Parent = ScreenGui

    local SystemTimeLabel = createLabel("System Time", {
        Position = UDim2.new(0.191, 0, 0.950, 0),
        Size = UDim2.new(0, 87, 0, 16),
        Parent = ScreenGui
    })

    local TimeLabel = createLabel(os.date("%I:%M %p"), {
        Position = UDim2.new(0.191, 0, 0.973, 0),
        Size = UDim2.new(0, 56, 0, 11),
        TextColor3 = Color3.fromRGB(255, 0, 4),
        Parent = ScreenGui
    })

    -- Update UI elements
    game:GetService("RunService").RenderStepped:Connect(function()
        local fps = math.floor(1/game:GetService("RunService").RenderStepped:Wait())
        Watermark.Text = string.format("VMX ROBLOX | FPS: %d", fps)
        TimeLabel.Text = os.date("%I:%M %p")
    end)

    -- Create header
    local HeaderFrame = createRoundedFrame({
        Name = "Header",
        BackgroundColor3 = HEADER_COLOR,
        Size = UDim2.new(1, 0, 0, 30),
        Parent = MainFrame
    })
    
    -- Add title to header
    local HeaderTitle = createLabel(title, {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = HeaderFrame
    })
    
    -- Create content frame
    local ContentFrame = createRoundedFrame({
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -40),
        Position = UDim2.new(0, 10, 0, 35),
        Parent = MainFrame
    })

    -- Add element functions
    function window:AddToggle(name, defaultState, callback, parent)
        local toggleFrame = createRoundedFrame({
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, #parent:GetChildren() * 35),
            Parent = parent or ContentFrame
        })
        
        local toggleButton = createRoundedFrame({
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 5, 0.5, -10),
            BackgroundColor3 = TOGGLE_COLOR,
            Parent = toggleFrame
        })
        
        local label = createLabel(name, {
            Position = UDim2.new(0, 35, 0, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Parent = toggleFrame
        })
        
        local enabled = defaultState or false
        
        local function updateToggle()
            toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or TOGGLE_COLOR
            if callback then callback(enabled) end
        end
        
        toggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                enabled = not enabled
                updateToggle()
            end
        end)
        
        return {
            Frame = toggleFrame,
            SetState = function(state)
                enabled = state
                updateToggle()
            end
        }
    end

    function window:AddSlider(name, min, max, default, callback, parent)
        local sliderFrame = createRoundedFrame({
            Size = UDim2.new(1, 0, 0, 45),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, #parent:GetChildren() * 35),
            Parent = parent or ContentFrame
        })
        
        local label = createLabel(name, {
            Position = UDim2.new(0, 5, 0, 0),
            Size = UDim2.new(1, -10, 0, 20),
            Parent = sliderFrame
        })
        
        local sliderBG = createRoundedFrame({
            Size = UDim2.new(1, -10, 0, 20),
            Position = UDim2.new(0, 5, 0, 22),
            BackgroundColor3 = TOGGLE_COLOR,
            Parent = sliderFrame
        })
        
        local sliderFill = createRoundedFrame({
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(0, 255, 0),
            Parent = sliderBG
        })
        
        local valueLabel = createLabel(tostring(default), {
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.new(0, 50, 1, 0),
            Parent = sliderBG
        })

        -- Add slider functionality
        local dragging = false
        local value = default or min
        
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * pos)
            valueLabel.Text = tostring(value)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            if callback then callback(value) end
        end

        sliderBG.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)

        return {
            Frame = sliderFrame,
            SetValue = function(newValue)
                value = math.clamp(newValue, min, max)
                local pos = (value - min) / (max - min)
                valueLabel.Text = tostring(value)
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                if callback then callback(value) end
            end
        }
    end

    function window:AddColorPicker(name, defaultColor, callback, parent)
        local pickerOpen = false
        local recentColors = {}
        
        -- Create main button
        local colorFrame = createRoundedFrame({
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, #parent:GetChildren() * 35),
            Parent = parent or ContentFrame
        })
        
        local colorButton = createRoundedFrame({
            Size = UDim2.new(0, 30, 0, 20),
            Position = UDim2.new(1, -35, 0.5, -10),
            BackgroundColor3 = defaultColor or Color3.fromRGB(255, 255, 255),
            Parent = colorFrame
        })
        
        local nameLabel = createLabel(name, {
            Position = UDim2.new(0, 5, 0, 0),
            Size = UDim2.new(1, -45, 1, 0),
            Parent = colorFrame
        })
        
        -- Create color picker window
        local pickerGui = createRoundedFrame({
            Size = UDim2.new(0, 200, 0, 240),
            Position = UDim2.new(1, 10, 0, 0),
            BackgroundColor3 = HEADER_COLOR,
            Parent = colorFrame,
            Visible = false
        })
        
        -- Create color spectrum
        local spectrum = createRoundedFrame({
            Size = UDim2.new(1, -20, 0, 150),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundColor3 = Color3.fromRGB(255, 0, 0),
            Parent = pickerGui
        })
        
        local spectrumGradient = Instance.new("UIGradient")
        spectrumGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        })
        spectrumGradient.Parent = spectrum
        
        -- Create hue bar
        local hueBar = createRoundedFrame({
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 10, 0, 170),
            Parent = pickerGui
        })
        
        local hueGradient = Instance.new("UIGradient")
        hueGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        })
        hueGradient.Parent = hueBar
        
        -- Create RGB inputs
        local function createColorInput(label, position)
            local frame = createRoundedFrame({
                Size = UDim2.new(0, 50, 0, 20),
                Position = position,
                BackgroundColor3 = TOGGLE_COLOR,
                Parent = pickerGui
            })
            
            local text = createLabel(label, {
                Size = UDim2.new(1, 0, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = frame
            })
            
            return frame, text
        end
        
        local rInput, rText = createColorInput("R", UDim2.new(0, 10, 0, 200))
        local gInput, gText = createColorInput("G", UDim2.new(0, 70, 0, 200))
        local bInput, bText = createColorInput("B", UDim2.new(0, 130, 0, 200))
        
        -- Create selector circles
        local hueSelectorCircle = createRoundedFrame({
            Size = UDim2.new(0, 10, 1, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = hueBar
        })
        
        local colorSelectorCircle = createRoundedFrame({
            Size = UDim2.new(0, 10, 0, 10),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = spectrum
        })
        
        -- Color picking logic
        local function updateColor(hue, sat, val)
            local color = HSVtoRGB(hue, sat, val)
            colorButton.BackgroundColor3 = color
            if callback then callback(color) end
            
            -- Update RGB inputs
            rText.Text = math.floor(color.R * 255)
            gText.Text = math.floor(color.G * 255)
            bText.Text = math.floor(color.B * 255)
            
            -- Update spectrum color
            spectrum.BackgroundColor3 = HSVtoRGB(hue, 1, 1)
        end
        
        -- Dragging logic
        local draggingHue, draggingColor = false, false
        local h, s, v = 0, 1, 1
        
        hueBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingHue = true
            end
        end)
        
        spectrum.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingColor = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingHue = false
                draggingColor = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                if draggingHue then
                    local pos = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    hueSelectorCircle.Position = UDim2.new(pos, -5, 0, 0)
                    h = pos
                    updateColor(h, s, v)
                elseif draggingColor then
                    local x = math.clamp((input.Position.X - spectrum.AbsolutePosition.X) / spectrum.AbsoluteSize.X, 0, 1)
                    local y = math.clamp((input.Position.Y - spectrum.AbsolutePosition.Y) / spectrum.AbsoluteSize.Y, 0, 1)
                    colorSelectorCircle.Position = UDim2.new(x, -5, y, -5)
                    s = x
                    v = 1 - y
                    updateColor(h, s, v)
                end
            end
        end)
        
        -- Toggle picker visibility
        colorButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                pickerOpen = not pickerOpen
                pickerGui.Visible = pickerOpen
            end
        end)
        
        -- Initial color setup
        if defaultColor then
            local h, s, v = RGBtoHSV(defaultColor)
            updateColor(h, s, v)
            hueSelectorCircle.Position = UDim2.new(h, -5, 0, 0)
            colorSelectorCircle.Position = UDim2.new(s, -5, 1-v, -5)
        end
        
        return {
            Frame = colorFrame,
            SetColor = function(color)
                local h, s, v = RGBtoHSV(color)
                updateColor(h, s, v)
                hueSelectorCircle.Position = UDim2.new(h, -5, 0, 0)
                colorSelectorCircle.Position = UDim2.new(s, -5, 1-v, -5)
            end
        }
    end

    function window:AddKeybind(name, defaultKey, callback, parent)
        local keybindFrame = createRoundedFrame({
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, #parent:GetChildren() * 35),
            Parent = parent or ContentFrame
        })
    
        local label = createLabel(name, {
            Position = UDim2.new(0, 5, 0, 0),
            Size = UDim2.new(0.5, -10, 1, 0),
            Parent = keybindFrame
        })
    
        local bindButton = createRoundedFrame({
            Size = UDim2.new(0.5, -10, 0, 20),
            Position = UDim2.new(0.5, 5, 0.5, -10),
            BackgroundColor3 = TOGGLE_COLOR,
            Parent = keybindFrame
        })
    
        local bindText = createLabel(defaultKey and defaultKey.Name or "Click To Bind", {
            Size = UDim2.new(1, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = bindButton
        })
    
        local currentKey = defaultKey
        local binding = false
    
        bindButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                binding = true
                bindText.Text = "..."
                
                -- Disconnect previous connection if exists
                if window.keyConnection then
                    window.keyConnection:Disconnect()
                end
                
                window.keyConnection = UserInputService.InputBegan:Connect(function(keyInput)
                    if keyInput.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = keyInput.KeyCode
                        bindText.Text = currentKey.Name
                        binding = false
                        window.keyConnection:Disconnect()
                        if callback then callback(currentKey) end
                    end
                end)
            end
        end)
    
        return {
            Frame = keybindFrame,
            GetKey = function() return currentKey end,
            SetKey = function(key)
                currentKey = key
                bindText.Text = key and key.Name or "None"
            end
        }
    end
    
    function window:AddDropdown(name, options, multiSelect, callback, parent)
        local dropdownFrame = createRoundedFrame({
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, #parent:GetChildren() * 35),
            Parent = parent or ContentFrame
        })
    
        local label = createLabel(name, {
            Position = UDim2.new(0, 5, 0, 0),
            Size = UDim2.new(1, -10, 0, 20),
            Parent = dropdownFrame
        })
    
        local dropdownButton = createRoundedFrame({
            Size = UDim2.new(1, -10, 0, 25),
            Position = UDim2.new(0, 5, 0, 25),
            BackgroundColor3 = TOGGLE_COLOR,
            Parent = dropdownFrame
        })
    
        local selectedText = createLabel(multiSelect and "None" or options[1], {
            Size = UDim2.new(1, -25, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = dropdownButton
        })
    
        local arrow = Instance.new("ImageLabel")
        arrow.Image = ASSETS.DROPDOWN_ICON
        arrow.BackgroundTransparency = 1
        arrow.Size = UDim2.new(0, 21, 0, 16)
        arrow.Position = UDim2.new(0.492, 0, 0.498, 0)
        arrow.Parent = dropdownButton
    
        local optionsFrame = createRoundedFrame({
            Size = UDim2.new(1, 0, 0, #options * 25),
            Position = UDim2.new(0, 0, 1, 5),
            BackgroundColor3 = TOGGLE_COLOR,
            Parent = dropdownButton,
            Visible = false
        })
    
        local selected = multiSelect and {} or options[1]
        
        -- Create option buttons
        for i, option in ipairs(options) do
            local optionButton = createRoundedFrame({
                Size = UDim2.new(1, 0, 0, 25),
                Position = UDim2.new(0, 0, 0, (i-1) * 25),
                BackgroundColor3 = TOGGLE_COLOR,
                BackgroundTransparency = 0.5,
                Parent = optionsFrame
            })
    
            local optionText = createLabel(option, {
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = optionButton
            })
    
            if multiSelect then
                local checkbox = createRoundedFrame({
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(1, -25, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                    Parent = optionButton
                })
            end
    
            optionButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if multiSelect then
                        if table.find(selected, option) then
                            table.remove(selected, table.find(selected, option))
                        else
                            table.insert(selected, option)
                        end
                        selectedText.Text = #selected > 0 and table.concat(selected, ", ") or "None"
                    else
                        selected = option
                        selectedText.Text = option
                        optionsFrame.Visible = false
                    end
                    if callback then callback(selected) end
                end
            end)
        end
    
        dropdownButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                optionsFrame.Visible = not optionsFrame.Visible
                TweenService:Create(arrow, TweenInfo.new(0.2), {
                    Rotation = optionsFrame.Visible and 180 or 0
                }):Play()
            end
        end)
    
        return {
            Frame = dropdownFrame,
            GetSelected = function() return selected end,
            SetSelected = function(value)
                selected = value
                selectedText.Text = multiSelect and (#value > 0 and table.concat(value, ", ") or "None") or value
                if callback then callback(selected) end
            end
        }
    end

    -- Add window functionality
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            isOpen = not isOpen
            MainFrame.Visible = isOpen
            
            -- Animate border effect
            if isOpen then
                TweenService:Create(MainFrame, TweenInfo.new(0.3), {
                    BackgroundTransparency = 0.17
                }):Play()
            end
        end
    end)

    -- Make window draggable
    local dragging, dragInput, dragStart, startPos
    
    HeaderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    HeaderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    ScreenGui.Parent = game:GetService("CoreGui")
    MainFrame.Visible = false

    -- Fix tab system
    function window:CreateTab(name)
        local tabFrame = createRoundedFrame({
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Parent = ContentFrame
        })

        local tab = {
            Frame = tabFrame,
            AddToggle = function(self, name, default, callback)
                return window:AddToggle(name, default, callback, tabFrame)
            end,
            AddSlider = function(self, name, min, max, default, callback)
                return window:AddSlider(name, min, max, default, callback, tabFrame)
            end,
            AddDropdown = function(self, name, options, multiSelect, callback)
                return window:AddDropdown(name, options, multiSelect, callback, tabFrame)
            end,
            AddColorPicker = function(self, name, default, callback)
                return window:AddColorPicker(name, default, callback, tabFrame)
            end,
            AddKeybind = function(self, name, default, callback)
                return window:AddKeybind(name, default, callback, tabFrame)
            end,
            AddLabel = function(self, text)
                local label = createLabel(text, {
                    Size = UDim2.new(1, -10, 0, 25),
                    Position = UDim2.new(0, 5, 0, #tabFrame:GetChildren() * 35),
                    Parent = tabFrame
                })
                return label
            end
        }

        return tab
    end

    return window
end

function VMXUILib.createTabs()
    local tabSystem = {
        tabs = {},
        currentTab = nil
    }
    
    local tabContainer = createRoundedFrame({
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    function tabSystem:AddTab(name, icon)
        local tab = {
            name = name,
            contentFrame = createRoundedFrame({
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Visible = false,
                Parent = tabContainer
            })
        }
        
        table.insert(self.tabs, tab)
        if #self.tabs == 1 then
            self:SelectTab(1)
        end
        
        return tab.contentFrame
    end
    
    function tabSystem:SelectTab(index)
        for i, tab in ipairs(self.tabs) do
            tab.contentFrame.Visible = (i == index)
        end
        self.currentTab = index
    end
    
    return tabSystem
end

return VMXUILib
