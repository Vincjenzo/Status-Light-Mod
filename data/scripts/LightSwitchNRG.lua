-- LightSwitchNRG.lua

local Time 	= Game.Time;
local Delay	= 3; -- game seconds
local Ready	= Time();
local Initialized = false;
local TriggerValue = nil;

-- the red and green sprite images don't line up with the normal/status light sprite images.
-- these values change the position when spawning a new light so that it lines up correctly.
local lightOffsetX = 0.017;
local lightOffsetY = 0.035;

function LoadInterface()
	if (this.FalseMode == nil) then
		this.FalseMode = "Off"
	end
	
	if (this.TrueMode == nil) then
		this.TrueMode = "On"
	end
	
	if (Initialized == true) then
		Interface.RemoveComponent(this, "changeGroup", "Button", "Operate Group:")
		Interface.RemoveComponent(this, "changeGroup1", "Button", "1")
		Interface.RemoveComponent(this, "changeGroup2", "Button", "2")
		Interface.RemoveComponent(this, "changeGroup3", "Button", "3")
		Interface.RemoveComponent(this, "changeGroup4", "Button", "4")
		Interface.RemoveComponent(this, "changeGroup5", "Button", "5")
		Interface.RemoveComponent(this, "changeGroup6", "Button", "6")
		
		Interface.RemoveComponent(this, "FalseMode", "Caption", "False Mode:")
		Interface.RemoveComponent(this, "FalseModeOn", "Button", "ON")
		Interface.RemoveComponent(this, "FalseModeOff", "Button", "OFF")
		Interface.RemoveComponent(this, "FalseModeGreen", "Button", "GREEN")
		Interface.RemoveComponent(this, "FalseModeRed", "Button", "RED")
		
		Interface.RemoveComponent(this, "TrueMode", "Caption", "True Mode:")
		Interface.RemoveComponent(this, "TrueModeOn", "Button", "ON")
		Interface.RemoveComponent(this, "TrueModeOff", "Button", "OFF")
		Interface.RemoveComponent(this, "TrueModeGreen", "Button", "GREEN")
		Interface.RemoveComponent(this, "TrueModeRed", "Button", "RED")
	end
	
	Interface.AddComponent(this, "changeGroup", "Caption", "Operate Group:")
	Interface.AddComponent(this, "changeGroup1", "Button", "1")
	Interface.AddComponent(this, "changeGroup2", "Button", "2")
	Interface.AddComponent(this, "changeGroup3", "Button", "3")
	Interface.AddComponent(this, "changeGroup4", "Button", "4")
	Interface.AddComponent(this, "changeGroup5", "Button", "5")
	Interface.AddComponent(this, "changeGroup6", "Button", "6")
	if (this.Group ~= nil) then
		Interface.SetCaption(this,"changeGroup" .. this.Group, this.Group .. " - Active")
	end
	Interface.AddComponent(this, "FalseMode", "Caption", "False Mode:")
	Interface.AddComponent(this, "FalseModeOn", "Button", "ON")
	Interface.AddComponent(this, "FalseModeOff", "Button", "OFF")
	Interface.AddComponent(this, "FalseModeGreen", "Button", "GREEN")
	Interface.AddComponent(this, "FalseModeRed", "Button", "RED")
	Interface.SetCaption(this,"FalseMode" .. this.FalseMode, string.upper(this.FalseMode) .. " - Active")
	
	Interface.AddComponent(this, "TrueMode", "Caption", "True Mode:")
	Interface.AddComponent(this, "TrueModeOn", "Button", "ON")
	Interface.AddComponent(this, "TrueModeOff", "Button", "OFF")
	Interface.AddComponent(this, "TrueModeGreen", "Button", "GREEN")
	Interface.AddComponent(this, "TrueModeRed", "Button", "RED")
	Interface.SetCaption(this,"TrueMode" .. this.TrueMode, string.upper(this.TrueMode) .. " - Active")
end

function Update()
	if Time() > Ready then
        PerformUpdate( Delay )
        Ready = Ready + Delay
    end
end

function PerformUpdate( elapsedTime )
	if (Initialized == false) then
		LoadInterface()
		Initialized = true
	end
	
	TriggerLights()
end

function TriggerLights()
	--[[
	Game.DebugOut("Input : " .. this.Triggered)
	Game.DebugOut("FalseMode : " .. this.FalseMode)
	Game.DebugOut("FalseModeActive : " .. tostring(this.FalseModeActive))
	Game.DebugOut("TrueMode : " .. this.TrueMode)
	Game.DebugOut("TrueModeActive : " .. tostring(this.TrueModeActive))
	--]]
	if (TriggerValue ~= this.Triggered and this.Group ~= nil) then
		TriggerValue = tonumber(this.Triggered)
		
		-- update lights to false status
		if (this.Triggered == 0) then
			this.TrueModeActive = false
			
			local lights = this.GetNearbyObjects( "StatusLightNRG" .. this.Group, 1000 )
			if (next(lights)) then
				
				for obj, dist in pairs( lights ) do
					
					if (this.FalseMode == "Off" and this.FalseModeActive ~= "Off") then 
						deleteLights(obj)
					end
					
					if (this.FalseMode == "On" and this.FalseModeActive ~= "On") then 
						deleteLights(obj)
						createNormalLight(obj)
					end
					
					if (this.FalseMode == "Green" and this.FalseModeActive ~= "Green") 	then 
						deleteLights(obj)
						createGreenLight(obj)
					end
					
					if (this.FalseMode == "Red" and this.FalseModeActive ~= "Red") then 
						deleteLights(obj)
						createRedLight(obj)
					end
				end
			end
			
			this.FalseModeActive = this.FalseMode
		
		-- update lights to true status
		else
			this.FalseModeActive = false
			
			local lights = this.GetNearbyObjects( "StatusLightNRG" .. this.Group, 1000 )
			if (next(lights)) then
				for obj, dist in pairs( lights ) do

					if (this.TrueMode == "Off" and this.TrueModeActive ~= "Off") then 
						deleteLights(obj)
					end

					if (this.TrueMode == "On" and this.TrueModeActive ~= "On") then 
						deleteLights(obj)
						createNormalLight(obj)
					end

					if (this.TrueMode == "Green" and this.TrueModeActive ~= "Green") then 
						deleteLights(obj)
						createGreenLight(obj)
					end

					if (this.TrueMode == "Red" and this.TrueModeActive ~= "Red") then 
						deleteLights(obj)
						createRedLight(obj)
					end

				end
			end

			this.TrueModeActive = this.TrueMode

		end
	end
