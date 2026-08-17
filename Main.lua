--========================================================--
--        DB Panel - 配色修改版｜文字适度加大
--        半透明纯黑背景 / 按钮更黑 / 文字纯白不透明
--========================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 动态尺寸
local function GetViewport()
    local cam = workspace.CurrentCamera
    if not cam then cam = workspace:WaitForChild("CurrentCamera", 2) end
    return cam and cam.ViewportSize or Vector2.new(1920, 1080)
end

local viewport = GetViewport()
local baseW, baseH = 650, 460
local panelWidth = math.clamp(viewport.X * 0.65, 400, baseW)
local panelHeight = math.clamp(panelWidth * (baseH / baseW), 280, baseH)
local BUTTON_SIZE = 56
local CORNER_RADIUS = 16
local ANIMATION_TIME = 0.35

-- GUI
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "DB_Panel"
MainGui.ResetOnSpawn = false
MainGui.IgnoreGuiInset = true
MainGui.DisplayOrder = 999
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.Parent = LocalPlayer.PlayerGui

-- State
local State = {
    PanelPosition = nil,
    ButtonPosition = nil,
    Animating = false,
    Minimized = false,
    CurrentCategory = "通用"
}

-- Clamp
local function ClampPosition(pos, size)
    local vp = GetViewport()
    local hx, hy = size.X/2, size.Y/2
    return Vector2.new(
        math.clamp(pos.X, -hx, vp.X + hx),
        math.clamp(pos.Y, -hy, vp.Y + hy)
    )
end

-- Rainbow
local Rainbow = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,55,75)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,170,50)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(255,240,60)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(65,255,125)),
    ColorSequenceKeypoint.new(0.64, Color3.fromRGB(55,205,255)),
    ColorSequenceKeypoint.new(0.80, Color3.fromRGB(125,70,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,55,190))
})

-- Panel
local Panel = Instance.new("Frame")
Panel.Name = "Panel"
Panel.AnchorPoint = Vector2.new(0.5, 0.5)
Panel.Size = UDim2.fromOffset(panelWidth, panelHeight)
Panel.BackgroundTransparency = 1
Panel.BorderSizePixel = 0
Panel.Active = true
Panel.Parent = MainGui

local Body = Instance.new("Frame")
Body.Name = "Body"
Body.Position = UDim2.fromOffset(2, 2)
Body.Size = UDim2.new(1, -4, 1, -4)
Body.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Body.BackgroundTransparency = 0.30
Body.BorderSizePixel = 0
Body.ClipsDescendants = true
Body.Parent = Panel

local BodyCorner = Instance.new("UICorner")
BodyCorner.CornerRadius = UDim.new(0, CORNER_RADIUS)
BodyCorner.Parent = Body

local Border = Instance.new("UIStroke")
Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Border.Thickness = 2
Border.Color = Color3.new(1,1,1)
Border.Parent = Body
local BorderGrad = Instance.new("UIGradient")
BorderGrad.Color = Rainbow
BorderGrad.Parent = Border

local Glow = Instance.new("UIStroke")
Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Glow.Thickness = 7
Glow.Transparency = 0.82
Glow.Color = Color3.new(1,1,1)
Glow.Parent = Body
local GlowGrad = Instance.new("UIGradient")
GlowGrad.Color = Rainbow
GlowGrad.Parent = Glow

-- Floating Button (DB)
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingButton.Size = UDim2.fromOffset(BUTTON_SIZE, BUTTON_SIZE)
FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FloatingButton.BackgroundTransparency = 0.25
FloatingButton.BorderSizePixel = 0
FloatingButton.Text = "DB"
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.TextSize = 22 --略微放大悬浮按钮文字
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.AutoButtonColor = false
FloatingButton.Active = true
FloatingButton.Visible = false
FloatingButton.ZIndex = 100
FloatingButton.Parent = MainGui

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(1, 0)
BtnCorner.Parent = FloatingButton

