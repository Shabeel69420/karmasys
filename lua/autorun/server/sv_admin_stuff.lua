util.AddNetworkString("receiveData")

net.Receive("receiveData", function(len, player)
    local target, goal = net.ReadString(), net.ReadString()
    if goal == 'wipe:Solo' then
        if Karma.Cfg.AdminRanks[player:GetUserGroup()] then
            Karma:Admin_WipeKarma(target, player)
        end
    end
    if goal == 'wipe:Global' then
        if Karma.Cfg.AdminRanks[player:GetUserGroup()] then
            Karma:ResetAllKarma(player)
        end
    end
    if goal == 'add:karma' then
        if Karma.Cfg.AdminRanks[player:GetUserGroup()] then
            Karma:AddKarma(target, net.ReadInt(32))
        end
    end
    if goal == 'remove:karma' then
        if Karma.Cfg.AdminRanks[player:GetUserGroup()] then
            Karma:RemoveKarma(target, net.ReadInt(32))
        end
    end
end)
