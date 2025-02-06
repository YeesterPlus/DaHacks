local notif = Instance.new("ScreenGui")
local label = Instance.new("TextLabel")
label.Size= UDim2.fromScale(1,1)
notif.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
label.BackgroundTransparency = 1
label.TextStrokeTransparency = 0
label.TextColor3 = Color3.new(1,1,1)
label.TextStrokeColor3=Color3.new(0,0,0)
label.Text = "Fling+ enabled"
notif.Parent = game:GetService("CoreGui")
notif.Enabled = false
local enabled = false
local uis = game:GetService("UserInputService")
uis.InputEnded:Connect(function(input: InputObject, gameProcessedEvent: boolean) 
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ==( FlingKey or Enum.KeyCode.Y )then 
		notif.Enabled = not enabled
		enabled = not enabled
	end
end)
game:GetService("RunService").RenderStepped:Connect(function()
	if enabled then
		game.Workspace.CurrentCamera.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
	end
end)
local c
function init()
	if c ~= nil then return end
	c=game.Players.LocalPlayer:GetMouse().Button1Up:Connect(function()
		c:Disconnect()
		c=nil
		local self = game.Players.LocalPlayer.Character
		if not enabled then init() return end
		local humanoid = self:WaitForChild("Humanoid")
		game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Fixed
		print(game.Players.LocalPlayer:GetMouse().Target)
		local part = nil
		part = game.Players.LocalPlayer:GetMouse().Target
		if part==nil then init() return end
		if part:IsGrounded() then init() return end
		if not (part.CanCollide or part.Parent:FindFirstChildOfClass("Humanoid") ~= nil) then init() return end
		local oldCF = self:WaitForChild("HumanoidRootPart").CFrame
		local out = Instance.new("SelectionBox",part)
		out.Adornee = part
		out.Color3 = Color3.new(1,0,0)
		humanoid.EvaluateStateMachine = false
		while part:FindFirstAncestorWhichIsA("DataModel")~=nil and self:WaitForChild("HumanoidRootPart").Position.Magnitude <= 4000 do
			local d = wait()
			local x = self:WaitForChild("HumanoidRootPart").Position.X
			local y = self:WaitForChild("HumanoidRootPart").Position.Z
			
			self:WaitForChild("HumanoidRootPart").AssemblyLinearVelocity = (part.Position-self:WaitForChild("HumanoidRootPart").Position)/d
			self:WaitForChild("HumanoidRootPart").AssemblyAngularVelocity = Vector3.one*9999999
			for _,i in ipairs(self:GetDescendants()) do
				if i:IsA("BasePart") then
					i.CanCollide = math.random(1,1000)==1
				end
			end
		end
		self:WaitForChild("HumanoidRootPart").AssemblyLinearVelocity = Vector3.zero
		self:WaitForChild("HumanoidRootPart").AssemblyAngularVelocity = Vector3.zero
		self:WaitForChild("HumanoidRootPart").CFrame=oldCF
		for _,i in ipairs(self:GetDescendants()) do
			if i:IsA("BasePart") then
				i.CanCollide = true
			end
		end
		humanoid.EvaluateStateMachine = true
		init()
	end)
end
game.Players.LocalPlayer.CharacterAdded:Connect(function()
	init()
	local self = game.Players.LocalPlayer.Character
	while true do
		local d = wait()
		if self:WaitForChild("HumanoidRootPart").Position.Magnitude > 5000 then for _=1,30 do d = wait()
				self:WaitForChild("HumanoidRootPart").AssemblyLinearVelocity = (Vector3.zero-self:WaitForChild("HumanoidRootPart").Position)/d
		end end
	end
end)