local BtnBorder = Instance.new("UIStroke")
BtnBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BtnBorder.Thickness = 2
BtnBorder.Color = Color3.new(1,1,1)
BtnBorder.Parent = FloatingButton
local BtnGrad = Instance.new("UIGradient")
BtnGrad.Color = Rainbow
BtnGrad.Parent = BtnBorder

local BtnGlow = Instance.new("UIStroke")
BtnGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BtnGlow.Thickness = 7
BtnGlow.Transparency = 0.82
BtnGlow.Color = Color3.new(1,1,1)
BtnGlow.Parent = FloatingButton
local BtnGlowGrad = Instance.new("UIGradient")
BtnGlowGrad.Color = Rainbow
BtnGlowGrad.Parent = BtnGlow

-- Rainbow Animation
task.spawn(function()
    local rot = 0
    while MainGui.Parent do
        rot = (rot + 1.25) % 360
        BorderGrad.Rotation = rot
        GlowGrad.Rotation = rot + 12
        BtnGrad.Rotation = rot
        BtnGlowGrad.Rotation = rot + 12
        task.wait(0.025)
    end
end)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Active = true
Header.ZIndex = 10
Header.Parent = Body

local DragArea = Instance.new("TextButton")
DragArea.Name = "DragArea"
DragArea.Size = UDim2.new(1, -90, 1, 0)
DragArea.Position = UDim2.fromOffset(0, 0)
DragArea.BackgroundTransparency = 1
DragArea.BorderSizePixel = 0
DragArea.Text = ""
DragArea.AutoButtonColor = false
DragArea.Active = true
DragArea.ZIndex = 20
DragArea.Parent = Header

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(14, 10)
Title.Size = UDim2.new(1, -40, 0, 28)
Title.Text = "DB 功能面板"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20 --标题放大
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 21
Title.Parent = DragArea

local Subtitle = Instance.new("TextLabel")
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.fromOffset(16, 34)
Subtitle.Size = UDim2.new(1, -40, 0, 14)
Subtitle.Text = "点击分类 · 加载脚本"
Subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
Subtitle.TextSize = 11 --副标题放大
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 21
Subtitle.Parent = DragArea

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.fromOffset(40, 40)
CloseBtn.Position = UDim2.new(1, -48, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CloseBtn.BackgroundTransparency = 0.20
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "−"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 30 --最小化按钮文字放大
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 30
CloseBtn.Parent = Header
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,12)
CloseCorner.Parent = CloseBtn

-- Content
local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(6, 56)
Content.Size = UDim2.new(1, -12, 1, -64)
Content.BackgroundTransparency = 1
Content.Parent = Body

local LeftMenu = Instance.new("Frame")
LeftMenu.Size = UDim2.new(0, 150, 1, 0)
LeftMenu.BackgroundTransparency = 1
LeftMenu.Parent = Content

local MenuScroll = Instance.new("ScrollingFrame")
MenuScroll.Size = UDim2.new(1, -4, 1, 0)
MenuScroll.Position = UDim2.fromOffset(2, 0)
MenuScroll.BackgroundTransparency = 1
MenuScroll.BorderSizePixel = 0
MenuScroll.ScrollBarThickness = 2
MenuScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
MenuScroll.Parent = LeftMenu
local MenuLayout = Instance.new("UIListLayout")
MenuLayout.Padding = UDim.new(0, 8)
MenuLayout.Parent = MenuScroll

local RightList = Instance.new("Frame")
RightList.Size = UDim2.new(1, -160, 1, 0)
RightList.Position = UDim2.new(0, 156, 0, 0)
RightList.BackgroundTransparency = 1
RightList.Parent = Content

local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(1, -4, 1, 0)
ListScroll.Position = UDim2.fromOffset(2, 0)
ListScroll.BackgroundTransparency = 1
ListScroll.BorderSizePixel = 0
ListScroll.ScrollBarThickness = 2
ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListScroll.Parent = RightList
local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = ListScroll

-- Helpers
local function ClearList()
    for _, obj in pairs(ListScroll:GetChildren()) do
        if obj:IsA("TextButton") then obj:Destroy() end
    end
end

