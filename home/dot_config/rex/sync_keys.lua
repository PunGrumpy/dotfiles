-- The keys live sync listens to. They are physical keys, so every keyboard layout
-- is covered, Thai included. The text comes with the key event.

local M = {}

local TEXT = [[Backquote Digit1 Digit2 Digit3 Digit4 Digit5 Digit6 Digit7 Digit8 Digit9 Digit0 Minus Equal
KeyQ KeyW KeyE KeyR KeyT KeyY KeyU KeyI KeyO KeyP BracketLeft BracketRight Backslash
KeyA KeyS KeyD KeyF KeyG KeyH KeyJ KeyK KeyL Semicolon Quote
KeyZ KeyX KeyC KeyV KeyB KeyN KeyM Comma Period Slash Space]]
local CHARS = [[` 1 2 3 4 5 6 7 8 9 0 - = q w e r t y u i o p [ ] \ a s d f g h j k l ; ' z x c v b n m , . / space]]
local NAMED = "enter tab backspace delete escape left right up down home end pageup pagedown"
local MODS = { "", "shift+", "ctrl+", "alt+", "ctrl+shift+", "alt+shift+", "ctrl+alt+" }

-- Rex's own tab shortcuts, which a binding would hide.
local REX = { ["ctrl+tab"] = true, ["ctrl+shift+tab"] = true, ["ctrl+shift+pageup"] = true, ["ctrl+shift+pagedown"] = true }

local function words(text)
  local list = {}
  for word in text:gmatch("%S+") do list[#list + 1] = word end
  return list
end

--- Calls bind(key) for every key. `taken` holds keys that keep their own binding,
-- such as pane navigation, in Rex's spelling.
function M.each(taken, bind)
  local function add(mods, name, key)
    local plain = mods .. name
    if not taken[plain] and not taken[mods .. key] and not REX[plain] then bind(mods .. key) end
  end
  local codes, chars = words(TEXT), words(CHARS)
  for _, mods in ipairs(MODS) do
    for i, code in ipairs(codes) do add(mods, chars[i], "[" .. code .. "]") end
    for _, name in ipairs(words(NAMED)) do add(mods, name, name) end
    for i = 1, 12 do add(mods, "f" .. i, "f" .. i) end
  end
end

return M
