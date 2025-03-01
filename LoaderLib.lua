local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local HeaderBar = Instance.new("Frame")
local HeaderText = Instance.new("TextLabel")
local ConsoleBox = Instance.new("TextLabel")
local LoadButton = Instance.new("TextButton")

-- Setup ScreenGui
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame Setup
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Position = UDim2.new(0.5, -201, 0.5, -151)
MainFrame.Size = UDim2.new(0, 403, 0, 302)

-- Header Setup
HeaderBar.Name = "HeaderBar"
HeaderBar.Parent = MainFrame
HeaderBar.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
HeaderBar.Size = UDim2.new(1, 0, 0, 30)

HeaderText.Name = "HeaderText"
HeaderText.Parent = HeaderBar
HeaderText.BackgroundTransparency = 1
HeaderText.Size = UDim2.new(1, 0, 1, 0)
HeaderText.Font = Enum.Font.SourceSansBold
HeaderText.Text = "VMX-Console"
HeaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderText.TextSize = 16

-- Console Text Setup
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

-- Load Button Setup
LoadButton.Name = "LoadButton"
LoadButton.Parent = MainFrame
LoadButton.BackgroundColor3 = Color3.fromRGB(51, 51, 51) -- 333333 in hex
LoadButton.Position = UDim2.new(0.5, -50, 1, -35)
LoadButton.Size = UDim2.new(0, 100, 0, 25)
LoadButton.Font = Enum.Font.Gotham -- Modern, clean font similar to Inter
LoadButton.Text = "Exit Client"
LoadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadButton.TextSize = 14
LoadButton.AutoButtonColor = true

-- Add corner rounding
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4) -- 2-4 pixel rounding
UICorner.Parent = LoadButton

-- Console Text Function
local function updateConsole()
    local gameId = game.GameId
    local messages = {
        '<font color="rgb(0,255,0)">[VMX]</font> Preparing to load client',
        '<font color="rgb(255,255,255)">[VMX]</font> <font color="rgb(255,0,0)">{AUTH}</font> -Checking Username',
        '<font color="rgb(255,255,255)">[VMX]</font> <font color="rgb(255,0,0)">{AUTH}</font> - Returned Username',
        '<font color="rgb(255,255,255)">[VMX]</font> <font color="rgb(255,0,0)">{AUTH}</font> Connecting To Database...',
        '<font color="rgb(255,255,255)">[VMX]</font> <font color="rgb(255,0,0)">{SERVER}</font> <font color="rgb(0,255,0)">Connected</font> Click <font color="rgb(0,255,0)">Load</font> to load Client.',
        '<font color="rgb(255,255,255)">[VMX]</font> <font color="rgb(255,255,0)">{INFO}</font> Product <font color="rgb(255,0,0)">' .. gameId .. '</font>'
    }
    
    ConsoleBox.Text = table.concat(messages, '\n')
    wait(2)
    LoadButton.Text = "Load Client"
    LoadButton.TextColor3 = Color3.fromRGB(0, 255, 0)
end

LoadButton.MouseButton1Click:Connect(updateConsole)
updateConsole()
