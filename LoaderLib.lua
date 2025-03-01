local VMXLibrary = {}

function VMXLibrary.new(title, clientName)
    local lib = {}
    lib.config = {
        title = title or "VMX-Console",
        clientName = clientName or "VMX",
        gameId = game.GameId,
        messages = {}
    }

    -- Create all UI elements
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local HeaderBar = Instance.new("Frame")
    local HeaderText = Instance.new("TextLabel")
    local ConsoleBox = Instance.new("TextLabel")
    local LoadButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")

    -- ScreenGui Setup
    ScreenGui.Name = "VMXLoader"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Main Frame Setup (increased size)
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175) -- Adjusted position
    MainFrame.Size = UDim2.new(0, 500, 0, 350) -- Increased size

    -- Header Setup
    HeaderBar.Name = "HeaderBar"
    HeaderBar.Parent = MainFrame
    HeaderBar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    HeaderBar.Size = UDim2.new(1, 0, 0, 30)

    HeaderText.Name = "HeaderText"
    HeaderText.Parent = HeaderBar
    HeaderText.BackgroundTransparency = 1
    HeaderText.Size = UDim2.new(1, 0, 1, 0)
    HeaderText.Font = Enum.Font.Code -- Changed from Gotham
    HeaderText.Text = lib.config.title
    HeaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderText.TextSize = 14 -- Reduced size for less emphasis

    -- Console Setup
    ConsoleBox.Name = "ConsoleBox"
    ConsoleBox.Parent = MainFrame
    ConsoleBox.BackgroundTransparency = 1
    ConsoleBox.Position = UDim2.new(0, 10, 0, 40)
    ConsoleBox.Size = UDim2.new(1, -20, 1, -80)
    ConsoleBox.Font = Enum.Font.Code
    ConsoleBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConsoleBox.TextSize = 14
    ConsoleBox.TextXAlignment = Enum.TextXAlignment.Left
    ConsoleBox.TextYAlignment = Enum.TextYAlignment.Top
    ConsoleBox.RichText = true
    ConsoleBox.TextTransparency = 0 -- Ensure full opacity
    ConsoleBox.Text = ""

    -- Load Button Setup (full width with margins)
    LoadButton.Name = "LoadButton"
    LoadButton.Parent = MainFrame
    LoadButton.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
    LoadButton.Position = UDim2.new(0, 20, 1, -35)
    LoadButton.Size = UDim2.new(1, -40, 0, 25)
    LoadButton.Font = Enum.Font.Code -- Changed from Gotham
    LoadButton.Text = "Exit Client"
    LoadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadButton.TextSize = 14
    LoadButton.AutoButtonColor = true

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = LoadButton

    -- Library Methods
    function lib:setTitle(text)
        self.config.title = text
        HeaderText.Text = text
        return self
    end

    function lib:setClientName(name)
        self.config.clientName = name
        self:updateConsole()
        return self
    end

    function lib:setGameId(id)
        self.config.gameId = id
        self:updateConsole()
        return self
    end

    function lib:addMessage(text, color)
        table.insert(self.config.messages, {
            text = text,
            color = color or "white"
        })
        self:updateConsole()
        return self
    end

    function lib:clearMessages()
        self.config.messages = {}
        self:updateConsole()
        return self
    end

    function lib:onLoad(callback)
        LoadButton.MouseButton1Click:Connect(function()
            LoadButton.Text = "Load Client"
            LoadButton.TextColor3 = Color3.fromRGB(0, 255, 0)
            if callback then callback() end
        end)
        return self
    end

    function lib:setProduct(name, type, nameColor, typeColor)
        local formattedProduct = string.format(
            '<font color="rgb(%s)">%s</font>, <font color="rgb(%s)">%s</font>',
            nameColor or "255,255,255", -- default white
            name,
            typeColor or "255,0,0", -- default red
            type
        )
        self:setGameId(formattedProduct)
        return self
    end

    function lib:updateConsole()
        local messages = {
            "[" .. self.config.clientName .. "] Preparing to load client",
            "[" .. self.config.clientName .. "] {AUTH} -Checking Username",
            "[" .. self.config.clientName .. "] {AUTH} - Returned Username",
            "[" .. self.config.clientName .. "] {AUTH} Connecting To Database...",
            '<font color="rgb(0,255,0)">[' .. self.config.clientName .. '] {SERVER} Connected Click Load to load Client.</font>',
            "[" .. self.config.clientName .. "] {INFO} Product " .. self.config.gameId
        }
        
        -- Animate messages
        ConsoleBox.Text = ""
        task.spawn(function()
            for _, msg in ipairs(messages) do
                if ConsoleBox.Parent then -- Check if UI still exists
                    ConsoleBox.Text = ConsoleBox.Text .. msg .. "\n"
                    task.wait(0.3) -- Delay between messages
                end
            end
        end)
    end

    -- Initialize
    lib:updateConsole()
    return lib
end

return VMXLibrary
