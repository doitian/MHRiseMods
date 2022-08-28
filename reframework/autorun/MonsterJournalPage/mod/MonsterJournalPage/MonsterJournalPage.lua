--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
-- Lua Library inline imports
local __TS__Symbol, Symbol
do
    local symbolMetatable = {__tostring = function(self)
        return ("Symbol(" .. (self.description or "")) .. ")"
    end}
    function __TS__Symbol(description)
        return setmetatable({description = description}, symbolMetatable)
    end
    Symbol = {
        iterator = __TS__Symbol("Symbol.iterator"),
        hasInstance = __TS__Symbol("Symbol.hasInstance"),
        species = __TS__Symbol("Symbol.species"),
        toStringTag = __TS__Symbol("Symbol.toStringTag")
    }
end

local __TS__Iterator
do
    local function iteratorGeneratorStep(self)
        local co = self.____coroutine
        local status, value = coroutine.resume(co)
        if not status then
            error(value, 0)
        end
        if coroutine.status(co) == "dead" then
            return
        end
        return true, value
    end
    local function iteratorIteratorStep(self)
        local result = self:next()
        if result.done then
            return
        end
        return true, result.value
    end
    local function iteratorStringStep(self, index)
        index = index + 1
        if index > #self then
            return
        end
        return index, string.sub(self, index, index)
    end
    function __TS__Iterator(iterable)
        if type(iterable) == "string" then
            return iteratorStringStep, iterable, 0
        elseif iterable.____coroutine ~= nil then
            return iteratorGeneratorStep, iterable
        elseif iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            return iteratorIteratorStep, iterator
        else
            return ipairs(iterable)
        end
    end
end

-- End of Lua Library inline imports
local ____exports = {}
local ____IL2CPP = require("MonsterJournalPage.IL2CPP.IL2CPP")
local snow = ____IL2CPP.snow
local System = ____IL2CPP.System
local via = ____IL2CPP.via
local ____utilities = require("MonsterJournalPage.mod.MonsterJournalPage.Utils.utilities")
local getObject = ____utilities.getObject
local il_iter = ____utilities.il_iter
local function check_select_tab_pressed(self)
    return snow.gui.StmGuiInput:andTrg(
        snow.StmInputManager.UI_INPUT.STATIC_MENU_ACT_TYPE_CL,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        false,
        false
    )
end
local function check_square_pressed(self)
    return snow.gui.StmGuiInput:andTrg(
        snow.StmInputManager.UI_INPUT.CONF_MENU_ACT_TYPE_RL,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        false,
        false
    )