local function MakeMenuButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.18
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14 --左侧分类文字加大
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12)
    pad.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function MakeScriptButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.18
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13 --脚本列表文字加大
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12)
    pad.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Load functions (完整追加全部脚本)
local function SafeLoadScript(customCode, url)
    task.spawn(function()
        pcall(function()
            if customCode then
                loadstring(customCode)()
            else
                local src = game:HttpGet(url)
                loadstring(src)()
            end
        end)
    end)
end

local function LoadCommon()
    ClearList()
    local btn1 = MakeScriptButton("XK Hub(支持服务器进群)", function()
        SafeLoadScript(nil, "https://github.com/devslopo/DVES/raw/main/XK%20Hub")
    end)
    btn1.Parent = ListScroll
    local btn2 = MakeScriptButton("翻译脚本", function()
        local code = [[TX = "TX Script"
Script = "全自动翻译"
loadstring(game:HttpGet("https://raw.githubusercontent.com/JsYb666/Item/refs/heads/main/Auto-language"))()]]
        SafeLoadScript(code,nil)
    end)
    btn2.Parent = ListScroll
    local btn3 = MakeScriptButton("霖溺支持服务器详情进主页群", function()
        SafeLoadScript(nil,"https://raw.githubusercontent.com/ShenJiaoBen/ScriptLoader/refs/heads/main/Linni_FreeLoader.lua")
    end)
    btn3.Parent = ListScroll
    local btn4 = MakeScriptButton("恐脚本支持服务器进主页群", function()
        SafeLoadScript(nil,"https://raw.githubusercontent.com/kongbaNB/9178/refs/heads/main/恐脚本.NB")
    end)
    btn4.Parent = ListScroll
    local btn5 = MakeScriptButton("BS脚本", function()
        local code = [[BS = "\104\116\116\112\115\58\47\47\103\105\116\101\101\46\99\111\109\47\66\83\95\115\99\114\105\112\116\47\115\99\114\105\112\116\47\114\97\119\47\109\97\115\116\101\114\47\66\83\95\83\99\114\105\112\116\46\76\117\97\117"
loadstring(game:HttpGet(BS))()]]
        SafeLoadScript(code,nil)
    end)
    btn5.Parent = ListScroll
    local btn6 = MakeScriptButton("动画脚本", function()
        SafeLoadScript(nil,"https://rawscripts.net/raw/Universal-Script-FREE-BUNDLES-l-FE-241758")
    end)
    btn6.Parent = ListScroll
    local btn7 = MakeScriptButton("皮脚本", function()
        SafeLoadScript(nil,"https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua")
    end)
    btn7.Parent = ListScroll
    local btn8 = MakeScriptButton("公益飞行(彩虹版)", function()
        SafeLoadScript(nil,"https://pastefy.app/tkHc58Wt/raw")
    end)
    btn8.Parent = ListScroll
    local btn9 = MakeScriptButton("子追", function()
        SafeLoadScript(nil,"https://raw.githubusercontent.com/HB-ksdb/-4/main/%E5%AD%90%E8%BF%BD%E8%84%9A%E6%9C%AC%E7%A9%BF%E5%A2%99.lua")
    end)
    btn9.Parent = ListScroll
    local btn10 = MakeScriptButton("自瞄", function()
        SafeLoadScript(nil,"https://raw.githubusercontent.com/gycgchgyfytdttr/QQ-9-2-8-9-50173/refs/heads/main/cure.lua")
    end)
    btn10.Parent = ListScroll
end

local function LoadShooter()
    ClearList()
    local btn = MakeScriptButton("特种部队模拟器", function()
        SafeLoadScript(nil,"https://rawscripts.net/raw/Tactical-Simulator-Six-Hub-215287")
    end)
    btn.Parent = ListScroll
end

