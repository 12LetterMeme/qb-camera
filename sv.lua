local QBCore = exports['qb-core']:GetCoreObject()

local WebHook = Config.Webhook

QBCore.Functions.CreateUseableItem("dslrcamera", function(source, item)
    local src = source
    TriggerClientEvent("TLM:USECAMBRO", src)
end)

QBCore.Functions.CreateCallback("TLM:WEBHOOKYO",function(source,cb)
	cb(WebHook)
end)
