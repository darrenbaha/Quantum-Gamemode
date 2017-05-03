 
local meta = FindMetaTable("Player") 

/*

Currency functions

*/
function meta:AddCor(amount)
        local current_cor = self:GetCor()
		self:SetCor( current_cor + amount)
end

function meta:GetCor()
return self:GetNetworkedInt("Cor")
end

function meta:SetCor(amount)
    self:SetNetworkedInt( "Cor", amount)
    --Save function
end

function meta:RemoveCor(amount)
        local current_cor = self:GetCor()
		self:AddCor(-amount)
end

/*

EXP functions

*/

function meta:AddEXP(exp)
        local current_exp = self:GetEXP()
		self:SetEXP( current_exp + exp)
end

function meta:GetEXP()
return self:GetNetworkedInt("EXP")
end

function meta:SetEXP(exp)
    self:SetNetworkedInt( "EXP", exp)
    --Save function
end

function meta:RemoveEXP(exp)
        local current_exp = self:GetEXP()
		self:AddEXP(-exp)
end

/*

Level functions

*/

function meta:GetLevel()
return self:GetNetworkedInt("Level")
end

function meta:SetLevel(level)
    self:SetNetworkedInt( "Level", level)
    --Save function
end

function meta:AddLevel(level)
        local current_level = self:GetLevel()
		self:SetLevel( current_level + level)
end
//Can we under level..?
function meta:RemoveLevel(level)
        local current_cor = self:GetCor()
		self:AddLevel(-level)
end

/*

Mana functions

*/

function meta:GetMana()
return self:GetNetworkedInt("Mana")
end

function meta:SetMana(mana)
    self:SetNetworkedInt( "Mana", mana)
end

function meta:AddMana(mana)
        local current_mana = self:GetMana()
		self:SetMana( current_mana + mana )

end

function meta:RemoveMana(mana)
         local current_mana = self:GetMana()
		self:AddMana(-mana)
end

/*

Stamina

*/

function meta:GetStamina()
return self:GetNetworkedInt("Stamina", 0)
end


