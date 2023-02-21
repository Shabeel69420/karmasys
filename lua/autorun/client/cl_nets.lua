net.Receive( "Karma:ChatPrint", function( len, ply )
    local msg,color = net.ReadString() , net.ReadColor()
    chat.AddText( Color( 45, 0, 255), "[Karma] ", color, msg )
end)

surface.CreateFont( "realthugv2", {
    font = "Arial",
    size = 32,
    weight = 600,
    antialias = true,
    shadow = false
} )

local function lgbtq()
    return HSVToColor((CurTime() * 100) % 360, 1, 1)
end


local function DrawHUD()
    local 🤓 = LocalPlayer()
    if not IsValid(🤓) then return end
    if not 🤓:Alive() then return end
    
    local karma = 🤓:GetNWInt("karma") or 0
    local w, h = ScrW(), ScrH()
    local box_w, box_h = 200, 50
    local x, y = 10, 10
    
    draw.RoundedBox(8, x, y, box_w, box_h, Color(0, 0, 0, 224))
    local color
    if karma < -10 then
        color = Color(255, 0, 0, 232) -- Red
    elseif karma >= -10 and karma <= 25 then
        color = Color(255, 255, 0, 232) -- Yellow
    elseif karma > 25 and karma <= 89 then
        color = Color(0, 255, 0, 232) -- Green
    else
        color = lgbtq()
    end
    draw.SimpleText("Rep: " .. karma, "realthugv2", x + box_w/2, y + box_h/2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end


net.Receive( "SendFirst.💜", function( 💜, __ )
    local 💜💜💜💜 = net.ReadInt( 32 )
    local 🤓 = LocalPlayer()
    --print('El net'..💜💜💜💜)
    LocalPlayer().GotPayload = true
    🤓:SetNWInt( "karma", 💜💜💜💜 )
    hook.Remove( "HUDPaint", "DrawHUD:Lucas" )
    timer.Simple(0 ,  function()
        hook.Add("HUDPaint", "DrawHUD:Lucas", function()
            if LocalPlayer().DontShowKarma then return end
            if !LocalPlayer().GotPayload then return end
            DrawHUD()
        end)  
    end)
end)


hook.Add("OnPlayerChat", "karma:admincmds", function(🤓, 📚)
    if 🤓 ~= LocalPlayer() then return end
    📚📚 = string.lower(📚)
    📚📚📚 = string.Explode(" ", 📚📚)

    if 📚📚📚[1] == '/wipekarma' then
        net.Start("👍")
        net.WriteString(📚📚📚[2])
        net.WriteString('wipe:Solo')
        net.WriteInt(0, 32)
        net.SendToServer()

        return true
    elseif 📚📚📚[1] == '/wipekarma_all' then
        net.Start("👍")
        net.WriteString('RealThug')
        net.WriteString('wipe:Global')
        net.WriteInt(0, 32)
        net.SendToServer()

        return true
    elseif 📚📚📚[1] == '/addkarma' then
        net.Start("👍")
        net.WriteString(📚📚📚[2])
        net.WriteString('add:karma')
        net.WriteInt(📚📚📚[3], 32)
        net.SendToServer()

        return true
    elseif 📚📚📚[1] == '/removekarma' then
        net.Start("👍")
        net.WriteString(📚📚📚[2])
        net.WriteString('remove:karma')
        net.WriteInt(📚📚📚[3], 32)
        net.SendToServer()

        return true
    end
end)