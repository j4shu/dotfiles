-- https://github.com/Hammerspoon/hammerspoon/pull/582
-- defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

-- application switcher
for key, name in pairs({
	["1"] = "Google Chrome",
	["2"] = "Ghostty",
	["3"] = "Notes",
	-- ["3"] = "Visual Studio Code",
	-- ["e"] = "Claude"
}) do
	hs.hotkey.bind("alt", key, function()
		hs.application.launchOrFocus(name)
	end)
end
