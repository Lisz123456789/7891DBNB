--========================================================--
--   DB Panel · 延长开场 + 右下系统弹窗版
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
local MIN_PANEL_WIDTH = 360
local MIN_PANEL_HEIGHT = 250

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "DB_Panel_Fixed"
MainGui.ResetOnSpawn = false
MainGui.IgnoreGuiInset = true
MainGui.DisplayOrder = 999
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.Parent = LocalPlayer:WaitForChild("PlayerGui")


--========================================================--
--   DB 开场动画 · 极简附魔版
--   仅保留：25颗彩球 / DB / 附魔质感 / 欢迎语
--========================================================--
local IntroGui = Instance.new("Frame")
IntroGui.Name = "DB_Intro"
IntroGui.Size = UDim2.fromScale(1, 1)
IntroGui.Position = UDim2.fromScale(0, 0)
IntroGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
IntroGui.BackgroundTransparency = 1
IntroGui.BorderSizePixel = 0
IntroGui.ZIndex = 10000
IntroGui.Active = true
IntroGui.ClipsDescendants = true
IntroGui.Parent = MainGui

local IntroRandom = Random.new()

local function IntroTween(obj, duration, props, style, direction)
    local tween = TweenService:Create(
        obj,
        TweenInfo.new(
            duration,
            style or Enum.EasingStyle.Quad,
            direction or Enum.EasingDirection.Out
        ),
        props
    )
    tween:Play()
    return tween
end

-- 25颗小彩球
local BallLayer = Instance.new("Frame")
BallLayer.Name = "BallLayer"
BallLayer.Size = UDim2.fromScale(1, 1)
BallLayer.BackgroundTransparency = 1
BallLayer.BorderSizePixel = 0
BallLayer.ClipsDescendants = true
BallLayer.ZIndex = 10001
BallLayer.Parent = IntroGui

local BallColors = {
    Color3.fromRGB(255, 92, 123),
    Color3.fromRGB(255, 172, 89),
    Color3.fromRGB(255, 228, 105),
    Color3.fromRGB(90, 236, 164),
    Color3.fromRGB(80, 218, 255),
    Color3.fromRGB(102, 148, 255),
    Color3.fromRGB(174, 112, 255),
    Color3.fromRGB(255, 112, 220)
}

local Balls = {}

local function CreateIntroBall(index)
    local size = IntroRandom:NextInteger(5, 12)
    local ball = Instance.new("Frame")
    ball.Name = "Ball_" .. index
    ball.AnchorPoint = Vector2.new(0.5, 0.5)
    ball.Size = UDim2.fromOffset(size, size)
    ball.Position = UDim2.fromScale(
        IntroRandom:NextNumber(0.025, 0.975),
        IntroRandom:NextNumber(0.04, 0.96)
    )
    ball.BackgroundColor3 = BallColors[IntroRandom:NextInteger(1, #BallColors)]
    ball.BackgroundTransparency = 1
    ball.BorderSizePixel = 0
    ball.ZIndex = 10001
    ball.Parent = BallLayer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ball

    ball:SetAttribute("VisibleTransparency", IntroRandom:NextNumber(0.28, 0.56))
    table.insert(Balls, ball)

    task.spawn(function()
        while ball.Parent and IntroGui.Parent do
            local moveTween = IntroTween(
                ball,
                IntroRandom:NextNumber(1.35, 2.65),
                {
                    Position = UDim2.fromScale(
                        IntroRandom:NextNumber(-0.025, 1.025),
                        IntroRandom:NextNumber(-0.025, 1.025)
                    )
                },
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            )
            moveTween.Completed:Wait()
            task.wait(IntroRandom:NextNumber(0.03, 0.14))
        end
    end)
end

for i = 1, 25 do
    CreateIntroBall(i)
end

-- DB 附魔：核心字始终纯白，仅让外层光影流动
local DBGroup = Instance.new("Frame")
DBGroup.Name = "DBEnchantLogo"
DBGroup.AnchorPoint = Vector2.new(0.5, 0.5)
DBGroup.Position = UDim2.fromScale(0.5, 0.43)
DBGroup.Size = UDim2.fromOffset(270, 130)
DBGroup.BackgroundTransparency = 1
DBGroup.ZIndex = 10005
DBGroup.Parent = IntroGui

local DBScale = Instance.new("UIScale")
DBScale.Scale = 0.86
DBScale.Parent = DBGroup

local DBShadow = Instance.new("TextLabel")
DBShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DBShadow.Position = UDim2.new(0.5, 3, 0.5, 4)
DBShadow.Size = UDim2.fromScale(1, 1)
DBShadow.BackgroundTransparency = 1
DBShadow.Text = "DB"
DBShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
DBShadow.TextTransparency = 1
DBShadow.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
DBShadow.TextStrokeTransparency = 1
DBShadow.TextSize = 84
DBShadow.Font = Enum.Font.GothamBlack
DBShadow.ZIndex = 10005
DBShadow.Parent = DBGroup

local DBGlowViolet = Instance.new("TextLabel")
DBGlowViolet.AnchorPoint = Vector2.new(0.5, 0.5)
DBGlowViolet.Position = UDim2.fromScale(0.5, 0.5)
DBGlowViolet.Size = UDim2.new(1, 18, 1, 18)
DBGlowViolet.BackgroundTransparency = 1
DBGlowViolet.Text = "DB"
DBGlowViolet.TextColor3 = Color3.fromRGB(186, 155, 255)
DBGlowViolet.TextTransparency = 1
DBGlowViolet.TextStrokeColor3 = Color3.fromRGB(130, 105, 255)
DBGlowViolet.TextStrokeTransparency = 1
DBGlowViolet.TextSize = 88
DBGlowViolet.Font = Enum.Font.GothamBlack
DBGlowViolet.ZIndex = 10006
DBGlowViolet.Parent = DBGroup

local DBGlowIce = Instance.new("TextLabel")
DBGlowIce.AnchorPoint = Vector2.new(0.5, 0.5)
DBGlowIce.Position = UDim2.fromScale(0.5, 0.5)
DBGlowIce.Size = UDim2.new(1, 10, 1, 10)
DBGlowIce.BackgroundTransparency = 1
DBGlowIce.Text = "DB"
DBGlowIce.TextColor3 = Color3.fromRGB(170, 232, 255)
DBGlowIce.TextTransparency = 1
DBGlowIce.TextStrokeColor3 = Color3.fromRGB(112, 210, 255)
DBGlowIce.TextStrokeTransparency = 1
DBGlowIce.TextSize = 86
DBGlowIce.Font = Enum.Font.GothamBlack
DBGlowIce.ZIndex = 10007
DBGlowIce.Parent = DBGroup

local DBText = Instance.new("TextLabel")
DBText.AnchorPoint = Vector2.new(0.5, 0.5)
DBText.Position = UDim2.fromScale(0.5, 0.5)
DBText.Size = UDim2.fromScale(1, 1)
DBText.BackgroundTransparency = 1
DBText.Text = "DB"
DBText.TextColor3 = Color3.fromRGB(255, 255, 255)
DBText.TextTransparency = 1
DBText.TextStrokeTransparency = 1
DBText.TextSize = 84
DBText.Font = Enum.Font.GothamBlack
DBText.ZIndex = 10009
DBText.Parent = DBGroup

-- 一道非常克制的附魔扫光，只扫过白色 DB
local SweepText = Instance.new("TextLabel")
SweepText.AnchorPoint = Vector2.new(0.5, 0.5)
SweepText.Position = UDim2.fromScale(0.5, 0.5)
SweepText.Size = UDim2.fromScale(1, 1)
SweepText.BackgroundTransparency = 1
SweepText.Text = "DB"
SweepText.TextColor3 = Color3.fromRGB(255, 255, 255)
SweepText.TextTransparency = 0
SweepText.TextSize = 84
SweepText.Font = Enum.Font.GothamBlack
SweepText.ZIndex = 10010
SweepText.Parent = DBGroup

local SweepGradient = Instance.new("UIGradient")
SweepGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(175, 145, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(155, 225, 255))
})
SweepGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.42, 1),
    NumberSequenceKeypoint.new(0.50, 0.10),
    NumberSequenceKeypoint.new(0.58, 1),
    NumberSequenceKeypoint.new(1, 1)
})
SweepGradient.Offset = Vector2.new(-1.2, 0)
SweepGradient.Rotation = 18
SweepGradient.Parent = SweepText

