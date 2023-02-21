local 💩 = util.AddNetworkString
💩("SendFirst.💜")

hook.Add("PlayerSpawn" , "💜" , function(🤓)
    timer.Simple(1, function()
        local 😘 = Karma:ReturnKarma(🤓:SteamID64())
        net.Start("SendFirst.💜")
        net.WriteInt(😘, 32)
        net.Send(🤓)
    end)
end)


hook.Add("PlayerInitialSpawn" , "💜" , function(🤓)
    timer.Simple(1, function()
        local 😘 = Karma:ReturnKarma(🤓:SteamID64())
        net.Start("SendFirst.💜")
        net.WriteInt(😘, 32)
        net.Send(🤓)
    end)
end)