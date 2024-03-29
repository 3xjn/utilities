if not game:IsLoaded() then
    game.Loaded:Wait()
end

local environment = assert(getgenv, "<util> ~ Your exploit is not supported")()
local request = syn.request or http_request or request or (http and http.request) or (http_request and http_request.request)

environment.util = {
    version = "1.6.7.2",
    author = "3xjn",
    description = "A collection of useful utilities for Roblox.",
    website = "https://github.com/3xjn/utilities"
}

local util = environment.util

local HttpService = game:GetService("HttpService")

if not isfolder("assets") then
    makefolder("assets")
end

local Directory = "assets/utilities"
util.Directory = Directory

if not isfolder(Directory) then
    makefolder(Directory)
end

if not isfile(Directory .. "/emotes.json") then
    writefile(Directory .. "/emotes.json", "[]")
end 

-- We load all the assets from github

local github = "https://raw.githubusercontent.com/3xjn/utilities/main/assets/"
local Icons = {
    hammer = github .. "hammer.png",
    animation = github .. "animation.png",
    emotes = github .. "emotes.png",
    chat = github .. "chat.png",
    speed = github .. "speed.png",
    sleep = github .. "sleep.png",
    block = github .. "block.png",
    log = github .. "log.png",
    userhider = github .. "userhider.png",
    error = github .. "error.png"
}

util.Icons = Icons

-- Convert online assets to useable assets

for k, v in pairs(Icons) do
    if isfile(Directory .. "/" .. k .. ".png") then
        Icons[k] = getcustomasset(Directory .. "/" .. k .. ".png")
        continue
    end

    local req = request({
        Url = v,
        Method = "GET"
    })

    writefile(Directory .. "/" .. k .. ".png", req.Body)
    Icons[k] = getcustomasset(Directory .. "/" .. k .. ".png")
end

local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/3xjn/utilities/main/assets/MercuryFork.lua"))()

local templateSettings = {
    Animation = {},
    Emotes = {},
    ACL = {
        Enabled = true,
        allowEmotes = true,
        regexPatterns = {}
    },
    AntiFling = {
        Enabled = false,
        ignoreFriends = true
    },
    AntiAfk = {
        Enabled = false
    },
    AntiKill = {
        AntiVoid = false,
        AntiTKill = false
    },
    ChatLogger = {
        Enabled = false
    },
    NameHighlight = {
        Enabled = false
    },
    InteractionESP = {
        Colors = {
            ProximityPrompt = {255, 255, 255},
            TouchTransmitter = {255, 255, 255},
            ClickDetector = {255, 255, 255},
            Tool = {255, 255, 255}
        },
        Enabled = {
            ProximityPrompt = true,
            TouchTransmitter = true,
            ClickDetector = true,
            Tool = true
        }
    },
    Speed = 1,
    ToggleKeybind = "Enum.KeyCode.RightAlt"
}

if not isfile(Directory .. "/settings.json") then
    writefile(Directory .. "/settings.json", HttpService:JSONEncode(templateSettings))
end

local Settings = HttpService:JSONDecode(readfile(Directory .. "/settings.json"))

-- check if there are any new settings that need to be added to the saved settings
for k, v in pairs(templateSettings) do
    if not Settings[k] then
        Settings[k] = v
    end
end

function util.saveSettings()
    writefile(Directory .. "/settings.json", HttpService:JSONEncode(Settings))
end

util.saveSettings()

-- Parse Toggle Keybind
local Keybind = Settings.ToggleKeybind:split(".")

if Keybind[1] == "Enum" then
    Settings.ToggleKeybind = Enum[Keybind[2]][Keybind[3]]
end

util.Settings = Settings


util.pluralize = function(number, singular, plural)
    return number == 1 and singular or plural
end

util.UI = Mercury:Create({
    Name = "Utilities",
    Size = UDim2.fromOffset(600, 400),
    Link = util.website,
    Url = "utilities",
    Icon = Icons.hammer,
    HideKeybind = Settings.ToggleKeybind,
    Status = "v" .. util.version
})

function import(file, placeId)
    if placeId and game.PlaceId ~= placeId then return end

    local success, errormessage = pcall(function()
        return loadstring(request({
            Url = "https://raw.githubusercontent.com/3xjn/utilities/main/" .. file,
            Method = "GET"
        }).Body)()
    end)

    if not success then
        util.UI:Notification({
            Title = "Error",
            Text = ("Error importing module '%s' (%s)"):format(file, errormessage),
            Duration = 10,
            Icon = Icons.error
        })
    end
end

task.wait(2)

import("modules/animation.lua")
import("modules/emotes.lua")
import("modules/acl.lua")
import("modules/antiafk.lua")
import("modules/antikill.lua")
import("modules/chatlogger.lua")
import("modules/userhider.lua")