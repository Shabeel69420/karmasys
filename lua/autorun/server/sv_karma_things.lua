hook.Add("EntityTakeDamage" , "Fale;Thugs" , function(_ , dmg) 
    local a = dmg:GetAttacker()
    if IsValid(a) && a:IsPlayer() && a.DMG_Nerf then
        dmg:ScaleDamage(0.8)
    end
end)

hook.Add("canDropWeapon", "Karma:NoDropy", function(ply, wep)
	if (wep.CantDrop) then return false end
end)

hook.Add("PlayerSpawn", "SetPlayerHealthBasedOnKarma", function(ply)
    local health = 100
    local closestState = Karma:GetState(ply:SteamID64())
    if closestState == nil then return end
    print(closestState)
    local reall = string.lower(closestState)
    if reall and string.match(reall, "good") then
        health = 110
        Karma:SendMessage("You have gotten +10 HP for good karma" , Color(0 , 100 , 25) , ply )
    elseif reall and string.match(reall, "bad") or string.match(reall , "wanted") then
        health = 90
        Karma:SendMessage("You have lost -10 HP for bad karma" , Color(205 , 255 , 0) , ply )
    end
    
    timer.Simple(0.1, function()
    ply:SetHealth(health)
    end)
end)
