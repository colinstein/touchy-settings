TOUCHYSETTINGS = {}

SLASH_TOUCHYSETTINGS1, SLASH_TOUCHYSETTINGS = '/ts', '/touchysettings';

function SlashCmdList.TOUCHYSETTINGS(msg, editbox)
   TouchySettingsFrame:Show();
end

function TOUCHYSETTINGS.TooltipEnter(widget)
   local title = widget:GetAttribute('tooltip_title');
   local description = widget:GetAttribute('tooltip_description');
   if (title and description) then
      GameTooltip:SetOwner(widget, "ANCHOR_CURSOR");
      GameTooltip:SetText(title);
      GameTooltip:AddLine(description, 1, 1, 1);
      GameTooltip:Show();
   end
end

function TOUCHYSETTINGS.TooltipLeave(widget)
   GameTooltip:Hide();
end

function TOUCHYSETTINGS.CloseButton_Click()
   TouchySettingsFrame:Hide();
end

function TOUCHYSETTINGS.Checkutton_OnClick(checkButton)
   local enabled = checkButton:GetChecked();
   local cvar = checkButton:GetAttribute('cvar_name');
   local value;
   if (enabled) then
      value = checkButton:GetAttribute('cvar_checked');
   else
      value = checkButton:GetAttribute('cvar_unchecked');
   end
   SetCVar(cvar, value);
end

function TOUCHYSETTINGS.Checkbutton_OnLoad(checkButton)
   _G[checkButton:GetName() .. "Text"]:SetText(checkButton:GetText());
   local cvarName = checkButton:GetAttribute('cvar_name');
   local cvarValue = GetCVar(cvarName);
   local checkedValue = checkButton:GetAttribute('cvar_checked');
   if (cvarValue == checkedValue) then
      checkButton:SetChecked(true);
   end
end

function TOUCHYSETTINGS.ResetActionBarsButton_Click()
   -- There are 120 action bar slots
   for i = 1, 120 do
      PickupAction(i);
      ClearCursor();
   end
end

function TOUCHYSETTINGS.ResetKeyBindingsButton_Click()
   local function unbindKey(c, ...)
      for i = 1, select("#", ...) do
         SetBinding(select(i, ...), nil);
      end
   end
   for i = 1, GetNumBindings() do
      unbindKey(GetBinding(i));
   end
   SaveBindings(GetCurrentBindingSet());
end

function TOUCHYSETTINGS.ResetMacrosButton_Click()
   for i = MAX_ACCOUNT_MACROS + MAX_CHARACTER_MACROS, 1, -1 do
      if GetMacroInfo(i) then
         DeleteMacro(i);
      end
   end
end

function TOUCHYSETTINGS.Menubutton_OnLoad(menuButton)
   UIDropDownMenu_Initialize(menuButton, function() 
      local menuItemCount = menuButton:GetAttribute("menu_item_count");
      
      -- add a title
      local menuTitle = UIDropDownMenu_CreateInfo();
      menuTitle.text = menuButton:GetText();
      menuTitle.isTitle = true;
      menuTitle.notCheckable = true;
      UIDropDownMenu_AddButton(menuTitle);
      
      -- and then all the buttons
      for i = 1, menuItemCount do
         local menuItem = UIDropDownMenu_CreateInfo();
         menuItem.text = menuButton:GetAttribute(string.format("menu_title_%d",i));
         menuItem.value = menuButton:GetAttribute(string.format("menu_value_%d",i));
         menuItem.func = TOUCHYSETTINGS.Menubutton_OnSelect;
         UIDropDownMenu_AddButton(menuItem);
         if menuItem.value == value then
            
         end
      end
      local cvar = menuButton:GetAttribute("cvar_name");
      local value = GetCVar(cvar);
      UIDropDownMenu_SetSelectedValue(menuButton, value);
   end);
end

function TOUCHYSETTINGS.Menubutton_OnSelect(self, arg1, arg2, checked)
   local cvar = UIDROPDOWNMENU_OPEN_MENU:GetAttribute('cvar_name');
   local value = self.value;
   if (not checked) then
      UIDropDownMenu_SetSelectedValue(UIDROPDOWNMENU_OPEN_MENU, value);
      SetCVar(cvar, value);
   end
end

function TOUCHYSETTINGS.Slider_OnLoad(slider)
   local cvarName = slider:GetAttribute('cvar_name');
   local cvarValue = GetCVar(cvarName) or 0;
   slider:SetValue(cvarValue);
   TOUCHYSETTINGS.Slider_InitLabels(slider);
   TOUCHYSETTINGS.Slider_SetText(slider);
end

function TOUCHYSETTINGS.Slider_InitLabels(slider)
   local minValue, maxValue = slider:GetMinMaxValues();
   _G[slider:GetName() .. 'Low']:SetText(minValue);
   _G[slider:GetName() .. 'High']:SetText(maxValue);
   TOUCHYSETTINGS.Slider_SetText(slider);
end

function TOUCHYSETTINGS.Slider_SetText(slider)
   local label = slider:GetAttribute('label') or '';
   local value = slider:GetValue();
   if value then
      label = label .. ": " .. value;
   end
   _G[slider:GetName() .. 'Text']:SetText(label);
end

function TOUCHYSETTINGS.Slider_OnValueChanged(slider)
   local name = slider:GetAttribute('cvar_name');
   local value  = slider:GetValue() or 0;
   value = math.floor(value);
   SetCVar(name, value);
end

function TOUCHYSETTINGS.Slider_SpellEffectValueChanged(slider)
   local value  = slider:GetValue() or 1;
   value = math.floor(value);
   ConsoleExec("spellEffectLevel " .. value);
end
