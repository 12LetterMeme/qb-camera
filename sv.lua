local QBCore = exports['qb-core']:GetCoreObject()

local WebHook = Config.Webhook

QBCore.Functions.CreateUseableItem("dslrcamera", function(source, item)
    local src = source
    TriggerClientEvent("tlm:client:vehiclecheck", src)
end)

QBCore.Functions.CreateCallback("tlm:server:WebHookCheck",function(source, cb)
	cb(WebHook)
end)