local WelcomeText = Instance.new("TextLabel")
WelcomeText.Name = "WelcomeText"
WelcomeText.AnchorPoint = Vector2.new(0.5, 1)
WelcomeText.Position = UDim2.new(0.5, 0, 0.94, 0)
WelcomeText.Size = UDim2.new(0.9, 0, 0, 32)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "欢迎：" .. LocalPlayer.Name
WelcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeText.TextTransparency = 1
WelcomeText.TextSize = 16
WelcomeText.Font = Enum.Font.GothamMedium
WelcomeText.TextXAlignment = Enum.TextXAlignment.Center
WelcomeText.ZIndex = 10008
WelcomeText.Parent = IntroGui

local CurtainIn = IntroTween(IntroGui, 0.32, {BackgroundTransparency = 0.25})
for _, ball in ipairs(Balls) do
    IntroTween(
        ball,
        IntroRandom:NextNumber(0.25, 0.45),
        {BackgroundTransparency = ball:GetAttribute("VisibleTransparency") or 0.42}
    )
end
CurtainIn.Completed:Wait()

IntroTween(DBShadow, 0.36, {TextTransparency = 0.64, TextStrokeTransparency = 0.78})
IntroTween(DBGlowViolet, 0.42, {TextTransparency = 0.72, TextStrokeTransparency = 0.70})
IntroTween(DBGlowIce, 0.42, {TextTransparency = 0.76, TextStrokeTransparency = 0.74})
IntroTween(DBText, 0.42, {TextTransparency = 0})
IntroTween(DBScale, 0.52, {Scale = 1}, Enum.EasingStyle.Back)
task.wait(0.14)
IntroTween(WelcomeText, 0.38, {TextTransparency = 0})

-- 附魔扫光循环：低频，不花哨
local sweepAlive = true
task.spawn(function()
    while sweepAlive and SweepGradient.Parent do
        SweepGradient.Offset = Vector2.new(-1.2, 0)
        local sw = IntroTween(
            SweepGradient,
            0.78,
            {Offset = Vector2.new(1.2, 0)},
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut
        )
        sw.Completed:Wait()
        task.wait(0.45)
    end
end)

-- 微弱呼吸，强调"附魔"而不是霓虹
local glowAlive = true
task.spawn(function()
    while glowAlive and DBGlowIce.Parent do
        IntroTween(DBGlowIce, 0.55, {TextTransparency = 0.68, TextStrokeTransparency = 0.64}, Enum.EasingStyle.Sine)
        IntroTween(DBGlowViolet, 0.55, {TextTransparency = 0.76, TextStrokeTransparency = 0.70}, Enum.EasingStyle.Sine)
        task.wait(0.55)
        IntroTween(DBGlowIce, 0.55, {TextTransparency = 0.82, TextStrokeTransparency = 0.78}, Enum.EasingStyle.Sine)
        IntroTween(DBGlowViolet, 0.55, {TextTransparency = 0.84, TextStrokeTransparency = 0.80}, Enum.EasingStyle.Sine)
        task.wait(0.55)
    end
end)

task.wait(2.35)
sweepAlive = false
glowAlive = false

IntroTween(DBText, 0.34, {TextTransparency = 1})
IntroTween(DBShadow, 0.34, {TextTransparency = 1, TextStrokeTransparency = 1})
IntroTween(DBGlowIce, 0.34, {TextTransparency = 1, TextStrokeTransparency = 1})
IntroTween(DBGlowViolet, 0.34, {TextTransparency = 1, TextStrokeTransparency = 1})
IntroTween(SweepText, 0.34, {TextTransparency = 1})
IntroTween(WelcomeText, 0.30, {TextTransparency = 1})
for _, ball in ipairs(Balls) do
    if ball.Parent then
        IntroTween(ball, 0.32, {BackgroundTransparency = 1})
    end
end

local CurtainOut = IntroTween(
    IntroGui,
    0.50,
    {BackgroundTransparency = 1},
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.InOut
)
CurtainOut.Completed:Wait()
IntroGui:Destroy()

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

