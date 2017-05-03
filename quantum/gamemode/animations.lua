
/*
Casting spells
Hold type : Fist
*/
//Casting on
RegisterLuaAnimation('cp_melee_hold', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Finger1'] = {
				},
				['ValveBiped.Bip01_L_Finger21'] = {
				},
				['ValveBiped.Bip01_L_Finger11'] = {
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Finger01'] = {
				},
				['ValveBiped.Bip01_L_Finger2'] = {
				},
				['ValveBiped.Bip01_L_Finger0'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Finger1'] = {
					RU = 80
				},
				['ValveBiped.Bip01_L_Finger21'] = {
					RU = 80
				},
				['ValveBiped.Bip01_L_Finger11'] = {
					RU = 64
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 43.46,
					RF = 29.818
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -64,
					RR = -16
				},
				['ValveBiped.Bip01_L_Finger01'] = {
					RU = 32
				},
				['ValveBiped.Bip01_L_Finger2'] = {
					RU = 80
				},
				['ValveBiped.Bip01_L_Finger0'] = {
					RU = -64
				}
			},
			FrameRate = 5
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Finger1'] = {
					RU = 80
				},
				['ValveBiped.Bip01_L_Finger21'] = {
					RU = 80
				},
				['ValveBiped.Bip01_L_Finger11'] = {
					RU = 64
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 43.46,
					RF = 29.818
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -64,
					RR = -16
				},
				['ValveBiped.Bip01_L_Finger2'] = {
					RU = 80
				},
				['ValveBiped.Bip01_L_Finger01'] = {
					RU = 32
				},
				['ValveBiped.Bip01_L_Finger0'] = {
					RU = -64
				}
			},
			FrameRate = 5
		}
	},
	RestartFrame = 3,
	Type = TYPE_STANCE
})
//Casting off
RegisterLuaAnimation('cp_melee_release', {
	FrameData = {
		{
			BoneInfo = {
			},
			FrameRate = 1
		}
	},
	Type = TYPE_GESTURE
})
/*
Casting spells
Hold type : Melee
*/