--========================================================--
--   DB Panel · 最终版（尺寸已调小）
--========================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function GetViewport()
    local cam = workspace.CurrentCamera
    if not cam then cam = workspace:WaitForChild("CurrentCamera", 2) end
    return cam and cam.ViewportSize or Vector2.new(1920, 1080)
end

local viewport = GetViewport()
local baseW, baseH = 550, 370
local panelWidth = math.clamp(viewport.X * 0.62, 380, baseW)
local panelHeight = math.clamp(panelWidth * (baseH / baseW), 260, baseH)
local BUTTON_SIZE = 56
local CORNER_RADIUS = 16
local ANIMATION_TIME = 0.35

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "DB_Panel_Fixed"
MainGui.ResetOnSpawn = false
MainGui.IgnoreGuiInset = true
MainGui.DisplayOrder = 999
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local State = {
    PanelPosition = nil,
    ButtonPosition = nil,
    Animating = false,
    Minimized = false,
    CurrentCategory = "通用",
    ButtonHidden = false,
    HideSide = "none"
}

local function ClampPosition(pos, size)
    local vp = GetViewport()
    local hx, hy = size.X/2, size.Y/2
    return Vector2.new(
        math.clamp(pos.X, -hx, vp.X + hx),
        math.clamp(pos.Y, -hy, vp.Y + hy)
    )
end

local Rainbow = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,55,75)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,170,50)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(255,240,60)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(65,255,125)),
    ColorSequenceKeypoint.new(0.64, Color3.fromRGB(55,205,255)),
    ColorSequenceKeypoint.new(0.80, Color3.fromRGB(125,70,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,55,190))
})

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

local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingButton.Size = UDim2.fromOffset(BUTTON_SIZE, BUTTON_SIZE)
FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FloatingButton.BackgroundTransparency = 0.25
FloatingButton.BorderSizePixel = 0
FloatingButton.Text = "DB"
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.TextSize = 22
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
Title.Text = "数据库"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
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
Subtitle.TextSize = 11
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
CloseBtn.TextSize = 30
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 30
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,12)
CloseCorner.Parent = CloseBtn

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

