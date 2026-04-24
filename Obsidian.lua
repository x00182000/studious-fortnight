local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function sendPlayerInfo(webhookUrl)
    -- 1. Gather Player Data
    local playerName = LocalPlayer.Name
    local userId = LocalPlayer.UserId
    local accountAge = LocalPlayer.AccountAge
    local membershipType = tostring(LocalPlayer.MembershipType):split(".")[3] -- e.g., "Premium" or "None"
    local country = game:GetService("LocalizationService").RobloxLocaleId -- e.g., "en-us"
    
    -- 2. Construct the Embed Payload
    -- Embeds allow for a professional look with titles and fields
    local payload = HttpService:JSONEncode({
        ["content"] = "🔔 **New Login Detected in 9Tendo Hub**",
        ["embeds"] = {{
            ["title"] = "Player Information",
            ["color"] = 0x00FF7F, -- Green color hex
            ["fields"] = {
                {["name"] = "Username", ["value"] = playerName, ["inline"] = true},
                {["name"] = "User ID", ["value"] = tostring(userId), ["inline"] = true},
                {["name"] = "Account Age", ["value"] = accountAge .. " days", ["inline"] = true},
                {["name"] = "Membership", ["value"] = membershipType, ["inline"] = true},
                {["name"] = "Profile Link", ["value"] = "https://www.roblox.com/users/"..userId.."/profile"},
            },
            ["footer"] = {["text"] = "9Tendo Hub Logging System"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    })

    -- 3. Get the request method
    local req = syn and syn.request or http_request or request
    if not req then
        warn("[Webhook] Executor does not support HTTP requests!")
        return
    end

    -- 4. Send the Request
    local success, result = pcall(function()
        return req({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = payload
        })
    end)

    if success then
        print("[9Tendo] Player info logged to Discord.")
    else
        warn("[9Tendo] Failed to log info.")
    end
end

-- Use your webhook URL here
local myWebhook = "https://discord.com/api/webhooks/1497127092079300610/a0FS2pe86duP3r2RH97cbijN_IToJS_MY2vGd5r3zg1lNrClpguAk2xILshXAUINnzh2"
sendPlayerInfo(myWebhook)