--========================================================--
--   经典黑透 UI · 超窄彩虹流动边缘
--   不再使用液态玻璃 / 磨砂玻璃
--========================================================--

local UI = {
    Panel = Color3.fromRGB(0, 0, 0),
    Button = Color3.fromRGB(12, 12, 14),
    ButtonHover = Color3.fromRGB(25, 25, 29),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(205, 205, 210)
}

-- 首尾颜色保持一致，360°循环时不会出现明显跳变
local RAINBOW_FLOW = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 65, 95)),
    ColorSequenceKeypoint.new(0.14, Color3.fromRGB(255, 155, 55)),
    ColorSequenceKeypoint.new(0.28, Color3.fromRGB(255, 235, 70)),
    ColorSequenceKeypoint.new(0.43, Color3.fromRGB(65, 240, 135)),
    ColorSequenceKeypoint.new(0.58, Color3.fromRGB(55, 205, 255)),
    ColorSequenceKeypoint.new(0.72, Color3.fromRGB(95, 105, 255)),
    ColorSequenceKeypoint.new(0.86, Color3.fromRGB(210, 70, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 65, 95))
})

local function AddCorner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
    return c
end

-- TweenService 连续旋转，不使用每帧 +1° 的方式
local function StartRainbowFlow(parent, duration, transparency)
    local grad = Instance.new("UIGradient")
    grad.Name = "RainbowFlow"
    grad.Color = RAINBOW_FLOW
    grad.Transparency = transparency or NumberSequence.new(0)
    grad.Rotation = -180
    grad.Parent = parent

    local tw = TweenService:Create(
        grad,
        TweenInfo.new(
            duration or 2.0,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            -1,
            false,
            0
        ),
        {Rotation = 180}
    )
    tw:Play()

    return grad, tw
end

local function AddRainbowBorder(obj, thickness, transparency, speed)
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = thickness or 0.9
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Transparency = transparency or 0.04
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = obj

    local grad = StartRainbowFlow(stroke, speed or 1.95)
    return stroke, grad
end

--========================================================--
--   右下角系统通知
--   尺寸参考 Roblox 官方好友/系统通知的紧凑横向卡片
--========================================================--

local NotificationLayer = Instance.new("Frame")
NotificationLayer.Name = "DB_NotificationLayer"
NotificationLayer.Size = UDim2.fromScale(1, 1)
NotificationLayer.BackgroundTransparency = 1
NotificationLayer.BorderSizePixel = 0
NotificationLayer.ZIndex = 800
NotificationLayer.Parent = MainGui

local ActiveNotification = nil

local function ShowDBNotification(titleText, bodyText, isSuccess)

    -- 有旧通知时先移除，避免叠在一起
    if ActiveNotification and ActiveNotification.Parent then
        ActiveNotification:Destroy()
        ActiveNotification = nil
    end

    local vp = GetViewport()

    -- 官方系统弹窗式紧凑比例：横向、圆角、右下角
    local cardW = math.clamp(vp.X * 0.22, 285, 360)
    local cardH = math.clamp(vp.Y * 0.10, 78, 96)

    local Card = Instance.new("Frame")
    Card.Name = "DB_SystemNotification"
    Card.AnchorPoint = Vector2.new(1, 1)
    Card.Position = UDim2.new(1, 18, 1, -22)
    Card.Size = UDim2.fromOffset(cardW, cardH)
    Card.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
    Card.BackgroundTransparency = 0.16
    Card.BorderSizePixel = 0
    Card.ZIndex = 810
    Card.Parent = NotificationLayer

    AddCorner(Card, 16)

    local Stroke, StrokeGrad = AddRainbowBorder(
        Card,
        1.45,
        0.02,
        2.35
    )

    -- 左侧状态图标
    local Icon = Instance.new("TextLabel")
    Icon.Name = "StatusIcon"
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.Position = UDim2.new(0, 15, 0.5, 0)
    Icon.Size = UDim2.fromOffset(34, 34)
    Icon.BackgroundTransparency = 1
    Icon.Text = isSuccess and "✓" or "!"
    Icon.TextColor3 = isSuccess
        and Color3.fromRGB(235, 255, 242)
        or Color3.fromRGB(255, 225, 225)
    Icon.TextSize = 27
    Icon.Font = Enum.Font.GothamBold
    Icon.TextXAlignment = Enum.TextXAlignment.Center
    Icon.TextYAlignment = Enum.TextYAlignment.Center
    Icon.ZIndex = 812
    Icon.Parent = Card

    local IconRing = Instance.new("Frame")
    IconRing.AnchorPoint = Vector2.new(0.5, 0.5)
    IconRing.Position = UDim2.new(0, 32, 0.5, 0)
    IconRing.Size = UDim2.fromOffset(40, 40)
    IconRing.BackgroundTransparency = 1
    IconRing.BorderSizePixel = 0
    IconRing.ZIndex = 811
    IconRing.Parent = Card
    AddCorner(IconRing, 999)

    local IconStroke = Instance.new("UIStroke")
    IconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    IconStroke.Thickness = 1.1
    IconStroke.Color = isSuccess
        and Color3.fromRGB(128, 235, 180)
        or Color3.fromRGB(255, 125, 125)
    IconStroke.Transparency = 0.25
    IconStroke.Parent = IconRing

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.fromOffset(60, 13)
    TitleLabel.Size = UDim2.new(1, -76, 0, 27)
    TitleLabel.Text = titleText
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextTransparency = 0
    TitleLabel.TextSize = 17
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
    TitleLabel.ZIndex = 812
    TitleLabel.Parent = Card

    local BodyLabel = Instance.new("TextLabel")
    BodyLabel.Name = "Body"
    BodyLabel.BackgroundTransparency = 1
    BodyLabel.Position = UDim2.fromOffset(60, 40)
    BodyLabel.Size = UDim2.new(1, -76, 0, 27)
    BodyLabel.Text = bodyText
    BodyLabel.TextColor3 = Color3.fromRGB(205, 208, 216)
    BodyLabel.TextTransparency = 0
    BodyLabel.TextSize = 13
    BodyLabel.Font = Enum.Font.GothamMedium
    BodyLabel.TextXAlignment = Enum.TextXAlignment.Left
    BodyLabel.TextYAlignment = Enum.TextYAlignment.Center
    BodyLabel.TextWrapped = true
    BodyLabel.ZIndex = 812
    BodyLabel.Parent = Card

    ActiveNotification = Card

    -- 从右侧滑入
    TweenService:Create(
        Card,
        TweenInfo.new(
            0.34,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Position = UDim2.new(1, -18, 1, -22)
        }
    ):Play()

    -- 稍作停留
    task.delay(3.6, function()
        if not Card or not Card.Parent then
            return
        end

        local OutTween = TweenService:Create(
            Card,
            TweenInfo.new(
                0.28,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.In
            ),
            {
                Position = UDim2.new(1, 26, 1, -22),
                BackgroundTransparency = 1
            }
        )

        OutTween:Play()

        TweenService:Create(
            TitleLabel,
            TweenInfo.new(0.22),
            {TextTransparency = 1}
        ):Play()

        TweenService:Create(
            BodyLabel,
            TweenInfo.new(0.22),
            {TextTransparency = 1}
        ):Play()

        TweenService:Create(
            Icon,
            TweenInfo.new(0.22),
            {TextTransparency = 1}
        ):Play()

        TweenService:Create(
            Stroke,
            TweenInfo.new(0.22),
            {Transparency = 1}
        ):Play()

        OutTween.Completed:Wait()

        if Card and Card.Parent then
            Card:Destroy()
        end

        if ActiveNotification == Card then
            ActiveNotification = nil
        end
    end)
