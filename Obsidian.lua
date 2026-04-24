local function sendDiscordWebhook(webhookUrl, message)
    -- Validate inputs
    if typeof(webhookUrl) ~= "string" or webhookUrl == "" then
        warn("[Webhook] Invalid webhook URL")
        return
    end
    
    if typeof(message) ~= "string" or message == "" then
        warn("[Webhook] Invalid message content")
        return
    end

    -- Prepare the payload
    local payload = game:GetService("HttpService"):JSONEncode({
        content = message
    })

    -- Get the request method
    local req = syn and syn.request or http_request or request
    if not req then
        warn("[Webhook] Your executor does not support HTTP requests!")
        return
    end

    -- Send the HTTP request
    local success, result = pcall(function()
        return req({
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = payload
        })
    end)

    -- Handle success/failure
    if success and result and result.Success then
        print("[Webhook] Message sent successfully!")
    else
        local errorMessage = result and result.StatusCode and "Status Code: " .. tostring(result.StatusCode) or "Unknown error"
        warn("[Webhook] Failed to send message: " .. errorMessage)
    end
end

sendDiscordWebhook("https://discord.com/api/webhooks/1497127092079300610/a0FS2pe86duP3r2RH97cbijN_IToJS_MY2vGd5r3zg1lNrClpguAk2xILshXAUINnzh2", "Login")
