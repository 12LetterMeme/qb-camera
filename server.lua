local QBCore = exports['qb-core']:GetCoreObject()

local WebHook = Config.Webhook

QBCore.Functions.CreateUseableItem("dslrcamera", function(source, item)
    local src = source
    TriggerClientEvent("TLM:USECAMBRO", src)
end)

QBCore.Functions.CreateCallback("TLM:WEBHOOKYO",function(source,cb)
	cb(WebHook)
end)

--[[  For Shared.. obv

["dslrcamera"] 		 	 		 = {["name"] = "dslrcamera", 					["label"] = "PD Camera", 				["weight"] = 1000, 	["type"] = "item", 			["image"] = "camera.png", 				["unique"] = true, 		["useable"] = true, 		["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = "DSLR Camera, with cloud uplink.. cool right?"},

]]