end


--========================================================--
--   主窗口
--========================================================--

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
Body.BackgroundColor3 = UI.Panel
Body.BackgroundTransparency = 0.30
Body.BorderSizePixel = 0
Body.ClipsDescendants = true
Body.ZIndex = 2
Body.Parent = Panel
AddCorner(Body, CORNER_RADIUS)

-- 主面板：比最原始 2px 更窄，只保留一条干净彩虹边
local PanelBorder, PanelBorderGradient = AddRainbowBorder(
    Body,
    1.65,
    0.02,
    2.75
)

--========================================================--
--   通用按钮风格
--   重要：绝不把 UIGradient 挂在 TextButton 本体上，
--   避免再次把按钮文字染暗。
--========================================================--

local function StyleLiquidButton(btn, radius, strong)
    radius = radius or 9

    btn.BackgroundColor3 = UI.Button
    btn.BackgroundTransparency = strong and 0.18 or 0.24
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true

    -- 功能按钮保持干净纯白字体
    btn.TextColor3 = UI.Text
    btn.TextTransparency = 0

    AddCorner(btn, radius)

    -- 普通功能按钮不再使用彩虹描边。
    -- 只保留一条很低调的深灰细边，避免视觉过于"鬼畜"。
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = strong and 0.85 or 0.70
    stroke.Color = strong
        and Color3.fromRGB(72, 76, 84)
        or Color3.fromRGB(53, 57, 64)
    stroke.Transparency = strong and 0.20 or 0.32
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = btn

    local scale = Instance.new("UIScale")
    scale.Scale = 1
    scale.Parent = btn

    btn.MouseEnter:Connect(function()
        if not btn.Parent then return end

        TweenService:Create(
            btn,
            TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                BackgroundColor3 = UI.ButtonHover,
                BackgroundTransparency = strong and 0.12 or 0.16
            }
        ):Play()

        TweenService:Create(
            scale,
            TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Scale = 1.006}
        ):Play()

        TweenService:Create(
            stroke,
            TweenInfo.new(0.12),
            {
                Color = Color3.fromRGB(92, 98, 108),
                Transparency = strong and 0.10 or 0.20
            }
        ):Play()
    end)

    btn.MouseLeave:Connect(function()
        if not btn.Parent then return end

        TweenService:Create(
            btn,
            TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                BackgroundColor3 = UI.Button,
                BackgroundTransparency = strong and 0.18 or 0.24
            }
        ):Play()

        TweenService:Create(
            scale,
            TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Scale = 1}
        ):Play()

        TweenService:Create(
            stroke,
            TweenInfo.new(0.16),
            {
                Color = strong
                    and Color3.fromRGB(72, 76, 84)
                    or Color3.fromRGB(53, 57, 64),
                Transparency = strong and 0.20 or 0.32
            }
        ):Play()
    end)

    btn.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        TweenService:Create(
            scale,
            TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Scale = 0.975}
        ):Play()

        TweenService:Create(
            btn,
            TweenInfo.new(0.06),
            {BackgroundTransparency = 0.10}
        ):Play()
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        TweenService:Create(
            scale,
            TweenInfo.new(0.17, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale = 1}
        ):Play()

        TweenService:Create(
            btn,
            TweenInfo.new(0.17),
            {BackgroundTransparency = strong and 0.18 or 0.24}
        ):Play()
    end)

    return stroke
end

--========================================================--
--   最小化后的 DB 悬浮按钮
--========================================================--

local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingButton.Size = UDim2.fromOffset(BUTTON_SIZE, BUTTON_SIZE)
FloatingButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FloatingButton.BackgroundTransparency = 0.25
FloatingButton.BorderSizePixel = 0
FloatingButton.Text = "DB"
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.TextTransparency = 0
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

-- 最原版：2px 彩虹描边
local BtnBorder, BtnGrad = AddRainbowBorder(
    FloatingButton,
    2.0,
    0.00,
    7.20
)

--========================================================--
--   顶栏
--========================================================--

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

--========================================================--
--   DB SCRIPT：彩虹只存在于字母内部
--   UIGradient 围绕字母中心连续旋转
--========================================================--

local Title = Instance.new("TextLabel")
Title.Name = "DB_SCRIPT_Title"
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(14, 8)
Title.Size = UDim2.new(1, -40, 0, 29)
Title.Text = "DB SCRIPT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextTransparency = 0
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 21
Title.Parent = DragArea

local TitleRainbow = StartRainbowFlow(
    Title,
    4.25,
    NumberSequence.new(0)
)

