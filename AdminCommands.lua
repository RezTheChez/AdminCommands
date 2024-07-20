-- Current Admins

local admins = {"ReztheChez", "Player1"}
-- Ban Store

local DataStoreService = game:GetService("DataStoreService")
local banStore = DataStoreService:GetDataStore("UserTempBans")
local banStore2 = DataStoreService:GetDataStore("UserBans")
game.Players.PlayerAdded:Connect(function(player)
	-- Check if tempBanned
	local bannedTime = banStore:GetAsync("UserBan"..player.UserId)
	if bannedTime and os.time() < bannedTime[1]  then
		player:Kick("TempBan\nTime: "..bannedTime[2].." minutes") 
	elseif bannedTime and os.time() > bannedTime[1] then
		banStore:RemoveAsync("UserBan"..player.UserId)
	end
	
	-- Check if banned
	local ifBanned = false
	local banData = banStore2:GetAsync(player.UserId)
	if banData ~= nil then
		ifBanned = banData
	else
		ifBanned = false	
	end
	if ifBanned == true then
		player:Kick("You have been banned from the game.")
	end
	
	-- Name varaibles
	local nameGUI = script.NameTag
	local cloned = nameGUI:Clone()
	cloned.Parent = workspace:WaitForChild(player.Name).Head
	cloned.Enabled = false
	
	-- Add nametag upon death
	player.Character.Humanoid.Died:Connect(function()
		if player.Character.Head:FindFirstChild("NameTag") then
			wait(game:GetService("Players").RespawnTime)
			nameGUI:Clone().Parent = player.Character.Head
			nameGUI.Enabled = false
		end
	end)
	
	player.Chatted:Connect(function(message, speaker)
		for i,v in pairs(admins) do
			--if player.Name == v then
				-- Admin check disabled for testing purposes
				
				-- Commands
				if string.sub(message:lower(), 1, 8) == "/kill me" then
					player.Character.Humanoid.Health = 0
				elseif string.sub(message:lower(), 1, 13) == "/kill others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							v.Character.Humanoid.Health = 0
						end
					end
				elseif string.sub(message:lower(), 1, 10) == "/kill all" then
					for _, v in pairs(game.Players:GetPlayers()) do
						v.Character.Humanoid.Health = 0
					end
				elseif string.sub(message:lower(), 1, 5) == "/kill" then
					local fiPlayer = string.sub(message:lower(), 7)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							v.Character.Humanoid.Health = 0
						end
					end
				end	
				-- tp cmds
				local cmd, args = nil, {}
				for argmatch in message:gmatch("[%w%p]+") do
					if cmd == nil then 
						cmd = argmatch:lower() 
					else
						table.insert(args, argmatch:lower()) 
					end
				end
				if cmd == "/tp" then
					local Player1 = {}
					if args[1] == "me" then
						table.insert(Player1, player)
					elseif args[1] == "others" then
						for _, v in pairs(game.Players:GetPlayers()) do
							if v.Name ~= player.Name then
								table.insert(Player1, v)
							end
						end
					else
						for _, v in pairs(game.Players:GetPlayers()) do
							if string.sub(v.Name:lower(), 1, #args[1]) == args[1] then
								table.insert(Player1, v)
							end
						end
					end

					local Player2;
					if args[2] == "me" then
						Player2 = player
					else
						for _, v in pairs(game.Players:GetPlayers()) do
							if string.sub(v.Name:lower(), 1, #args[2]) == args[2] then
								Player2 = v
							end
						end
					end
					if #Player1 == 0 or Player2 == nil then
						return "[Admin] Error: Argument 1 (or 2) is invalid."
					end
					for _, v  in pairs(Player1) do
						v.Character.Humanoid.Jump = true
						v.Character:SetPrimaryPartCFrame(Player2.Character.HumanoidRootPart.CFrame)
					end
				end
				-- explode cmds
				if string.sub(message:lower(), 1, 11) == "/explode me" then
					local explosion = Instance.new("Explosion")
					explosion.Parent = player.Character.HumanoidRootPart
					explosion.Position = player.Character.HumanoidRootPart.Position
					explosion.BlastPressure = 1
					player.Character.Humanoid.Health = 0
				elseif string.sub(message:lower(), 1, 15) == "/explode others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							local explosion = Instance.new("Explosion")
							explosion.Parent = v.Character.HumanoidRootPart
							explosion.Position = v.Character.HumanoidRootPart.Position
							explosion.BlastPressure = 1
							v.Character.Humanoid.Health = 0
						end
					end
				elseif string.sub(message:lower(), 1, 12) == "/explode all" then
					for _, v in pairs(game.Players:GetPlayers()) do
						local explosion = Instance.new("Explosion")
						explosion.Parent = v.Character.HumanoidRootPart
						explosion.Position = v.Character.HumanoidRootPart.Position
						explosion.BlastPressure = 1
						v.Character.Humanoid.Health = 0
					end
				elseif string.sub(message:lower(), 1, 8) == "/explode" then
					local fiPlayer = string.sub(message:lower(), 10)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							local explosion = Instance.new("Explosion")
							explosion.Parent = v.Character.HumanoidRootPart
							explosion.Position = v.Character.HumanoidRootPart.Position
							explosion.BlastPressure = 1
							v.Character.Humanoid.Health = 0
						end
					end		
				end
				-- kick cmds
				if string.sub(message:lower(), 1, 8) == "/kick me" then
					player:Kick("You were kicked from the game by: "..player.Name)
				elseif string.sub(message:lower(), 1, 9) == "/kick all" then	
					for _, v in pairs(game.Players:GetPlayers()) do
						v:Kick("You were kicked from the game by: "..player.Name)
					end
				elseif string.sub(message:lower(), 1, 12) == "/kick others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							v:Kick("You were kicked from the game by: "..player.Name)
						end
					end
				elseif string.sub(message:lower(), 1, 5) == "/kick" then
					local fiPlayer = string.sub(message:lower(), 7)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							v:Kick("You were kicked from the game by: "..player.Name)
						end
					end	
				end
				-- tempban cmds
				if cmd == "/tempban" then
					local banPlayers = {}
					if args[1] == "me" then
						table.insert(banPlayers, player)
					elseif args[1] == "others" then
						for _, v in pairs(game.Players:GetPlayers()) do
							if v.Name ~= player.Name then
								table.insert(banPlayers, v) 
							end
						end
					elseif args[1] == "all" then
						for _, v in pairs(game.Players:GetPlayers()) do
							table.insert(banPlayers, v)
						end
					else
						for _, v in pairs(game.Players:GetPlayers()) do
							if string.sub(v.Name:lower(), 1, #args[1]) == args[1] then
								table.insert(banPlayers, v)
							end
						end
					end
					if #banPlayers == 0 then 
						return "[Admin]: No banned players found." 
					end
					local Time = os.time() + (60 * args[2]) -- 60 * 1 = 1 Min added to the ban time
					for _, v in pairs(banPlayers) do
						banStore:SetAsync("UserBan"..v.UserId, {Time, args[2]})
						v:Kick("TempBan\nTime: "..args[2].." minutes")
					end
				end
				-- ban cmds
				if cmd == "/ban" then
					if args[1] == "me" then
						ifBanned = true
						banStore2:SetAsync(player.UserId, ifBanned)
						player:Kick("You have been banned from the game.")
					elseif args[1] == "others" then
						for _, v in pairs(game.Players:GetPlayers()) do
							if v.Name ~= player.Name then
								ifBanned = true
								banStore2:SetAsync(v.UserId, ifBanned)
								v:Kick("You have been banned from the game.")
							end
						end	
					elseif args[1] == "all" then
						for _, v in pairs(game.Players:GetPlayers()) do
							ifBanned = true
							banStore2:SetAsync(v.UserId, ifBanned)
							v:Kick("You have been banned from the game.")
						end	
					else 
						for _, v in pairs(game.Players:GetPlayers()) do
							if string.sub(v.Name:lower(), 1, #args[1]) == args[1] then
								ifBanned = true
								banStore2:SetAsync(v.UserId, ifBanned)
								v:Kick("You have been banned from the game.")
							end
						end
					end		
				end
				-- unban cmd
				if cmd == "/unban" then
					local playerID = args[1]			
					banStore2:RemoveAsync(playerID)
					banStore:RemoveAsync("UserBan"..playerID)
				end
				-- name cmd
				if cmd == "/name" then
					local name = args[2]
					if args[1] == "me" then
						player.Character.Head.NameTag.name.Text = name
						player.Character.Head.NameTag.Enabled = true
						player.Character.Humanoid.DisplayDistanceType = "None"
					elseif args[1] == "others" then
						for i,v in pairs(game.Players:GetPlayers()) do
							if v.Name ~= player.Name then
								workspace[v.Name].Head.NameTag.name.Text = name
								workspace[v.Name].Head.NameTag.Enabled = true
								workspace[v.Name].Humanoid.DisplayDistanceType = "None"
							end
						end
					elseif args[1] == "all" then
						for i,v in pairs(game.Players:GetChildren()) do
							workspace[v.Name].Head.NameTag.name.Text = name
							workspace[v.Name].Head.NameTag.Enabled = true						
							workspace[v.Name].Humanoid.DisplayDistanceType = "None"							
						end						
					else						
						for _, v in pairs(game.Players:GetPlayers()) do	
							if string.sub(v.Name:lower(), 1, #args[1]) == args[1] then	
								workspace[v.Name].Head.NameTag.name.Text = name
								workspace[v.Name].Head.NameTag.Enabled = true						
								workspace[v.Name].Humanoid.DisplayDistanceType = "None"
							end
						end						
					end					
				end				
				-- give cmd				
				if cmd == "/give" then					
					for _, v in pairs(game.Players:GetPlayers()) do	
						if string.sub(v.Name:lower(), 1, #args[1]) == args[1] then	
							for a, o in pairs(player.Character:GetChildren()) do	
								if o:IsA("Tool") then									
									local clonedGear = o:Clone()
									clonedGear.Parent = game.Players[v.Name].Backpack									
									o:Destroy()									
								end				
							end
						end
					end
				end
				-- help cmd
				if cmd == "/troll" then
					local gui = script.UTG
					gui:Clone().Parent = player.PlayerGui
				end
				-- print cmd
				if cmd == "/print" then
					local printData = args[1]
					print(printData)
				end
				-- sparkles cmd
				if string.sub(message:lower(), 1, 11) == "/sparkle me" then
					local explosion = Instance.new("Sparkles")
					explosion.Parent = player.Character.Head
				elseif string.sub(message:lower(), 1, 15) == "/sparkle others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							local explosion = Instance.new("Sparkles")
							explosion.Parent = v.Character.Head
						end
					end
				elseif string.sub(message:lower(), 1, 12) == "/sparkle all" then
					for _, v in pairs(game.Players:GetPlayers()) do
						local explosion = Instance.new("Sparkles")
						explosion.Parent = v.Character.Head
					end
				elseif string.sub(message:lower(), 1, 8) == "/sparkle" then
					local fiPlayer = string.sub(message:lower(), 10)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							local explosion = Instance.new("Sparkles")
							explosion.Parent = v.Character.Head
						end
					end
				end
				-- unsparkle cmd
				if string.sub(message:lower(), 1, 13) == "/unsparkle me" then
					local sparkles = player.Character.Head:FindFirstChild("Sparkles")
					sparkles:Destroy()
				elseif string.sub(message:lower(), 1, 17) == "/unsparkle others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							local sparkles = v.Character.Head:FindFirstChild("Sparkles")
							sparkles:Destroy()
						end
					end
				elseif string.sub(message:lower(), 1, 14) == "/unsparkle all" then
					for _, v in pairs(game.Players:GetPlayers()) do
						local sparkles = v.Character.Head:FindFirstChild("Sparkles")
						sparkles:Destroy()
					end
				elseif string.sub(message:lower(), 1, 10) == "/unsparkle" then
					local fiPlayer = string.sub(message:lower(), 12)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							local sparkles = v.Character.Head:FindFirstChild("Sparkles")
							sparkles:Destroy()
						end
					end
				end
				-- sit cmd
				if string.sub(message:lower(), 1, 7) == "/sit me" then
					player.Character.Humanoid.Sit = true
				elseif string.sub(message:lower(), 1, 11) == "/sit others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							v.Character.Humanoid.Sit = true
						end
					end
				elseif string.sub(message:lower(), 1, 8) == "/sit all" then
					for _, v in pairs(game.Players:GetPlayers()) do
						v.Character.Humanoid.Sit = true
					end
				elseif string.sub(message:lower(), 1, 4) == "/sit" then
					local fiPlayer = string.sub(message:lower(), 6)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							v.Character.Humanoid.Sit = true
						end
					end
				end
				-- forcefield cmd
				if string.sub(message:lower(), 1, 6) == "/ff me" then
					Instance.new("ForceField", player.Character)
				elseif string.sub(message:lower(), 1, 10) == "/ff others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							Instance.new("ForceField", v.Character)
						end
					end
				elseif string.sub(message:lower(), 1, 7) == "/ff all" then
					for _, v in pairs(game.Players:GetPlayers()) do
						Instance.new("ForceField", v.Character)
					end
				elseif string.sub(message:lower(), 1, 3) == "/ff" then
					local fiPlayer = string.sub(message:lower(), 5)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							Instance.new("ForceField", v.Character)
						end
					end
				end
				-- unff cmd
				if string.sub(message:lower(), 1, 8) == "/unff me" then
					v.Character.ForceField:Destroy()
				elseif string.sub(message:lower(), 1, 12) == "/unff others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							v.Character.ForceField:Destroy()
						end
					end
				elseif string.sub(message:lower(), 1, 9) == "/unff all" then
					for _, v in pairs(game.Players:GetPlayers()) do
						v.Character.ForceField:Destroy()
					end
				elseif string.sub(message:lower(), 1, 5) == "/unff" then
					local fiPlayer = string.sub(message:lower(), 7)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							v.Character.ForceField:Destroy()
						end
					end
				end
				-- run cmd
				if string.sub(message:lower(), 1, 7) == "/run me" then
					v.Character.Humanoid.WalkSpeed = 25
				elseif string.sub(message:lower(), 1, 11) == "/run others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							v.Character.Humanoid.WalkSpeed = 25
						end
					end
				elseif string.sub(message:lower(), 1, 8) == "/run all" then
					for _, v in pairs(game.Players:GetPlayers()) do
						v.Character.Humanoid.WalkSpeed = 25
					end
				elseif string.sub(message:lower(), 1, 4) == "/run" then
					local fiPlayer = string.sub(message:lower(), 6)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							v.Character.Humanoid.WalkSpeed = 25
						end
					end
				end
				-- walk cmd
				if string.sub(message:lower(), 1, 8) == "/walk me" then
					player.Character.Humanoid.WalkSpeed = 16
				elseif string.sub(message:lower(), 1, 12) == "/walk others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							v.Character.Humanoid.WalkSpeed = 16
						end
					end
				elseif string.sub(message:lower(), 1, 9) == "/walk all" then
					for _, v in pairs(game.Players:GetPlayers()) do
						v.Character.Humanoid.WalkSpeed = 16
					end
				elseif string.sub(message:lower(), 1, 5) == "/walk" then
					local fiPlayer = string.sub(message:lower(), 7)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							v.Character.Humanoid.WalkSpeed = 16
						end
					end
				end
				-- freeze cmd
				if string.sub(message:lower(), 1, 10) == "/freeze me" then
					player.Character.Humanoid.WalkSpeed = 0
					player.Character.Humanoid.JumpPower = 0
				elseif string.sub(message:lower(), 1, 14) == "/freeze others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							v.Character.Humanoid.WalkSpeed = 0
							v.Character.Humanoid.JumpPower = 0
						end
					end
				elseif string.sub(message:lower(), 1, 11) == "/freeze all" then
					for _, v in pairs(game.Players:GetPlayers()) do
						v.Character.Humanoid.WalkSpeed = 0
						v.Character.Humanoid.JumpPower = 0
					end
				elseif string.sub(message:lower(), 1, 7) == "/freeze" then
					local fiPlayer = string.sub(message:lower(), 9)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							v.Character.Humanoid.WalkSpeed = 0
							v.Character.Humanoid.JumpPower = 0
						end
					end
				end
				-- jail cmd
				if string.sub(message:lower(), 1, 8) == "/jail me" then
					player.Character.HumanoidRootPart.CFrame = script.jail.Hitbox.CFrame
					script.jail:Clone().Parent = workspace
				elseif string.sub(message:lower(), 1, 12) == "/jail others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							v.Character.HumanoidRootPart.CFrame = script.jail.Hitbox.CFrame
							script.jail:Clone().Parent = workspace
						end
					end
				elseif string.sub(message:lower(), 1, 9) == "/jail all" then
					for _, v in pairs(game.Players:GetPlayers()) do
						v.Character.HumanoidRootPart.CFrame = script.jail.Hitbox.CFrame
						script.jail:Clone().Parent = workspace
					end
				elseif string.sub(message:lower(), 1, 5) == "/jail" then
					local fiPlayer = string.sub(message:lower(), 7)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							v.Character.HumanoidRootPart.CFrame = script.jail.Hitbox.CFrame
							script.jail:Clone().Parent = workspace
						end
					end
				end
				-- unjail cmd
				if string.sub(message:lower(), 1, 10) == "/unjail me" then
					player.Character.Humanoid.Health = 0
					game.Workspace.jail:Destroy()
				elseif string.sub(message:lower(), 1, 14) == "/unjail others" then
					for _, v in pairs(game.Players:GetPlayers()) do
						if v.Name ~= player.Name then
							v.Character.Humanoid.Health = 0
							game.Workspace.jail:Destroy()
						end
					end
				elseif string.sub(message:lower(), 1, 11) == "/unjail all" then
					for _, v in pairs(game.Players:GetPlayers()) do
						v.Character.Humanoid.Health = 0
						game.Workspace.jail:Destroy()
					end
				elseif string.sub(message:lower(), 1, 7) == "/unjail" then
					local fiPlayer = string.sub(message:lower(), 9)
					for _, v in pairs(game.Players:GetPlayers()) do
						if string.sub(v.Name:lower(), 1, #fiPlayer) == fiPlayer then
							v.Character.Humanoid.Health = 0
							game.Workspace.jail:Destroy()
						end
					end
				end
			--end
		end
	end)
end)
