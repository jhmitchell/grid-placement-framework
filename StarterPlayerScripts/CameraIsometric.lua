local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local zoom = 70
local zoomIncrement = 5
local zoomMin = 50
local zoomMax = 100
local fieldOfView = 7

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Camera = game.Workspace.CurrentCamera

Camera.CameraType = Enum.CameraType.Custom
Player.CameraMinZoomDistance = 5

RunService.RenderStepped:Connect(function()
	Camera.FieldOfView = fieldOfView
	if Character and Character:findFirstChild("Head") then
		-- Zooming out will mess up sounds. To fix this, set the listening point to be the character's head.
		SoundService:SetListener(Enum.ListenerType.ObjectCFrame, Character.Head)
		
		-- Set the camera's position based on zoom
		local cameraPosition = Vector3.new(Character.Head.Position.X - zoom, Character.Head.Position.Y + zoom, Character.Head.Position.Z - zoom)
		Camera.CFrame = CFrame.new(cameraPosition, Character.Head.Position)
	end
end)

UserInputService.InputChanged:Connect(function(input, _gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseWheel then
		-- -1 = zoom out, 1 = zoom in
		if input.Position.Z == -1 and zoom < zoomMax then
			zoom += zoomIncrement
		elseif input.Position.Z == 1 and zoom > zoomMin then
			zoom -= zoomIncrement
		end
	end
end)