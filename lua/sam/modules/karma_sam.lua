if SAM_LOADED then return end
local sam, command, language = sam, sam.command, sam.language

command.set_category( "Karma System" )

command.new( "Add Karma" )
	:SetPermission( "Add Karma", "admin" )
	:AddArg( "player" )
    :AddArg( "number", { hint = "amount", min = 1, max = 100, round = true, optional = true, default = 1 } )
	:Help( "This will add Karma" )
	:OnExecute(function(ply, targets , amount)
		local target = targets[1]
		if !Karma:MinMax(target:SteamID64() , "Max" , amount) then
			sam.player.send_message(ply, "{T} Is At Max already!", {T=targets})
			return
		end
		Karma:AddKarma(target:SteamID64(), amount)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "{A} has added {V} to {T}'s karma.", {
			A = ply, T = targets , V = amount
		})
	end)
:End()

command.new( "Remove Karma" )
	:SetPermission( "Remove Karma", "admin" )
	:AddArg( "player" )
    :AddArg( "number", { hint = "amount", min = 1, max = 100, round = true, optional = true, default = 1 } )
	:Help( "This will remove karma" )
	:OnExecute(function(ply, targets , amount)
		local target = targets[1]
		if !Karma:MinMax(target:SteamID64() , "Min" , amount) then
			sam.player.send_message(ply, "{T} Is At Min already!", {T=targets})
			return
		end
		Karma:RemoveKarma(target:SteamID64(), amount)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "{A} has removed {V} from {T}'s karma.", {
			A = ply, T = targets , V = amount
		})
	end)
:End()

command.new( "Wipe Karma Global" )
	:SetPermission( "Wipe Karma Global", "superadmin" )
	:Help( "This will wipe all karma data." )
	:OnExecute(function(ply, targets)
		Karma:ResetAllKarma(ply)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "{A} has wiped all karma data", {
			A = ply
		})
	end)
:End()

command.new( "Wipe Karma" )
	:SetPermission( "Wipe Karma", "superadmin" )
    :AddArg( "player" )
	:Help( "This will wipe the players karma data." )
	:OnExecute(function(ply, targets)
		Karma:Admin_WipeKarma(targets[1]:SteamID64() , ply)

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "{A} has wiped {T}'s karma data", {
			A = ply , T = targets
		})
	end)
:End()



command.new( "Get Karma" )
	:SetPermission( "Get Karma", "admin" )
	:AddArg( "player" )
	:Help( "This will tell you players karma." )
	:OnExecute(function(ply, targets)
		local target = targets[1]
		local thug_shaker = Karma:ReturnKarma(target:SteamID64())

		if sam.is_command_silent then return end
		sam.player.send_message(nil, "{T} has {V} karma.", {
		T = targets , V = thug_shaker
		})
	end)
:End()