--========================================================--
--   脚本数据库定义（含所有新增脚本）
--========================================================--
local ScriptDatabase = {
    ["通用"] = {
        {Name = "飞行", Code = [[loadstring(game:HttpGet("https://pastefy.app/tkHc58Wt/raw"))()]]},
        {Name = "子追", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/HB-ksdb/-4/main/%E5%AD%90%E8%BF%BD%E8%84%9A%E6%9C%AC%E7%A9%BF%E5%A2%99.lua"))()]]},
        {Name = "自瞄", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/QQ-9-2-8-9-50173/refs/heads/main/cure.lua"))()]]},
        {Name = "XK Hub(支持服务器进群)", Url = "https://github.com/devslopo/DVES/raw/main/XK%20Hub"},
        {Name = "翻译脚本", Code = [[TX = "TX Script"; Script = "全自动翻译"; loadstring(game:HttpGet("https://raw.githubusercontent.com/JsYb666/Item/refs/heads/main/Auto-language"))()]]},
        {Name = "霖溺支持服务器详情进主页群", Url = "https://raw.githubusercontent.com/ShenJiaoBen/ScriptLoader/refs/heads/main/Linni_FreeLoader.lua"},
        {Name = "恐脚本支持服务器进主页群", Url = "https://raw.githubusercontent.com/kongbaNB/9178/refs/heads/main/恐脚本.NB"},
        {Name = "BS脚本", Code = [[local BS = "\104\116\116\112\115\58\47\47\103\105\116\101\101\46\99\111\109\47\66\83\95\115\99\114\105\112\116\47\115\99\114\105\112\116\47\114\97\119\47\109\97\115\116\101\114\47\66\83\95\83\99\114\105\112\116\46\76\117\97\117"; loadstring(game:HttpGet(BS))()]]},
        {Name = "动画脚本", Url = "https://rawscripts.net/raw/Universal-Script-FREE-BUNDLES-l-FE-241758"},
        {Name = "皮脚本", Url = "https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua"},
        {Name = "TrashHub", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/WasKKal/OnlyJumpToOther/main/loader.lua"))()]]},
        {Name = "隐身", Code = [[loadstring(game:HttpGet('https://pastefy.app/6zjosppv/raw'))()]]},
        {Name = "霖溺通用", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ShenJiaoBen/Partial-Server-Ribbon/refs/heads/main/Linni_Universal.txt"))()]]}
    },
    ["射击游戏"] = {
        {Name = "特种部队模拟器", Url = "https://rawscripts.net/raw/Tactical:-Swat-Simulator-Six-Hub-215287"},
        {Name = "刀战竞技场", Url = "https://rawscripts.net/raw/FPSKnife-Arena-Script-Auto-Kill-And-Speed-And-More-No-Key-102295"},
        {Name = "狙击竞技场", Url = "https://rawscripts.net/raw/GAMEMODE-Sniper-Arena-Script-ESP-Aimbot-Auto-Fire-Keyless-206741"},
        {Name = "战斗竞技场", Url = "https://pastebin.com/raw/bJvbP48n"},
        {Name = "刀对决", Url = "https://raw.githubusercontent.com/imshrak/knifeduels/main/menu"},
        {Name = "手枪竞技场", Url = "https://rawscripts.net/raw/Pistol-Arena-Vodka-hub-keyless-op-201209"},
        {Name = "监狱人生(不好用可以用XK)", Code = [[loadstring(game:HttpGet("https://rawscripts.net/raw/Prison-Life-auto-arrest-inf-jump-teleport-and-etc-242404"))()]]},
        {Name = "莱克星顿和康科德(LC)", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Matds78/Script/refs/heads/main/LC"))()]]},
        {Name = "杀手VS警长", Code = [[loadstring(game:HttpGet("https://rawscripts.net/raw/DUELS-Murderers-VS-Sheriffs-BEST-SCRIPT-SILENT-AIM-AIMBOT-ESP-RAGEBOT-AND-ALOT-MORE-227237"))()]]},
        {Name = "凶手VS警长决斗", Code = [[loadstring(game:HttpGet("https://rawscripts.net/raw/Murderers-VS-Sheriffs-DUELS-mvsd-script-open-source-many-features-undetected-244205"))()]]}
    },
    ["角色扮演RPG"] = {
        {Name = "圣奥里", Code = [[getgenv().XiaoPi="皮脚本-圣奥里"; loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/Roblox-Pi-Script-SaintOrie.lua"))()]]},
        {Name = "圣地亚哥角色扮演(刷钱)", Url = "https://paste.dot.com.in/p/csolyxih65/raw"},
        {Name = "河北唐县", Code = [[getgenv().XiaoPi="皮脚本-河北唐县"; loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaopi77/xiaopi77/refs/heads/main/PIJIAOBEN-HEBEITANGXIAN.lua"))()]]},
        {Name = "恶名昭彰收获日体验", Code = [[loadstring(game:HttpGet("https://rawscripts.net/raw/Notoriety:-A-PAYDAY(r)-Experience-XXMZ-HUB-177374"))()]]}
    },
    ["休闲挂机"] = {
        {Name = "偷走一个蛋｜群友：搁浅(小号) 投稿", Url = "https://raw.githubusercontent.com/kaisenlmao/loader/refs/heads/main/chiyo.lua"},
        {Name = "踢一个幸运方块", Url = "https://raw.githubusercontent.com/fartez127-design/FARTEZHUB/refs/heads/main/FARTEZHUBXKickaLuckyBlock"},
        {Name = "偷一个蛋", Code = [[loadstring(game:HttpGet("https://solixhub.com/loader"))()]]},
        {Name = "重型钓鱼(脚本不能用看群公告)", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/linni-fish/HeavyFishing/main/Fishing.lua"))()]]}
    },
    ["竞技格斗"] = {},
    ["休闲社交"] = {
        {Name = "谋杀之谜MM2", Url = "https://raw.githubusercontent.com/snxpzscripts/mm2/refs/heads/main/MozqlHub"},
        {Name = "NPC或死", Code = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/ToraScript/Script/main/BENPCORDIE', true))()]]},
        {Name = "画我", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/KENNY画我.lua"))()]]}
    },
    ["合作游戏"] = {
        {Name = "动物医院", Url = "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FN_AnimalHospital.lua"},
        {Name = "门｜群友提供@噬", Url = "https://api.luarmor.net/files/v4/loaders/730854e5b6499ee91deb1080e8e12ae3.lua"},
        {Name = "恐鬼症", Code = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/Aoruen/Roblox-Stuff/refs/heads/main/Dusty%20Trip%20Gui%20V2.lua'))()]]},
        {Name = "森林中的99夜", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua"))()]]},
        {Name = "彩虹朋友1", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Iliankytb/Iliankytb/main/BestRainbowFriendOne"))()]]},
        {Name = "死铁轨", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/erewe23/deadrailsring.github.io/refs/heads/main/ringta.lua"))()]]}
    },
    ["非对称竞技"] = {
        {Name = "被遗弃｜群友提供@噬", Url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/ainianniang.lua"},
        {Name = "致命猿猴", Url = "https://raw.githubusercontent.com/Anzzckc/Lethal-Ape-Beta/refs/heads/main/Lethal%20Ape%20Beta.lua"},
        {Name = "暴力区", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/lixxWW/ViolenceDistrict/refs/heads/main/ViolenceDistrict.lua"))()]]}
    },
    ["塔防游戏"] = {
        {Name = "战斗砖块", Url = "https://rawscripts.net/raw/The-Battle-Bricks-auto-play-no-key-141463"}
    }
}

--========================================================--
--   核心执行与UI点击逻辑
--========================================================--

local function SafeLoadScript(item)
    task.spawn(function()
        local success, err = pcall(function()
            if item.Code then
                loadstring(item.Code)()
            elseif item.Url then
                local src = game:HttpGet(item.Url)
                loadstring(src)()
            end
        end)
        if not success then
            warn("❌ 脚本加载失败: " .. tostring(err))
        end
    end)
end

local function ApplySafeClickEffect(btn, onClick)
    btn.Activated:Connect(function()
        local origBg = btn.BackgroundColor3
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = origBg}):Play()
        if onClick then
            onClick()
        end
    end)
end

local function RenderRightList(categoryName)
    for _, child in ipairs(ListScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local list = ScriptDatabase[categoryName] or {}
    for _, item in ipairs(list) do
        local btn = Instance.new("TextButton")
        btn.Name = item.Name
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Text = item.Name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamMedium
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 12)
        pad.Parent = btn

        ApplySafeClickEffect(btn, function()
            SafeLoadScript(item)
        end)

        btn.Parent = ListScroll
    end
end

local categoriesOrder = {
    "通用", "射击游戏", "角色扮演RPG", "休闲挂机",
    "竞技格斗", "休闲社交", "合作游戏", "非对称竞技", "塔防游戏"
}

for _, catName in ipairs(categoriesOrder) do
    local btn = Instance.new("TextButton")
    btn.Name = "Category_" .. catName
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.BackgroundTransparency = 0.25
    btn.BorderSizePixel = 0
    btn.Text = catName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12)
    pad.Parent = btn

    ApplySafeClickEffect(btn, function()
        State.CurrentCategory = catName
        RenderRightList(catName)
    end)

    btn.Parent = MenuScroll
end

RenderRightList("通用")

--========================================================--
--   窗口拖拽、最小化与位置计算
--========================================================--

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
    State.ButtonHidden = false
    State.HideSide = "none"
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

    if State.ButtonHidden then
        local restorePos = State.ButtonPosition
        if not restorePos then
            local vp = GetViewport()
            restorePos = Vector2.new(vp.X * 0.12, vp.Y * 0.35)
        end
        local vp = GetViewport()
        local half = BUTTON_SIZE / 2
        restorePos = Vector2.new(
            math.clamp(restorePos.X, half, vp.X - half),
            math.clamp(restorePos.Y, half, vp.Y - half)
        )
        SetButtonPosition(restorePos)
        State.ButtonHidden = false
        State.HideSide = "none"
        task.wait(0.05)
    end

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

local function EnableDrag(handle, getPos, setPos)
    local dragging = false
    local startInput, startObj, touchInput
    local beganPos = nil

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
            dragging = false
            startInput = nil; startObj = nil; touchInput = nil
            beganPos = nil
        end
    end)
end

EnableDrag(DragArea, function() return State.PanelPosition end, SetPanelPosition)

local btnDragging = false
local btnDragStartPos = nil
local btnDragStartMouse = nil
local dragDistance = 0
local CLICK_THRESHOLD = 10
local EDGE_SNAP_DIST = 60
local currentTween = nil

local function SnapToEdge()
    if currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing then
        currentTween:Cancel()
        currentTween = nil
    end
    local vp = GetViewport()
    local btnPos = FloatingButton.Position
    local x = btnPos.X.Offset
    local y = btnPos.Y.Offset
    local halfSize = BUTTON_SIZE / 2
    local edgeDistLeft = x - halfSize
    local edgeDistRight = (vp.X - halfSize) - x
    if State.ButtonHidden then return end
    local snap = false
    local newX = x
    local side = "none"
    if edgeDistLeft < EDGE_SNAP_DIST and edgeDistLeft < edgeDistRight then
        newX = 10 + halfSize
        side = "left"
        snap = true
    elseif edgeDistRight < EDGE_SNAP_DIST and edgeDistRight < edgeDistLeft then
        newX = vp.X - 10 - halfSize
        side = "right"
        snap = true
    end
    if snap then
        local targetPos = Vector2.new(newX, y)
        currentTween = TweenService:Create(FloatingButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.fromOffset(targetPos.X, targetPos.Y)})
        currentTween:Play()
        currentTween.Completed:Connect(function() currentTween = nil end)
        State.ButtonHidden = true
        State.HideSide = side
        State.ButtonPosition = targetPos
    else
        local clampedX = math.clamp(x, halfSize, vp.X - halfSize)
        local clampedY = math.clamp(y, halfSize, vp.Y - halfSize)
        if clampedX ~= x or clampedY ~= y then
            local targetPos = Vector2.new(clampedX, clampedY)
            FloatingButton.Position = UDim2.fromOffset(targetPos.X, targetPos.Y)
            State.ButtonPosition = targetPos
        else
            State.ButtonPosition = Vector2.new(x, y)
        end
    end
end

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true
        btnDragStartPos = FloatingButton.Position
        btnDragStartMouse = input.Position
        dragDistance = 0
        if currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing then
            currentTween:Cancel()
            currentTween = nil
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not btnDragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - btnDragStartMouse
        dragDistance = dragDistance + delta.Magnitude
        local newX = btnDragStartPos.X.Offset + delta.X
        local newY = btnDragStartPos.Y.Offset + delta.Y
        local vp = GetViewport()
        local halfSize = BUTTON_SIZE / 2
        newX = math.clamp(newX, -halfSize + 5, vp.X + halfSize - 5)
        newY = math.clamp(newY, halfSize, vp.Y - halfSize)
        FloatingButton.Position = UDim2.fromOffset(newX, newY)
        State.ButtonPosition = Vector2.new(newX, newY)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if btnDragging then
            local dist = dragDistance
            btnDragging = false
            btnDragStartPos = nil
            btnDragStartMouse = nil
            if dist < CLICK_THRESHOLD then
                if State.ButtonHidden then
                    local vp = GetViewport()
                    local half = BUTTON_SIZE / 2
                    local restoreX = math.clamp(State.ButtonPosition.X, half, vp.X - half)
                    local restoreY = math.clamp(State.ButtonPosition.Y, half, vp.Y - half)
                    local restorePos = Vector2.new(restoreX, restoreY)
                    SetButtonPosition(restorePos)
                    State.ButtonHidden = false
                    State.HideSide = "none"
                    task.wait(0.05)
                end
                if State.Minimized and not State.Animating then
                    Restore()
                end
            else
                SnapToEdge()
            end
        end
    end
end)

CloseBtn.Activated:Connect(Minimize)

Panel.Visible = true
FloatingButton.Visible = false
State.Minimized = false
State.ButtonHidden = false
State.HideSide = "none"

print("✅ DB Panel 已加载（尺寸已调小）")
