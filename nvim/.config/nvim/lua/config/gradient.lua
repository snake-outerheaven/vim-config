-- Gradiente entre duas cores #rrggbb (usado no cabecalho do dashboard).
local M = {}

local function rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

function M.steps(from, to, n)
    local out = {}
    local r1, g1, b1 = rgb(from)
    local r2, g2, b2 = rgb(to)
    for i = 0, n - 1 do
        local t = n == 1 and 0 or i / (n - 1)
        out[#out + 1] = string.format("#%02x%02x%02x",
            math.floor(r1 + (r2 - r1) * t + 0.5),
            math.floor(g1 + (g2 - g1) * t + 0.5),
            math.floor(b1 + (b2 - b1) * t + 0.5))
    end
    return out
end

return M