end
local function get_current_target_monsters(self)
    local current_quest = snow.QuestManager.Instance:getActiveQuestData()
    if not current_quest then
        return {}
    end
    local data = current_quest:get_RawNormal()
    if data then
        local ret = {}
        if data._TargetType:Get(0) == snow.quest.QuestTargetType.AllMainEnemy then
            do
                local i = 0
                while i < data._BossEmType:get_Count() do
                    local em = data._BossEmType:Get(i)
                    if em ~= 0 then
                        ret[#ret + 1] = data._BossEmType:Get(i)
                    end
                    i = i + 1
                end
            end
            return ret
        end
        do
            local i = 0
            while i < data._TgtEmType:get_Count() do
                local em = data._TgtEmType:Get(i)
                if em ~= 0 then
                    ret[#ret + 1] = data._TgtEmType:Get(i)
                end
                i = i + 1
            end
        end
        return ret
    end
    local mystery = current_quest:get_RandomMystery()
    if mystery then
        local ret = {}
        do
            local i = 0
            while i < mystery._HuntTargetNum do
                ret[#ret + 1] = mystery._BossEmType:Get(i)
                i = i + 1
            end
        end
        return ret
    end
    return {}
end
local function get_max_group(self, mon_list)
    local monster_info = mon_list:getCurrentMonsterInfo()
    local meat_data = snow.gui.GuiManager.Instance.monsterListParam._MeatInfoDictionary:get_Item(monster_info._Data._EmType)
    local max_group = 1
    for ____, obj in __TS__Iterator(il_iter(nil, meat_data._MeatContainer)) do
        max_group = math.max(
            obj._MeatGroupInfo:get_Count(),
            max_group
        )
    end
    return max_group
end
local current_idx = 0
sdk.hook(
    snow.gui.GuiMonsterList.start,
    function(args)
        current_idx = 0
    end
)
sdk.hook(
    snow.gui.GuiMonsterList.update,
    function(args)
        local mon_list = sdk.to_managed_object(args[2])
        if check_select_tab_pressed(nil) then
            local mons = get_current_target_monsters(nil)
            if #mons > 0 then
                local mon_to_show = mons[current_idx % #mons + 1]
                current_idx = current_idx + 1
                do
                    local i = 0
                    while i < mon_list._MonsterList.mSize do
                        if mon_list._MonsterList:get_Item(i)._Data._EmType == mon_to_show then
                            local selected_index = mon_list._MonsterListScrollCtrl:get_selectedIndex()
                            selected_index._HasValue = true
                            selected_index._Value = i
                            mon_list._MonsterListScrollCtrl:set_selectedIndex(selected_index)
                            snow.gui.SnowGuiCommonUtility:reqSe(4105602971)
                            mon_list:updateTopTab()
                            mon_list._MonsterListScrollCtrl:selectedIndexToCursorSelect()
                            mon_list:setupMainPage(false, true)
                            mon_list:updateMainPage(true)
                            return
                        end
                        i = i + 1
                    end
                end
            end
        end
    end
)
do
    local ____self
    sdk.hook(
        snow.gui.GuiMonsterList.updateKeyAssign,
        function(args)
            ____self = sdk.to_managed_object(args[2])
        end,
        function()
            local assignList = snow.gui.GuiManager.Instance:get_refGuiCommonKeyAssign()._KeyAssignList
            local text = getObject(
                nil,
                assignList:get_Items()[0],
                "txt_assign",
                via.gui.Text:T()
            )
            local assign_text = text:get_Message()
            if ____self:getMainPageMode() == snow.gui.GuiMonsterList.PageMode.Part and get_max_group(nil, ____self) > 1 then
                assign_text = "<STM CONF_MENU_ACT_TYPE_RL> Swap State " .. assign_text
            end
            if #get_current_target_monsters(nil) > 0 then
                assign_text = "<STM STATIC_MENU_ACT_TYPE_CL> Quest Monster " .. assign_text
            end
            text:set_Message(assign_text)
        end
    )
end
local swap_counter = 0
sdk.hook(
    snow.gui.GuiMonsterList.updateEmMonsterInput,
    function(args)
        local ____self = sdk.to_managed_object(args[2])
        if ____self:getMainPageMode() ~= snow.gui.GuiMonsterList.PageMode.Part then
            return
        end
        if check_square_pressed(nil) then
            swap_counter = swap_counter + 1
            local monster_info = ____self:getCurrentMonsterInfo()
            ____self:updateEmMonsterPartsPage(monster_info, false)
        end
    end
)
do
    local text_names = {
        "txt_slash_number",
        "txt_shock_number",
        "txt_shot_number",
        "txt_fire_number",
        "txt_water_number",
        "txt_ice_number",
        "txt_thunder_number",
        "txt_dragon_number"
    }
    local message_id
    local ____self
    local last_monster = -1
    sdk.hook(
        snow.gui.GuiMonsterList.updateEmMonsterPartsPage,
        function(args)
            ____self = sdk.to_managed_object(args[2])
            local monster_info = ____self:getCurrentMonsterInfo()
            local id = monster_info._Data._EmType
            if id ~= last_monster then
                swap_counter = 0
                last_monster = id
            end
        end,
        function()
            local monster_info = ____self:getCurrentMonsterInfo()
            local meat_data = snow.gui.GuiManager.Instance.monsterListParam._MeatInfoDictionary:get_Item(monster_info._Data._EmType)
            local max_group = get_max_group(nil, ____self)
            local current_group = swap_counter % max_group
            local normal_text = getObject(
                nil,
                ____self.guiController:get_Component(),
                "pnl_MonsterList_top/pnl_MonsterList/pnl_MonsterName/txt_nomal",
                via.gui.Text:T()
            )
            if message_id == nil then
                message_id = normal_text:get_MessageId()
            end
            if current_group == 0 then
                normal_text:set_MessageId(message_id)
            else
                normal_text:set_MessageId(System.Guid.Empty)
                normal_text:set_Message("State " .. tostring(current_group))
            end
            local part_data = monster_info._Data._PartTableData
            local scroll_index = ____self._MonsterPartListlCtrl._Cursor:get_scrollIndex()
            local part_list = ____self._MonsterPartListlCtrl._scrL_List:get_Items()
            do
                local i = 0
                while i < part_list:get_Count() - 1 do
                    local current_part = part_data:get_Item(i + scroll_index)
                    local current_meat = meat_data._MeatContainer:get_Item(current_part._EmPart)
                    do
                        local j = 0
                        while j < #text_names do
                            local text_name = text_names[j + 1]
                            local gui_text = getObject(
                                nil,
                                part_list:get_Item(i),
                                text_name,
                                via.gui.Text:T()
                            )
                            if current_group >= current_meat._MeatGroupInfo:get_Count() then
                                gui_text:set_Message(" X ")
                            else
                                local value = meat_data:getMeatValue(current_part._EmPart, current_group, j)
                                local str = sdk.create_managed_string(tostring(value)):add_ref()
                                gui_text:set_Message(str)
                            end
                            j = j + 1
                        end
                    end
                    i = i + 1
                end
            end
        end
    )
end
return ____exports
