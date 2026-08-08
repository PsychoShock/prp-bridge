local appearance = {}
local isOpen = false

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
        exports["illenium-appearance"]:setPlayerAppearance(decoded)
        return
    end
    exports["illenium-appearance"]:setPedAppearance(ped, decoded)
end

---@param ped? number
---@return table?
function appearance.getPedAppearance(ped)
    ped = ped or PlayerPedId()
    return exports["illenium-appearance"]:getPedAppearance(ped)
end

local function getClothingConfig(isPedMenu)
    return {
        ped = isPedMenu and true or false,
        headBlend = isPedMenu and true or false,
        faceFeatures = isPedMenu and true or false,
        headOverlays = isPedMenu and true or false,
        components = true,
        componentConfig = {
            masks = true,
            upperBody = true,
            lowerBody = true,
            bags = true,
            shoes = true,
            scarfAndChains = true,
            bodyArmor = true,
            shirts = true,
            decals = true,
            jackets = true,
        },
        props = true,
        propConfig = {
            hats = true,
            glasses = true,
            ear = true,
            watches = true,
            bracelets = true,
        },
        tattoos = isPedMenu and true or false,
        enableExit = true,
        hasTracker = false,
        automaticFade = false,
    }
end

---@param isNew? boolean
---@param onClose? fun(appearance: table|nil)
function appearance.openCreator(isNew, onClose)
    if isNew then
        TriggerEvent("qb-clothes:client:CreateFirstCharacter")
        return
    end

    if isOpen then
        if onClose then
            onClose(nil)
        end
        return
    end

    isOpen = true

    exports["illenium-appearance"]:startPlayerCustomization(function(result)
        isOpen = false

        if result then
            TriggerServerEvent("illenium-appearance:server:saveAppearance", result)
        end

        if onClose then
            onClose(result)
        end
    end, getClothingConfig(false))
end

return appearance
