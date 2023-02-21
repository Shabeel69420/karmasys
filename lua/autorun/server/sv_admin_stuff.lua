local 😆 = util.AddNetworkString

😆("👍")

net.Receive("👍", function(ii , 🤓)
    local targ,goal = net.ReadString(),net.ReadString()
    if goal == 'wipe:Solo' then
        if Karma.Cfg.AdminRanks[🤓:GetUserGroup()] then
            Karma:Admin_WipeKarma(targ , 🤓)
        end
    end
    if goal == 'wipe:Global' then
        if Karma.Cfg.AdminRanks[🤓:GetUserGroup()] then
            Karma:ResetAllKarma(🤓)
        end
    end
    if goal == 'add:karma' then
        if Karma.Cfg.AdminRanks[🤓:GetUserGroup()] then
            Karma:AddKarma(targ, net.ReadInt(32))
        end
    end
    if goal == 'remove:karma' then
        if Karma.Cfg.AdminRanks[🤓:GetUserGroup()] then
            Karma:RemoveKarma(targ, net.ReadInt(32))
        end
    end
end)
