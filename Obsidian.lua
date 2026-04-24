local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function sendDetailedPlayerInfo(webhookUrl)
    local playerName = LocalPlayer.Name
    local userId = LocalPlayer.UserId
    
    local successInfo, gameInfo = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    local gameName = successInfo and gameInfo.Name or "Unknown Game"
    local placeId = game.PlaceId
    local jobId = game.JobId
    
    local joinLink = string.format("roblox://experiences/start?placeId=%d&gameInstanceId=%s", placeId, jobId)

    local payload = HttpService:JSONEncode({
        ["username"] = "9Tendo Logging",
        ["content"] = "🚀 **9Tendo Hub: Session Started**",
        ["embeds"] = {{
            ["title"] = "Session Report",
            ["color"] = 0x3498db,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = string.format("[%s](https://www.roblox.com/users/%d/profile)", playerName, userId), ["inline"] = true},
                {["name"] = "🎂 Account Age", ["value"] = LocalPlayer.AccountAge .. " days", ["inline"] = true},
                {["name"] = "🎮 Game", ["value"] = gameName, ["inline"] = false},
                {["name"] = "📍 Place ID", ["value"] = tostring(placeId), ["inline"] = true},
                {["name"] = "🔗 Join Server (Click to Hop)", ["value"] = "[Direct Join Link](" .. joinLink .. ")", ["inline"] = false},
                {["name"] = "📝 Job ID", ["value"] = "```" .. jobId .. "```", ["inline"] = false},
            },
            ["footer"] = {["text"] = "9Tendo Hub v1.0"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    })

    -- 4. Send Request
    local req = syn and syn.request or http_request or request
    if req then
        pcall(function()
            req({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })
        end)
    end
end

local myWebhook = "https://discord.com/api/webhooks/1497127092079300610/a0FS2pe86duP3r2RH97cbijN_IToJS_MY2vGd5r3zg1lNrClpguAk2xILshXAUINnzh2"
sendDetailedPlayerInfo(myWebhook)
