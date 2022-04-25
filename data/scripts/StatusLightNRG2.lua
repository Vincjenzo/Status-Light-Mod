local Initialized = false;

function Create()
	Interface.AddComponent(this,"changeGroup1", "Button", "Group 1")
	Interface.AddComponent(this,"changeGroup2", "Caption", "Group 2 - Active")
	Interface.AddComponent(this,"changeGroup3", "Button", "Group 3")
	Interface.AddComponent(this,"changeGroup4", "Button", "Group 4")
	Interface.AddComponent(this,"changeGroup5", "Button", "Group 5")
	Interface.AddComponent(this,"changeGroup6", "Button", "Group 6")
end
function Update()
	if (Initialized == false) then
		Create();
		Initialized = true
	end
end
function changeGroup1Clicked()
	changeGroup(1);
end

function changeGroup2Clicked()
	--changeGroup(2);
end
function changeGroup3Clicked()
	changeGroup(3);
end
function changeGroup4Clicked()
	changeGroup(4);
end
function changeGroup5Clicked()
	changeGroup(5);
end
function changeGroup6Clicked()
	changeGroup(6);
end
function changeGroup(number)
	Object.Delete();
	Object.Spawn("StatusLightNRG" .. number, this.Pos.x, this.Pos.y)
end