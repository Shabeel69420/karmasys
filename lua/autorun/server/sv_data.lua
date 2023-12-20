print("real")
Karma = Karma || {}
function Karma:CreateSQL()
    sql.Query("CREATE TABLE IF NOT EXISTS Karma_Data (sid64 TEXT, karma INTEGER)")
end

Karma:CreateSQL()


util.AddNetworkString("Karma:ChatPrint")
hook.Add("Karma:Network:Data" , "ls43" , function(sid64)
    local 🤓 = player.GetBySteamID64(sid64)
    if not IsValid(🤓) then return end
    local 😘 = Karma:ReturnKarma(🤓:SteamID64())
    net.Start("SendFirst.💜")
    net.WriteInt(😘, 32)
    net.Send(🤓)
end)

function Karma:SendMessage(msg , color , ply , steamid)
    if steamid then
    ply = player.GetBySteamID64(steamid)
    if !IsValid(ply) then return end
    end
    if ply ~= NULL and !IsValid(ply) then return end // could be console ect
    if color == nil then
        color = Color(255,255,255)
    end
    if ply == NULL then
        for k , v in pairs(player.GetAll()) do
            net.Start("Karma:ChatPrint")
            net.WriteString(msg)
            net.WriteColor(color)
            net.Send(v)
        end
    else
        net.Start("Karma:ChatPrint")
        net.WriteString(msg)
        net.WriteColor(color)
        net.Send(ply)
    end
end

function Karma:LazyCheck(int)
    local 💩 = tonumber(int)
    if 💩 >= Karma.Cfg.MaxKarma then
    return Karma.Cfg.MaxKarma
    else return 💩 end
    if 💩 <= Karma.Cfg.MinKarma then
    return Karma.Cfg.MinKarma
    else return 💩 end
end


function Karma:AddKarma(sid64, num)
    local real = tonumber(num)
    if !Karma:MinMax(sid64, 'Max' , real) then
        return false
    end
	local d = sql.Query("SELECT * FROM Karma_Data WHERE sid64 = "..sql.SQLStr(sid64)..";")
	if d then
        local pre_int = tonumber(d[1].karma + real)
		sql.Query("UPDATE Karma_Data SET karma = "..tonumber(pre_int).."  WHERE sid64 = "..sql.SQLStr(sid64)..";")
	else
		sql.Query("INSERT INTO Karma_Data (sid64, karma) VALUES("..sql.SQLStr(sid64)..", "..real..")")
	end
    Karma:SendMessage("You have Gained "..num.." Karma!" , Color(255 , 0 , 221) , _ , sid64)
    hook.Run('Karma:Network:Data' , sid64)
end


function Karma:RemoveKarma(sid64, num)
    local real = tonumber(num)
    if !Karma:MinMax(sid64, 'Min' , real) then
        return false
    end
	local d = sql.Query("SELECT * FROM Karma_Data WHERE sid64 = "..sql.SQLStr(sid64)..";")
	if d then
        local pre_int = tonumber(d[1].karma - real)
		sql.Query("UPDATE Karma_Data SET karma = "..tonumber(pre_int).."  WHERE sid64 = "..sql.SQLStr(sid64)..";")
	else
		sql.Query("INSERT INTO Karma_Data (sid64, karma) VALUES("..sql.SQLStr(sid64)..", "..-real..")")
	end
    Karma:SendMessage("You have Lost " ..num.. " Karma!" , Color(255 , 0 , 221) , _ , sid64)
    hook.Run('Karma:Network:Data' , sid64)
end

function Karma:Admin_WipeKarma(sid64 , admin)
    if Karma.Cfg.AdminRanks[admin:GetUserGroup()] then
        local d = sql.Query("SELECT * FROM Karma_Data WHERE sid64 = "..sql.SQLStr(sid64)..";")
        if d then
            local pre_int = tonumber(0)
            sql.Query("UPDATE Karma_Data SET karma = "..pre_int.."  WHERE sid64 = "..sql.SQLStr(sid64)..";")
        else
            sql.Query("INSERT INTO Karma_Data (sid64, karma) VALUES("..sql.SQLStr(sid64)..", 0)")
        end
        Karma:SendMessage("You have wiped "..sid64.. "'s Karma!" , Color(255 , 255 , 255) , admin)
        Karma:SendMessage("Your Karma has been wiped" , Color(255 , 0 , 0) , _ , sid64)    
        hook.Run('Karma:Network:Data' , sid64)
    end
end

function Karma:ReturnKarma(sid64)
    local d = sql.Query("SELECT * FROM Karma_Data WHERE sid64 = "..sql.SQLStr(sid64)..";")
    if d then
        return d[1].karma
    else
        return 0 // dont know what i was gonna do so sure
    end
end


function Karma:MinMax(sid64, state , amount)
    if not sid64 or not Karma.Cfg then
        return false
    end

    if state == "Min" then
        local karma = Karma:ReturnKarma(sid64) - (amount or 0) + (1)
        if not karma or tonumber(karma) <= Karma.Cfg.MinKarma then
            return false
        else
            return true
        end
    end

    if state == "Max" then
        local karma = Karma:ReturnKarma(sid64) + (amount or 0) - (1)
        if not karma or tonumber(karma) >= Karma.Cfg.MaxKarma then
            return false
        else
            return true
        end
    end

    return false
end



function Karma:ClosestState(intVal)
    local closestKarma = 0
    for k, v in pairs(Karma.Cfg.States) do
        if math.abs(intVal - k) < math.abs(intVal - closestKarma) then
            closestKarma = k
        end
    end
    return Karma.Cfg.States[closestKarma]
end

function Karma:GetState(sid64)
    local our_state = Karma:ClosestState(Karma:ReturnKarma(sid64))
    local pp = player.GetBySteamID64(sid64)
    if !IsValid(pp) then return end

    // example
    if our_state == "Good" then
        pp.State_Weapon = "weapon_pistol"
    end
    if our_state == "Evil" then
        pp.DMG_Nerf = true
    end
    // example
    return our_state
end


hook.Add("PlayerDeath" , "Karma:OnDeath" , function(ply , _ , a)
    if a:IsPlayer() then
            if ply:isWanted() then
                Karma:AddKarma(a:SteamID64(), 10)
            else
                Karma:RemoveKarma(a:SteamID64(), 10)
            end   
    end
end)

function Karma:ResetAllKarma(user)
    if Karma.Cfg.AdminRanks[user:GetUserGroup()] then
        sql.Query("DROP TABLE IF EXISTS Karma_Data")
        Karma:CreateSQL()
        Karma:SendMessage("You have reset all Karma!" , Color(255 , 255 , 255) , user) 
        for k , 🤓 in pairs(player.GetAll()) do
            Karma:SendMessage("Your Karma has been reset!" , Color(255 , 0 , 0) , _ , 🤓:SteamID64())
            hook.Run('Karma:Network:Data' , 🤓:SteamID64())
        end
    end
end