end

-- Options should be 1-6
function changeGroup(number)	this.Group = number end

-- Options should be Off, On, Red, Green
function changeFalseMode(str)	this.FalseMode = str end
function changeTrueMode(str)	this.TrueMode = str end

function changeGroup1Clicked() changeGroup(1); LoadInterface(); end
function changeGroup2Clicked() changeGroup(2); LoadInterface(); end
function changeGroup3Clicked() changeGroup(3); LoadInterface(); end
function changeGroup4Clicked() changeGroup(4); LoadInterface(); end
function changeGroup5Clicked() changeGroup(5); LoadInterface(); end
function changeGroup6Clicked() changeGroup(6); LoadInterface(); end

function FalseModeOnClicked()		changeFalseMode("On");		LoadInterface(); end
function FalseModeOffClicked()		changeFalseMode("Off");		LoadInterface(); end
function FalseModeGreenClicked()	changeFalseMode("Green");	LoadInterface(); end
function FalseModeRedClicked()		changeFalseMode("Red");		LoadInterface(); end

function TrueModeOnClicked()		changeTrueMode("On");		LoadInterface(); end
function TrueModeOffClicked()		changeTrueMode("Off");		LoadInterface(); end
function TrueModeGreenClicked()		changeTrueMode("Green");	LoadInterface(); end
function TrueModeRedClicked()		changeTrueMode("Red");		LoadInterface(); end

function createNormalLight(obj)
	--Game.DebugOut("CREATING a NORMAL light")
	Object.Spawn("Light", obj.Pos.x, obj.Pos.y)
end

function createGreenLight(obj)
	--Game.DebugOut("CREATING a GREEN light")
	Object.Spawn("LightGreen", obj.Pos.x - lightOffsetX, obj.Pos.y + lightOffsetY)
end

function createRedLight(obj)
	--Game.DebugOut("CREATING a RED light")
	Object.Spawn("LightRed", obj.Pos.x - lightOffsetX, obj.Pos.y + lightOffsetY)
end

function deleteLights(obj)
	--Game.DebugOut("DELETING the helper lights!")
	local deleted = obj.GetNearbyObjects("Light", 1)
	if (next(deleted)) then
		for del,dist in pairs(deleted) do
			 -- make sure to only remove a light at same position
			if (obj.Pos.x == del.Pos.x and obj.Pos.y == del.Pos.y) then
				del.Delete()
				
				-- solve problem of objects remaining in memory..
				-- these are in the form of {objectname}i{light.Id.i}u{light.Id.u}
				-- example: Lighti12u12345678
				_G["Lighti" .. del.Id.i .. "u" .. del.Id.u] = nil
			end
		end
	end
	
	deleted = obj.GetNearbyObjects("LightGreen", 1)
	if (next(deleted)) then
		for del,dist in pairs(deleted) do
			--[[Game.DebugOut("X")
			Game.DebugOut('ObjectX ' .. obj.Pos.x) --75.5
			Game.DebugOut('DeleteX ' .. del.Pos.x) --75.482498
			Game.DebugOut('lightOffsetX ' .. lightOffsetX) --0.0175
			Game.DebugOut('Result ' .. obj.Pos.x - lightOffsetX) --75.4825
			Game.DebugOut( (obj.Pos.x - lightOffsetX) == del.Pos.x)
			Game.DebugOut("Y")
			Game.DebugOut( (obj.Pos.y + lightOffsetY) == del.Pos.y)
			Game.DebugOut(del.Pos.y)
			--if (obj.Pos.x == del.Pos.x and obj.Pos.y == del.Pos.y) then
			-- there is some weird rounding error or something, so added math.floor to fix it.
			-- left the above debug statements and original code in for future reference.
			]]--
			if (math.floor(obj.Pos.x - lightOffsetX) == math.floor(del.Pos.x) and math.floor(obj.Pos.y + lightOffsetY) == math.floor(del.Pos.y)) then
				del.Delete()
				_G["LightGreeni" .. del.Id.i .. "u" .. del.Id.u] = nil
			end
		end
	end
	
	deleted = obj.GetNearbyObjects("LightRed", 1)
	if (next(deleted)) then
		for del,dist in pairs(deleted) do
			if (math.floor(obj.Pos.x - lightOffsetX) == math.floor(del.Pos.x) and math.floor(obj.Pos.y + lightOffsetY) == math.floor(del.Pos.y)) then
				del.Delete()
				_G["LightRedi" .. del.Id.i .. "u" .. del.Id.u] = nil
			end
		end
	end
end