local VMXLibrary = {}

local TweenService = game:GetService("TweenService")

function VMXLibrary.new(title, clientName)
    local lib = {}
    lib.config = {
        title = title or "VMX-Console",
        clientName = clientName or "VMX",
        gameId = game.GameId,
        messages = {}
    }

    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local HeaderBar = Instance.new("Frame")
    local HeaderText = Instance.new("TextLabel")
    local ConsoleBox = Instance.new("TextLabel")
    local LoadButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")

    ScreenGui.Name = "VMXLoader"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)

    HeaderBar.Name = "HeaderBar"
    HeaderBar.Parent = MainFrame
    HeaderBar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    HeaderBar.Size = UDim2.new(1, 0, 0, 30)

    HeaderText.Name = "HeaderText"
    HeaderText.Parent = HeaderBar
    HeaderText.BackgroundTransparency = 1
    HeaderText.Size = UDim2.new(1, 0, 1, 0)
    HeaderText.Font = Enum.Font.Code
    HeaderText.Text = lib.config.title
    HeaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderText.TextSize = 14

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
    ConsoleBox.TextTransparency = 0
    ConsoleBox.Text = ""

    LoadButton.Name = "LoadButton"
    LoadButton.Parent = MainFrame
    LoadButton.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
    LoadButton.Position = UDim2.new(0, 20, 1, -35)
    LoadButton.Size = UDim2.new(1, -40, 0, 25)
    LoadButton.Font = Enum.Font.Code
    LoadButton.Text = "Exit Client"
    LoadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadButton.TextSize = 14
    LoadButton.AutoButtonColor = true

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = LoadButton

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

    local function exitClient()
        local fadeOut = TweenService:Create(ScreenGui, TweenInfo.new(0.5), {
            Transparency = 1
        })
        fadeOut:Play()
        fadeOut.Completed:Wait()
        ScreenGui:Destroy()
    end

    function lib:onLoad(callback)
        local isExiting = true
        
        LoadButton.MouseButton1Click:Connect(function()
            if isExiting then
                exitClient()
            else
                if callback then callback() end
            end
        end)

        task.spawn(function()
            task.wait(#messages * 0.5 + 1)
            isExiting = false
        end)
        
        return self
    end

    function lib:setProduct(name, type, nameColor, typeColor)
        local formattedProduct = string.format(
            '<font color="rgb(%s)">%s</font>, <font color="rgb(%s)">%s</font>',
            nameColor or "255,255,255",
            name,
            typeColor or "255,0,0",
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
        
        ConsoleBox.Text = ""
        task.spawn(function()
            for _, msg in ipairs(messages) do
                if ConsoleBox.Parent then
                    ConsoleBox.Text = ConsoleBox.Text .. msg .. "\n"
                    task.wait(0.5)
                end
            end

            if LoadButton then
                local buttonTween = TweenService:Create(LoadButton, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                })
                local textTween = TweenService:Create(LoadButton, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                })
                
                task.wait(0.3)
                LoadButton.Text = "Load Client"
                buttonTween:Play()
                textTween:Play()
            end
        end)
    end

    lib:updateConsole()
    return lib
end

return VMXLibrary