local Subtitle = Instance.new("TextLabel")
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.fromOffset(16, 34)
Subtitle.Size = UDim2.new(1, -40, 0, 14)
Subtitle.Text = "点击分类 · 加载脚本"
Subtitle.TextColor3 = UI.SubText
Subtitle.TextTransparency = 0
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.ZIndex = 21
Subtitle.Parent = DragArea

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.fromOffset(40, 40)
CloseBtn.Position = UDim2.new(1, -48, 0, 5)
CloseBtn.BackgroundColor3 = UI.Button
CloseBtn.BackgroundTransparency = 0.18
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "−"
CloseBtn.TextColor3 = UI.Text
CloseBtn.TextTransparency = 0
CloseBtn.TextSize = 28
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 30
CloseBtn.Parent = Header
StyleLiquidButton(CloseBtn, 11, true)

--========================================================--
--   内容区
--========================================================--

local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(6, 56)
Content.Size = UDim2.new(1, -12, 1, -72)
Content.BackgroundTransparency = 1
Content.ZIndex = 10
Content.Parent = Body

local LeftMenu = Instance.new("Frame")
LeftMenu.Size = UDim2.new(0.30, -5, 1, 0)
LeftMenu.BackgroundTransparency = 1
LeftMenu.Parent = Content

local MenuScroll = Instance.new("ScrollingFrame")
MenuScroll.Size = UDim2.new(1, -4, 1, 0)
MenuScroll.Position = UDim2.fromOffset(2, 0)
MenuScroll.BackgroundTransparency = 1
MenuScroll.BorderSizePixel = 0
MenuScroll.ScrollBarThickness = 2
MenuScroll.ScrollBarImageColor3 = Color3.fromRGB(205, 205, 210)
MenuScroll.ScrollBarImageTransparency = 0.55
MenuScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
MenuScroll.CanvasSize = UDim2.new()
MenuScroll.Parent = LeftMenu

local MenuLayout = Instance.new("UIListLayout")
MenuLayout.Padding = UDim.new(0, 8)
MenuLayout.Parent = MenuScroll

local RightList = Instance.new("Frame")
RightList.Size = UDim2.new(0.70, -5, 1, 0)
RightList.Position = UDim2.new(0.30, 5, 0, 0)
RightList.BackgroundTransparency = 1
RightList.Parent = Content

local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(1, -4, 1, 0)
ListScroll.Position = UDim2.fromOffset(2, 0)
ListScroll.BackgroundTransparency = 1
ListScroll.BorderSizePixel = 0
ListScroll.ScrollBarThickness = 2
ListScroll.ScrollBarImageColor3 = Color3.fromRGB(205, 205, 210)
ListScroll.ScrollBarImageTransparency = 0.55
ListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListScroll.CanvasSize = UDim2.new()
ListScroll.Parent = RightList

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = ListScroll

--========================================================--
--   底部移动条
--   默认低调灰色；按住才进入白色魔法闪烁
--   长度 = 整个功能面板宽度的 3/5
--========================================================--

local MoveBarHitArea = Instance.new("TextButton")
MoveBarHitArea.Name = "MoveBarHitArea"
MoveBarHitArea.AnchorPoint = Vector2.new(0.5, 1)
MoveBarHitArea.Position = UDim2.new(0.5, 0, 1, -2)
MoveBarHitArea.Size = UDim2.new(3/5, 0, 0, 20)
MoveBarHitArea.BackgroundTransparency = 1
MoveBarHitArea.BorderSizePixel = 0
MoveBarHitArea.Text = ""
MoveBarHitArea.AutoButtonColor = false
MoveBarHitArea.Active = true
MoveBarHitArea.ZIndex = 70
MoveBarHitArea.Parent = Body

local MoveBar = Instance.new("Frame")
MoveBar.Name = "MoveBar"
MoveBar.AnchorPoint = Vector2.new(0.5, 0.5)
MoveBar.Position = UDim2.fromScale(0.5, 0.63)
MoveBar.Size = UDim2.new(1, 0, 0, 3)
MoveBar.BackgroundColor3 = Color3.fromRGB(88, 88, 94)
MoveBar.BackgroundTransparency = 0.20
MoveBar.BorderSizePixel = 0
MoveBar.ZIndex = 71
MoveBar.Parent = MoveBarHitArea
AddCorner(MoveBar, 999)

local MoveBarScale = Instance.new("UIScale")
MoveBarScale.Scale = 1
MoveBarScale.Parent = MoveBar

local MoveBarGlow = Instance.new("UIStroke")
MoveBarGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MoveBarGlow.Thickness = 1.0
MoveBarGlow.Color = Color3.fromRGB(255, 255, 255)
MoveBarGlow.Transparency = 1
MoveBarGlow.LineJoinMode = Enum.LineJoinMode.Round
MoveBarGlow.Parent = MoveBar

local MoveMagicGradient = Instance.new("UIGradient")
MoveMagicGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(165, 228, 255)),
    ColorSequenceKeypoint.new(0.68, Color3.fromRGB(208, 174, 255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))
})
MoveMagicGradient.Rotation = 0
MoveMagicGradient.Parent = MoveBarGlow

--========================================================--
--   右下角缩放手柄
--   真正触摸区透明；视觉使用类似系统窗口的圆角 L 形提示
--   放在彩虹边缘外侧一点
--========================================================--

local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"

-- 触摸区保持大一些，视觉本体紧贴右下彩虹边缘
ResizeHandle.AnchorPoint = Vector2.new(0, 0)

-- 贴近右下角：视觉圆弧与彩虹边缘只留约 1~2px
ResizeHandle.Position = UDim2.new(1, -26, 1, -26)

ResizeHandle.Size = UDim2.fromOffset(48, 48)

ResizeHandle.BackgroundTransparency = 1
ResizeHandle.BorderSizePixel = 0
ResizeHandle.Text = ""
ResizeHandle.AutoButtonColor = false
ResizeHandle.Active = true
ResizeHandle.ZIndex = 90
ResizeHandle.Parent = Panel

--========================================================--
--   加粗 1/4 圆角
--   只保留单一灰色圆弧，不加任何额外装饰
--========================================================--

local ResizeArcVisual = Instance.new("TextLabel")
ResizeArcVisual.Name = "ResizeArcVisual"

ResizeArcVisual.AnchorPoint = Vector2.new(0, 0)

-- 圆弧往左上收，让它贴着主面板右下彩虹圆角
ResizeArcVisual.Position = UDim2.fromOffset(12, 10)

ResizeArcVisual.Size = UDim2.fromOffset(36, 36)

