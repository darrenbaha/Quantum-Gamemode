
//Format ["Armor name"] = {"type", value, damage defense, magic defense, wear, weight, model}
Armor = {}


//Weapons

 //Format ["weapon name"] = { "holdtype", worth, damage, wear, weight, model. description}}
WeaponTable = {}
WeaponTable["weapon_fists"] = {"fists", 0, 0, 0, 0, "", "You shouldn't see this..."}
WeaponTable["weapon_crowbar"] = {"meele1", 100, 25, "", 3, "", "A crowbar wielded by Gordan Freeman"}

//Usables

Use = {}

//ETC's
Etc = {}

Items = {}

Items["weapon_crowbar"] = {"weapon", "melee1", 0, 10, "", "A crowbar wielded by Gordan Freeman"}


concommand.Add("quantum_generate_item", function(sender, command, args)
        if (not IsValid(sender)) or (not sender:IsConnected()) then return end
		local itemName = args[1] or ""
		if 
 
end)


function UseItem()

end

function EquipItem()


end

function DropItem()

end
