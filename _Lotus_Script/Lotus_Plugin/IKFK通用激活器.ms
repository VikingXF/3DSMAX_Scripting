try( deleteModifier $ $.modifiers[EmptyModifier])catch()
addmodifier $ (EmptyModifier ()) ui:on
	
rigTools = attributes rigT
(
	parameters NewRollout rollout: rigT
	(
		bt01 type:#node animatable:true
		bt02 type:#node animatable:true
		bt03 type:#node animatable:true
		bt04 type:#node animatable:true
		bt05 type:#node animatable:true
		bt06 type:#node animatable:true
		bt07 type:#node animatable:true
		bt08 type:#node animatable:true
		bt09 type:#node animatable:true
		bt10 type:#node animatable:true
	)	
	
	rollout rigT ""  
	(	
		button activation ">>>>>>_¼¤»î_<<<<<<" pos:[10,205] width:140 height:50 
		
		on activation pressed do with undo on
		(
			for i = 1 to 10 do
			(
				try
				(
					temp = selection[1]
					num = i as string
					if i < 10 do (num = "0" + num)
					execute ("select temp.'Attribute_Holder'.rigT.bt" + num)
					max modify mode
					try
					(
						findCTS = windows.getchildhwnd #max ">>>>>>_start_<<<<<<" 
						uiaccessor.pressbutton findCTS[1]
					)catch()
					try
					(
						findCTS = windows.getchildhwnd #max ">>>>>>_¼¤»î_<<<<<<" 
						uiaccessor.pressbutton findCTS[1]
					)catch()
					select temp
					
				)catch()
			)
			try((LayerManager.getLayerFromName "hide").ishidden = on)catch()
		)	
	)
)

custAttributes.add $.modifiers[#Attribute_Holder] rigTools #Unique

			try($.'Attribute_Holder'.rigT.bt01 = $IKFKChange_Hand_R)catch()
			try($.'Attribute_Holder'.rigT.bt02 = $IKFKChange_Hand_L)catch()
			try($.'Attribute_Holder'.rigT.bt03 = $IKFKChange_Foot_R)catch()
			try($.'Attribute_Holder'.rigT.bt04 = $IKFKChange_Foot_L)catch()
			try($.'Attribute_Holder'.rigT.bt05 = $F_IKFKChange_Foot_L)catch()
			try($.'Attribute_Holder'.rigT.bt06 = $F_IKFKChange_Foot_R)catch()
			try($.'Attribute_Holder'.rigT.bt07 = $B_IKFKChange_Foot_L)catch()
			try($.'Attribute_Holder'.rigT.bt08 = $B_IKFKChange_Foot_R)catch()



