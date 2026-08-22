--========================================================--
--   DB Panel · 完整版（含所有分类和脚本）
--========================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local LocalPlayer = Players.LocalPlayer
local __dbWaitStart = os.clock()

while not LocalPlayer and (os.clock() - __dbWaitStart) < 12 do
    task.wait(0.10)
    LocalPlayer = Players.LocalPlayer
end

if not LocalPlayer then
    error("[DB] LocalPlayer 未准备好")
end

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
local __dbPlayerGui = LocalPlayer:WaitForChild("PlayerGui", 12)
if not __dbPlayerGui then
    error("[DB] PlayerGui 未准备好")
end
MainGui.Parent = __dbPlayerGui

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

local UI = {
    Panel = Color3.fromRGB(0, 0, 0),
    Button = Color3.fromRGB(12, 12, 14),
    ButtonHover = Color3.fromRGB(25, 25, 29),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(205, 205, 210)
}

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

local NotificationLayer = Instance.new("Frame")
NotificationLayer.Name = "DB_NotificationLayer"
NotificationLayer.Size = UDim2.fromScale(1, 1)
NotificationLayer.BackgroundTransparency = 1
NotificationLayer.BorderSizePixel = 0
NotificationLayer.ZIndex = 800
NotificationLayer.Parent = MainGui

local ActiveNotification = nil

local function ShowDBNotification(titleText, bodyText, isSuccess)

    if ActiveNotification and ActiveNotification.Parent then
        ActiveNotification:Destroy()
        ActiveNotification = nil
    end

    local vp = GetViewport()

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

local PanelBorder, PanelBorderGradient = AddRainbowBorder(
    Body,
    1.65,
    0.02,
    2.75
)

local function StyleLiquidButton(btn, radius, strong)
    radius = radius or 9

    btn.BackgroundColor3 = UI.Button
    btn.BackgroundTransparency = strong and 0.18 or 0.24
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ClipsDescendants = false

    btn.TextColor3 = UI.Text
    btn.TextTransparency = 0

    AddCorner(btn, radius)

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

local BtnBorder, BtnGrad = AddRainbowBorder(
    FloatingButton,
    2.0,
    0.00,
    7.20
)

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
MenuScroll.Size = UDim2.new(1, 0, 1, 0)
MenuScroll.Position = UDim2.fromOffset(0, 0)
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
MenuLayout.SortOrder = Enum.SortOrder.LayoutOrder
MenuLayout.Parent = MenuScroll

local MenuScrollPadding = Instance.new("UIPadding")
MenuScrollPadding.PaddingTop = UDim.new(0, 4)
MenuScrollPadding.PaddingBottom = UDim.new(0, 4)
MenuScrollPadding.PaddingLeft = UDim.new(0, 4)
MenuScrollPadding.PaddingRight = UDim.new(0, 7)
MenuScrollPadding.Parent = MenuScroll

local RightList = Instance.new("Frame")
RightList.Size = UDim2.new(0.70, -5, 1, 0)
RightList.Position = UDim2.new(0.30, 5, 0, 0)
RightList.BackgroundTransparency = 1
RightList.Parent = Content

local ListScroll = Instance.new("ScrollingFrame")
ListScroll.Size = UDim2.new(1, 0, 1, 0)
ListScroll.Position = UDim2.fromOffset(0, 0)
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
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ListScroll

local ListScrollPadding = Instance.new("UIPadding")
ListScrollPadding.PaddingTop = UDim.new(0, 4)
ListScrollPadding.PaddingBottom = UDim.new(0, 4)
ListScrollPadding.PaddingLeft = UDim.new(0, 4)
ListScrollPadding.PaddingRight = UDim.new(0, 7)
ListScrollPadding.Parent = ListScroll

local function AddHyperOSScrollFrost(scrollFrame, hostFrame, zBase)
    zBase = zBase or 72

    local function CreateFrost(name, isTop)
        local group = Instance.new("CanvasGroup")
        group.Name = name
        group.AnchorPoint = Vector2.new(
            0,
            isTop and 0 or 1
        )

        group.Position =
            isTop
            and UDim2.fromOffset(-10, -3)
            or UDim2.new(0, -10, 1, 3)

        group.Size = UDim2.new(1, 20, 0, 64)
        group.BackgroundTransparency = 1
        group.BorderSizePixel = 0
        group.Active = false
        group.GroupTransparency = 1
        group.Visible = false
        group.ZIndex = zBase
        group.Parent = hostFrame

        local glass = Instance.new("Frame")
        glass.Name = "GlassBase"
        glass.Size = UDim2.fromScale(1, 1)
        glass.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        glass.BackgroundTransparency = 0.10
        glass.BorderSizePixel = 0
        glass.Active = false
        glass.ZIndex = zBase
        glass.Parent = group

        local glassGradient = Instance.new("UIGradient")
        glassGradient.Rotation =
            isTop and 90 or -90

        glassGradient.Transparency =
            NumberSequence.new({
                NumberSequenceKeypoint.new(0.00, 0.04),
                NumberSequenceKeypoint.new(0.14, 0.07),
                NumberSequenceKeypoint.new(0.31, 0.16),
                NumberSequenceKeypoint.new(0.50, 0.34),
                NumberSequenceKeypoint.new(0.68, 0.58),
                NumberSequenceKeypoint.new(0.84, 0.80),
                NumberSequenceKeypoint.new(1.00, 1.00)
            })

        glassGradient.Parent = glass

        local mist = Instance.new("Frame")
        mist.Name = "SoftMist"
        mist.Position =
            isTop
            and UDim2.fromOffset(0, 0)
            or UDim2.new(0, 0, 0.18, 0)

        mist.Size = UDim2.new(1, 0, 0.82, 0)
        mist.BackgroundColor3 = Color3.fromRGB(64, 67, 76)
        mist.BackgroundTransparency = 0.78
        mist.BorderSizePixel = 0
        mist.Active = false
        mist.ZIndex = zBase + 1
        mist.Parent = group

        local mistGradient = Instance.new("UIGradient")
        mistGradient.Rotation =
            isTop and 90 or -90

        mistGradient.Transparency =
            NumberSequence.new({
                NumberSequenceKeypoint.new(0.00, 0.28),
                NumberSequenceKeypoint.new(0.24, 0.38),
                NumberSequenceKeypoint.new(0.52, 0.62),
                NumberSequenceKeypoint.new(0.78, 0.86),
                NumberSequenceKeypoint.new(1.00, 1.00)
            })

        mistGradient.Parent = mist

        local bloom = Instance.new("Frame")
        bloom.Name = "EdgeBloom"
        bloom.Position =
            isTop
            and UDim2.fromOffset(0, 0)
            or UDim2.new(0, 0, 1, -20)

        bloom.Size = UDim2.new(1, 0, 0, 20)
        bloom.BackgroundColor3 = Color3.fromRGB(225, 228, 238)
        bloom.BackgroundTransparency = 0.91
        bloom.BorderSizePixel = 0
        bloom.Active = false
        bloom.ZIndex = zBase + 2
        bloom.Parent = group

        local bloomGradient = Instance.new("UIGradient")
        bloomGradient.Rotation =
            isTop and 90 or -90

        bloomGradient.Transparency =
            NumberSequence.new({
                NumberSequenceKeypoint.new(0.00, 0.50),
                NumberSequenceKeypoint.new(0.35, 0.74),
                NumberSequenceKeypoint.new(1.00, 1.00)
            })

        bloomGradient.Parent = bloom

        local edgeLight = Instance.new("Frame")
        edgeLight.Name = "EdgeLight"
        edgeLight.Size = UDim2.new(1, -8, 0, 1)
        edgeLight.Position =
            isTop
            and UDim2.fromOffset(4, 0)
            or UDim2.new(0, 4, 1, -1)

        edgeLight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        edgeLight.BackgroundTransparency = 0.94
        edgeLight.BorderSizePixel = 0
        edgeLight.Active = false
        edgeLight.ZIndex = zBase + 3
        edgeLight.Parent = group

        return group
    end

    local topFrost =
        CreateFrost(
            "DB_HyperOS_TopFrost",
            true
        )

    local bottomFrost =
        CreateFrost(
            "DB_HyperOS_BottomFrost",
            false
        )

    local topStrength = 0
    local bottomStrength = 0

    local function ApplyStrength(group, strength)
        strength =
            math.clamp(
                strength,
                0,
                1
            )

        if strength <= 0.01 then
            group.GroupTransparency = 1
            group.Visible = false
            return
        end

        group.Visible = true

        group.GroupTransparency =
            1 - (
                strength * 0.94
            )
    end

    local function RefreshFrost()
        if not scrollFrame
        or not scrollFrame.Parent then
            return
        end

        if not scrollFrame.Visible then
            topFrost.Visible = false
            bottomFrost.Visible = false
            return
        end

        local canvasY =
            math.max(
                0,
                scrollFrame.CanvasPosition.Y
            )

        local viewportH =
            math.max(
                1,
                scrollFrame.AbsoluteSize.Y
            )

        local canvasH =
            math.max(
                viewportH,
                scrollFrame.AbsoluteCanvasSize.Y
            )

        local maxY =
            math.max(
                0,
                canvasH - viewportH
            )

        topStrength =
            math.clamp(
                canvasY / 30,
                0,
                1
            )

        bottomStrength =
            maxY <= 2
            and 0
            or math.clamp(
                (maxY - canvasY) / 30,
                0,
                1
            )

        ApplyStrength(
            topFrost,
            topStrength
        )

        ApplyStrength(
            bottomFrost,
            bottomStrength
        )
    end

    scrollFrame:GetPropertyChangedSignal(
        "CanvasPosition"
    ):Connect(RefreshFrost)

    scrollFrame:GetPropertyChangedSignal(
        "AbsoluteCanvasSize"
    ):Connect(RefreshFrost)

    scrollFrame:GetPropertyChangedSignal(
        "AbsoluteSize"
    ):Connect(RefreshFrost)

    scrollFrame:GetPropertyChangedSignal(
        "Visible"
    ):Connect(RefreshFrost)

    task.defer(RefreshFrost)
end

AddHyperOSScrollFrost(
    MenuScroll,
    LeftMenu,
    520
)

AddHyperOSScrollFrost(
    ListScroll,
    RightList,
    520
)

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

local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"

ResizeHandle.AnchorPoint = Vector2.new(0, 0)

ResizeHandle.Position = UDim2.new(1, -26, 1, -26)

ResizeHandle.Size = UDim2.fromOffset(48, 48)

ResizeHandle.BackgroundTransparency = 1
ResizeHandle.BorderSizePixel = 0
ResizeHandle.Text = ""
ResizeHandle.AutoButtonColor = false
ResizeHandle.Active = true
ResizeHandle.ZIndex = 90
ResizeHandle.Parent = Panel

local ResizeArcVisual = Instance.new("TextLabel")
ResizeArcVisual.Name = "ResizeArcVisual"

ResizeArcVisual.AnchorPoint = Vector2.new(0, 0)

ResizeArcVisual.Position = UDim2.fromOffset(12, 10)

ResizeArcVisual.Size = UDim2.fromOffset(36, 36)

ResizeArcVisual.BackgroundTransparency = 1
ResizeArcVisual.BorderSizePixel = 0

ResizeArcVisual.Text = "╯"

ResizeArcVisual.TextColor3 = Color3.fromRGB(150, 150, 156)
ResizeArcVisual.TextTransparency = 0.04
ResizeArcVisual.TextSize = 50
ResizeArcVisual.Font = Enum.Font.GothamBold

ResizeArcVisual.TextXAlignment = Enum.TextXAlignment.Center
ResizeArcVisual.TextYAlignment = Enum.TextYAlignment.Center

ResizeArcVisual.ZIndex = 91
ResizeArcVisual.Parent = ResizeHandle

--========================================================--
--   ★ 脚本数据库（完整版，含所有分类）★
--==========================================================

