local appearance = {}

local function decodeAppearance(data)
    if type(data) == "string" then
        return json.decode(data)
    end
    return data
end

---@param ped number
---@param data table|string
function appearance.setPedAppearance(ped, data)
    local decoded = decodeAppearance(data)
    if not decoded then return end
    if ped == PlayerPedId() and decoded.model then
        exports["fivem-appearance"]:setPlayerAppearance(decoded)
        return
    end
    exports["fivem-appearance"]:setPedAppearance(ped, decoded)
end

---@param ped? number
---@return table?
function appearance.getPedAppearance(ped)
    ped = ped or PlayerPedId()
    return exports["fivem-appearance"]:getPedAppearance(ped)
end

---@param isNew? boolean
---@param onClose? fun(appearance: table|nil)
function appearance.openCreator(isNew, onClose)
    local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
        allowExit = not isNew,
        tattoos = true,
    }

    exports["fivem-appearance"]:startPlayerCustomization(function(result)
        if result then
            TriggerServerEvent("prp-bridge:appearance:save", result)
        end

        if onClose then
            onClose(result)
        end
    end, config)
end

return appearance