local function LoadRPG()
    ClearList()
    local btn1 = MakeScriptButton("圣奥里", function()
        local code = [[getgenv().XiaoPi="皮脚本-圣奥里" 
loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/Roblox-Pi-Script-SaintOrie.lua"))()]]
        SafeLoadScript(code, nil)
    end)
    btn1.Parent = ListScroll
    local btn2 = MakeScriptButton("圣地亚哥角色扮演(刷钱)", function()
        SafeLoadScript(nil,"https://paste.dot.com.in/p/csolyxih65/raw")
    end)
    btn2.Parent = ListScroll
    local btn3 = MakeScriptButton("河北唐县", function()
        local code = [[getgenv().XiaoPi="皮脚本-河北唐县"
loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/PIJIAOBEN-HEBEITANGXIAN.lua"))()]]
        SafeLoadScript(code, nil)
    end)
    btn3.Parent = ListScroll
end

local function LoadIdle()
    ClearList()
    local btn = MakeScriptButton("偷走一个蛋｜群友：搁浅(小号) 投稿", function()
        SafeLoadScript(nil,"https://raw.githubusercontent.com/kaisenlmao/loader/refs/heads/main/chiyo.lua")
    end)
    btn.Parent = ListScroll
end

local function LoadFighting() ClearList() end

local function LoadCasual()
    ClearList()
    local btn1 = MakeScriptButton("谋杀之谜MM2", function()
        SafeLoadScript(nil,"https://raw.githubusercontent.com/snxpzscripts/mm2/refs/heads/main/MozqlHub")
    end)
    btn1.Parent = ListScroll
    local btn2 = MakeScriptButton("NPC或死", function()
        SafeLoadScript(nil,"https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/BeNpcOrDie")
    end)
    btn2.Parent = ListScroll
    local btn3 = MakeScriptButton("重型钓鱼", function()
        SafeLoadScript(nil,"https://raw.githubusercontent.com/bvect1037-alt/KhfreshHub/refs/heads/main/Bmonkie")
    end)
    btn3.Parent = ListScroll
end

local function LoadCoop()
    ClearList()
    local btn1 = MakeScriptButton("动物医院", function()
        SafeLoadScript(nil,"https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FN_AnimalHospital.lua")
    end)
    btn1.Parent = ListScroll
    local btn2 = MakeScriptButton("门(群友@噬)", function()
        SafeLoadScript(nil,"https://api.luarmor.net/files/v4/loaders/730854e5b6499ee91deb1080e8e12ae3.lua")
    end)
    btn2.Parent = ListScroll
    local btn3 = MakeScriptButton("亡命速递", function()
        SafeLoadScript(nil,"https://raw.githubusercontent.com/SNSDARK/Scripts/refs/heads/main/Deadly%20Delivery.lua")
    end)
    btn3.Parent = ListScroll
end

-- 新增分类：非对称竞技
local function LoadAsymmetric()
    ClearList()
    local btn = MakeScriptButton("被遗弃(群友@噬)", function()
        SafeLoadScript(nil,"https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/ainianniang.lua")
    end)
    btn.Parent = ListScroll
end

-- Menu按钮列表：已移除【模拟器、塔防游戏】，新增【非对称竞技】
local categoryMap = {
    {"通用", LoadCommon},
    {"射击游戏", LoadShooter},
    {"角色扮演RPG", LoadRPG},
    {"休闲挂机", LoadIdle},
    {"竞技格斗", LoadFighting},
    {"休闲社交", LoadCasual},
    {"合作游戏", LoadCoop},
    {"非对称竞技", LoadAsymmetric}
}
for _, pair in ipairs(categoryMap) do
    local name, func = pair[1], pair[2]
    local btn = MakeMenuButton(name, function()
        State.CurrentCategory = name
        func()
    end)
    btn.Parent = MenuScroll
end
LoadCommon()

-- Position functions
local function SetPanelPosition(pos)
    local new = ClampPosition(pos, Vector2.new(panelWidth, panelHeight))
    State.PanelPosition = new
    Panel.Position = UDim2.fromOffset(new.X, new.Y)
end

local function SetButtonPosition(pos)
    local new = ClampPosition(pos, Vector2.new(BUTTON_SIZE, BUTTON_SIZE))
    State.ButtonPosition = new
    FloatingButton.Position = UDim2.fromOffset(new.X, new.Y)
end

local vp = GetViewport()
SetPanelPosition(Vector2.new(vp.X/2, vp.Y/2))
SetButtonPosition(Vector2.new(vp.X * 0.12, vp.Y * 0.35))

-- ═══════════════════════════════════════════════════════════
-- 先定义 Minimize 和 Restore（重要！）
-- ═══════════════════════════════════════════════════════════
local function Minimize()
    if State.Animating or State.Minimized then return end
    State.Animating = true
    local savedBtnPos = State.ButtonPosition

    FloatingButton.Position = UDim2.fromOffset(State.PanelPosition.X, State.PanelPosition.Y)
    local tween = TweenService:Create(Panel, TweenInfo.new(ANIMATION_TIME, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
        {Size = UDim2.fromOffset(BUTTON_SIZE, BUTTON_SIZE)})
    tween:Play()
    tween.Completed:Wait()

    Panel.Visible = false
    Panel.Size = UDim2.fromOffset(panelWidth, panelHeight)
    FloatingButton.Size = UDim2.fromOffset(40, 40)
    FloatingButton.Visible = true
    SetButtonPosition(savedBtnPos)

    local btnTween = TweenService:Create(FloatingButton, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.fromOffset(BUTTON_SIZE, BUTTON_SIZE)})
    btnTween:Play()

    State.Minimized = true
    State.Animating = false
end

local function Restore()
    if State.Animating or not State.Minimized then return end
    State.Animating = true

    -- 强制面板回到屏幕中央
    local vp = GetViewport()
    local centerPos = Vector2.new(vp.X / 2, vp.Y / 2)
    SetPanelPosition(centerPos)

    Panel.Size = UDim2.fromOffset(BUTTON_SIZE, BUTTON_SIZE)
    Panel.Visible = true
    FloatingButton.Visible = false

    local tween = TweenService:Create(Panel, TweenInfo.new(ANIMATION_TIME, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {Size = UDim2.fromOffset(panelWidth, panelHeight)})
    tween:Play()
    tween.Completed:Wait()

    State.Minimized = false
    State.Animating = false
end

-- ═══════════════════════════════════════════════════════════
-- 增强版拖动函数（支持点击/拖动区分）
-- ═══════════════════════════════════════════════════════════
local function EnableDrag(handle, getPos, setPos, onClick)
    local dragging = false
    local startInput, startObj, touchInput
    local beganPos = nil
    local threshold = 10

    handle.InputBegan:Connect(function(inp)
        if State.Animating then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = inp.Position
            startObj = getPos()
            beganPos = inp.Position
            if inp.UserInputType == Enum.UserInputType.Touch then touchInput = inp end
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement then
            if not startInput then return end
            setPos(startObj + (inp.Position - startInput))
        elseif inp.UserInputType == Enum.UserInputType.Touch and inp == touchInput then
            setPos(startObj + (inp.Position - startInput))
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or (inp.UserInputType == Enum.UserInputType.Touch and inp == touchInput) then
            local isClick = false
            if beganPos and inp.Position then
                local dist = (beganPos - inp.Position).Magnitude
                if dist < threshold then
                    isClick = true
                end
            end
            dragging = false
            startInput = nil; startObj = nil; touchInput = nil
            if isClick and onClick then
                onClick()
            end
            beganPos = nil
        end
    end)
end

-- 面板拖动（标题栏）
EnableDrag(DragArea, function() return State.PanelPosition end, SetPanelPosition, nil)

-- 按钮拖动 + 点击恢复（此时 Restore 已定义）
EnableDrag(FloatingButton, function() return State.ButtonPosition end, SetButtonPosition, function()
    if not State.Animating then
        Restore()
    end
end)

-- 关闭按钮最小化
CloseBtn.Activated:Connect(Minimize)

-- 视口变化处理
local cam = workspace.CurrentCamera
if cam then
    cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if State.Minimized then
            SetButtonPosition(State.ButtonPosition)
        else
            SetPanelPosition(State.PanelPosition)
        end
    end)
end

-- 初始状态
Panel.Visible = true
FloatingButton.Visible = false
State.Minimized = false

print("✅ DB Panel | 配色：半透纯黑，文字适度增大版本加载完成")