local ScriptDatabase = {
    ["通用"] = {
        {Name = "飞行", Code = [[loadstring(game:HttpGet("https://pastefy.app/tkHc58Wt/raw"))()]]},
        {Name = "子追", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/HB-ksdb/-4/main/%E5%AD%90%E8%BF%BD%E8%84%9A%E6%9C%AC%E7%A9%BF%E5%A2%99.lua"))()]]},
        {Name = "自瞄", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/gycgchgyfytdttr/QQ-9-2-8-9-50173/refs/heads/main/cure.lua"))()]]},
        {Name = "翻译脚本", Code = [[TX = "TX Script"; Script = "全自动翻译"; loadstring(game:HttpGet("https://raw.githubusercontent.com/JsYb666/Item/refs/heads/main/Auto-language"))()]]},
        {Name = "动画脚本", Url = "https://rawscripts.net/raw/Universal-Script-FREE-BUNDLES-l-FE-241758"},
        {Name = "隐身", Code = [[loadstring(game:HttpGet('https://pastefy.app/6zjosppv/raw'))()]]}
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
        {Name = "画我", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/KENNY画我.lua"))()]]},
        {Name = "闪耀事物和人", Code = [[loadstring(game:HttpGet("https://rawscripts.net/raw/Fling-Things-and-People-ftap-script-241022"))()]]}
    },
    ["合作游戏"] = {
        {Name = "动物医院", Url = "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FN_AnimalHospital.lua"},
        {Name = "门｜群友提供@噬", Url = "https://api.luarmor.net/files/v4/loaders/730854e5b6499ee91deb1080e8e12ae3.lua"},
        {Name = "恐鬼症", Code = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/Aoruen/Roblox-Stuff/refs/heads/main/Dusty%20Trip%20Gui%20V2.lua'))()]]},
        {Name = "森林中的99夜", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua"))()]]},
        {Name = "彩虹朋友1", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Iliankytb/Iliankytb/main/BestRainbowFriendOne"))()]]},
        {Name = "死铁轨", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/erewe23/deadrailsring.github.io/refs/heads/main/ringta.lua"))()]]},
        {Name = "一次尘土飞扬的旅行", Code = [[loadstring(game:HttpGet("https://rawscripts.net/raw/a-dusty-trip-SHOP-KEYLESS-Dusty-Trip-Gui-V2-135343"))()]]}
    },
    ["非对称竞技"] = {
        {Name = "被遗弃｜群友提供@噬", Url = "https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/ainianniang.lua"},
        {Name = "致命猿猴", Url = "https://raw.githubusercontent.com/Anzzckc/Lethal-Ape-Beta/refs/heads/main/Lethal%20Ape%20Beta.lua"},
        {Name = "暴力区", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/lixxWW/ViolenceDistrict/refs/heads/main/ViolenceDistrict.lua"))()]]},
        {Name = "死亡之死", Code = [[loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-DIE-OF-DEATH-SCRIPT-RAYFIELD-201013"))()]]}
    },
    ["塔防游戏"] = {
        {Name = "战斗砖块", Url = "https://rawscripts.net/raw/The-Battle-Bricks-auto-play-no-key-141463"}
    },
    ["其他作者脚本"] = {
        {Name = "XK Hub(支持服务器进群)", Url = "https://github.com/devslopo/DVES/raw/main/XK%20Hub"},
        {Name = "恐脚本支持服务器进主页群", Url = "https://raw.githubusercontent.com/kongbaNB/9178/refs/heads/main/恐脚本.NB"},
        {Name = "皮脚本", Url = "https://raw.githubusercontent.com/xiaopi77/xiaopi77/main/QQ1002100032-Roblox-Pi-script.lua"},
        {Name = "BS脚本", Code = [[local BS = "\104\116\116\112\115\58\47\47\103\105\116\101\101\46\99\111\109\47\66\83\95\115\99\114\105\112\116\47\115\99\114\105\112\116\47\114\97\119\47\109\97\115\116\101\114\47\66\83\95\83\99\114\105\112\116\46\76\117\97\117"; loadstring(game:HttpGet(BS))()]]},
        {Name = "霖溺支持服务器详情进主页群", Url = "https://raw.githubusercontent.com/ShenJiaoBen/ScriptLoader/refs/heads/main/Linni_FreeLoader.lua"},
        {Name = "霖溺通用", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/ShenJiaoBen/Partial-Server-Ribbon/refs/heads/main/Linni_Universal.txt"))()]]},
        {Name = "黑白脚本", Code = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/tfcygvunbind/Apple/main/黑白脚本加载器'))()]]},
        {Name = "TrashHub", Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/WasKKal/OnlyJumpToOther/main/loader.lua"))()]]}
    }
}

local RefreshHomePage

local DBRuntimeState = {
    MainStatus = "运行中",
    Scripts = {},
    ScriptOrder = {}
}

local function DBSetScriptStatus(name, status)
    name = tostring(name or "未命名脚本")
    status = tostring(status or "未知")

    if not DBRuntimeState.Scripts[name] then
        table.insert(DBRuntimeState.ScriptOrder, name)
    end

    DBRuntimeState.Scripts[name] = {
        Status = status,
        UpdatedAt = os.clock()
    }

    if RefreshHomePage then
        pcall(RefreshHomePage)
    end
end

local function SafeLoadScript(item)
    local itemName =
        tostring(
            item and item.Name
            or "未命名脚本"
        )

    DBSetScriptStatus(
        itemName,
        "加载中"
    )

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
            DBSetScriptStatus(
                itemName,
                "运行中"
            )

            ShowDBNotification(
                "加载成功",
                itemName,
                true
            )
        else
            DBSetScriptStatus(
                itemName,
                "加载失败"
            )

            warn(
                "❌ 脚本加载失败: "
                .. tostring(err)
            )

            ShowDBNotification(
                "加载失败",
                itemName,
                false
            )
        end
    end)
end

local function DBBuildHomeAndAI()
    -- 前向声明：主页函数会在 AIPanel 真正创建前被编译，
    -- 所以必须让它捕获这个局部，而不是误读成全局变量。
    local AIPanel
    local AICommandUI
    local DBAIHandleMessage

local HomePanel = Instance.new("Frame")
HomePanel.Name = "DB_Home_Panel"
HomePanel.Size = UDim2.new(1, -8, 1, -4)
HomePanel.Position = UDim2.fromOffset(4, 2)
HomePanel.BackgroundTransparency = 1
HomePanel.Visible = false
HomePanel.ZIndex = 20
HomePanel.Parent = RightList

local HomeScroll = Instance.new("ScrollingFrame")
HomeScroll.Name = "HomeScroll"
HomeScroll.Size = UDim2.fromScale(1, 1)
HomeScroll.BackgroundTransparency = 1
HomeScroll.BorderSizePixel = 0
HomeScroll.ScrollBarThickness = 2
HomeScroll.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 205)
HomeScroll.ScrollBarImageTransparency = 0.58
HomeScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
HomeScroll.CanvasSize = UDim2.new()
HomeScroll.ZIndex = 21
HomeScroll.Parent = HomePanel

local HomeLayout = Instance.new("UIListLayout")
HomeLayout.Padding = UDim.new(0, 8)
HomeLayout.SortOrder = Enum.SortOrder.LayoutOrder
HomeLayout.Parent = HomeScroll

local HomePadding = Instance.new("UIPadding")
HomePadding.PaddingTop = UDim.new(0, 4)
HomePadding.PaddingBottom = UDim.new(0, 5)
HomePadding.PaddingLeft = UDim.new(0, 4)
HomePadding.PaddingRight = UDim.new(0, 7)
HomePadding.Parent = HomeScroll

local function CreateHomeCard(titleText, height)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -4, 0, height)
    card.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
    card.BackgroundTransparency = 0.18
    card.BorderSizePixel = 0
    card.ZIndex = 22
    card.Parent = HomeScroll

    AddCorner(card, 11)

    AddRainbowBorder(
        card,
        1.25,
        0.04,
        3.40
    )

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(12, 7)
    title.Size = UDim2.new(1, -24, 0, 20)
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 23
    title.Parent = card

    local value = Instance.new("TextLabel")
    value.Name = "Value"
    value.BackgroundTransparency = 1
    value.Position = UDim2.fromOffset(12, 29)
    value.Size = UDim2.new(1, -24, 1, -36)
    value.Text = ""
    value.TextColor3 = Color3.fromRGB(245, 245, 248)
    value.TextSize = 11
    value.Font = Enum.Font.GothamMedium
    value.TextWrapped = true
    value.TextXAlignment = Enum.TextXAlignment.Left
    value.TextYAlignment = Enum.TextYAlignment.Top
    value.ZIndex = 23
    value.Parent = card

    return card, value
end

--========================================================--
--  玩家信息主卡：头像 + 名字 + 账号年龄 + 好友在线信息
--========================================================--

local FriendRemarks = {}
local FriendRows = {}
local FriendRowsByUserId = {}
local FriendRefreshToken = 0
local FriendPresenceBusy = false

local PlayerInfoCard = Instance.new("Frame")
PlayerInfoCard.Name = "PlayerInfoCard"
PlayerInfoCard.Size = UDim2.new(1, -4, 0, 286)
PlayerInfoCard.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
PlayerInfoCard.BackgroundTransparency = 0.16
PlayerInfoCard.BorderSizePixel = 0
PlayerInfoCard.LayoutOrder = 1
PlayerInfoCard.ZIndex = 22
PlayerInfoCard.Parent = HomeScroll

AddCorner(PlayerInfoCard, 12)

AddRainbowBorder(
    PlayerInfoCard,
    1.45,
    0.025,
    3.20
)

local PlayerInfoTitle = Instance.new("TextLabel")
PlayerInfoTitle.BackgroundTransparency = 1
PlayerInfoTitle.Position = UDim2.fromOffset(14, 8)
PlayerInfoTitle.Size = UDim2.new(1, -28, 0, 22)
PlayerInfoTitle.Text = "玩家信息"
PlayerInfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerInfoTitle.TextSize = 14
PlayerInfoTitle.Font = Enum.Font.GothamBold
PlayerInfoTitle.TextXAlignment = Enum.TextXAlignment.Left
PlayerInfoTitle.ZIndex = 24
PlayerInfoTitle.Parent = PlayerInfoCard

local PlayerAvatar = Instance.new("ImageLabel")
PlayerAvatar.Name = "PlayerAvatar"
PlayerAvatar.Position = UDim2.fromOffset(14, 38)
PlayerAvatar.Size = UDim2.fromOffset(76, 76)
PlayerAvatar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
PlayerAvatar.BackgroundTransparency = 0.08
PlayerAvatar.BorderSizePixel = 0
PlayerAvatar.Image = ""
PlayerAvatar.ScaleType = Enum.ScaleType.Crop
PlayerAvatar.ZIndex = 24
PlayerAvatar.Parent = PlayerInfoCard

local PlayerAvatarCorner = Instance.new("UICorner")
PlayerAvatarCorner.CornerRadius = UDim.new(1, 0)
PlayerAvatarCorner.Parent = PlayerAvatar

local PlayerAvatarStroke = Instance.new("UIStroke")
PlayerAvatarStroke.Thickness = 1.15
PlayerAvatarStroke.Transparency = 0.12
PlayerAvatarStroke.Color = Color3.fromRGB(220, 220, 225)
PlayerAvatarStroke.Parent = PlayerAvatar

local PlayerNameLabel = Instance.new("TextLabel")
PlayerNameLabel.BackgroundTransparency = 1
PlayerNameLabel.Position = UDim2.fromOffset(102, 42)
PlayerNameLabel.Size = UDim2.new(1, -118, 0, 28)
PlayerNameLabel.Text = "玩家名字：读取中..."
PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameLabel.TextSize = 13
PlayerNameLabel.Font = Enum.Font.GothamBold
PlayerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerNameLabel.TextWrapped = true
PlayerNameLabel.ZIndex = 24
PlayerNameLabel.Parent = PlayerInfoCard

local PlayerAgeLabel = Instance.new("TextLabel")
PlayerAgeLabel.BackgroundTransparency = 1
PlayerAgeLabel.Position = UDim2.fromOffset(102, 72)
PlayerAgeLabel.Size = UDim2.new(1, -118, 0, 23)
PlayerAgeLabel.Text = "账号年龄：读取中..."
PlayerAgeLabel.TextColor3 = Color3.fromRGB(235, 236, 241)
PlayerAgeLabel.TextSize = 11
PlayerAgeLabel.Font = Enum.Font.GothamMedium
PlayerAgeLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerAgeLabel.ZIndex = 24
PlayerAgeLabel.Parent = PlayerInfoCard

local PlayerUsernameLabel = Instance.new("TextLabel")
PlayerUsernameLabel.BackgroundTransparency = 1
PlayerUsernameLabel.Position = UDim2.fromOffset(102, 94)
PlayerUsernameLabel.Size = UDim2.new(1, -118, 0, 19)
PlayerUsernameLabel.Text = ""
PlayerUsernameLabel.TextColor3 = Color3.fromRGB(170, 174, 184)
PlayerUsernameLabel.TextSize = 10
PlayerUsernameLabel.Font = Enum.Font.Gotham
PlayerUsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerUsernameLabel.ZIndex = 24
PlayerUsernameLabel.Parent = PlayerInfoCard

local FriendBox = Instance.new("Frame")
FriendBox.Name = "FriendOnlineBox"
FriendBox.Position = UDim2.fromOffset(12, 126)
FriendBox.Size = UDim2.new(1, -24, 1, -138)
FriendBox.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
FriendBox.BackgroundTransparency = 0.18
FriendBox.BorderSizePixel = 0
FriendBox.ZIndex = 24
FriendBox.Parent = PlayerInfoCard

AddCorner(FriendBox, 10)

AddRainbowBorder(
    FriendBox,
    1.05,
    0.08,
    3.65
)

local FriendBoxTitle = Instance.new("TextLabel")
FriendBoxTitle.BackgroundTransparency = 1
FriendBoxTitle.Position = UDim2.fromOffset(10, 6)
FriendBoxTitle.Size = UDim2.new(1, -20, 0, 18)
FriendBoxTitle.Text = "好友在线信息"
FriendBoxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FriendBoxTitle.TextSize = 11
FriendBoxTitle.Font = Enum.Font.GothamBold
FriendBoxTitle.TextXAlignment = Enum.TextXAlignment.Left
FriendBoxTitle.ZIndex = 26
FriendBoxTitle.Parent = FriendBox

local FriendScroll = Instance.new("ScrollingFrame")
FriendScroll.Name = "FriendScroll"
FriendScroll.Position = UDim2.fromOffset(6, 28)
FriendScroll.Size = UDim2.new(1, -12, 1, -34)
FriendScroll.BackgroundTransparency = 1
FriendScroll.BorderSizePixel = 0
FriendScroll.ScrollBarThickness = 2
FriendScroll.ScrollBarImageColor3 = Color3.fromRGB(205, 205, 212)
FriendScroll.ScrollBarImageTransparency = 0.55
FriendScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
FriendScroll.CanvasSize = UDim2.new()
FriendScroll.ZIndex = 25
FriendScroll.Parent = FriendBox

local FriendLayout = Instance.new("UIListLayout")
FriendLayout.Padding = UDim.new(0, 5)
FriendLayout.SortOrder = Enum.SortOrder.LayoutOrder
FriendLayout.Parent = FriendScroll

local FriendPadding = Instance.new("UIPadding")
FriendPadding.PaddingTop = UDim.new(0, 2)
FriendPadding.PaddingBottom = UDim.new(0, 4)
FriendPadding.PaddingLeft = UDim.new(0, 3)
FriendPadding.PaddingRight = UDim.new(0, 4)
FriendPadding.Parent = FriendScroll

local FriendLoadingLabel = Instance.new("TextLabel")
FriendLoadingLabel.Size = UDim2.new(1, -6, 0, 34)
FriendLoadingLabel.BackgroundTransparency = 1
FriendLoadingLabel.Text = "正在读取好友信息..."
FriendLoadingLabel.TextColor3 = Color3.fromRGB(185, 188, 198)
FriendLoadingLabel.TextSize = 10
FriendLoadingLabel.Font = Enum.Font.Gotham
FriendLoadingLabel.TextXAlignment = Enum.TextXAlignment.Left
FriendLoadingLabel.ZIndex = 26
FriendLoadingLabel.Parent = FriendScroll

local function GetUserHeadshot(userId)
    local ok, content =
        pcall(function()
            local image =
                Players:GetUserThumbnailAsync(
                    userId,
                    Enum.ThumbnailType.HeadShot,
                    Enum.ThumbnailSize.Size150x150
                )

            return image
        end)

    if ok then
        return content
    end

    return ""
end

local function ClearFriendRows()
    for _, rowInfo in ipairs(FriendRows) do
        local row =
            rowInfo
            and rowInfo.Frame
            or rowInfo

        if row and row.Parent then
            row:Destroy()
        end
    end

    FriendRows = {}
    FriendRowsByUserId = {}
end

local function CreateFriendRow(info, order)
    local userId =
        tonumber(info.Id or info.UserId)
        or 0

    local displayName =
        tostring(
            info.DisplayName
            or info.Username
            or "未知好友"
        )

    local username =
        tostring(
            info.Username
            or displayName
        )

    local row = Instance.new("Frame")
    row.Name = "Friend_" .. tostring(userId)
    row.Size = UDim2.new(1, -4, 0, 62)
    row.BackgroundColor3 = Color3.fromRGB(16, 16, 21)
    row.BackgroundTransparency = 0.20
    row.BorderSizePixel = 0
    row.LayoutOrder = 10000 + order
    row.ZIndex = 26
    row.Parent = FriendScroll

    AddCorner(row, 8)

    local avatar = Instance.new("ImageLabel")
    avatar.Position = UDim2.fromOffset(6, 8)
    avatar.Size = UDim2.fromOffset(40, 40)
    avatar.BackgroundColor3 = Color3.fromRGB(27, 27, 33)
    avatar.BackgroundTransparency = 0.10
    avatar.BorderSizePixel = 0
    avatar.ScaleType = Enum.ScaleType.Crop
    avatar.Image = ""
    avatar.ZIndex = 27
    avatar.Parent = row

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatar

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.fromOffset(53, 4)
    nameLabel.Size = UDim2.new(0.43, -5, 0, 18)
    nameLabel.Text =
        displayName
        .. " (@"
        .. username
        .. ")"

    nameLabel.TextColor3 = Color3.fromRGB(250, 250, 252)
    nameLabel.TextSize = 9
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.ZIndex = 27
    nameLabel.Parent = row

    local statusLabel = Instance.new("TextLabel")
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.fromOffset(53, 22)
    statusLabel.Size = UDim2.new(0.43, -5, 0, 15)
    statusLabel.Text = "○ 离线"
    statusLabel.TextColor3 = Color3.fromRGB(135, 138, 147)
    statusLabel.TextSize = 8
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.ZIndex = 27
    statusLabel.Parent = row

    local locationLabel = Instance.new("TextLabel")
    locationLabel.BackgroundTransparency = 1
    locationLabel.Position = UDim2.fromOffset(53, 38)
    locationLabel.Size = UDim2.new(0.43, -5, 0, 19)
    locationLabel.Text = "未在游戏中"
    locationLabel.TextColor3 = Color3.fromRGB(120, 123, 132)
    locationLabel.TextSize = 7
    locationLabel.Font = Enum.Font.Gotham
    locationLabel.TextXAlignment = Enum.TextXAlignment.Left
    locationLabel.TextTruncate = Enum.TextTruncate.AtEnd
    locationLabel.ZIndex = 27
    locationLabel.Parent = row

    local remarkBox = Instance.new("TextBox")
    remarkBox.AnchorPoint = Vector2.new(1, 0.5)
    remarkBox.Position = UDim2.new(1, -7, 0.5, 0)
    remarkBox.Size = UDim2.new(0.36, 0, 0, 34)
    remarkBox.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    remarkBox.BackgroundTransparency = 0.12
    remarkBox.BorderSizePixel = 0
    remarkBox.PlaceholderText = "备注..."
    remarkBox.PlaceholderColor3 = Color3.fromRGB(120, 123, 132)
    remarkBox.Text =
        FriendRemarks[userId]
        or ""

    remarkBox.TextColor3 = Color3.fromRGB(240, 240, 244)
    remarkBox.TextSize = 9
    remarkBox.Font = Enum.Font.Gotham
    remarkBox.ClearTextOnFocus = false
    remarkBox.TextXAlignment = Enum.TextXAlignment.Left
    remarkBox.ZIndex = 27
    remarkBox.Parent = row

    AddCorner(remarkBox, 7)

    local remarkPadding = Instance.new("UIPadding")
    remarkPadding.PaddingLeft = UDim.new(0, 7)
    remarkPadding.PaddingRight = UDim.new(0, 7)
    remarkPadding.Parent = remarkBox

    remarkBox.FocusLost:Connect(function()
        local value =
            tostring(remarkBox.Text or "")

        value =
            string.gsub(
                value,
                "^%s+",
                ""
            )

        value =
            string.gsub(
                value,
                "%s+$",
                ""
            )

        FriendRemarks[userId] =
            value
    end)

    task.spawn(function()
        local content =
            GetUserHeadshot(userId)

        if avatar and avatar.Parent then
            avatar.Image = content
        end
    end)

    local rowInfo = {
        Frame = row,
        UserId = userId,
        Username = username,
        DisplayName = displayName,
        Status = statusLabel,
        Location = locationLabel,
        BaseOrder = order
    }

    table.insert(
        FriendRows,
        rowInfo
    )

    FriendRowsByUserId[userId] =
        rowInfo

    return rowInfo
end

local function ApplyFriendPresence(rowInfo, presence)
    if not rowInfo
    or not rowInfo.Frame
    or not rowInfo.Frame.Parent then
        return
    end

    local online =
        presence ~= nil
        and presence.IsOnline ~= false

    if online then
        rowInfo.Status.Text =
            "● 在线"

        rowInfo.Status.TextColor3 =
            Color3.fromRGB(225, 238, 230)

        local lastLocation =
            tostring(
                presence.LastLocation
                or ""
            )

        local gameId =
            tostring(
                presence.GameId
                or ""
            )

        local placeId =
            tonumber(
                presence.PlaceId
            )

        local locationText = ""

        if gameId ~= ""
        and gameId == tostring(game.JobId) then
            locationText =
                "正在玩："
                .. tostring(game.Name)
                .. " · 当前服务器"

        elseif lastLocation ~= "" then
            locationText =
                "正在玩："
                .. lastLocation

            if gameId ~= "" then
                locationText =
                    locationText
                    .. " · 服务器："
                    .. gameId
            elseif placeId then
                locationText =
                    locationText
                    .. " · PlaceId："
                    .. tostring(placeId)
            end

        elseif placeId then
            locationText =
                "在线 · PlaceId："
                .. tostring(placeId)
        else
            locationText =
                "在线 · 当前未进入游戏服务器"
        end

        rowInfo.Location.Text =
            locationText

        rowInfo.Location.TextColor3 =
            Color3.fromRGB(174, 184, 178)

        rowInfo.Frame.LayoutOrder =
            rowInfo.BaseOrder
    else
        rowInfo.Status.Text =
            "○ 离线"

        rowInfo.Status.TextColor3 =
            Color3.fromRGB(135, 138, 147)

        rowInfo.Location.Text =
            "未在游戏中"

        rowInfo.Location.TextColor3 =
            Color3.fromRGB(120, 123, 132)

        rowInfo.Frame.LayoutOrder =
            10000
            + rowInfo.BaseOrder
    end
end

local function RefreshFriendPresence()
    if FriendPresenceBusy then
        return
    end

    if #FriendRows == 0 then
        return
    end

    FriendPresenceBusy = true

    task.spawn(function()
        local onlineMap = {}

        local ok, onlineFriends =
            pcall(function()
                return LocalPlayer:GetFriendsOnlineAsync(
                    200
                )
            end)

        if ok
        and type(onlineFriends) == "table" then
            for _, info in pairs(onlineFriends) do
                local userId =
                    tonumber(
                        info.VisitorId
                        or info.UserId
                        or info.Id
                    )

                if userId then
                    info.IsOnline = true
                    onlineMap[userId] =
                        info
                end
            end
        end

        -- 当前服务器里的好友不依赖Presence缓存，
        -- 每秒都能立即反映进入/离开本服务器。
        for _, player in ipairs(
            Players:GetPlayers()
        ) do
            local rowInfo =
                FriendRowsByUserId[
                    player.UserId
                ]

            if rowInfo then
                onlineMap[player.UserId] = {
                    VisitorId = player.UserId,
                    UserName = player.Name,
                    DisplayName = player.DisplayName,
                    IsOnline = true,
                    LastLocation = tostring(game.Name),
                    PlaceId = game.PlaceId,
                    GameId = game.JobId,
                    LocationType = 4
                }
            end
        end

        local onlineCount = 0

        for userId, rowInfo in pairs(
            FriendRowsByUserId
        ) do
            local presence =
                onlineMap[userId]

            if presence then
                onlineCount =
                    onlineCount + 1
            end

            ApplyFriendPresence(
                rowInfo,
                presence
            )
        end

        FriendBoxTitle.Text =
            "好友在线信息 · "
            .. tostring(onlineCount)
            .. " 在线"

        FriendPresenceBusy = false
    end)
end

local function RefreshFriends()
    FriendRefreshToken =
        FriendRefreshToken + 1

    local token =
        FriendRefreshToken

    ClearFriendRows()

    FriendLoadingLabel.Visible = true
    FriendLoadingLabel.Text =
        "正在读取好友列表..."

    task.spawn(function()
        local ok, pages =
            pcall(function()
                return Players:GetFriendsAsync(
                    LocalPlayer.UserId
                )
            end)

        if token ~= FriendRefreshToken then
            return
        end

        if not ok or not pages then
            FriendLoadingLabel.Text =
                "好友列表读取失败"
            return
        end

        local allFriends = {}
        local pageGuard = 0

        while pages do
            pageGuard =
                pageGuard + 1

            local pageItems = {}

            local pageOk =
                pcall(function()
                    pageItems =
                        pages:GetCurrentPage()
                end)

            if not pageOk then
                break
            end

            for _, info in ipairs(
                pageItems
            ) do
                table.insert(
                    allFriends,
                    info
                )
            end

            if pages.IsFinished
            or pageGuard >= 10 then
                break
            end

            local advanceOk =
                pcall(function()
                    pages:AdvanceToNextPageAsync()
                end)

            if not advanceOk then
                break
            end
        end

        if token ~= FriendRefreshToken then
            return
        end

        table.sort(
            allFriends,
            function(a, b)
                return tostring(
                    a.DisplayName
                    or a.Username
                    or ""
                ) < tostring(
                    b.DisplayName
                    or b.Username
                    or ""
                )
            end
        )

        FriendLoadingLabel.Visible =
            #allFriends == 0

        if #allFriends == 0 then
            FriendLoadingLabel.Text =
                "暂无好友信息"
            return
        end

        for index, info in ipairs(
            allFriends
        ) do
            if token ~= FriendRefreshToken then
                return
            end

            CreateFriendRow(
                info,
                index
            )

            if index % 12 == 0 then
                task.wait()
            end
        end

        FriendLoadingLabel.Visible =
            false

        RefreshFriendPresence()
    end)
end


task.spawn(function()
    local avatar =
        GetUserHeadshot(
            LocalPlayer.UserId
        )

    if PlayerAvatar
    and PlayerAvatar.Parent then
        PlayerAvatar.Image =
            avatar
    end
end)

PlayerNameLabel.Text =
    "玩家名字："
    .. tostring(LocalPlayer.DisplayName)

PlayerAgeLabel.Text =
    "账号年龄："
    .. tostring(LocalPlayer.AccountAge)
    .. " 天"

PlayerUsernameLabel.Text =
    "用户名：@"
    .. tostring(LocalPlayer.Name)

-- 主页其余状态卡
local ProcessCard, ProcessValue =
    CreateHomeCard(
        "正在运行的脚本 / 运行状态",
        92
    )

ProcessCard.LayoutOrder = 2

local function CreatePerformanceCard()
    local RunService = game:GetService("RunService")

    local card = Instance.new("Frame")
    card.Name = "PerformanceCard"
    card.Size = UDim2.new(1, -4, 0, 288)
    card.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
    card.BackgroundTransparency = 0.16
    card.BorderSizePixel = 0
    card.LayoutOrder = 3
    card.ZIndex = 22
    card.Parent = HomeScroll
    AddCorner(card, 12)
    AddRainbowBorder(card, 1.35, 0.035, 3.25)

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(13, 7)
    title.Size = UDim2.new(1, -26, 0, 20)
    title.Text = "实时帧率 / 网络延迟"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 24
    title.Parent = card

    local liveLabel = Instance.new("TextLabel")
    liveLabel.BackgroundTransparency = 1
    liveLabel.Position = UDim2.fromOffset(13, 29)
    liveLabel.Size = UDim2.new(0.46, -4, 0, 20)
    liveLabel.Text = "FPS：--    Ping：-- ms"
    liveLabel.TextColor3 = Color3.fromRGB(245, 245, 248)
    liveLabel.TextSize = 10
    liveLabel.Font = Enum.Font.GothamMedium
    liveLabel.TextXAlignment = Enum.TextXAlignment.Left
    liveLabel.ZIndex = 24
    liveLabel.Parent = card

    local avgTopLabel = Instance.new("TextLabel")
    avgTopLabel.BackgroundTransparency = 1
    avgTopLabel.Position = UDim2.new(0.46, 4, 0, 29)
    avgTopLabel.Size = UDim2.new(0.27, -6, 0, 20)
    avgTopLabel.Text = "AVG：--"
    avgTopLabel.TextColor3 = Color3.fromRGB(245, 245, 248)
    avgTopLabel.TextSize = 10
    avgTopLabel.Font = Enum.Font.GothamMedium
    avgTopLabel.TextXAlignment = Enum.TextXAlignment.Left
    avgTopLabel.ZIndex = 24
    avgTopLabel.Parent = card

    local floatToggle = Instance.new("TextButton")
    floatToggle.AnchorPoint = Vector2.new(1, 0)
    floatToggle.Position = UDim2.new(1, -12, 0, 28)
    floatToggle.Size = UDim2.new(0.25, 0, 0, 21)
    floatToggle.BackgroundColor3 = Color3.fromRGB(48, 48, 56)
    floatToggle.BackgroundTransparency = 0.10
    floatToggle.BorderSizePixel = 0
    floatToggle.Text = "实时帧率 · 关"
    floatToggle.TextColor3 = Color3.fromRGB(245, 245, 248)
    floatToggle.TextSize = 8
    floatToggle.Font = Enum.Font.GothamMedium
    floatToggle.AutoButtonColor = false
    floatToggle.ZIndex = 25
    floatToggle.Parent = card
    AddCorner(floatToggle, 12)

    local floatingFPS = Instance.new("Frame")
    floatingFPS.Name = "DB_FloatingFPS"
    floatingFPS.AnchorPoint = Vector2.new(0.5, 0.5)
    floatingFPS.Position = UDim2.fromScale(0.5, 0.5)
    floatingFPS.Size = UDim2.fromOffset(72, 27)
    floatingFPS.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    floatingFPS.BackgroundTransparency = 0.14
    floatingFPS.BorderSizePixel = 0
    floatingFPS.Active = true
    floatingFPS.Visible = false
    floatingFPS.ZIndex = 1000
    floatingFPS.Parent = MainGui
    AddCorner(floatingFPS, 14)
    AddRainbowBorder(floatingFPS, 1.15, 0.03, 3.0)

    local floatingText = Instance.new("TextLabel")
    floatingText.Size = UDim2.fromScale(1, 1)
    floatingText.BackgroundTransparency = 1
    floatingText.Text = "FPS --"
    floatingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    floatingText.TextSize = 11
    floatingText.Font = Enum.Font.GothamBold
    floatingText.ZIndex = 1001
    floatingText.Parent = floatingFPS

    local floatingEnabled = false
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local dragStartPosition = nil

    local function setFloatingEnabled(enabled)
        floatingEnabled = enabled == true
        floatingFPS.Visible = floatingEnabled
        floatToggle.Text = floatingEnabled and "实时帧率 · 开" or "实时帧率 · 关"
        floatToggle.BackgroundColor3 = floatingEnabled and Color3.fromRGB(46, 153, 78) or Color3.fromRGB(48, 48, 56)
    end

    floatToggle.Activated:Connect(function()
        setFloatingEnabled(not floatingEnabled)
    end)

    floatingFPS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            dragStartPosition = floatingFPS.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    floatingFPS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput and dragStart and dragStartPosition then
            local delta = input.Position - dragStart
            floatingFPS.Position = UDim2.new(
                dragStartPosition.X.Scale,
                dragStartPosition.X.Offset + delta.X,
                dragStartPosition.Y.Scale,
                dragStartPosition.Y.Offset + delta.Y
            )
        end
    end)

    -- MAX / MIN / AVG / JITTER / 5% LOW
    local statsFrame = Instance.new("Frame")
    statsFrame.Position = UDim2.fromOffset(10, 53)
    statsFrame.Size = UDim2.new(1, -20, 0, 43)
    statsFrame.BackgroundTransparency = 1
    statsFrame.ZIndex = 24
    statsFrame.Parent = card

    local statsLayout = Instance.new("UIListLayout")
    statsLayout.FillDirection = Enum.FillDirection.Horizontal
    statsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    statsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    statsLayout.Padding = UDim.new(0, 2)
    statsLayout.Parent = statsFrame

    local statValues = {}

    local function createStat(nameText)
        local cell = Instance.new("Frame")
        cell.Size = UDim2.new(0.2, -2, 1, 0)
        cell.BackgroundTransparency = 1
        cell.ZIndex = 24
        cell.Parent = statsFrame

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0, 14)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = nameText
        nameLabel.TextColor3 = Color3.fromRGB(145, 148, 158)
        nameLabel.TextSize = 7
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.ZIndex = 25
        nameLabel.Parent = cell

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Position = UDim2.fromOffset(0, 14)
        valueLabel.Size = UDim2.new(1, 0, 0, 20)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = "--"
        valueLabel.TextColor3 = Color3.fromRGB(238, 240, 246)
        valueLabel.TextSize = 11
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.ZIndex = 25
        valueLabel.Parent = cell
        statValues[nameText] = valueLabel
    end

    createStat("MAX")
    createStat("MIN")
    createStat("AVG")
    createStat("JITTER")
    createStat("5% LOW")

    local chart = Instance.new("Frame")
    chart.Name = "FPSChart"
    chart.Position = UDim2.fromOffset(35, 102)
    chart.Size = UDim2.new(1, -50, 1, -122)
    chart.BackgroundColor3 = Color3.fromRGB(18, 19, 24)
    chart.BackgroundTransparency = 0.38
    chart.BorderSizePixel = 0
    chart.ClipsDescendants = false
    chart.ZIndex = 23
    chart.Parent = card
    AddCorner(chart, 7)

    local haze = Instance.new("Frame")
    haze.Size = UDim2.fromScale(1, 1)
    haze.BackgroundColor3 = Color3.fromRGB(70, 73, 84)
    haze.BackgroundTransparency = 0.93
    haze.BorderSizePixel = 0
    haze.ZIndex = 23
    haze.Parent = chart
    AddCorner(haze, 7)

    local grid = Instance.new("Frame")
    grid.Size = UDim2.fromScale(1, 1)
    grid.BackgroundTransparency = 1
    grid.ClipsDescendants = true
    grid.ZIndex = 24
    grid.Parent = chart

    local fpsTicks = {0, 10, 15, 30, 40, 60, 90, 120}
    for _, value in ipairs(fpsTicks) do
        local yScale = 1 - math.clamp(value / 120, 0, 1)
        local major = value == 0 or value == 30 or value == 60 or value == 90 or value == 120

        local line = Instance.new("Frame")
        line.AnchorPoint = Vector2.new(0, 0.5)
        line.Position = UDim2.new(0, 0, yScale, 0)
        line.Size = UDim2.new(1, 0, 0, 1)
        line.BackgroundColor3 = Color3.fromRGB(205, 208, 218)
        line.BackgroundTransparency = major and 0.84 or 0.93
        line.BorderSizePixel = 0
        line.ZIndex = 24
        line.Parent = grid

        local label = Instance.new("TextLabel")
        label.AnchorPoint = Vector2.new(1, 0.5)
        label.Position = UDim2.new(0, -5, yScale, 0)
        label.Size = UDim2.fromOffset(27, 13)
        label.BackgroundTransparency = 1
        label.Text = tostring(value)
        label.TextColor3 = Color3.fromRGB(157, 160, 170)
        label.TextSize = 7
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Right
        label.ZIndex = 25
        label.Parent = chart
    end

    for i = 1, 7 do
        local line = Instance.new("Frame")
        line.AnchorPoint = Vector2.new(0.5, 0)
        line.Position = UDim2.new(i / 8, 0, 0, 0)
        line.Size = UDim2.new(0, 1, 1, 0)
        line.BackgroundColor3 = Color3.fromRGB(205, 208, 218)
        line.BackgroundTransparency = 0.93
        line.BorderSizePixel = 0
        line.ZIndex = 24
        line.Parent = grid
    end

    local yAxis = Instance.new("Frame")
    yAxis.Size = UDim2.new(0, 2, 1, 0)
    yAxis.BackgroundColor3 = Color3.fromRGB(220, 223, 230)
    yAxis.BackgroundTransparency = 0.30
    yAxis.BorderSizePixel = 0
    yAxis.ZIndex = 27
    yAxis.Parent = chart

    local yArrow = Instance.new("TextLabel")
    yArrow.AnchorPoint = Vector2.new(0.5, 0.5)
    yArrow.Position = UDim2.fromOffset(0, -1)
    yArrow.Size = UDim2.fromOffset(15, 15)
    yArrow.BackgroundTransparency = 1
    yArrow.Text = "↑"
    yArrow.TextColor3 = Color3.fromRGB(232, 234, 240)
    yArrow.TextSize = 14
    yArrow.Font = Enum.Font.GothamBold
    yArrow.ZIndex = 29
    yArrow.Parent = chart

    local xAxis = Instance.new("Frame")
    xAxis.AnchorPoint = Vector2.new(0, 1)
    xAxis.Position = UDim2.new(0, 0, 1, 0)
    xAxis.Size = UDim2.new(1, 0, 0, 2)
    xAxis.BackgroundColor3 = Color3.fromRGB(220, 223, 230)
    xAxis.BackgroundTransparency = 0.30
    xAxis.BorderSizePixel = 0
    xAxis.ZIndex = 27
    xAxis.Parent = chart

    local xArrow = Instance.new("TextLabel")
    xArrow.AnchorPoint = Vector2.new(0.5, 0.5)
    xArrow.Position = UDim2.new(1, 2, 1, 0)
    xArrow.Size = UDim2.fromOffset(15, 15)
    xArrow.BackgroundTransparency = 1
    xArrow.Text = "→"
    xArrow.TextColor3 = Color3.fromRGB(232, 234, 240)
    xArrow.TextSize = 14
    xArrow.Font = Enum.Font.GothamBold
    xArrow.ZIndex = 29
    xArrow.Parent = chart

    local startTimeLabel = Instance.new("TextLabel")
    startTimeLabel.Position = UDim2.new(0, 3, 1, 3)
    startTimeLabel.Size = UDim2.fromOffset(54, 13)
    startTimeLabel.BackgroundTransparency = 1
    startTimeLabel.Text = "0:00"
    startTimeLabel.TextColor3 = Color3.fromRGB(150, 153, 163)
    startTimeLabel.TextSize = 7
    startTimeLabel.Font = Enum.Font.Gotham
    startTimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    startTimeLabel.ZIndex = 25
    startTimeLabel.Parent = chart

    local midTimeLabel = startTimeLabel:Clone()
    midTimeLabel.AnchorPoint = Vector2.new(0.5, 0)
    midTimeLabel.Position = UDim2.new(0.5, 0, 1, 3)
    midTimeLabel.TextXAlignment = Enum.TextXAlignment.Center
    midTimeLabel.Parent = chart

    local endTimeLabel = startTimeLabel:Clone()
    endTimeLabel.AnchorPoint = Vector2.new(1, 0)
    endTimeLabel.Position = UDim2.new(1, -3, 1, 3)
    endTimeLabel.TextXAlignment = Enum.TextXAlignment.Right
    endTimeLabel.Parent = chart

    -- 每0.5秒写入一次；每个FPS值来自最近1.5秒的滚动窗口。
    local SAMPLE_INTERVAL = 0.5
    local SMOOTH_WINDOW = 1.5
    local HISTORY_WINDOW = 300
    local MAX_HISTORY = 620
    local MAX_DRAW_POINTS = 120

    local state = {
        SessionStart = time(),
        SampleClock = 0,
        FrameTimes = {},
        Samples = {},
        SmoothedFPS = nil,
        SmoothedPing = nil,
        Segments = {},
        LastStatsUpdate = 0
    }

    for i = 1, MAX_DRAW_POINTS - 1 do
        local segment = Instance.new("Frame")
        segment.Name = "FPSLine_" .. tostring(i)
        segment.AnchorPoint = Vector2.new(0, 0.5)
        segment.Size = UDim2.fromOffset(0, 2)
        segment.BackgroundColor3 = Color3.fromRGB(194, 196, 201)
        segment.BackgroundTransparency = 0.08
        segment.BorderSizePixel = 0
        segment.Visible = false
        segment.ZIndex = 30
        segment.Parent = chart
        state.Segments[i] = segment
    end

    local function formatTime(seconds)
        seconds = math.max(0, math.floor(seconds or 0))
        local minutes = math.floor(seconds / 60)
        local remain = seconds % 60
        return tostring(minutes) .. ":" .. string.format("%02d", remain)
    end

    local function getWindowFPS(now)
        local cutoff = now - SMOOTH_WINDOW
        while #state.FrameTimes > 0 and state.FrameTimes[1].Time < cutoff do
            table.remove(state.FrameTimes, 1)
        end

        local count = #state.FrameTimes
        if count < 2 then
            return nil
        end

        local totalDt = 0
        for _, frame in ipairs(state.FrameTimes) do
            totalDt = totalDt + frame.Dt
        end

        if totalDt <= 0 then
            return nil
        end

        return math.clamp(count / totalDt, 1, 240)
    end

    local function makePlotSamples()
        local source = state.Samples
        local count = #source
        if count <= MAX_DRAW_POINTS then
            local copy = {}
            for i = 1, count do
                copy[i] = source[i]
            end
            return copy
        end

        local result = {}
        local bucketSize = count / MAX_DRAW_POINTS
        for bucket = 1, MAX_DRAW_POINTS do
            local firstIndex = math.floor((bucket - 1) * bucketSize) + 1
            local lastIndex = math.min(count, math.floor(bucket * bucketSize))
            local sumFPS, sumTime, n = 0, 0, 0

            for i = firstIndex, lastIndex do
                local sample = source[i]
                if sample then
                    sumFPS = sumFPS + sample.FPS
                    sumTime = sumTime + sample.Time
                    n = n + 1
                end
            end

            if n > 0 then
                table.insert(result, {FPS = sumFPS / n, Time = sumTime / n})
            end
        end
        return result
    end

    local function updateStats()
        local samples = state.Samples
        local count = #samples
        if count == 0 then return end

        local values = {}
        local sum = 0
        local maxValue = -math.huge
        local minValue = math.huge

        for i, sample in ipairs(samples) do
            local value = sample.FPS
            values[i] = value
            sum = sum + value
            maxValue = math.max(maxValue, value)
            minValue = math.min(minValue, value)
        end

        local avg = sum / count
        local variance = 0
        for _, value in ipairs(values) do
            local d = value - avg
            variance = variance + d * d
        end

        local deviation = math.sqrt(variance / math.max(1, count))
        local jitter = avg > 0 and (deviation / avg * 100) or 0
        table.sort(values)

        local lowCount = math.max(1, math.floor(count * 0.05 + 0.5))
        local lowSum = 0
        for i = 1, lowCount do
            lowSum = lowSum + values[i]
        end
        local low5 = lowSum / lowCount

        statValues["MAX"].Text = string.format("%.1f", maxValue)
        statValues["MIN"].Text = string.format("%.1f", minValue)
        statValues["AVG"].Text = string.format("%.1f", avg)
        statValues["JITTER"].Text = string.format("%.1f%%", jitter)
        statValues["5% LOW"].Text = string.format("%.1f", low5)
    end

    local function refreshGraph()
        local plot = makePlotSamples()
        local width = math.max(1, chart.AbsoluteSize.X)
        local height = math.max(1, chart.AbsoluteSize.Y)
        local elapsed = math.max(0, time() - state.SessionStart)
        local rightTime = elapsed
        local leftTime = math.max(0, rightTime - HISTORY_WINDOW)
        local span = math.max(1, rightTime - leftTime)

        for i, segment in ipairs(state.Segments) do
            local a = plot[i]
            local b = plot[i + 1]
            if a and b then
                local x1 = math.clamp((a.Time - leftTime) / span, 0, 1) * width
                local x2 = math.clamp((b.Time - leftTime) / span, 0, 1) * width
                local y1 = (1 - math.clamp(a.FPS / 120, 0, 1)) * height
                local y2 = (1 - math.clamp(b.FPS / 120, 0, 1)) * height
                local dx = x2 - x1
                local dy = y2 - y1

                segment.Position = UDim2.fromOffset(x1, y1)
                segment.Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), 2)
                segment.Rotation = math.deg(math.atan2(dy, dx))
                segment.Visible = true
            else
                segment.Visible = false
            end
        end

        startTimeLabel.Text = formatTime(leftTime)
        midTimeLabel.Text = formatTime(leftTime + span * 0.5)
        endTimeLabel.Text = formatTime(rightTime)
    end

    local function takeSample()
        local now = time()
        local rawFPS = getWindowFPS(now)
        if not rawFPS then return end

        if not state.SmoothedFPS then
            state.SmoothedFPS = rawFPS
        else
            state.SmoothedFPS = state.SmoothedFPS + (rawFPS - state.SmoothedFPS) * 0.38
        end

        local pingOk, ping = pcall(function()
            return LocalPlayer:GetNetworkPing()
        end)

        if pingOk and type(ping) == "number" then
            local pingMS = ping * 1000
            if not state.SmoothedPing then
                state.SmoothedPing = pingMS
            else
                state.SmoothedPing = state.SmoothedPing + (pingMS - state.SmoothedPing) * 0.30
            end
        end

        local elapsed = now - state.SessionStart
        table.insert(state.Samples, {FPS = state.SmoothedFPS, Time = elapsed})

        local cutoff = math.max(0, elapsed - HISTORY_WINDOW - 2)
        while #state.Samples > 0 and state.Samples[1].Time < cutoff do
            table.remove(state.Samples, 1)
        end
        while #state.Samples > MAX_HISTORY do
            table.remove(state.Samples, 1)
        end

        local displayFPS = math.floor(state.SmoothedFPS + 0.5)
        local displayPing = math.floor((state.SmoothedPing or 0) + 0.5)
        liveLabel.Text = "FPS：" .. tostring(displayFPS) .. "    Ping：" .. tostring(displayPing) .. " ms"

        local runningAverage = 0

        if #state.Samples > 0 then
            local sumFPS = 0

            for _, sample in ipairs(state.Samples) do
                sumFPS = sumFPS + sample.FPS
            end

            runningAverage = sumFPS / #state.Samples
        end

        avgTopLabel.Text =
            "AVG："
            .. string.format("%.1f", runningAverage)

        floatingText.Text = "FPS " .. tostring(displayFPS)
        refreshGraph()

        if now - state.LastStatsUpdate >= 1.5 then
            state.LastStatsUpdate = now
            updateStats()
        end
    end

    RunService.RenderStepped:Connect(function(dt)
        local now = time()
        table.insert(state.FrameTimes, {Time = now, Dt = dt})
        state.SampleClock = state.SampleClock + dt

        if state.SampleClock >= SAMPLE_INTERVAL then
            state.SampleClock = state.SampleClock - SAMPLE_INTERVAL
            takeSample()
        end
    end)

    chart:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshGraph)

    return {
        Card = card,
        Refresh = refreshGraph,
        SetFloatingVisible = setFloatingEnabled,
        Floating = floatingFPS
    }
end

local PerformanceUI =
    CreatePerformanceCard()

local ServerCard, ServerValue =
    CreateHomeCard(
        "服务器在线人数",
        58
    )

ServerCard.LayoutOrder = 4

local PlayersCard, PlayersValue =
    CreateHomeCard(
        "服务器玩家",
        118
    )

PlayersCard.LayoutOrder = 5

local TimeCard, TimeValue =
    CreateHomeCard(
        "现实时间 · 北京时间",
        66
    )

TimeCard.LayoutOrder = 6

local function DBGetBeijingTimestamp()
    local unixNow = nil

    local ok, value =
        pcall(function()
            return workspace:GetServerTimeNow()
        end)

    if ok
    and type(value) == "number"
    and value > 1000000000 then
        unixNow = value
    else
        unixNow = os.time()
    end

    return os.date(
        "!%Y-%m-%d %H:%M:%S",
        math.floor(unixNow + 8 * 60 * 60)
    )
end

local function DBBuildProcessText()
    local lines = {
        "DB 主程序  ·  "
        .. DBRuntimeState.MainStatus
    }

    local shown = 0

    for i = #DBRuntimeState.ScriptOrder, 1, -1 do
        local name =
            DBRuntimeState.ScriptOrder[i]

        local info =
            DBRuntimeState.Scripts[name]

        if info then
            table.insert(
                lines,
                name
                .. "  ·  "
                .. tostring(info.Status)
            )

            shown = shown + 1

            if shown >= 4 then
                break
            end
        end
    end

    if shown == 0 then
        table.insert(
            lines,
            "外部脚本  ·  暂无"
        )
    end

    return table.concat(lines, "\n")
end

local function DBBuildPlayersText()
    local players =
        Players:GetPlayers()

    local lines = {}
    local maxShow =
        math.min(
            10,
            #players
        )

    for i = 1, maxShow do
        local p = players[i]

        table.insert(
            lines,
            tostring(p.DisplayName)
            .. " (@"
            .. tostring(p.Name)
            .. ")"
        )
    end

    if #players > maxShow then
        table.insert(
            lines,
            "……另有 "
            .. tostring(
                #players - maxShow
            )
            .. " 名玩家"
        )
    end

    if #lines == 0 then
        return "暂无玩家"
    end

    return table.concat(
        lines,
        "\n"
    )
end

RefreshHomePage = function()
    if not ProcessValue
    or not ProcessValue.Parent then
        return
    end

    ProcessValue.Text =
        DBBuildProcessText()

    ServerValue.Text =
        "当前在线："
        .. tostring(
            #Players:GetPlayers()
        )
        .. " 人"

    PlayersValue.Text =
        DBBuildPlayersText()

    TimeValue.Text =
        DBGetBeijingTimestamp()
        .. "\nUTC+8 · 中国标准时间"
end

local function ShowHomePage()
    if AICommandUI
    and AICommandUI.Popup
    and AICommandUI.Popup.Visible then
        AICommandUI.SetVisible(false)
    end

    ListScroll.Visible = false
    AIPanel.Visible = false
    HomePanel.Visible = true
    State.CurrentCategory = "主页"

    RefreshHomePage()

    if #FriendRows == 0 then
        RefreshFriends()
    else
        RefreshFriendPresence()
    end
end

task.spawn(function()
    while MainGui
    and MainGui.Parent do
        if HomePanel.Visible then
            RefreshHomePage()
            RefreshFriendPresence()
        end

        task.wait(1)
    end
end)

Players.PlayerAdded:Connect(function()
    if HomePanel.Visible then
        task.defer(RefreshHomePage)
    end
end)

Players.PlayerRemoving:Connect(function()
    if HomePanel.Visible then
        task.defer(RefreshHomePage)
    end
end)

AIPanel = Instance.new("Frame")
AIPanel.Name = "DB_AI_Panel"
AIPanel.Size = UDim2.new(1, -8, 1, -4)
AIPanel.Position = UDim2.fromOffset(4, 2)
AIPanel.BackgroundTransparency = 1
AIPanel.Visible = false
AIPanel.ZIndex = 20
AIPanel.Parent = RightList

local AIHeader = Instance.new("Frame")
AIHeader.Name = "AIHeader"
AIHeader.Size = UDim2.new(1, 0, 0, 38)
AIHeader.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
AIHeader.BackgroundTransparency = 0.20
AIHeader.BorderSizePixel = 0
AIHeader.ZIndex = 21
AIHeader.Parent = AIPanel
AddCorner(AIHeader, 11)

local AIHeaderTitle = Instance.new("TextLabel")
AIHeaderTitle.Name = "Title"
AIHeaderTitle.BackgroundTransparency = 1
AIHeaderTitle.Position = UDim2.fromOffset(11, 3)
AIHeaderTitle.Size = UDim2.new(0, 90, 0, 21)
AIHeaderTitle.Text = "DB AI"
AIHeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AIHeaderTitle.TextSize = 16
AIHeaderTitle.Font = Enum.Font.GothamBold
AIHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
AIHeaderTitle.ZIndex = 22
AIHeaderTitle.Parent = AIHeader

StartRainbowFlow(
    AIHeaderTitle,
    3.60,
    NumberSequence.new(0)
)

local AIHeaderSub = Instance.new("TextLabel")
AIHeaderSub.BackgroundTransparency = 1
AIHeaderSub.Position = UDim2.fromOffset(11, 21)
AIHeaderSub.Size = UDim2.new(1, -20, 0, 14)
AIHeaderSub.Text = "聊天 · 天气 · 新闻 · 百科 · 游戏 · DB"
AIHeaderSub.TextColor3 = Color3.fromRGB(174, 176, 184)
AIHeaderSub.TextSize = 9
AIHeaderSub.Font = Enum.Font.GothamMedium
AIHeaderSub.TextXAlignment = Enum.TextXAlignment.Left
AIHeaderSub.ZIndex = 22
AIHeaderSub.Parent = AIHeader

local AIChatScroll = Instance.new("ScrollingFrame")
AIChatScroll.Name = "AIChat"
AIChatScroll.Position = UDim2.fromOffset(0, 44)
AIChatScroll.Size = UDim2.new(1, 0, 1, -88)
AIChatScroll.BackgroundTransparency = 1
AIChatScroll.BorderSizePixel = 0
AIChatScroll.ScrollBarThickness = 2
AIChatScroll.ScrollBarImageColor3 = Color3.fromRGB(190, 190, 198)
AIChatScroll.ScrollBarImageTransparency = 0.55
AIChatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
AIChatScroll.CanvasSize = UDim2.new()
AIChatScroll.ZIndex = 21
AIChatScroll.Parent = AIPanel

local AIChatLayout = Instance.new("UIListLayout")
AIChatLayout.Padding = UDim.new(0, 6)
AIChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
AIChatLayout.Parent = AIChatScroll

local AIInputBar = Instance.new("Frame")
AIInputBar.Name = "InputBar"
AIInputBar.AnchorPoint = Vector2.new(0, 1)
AIInputBar.Position = UDim2.new(0, 0, 1, 0)
AIInputBar.Size = UDim2.new(1, 0, 0, 38)
AIInputBar.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
AIInputBar.BackgroundTransparency = 0.18
AIInputBar.BorderSizePixel = 0
AIInputBar.ZIndex = 24
AIInputBar.Parent = AIPanel
AddCorner(AIInputBar, 11)

local AIPlusButton = Instance.new("TextButton")
AIPlusButton.Name = "CommandPlus"
AIPlusButton.Position = UDim2.fromOffset(5, 5)
AIPlusButton.Size = UDim2.fromOffset(28, 28)
AIPlusButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
AIPlusButton.BackgroundTransparency = 0.06
AIPlusButton.BorderSizePixel = 0
AIPlusButton.Text = "+"
AIPlusButton.TextColor3 = Color3.fromRGB(245, 245, 248)
AIPlusButton.TextSize = 20
AIPlusButton.Font = Enum.Font.GothamMedium
AIPlusButton.AutoButtonColor = false
AIPlusButton.ZIndex = 26
AIPlusButton.Parent = AIInputBar

local AIPlusCorner = Instance.new("UICorner")
AIPlusCorner.CornerRadius = UDim.new(1, 0)
AIPlusCorner.Parent = AIPlusButton

local AIPlusStroke = Instance.new("UIStroke")
AIPlusStroke.Thickness = 1
AIPlusStroke.Color = Color3.fromRGB(80, 82, 92)
AIPlusStroke.Transparency = 0.28
AIPlusStroke.Parent = AIPlusButton

local AIInput = Instance.new("TextBox")
AIInput.Name = "AIInput"
AIInput.Position = UDim2.fromOffset(39, 5)
AIInput.Size = UDim2.new(1, -93, 1, -10)
AIInput.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
AIInput.BackgroundTransparency = 0.08
AIInput.BorderSizePixel = 0
AIInput.ClearTextOnFocus = false
AIInput.MultiLine = false
AIInput.PlaceholderText = "聊天，或问服务器 / 天气 / 新闻 / 地名 / 脚本"
AIInput.PlaceholderColor3 = Color3.fromRGB(125, 127, 136)
AIInput.Text = ""
AIInput.TextColor3 = Color3.fromRGB(245, 245, 248)
AIInput.TextSize = 12
AIInput.Font = Enum.Font.GothamMedium
AIInput.TextXAlignment = Enum.TextXAlignment.Left
AIInput.ZIndex = 25
AIInput.Parent = AIInputBar
AddCorner(AIInput, 8)

local AIInputPadding = Instance.new("UIPadding")
AIInputPadding.PaddingLeft = UDim.new(0, 9)
AIInputPadding.PaddingRight = UDim.new(0, 7)
AIInputPadding.Parent = AIInput

local AISend = Instance.new("TextButton")
AISend.Name = "Send"
AISend.AnchorPoint = Vector2.new(1, 0)
AISend.Position = UDim2.new(1, -5, 0, 5)
AISend.Size = UDim2.fromOffset(44, 28)
AISend.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
AISend.BackgroundTransparency = 0.08
AISend.BorderSizePixel = 0
AISend.Text = "发送"
AISend.TextColor3 = Color3.fromRGB(245, 245, 248)
AISend.TextSize = 11
AISend.Font = Enum.Font.GothamBold
AISend.AutoButtonColor = false
AISend.ZIndex = 25
AISend.Parent = AIInputBar
AddCorner(AISend, 8)

local AIAllScripts = {}

for categoryName, items in pairs(ScriptDatabase) do
    for _, item in ipairs(items) do
        table.insert(AIAllScripts, {
            Category = categoryName,
            Item = item,
            Name = tostring(item.Name or "未命名脚本")
        })
    end
end

table.sort(AIAllScripts, function(a, b)
    return a.Name < b.Name
end)

local function AISetupCommandMenu()
    local popup = Instance.new("CanvasGroup")
    popup.Name = "AICommandPopup"
    popup.AnchorPoint = Vector2.new(0, 1)
    popup.Position = UDim2.new(0, 0, 1, -44)
    popup.Size = UDim2.new(0.54, -4, 0, 96)
    popup.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
    popup.BackgroundTransparency = 0.14
    popup.BorderSizePixel = 0
    popup.GroupTransparency = 1
    popup.ClipsDescendants = true
    popup.Visible = false
    popup.ZIndex = 90
    popup.Parent = AIPanel
    AddCorner(popup, 12)

    local popupScale = Instance.new("UIScale")
    popupScale.Scale = 0.88
    popupScale.Parent = popup

    local busy = false
    local selectedCategory = "全部"
    local categoryButtons = {}
    local scriptRows = {}
    local pendingEntry = nil
    local pendingText = nil
    local pendingPanelSection = nil
    local pendingPanelText = nil

    local rootMenu = Instance.new("Frame")
    rootMenu.Name = "RootMenu"
    rootMenu.Size = UDim2.fromScale(1, 1)
    rootMenu.BackgroundTransparency = 1
    rootMenu.ZIndex = 91
    rootMenu.Parent = popup

    local executeOption = Instance.new("TextButton")
    executeOption.Name = "Execute"
    executeOption.Position = UDim2.fromOffset(7, 7)
    executeOption.Size = UDim2.new(1, -14, 0, 36)
    executeOption.BackgroundColor3 = Color3.fromRGB(48, 48, 56)
    executeOption.BackgroundTransparency = 0.16
    executeOption.BorderSizePixel = 0
    executeOption.Text = "执行"
    executeOption.TextColor3 = Color3.fromRGB(248, 248, 250)
    executeOption.TextSize = 12
    executeOption.Font = Enum.Font.GothamMedium
    executeOption.TextXAlignment = Enum.TextXAlignment.Left
    executeOption.AutoButtonColor = false
    executeOption.ZIndex = 92
    executeOption.Parent = rootMenu
    AddCorner(executeOption, 9)

    local executePadding = Instance.new("UIPadding")
    executePadding.PaddingLeft = UDim.new(0, 12)
    executePadding.Parent = executeOption

    local playerPanelOption = Instance.new("TextButton")
    playerPanelOption.Name = "ViewPlayerPanel"
    playerPanelOption.Position = UDim2.fromOffset(7, 51)
    playerPanelOption.Size = UDim2.new(1, -14, 0, 36)
    playerPanelOption.BackgroundColor3 = Color3.fromRGB(48, 48, 56)
    playerPanelOption.BackgroundTransparency = 0.16
    playerPanelOption.BorderSizePixel = 0
    playerPanelOption.Text = "查看玩家面板"
    playerPanelOption.TextColor3 = Color3.fromRGB(248, 248, 250)
    playerPanelOption.TextSize = 12
    playerPanelOption.Font = Enum.Font.GothamMedium
    playerPanelOption.TextXAlignment = Enum.TextXAlignment.Left
    playerPanelOption.AutoButtonColor = false
    playerPanelOption.ZIndex = 92
    playerPanelOption.Parent = rootMenu
    AddCorner(playerPanelOption, 9)

    local playerPanelPadding = Instance.new("UIPadding")
    playerPanelPadding.PaddingLeft = UDim.new(0, 12)
    playerPanelPadding.Parent = playerPanelOption

    local picker = Instance.new("Frame")
    picker.Name = "ScriptPicker"
    picker.Size = UDim2.fromScale(1, 1)
    picker.BackgroundTransparency = 1
    picker.Visible = false
    picker.ZIndex = 91
    picker.Parent = popup

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 34)
    header.BackgroundTransparency = 1
    header.ZIndex = 92
    header.Parent = picker

    local backButton = Instance.new("TextButton")
    backButton.Position = UDim2.fromOffset(6, 5)
    backButton.Size = UDim2.fromOffset(30, 24)
    backButton.BackgroundColor3 = Color3.fromRGB(48, 48, 56)
    backButton.BackgroundTransparency = 0.18
    backButton.BorderSizePixel = 0
    backButton.Text = "‹"
    backButton.TextColor3 = Color3.fromRGB(240, 240, 244)
    backButton.TextSize = 20
    backButton.Font = Enum.Font.GothamMedium
    backButton.AutoButtonColor = false
    backButton.ZIndex = 93
    backButton.Parent = header
    AddCorner(backButton, 7)

    local title = Instance.new("TextLabel")
    title.Position = UDim2.fromOffset(43, 0)
    title.Size = UDim2.new(1, -50, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "选择要执行的脚本"
    title.TextColor3 = Color3.fromRGB(245, 245, 248)
    title.TextSize = 11
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 93
    title.Parent = header

    local categoryPanel = Instance.new("Frame")
    categoryPanel.Name = "CategoryPanel"
    categoryPanel.Position = UDim2.fromOffset(6, 35)
    categoryPanel.Size = UDim2.new(0.31, -7, 1, -41)
    categoryPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    categoryPanel.BackgroundTransparency = 0.28
    categoryPanel.BorderSizePixel = 0
    categoryPanel.ZIndex = 92
    categoryPanel.Parent = picker
    AddCorner(categoryPanel, 9)

    local categoryTitle = Instance.new("TextLabel")
    categoryTitle.Position = UDim2.fromOffset(8, 5)
    categoryTitle.Size = UDim2.new(1, -16, 0, 18)
    categoryTitle.BackgroundTransparency = 1
    categoryTitle.Text = "分类"
    categoryTitle.TextColor3 = Color3.fromRGB(220, 222, 228)
    categoryTitle.TextSize = 9
    categoryTitle.Font = Enum.Font.GothamBold
    categoryTitle.TextXAlignment = Enum.TextXAlignment.Left
    categoryTitle.ZIndex = 94
    categoryTitle.Parent = categoryPanel

    local categoryScroll = Instance.new("ScrollingFrame")
    categoryScroll.Name = "CategoryScroll"
    categoryScroll.Position = UDim2.fromOffset(5, 26)
    categoryScroll.Size = UDim2.new(1, -10, 1, -31)
    categoryScroll.BackgroundTransparency = 1
    categoryScroll.BorderSizePixel = 0
    categoryScroll.ScrollBarThickness = 2
    categoryScroll.ScrollBarImageColor3 = Color3.fromRGB(175, 178, 188)
    categoryScroll.ScrollBarImageTransparency = 0.58
    categoryScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    categoryScroll.CanvasSize = UDim2.new()
    categoryScroll.ZIndex = 93
    categoryScroll.Parent = categoryPanel

    local categoryLayout = Instance.new("UIListLayout")
    categoryLayout.Padding = UDim.new(0, 5)
    categoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
    categoryLayout.Parent = categoryScroll

    local categoryPadding = Instance.new("UIPadding")
    categoryPadding.PaddingTop = UDim.new(0, 2)
    categoryPadding.PaddingBottom = UDim.new(0, 4)
    categoryPadding.PaddingLeft = UDim.new(0, 2)
    categoryPadding.PaddingRight = UDim.new(0, 3)
    categoryPadding.Parent = categoryScroll

    local scriptPanel = Instance.new("Frame")
    scriptPanel.Name = "ScriptPanel"
    scriptPanel.Position = UDim2.new(0.31, 3, 0, 35)
    scriptPanel.Size = UDim2.new(0.69, -9, 1, -41)
    scriptPanel.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    scriptPanel.BackgroundTransparency = 0.28
    scriptPanel.BorderSizePixel = 0
    scriptPanel.ZIndex = 92
    scriptPanel.Parent = picker
    AddCorner(scriptPanel, 9)

    local scriptTitle = Instance.new("TextLabel")
    scriptTitle.Position = UDim2.fromOffset(8, 5)
    scriptTitle.Size = UDim2.new(1, -16, 0, 18)
    scriptTitle.BackgroundTransparency = 1
    scriptTitle.Text = "全部脚本"
    scriptTitle.TextColor3 = Color3.fromRGB(220, 222, 228)
    scriptTitle.TextSize = 9
    scriptTitle.Font = Enum.Font.GothamBold
    scriptTitle.TextXAlignment = Enum.TextXAlignment.Left
    scriptTitle.ZIndex = 94
    scriptTitle.Parent = scriptPanel

    local scriptScroll = Instance.new("ScrollingFrame")
    scriptScroll.Name = "ScriptScroll"
    scriptScroll.Position = UDim2.fromOffset(5, 26)
    scriptScroll.Size = UDim2.new(1, -10, 1, -31)
    scriptScroll.BackgroundTransparency = 1
    scriptScroll.BorderSizePixel = 0
    scriptScroll.ScrollBarThickness = 2
    scriptScroll.ScrollBarImageColor3 = Color3.fromRGB(190, 190, 198)
    scriptScroll.ScrollBarImageTransparency = 0.52
    scriptScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scriptScroll.CanvasSize = UDim2.new()
    scriptScroll.ZIndex = 93
    scriptScroll.Parent = scriptPanel

    local scriptLayout = Instance.new("UIListLayout")
    scriptLayout.Padding = UDim.new(0, 5)
    scriptLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scriptLayout.Parent = scriptScroll

    local scriptPadding = Instance.new("UIPadding")
    scriptPadding.PaddingTop = UDim.new(0, 2)
    scriptPadding.PaddingBottom = UDim.new(0, 4)
    scriptPadding.PaddingLeft = UDim.new(0, 2)
    scriptPadding.PaddingRight = UDim.new(0, 3)
    scriptPadding.Parent = scriptScroll

    local playerPicker = Instance.new("Frame")
    playerPicker.Name = "PlayerPanelPicker"
    playerPicker.Size = UDim2.fromScale(1, 1)
    playerPicker.BackgroundTransparency = 1
    playerPicker.Visible = false
    playerPicker.ZIndex = 91
    playerPicker.Parent = popup

    local playerPickerHeader = Instance.new("Frame")
    playerPickerHeader.Size = UDim2.new(1, 0, 0, 34)
    playerPickerHeader.BackgroundTransparency = 1
    playerPickerHeader.ZIndex = 92
    playerPickerHeader.Parent = playerPicker

    local playerBackButton = Instance.new("TextButton")
    playerBackButton.Position = UDim2.fromOffset(6, 5)
    playerBackButton.Size = UDim2.fromOffset(30, 24)
    playerBackButton.BackgroundColor3 = Color3.fromRGB(48, 48, 56)
    playerBackButton.BackgroundTransparency = 0.18
    playerBackButton.BorderSizePixel = 0
    playerBackButton.Text = "‹"
    playerBackButton.TextColor3 = Color3.fromRGB(240, 240, 244)
    playerBackButton.TextSize = 20
    playerBackButton.Font = Enum.Font.GothamMedium
    playerBackButton.AutoButtonColor = false
    playerBackButton.ZIndex = 93
    playerBackButton.Parent = playerPickerHeader
    AddCorner(playerBackButton, 7)

    local playerPickerTitle = Instance.new("TextLabel")
    playerPickerTitle.Position = UDim2.fromOffset(43, 0)
    playerPickerTitle.Size = UDim2.new(1, -50, 1, 0)
    playerPickerTitle.BackgroundTransparency = 1
    playerPickerTitle.Text = "查看玩家面板"
    playerPickerTitle.TextColor3 = Color3.fromRGB(245, 245, 248)
    playerPickerTitle.TextSize = 11
    playerPickerTitle.Font = Enum.Font.GothamBold
    playerPickerTitle.TextXAlignment = Enum.TextXAlignment.Left
    playerPickerTitle.ZIndex = 93
    playerPickerTitle.Parent = playerPickerHeader

    local playerOptionScroll = Instance.new("ScrollingFrame")
    playerOptionScroll.Name = "PlayerPanelOptions"
    playerOptionScroll.Position = UDim2.fromOffset(7, 36)
    playerOptionScroll.Size = UDim2.new(1, -14, 1, -43)
    playerOptionScroll.BackgroundTransparency = 1
    playerOptionScroll.BorderSizePixel = 0
    playerOptionScroll.ScrollBarThickness = 2
    playerOptionScroll.ScrollBarImageColor3 = Color3.fromRGB(190, 190, 198)
    playerOptionScroll.ScrollBarImageTransparency = 0.55
    playerOptionScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    playerOptionScroll.CanvasSize = UDim2.new()
    playerOptionScroll.ZIndex = 92
    playerOptionScroll.Parent = playerPicker

    local playerOptionLayout = Instance.new("UIListLayout")
    playerOptionLayout.Padding = UDim.new(0, 6)
    playerOptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    playerOptionLayout.Parent = playerOptionScroll

    local playerOptionPadding = Instance.new("UIPadding")
    playerOptionPadding.PaddingTop = UDim.new(0, 2)
    playerOptionPadding.PaddingBottom = UDim.new(0, 4)
    playerOptionPadding.PaddingLeft = UDim.new(0, 3)
    playerOptionPadding.PaddingRight = UDim.new(0, 4)
    playerOptionPadding.Parent = playerOptionScroll

    local selectedPanelSection = "全部"
    playerPicker:SetAttribute(
        "SelectedSection",
        "全部"
    )

    local playerSectionButtons = {}
    local playerSections = {
        "全部",
        "基础信息",
        "角色状态",
        "位置坐标",
        "服务器信息",
        "排行榜数据"
    }

    local function refreshPlayerSectionVisuals()
        for sectionName, button in pairs(playerSectionButtons) do
            local active =
                sectionName == selectedPanelSection

            button.BackgroundColor3 =
                active
                and Color3.fromRGB(46, 153, 78)
                or Color3.fromRGB(48, 48, 56)

            button.BackgroundTransparency =
                active
                and 0.04
                or 0.18

            button.TextColor3 =
                active
                and Color3.fromRGB(255, 255, 255)
                or Color3.fromRGB(224, 226, 232)
        end
    end

    for index, sectionName in ipairs(playerSections) do
        local button = Instance.new("TextButton")
        button.Name = "PlayerSection_" .. tostring(index)
        button.Size = UDim2.new(1, -4, 0, 31)
        button.BackgroundColor3 = Color3.fromRGB(48, 48, 56)
        button.BackgroundTransparency = 0.18
        button.BorderSizePixel = 0
        button.Text = sectionName
        button.TextColor3 = Color3.fromRGB(224, 226, 232)
        button.TextSize = 9
        button.Font = Enum.Font.GothamMedium
        button.AutoButtonColor = false
        button.LayoutOrder = index
        button.ZIndex = 93
        button.Parent = playerOptionScroll

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = button

        playerSectionButtons[sectionName] =
            button

        button.Activated:Connect(function()
            selectedPanelSection =
                sectionName

            playerPicker:SetAttribute(
                "SelectedSection",
                sectionName
            )

            pendingEntry = nil
            pendingText = nil

            pendingPanelSection =
                sectionName

            pendingPanelText =
                "查看玩家面板 "
                .. sectionName

            AIInput.Text =
                pendingPanelText

            AIInput.CursorPosition =
                #AIInput.Text + 1

            refreshPlayerSectionVisuals()
        end)
    end

    refreshPlayerSectionVisuals()

    local function setVisible(visible)
        if busy then
            return
        end

        busy = true

        if visible then
            popup.Visible = true
            popup.GroupTransparency = 1
            popupScale.Scale = 0.88

            TweenService:Create(
                popup,
                TweenInfo.new(
                    0.20,
                    Enum.EasingStyle.Quad,
                    Enum.EasingDirection.Out
                ),
                {GroupTransparency = 0}
            ):Play()

            local tween = TweenService:Create(
                popupScale,
                TweenInfo.new(
                    0.32,
                    Enum.EasingStyle.Back,
                    Enum.EasingDirection.Out
                ),
                {Scale = 1}
            )

            tween:Play()
            tween.Completed:Connect(function()
                busy = false
            end)
        else
            local tween = TweenService:Create(
                popupScale,
                TweenInfo.new(
                    0.15,
                    Enum.EasingStyle.Quad,
                    Enum.EasingDirection.In
                ),
                {Scale = 0.92}
            )

            TweenService:Create(
                popup,
                TweenInfo.new(
                    0.14,
                    Enum.EasingStyle.Quad,
                    Enum.EasingDirection.In
                ),
                {GroupTransparency = 1}
            ):Play()

            tween:Play()
            tween.Completed:Connect(function()
                popup.Visible = false
                busy = false
            end)
        end
    end

    local function showRoot()
        rootMenu.Visible = true
        picker.Visible = false
        playerPicker.Visible = false

        TweenService:Create(
            popup,
            TweenInfo.new(
                0.28,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {Size = UDim2.new(0.54, -4, 0, 96)}
        ):Play()
    end

    local function refreshCategoryVisuals()
        for categoryName, button in pairs(categoryButtons) do
            local active = categoryName == selectedCategory

            button.BackgroundColor3 =
                active
                and Color3.fromRGB(46, 153, 78)
                or Color3.fromRGB(48, 48, 56)

            button.BackgroundTransparency =
                active and 0.04 or 0.18

            button.TextColor3 =
                active
                and Color3.fromRGB(255, 255, 255)
                or Color3.fromRGB(224, 226, 232)
        end
    end

    local function applyCategory(categoryName)
        selectedCategory = categoryName or "全部"

        scriptTitle.Text =
            selectedCategory == "全部"
            and "全部脚本"
            or selectedCategory

        for _, rowInfo in ipairs(scriptRows) do
            rowInfo.Button.Visible =
                selectedCategory == "全部"
                or rowInfo.Entry.Category == selectedCategory
        end

        scriptScroll.CanvasPosition = Vector2.new(0, 0)
        refreshCategoryVisuals()
    end

    local function showScripts()
        rootMenu.Visible = false
        picker.Visible = true
        playerPicker.Visible = false

        TweenService:Create(
            popup,
            TweenInfo.new(
                0.34,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {Size = UDim2.new(0.82, -4, 0, 238)}
        ):Play()
    end

    local function showPlayerPicker()
        rootMenu.Visible = false
        picker.Visible = false
        playerPicker.Visible = true

        selectedPanelSection = "全部"
        playerPicker:SetAttribute(
            "SelectedSection",
            "全部"
        )

        pendingPanelSection = nil
        pendingPanelText = nil

        refreshPlayerSectionVisuals()

        TweenService:Create(
            popup,
            TweenInfo.new(
                0.34,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {Size = UDim2.new(0.58, -4, 0, 250)}
        ):Play()
    end

    local categoryNames = {"全部"}
    for categoryName in pairs(ScriptDatabase) do
        table.insert(categoryNames, tostring(categoryName))
    end

    table.sort(categoryNames, function(a, b)
        if a == "全部" then
            return true
        elseif b == "全部" then
            return false
        end

        return a < b
    end)

    for index, categoryName in ipairs(categoryNames) do
        local button = Instance.new("TextButton")
        button.Name = "Category_" .. tostring(index)
        button.Size = UDim2.new(1, -3, 0, 28)
        button.BackgroundColor3 = Color3.fromRGB(48, 48, 56)
        button.BackgroundTransparency = 0.18
        button.BorderSizePixel = 0
        button.Text = categoryName
        button.TextColor3 = Color3.fromRGB(224, 226, 232)
        button.TextSize = 8
        button.Font = Enum.Font.GothamMedium
        button.TextWrapped = true
        button.AutoButtonColor = false
        button.LayoutOrder = index
        button.ZIndex = 94
        button.Parent = categoryScroll

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = button

        categoryButtons[categoryName] = button

        button.Activated:Connect(function()
            applyCategory(categoryName)
        end)
    end

    for index, entry in ipairs(AIAllScripts) do
        local button = Instance.new("TextButton")
        button.Name = "Script_" .. tostring(index)
        button.Size = UDim2.new(1, -4, 0, 38)
        button.BackgroundColor3 = Color3.fromRGB(46, 46, 54)
        button.BackgroundTransparency = 0.18
        button.BorderSizePixel = 0
        button.Text = ""
        button.AutoButtonColor = false
        button.LayoutOrder = index
        button.ZIndex = 94
        button.Parent = scriptScroll
        AddCorner(button, 8)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Position = UDim2.fromOffset(9, 4)
        nameLabel.Size = UDim2.new(1, -18, 0, 18)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = entry.Name
        nameLabel.TextColor3 = Color3.fromRGB(247, 247, 249)
        nameLabel.TextSize = 9
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.ZIndex = 95
        nameLabel.Parent = button

        local categoryLabel = Instance.new("TextLabel")
        categoryLabel.Position = UDim2.fromOffset(9, 22)
        categoryLabel.Size = UDim2.new(1, -18, 0, 12)
        categoryLabel.BackgroundTransparency = 1
        categoryLabel.Text = tostring(entry.Category)
        categoryLabel.TextColor3 = Color3.fromRGB(145, 148, 158)
        categoryLabel.TextSize = 8
        categoryLabel.Font = Enum.Font.Gotham
        categoryLabel.TextXAlignment = Enum.TextXAlignment.Left
        categoryLabel.ZIndex = 95
        categoryLabel.Parent = button

        table.insert(
            scriptRows,
            {Button = button, Entry = entry}
        )

        button.Activated:Connect(function()
            pendingEntry = entry
            pendingText =
                "执行 "
                .. tostring(entry.Name)

            AIInput.Text =
                pendingText

            AIInput.CursorPosition =
                #AIInput.Text + 1

            setVisible(false)
        end)
    end

    applyCategory("全部")

    AIPlusButton.Activated:Connect(function()
        if popup.Visible then
            setVisible(false)
        else
            showRoot()
            setVisible(true)
        end
    end)

    executeOption.Activated:Connect(function()
        pendingEntry = nil
        pendingText = nil
        pendingPanelSection = nil
        pendingPanelText = nil

        AIInput.Text = "执行 "
        AIInput.CursorPosition = #AIInput.Text + 1
        showScripts()
    end)

    playerPanelOption.Activated:Connect(function()
        pendingEntry = nil
        pendingText = nil
        pendingPanelSection = nil
        pendingPanelText = nil

        showPlayerPicker()
    end)

    backButton.Activated:Connect(function()
        showRoot()
    end)

    playerBackButton.Activated:Connect(function()
        showRoot()
    end)

    return {
        Popup = popup,
        SetVisible = setVisible,
        OpenScripts = function()
            pendingEntry = nil
            pendingText = nil

            if not popup.Visible then
                popup.Visible = true
                popup.GroupTransparency = 0
                popupScale.Scale = 1
            end

            AIInput.Text = "执行 "
            AIInput.CursorPosition = #AIInput.Text + 1
            showScripts()
        end,

        ConsumeExecute = function(message)
            local entry =
                pendingEntry

            local expected =
                pendingText

            pendingEntry = nil
            pendingText = nil

            if not entry
            or not expected then
                return nil
            end

            if tostring(message or "")
            ~= expected then
                return nil
            end

            return entry
        end,

        ConsumePlayerPanel = function(message)
            local section =
                pendingPanelSection

            local expected =
                pendingPanelText

            pendingPanelSection = nil
            pendingPanelText = nil

            if not section
            or not expected then
                return nil
            end

            if tostring(message or "")
            ~= expected then
                return nil
            end

            return section
        end,

        ClearPending = function()
            pendingEntry = nil
            pendingText = nil
            pendingPanelSection = nil
            pendingPanelText = nil
        end
    }
end

AICommandUI = AISetupCommandMenu()


local function AITrim(s)
    s = tostring(s or "")
    s = string.gsub(s, "^%s+", "")
    s = string.gsub(s, "%s+$", "")
    return s
end

local function AINormalize(s)
    s = string.lower(AITrim(s))
    s = string.gsub(s, "%s+", "")
    s = string.gsub(s, "[，。！？、,.!?:：;；%-%_/%(%)%[%]【】]", "")
    return s
end

local function AIContains(textValue, needle)
    return string.find(
        AINormalize(textValue),
        AINormalize(needle),
        1,
        true
    ) ~= nil
end

local function AICleanScriptQuery(message)
    local q = AINormalize(message)

    local removeWords = {
        "帮我", "麻烦", "请", "给我",
        "运行", "执行", "打开", "加载", "启动",
        "开一下", "开", "使用", "用一下", "用",
        "查找", "搜索", "找一下", "找",
        "那个", "这个", "功能", "脚本",
        "一下", "一下子", "吧", "啊", "呀", "呢"
    }

    for _, word in ipairs(removeWords) do
        q = string.gsub(q, AINormalize(word), "")
    end

    return q
end

local function AIParseFixedExecuteCommand(message)
    local normalized = AINormalize(message)

    if normalized == "执行" then
        return true, ""
    end

    if string.find(
        normalized,
        "执行",
        1,
        true
    ) == 1 then
        return true, AICleanScriptQuery(message)
    end

    return false, nil
end

local function AIFindScripts(query, limit)
    local q = AINormalize(query)

    if q == "" then
        return {}
    end

    local ranked = {}

    for _, entry in ipairs(AIAllScripts) do
        local n = AINormalize(entry.Name)
        local score = 0

        if n == q then
            score = 10000
        elseif string.find(n, q, 1, true) then
            score = 7000 - math.abs(#n - #q)
        elseif string.find(q, n, 1, true) then
            score = 6500 + #n
        end

        if score > 0 then
            table.insert(ranked, {
                Entry = entry,
                Score = score
            })
        end
    end

    table.sort(ranked, function(a, b)
        if a.Score == b.Score then
            return a.Entry.Name < b.Entry.Name
        end
        return a.Score > b.Score
    end)

    local result = {}
    local maxCount = math.min(limit or 5, #ranked)

    for i = 1, maxCount do
        table.insert(result, ranked[i].Entry)
    end

    return result
end

local function DBAIFindExactScriptByName(name)
    local target = AINormalize(name)

    if target == "" then
        return nil
    end

    for _, entry in ipairs(AIAllScripts) do
        if AINormalize(entry.Name) == target then
            return entry
        end
    end

    local matches = AIFindScripts(name, 1)

    if #matches == 1 then
        return matches[1]
    end

    return nil
end

local function DBAIParseAction(replyText)
    local actionName =
        string.match(
            tostring(replyText or ""),
            "%[%[RUN:(.-)%]%]"
        )

    local cleanReply =
        string.gsub(
            tostring(replyText or ""),
            "%s*%[%[RUN:.-%]%]%s*",
            ""
        )

    cleanReply = AITrim(cleanReply)

    return cleanReply, actionName
end

local function AIHasAny(message, words)
    for _, word in ipairs(words) do
        if AIContains(message, word) then
            return true
        end
    end
    return false
end

local function AIGetCategoryFromMessage(message)
    local order = {
        "通用", "射击游戏", "角色扮演RPG", "休闲挂机",
        "竞技格斗", "休闲社交", "合作游戏",
        "非对称竞技", "塔防游戏", "其他作者脚本"
    }

    for _, name in ipairs(order) do
        if AIContains(message, name) then
            return name
        end
    end

    if AIContains(message, "RPG") then
        return "角色扮演RPG"
    end

    return nil
end

local AIMessageIndex = 0

local function AIScrollToBottom()
    task.defer(function()
        task.wait()
        local y = math.max(
            0,
            AIChatLayout.AbsoluteContentSize.Y
            - AIChatScroll.AbsoluteWindowSize.Y
            + 8
        )
        AIChatScroll.CanvasPosition = Vector2.new(0, y)
    end)
end

local function AIGetBubbleHeight(message, role)
    local chatWidth = AIChatScroll.AbsoluteSize.X

    if chatWidth <= 0 then
        chatWidth = 430
    end

    local bubbleWidth = math.max(
        170,
        math.floor(chatWidth * 0.78) - 30
    )

    local font =
        role == "user"
        and Enum.Font.GothamMedium
        or Enum.Font.Gotham

    local size =
        role == "thought"
        and 10
        or 12

    local bounds = TextService:GetTextSize(
        tostring(message),
        size,
        font,
        Vector2.new(bubbleWidth, 10000)
    )

    if role == "thought" then
        return math.max(22, bounds.Y + 9)
    end

    return math.max(38, bounds.Y + 22)
end

local function AIRefreshMessageSizes()
    for _, row in ipairs(AIChatScroll:GetChildren()) do
        if row:IsA("Frame")
        and row:GetAttribute("DBAIMessageRow") then

            local bubble = row:FindFirstChild("Bubble")
            local role = row:GetAttribute("Role")
            local rawText = row:GetAttribute("RawText")

            if bubble and rawText then
                local h = AIGetBubbleHeight(rawText, role)
                row.Size = UDim2.new(1, -2, 0, h)
                bubble.Size = UDim2.new(0.78, -4, 0, h - 2)
            end
        end
    end
end

AIChatScroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    task.defer(AIRefreshMessageSizes)
end)

local function AIAddMessage(role, message)
    AIMessageIndex = AIMessageIndex + 1

    message = tostring(message or "")

    local row = Instance.new("Frame")
    row.Name = "AI_Row_" .. AIMessageIndex
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.LayoutOrder = AIMessageIndex
    row.ZIndex = 22
    row:SetAttribute("DBAIMessageRow", true)
    row:SetAttribute("Role", role)
    row:SetAttribute("RawText", message)

    local h = AIGetBubbleHeight(message, role)
    row.Size = UDim2.new(1, -2, 0, h)
    row.Parent = AIChatScroll

    local bubble = Instance.new("TextLabel")
    bubble.Name = "Bubble"
    bubble.Size = UDim2.new(0.78, -4, 0, h - 2)
    bubble.BackgroundColor3 =
        role == "user"
        and Color3.fromRGB(31, 31, 38)
        or Color3.fromRGB(14, 14, 18)

    bubble.BackgroundTransparency =
        role == "user" and 0.05 or 0.16

    bubble.BorderSizePixel = 0
    bubble.Text = message

    bubble.TextColor3 =
        role == "user"
        and Color3.fromRGB(246, 246, 249)
        or Color3.fromRGB(226, 231, 241)

    bubble.TextSize = 12
    bubble.Font =
        role == "user"
        and Enum.Font.GothamMedium
        or Enum.Font.Gotham

    bubble.TextWrapped = true
    bubble.TextXAlignment = Enum.TextXAlignment.Left
    bubble.TextYAlignment = Enum.TextYAlignment.Top
    bubble.ZIndex = 23
    bubble.ClipsDescendants = false

    if role == "user" then
        bubble.AnchorPoint = Vector2.new(1, 0)
        bubble.Position = UDim2.new(1, -4, 0, 0)
    else
        bubble.AnchorPoint = Vector2.new(0, 0)
        bubble.Position = UDim2.fromOffset(4, 0)
    end

    bubble.Parent = row
    AddCorner(bubble, 10)

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 9)
    pad.PaddingBottom = UDim.new(0, 9)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.Parent = bubble

    AIScrollToBottom()

    return bubble
end

local function AIAddThought(summary)
    AIMessageIndex = AIMessageIndex + 1

    summary = tostring(summary or "正在整理问题")

    local row = Instance.new("Frame")
    row.Name = "AI_Thought_" .. AIMessageIndex
    row.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    row.BackgroundTransparency = 0.42
    row.BorderSizePixel = 0
    row.LayoutOrder = AIMessageIndex
    row.ZIndex = 22

    local h = math.max(
        31,
        AIGetBubbleHeight(summary, "thought") + 7
    )

    row.Size = UDim2.new(0.88, -8, 0, h)
    row.Position = UDim2.fromOffset(6, 0)
    row.Parent = AIChatScroll
    AddCorner(row, 8)

    local side = Instance.new("Frame")
    side.Name = "ThoughtSide"
    side.Position = UDim2.fromOffset(0, 5)
    side.Size = UDim2.new(0, 2, 1, -10)
    side.BackgroundColor3 = Color3.fromRGB(112, 116, 128)
    side.BackgroundTransparency = 0.20
    side.BorderSizePixel = 0
    side.ZIndex = 23
    side.Parent = row
    AddCorner(side, 99)

    local title = Instance.new("TextLabel")
    title.Name = "ThoughtTitle"
    title.Position = UDim2.fromOffset(10, 4)
    title.Size = UDim2.new(1, -18, 0, 13)
    title.BackgroundTransparency = 1
    title.Text = "思考中"
    title.TextColor3 = Color3.fromRGB(154, 158, 169)
    title.TextSize = 9
    title.Font = Enum.Font.GothamMedium
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 23
    title.Parent = row

    local label = Instance.new("TextLabel")
    label.Name = "Thought"
    label.Position = UDim2.fromOffset(10, 17)
    label.Size = UDim2.new(1, -18, 1, -20)
    label.BackgroundTransparency = 1
    label.Text = summary
    label.TextColor3 = Color3.fromRGB(125, 129, 140)
    label.TextTransparency = 0.03
    label.TextSize = 9
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.ZIndex = 23
    label.Parent = row

    task.delay(0.28, function()
        if title and title.Parent then
            title.Text = "思考摘要"
        end
    end)

    AIScrollToBottom()

    return row
end

local function AIAddRunButton(entry)
    AIMessageIndex = AIMessageIndex + 1

    local button = Instance.new("TextButton")
    button.Name = "AI_Run_" .. tostring(entry.Name)
    button.Size = UDim2.new(1, -12, 0, 29)
    button.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
    button.BackgroundTransparency = 0.10
    button.BorderSizePixel = 0
    button.Text = "运行  " .. tostring(entry.Name)
    button.TextColor3 = Color3.fromRGB(240, 240, 244)
    button.TextSize = 11
    button.Font = Enum.Font.GothamMedium
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.AutoButtonColor = false
    button.ZIndex = 23
    button.LayoutOrder = AIMessageIndex
    button.Parent = AIChatScroll

    AddCorner(button, 9)

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 0.8
    stroke.Color = Color3.fromRGB(88, 90, 100)
    stroke.Transparency = 0.48
    stroke.Parent = button

    button.Activated:Connect(function()
        AIAddMessage(
            "assistant",
            "行，正在加载「"
            .. tostring(entry.Name)
            .. "」。"
        )

        SafeLoadScript(entry.Item)
    end)

    AIScrollToBottom()
end

local function AIListCategory(categoryName)
    local list = ScriptDatabase[categoryName] or {}

    if #list == 0 then
        AIAddMessage(
            "assistant",
            "「" .. categoryName .. "」现在还没有脚本。"
        )
        return
    end

    local names = {}
    local showCount = math.min(#list, 7)

    for i = 1, showCount do
        table.insert(names, tostring(list[i].Name))
    end

    local suffix =
        #list > showCount
        and ("……共 " .. #list .. " 个")
        or ("，共 " .. #list .. " 个")

    AIAddMessage(
        "assistant",
        "「"
        .. categoryName
        .. "」里有："
        .. table.concat(names, "、")
        .. suffix
        .. "。"
    )
end

local DBAIRandom = Random.new()

local DBAIState = {
    Turn = 0,

    Chat = {
        Mood = "normal",
        MoodTurn = 0,
        LastTopic = "",
        LastUserText = "",
        LastReply = ""
    },

    Script = {
        LastMatches = {},
        LastQuery = "",
        LastTurn = 0
    },

    Weather = {
        LastCity = nil,
        PendingCityTurn = nil
    },

    Reality = {
        LastQueryType = nil,
        LastQuery = ""
    },

    Focus = {
        Kind = nil,
        Args = nil,
        Turn = 0,
        Time = 0
    },

    LastTask = {
        Kind = nil,
        Args = nil,
        Turn = 0,
        Time = 0,
        Repeatable = false
    },

    Observations = {
        ServerCount = nil,
        Weather = {},
        PlayerListCount = nil
    },

    History = {}
}

local function AIPick(list)
    if #list == 0 then
        return ""
    end

    return list[
        DBAIRandom:NextInteger(1, #list)
    ]
end

local function AICleanReplyText(s)
    s = tostring(s or "")

    local replacements = {
        {"咋回事", "怎么回事"},
        {"咋了", "怎么了"},
        {"来呗", "可以"},
        {"牛逼", "不错"},
        {"折腾", "处理"},
        {"整", "处理"},
        {"啥", "什么"}
    }

    for _, pair in ipairs(replacements) do
        s = string.gsub(s, pair[1], pair[2])
    end

    s = string.gsub(s, "^%s+", "")
    s = string.gsub(s, "%s+$", "")

    return s
end

local function AIReply(message)
    local cleaned =
        AICleanReplyText(message)

    DBAIState.Chat.LastReply =
        cleaned

    AIAddMessage(
        "assistant",
        cleaned
    )
end

local function AIReplyPick(list)
    if #list == 0 then
        return
    end

    local lastReply =
        tostring(
            DBAIState.Chat.LastReply
            or ""
        )

    local candidates = {}

    for _, value in ipairs(list) do
        local cleaned =
            AICleanReplyText(value)

        if cleaned ~= lastReply then
            table.insert(
                candidates,
                cleaned
            )
        end
    end

    if #candidates == 0 then
        candidates = list
    end

    AIReply(
        AIPick(candidates)
    )
end

local function AIResetScriptContext()
    DBAIState.Script.LastMatches = {}
    DBAIState.Script.LastQuery = ""
    DBAIState.Script.LastTurn = 0
end

local function AIEnterNonScriptMode()
    AIResetScriptContext()
end

local function AISetScriptMatches(matches, query)
    DBAIState.Script.LastMatches = {}
    DBAIState.Script.LastQuery = tostring(query or "")
    DBAIState.Script.LastTurn = DBAIState.Turn

    for i, entry in ipairs(matches or {}) do
        DBAIState.Script.LastMatches[i] = entry
    end
end

local function AIHistoryPush(kind, userText, summary)
    table.insert(DBAIState.History, {
        Turn = DBAIState.Turn,
        Kind = tostring(kind or "chat"),
        User = tostring(userText or ""),
        Summary = tostring(summary or "")
    })

    while #DBAIState.History > 14 do
        table.remove(DBAIState.History, 1)
    end
end

local function AISetFocus(kind, args)
    DBAIState.Focus.Kind = kind
    DBAIState.Focus.Args = args
    DBAIState.Focus.Turn = DBAIState.Turn
    DBAIState.Focus.Time = os.clock()
end

local function AISetLastTask(kind, args, repeatable)
    DBAIState.LastTask.Kind = kind
    DBAIState.LastTask.Args = args
    DBAIState.LastTask.Turn = DBAIState.Turn
    DBAIState.LastTask.Time = os.clock()
    DBAIState.LastTask.Repeatable = repeatable == true

    AISetFocus(kind, args)
end

local function AIClearFocusIfOld(maxTurns)
    maxTurns = maxTurns or 8

    if DBAIState.Focus.Kind
    and (DBAIState.Turn - DBAIState.Focus.Turn) > maxTurns then
        DBAIState.Focus.Kind = nil
        DBAIState.Focus.Args = nil
    end
end

local function AIIsFollowUpPhrase(message)
    local n = AINormalize(message)

    local exact = {
        ["现在呢"] = true,
        ["那现在呢"] = true,
        ["那现在"] = true,
        ["现在多少"] = true,
        ["现在怎么样"] = true,
        ["现在如何"] = true,
        ["再看看"] = true,
        ["再查一下"] = true,
        ["重新查一下"] = true,
        ["更新一下"] = true,
        ["刷新一下"] = true,
        ["还有呢"] = true,
        ["然后呢"] = true,
        ["呢"] = true,
        ["现在"] = true
    }

    if exact[n] then
        return true
    end

    if #n <= 12 then
        if string.find(n, "现在", 1, true)
        or string.find(n, "再查", 1, true)
        or string.find(n, "更新", 1, true)
        or string.find(n, "刷新", 1, true) then
            return true
        end
    end

    return false
end

local function AIFormatDelta(current, previous, unit)
    unit = unit or ""

    if previous == nil then
        return ""
    end

    local diff = current - previous

    if diff > 0 then
        return "，比刚才多 " .. tostring(diff) .. unit
    elseif diff < 0 then
        return "，比刚才少 " .. tostring(math.abs(diff)) .. unit
    else
        return "，和刚才一样"
    end
end

local function AIGetRecentFocus(maxTurns)
    maxTurns = maxTurns or 8

    local focus = DBAIState.Focus

    if not focus.Kind then
        return nil, nil
    end

    if (DBAIState.Turn - focus.Turn) > maxTurns then
        return nil, nil
    end

    return focus.Kind, focus.Args
end

local function AIGetServerPlayers()
    return Players:GetPlayers()
end

local function AIGetServerPlayerCount()
    return #AIGetServerPlayers()
end

local function AIGetPlayerNames(limit)
    local names = {}
    local allPlayers = AIGetServerPlayers()
    local maxCount = math.min(limit or 20, #allPlayers)

    for i = 1, maxCount do
        local p = allPlayers[i]
        table.insert(
            names,
            tostring(p.DisplayName)
            .. " (@"
            .. tostring(p.Name)
            .. ")"
        )
    end

    return names
end

local function AIGetTeamSummary()
    local Teams = game:GetService("Teams")
    local teams = Teams:GetChildren()

    if #teams == 0 then
        return "当前游戏没有可见的 Teams 分组。"
    end

    local lines = {}

    for _, team in ipairs(teams) do
        if team:IsA("Team") then
            local count = 0

            for _, p in ipairs(AIGetServerPlayers()) do
                if p.Team == team then
                    count = count + 1
                end
            end

            table.insert(
                lines,
                tostring(team.Name)
                .. "："
                .. tostring(count)
                .. "人"
            )
        end
    end

    if #lines == 0 then
        return "当前游戏没有可见的 Teams 分组。"
    end

    return table.concat(lines, "；")
end

local function AIGetLocalCharacterInfo()
    local character = LocalPlayer.Character

    if not character then
        return "你的角色当前还没有加载完成。"
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    local root =
        character:FindFirstChild("HumanoidRootPart")

    local parts = {}

    table.insert(
        parts,
        "玩家："
        .. tostring(LocalPlayer.DisplayName)
        .. " (@"
        .. tostring(LocalPlayer.Name)
        .. ")"
    )

    if humanoid then
        table.insert(
            parts,
            "生命："
            .. tostring(math.floor(humanoid.Health))
            .. "/"
            .. tostring(math.floor(humanoid.MaxHealth))
        )

        table.insert(
            parts,
            "移动速度："
            .. tostring(humanoid.WalkSpeed)
        )
    end

    if root then
        local p = root.Position

        table.insert(
            parts,
            "坐标约："
            .. string.format("%.1f, %.1f, %.1f", p.X, p.Y, p.Z)
        )
    end

    if LocalPlayer.Team then
        table.insert(
            parts,
            "队伍："
            .. tostring(LocalPlayer.Team.Name)
        )
    end

    return table.concat(parts, "；")
end

local function AIGetLeaderstatsSummary(player)
    player = player or LocalPlayer

    local leaderstats =
        player:FindFirstChild("leaderstats")

    if not leaderstats then
        return nil
    end

    local lines = {}

    for _, child in ipairs(leaderstats:GetChildren()) do
        if child:IsA("ValueBase") then
            table.insert(
                lines,
                tostring(child.Name)
                .. "="
                .. tostring(child.Value)
            )
        end
    end

    if #lines == 0 then
        return nil
    end

    return table.concat(lines, "，")
end

local function AIGetSelfPanelText(section)
    section =
        tostring(
            section
            or "全部"
        )

    local character =
        LocalPlayer.Character

    local humanoid =
        character
        and character:FindFirstChildOfClass(
            "Humanoid"
        )

    local root =
        character
        and character:FindFirstChild(
            "HumanoidRootPart"
        )

    local basicLines = {
        "玩家名字："
        .. tostring(LocalPlayer.DisplayName),

        "用户名：@"
        .. tostring(LocalPlayer.Name),

        "UserId："
        .. tostring(LocalPlayer.UserId),

        "账号年龄："
        .. tostring(LocalPlayer.AccountAge)
        .. " 天",

        "会员类型："
        .. tostring(
            LocalPlayer.MembershipType.Name
        )
    }

    local characterLines = {}

    if humanoid then
        table.insert(
            characterLines,
            "生命值："
            .. tostring(
                math.floor(
                    humanoid.Health
                )
            )
            .. "/"
            .. tostring(
                math.floor(
                    humanoid.MaxHealth
                )
            )
        )

        table.insert(
            characterLines,
            "WalkSpeed："
            .. tostring(
                humanoid.WalkSpeed
            )
        )

        local jumpValue =
            humanoid.UseJumpPower
            and humanoid.JumpPower
            or humanoid.JumpHeight

        table.insert(
            characterLines,
            humanoid.UseJumpPower
            and (
                "JumpPower："
                .. tostring(jumpValue)
            )
            or (
                "JumpHeight："
                .. tostring(jumpValue)
            )
        )

        table.insert(
            characterLines,
            "坐下状态："
            .. (
                humanoid.Sit
                and "是"
                or "否"
            )
        )
    else
        table.insert(
            characterLines,
            "角色状态：尚未读取到 Humanoid"
        )
    end

    if LocalPlayer.Team then
        table.insert(
            characterLines,
            "队伍："
            .. tostring(
                LocalPlayer.Team.Name
            )
        )
    else
        table.insert(
            characterLines,
            "队伍：无"
        )
    end

    local positionLines = {}

    if root then
        local p =
            root.Position

        local velocity =
            root.AssemblyLinearVelocity

        table.insert(
            positionLines,
            "坐标："
            .. string.format(
                "%.2f, %.2f, %.2f",
                p.X,
                p.Y,
                p.Z
            )
        )

        table.insert(
            positionLines,
            "实际移动速度："
            .. string.format(
                "%.2f",
                velocity.Magnitude
            )
        )
    else
        table.insert(
            positionLines,
            "位置：尚未读取到 HumanoidRootPart"
        )
    end

    local serverLines = {
        "游戏："
        .. tostring(game.Name),

        "服务器在线人数："
        .. tostring(
            #Players:GetPlayers()
        ),

        "PlaceId："
        .. tostring(game.PlaceId),

        "GameId："
        .. tostring(game.GameId),

        "JobId："
        .. tostring(game.JobId)
    }

    local pingOk, ping =
        pcall(function()
            return LocalPlayer:GetNetworkPing()
        end)

    if pingOk
    and type(ping) == "number" then
        table.insert(
            serverLines,
            "网络延迟约："
            .. tostring(
                math.floor(
                    ping * 1000
                )
            )
            .. " ms"
        )
    end

    local leaderLines = {}
    local leader =
        AIGetLeaderstatsSummary(
            LocalPlayer
        )

    if leader then
        table.insert(
            leaderLines,
            "leaderstats："
            .. leader
        )
    else
        table.insert(
            leaderLines,
            "当前游戏没有可见的 leaderstats 数据"
        )
    end

    local function join(titleText, lines)
        return
            "【"
            .. titleText
            .. "】\n"
            .. table.concat(
                lines,
                "\n"
            )
    end

    if section == "基础信息" then
        return join(
            "基础信息",
            basicLines
        )

    elseif section == "角色状态" then
        return join(
            "角色状态",
            characterLines
        )

    elseif section == "位置坐标" then
        return join(
            "位置坐标",
            positionLines
        )

    elseif section == "服务器信息" then
        return join(
            "服务器信息",
            serverLines
        )

    elseif section == "排行榜数据" then
        return join(
            "排行榜数据",
            leaderLines
        )
    end

    if section == "全部" then
        return table.concat({
            join("基础信息", basicLines),
            join("角色状态", characterLines),
            join("位置坐标", positionLines),
            join("服务器信息", serverLines),
            join("排行榜数据", leaderLines)
        }, "\n\n")
    end

    return
        "没有识别到玩家面板项目「"
        .. section
        .. "」。"
end

local function AIGetWorldSummary()
    local workspaceCount = 0
    local modelCount = 0
    local partCount = 0

    for _, obj in ipairs(workspace:GetDescendants()) do
        workspaceCount = workspaceCount + 1

        if obj:IsA("Model") then
            modelCount = modelCount + 1
        elseif obj:IsA("BasePart") then
            partCount = partCount + 1
        end
    end

    return
        "Workspace 当前可见对象约 "
        .. tostring(workspaceCount)
        .. " 个，其中 Model "
        .. tostring(modelCount)
        .. " 个、BasePart "
        .. tostring(partCount)
        .. " 个。"
end

local function AIGetDBSummary()
    local categoryCount = 0
    local scriptCount = 0
    local categoryLines = {}

    for categoryName, items in pairs(ScriptDatabase) do
        categoryCount = categoryCount + 1
        scriptCount = scriptCount + #items

        table.insert(
            categoryLines,
            tostring(categoryName)
            .. "("
            .. tostring(#items)
            .. ")"
        )
    end

    table.sort(categoryLines)

    return
        "DB 当前有 "
        .. tostring(categoryCount)
        .. " 个分类、"
        .. tostring(scriptCount)
        .. " 个脚本。分类："
        .. table.concat(categoryLines, "、")
        .. "。"
end

local function AIGetGameSummary()
    local placeName =
        tostring(game.Name or "未知游戏")

    local creatorText = ""

    pcall(function()
        if game.CreatorType == Enum.CreatorType.User then
            creatorText =
                "，创建者类型：用户"
        elseif game.CreatorType == Enum.CreatorType.Group then
            creatorText =
                "，创建者类型：群组"
        end
    end)

    return
        "当前游戏："
        .. placeName
        .. "；PlaceId："
        .. tostring(game.PlaceId)
        .. "；GameId："
        .. tostring(game.GameId)
        .. "；JobId："
        .. tostring(game.JobId)
        .. creatorText
        .. "。"
end

local function AIGetCapabilitiesText()
    return table.concat({
        "我现在主要能做这些：",
        "1. 正常聊天，并区分聊天、天气、新闻、百科、地名和脚本任务；",
        "2. 查询当前服务器人数、玩家名单、队伍、当前游戏、PlaceId、JobId；",
        "3. 查看你的角色状态、生命、速度、坐标，以及可见的 leaderstats；",
        "4. 读取当前客户端能看到的 Workspace 环境概要；",
        "5. 查询天气、新闻、百科、准确地名和坐标；",
        "6. 读取整个 DB 脚本库，搜索脚本、列分类，并按你的明确指令执行对应脚本；",
        "7. 记住最近任务和查询结果，能理解“现在呢”“再看看”“第二个”等多轮指代，同时隔离脚本与聊天上下文。"
    }, "\n")
end

local function AIRunServerCountQuery(isFollowUp)
    local previous =
        DBAIState.Observations.ServerCount

    local current =
        AIGetServerPlayerCount()

    DBAIState.Observations.ServerCount =
        current

    AISetLastTask(
        "server_count",
        {},
        true
    )

    AIHistoryPush(
        "server_count",
        isFollowUp and "现在呢" or "服务器人数",
        tostring(current)
    )

    AIAddThought(
        "读取当前 Players:GetPlayers()，重新统计实时服务器人数"
    )

    local delta =
        AIFormatDelta(
            current,
            previous,
            " 人"
        )

    if isFollowUp and previous ~= nil then
        AIReply(
            "现在是 "
            .. tostring(current)
            .. " 名玩家"
            .. delta
            .. "。"
        )
    else
        AIReply(
            "当前这个服务器一共有 "
            .. tostring(current)
            .. " 名玩家。"
        )
    end
end

local function AIRunPlayerListQuery(isFollowUp)
    local names =
        AIGetPlayerNames(24)

    local currentCount =
        #AIGetServerPlayers()

    local previousCount =
        DBAIState.Observations.PlayerListCount

    DBAIState.Observations.PlayerListCount =
        currentCount

    AISetLastTask(
        "player_list",
        {},
        true
    )

    AIAddThought(
        "重新读取当前服务器玩家列表"
    )

    local prefix = ""

    if isFollowUp and previousCount ~= nil then
        prefix =
            "现在共 "
            .. tostring(currentCount)
            .. " 人"
            .. AIFormatDelta(
                currentCount,
                previousCount,
                " 人"
            )
            .. "。"
    end

    if #names == 0 then
        AIReply(
            prefix
            .. "当前没有读取到玩家名单。"
        )
    else
        AIReply(
            prefix
            .. "当前服务器玩家："
            .. table.concat(names, "、")
            .. "。"
        )
    end
end

local AIQueryWeather

local function AIRunWeatherQuery(city, isFollowUp)
    city = AITrim(city or "")

    if city == "" then
        AIReply(
            "我还不知道你要查哪个城市。"
        )
        return
    end

    AISetLastTask(
        "weather",
        {City = city},
        true
    )

    DBAIState.Weather.LastCity =
        city

    AIAddThought(
        isFollowUp
        and ("重新查询「" .. city .. "」当前天气")
        or ("查询「" .. city .. "」当前天气")
    )

    task.spawn(function()
        local ok, success, result =
            pcall(
                AIQueryWeather,
                city
            )

        if not ok then
            AIReply(
                "这次天气服务没有连接成功，请稍后再试。"
            )
            return
        end

        AIReply(result)
    end)
end

local function AIRunGameInfoQuery()
    AISetLastTask(
        "game_info",
        {},
        true
    )

    AIAddThought(
        "重新读取当前 Roblox 游戏实例信息"
    )

    AIReply(
        AIGetGameSummary()
    )
end

local function AIRunCharacterQuery()
    AISetLastTask(
        "character_info",
        {},
        true
    )

    AIAddThought(
        "重新读取你的当前角色状态"
    )

    local info =
        AIGetLocalCharacterInfo()

    local leader =
        AIGetLeaderstatsSummary(LocalPlayer)

    if leader then
        info =
            info
            .. "；排行榜数据："
            .. leader
    end

    AIReply(info)
end

local function AIRunWorldQuery()
    AISetLastTask(
        "world_summary",
        {},
        true
    )

    AIAddThought(
        "重新扫描客户端当前可见 Workspace 环境"
    )

    AIReply(
        AIGetWorldSummary()
    )
end

local function AIRunDBSummaryQuery()
    AISetLastTask(
        "db_summary",
        {},
        true
    )

    AIAddThought(
        "重新读取整个 DB 脚本数据库"
    )

    AIReply(
        AIGetDBSummary()
    )
end

local function AIRepeatLastTask()
    local taskInfo =
        DBAIState.LastTask

    if not taskInfo.Kind
    or not taskInfo.Repeatable then
        return false
    end

    if (DBAIState.Turn - taskInfo.Turn) > 8 then
        return false
    end

    if taskInfo.Kind == "server_count" then
        AIRunServerCountQuery(true)
        return true

    elseif taskInfo.Kind == "player_list" then
        AIRunPlayerListQuery(true)
        return true

    elseif taskInfo.Kind == "weather" then
        local city =
            taskInfo.Args
            and taskInfo.Args.City
            or DBAIState.Weather.LastCity

        AIRunWeatherQuery(
            city,
            true
        )
        return true

    elseif taskInfo.Kind == "game_info" then
        AIRunGameInfoQuery()
        return true

    elseif taskInfo.Kind == "character_info" then
        AIRunCharacterQuery()
        return true

    elseif taskInfo.Kind == "world_summary" then
        AIRunWorldQuery()
        return true

    elseif taskInfo.Kind == "db_summary" then
        AIRunDBSummaryQuery()
        return true
    end

    return false
end

local function AIIsWeatherIntent(message)
    return AIHasAny(message, {
        "天气", "温度", "气温", "下雨", "下雪",
        "刮风", "体感温度", "天气预报"
    })
end

local function AIIsNewsIntent(message)
    return AIHasAny(message, {
        "新闻", "最新消息", "最新资讯",
        "热点", "头条", "最近发生"
    })
end

local function AIIsPlaceIntent(message)
    return AIHasAny(message, {
        "在哪里", "在哪儿", "在哪",
        "位置", "坐标", "经纬度",
        "属于哪个省", "属于哪个国家",
        "是什么地方"
    })
end

local function AIIsKnowledgeIntent(message)
    return AIHasAny(message, {
        "什么是", "是什么", "是谁", "谁是",
        "介绍一下", "科普一下",
        "百科", "资料",
        "几年成立", "哪年成立", "哪一年成立",
        "什么时候成立", "何时成立",
        "几年建立", "哪年建立", "什么时候建立",
        "谁建立", "谁创建", "谁创立", "谁发明",
        "哪年出生", "什么时候出生",
        "首都", "人口多少", "有多少人口",
        "面积多大", "面积多少",
        "哪一年发生", "什么时候发生"
    })
end

local function AIIsTimeIntent(message)
    return AIHasAny(message, {
        "几点", "现在时间", "当前时间",
        "几号", "星期几", "今天日期", "今天几号"
    })
end

local function AIIsExplicitScriptRun(message)
    if AIHasAny(message, {
        "运行脚本", "执行脚本", "打开脚本", "加载脚本",
        "启动脚本", "运行功能", "执行功能",
        "帮我运行", "帮我执行", "帮我打开", "帮我加载",
        "运行一下", "执行一下"
    }) then
        return true
    end

    local normalized =
        AINormalize(message)

    if string.find(
        normalized,
        "执行",
        1,
        true
    ) == 1 then
        local query =
            AICleanScriptQuery(message)

        return #AIFindScripts(
            query,
            1
        ) > 0
    end

    return false
end

local function AIIsExplicitScriptSearch(message)
    return AIHasAny(message, {
        "找脚本", "搜索脚本", "查找脚本",
        "有没有脚本", "找功能", "搜索功能",
        "查找功能", "有哪些脚本", "有什么脚本"
    })
end

local function AIIsCategoryScriptQuery(message)
    local category = AIGetCategoryFromMessage(message)

    if not category then
        return nil
    end

    if AIHasAny(message, {
        "有什么", "有哪些", "列出",
        "脚本", "功能", "看看"
    }) then
        return category
    end

    return nil
end

local function AILooksLikeShortLocation(textValue)
    local s = AITrim(textValue)

    if s == "" or #s > 24 then
        return false
    end

    if AIHasAny(s, {
        "脚本", "功能", "新闻", "天气",
        "为什么", "怎么", "什么", "你好",
        "谢谢", "聊天", "觉得"
    }) then
        return false
    end

    return true
end

local function AIWeatherText(code)
    local map = {
        [0] = "晴",
        [1] = "大致晴朗",
        [2] = "局部多云",
        [3] = "阴",
        [45] = "有雾",
        [48] = "雾凇",
        [51] = "小毛毛雨",
        [53] = "毛毛雨",
        [55] = "较强毛毛雨",
        [61] = "小雨",
        [63] = "中雨",
        [65] = "大雨",
        [71] = "小雪",
        [73] = "中雪",
        [75] = "大雪",
        [80] = "阵雨",
        [81] = "较强阵雨",
        [82] = "强阵雨",
        [95] = "雷雨",
        [96] = "雷雨伴小冰雹",
        [99] = "强雷雨伴冰雹"
    }

    return map[tonumber(code)] or "天气状况未知"
end

local function AIExtractWeatherCity(message)
    local city = tostring(message or "")

    local removeWords = {
        "帮我", "查一下", "查询", "查查", "看看",
        "请问", "告诉我",
        "今天", "现在", "目前", "当地", "那边", "那里的",
        "天气怎么样", "天气如何", "什么天气",
        "天气", "怎么样", "如何", "情况",
        "呢", "啊", "呀", "吗", "？", "?"
    }

    for _, word in ipairs(removeWords) do
        city = string.gsub(city, word, "")
    end

    city = string.gsub(city, "^的", "")
    city = string.gsub(city, "的$", "")
    city = AITrim(city)

    return city
end

local function AIAddUniqueCandidate(list, value)
    value = AITrim(value)

    if value == "" then
        return
    end

    for _, old in ipairs(list) do
        if old == value then
            return
        end
    end

    table.insert(list, value)
end

local function AIBuildLocationCandidates(locationText)
    local raw = AITrim(locationText)
    local list = {}

    AIAddUniqueCandidate(list, raw)

    local province, city =
        string.match(
            raw,
            "^(.+省)(.+市)$"
        )

    if province and city then
        AIAddUniqueCandidate(
            list,
            city .. ", " .. province
        )

        AIAddUniqueCandidate(
            list,
            string.gsub(city, "市$", "")
            .. ", "
            .. string.gsub(province, "省$", "")
        )

        AIAddUniqueCandidate(list, city)
        AIAddUniqueCandidate(
            list,
            string.gsub(city, "市$", "")
        )
    end

    local region, regionCity =
        string.match(
            raw,
            "^(.+自治区)(.+市)$"
        )

    if region and regionCity then
        AIAddUniqueCandidate(
            list,
            regionCity .. ", " .. region
        )
        AIAddUniqueCandidate(list, regionCity)
        AIAddUniqueCandidate(
            list,
            string.gsub(regionCity, "市$", "")
        )
    end

    local extractedCity =
        string.match(raw, "([^省自治区特别行政区]+市)$")

    if extractedCity then
        AIAddUniqueCandidate(list, extractedCity)
        AIAddUniqueCandidate(
            list,
            string.gsub(extractedCity, "市$", "")
        )
    end

    local simplified = raw
    simplified = string.gsub(simplified, "特别行政区", "")
    simplified = string.gsub(simplified, "自治区", "")
    simplified = string.gsub(simplified, "省", "")
    simplified = string.gsub(simplified, "市", "")
    simplified = string.gsub(simplified, "地区", "")
    simplified = string.gsub(simplified, "自治州", "")
    AIAddUniqueCandidate(list, simplified)

    return list
end

local function AIGeocodeLocation(locationText)
    local candidates =
        AIBuildLocationCandidates(locationText)

    local lastErr = nil

    for _, candidate in ipairs(candidates) do
        local encoded =
            HttpService:UrlEncode(candidate)

        local geoUrl =
            "https://geocoding-api.open-meteo.com/v1/search"
            .. "?name=" .. encoded
            .. "&count=5&language=zh&format=json"

        local ok, body =
            pcall(function()
                return game:HttpGet(geoUrl)
            end)

        if ok and type(body) == "string" then
            local decodeOk, geo =
                pcall(
                    HttpService.JSONDecode,
                    HttpService,
                    body
                )

            if decodeOk
            and type(geo) == "table"
            and type(geo.results) == "table"
            and geo.results[1] then

                return geo.results[1], candidate
            end

            lastErr = "没有匹配结果"
        else
            lastErr = tostring(body)
        end
    end

    return nil, lastErr
end

AIQueryWeather = function(city)
    city = AITrim(city)

    if city == "" then
        return false, "你要查哪个城市？比如直接回“北京”就行。"
    end

    local place, matchedQuery =
        AIGeocodeLocation(city)

    if not place then
        return false,
            "我把「"
            .. city
            .. "」按完整地名、城市名和去掉行政后缀都试了一遍，还是没查到。"
    end
    local lat = place.latitude
    local lon = place.longitude

    if not lat or not lon then
        return false, "这个地点有点怪，我拿不到它的坐标。"
    end

    local weatherUrl =
        "https://api.open-meteo.com/v1/forecast"
        .. "?latitude=" .. tostring(lat)
        .. "&longitude=" .. tostring(lon)
        .. "&current=temperature_2m,apparent_temperature,weather_code,wind_speed_10m"
        .. "&timezone=auto"

    local weatherBody = game:HttpGet(weatherUrl)
    local weather = HttpService:JSONDecode(weatherBody)
    local current = weather and weather.current

    if type(current) ~= "table" then
        return false, "天气接口这次没给我有效数据。"
    end

    local displayName =
        tostring(place.name or city)

    if place.admin1 and tostring(place.admin1) ~= displayName then
        displayName =
            displayName
            .. "（"
            .. tostring(place.admin1)
            .. "）"
    end

    DBAIState.Weather.LastCity = tostring(place.name or city)

    local temp = current.temperature_2m
    local feels = current.apparent_temperature
    local wind = current.wind_speed_10m
    local condition = AIWeatherText(current.weather_code)

    return true,
        displayName
        .. "现在"
        .. condition
        .. "，"
        .. tostring(temp or "?")
        .. "℃"
        .. "，体感"
        .. tostring(feels or "?")
        .. "℃"
        .. "，风速约"
        .. tostring(wind or "?")
        .. " km/h。"
end

local function AIHandleWeather(city)
    AIAddThought(
        "识别到天气问题 → 查询「"
        .. tostring(city)
        .. "」实时天气"
    )

    task.spawn(function()
        local ok, success, result =
            pcall(AIQueryWeather, city)

        if not ok then
            AIAddMessage(
                "assistant",
                "天气服务这次没有连接成功，请稍后再试。"
            )
            return
        end

        if success then
            AIAddMessage(
                "assistant",
                result
            )
        else
            AIAddMessage("assistant", result)
        end
    end)
end

local function AIExtractPlaceQuery(message)
    local q = tostring(message or "")

    local removeWords = {
        "请问", "帮我", "查一下", "查询", "查查", "看看",
        "告诉我", "介绍一下",
        "在哪里", "在哪儿", "在哪", "位置",
        "地名", "坐标", "经纬度",
        "属于哪里", "属于哪个省", "属于哪个国家",
        "是哪里", "是什么地方",
        "？", "?"
    }

    for _, word in ipairs(removeWords) do
        q = string.gsub(q, word, "")
    end

    return AITrim(q)
end

local function AIQueryPlace(placeText)
    local place =
        AIGeocodeLocation(placeText)

    if not place then
        return false,
            "我没查到「"
            .. tostring(placeText)
            .. "」这个地点。"
    end

    local parts = {}

    table.insert(
        parts,
        tostring(place.name or placeText)
    )

    if place.admin2 and place.admin2 ~= "" then
        table.insert(parts, tostring(place.admin2))
    end

    if place.admin1 and place.admin1 ~= "" then
        table.insert(parts, tostring(place.admin1))
    end

    if place.country and place.country ~= "" then
        table.insert(parts, tostring(place.country))
    end

    local locationName =
        table.concat(parts, " · ")

    local extra = ""

    if place.latitude and place.longitude then
        extra =
            "，坐标约 "
            .. string.format("%.4f", place.latitude)
            .. ", "
            .. string.format("%.4f", place.longitude)
    end

    if place.timezone then
        extra =
            extra
            .. "，时区 "
            .. tostring(place.timezone)
    end

    if place.population then
        extra =
            extra
            .. "，人口数据约 "
            .. tostring(place.population)
    end

    return true,
        locationName
        .. extra
        .. "。"
end

local function AIExtractKnowledgeQuery(message)
    local q =
        tostring(
            message
            or ""
        )

    local removeWords = {
        "请问", "你知道", "告诉我", "帮我查",
        "查一下", "搜索一下", "介绍一下", "介绍",
        "什么是", "是什么", "谁是", "是谁",
        "我想知道", "科普一下", "讲讲",
        "资料", "百科",

        "是几年成立的", "几年成立的", "几年成立",
        "是哪年成立的", "哪年成立的", "哪年成立",
        "是哪一年成立的", "哪一年成立的", "哪一年成立",
        "是什么时候成立的", "什么时候成立的", "什么时候成立",
        "何时成立",

        "是几年建立的", "几年建立的", "几年建立",
        "是哪年建立的", "哪年建立的", "哪年建立",
        "什么时候建立的", "什么时候建立",

        "是谁建立的", "谁建立的", "谁建立",
        "是谁创建的", "谁创建的", "谁创建",
        "是谁创立的", "谁创立的", "谁创立",
        "是谁发明的", "谁发明的", "谁发明",

        "是哪年出生的", "哪年出生的", "哪年出生",
        "什么时候出生的", "什么时候出生",

        "的首都是哪里", "首都是哪里", "首都是什么",
        "有多少人口", "人口有多少", "人口多少",
        "面积有多大", "面积多大", "面积多少",

        "吗", "呢", "？", "?"
    }

    for _, word in ipairs(removeWords) do
        q =
            string.gsub(
                q,
                word,
                ""
            )
    end

    q =
        string.gsub(
            q,
            "的$",
            ""
        )

    q = AITrim(q)

    if q == "" then
        q =
            AITrim(
                tostring(
                    message
                    or ""
                )
            )
    end

    return q
end

local function AIUtf8Truncate(value, maxChars)
    value =
        tostring(
            value
            or ""
        )

    maxChars =
        tonumber(maxChars)
        or 240

    local ok, length =
        pcall(
            utf8.len,
            value
        )

    if not ok
    or not length
    or length <= maxChars then
        return value
    end

    local okOffset, byteIndex =
        pcall(
            utf8.offset,
            value,
            maxChars + 1
        )

    if okOffset
    and byteIndex then
        return
            string.sub(
                value,
                1,
                byteIndex - 1
            )
            .. "……"
    end

    return value
end

local function AIQueryWikipedia(query)
    query = AITrim(query)

    if query == "" then
        return false, "你想查什么？"
    end

    local searchUrl =
        "https://zh.wikipedia.org/w/api.php"
        .. "?action=opensearch"
        .. "&search=" .. HttpService:UrlEncode(query)
        .. "&limit=1&namespace=0&format=json"

    local searchBody =
        game:HttpGet(searchUrl)

    local searchData =
        HttpService:JSONDecode(searchBody)

    if type(searchData) ~= "table"
    or type(searchData[2]) ~= "table"
    or not searchData[2][1] then
        return false,
            "百科里没找到「"
            .. query
            .. "」的明确条目。"
    end

    local title =
        tostring(searchData[2][1])

    local extractUrl =
        "https://zh.wikipedia.org/w/api.php"
        .. "?action=query"
        .. "&prop=extracts"
        .. "&exintro=1&explaintext=1&exchars=520"
        .. "&titles=" .. HttpService:UrlEncode(title)
        .. "&format=json"

    local extractBody =
        game:HttpGet(extractUrl)

    local extractData =
        HttpService:JSONDecode(extractBody)

    local pages =
        extractData
        and extractData.query
        and extractData.query.pages

    if type(pages) ~= "table" then
        return false, "百科返回的数据格式不对。"
    end

    for _, page in pairs(pages) do
        if type(page) == "table"
        and type(page.extract) == "string"
        and page.extract ~= "" then

            local summary =
                AIUtf8Truncate(
                    page.extract,
                    260
                )

            return true,
                tostring(page.title or title)
                .. "："
                .. summary
        end
    end

    return false, "百科条目找到了，但没有可用摘要。"
end

local function AIExtractNewsQuery(message)
    local q = tostring(message or "")

    local removeWords = {
        "请问", "帮我", "查一下", "查询", "查查", "看看",
        "告诉我", "我想看",
        "今天", "现在", "最近", "最新",
        "新闻", "消息", "资讯", "热点", "头条",
        "有什么", "有哪些",
        "吗", "呢", "？", "?"
    }

    for _, word in ipairs(removeWords) do
        q = string.gsub(q, word, "")
    end

    return AITrim(q)
end

local function AIQueryNews(query)
    query = AITrim(query)

    if query == "" then
        return false,
            "新闻范围太大了。你给我一个主题，比如“OpenAI新闻”“唐山新闻”或者“新能源汽车新闻”。"
    end

    local url =
        "https://api.gdeltproject.org/api/v2/doc/doc"
        .. "?query=" .. HttpService:UrlEncode(query)
        .. "&mode=artlist"
        .. "&maxrecords=5"
        .. "&timespan=48h"
        .. "&sort=datedesc"
        .. "&format=jsonfeed"

    local body = game:HttpGet(url)
    local data = HttpService:JSONDecode(body)

    local items =
        data and data.items

    if type(items) ~= "table"
    or #items == 0 then
        return false,
            "最近两天没有检索到「"
            .. query
            .. "」的新闻结果。"
    end

    local lines = {}
    local count = math.min(4, #items)

    for i = 1, count do
        local item = items[i]
        local title =
            type(item) == "table"
            and tostring(item.title or "未命名新闻")
            or "未命名新闻"

        local dateText = ""
        if type(item) == "table"
        and item.date_published then
            dateText =
                "（"
                .. string.sub(
                    tostring(item.date_published),
                    1,
                    10
                )
                .. "）"
        end

        table.insert(
            lines,
            tostring(i)
            .. ". "
            .. title
            .. dateText
        )
    end

    return true,
        "我查到最近的「"
        .. query
        .. "」相关新闻：\n"
        .. table.concat(lines, "\n")
        .. "\n这些是新闻检索结果标题，不代表我替来源真实性背书。"
end

local function AIHandleRealityTask(kind, query)
    local thoughtMap = {
        place = "识别为地名问题 → 校正行政区写法 → 查询地点",
        knowledge = "识别为知识问题 → 搜索百科 → 提取摘要",
        news = "识别为实时新闻 → 检索最近48小时报道"
    }

    AIAddThought(
        thoughtMap[kind]
        or "正在查询现实资料"
    )

    task.spawn(function()
        local ok, success, result =
            pcall(function()
                if kind == "place" then
                    return AIQueryPlace(query)
                elseif kind == "knowledge" then
                    return AIQueryWikipedia(query)
                elseif kind == "news" then
                    return AIQueryNews(query)
                end

                return false, "未知查询类型"
            end)

        if not ok then
            AIReply(
                "这次联网查询失败了："
                .. tostring(success)
            )
            return
        end

        AIReply(
            tostring(result)
        )
    end)
end

local function AIHandleNumberChoice(message)
    local age =
        DBAIState.Turn
        - (DBAIState.Script.LastTurn or 0)

    if age < 0 or age > 2 then
        return false
    end

    local index = nil

    if AIContains(message, "第一个")
    or AINormalize(message) == "1" then
        index = 1
    elseif AIContains(message, "第二个")
    or AINormalize(message) == "2" then
        index = 2
    elseif AIContains(message, "第三个")
    or AINormalize(message) == "3" then
        index = 3
    elseif AIContains(message, "第四个")
    or AINormalize(message) == "4" then
        index = 4
    end

    if index
    and DBAIState.Script.LastMatches[index] then
        local entry =
            DBAIState.Script.LastMatches[index]

        AIAddThought(
            "结合刚才的脚本候选，确认你选择的是「"
            .. entry.Name
            .. "」"
        )

        AIReply(
            "好的，正在加载「"
            .. entry.Name
            .. "」。"
        )

        SafeLoadScript(entry.Item)
        return true
    end

    return false
end

local function AIExecuteFixedScriptQuery(query)
    query = AITrim(query)

    if query == "" then
        AIAddThought(
            "识别到固定“执行”指令，但还没有选择脚本"
        )

        AIReply(
            "请选择或输入要执行的脚本。"
        )

        if AICommandUI
        and AICommandUI.OpenScripts then
            AICommandUI.OpenScripts()
        end

        return true
    end

    local matches = AIFindScripts(query, 4)

    AISetScriptMatches(matches, query)

    if #matches == 1 then
        local found = matches[1]

        AIAddThought(
            "固定执行指令 → 匹配「"
            .. found.Name
            .. "」"
        )

        AIReply(
            "正在执行「"
            .. found.Name
            .. "」。"
        )

        SafeLoadScript(found.Item)
        return true
    end

    if #matches > 1 then
        AIAddThought(
            "固定执行指令 → 找到多个相近脚本"
        )

        AIReply(
            "找到多个相近脚本，请选择一个。"
        )

        for _, entry in ipairs(matches) do
            AIAddRunButton(entry)
        end

        return true
    end

    AIAddThought(
        "固定执行指令 → DB中没有匹配脚本"
    )

    AIReply(
        "DB里没有找到「"
        .. query
        .. "」这个脚本。"
    )

    return true
end

local function AIInferLocalIntent(message)
    local n =
        AINormalize(message)

    local scores = {
        self_panel = 0,
        self_character = 0,
        server_count = 0,
        server_players = 0,
        team = 0,
        game_info = 0,
        world_info = 0,
        db_summary = 0
    }

    local function hasAny(words)
        for _, word in ipairs(words) do
            if string.find(
                n,
                AINormalize(word),
                1,
                true
            ) then
                return true
            end
        end

        return false
    end

    if hasAny({
        "服务器", "这个服", "当前服",
        "房间", "本服"
    }) then
        scores.server_count =
            scores.server_count + 2

        scores.server_players =
            scores.server_players + 2
    end

    if hasAny({
        "多少人", "几个人", "几人",
        "人数", "在线人数",
        "一共多少", "共有多少"
    }) then
        scores.server_count =
            scores.server_count + 4
    end

    if hasAny({
        "都有谁", "有哪些人", "谁在",
        "玩家名单", "在线玩家",
        "哪些玩家", "所有玩家"
    }) then
        scores.server_players =
            scores.server_players + 4
    end

    if hasAny({
        "我", "我的", "自己",
        "本人", "人物", "角色"
    }) then
        scores.self_panel =
            scores.self_panel + 1

        scores.self_character =
            scores.self_character + 1
    end

    if hasAny({
        "速度", "walkspeed",
        "生命", "血量", "多少血",
        "坐标", "位置",
        "跳跃", "jumppower",
        "状态", "队伍"
    }) then
        scores.self_character =
            scores.self_character + 4
    end

    if hasAny({
        "我的信息", "我的资料",
        "我的详情", "玩家面板",
        "人物信息", "角色信息",
        "全部信息", "详细信息",
        "信息都调出来", "详情都调出来"
    }) then
        scores.self_panel =
            scores.self_panel + 5
    end

    if hasAny({
        "队伍情况", "阵营",
        "有哪些队伍", "team情况"
    }) then
        scores.team =
            scores.team + 6
    end

    if hasAny({
        "这个游戏", "当前游戏",
        "游戏信息", "placeid",
        "gameid", "jobid"
    }) then
        scores.game_info =
            scores.game_info + 6
    end

    if hasAny({
        "workspace", "地图对象",
        "地图里有什么", "世界里有什么",
        "服务器环境"
    }) then
        scores.world_info =
            scores.world_info + 6
    end

    if hasAny({
        "db有什么", "db里有什么",
        "db有多少脚本",
        "脚本库情况", "脚本数据库"
    }) then
        scores.db_summary =
            scores.db_summary + 6
    end

    local bestIntent = nil
    local bestScore = 0

    for intentName, score in pairs(scores) do
        if score > bestScore then
            bestScore = score
            bestIntent = intentName
        end
    end

    if bestScore < 4 then
        return nil
    end

    return bestIntent
end

local function AIHandleSmartLocalIntent(message)
    local intent =
        AIInferLocalIntent(
            message
        )

    if not intent then
        return false
    end

    AIEnterNonScriptMode()

    if intent == "server_count" then
        AIAddThought(
            "语义判断：询问当前服务器人数，直接读取 Players"
        )

        AIRunServerCountQuery(
            false
        )
        return true
    end

    if intent == "server_players" then
        AIAddThought(
            "语义判断：询问当前服务器玩家，直接读取 Players"
        )

        AIRunPlayerListQuery(
            false
        )
        return true
    end

    if intent == "self_panel" then
        AIAddThought(
            "语义判断：询问自己的详细信息，读取玩家面板"
        )

        AIReply(
            AIGetSelfPanelText(
                "全部"
            )
        )
        return true
    end

    if intent == "self_character" then
        AIAddThought(
            "语义判断：询问自己的实时角色状态"
        )

        AIRunCharacterQuery()
        return true
    end

    if intent == "team" then
        AIAddThought(
            "语义判断：询问当前服务器队伍情况"
        )

        AIReply(
            AIGetTeamSummary()
        )
        return true
    end

    if intent == "game_info" then
        AIRunGameInfoQuery()
        return true
    end

    if intent == "world_info" then
        AIRunWorldQuery()
        return true
    end

    if intent == "db_summary" then
        AIRunDBSummaryQuery()
        return true
    end

    return false
end

local function DBLocalAI(message)
    message = AITrim(message)

    if message == "" then
        return
    end

    DBAIState.Turn =
        DBAIState.Turn + 1

    if DBAIState.Chat.Mood ~= "normal"
    and (
        DBAIState.Turn
        - (DBAIState.Chat.MoodTurn or 0)
    ) > 3 then
        DBAIState.Chat.Mood = "normal"
        DBAIState.Chat.MoodTurn = 0
    end

    DBAIState.Chat.LastUserText =
        message

    AIAddMessage("user", message)

    AIClearFocusIfOld(8)

    if AINormalize(message) == "执行" then
        AIEnterNonScriptMode()

        AIAddThought(
            "识别为手动输入的执行意图，但没有指定脚本"
        )

        AIReply(
            "你想执行哪个脚本？可以直接告诉我脚本名，或者用左下角的 + 选择。"
        )
        return
    end

    if AIIsFollowUpPhrase(message) then
        AIAddThought(
            "检测到省略式追问，结合上一轮任务解析“现在呢”的指代对象"
        )

        if AIRepeatLastTask() then
            return
        end
    end

    if AIHandleNumberChoice(message) then
        return
    end

    if AIHandleSmartLocalIntent(message) then
        return
    end

    if AIIsWeatherIntent(message) then
        AIEnterNonScriptMode()

        local city =
            AIExtractWeatherCity(message)

        if city == "" then
            if DBAIState.Weather.LastCity then
                city =
                    DBAIState.Weather.LastCity
            else
                DBAIState.Weather.PendingCityTurn =
                    DBAIState.Turn

                AIAddThought(
                    "识别为天气查询，但还缺少地点"
                )

                AIReply(
                    "可以。请告诉我你要查询的城市或地区，例如“唐山市”。"
                )
                return
            end
        end

        AIRunWeatherQuery(
            city,
            false
        )

        return
    end

    if DBAIState.Weather.PendingCityTurn then
        local age =
            DBAIState.Turn
            - DBAIState.Weather.PendingCityTurn

        if age == 1
        and AILooksLikeShortLocation(message) then
            DBAIState.Weather.PendingCityTurn = nil
            AIEnterNonScriptMode()

            AIAddThought(
                "把这一条识别为上一轮天气查询的地点"
            )

            AIRunWeatherQuery(
                message,
                false
            )

            return
        end

        DBAIState.Weather.PendingCityTurn = nil
    end

    if AIIsNewsIntent(message) then
        AIEnterNonScriptMode()

        AIHandleRealityTask(
            "news",
            AIExtractNewsQuery(message)
        )
        return
    end

    if AIIsPlaceIntent(message) then
        AIEnterNonScriptMode()

        local q =
            AIExtractPlaceQuery(message)

        if q == "" then
            AIReply(
                "请告诉我你想查询的具体地名。"
            )
        else
            AIHandleRealityTask(
                "place",
                q
            )
        end
        return
    end

    if AIIsKnowledgeIntent(message) then
        AIEnterNonScriptMode()

        local q =
            AIExtractKnowledgeQuery(message)

        if q == "" then
            AIReply(
                "你想了解什么？告诉我关键词即可。"
            )
        else
            AIHandleRealityTask(
                "knowledge",
                q
            )
        end
        return
    end

    if AIIsTimeIntent(message) then
        AIEnterNonScriptMode()

        AIAddThought(
            "识别为时间日期问题，读取当前设备时间"
        )

        local weekMap = {
            ["0"] = "星期日",
            ["1"] = "星期一",
            ["2"] = "星期二",
            ["3"] = "星期三",
            ["4"] = "星期四",
            ["5"] = "星期五",
            ["6"] = "星期六"
        }

        AIReply(
            "现在是 "
            .. os.date("%Y年%m月%d日 %H:%M")
            .. "，"
            .. (weekMap[os.date("%w")] or "")
            .. "。"
        )
        return
    end

    if AIHasAny(message, {
        "服务器多少人", "服务器有多少人",
        "现在多少人", "当前多少人",
        "这个服多少人", "这个服务器几个人",
        "在线人数", "有几个人", "几个人在线"
    }) then
        AIEnterNonScriptMode()
        AIRunServerCountQuery(false)
        return
    end

    if AIHasAny(message, {
        "服务器有哪些人", "服务器都有谁",
        "谁在服务器", "玩家名单",
        "现在都有谁", "这个服都有谁",
        "在线玩家", "现在谁在"
    }) then
        AIEnterNonScriptMode()
        AIRunPlayerListQuery(false)
        return
    end

    if AIHasAny(message, {
        "队伍情况", "有哪些队伍",
        "服务器队伍", "team情况",
        "阵营情况"
    }) then
        AIEnterNonScriptMode()

        AIAddThought(
            "读取 Teams 服务并统计各队伍人数"
        )

        AIReply(
            AIGetTeamSummary()
        )
        return
    end

    if AIHasAny(message, {
        "我现在什么状态", "我的状态",
        "我的角色信息", "我多少血",
        "我的生命", "我的速度",
        "我在哪个坐标", "我的坐标"
    }) then
        AIEnterNonScriptMode()
        AIRunCharacterQuery()
        return
    end

    if AIHasAny(message, {
        "这个游戏是什么", "当前游戏是什么",
        "游戏信息", "这个游戏信息",
        "placeid", "gameid", "jobid"
    }) then
        AIEnterNonScriptMode()
        AIRunGameInfoQuery()
        return
    end

    if AIHasAny(message, {
        "这个地图有什么", "workspace有什么",
        "环境信息", "地图对象",
        "世界里有什么", "服务器环境"
    }) then
        AIEnterNonScriptMode()
        AIRunWorldQuery()
        return
    end

    if AIHasAny(message, {
        "db有什么", "db里有什么",
        "db有多少脚本", "脚本库情况",
        "整个脚本有什么", "这个脚本有什么",
        "脚本数据库"
    }) then
        AIEnterNonScriptMode()
        AIRunDBSummaryQuery()
        return
    end

    local category =
        AIIsCategoryScriptQuery(message)

    if category then
        AIAddThought(
            "识别为脚本分类查询，读取「"
            .. category
            .. "」"
        )

        AIListCategory(category)
        return
    end

    if AIIsExplicitScriptSearch(message) then
        local query =
            AICleanScriptQuery(message)

        if query == "" then
            AIReply(
                "你想找哪个脚本？告诉我名称或关键词即可。"
            )
            return
        end

        local matches =
            AIFindScripts(query, 5)

        AISetScriptMatches(matches, query)

        if #matches == 0 then
            AIAddThought(
                "搜索 DB 脚本数据库，没有找到匹配项"
            )

            AIReply(
                "当前 DB 里没有找到「"
                .. query
                .. "」相关脚本。"
            )
            return
        end

        AIAddThought(
            "搜索 DB 脚本数据库，找到 "
            .. tostring(#matches)
            .. " 个候选"
        )

        AIReply(
            "找到了几个相关脚本，你可以直接选择。"
        )

        for _, entry in ipairs(matches) do
            AIAddRunButton(entry)
        end

        return
    end

    if AIHasAny(message, {
        "给我开", "帮我开", "开一下",
        "用一下", "帮我用", "给我用"
    }) then
        local query =
            AICleanScriptQuery(message)

        if query ~= "" then
            local matches =
                AIFindScripts(query, 3)

            if #matches == 1 then
                local found =
                    matches[1]

                AISetScriptMatches(
                    matches,
                    query
                )

                AIAddThought(
                    "识别为自然语言脚本执行请求，匹配到「"
                    .. found.Name
                    .. "」"
                )

                AIReply(
                    "好的，正在加载「"
                    .. found.Name
                    .. "」。"
                )

                SafeLoadScript(found.Item)
                return
            elseif #matches > 1 then
                AISetScriptMatches(
                    matches,
                    query
                )

                AIAddThought(
                    "识别为自然语言脚本请求，但有多个候选"
                )

                AIReply(
                    "我找到几个接近的脚本，为避免误操作，请选择一个。"
                )

                for _, entry in ipairs(matches) do
                    AIAddRunButton(entry)
                end

                return
            end
        end
    end

    if AIIsExplicitScriptRun(message) then
        local query =
            AICleanScriptQuery(message)

        if query == "" then
            AIReply(
                "请告诉我你要运行的脚本名称。"
            )
            return
        end

        local matches =
            AIFindScripts(query, 4)

        AISetScriptMatches(matches, query)

        if #matches == 1 then
            local found =
                matches[1]

            AIAddThought(
                "识别为脚本执行命令，匹配到「"
                .. found.Name
                .. "」"
            )

            AIReply(
                "好的，正在加载「"
                .. found.Name
                .. "」。"
            )

            SafeLoadScript(found.Item)
            return
        end

        if #matches > 1 then
            AIAddThought(
                "识别为脚本执行命令，但存在多个相近结果"
            )

            AIReply(
                "找到多个相近脚本。为避免误执行，请选择一个。"
            )

            for _, entry in ipairs(matches) do
                AIAddRunButton(entry)
            end

            return
        end

        AIAddThought(
            "识别为脚本执行命令，但数据库没有匹配项"
        )

        AIReply(
            "当前 DB 里没有找到「"
            .. query
            .. "」这个脚本。"
        )

        return
    end

    local normalizedMessage =
        AINormalize(message)

    for _, entry in ipairs(AIAllScripts) do
        if AINormalize(entry.Name)
        == normalizedMessage then
            AISetScriptMatches(
                {entry},
                entry.Name
            )

            AIAddThought(
                "输入内容与 DB 脚本名称完全一致"
            )

            AIReply(
                "「"
                .. entry.Name
                .. "」是当前 DB 中的脚本。需要运行时可以说“运行 "
                .. entry.Name
                .. "”。"
            )
            return
        end
    end

    AIEnterNonScriptMode()

    if AIHasAny(message, {
        "烦", "难受", "不开心", "郁闷",
        "好累", "生气", "崩溃", "倒霉"
    }) then
        DBAIState.Chat.Mood = "low"
        DBAIState.Chat.MoodTurn = DBAIState.Turn
        DBAIState.Chat.LastTopic = "mood"

        AIAddThought(
            "识别到负面情绪，优先回应当前感受"
        )

        AIReplyPick({
            "听起来你现在确实有些烦。你愿意的话，可以具体说说发生了什么。",
            "我明白。先不用急着解决问题，你可以把最让你不舒服的那部分说出来。",
            "这种状态确实不好受。你继续说，我会跟着你的话题来。"
        })
        return
    end

    if AIHasAny(message, {
        "开心", "成功了", "搞定了",
        "不错", "舒服"
    }) then
        DBAIState.Chat.Mood = "happy"
        DBAIState.Chat.MoodTurn = DBAIState.Turn

        AIAddThought(
            "识别到积极情绪，保持自然回应"
        )

        AIReplyPick({
            "那很好，说明这次终于顺利了。",
            "听起来结果不错。",
            "可以，这样就舒服多了。"
        })
        return
    end

    if AIHasAny(message, {
        "无聊", "陪我聊", "聊聊天",
        "随便聊"
    }) then
        AIAddThought(
            "识别为闲聊，不进入脚本模式"
        )

        AIReplyPick({
            "可以。你最近比较关注什么？游戏、电脑、AI，或者生活里的事情都可以。",
            "当然可以。你随便起个话题，我跟着聊。",
            "可以聊。你现在最想聊哪件事？"
        })
        return
    end

    if AIHasAny(message, {
        "你好", "嗨", "在吗", "在不在"
    }) then
        AIAddThought(
            "识别为问候"
        )

        AIReplyPick({
            "你好，我在。",
            "在的，你说。",
            "你好。今天想聊什么？"
        })
        return
    end

    if AIHasAny(message, {
        "你是谁", "你叫什么"
    }) then
        AIAddThought(
            "识别为身份问题"
        )

        AIReply(
            "我是 DB AI，主要负责聊天、现实信息查询，以及协助你使用 DB 里的脚本功能。"
        )
        return
    end

    if AIHasAny(message, {
        "能做什么", "怎么用", "帮助", "指令",
        "能帮我干什么", "能帮我干啥",
        "你会什么", "你能干嘛",
        "你有什么用", "功能介绍"
    }) then
        AIEnterNonScriptMode()

        AIAddThought(
            "识别为能力询问，汇总当前环境感知、现实查询和 DB 控制能力"
        )

        AIReply(
            AIGetCapabilitiesText()
        )
        return
    end

    if AIHasAny(message, {
        "谢谢", "多谢", "感谢"
    }) then
        AIAddThought(
            "识别为感谢"
        )

        AIReplyPick({
            "不客气。",
            "不用客气。",
            "没关系，有需要继续说。"
        })
        return
    end

    if #AINormalize(message) <= 12 then
        local focusKind, focusArgs =
            AIGetRecentFocus(6)

        if focusKind == "server_count"
        and AIHasAny(message, {"多少", "几个人", "人呢"}) then
            AIRunServerCountQuery(true)
            return

        elseif focusKind == "weather"
        and AIHasAny(message, {"怎么样", "如何", "呢"}) then
            local city =
                focusArgs
                and focusArgs.City
                or DBAIState.Weather.LastCity

            AIRunWeatherQuery(
                city,
                true
            )
            return
        end
    end

    local function IsLikelyKnowledgeQuestion(value)
        local normalizedValue =
            AINormalize(value)

        if AIHasAny(normalizedValue, {
            "几年", "哪年", "哪一年",
            "什么时候", "何时",
            "谁发明", "谁建立", "谁创建", "谁创立",
            "首都", "人口", "面积",
            "历史", "成立", "建立",
            "出生", "发生于", "发生在"
        }) then
            return true
        end

        local hasQuestionMark =
            string.find(
                tostring(value),
                "？",
                1,
                true
            )
            or string.find(
                tostring(value),
                "?",
                1,
                true
            )

        if hasQuestionMark
        and AIHasAny(normalizedValue, {
            "谁", "哪", "多少", "几",
            "什么时候", "哪里"
        }) then
            return true
        end

        return false
    end

    if IsLikelyKnowledgeQuestion(message) then
        AIEnterNonScriptMode()

        local query =
            AIExtractKnowledgeQuery(
                message
            )

        AIAddThought(
            "识别为事实知识问题，转入百科检索"
        )

        AIHandleRealityTask(
            "knowledge",
            query
        )
        return
    end

    AIAddThought(
        "识别为普通聊天，直接回应当前内容"
    )

    local normalized =
        AINormalize(message)

    if DBAIState.Chat.Mood == "low" then
        AIReplyPick({
            "我在听。你可以继续说，我会尽量跟住你的意思。",
            "明白。你可以把最关键的那一点继续说出来。",
            "可以，我们就接着这个话题聊。"
        })
        return
    end

    if string.find(message, "为什么", 1, true) then
        AIReply(
            "这个问题要结合具体情况判断。你把关键背景告诉我，我会直接分析原因。"
        )
        return
    end

    if string.find(message, "你觉得", 1, true)
    or string.find(message, "你认为", 1, true) then
        AIReply(
            "可以。你把具体事情说出来，我会直接给出判断和理由。"
        )
        return
    end

    if string.find(message, "怎么办", 1, true)
    or string.find(message, "怎么解决", 1, true) then
        AIReply(
            "可以。把具体问题和现在的现象告诉我，我会直接给你解决思路。"
        )
        return
    end

    local shortText =
        AIUtf8Truncate(
            tostring(message or ""),
            18
        )

    AIReplyPick({
        "关于「"
        .. shortText
        .. "」，我会按这个话题继续，不切到脚本模式。",
        "我接着这个问题聊。你可以继续问具体一点。",
        "可以，我们继续当前话题。",
        "我在听。你继续问，我会回答内容本身。"
    })
end

DBAIHandleMessage = function(message)
    message =
        AITrim(message)

    if message == "" then
        return
    end

    local commandEntry = nil
    local playerPanelSection = nil

    if AICommandUI then
        if AICommandUI.ConsumeExecute then
            commandEntry =
                AICommandUI.ConsumeExecute(
                    message
                )
        end

        if AICommandUI.ConsumePlayerPanel then
            playerPanelSection =
                AICommandUI.ConsumePlayerPanel(
                    message
                )
        end
    end

    if playerPanelSection then
        if AICommandUI
        and AICommandUI.Popup
        and AICommandUI.Popup.Visible then
            AICommandUI.SetVisible(false)
        end

        AIAddMessage(
            "user",
            "查看玩家面板 · "
            .. tostring(playerPanelSection)
        )

        AIAddThought(
            "识别到来自“+ → 查看玩家面板 → 选择项目 → 发送”的固定UI指令"
        )

        AIReply(
            AIGetSelfPanelText(
                playerPanelSection
            )
        )

        return
    end

    if commandEntry then
        AIAddMessage(
            "user",
            message
        )

        AIAddThought(
            "识别到来自“+ → 执行 → 脚本选择”的固定UI指令"
        )

        AIReply(
            "正在执行「"
            .. tostring(commandEntry.Name)
            .. "」。"
        )

        SafeLoadScript(
            commandEntry.Item
        )

        return
    end

    DBLocalAI(message)
end

local function ShowDBAI()
    ListScroll.Visible = false
    HomePanel.Visible = false
    AIPanel.Visible = true
    State.CurrentCategory = "DB AI"

    if AIMessageIndex == 0 then
        AIAddMessage(
            "assistant",
            "你好。我保留核心能力：聊天、天气、新闻、百科、地名、服务器环境和 DB 脚本控制，并支持连续追问。"
        )
    end
end

AISend.Activated:Connect(function()
    local message = AIInput.Text
    AIInput.Text = ""
    DBAIHandleMessage(message)
end)

AIInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local message = AIInput.Text
        AIInput.Text = ""
        DBAIHandleMessage(message)
    end
end)

local function ApplySafeClickEffect(btn, onClick)
    btn.Activated:Connect(function()
        if onClick then
            onClick()
        end
    end)
end

local function RenderRightList(categoryName)
    if AICommandUI
    and AICommandUI.Popup
    and AICommandUI.Popup.Visible then
        AICommandUI.SetVisible(false)
    end

    HomePanel.Visible = false
    AIPanel.Visible = false
    ListScroll.Visible = true

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
    "竞技格斗", "休闲社交", "合作游戏", "非对称竞技",
    "塔防游戏", "其他作者脚本"
}

for categoryIndex, catName in ipairs(categoriesOrder) do
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
    btn.LayoutOrder = categoryIndex + 10

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

local HomeButton = Instance.new("TextButton")
HomeButton.Name = "Category_Home"
HomeButton.Size = UDim2.new(1, 0, 0, 34)
HomeButton.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
HomeButton.BackgroundTransparency = 0.18
HomeButton.BorderSizePixel = 0
HomeButton.Text = ""
HomeButton.AutoButtonColor = false
HomeButton.ZIndex = 16
HomeButton.LayoutOrder = 1
HomeButton.Parent = MenuScroll

AddCorner(HomeButton, 11)

AddRainbowBorder(
    HomeButton,
    1.45,
    0.02,
    3.20
)

local HomeButtonText = Instance.new("TextLabel")
HomeButtonText.Name = "RainbowText"
HomeButtonText.BackgroundTransparency = 1
HomeButtonText.Position = UDim2.fromOffset(12, 0)
HomeButtonText.Size = UDim2.new(1, -20, 1, 0)
HomeButtonText.Text = "主页"
HomeButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeButtonText.TextSize = 14
HomeButtonText.Font = Enum.Font.GothamBold
HomeButtonText.TextXAlignment = Enum.TextXAlignment.Left
HomeButtonText.TextYAlignment = Enum.TextYAlignment.Center
HomeButtonText.ZIndex = 17
HomeButtonText.Parent = HomeButton

StartRainbowFlow(
    HomeButtonText,
    3.20,
    NumberSequence.new(0)
)

HomeButton.Activated:Connect(function()
    ShowHomePage()
end)

local DBAIButton = Instance.new("TextButton")
DBAIButton.Name = "Category_DB_AI"
DBAIButton.Size = UDim2.new(1, 0, 0, 34)
DBAIButton.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
DBAIButton.BackgroundTransparency = 0.18
DBAIButton.BorderSizePixel = 0
DBAIButton.Text = ""
DBAIButton.AutoButtonColor = false
DBAIButton.ZIndex = 16
DBAIButton.LayoutOrder = 2
DBAIButton.Parent = MenuScroll

AddCorner(DBAIButton, 11)

AddRainbowBorder(
    DBAIButton,
    1.45,
    0.02,
    3.20
)

local DBAIButtonText = Instance.new("TextLabel")
DBAIButtonText.Name = "RainbowText"
DBAIButtonText.BackgroundTransparency = 1
DBAIButtonText.Position = UDim2.fromOffset(12, 0)
DBAIButtonText.Size = UDim2.new(1, -20, 1, 0)
DBAIButtonText.Text = "DB  AI"
DBAIButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
DBAIButtonText.TextSize = 14
DBAIButtonText.Font = Enum.Font.GothamBold
DBAIButtonText.TextXAlignment = Enum.TextXAlignment.Left
DBAIButtonText.TextYAlignment = Enum.TextYAlignment.Center
DBAIButtonText.ZIndex = 17
DBAIButtonText.Parent = DBAIButton

StartRainbowFlow(
    DBAIButtonText,
    3.20,
    NumberSequence.new(0)
)

DBAIButton.Activated:Connect(function()
    ShowDBAI()
end)

ShowHomePage()

end

DBBuildHomeAndAI()

local function SetPanelPosition(pos)
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

local function InputXY(input)
    return Vector2.new(input.Position.X, input.Position.Y)
end

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
    moveMagicToken = moveMagicToken + 1
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

local activePanelGesture = nil

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

    resizeMagicToken = resizeMagicToken + 1
    local myToken = resizeMagicToken

    if resizePulseTween then
        resizePulseTween:Cancel()
        resizePulseTween = nil
    end

    if active then

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

MoveBarHitArea.InputBegan:Connect(function(input)

    if State.Animating
    or State.Minimized
    or activePanelGesture ~= nil then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        activePanelGesture = "move"

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

ResizeHandle.InputBegan:Connect(function(input)

    if State.Animating
    or State.Minimized
    or activePanelGesture ~= nil then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        activePanelGesture = "resize"

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

UserInputService.InputChanged:Connect(function(input)

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

print("✅ DB Panel 已加载 · FPS顶栏重排 / 迷你悬浮帧率版")