ResizeArcVisual.BackgroundTransparency = 1
ResizeArcVisual.BorderSizePixel = 0

ResizeArcVisual.Text = "╯"

-- 比上一版更粗、更有存在感
ResizeArcVisual.TextColor3 = Color3.fromRGB(150, 150, 156)
ResizeArcVisual.TextTransparency = 0.04
ResizeArcVisual.TextSize = 50
ResizeArcVisual.Font = Enum.Font.GothamBold

ResizeArcVisual.TextXAlignment = Enum.TextXAlignment.Center
ResizeArcVisual.TextYAlignment = Enum.TextYAlignment.Center

ResizeArcVisual.ZIndex = 91
ResizeArcVisual.Parent = ResizeHandle

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
    ["竞技格斗"] = {
        {Name = "最强战场", Code = [[loadstring(game:HttpGet("https://gitlab.com/zkay404-group/ProjectYielding/-/raw/main/ZKPublicFarm"))()]]}
    },
    ["休闲社交"] = {
        {Name = "谋杀之谜MM2", Url = "https://raw.githubusercontent.com/snxpzscripts/mm2/refs/heads/main/MozqlHub"},
        {Name = "NPC或死", Code = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/ToraScript/Script/main/BENPCORDIE', true))()]]},
        {Name = "画我", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/KENNY画我.lua"))()]]},
        {Name = "闪耀事物和人", Code = [[loadstring(game:HttpGet("https://rawscripts.net/raw/Fling-Things-and-People-ftap-script-241022"))()]]}
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

        if success then
            ShowDBNotification(
                "加载成功",
                item.Name or "欢迎使用DB脚本",
                true
            )
        else
            warn("❌ 脚本加载失败: " .. tostring(err))

            ShowDBNotification(
                "加载失败",
                item.Name or "脚本加载失败",
                false
            )
        end
    end)
end

local function ApplySafeClickEffect(btn, onClick)
    btn.Activated:Connect(function()
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
        btn.BackgroundColor3 = UI.Button
        btn.BackgroundTransparency = 0.24
        btn.BorderSizePixel = 0
        btn.Text = item.Name
        btn.TextColor3 = UI.Text
        btn.TextTransparency = 0
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamMedium
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.ZIndex = 15

        StyleLiquidButton(btn, 9, false)

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
    btn.BackgroundColor3 = UI.Button
    btn.BackgroundTransparency = 0.24
    btn.BorderSizePixel = 0
    btn.Text = catName
    btn.TextColor3 = UI.Text
    btn.TextTransparency = 0
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.ZIndex = 15

    StyleLiquidButton(btn, 11, false)

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
    -- 功能面板不做屏幕边界限制。
    -- 可以任意移动到屏幕外，甚至完全隐藏在屏幕之外。
    State.PanelPosition = pos
    Panel.Position = UDim2.fromOffset(pos.X, pos.Y)
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

-- 顶栏不再承担拖动，面板移动统一由底部白条控制。

local function InputXY(input)
    return Vector2.new(input.Position.X, input.Position.Y)
end

--========================================================--
--   移动白条：按住时魔法闪烁
--========================================================--

local moveDragging = false
local moveStartPointer = nil
local moveStartPanelPos = nil
local moveTouchInput = nil
local moveMagicToken = 0
local movePulseTween = nil
local moveGradientTween = nil

local function SpawnMoveSpark()
    if not MoveBar.Parent then
        return
    end

    local spark = Instance.new("Frame")
    local size = math.random(2, 4)

    spark.AnchorPoint = Vector2.new(0.5, 0.5)
    spark.Size = UDim2.fromOffset(size, size)
    spark.Position = UDim2.new(
        math.random(8, 92) / 100,
        0,
        0.5,
        math.random(-7, 7)
    )
    spark.BackgroundColor3 =
        (math.random(1, 3) == 1)
        and Color3.fromRGB(205, 177, 255)
        or Color3.fromRGB(210, 242, 255)
    spark.BackgroundTransparency = 0.05
    spark.BorderSizePixel = 0
    spark.ZIndex = 73
    spark.Parent = MoveBar
    AddCorner(spark, 999)

    local driftX = math.random(-6, 6)
    local driftY = math.random(-11, -5)

    TweenService:Create(
        spark,
        TweenInfo.new(
            0.34,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Position = UDim2.new(
                spark.Position.X.Scale,
                driftX,
                spark.Position.Y.Scale,
                driftY
            ),
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(size + 2, size + 2)
        }
    ):Play()

    task.delay(0.38, function()
        if spark and spark.Parent then
            spark:Destroy()
        end
    end)
end

local function SetMoveBarMagic(active)
    moveMagicToken += 1
    local myToken = moveMagicToken

    if movePulseTween then
        movePulseTween:Cancel()
        movePulseTween = nil
    end

    if moveGradientTween then
        moveGradientTween:Cancel()
        moveGradientTween = nil
    end

    if active then
        -- 按住时才由低调灰色变成白色
        TweenService:Create(
            MoveBar,
            TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                BackgroundColor3 = Color3.fromRGB(245, 245, 248),
                BackgroundTransparency = 0.02
            }
        ):Play()

        MoveBarGlow.Transparency = 0.05
        MoveBarGlow.Thickness = 1.25

        TweenService:Create(
            MoveBarScale,
            TweenInfo.new(
                0.11,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {Scale = 1.018}
        ):Play()

        movePulseTween = TweenService:Create(
            MoveBarGlow,
            TweenInfo.new(
                0.40,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut,
                -1,
                true
            ),
            {
                Transparency = 0.58,
                Thickness = 2.15
            }
        )
        movePulseTween:Play()

        MoveMagicGradient.Rotation = 0
        moveGradientTween = TweenService:Create(
            MoveMagicGradient,
            TweenInfo.new(
                1.05,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.InOut,
                -1,
                false
            ),
            {Rotation = 360}
        )
        moveGradientTween:Play()

        task.spawn(function()
            while moveDragging
            and myToken == moveMagicToken
            and MoveBar.Parent do
                SpawnMoveSpark()
                task.wait(0.13)
            end
        end)
    else
        MoveBarGlow.Transparency = 1
        MoveBarGlow.Thickness = 1.0
        MoveMagicGradient.Rotation = 0

        TweenService:Create(
            MoveBar,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                BackgroundColor3 = Color3.fromRGB(88, 88, 94),
                BackgroundTransparency = 0.20
            }
        ):Play()

        TweenService:Create(
            MoveBarScale,
            TweenInfo.new(
                0.15,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {Scale = 1}
        ):Play()
    end
end

--========================================================--
--   移动 / 缩放手势状态
--   两种手势严格互斥，防止移动时误触发缩放
--========================================================--

local activePanelGesture = nil

--========================================================--
--   缩放状态
--========================================================--

local resizing = false
local resizeArmed = false
local resizeStartPointer = nil
local resizeStartSize = nil
local resizeStartPosition = nil
local resizeTouchInput = nil

local resizeMagicToken = 0
local resizePulseTween = nil

local function SpawnResizeSpark()

    if not ResizeArcVisual.Parent then
        return
    end

    local spark = Instance.new("Frame")
    local size = math.random(2, 4)

    spark.AnchorPoint = Vector2.new(0.5, 0.5)

    -- 星点只出现在右下角圆弧附近
    spark.Position = UDim2.fromOffset(
        math.random(18, 40),
        math.random(17, 39)
    )

    spark.Size = UDim2.fromOffset(size, size)

    spark.BackgroundColor3 =
        (math.random(1, 3) == 1)
        and Color3.fromRGB(208, 174, 255)
        or Color3.fromRGB(195, 235, 255)

    spark.BackgroundTransparency = 0.04
    spark.BorderSizePixel = 0
    spark.ZIndex = 94
    spark.Parent = ResizeHandle

    AddCorner(spark, 999)

    local driftX = math.random(-6, 7)
    local driftY = math.random(-8, 4)

    TweenService:Create(
        spark,
        TweenInfo.new(
            0.32,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Position = UDim2.fromOffset(
                spark.Position.X.Offset + driftX,
                spark.Position.Y.Offset + driftY
            ),
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(size + 2, size + 2)
        }
    ):Play()

    task.delay(0.36, function()
        if spark and spark.Parent then
            spark:Destroy()
        end
    end)

end

local function SetResizeMagic(active)

    resizeMagicToken += 1
    local myToken = resizeMagicToken

    if resizePulseTween then
        resizePulseTween:Cancel()
        resizePulseTween = nil
    end

    if active then

        -- 按住时由灰色变成亮白
        TweenService:Create(
            ResizeArcVisual,
            TweenInfo.new(
                0.10,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                TextColor3 = Color3.fromRGB(250, 250, 255),
                TextTransparency = 0.00,
                TextSize = 53
            }
        ):Play()

        -- 轻微呼吸闪烁
        resizePulseTween = TweenService:Create(
            ResizeArcVisual,
            TweenInfo.new(
                0.42,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut,
                -1,
                true
            ),
            {
                TextColor3 = Color3.fromRGB(205, 235, 255),
                TextTransparency = 0.18,
                TextSize = 55
            }
        )

        resizePulseTween:Play()

        -- 少量淡紫 / 冰蓝星点
        task.spawn(function()

            while activePanelGesture == "resize"
            and resizeArmed
            and myToken == resizeMagicToken
            and ResizeHandle.Parent do

                SpawnResizeSpark()

                task.wait(0.12)

            end

        end)

    else

        -- 松手后恢复现在这版的灰色圆弧
        TweenService:Create(
            ResizeArcVisual,
            TweenInfo.new(
                0.14,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                TextColor3 = Color3.fromRGB(150, 150, 156),
                TextTransparency = 0.04,
                TextSize = 50
            }
        ):Play()

    end

end

--========================================================--
--   移动条按下
--========================================================--

MoveBarHitArea.InputBegan:Connect(function(input)

    if State.Animating
    or State.Minimized
    or activePanelGesture ~= nil then
        return
    end    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        activePanelGesture = "move"

        -- 一旦开始移动，缩放区域临时失效
        ResizeHandle.Active = false

        resizing = false
        resizeArmed = false
        resizeTouchInput = nil

        moveDragging = true
        moveStartPointer = InputXY(input)
        moveStartPanelPos = State.PanelPosition

        if input.UserInputType == Enum.UserInputType.Touch then
            moveTouchInput = input
        else
            moveTouchInput = nil
        end

        SetMoveBarMagic(true)

    end

end)

--========================================================--
--   缩放角按下
--========================================================--

ResizeHandle.InputBegan:Connect(function(input)

    if State.Animating
    or State.Minimized
    or activePanelGesture ~= nil then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        activePanelGesture = "resize"

        -- 一旦开始缩放，底部移动条临时失效
        MoveBarHitArea.Active = false

        moveDragging = false
        moveTouchInput = nil

        resizeArmed = true
        resizing = false

        resizeStartPointer = InputXY(input)
        resizeStartSize = Vector2.new(panelWidth, panelHeight)
        resizeStartPosition = State.PanelPosition

        if input.UserInputType == Enum.UserInputType.Touch then
            resizeTouchInput = input
        else
            resizeTouchInput = nil
        end

        SetResizeMagic(true)

    end

end)

--========================================================--
--   手势移动
--========================================================--

UserInputService.InputChanged:Connect(function(input)

    --====================================================--
    --   移动
    --   完全取消以前的边缘加速推入机制。
    --   面板只跟随手指真实位移，不吸边、不跳跃。
    --====================================================--

    if activePanelGesture == "move"
    and moveDragging then

        local isMouseMove =
            input.UserInputType == Enum.UserInputType.MouseMovement

        local isCorrectTouch =
            input.UserInputType == Enum.UserInputType.Touch
            and input == moveTouchInput

        if isMouseMove or isCorrectTouch then

            local pointer = InputXY(input)
            local delta = pointer - moveStartPointer

            SetPanelPosition(
                moveStartPanelPos + delta
            )

        end

        return

    end

    --====================================================--
    --   缩放
    --====================================================--

    if activePanelGesture == "resize"
    and resizeArmed then

        local isMouseMove =
            input.UserInputType == Enum.UserInputType.MouseMovement

        local isCorrectTouch =
            input.UserInputType == Enum.UserInputType.Touch
            and input == resizeTouchInput

        if isMouseMove or isCorrectTouch then

            local pointer = InputXY(input)
            local delta = pointer - resizeStartPointer

            -- 至少真正拖动 5px 才正式进入缩放，
            -- 单纯点击或轻微抖动不会改变面板大小。
            if not resizing then

                if delta.Magnitude < 5 then
                    return
                end

                resizing = true

            end

            local vpNow = GetViewport()

            local maxW = vpNow.X * 0.90
            local maxH = vpNow.Y * 0.90

            local minW = math.min(MIN_PANEL_WIDTH, maxW)
            local minH = math.min(MIN_PANEL_HEIGHT, maxH)

            local newW = math.clamp(
                resizeStartSize.X + delta.X,
                minW,
                maxW
            )

            local newH = math.clamp(
                resizeStartSize.Y + delta.Y,
                minH,
                maxH
            )

            local usedDX = newW - resizeStartSize.X
            local usedDY = newH - resizeStartSize.Y

            panelWidth = newW
            panelHeight = newH

            Panel.Size = UDim2.fromOffset(
                panelWidth,
                panelHeight
            )

            -- 保持左上角基本不动，
            -- 只让右下角跟着手指缩放。
            SetPanelPosition(
                resizeStartPosition
                + Vector2.new(
                    usedDX / 2,
                    usedDY / 2
                )
            )

        end

    end

end)

--========================================================--
--   手势结束
--========================================================--

UserInputService.InputEnded:Connect(function(input)

    if activePanelGesture == "move"
    and moveDragging then

        local endedMouse =
            input.UserInputType == Enum.UserInputType.MouseButton1

        local endedTouch =
            input.UserInputType == Enum.UserInputType.Touch
            and input == moveTouchInput

        if endedMouse or endedTouch then

            moveDragging = false
            moveStartPointer = nil
            moveStartPanelPos = nil
            moveTouchInput = nil

            SetMoveBarMagic(false)

            activePanelGesture = nil

            ResizeHandle.Active = true

        end

        return

    end

    if activePanelGesture == "resize"
    and resizeArmed then

        local endedMouse =
            input.UserInputType == Enum.UserInputType.MouseButton1

        local endedTouch =
            input.UserInputType == Enum.UserInputType.Touch
            and input == resizeTouchInput

        if endedMouse or endedTouch then

            resizing = false
            resizeArmed = false

            resizeStartPointer = nil
            resizeStartSize = nil
            resizeStartPosition = nil
            resizeTouchInput = nil

            SetResizeMagic(false)

            activePanelGesture = nil

            MoveBarHitArea.Active = true

        end

    end

end)

-- 屏幕方向或分辨率改变后，自动把当前尺寸限制回允许范围
task.spawn(function()
    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if State.Minimized then
            return
        end

        local vpNow = GetViewport()
        local maxW = vpNow.X * 0.90
        local maxH = vpNow.Y * 0.90

        panelWidth = math.clamp(
            panelWidth,
            math.min(MIN_PANEL_WIDTH, maxW),
            maxW
        )

        panelHeight = math.clamp(
            panelHeight,
            math.min(MIN_PANEL_HEIGHT, maxH),
            maxH
        )

        Panel.Size = UDim2.fromOffset(
            panelWidth,
            panelHeight
        )

        SetPanelPosition(
            State.PanelPosition
            or Vector2.new(vpNow.X / 2, vpNow.Y / 2)
        )
    end)
end)


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

    if State.ButtonHidden then
        return
    end

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

        currentTween = TweenService:Create(
            FloatingButton,
            TweenInfo.new(
                0.25,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {
                Position = UDim2.fromOffset(
                    targetPos.X,
                    targetPos.Y
                )
            }
        )

        currentTween:Play()

        currentTween.Completed:Connect(function()
            currentTween = nil
        end)

        State.ButtonHidden = true
        State.HideSide = side
        State.ButtonPosition = targetPos
    else
        local clampedX = math.clamp(
            x,
            halfSize,
            vp.X - halfSize
        )

        local clampedY = math.clamp(
            y,
            halfSize,
            vp.Y - halfSize
        )

        if clampedX ~= x or clampedY ~= y then
            local targetPos = Vector2.new(
                clampedX,
                clampedY
            )

            FloatingButton.Position = UDim2.fromOffset(
                targetPos.X,
                targetPos.Y
            )

            State.ButtonPosition = targetPos
        else
            State.ButtonPosition = Vector2.new(x, y)
        end
    end
end

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        btnDragging = true
        btnDragStartPos = FloatingButton.Position
        btnDragStartMouse = input.Position
        dragDistance = 0

        if currentTween
        and currentTween.PlaybackState == Enum.PlaybackState.Playing then
            currentTween:Cancel()
            currentTween = nil
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not btnDragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - btnDragStartMouse

        dragDistance = dragDistance + delta.Magnitude

        local newX = btnDragStartPos.X.Offset + delta.X
        local newY = btnDragStartPos.Y.Offset + delta.Y

        local vp = GetViewport()
        local halfSize = BUTTON_SIZE / 2

        -- 最原版限制：允许绝大部分按钮进入屏幕边缘，
        -- 但仍保留约 5px 可见区域。
        newX = math.clamp(
            newX,
            -halfSize + 5,
            vp.X + halfSize - 5
        )

        newY = math.clamp(
            newY,
            halfSize,
            vp.Y - halfSize
        )

        FloatingButton.Position = UDim2.fromOffset(
            newX,
            newY
        )

        State.ButtonPosition = Vector2.new(
            newX,
            newY
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        if btnDragging then
            local dist = dragDistance

            btnDragging = false
            btnDragStartPos = nil
            btnDragStartMouse = nil

            if dist < CLICK_THRESHOLD then

                if State.ButtonHidden then
                    local vp = GetViewport()
                    local half = BUTTON_SIZE / 2

                    local restoreX = math.clamp(
                        State.ButtonPosition.X,
                        half,
                        vp.X - half
                    )

                    local restoreY = math.clamp(
                        State.ButtonPosition.Y,
                        half,
                        vp.Y - half
                    )

                    local restorePos = Vector2.new(
                        restoreX,
                        restoreY
                    )

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

ShowDBNotification(
    "加载成功",
    "欢迎使用DB脚本",
    true
)

print("✅ DB Panel 已加载 · 延长开场 + 右下系统弹窗版")
