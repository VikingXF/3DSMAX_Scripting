--#######/ rig_IK_FK2.0 /##################
fn Lotus_rig_HandIKFK2_ =
(	
	fn Lotus_pointTransfromLC baseOBJ toOBJ =
	(
		Pos_Constraint_ = Position_Constraint()
		baseOBJ[3][1].controller = Pos_Constraint_
		Pos_Constraint_.constraints.appendtarget toOBJ 100
		Ori_Constraint_ = Orientation_Constraint()
		baseOBJ[3][2].controller = Ori_Constraint_
		Ori_Constraint_.constraints.appendtarget toOBJ 100
		paramWire.connect toOBJ.transform.controller[#Scale] baseOBJ.transform.controller[#Scale] "Scale"
	)
	
	animationRange = interval 0 animationRange.end 
	sliderTime = 0f
	the_LRLR = "L"
	thSc = 1
	theBaseBoneArray = (selection as array)
	try ( if theBaseBoneArray[1].pos.x < 0 then ( the_LRLR = "R" )else( the_LRLR = "L" ))catch()
	lcToHideArray = #()
	HandNameArray = #("Hand","Upperarm","Forearm","Hand")
	NOSelArray = #()

	if theBaseBoneArray.count == 3 do
	(
		--冻结骨骼
		for i = 1 to theBaseBoneArray.count do( Lotus_FreezeTransform theBaseBoneArray[i] )
		
		--基础骨骼认命
		baseBone001 = theBaseBoneArray[1]
		baseBone002 = theBaseBoneArray[2]
		baseBone003 = theBaseBoneArray[3]
		baseBone000 = baseBone001.parent ;Lotus_FreezeTransform baseBone000
		alphaBone = baseBone000.parent ;Lotus_FreezeTransform alphaBone
		
		--计算骨骼控制器比例
		thSc = (distance baseBone001 baseBone003)/50
		
		--最大虚拟点建立
		theIKFKLC = Plane_Angle pos:[0,0,0] isSelected:on distance:(17*thSc) size:(0.2*thSc)
		theIKFKLC.name = "IKFKLC_" + HandNameArray[1] + the_LRLR  ;append lcToHideArray theIKFKLC
		theIKFKLC.pos = baseBone001.pos
		theIKFKLC.wirecolor = color 0 0 0
		theIKFKLC.parent = alphaBone
		Lotus_FreezeTransform theIKFKLC
		paramWire.connect theIKFKLC.transform.controller[#Scale] baseBone001.transform.controller[#Scale] "Scale"
		
		--引导锁骨与大臂链接
		baseBone000[3][2][3].controller = LookAt_Constraint ()
		baseBone000[3][2][3].controller.appendTarget theIKFKLC 100
		baseBone000[3][2][3].controller.lookat_vector_length = 0
		baseBone000[3][2][3].controller.upnode_world = off
		baseBone000[3][2][3].controller.pickUpNode = theIKFKLC
		baseBone000[3][2][3].controller.RELATIVE = on

		--IK骨骼搭建
		maxOps.cloneNodes theBaseBoneArray cloneType:#copy newNodes:&theIKboneArray
		for i = 1 to theIKboneArray.count do ( theIKboneArray[i].wirecolor = color 176 26 26 ; theIKboneArray[i].boxmode = on ; theIKboneArray[i].width = 0; theIKboneArray[i].height = 0)
		ikBone001 = theIKboneArray[1]
			ikBone001.parent = theIKFKLC
			ikBone001.name = HandNameArray[2] + "_IK_" + the_LRLR  ;append lcToHideArray ikBone001 ;append NOSelArray ikBone001 
		ikBone002 = theIKboneArray[2]
			ikBone002.name = HandNameArray[3] + "_IK_"  + the_LRLR  ;append lcToHideArray ikBone002 ;append NOSelArray ikBone002
		ikBone003 = theIKboneArray[3]
			ikBone003.name = HandNameArray[4] + "_IK_"  + the_LRLR  ;append lcToHideArray ikBone003 ;append NOSelArray ikBone003
		for i = 1 to theIKboneArray.count do( Lotus_FreezeTransform theIKboneArray[i] )
		
		--IK骨骼附属骨骼搭建
		maxOps.cloneNodes theBaseBoneArray cloneType:#copy newNodes:&theIKboneArray2
		for i = 1 to theIKboneArray2.count do ( theIKboneArray2[i].wirecolor = color 176 26 26 ; theIKboneArray2[i].boxmode = on ; theIKboneArray2[i].width = 0; theIKboneArray2[i].height = 0)
		ikBone001_1 = theIKboneArray2[1]
			ikBone001_1.parent = ikBone001
			ikBone001_1.name = HandNameArray[2] + "_IK2_11_" + the_LRLR  ;append lcToHideArray ikBone001_1 ;append NOSelArray ikBone001_1
		ikBone001_1ed = theIKboneArray2[2]
			ikBone001_1ed.name = HandNameArray[2] + "_IK2_1ed_"  + the_LRLR  ;append lcToHideArray ikBone001_1ed ;append NOSelArray ikBone001_1ed
		ikBone003_1 = theIKboneArray2[3]
		try( delete theIKboneArray2[5] ;delete theIKboneArray2[4] )catch()
		try( delete ikBone003_1 )catch()
		
		Lotus_FreezeTransform ikBone001_1
		Lotus_FreezeTransform ikBone001_1ed	
		Pos_Constraint_ = Position_Constraint()
		ikBone001_1ed[3][1][3].controller = Pos_Constraint_
		Pos_Constraint_.constraints.appendtarget ikBone002 100
		Ori_Constraint_ = Orientation_Constraint()
		ikBone001_1ed[3][2][3].controller = Ori_Constraint_
		Ori_Constraint_.constraints.appendtarget ikBone002 100
		
		maxOps.cloneNodes theBaseBoneArray cloneType:#copy newNodes:&theIKboneArray3
		for i = 1 to theIKboneArray3.count do ( theIKboneArray3[i].wirecolor = color 176 26 26 ; theIKboneArray3[i].boxmode = on ; theIKboneArray3[i].width = 0; theIKboneArray3[i].height = 0)
		ikBone001_2 = theIKboneArray3[1]
		ikBone002_2 = theIKboneArray3[2]
			ikBone002_2.name = HandNameArray[3] + "_IK2_21_"  + the_LRLR  ;append lcToHideArray ikBone002_2 ;append NOSelArray ikBone002_2
		ikBone002_2ed = theIKboneArray3[3]
			ikBone002_2ed.name = HandNameArray[3] + "_IK2_2ed_"  + the_LRLR  ;append lcToHideArray ikBone002_2ed ;append NOSelArray ikBone002_2ed
		try( delete theIKboneArray3[5] ;delete theIKboneArray3[4] )catch()
		try( delete ikBone001_2 )catch()
		ikBone002_2.parent = ikBone002
		Lotus_FreezeTransform ikBone002_2
		Lotus_FreezeTransform ikBone002_2ed	
		Pos_Constraint_ = Position_Constraint()
		ikBone002_2ed[3][1][3].controller = Pos_Constraint_
		Pos_Constraint_.constraints.appendtarget ikBone003 100
		Ori_Constraint_ = Orientation_Constraint()
		ikBone002_2ed[3][2][3].controller = Ori_Constraint_
		Ori_Constraint_.constraints.appendtarget ikBone003 100
		
		--FK骨骼搭建
		maxOps.cloneNodes theBaseBoneArray cloneType:#copy newNodes:&theFKboneArray
		for i = 1 to theIKboneArray.count do 
		(
			theFKboneArray[i].wirecolor = color 198 225 87
			theFKboneArray[i].width = 0
			theFKboneArray[i].height = 0
		)
		fkBone001 = theFKboneArray[1]
			fkBone001.parent = theIKFKLC
			fkBone001.name = HandNameArray[2] + "_FK_" + the_LRLR  ;append lcToHideArray fkBone001 ;append NOSelArray fkBone001
		fkBone002 = theFKboneArray[2]
			fkBone002.name = HandNameArray[3] + "_FK_"  + the_LRLR  ;append lcToHideArray fkBone002 ;append NOSelArray fkBone002
		fkBone003 = theFKboneArray[3]
			fkBone003.name = HandNameArray[4] + "_FK_"  + the_LRLR  ;append lcToHideArray fkBone003 ;append NOSelArray fkBone003
		for i = 1 to theFKboneArray.count do( Lotus_FreezeTransform theFKboneArray[i] )

		--IK制作
		theIKChain001 = IKSys.ikChain ikBone001 ikBone003 "IKHISolver"
		theIKChain001.name = "IK_" + HandNameArray[1] + "_001_" + the_LRLR  ;append lcToHideArray theIKChain001 ;append NOSelArray theIKChain001
		Lotus_RotatePivotOnly theIKChain001 fkBone003
			--IK极向量
		theIKChain001_VHTarget = Star radius1:(2*thSc) radius2:(4*thSc) fillet1:0 fillet2:0 numPoints:6 distort:0 isSelected:on
		theIKChain001_VHTarget.transform = ikBone002.transform
		theIKChain001_VHTarget.wirecolor = color 87 225 87
		Lotus_RotatePivotOnly theIKChain001_VHTarget fkBone002
		Lotus_FreezeTransform theIKChain001_VHTarget
		theIKChain001_VHTarget.name = "IK_" + HandNameArray[1] + "_VHT_" + the_LRLR  ;append lcToHideArray theIKChain001_VHTarget 
		theIKChain001.transform.controller.VHTarget = theIKChain001_VHTarget
		theIKChain001.transform.controller.SAParent = 0
			--IK大圈
		ikBaseCircle = Circle radius:(10*thSc) isSelected:on
		ikBaseCircle.name = "IKBase_"+ HandNameArray[1] +"_" + the_LRLR  ;append lcToHideArray ikBaseCircle
		ikBaseCircle.transform = fkBone003.transform
		ikBaseCircle.wirecolor = color 87 225 87
		in coordsys local rotate ikBaseCircle (EulerAngles 0 90 0)
		Lotus_RotatePivotOnly ikBaseCircle fkBone003
		theIKChain001.parent = ikBaseCircle
		theIKChain001_VHTarget.parent = theIKFKLC
		Lotus_FreezeTransform theIKChain001
		Lotus_FreezeTransform ikBaseCircle
		Lotus_FreezeTransform theIKChain001_VHTarget
		
		--制作IK拉伸效果 --第二代
		ctrl = float_script()  
		ikBone002[3][4][1][2][1].controller = ctrl
		ctrl.AddNode "IKExp" theIKFKLC
		ctrl.AddNode "ikbone001" ikBone001
		ctrl.AddNode "ikbone002" ikBone002
		ctrl.AddNode "ikfklc" theIKFKLC
		ctrl.AddNode "ik_001" theIKChain001
		ctrl.setExpression ("tempNum = (ikBone001.length + ikBone002.length)*ikBone001.scale.x
val = 2*ikBone001.scale.x
(((distance ikfklc ik_001) - tempNum )/val)")
		
		ikBone002[3][4][1][2][1].controller = float_limit ()
		ikBone002[3][4][1][2][1].controller.upper_limit = ( Distance theIKFKLC theIKChain001 ) / 2.5
		ikBone002[3][4][1][2][1].controller.lower_limit = 0
		ikBone003[3][4][1][2][1].controller = ikBone002[3][4][1][2][1].controller
		
		--制作FK骨骼的曲线控制器
		fkCircle1 = Rectangle length:(11*thSc) width:(11*thSc) cornerRadius:0 isSelected:on
		fkCircle1.name = "fkCir001_"+ HandNameArray[2] +"_" + the_LRLR  
		fkCircle1.transform = fkBone001.transform
		in coordsys local rotate fkCircle1 (EulerAngles 0 90 0)
		Lotus_RotatePivotOnly fkCircle1 fkBone001
		fkCircle1.wirecolor = color 87 225 87
		Lotus_pointTransfromLC fkBone001 fkCircle1
		append lcToHideArray fkCircle1 
			fkCircle2 = Rectangle length:(11*thSc) width:(11*thSc) cornerRadius:0 isSelected:on
			fkCircle2.name = "fkCir002_"+ HandNameArray[3] +"_" + the_LRLR  
			fkCircle2.transform = fkBone002.transform
			in coordsys local rotate fkCircle2 (EulerAngles 0 90 0)
			Lotus_RotatePivotOnly fkCircle2 fkBone002
			fkCircle2.wirecolor = color 87 225 87
			Lotus_pointTransfromLC fkBone002 fkCircle2
			append lcToHideArray fkCircle2
				fkCircle3 = Rectangle length:(11*thSc) width:(11*thSc) cornerRadius:0 isSelected:on
				fkCircle3.name = "fkCir003_"+ HandNameArray[4] +"_" + the_LRLR  
				fkCircle3.transform = fkBone003.transform
				in coordsys local rotate fkCircle3 (EulerAngles 0 90 0)
				Lotus_RotatePivotOnly fkCircle3 fkBone003
				fkCircle3.wirecolor = color 87 225 87
				Lotus_pointTransfromLC fkBone003 fkCircle3
				append lcToHideArray fkCircle3 
		fkCircle3.parent = fkCircle2 
		fkCircle2.parent = fkCircle1 
		fkCircle1.parent = theIKFKLC
		Lotus_FreezeTransform fkCircle3
		Lotus_FreezeTransform fkCircle2
		Lotus_FreezeTransform fkCircle1
		
		--制作FK拉伸效果
		fkBone001[3][2].controller = LookAt_Constraint ()
		fkBone001[3][2].controller.appendTarget fkCircle2 100
		fkBone001[3][2].controller.lookat_vector_length = 0
		fkBone001[3][2].controller.upnode_world = off
		fkBone001[3][2].controller.pickUpNode = fkCircle1
		fkBone002[3][2].controller = LookAt_Constraint ()
		fkBone002[3][2].controller.appendTarget fkCircle3 100
		fkBone002[3][2].controller.lookat_vector_length = 0
		fkBone002[3][2].controller.upnode_world = off
		fkBone002[3][2].controller.pickUpNode = fkCircle2
		
		--制作IKFK过渡
		Pos_Constraint_ = Position_Constraint()
		baseBone001[3][1][3].controller = Pos_Constraint_
		Pos_Constraint_.constraints.appendtarget ikBone001_1 100
		Pos_Constraint_.constraints.appendtarget fkBone001 0
		Ori_Constraint_ = Orientation_Constraint()
		baseBone001[3][2][3].controller = Ori_Constraint_
		Ori_Constraint_.constraints.appendtarget ikBone001_1 100
		Ori_Constraint_.constraints.appendtarget fkBone001 0
			Pos_Constraint_ = Position_Constraint()
			baseBone002[3][1][3].controller = Pos_Constraint_
			Pos_Constraint_.constraints.appendtarget ikBone002_2 100
			Pos_Constraint_.constraints.appendtarget fkBone002 0
			Ori_Constraint_ = Orientation_Constraint()
			baseBone002[3][2][3].controller = Ori_Constraint_
			Ori_Constraint_.constraints.appendtarget ikBone002_2 100
			Ori_Constraint_.constraints.appendtarget fkBone002 0
				Pos_Constraint_ = Position_Constraint()
				baseBone003[3][1][3].controller = Pos_Constraint_
				Pos_Constraint_.constraints.appendtarget ikBone002_2ed 100
				Pos_Constraint_.constraints.appendtarget fkBone003 0
				Ori_Constraint_ = Orientation_Constraint()
				baseBone003[3][2][3].controller = Ori_Constraint_
				Ori_Constraint_.constraints.appendtarget ikBone002_2ed 100
				Ori_Constraint_.constraints.appendtarget fkBone003 0
		
		--制作IKFK转换器
		IKFK_Change = text size:(7*thSc) kerning:0 leading:0 isSelected:on text:"手" font:"@黑体"
		IKFK_Change.transform = ikBaseCircle.transform
		IKFK_Change.pos.z += 5*thSc
		IKFK_Change.parent = baseBone003       
		IKFK_Change.name = "IKFKChange_" + HandNameArray[1] + "_" + the_LRLR  ;append lcToHideArray IKFK_Change
		IKFK_Change.wirecolor = color 87 225 87
		Lotus_FreezeTransform IKFK_Change 

		try( deleteModifier IKFK_Change IKFK_Change.modifiers[EmptyModifier])catch()
		addmodifier IKFK_Change (EmptyModifier ())
		IKFKChange_roll = attributes Lotus_IKFKChange
		(
			parameters NewRollout rollout: Lotus_IKFKChange
			(
				sli01 type:#float ui:(sli01) animatable:true  default:0
				bt01 type:#boolean ui:(bt01) animatable:true
				bt02 type:#boolean ui:(bt02) animatable:true
				hideIKbone type:#boolean ui:(hideIKbone) animatable:false  default:true
				hideFKbone type:#boolean ui:(hideFKbone) animatable:false  default:false
				freezeBaseBone type:#boolean ui:(freezeBaseBone) animatable:false  default:true
				NOsel type:#boolean ui:(NOsel) animatable:false  default:true
				
				--st
				bone1         type:#node ;bone2         type:#node ;bone3        type:#node ;bone4        type:#node ;bone5       type:#node  ;bone0       type:#node 
				--ik
				ikBone1       type:#node ;ikBone2       type:#node ;ikBone3      type:#node 
				ikBaseCircle  type:#node ;ikPickTarget  type:#node ;ikChain001   type:#node 
				ikBone1_1     type:#node ;ikBone2_2     type:#node ;ikBone1_1ed  type:#node ;ikBone2_2ed  type:#node ;
				ikBone3_2     type:#node 
				--fk
				fkBone1       type:#node ;fkBone2       type:#node ;fkBone3      type:#node ;fkBone4      type:#node ;fkBone5     type:#node 
				fkCircle1     type:#node ;fkCircle2     type:#node ;fkCircle3    type:#node ;
				--lc
				theIKFKLC     type:#node ;
				--array
				NOSelArray    type:#nodeTab  tabSizeVariable:true
			)	
			
			rollout Lotus_IKFKChange "Lotus_handRig_v2.82"  
			(	
				groupBox g1 "" pos:[2,0] width:155 height:400 align:#left 
					slider  sli01 "IK                                       FK" pos:[10,10] width:150 height:20 type:#integer range:[0,1,0] ticks:1
					button  bt01 "Move IK to FK" pos:[10,68] width:140 height:30  
					button  bt02 "Move FK to IK" pos:[10,100] width:140 height:30 	
						checkbox  hideIKbone "Hide IK" pos:[15,135] width:68 height:20  checked:true
						checkbox  hideFKbone "Hide FK" pos:[15,155] width:68 height:20  checked:false
						checkbox  freezeBaseBone "Lock Bone" pos:[85,155] width:68 height:20  checked:true
					button  selbt2 "sel...bone" pos:[85,178] width:65 height:20 align:#left  
				checkbox  NOsel "冻结非必要的节点" pos:[15,205] width:128 height:20  checked:true
				button activation ">>>>>>_刷新_<<<<<<" pos:[10,310] width:140 height:50 
					button boneToZero "骨骼拉伸归零" pos:[10,365] width:140 height:30 
					button  selbt1 "sel...all" pos:[10,420] width:70 height:20 align:#left 	
				groupBox g2 "Del" pos:[2,450] width:155 height:63 align:#left 
					button del1 "Delete Keep Normal Pose" pos:[10,465] width:140 height:20 
					button del2 "Delete Keep Present Pose" pos:[10,487] width:140 height:20 
					
				on sli01 changed val do with undo on
				( 
					if $.'Attribute_Holder'.Lotus_IKFKChange.sli01.controller != bezier_float () then ( try($.'Attribute_Holder'.Lotus_IKFKChange.sli01.controller = bezier_float ())catch() )
					try( addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.sli01.controller 0f )catch()
					--pos
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone1.pos.controller.Position_Constraint.controller.weight[1] = 100 - val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone1.pos.controller.Position_Constraint.controller.weight[2] = val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone2.pos.controller.Position_Constraint.controller.weight[1] = 100 - val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone2.pos.controller.Position_Constraint.controller.weight[2] = val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone3.pos.controller.Position_Constraint.controller.weight[1] = 100 - val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone3.pos.controller.Position_Constraint.controller.weight[2] = val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone4.pos.controller.Position_Constraint.controller.weight[1] = 100 - val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone4.pos.controller.Position_Constraint.controller.weight[2] = val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone5.pos.controller.Position_Constraint.controller.weight[1] = 100 - val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone5.pos.controller.Position_Constraint.controller.weight[2] = val*100 )catch()
					--rot
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone1.rotation.controller.Orientation_Constraint.controller.weight[1] = 100 - val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone1.rotation.controller.Orientation_Constraint.controller.weight[2] = val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone2.rotation.controller.Orientation_Constraint.controller.weight[1] = 100 - val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone2.rotation.controller.Orientation_Constraint.controller.weight[2] = val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone3.rotation.controller.Orientation_Constraint.controller.weight[1] = 100 - val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone3.rotation.controller.Orientation_Constraint.controller.weight[2] = val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone4.rotation.controller.Orientation_Constraint.controller.weight[1] = 100 - val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone4.rotation.controller.Orientation_Constraint.controller.weight[2] = val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone5.rotation.controller.Orientation_Constraint.controller.weight[1] = 100 - val*100 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.bone5.rotation.controller.Orientation_Constraint.controller.weight[2] = val*100 )catch()

					if val == 1 then
					(
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.bt02.pressed() )catch()
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideIKbone.checked = true  )catch()
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideIKbone.changed(true)   )catch()
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideFKbone.checked = false )catch()
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideFKbone.changed(false)  )catch()
					)
					else
					(
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.bt01.pressed() )catch()
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideIKbone.checked = false  )catch()
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideIKbone.changed(false)   )catch()
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideFKbone.checked = true   )catch()
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideFKbone.changed(true)    )catch()
					)
				)
				
				on bt01 pressed do with undo on
				(
					try( $.'Attribute_Holder'.Lotus_IKFKChange.ikBaseCircle.transform = $.'Attribute_Holder'.Lotus_IKFKChange.fkBone3.transform )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.ikPickTarget.transform = $.'Attribute_Holder'.Lotus_IKFKChange.fkBone2.transform )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.ikChain001.transform = $.'Attribute_Holder'.Lotus_IKFKChange.fkBone3.transform )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1.transform = $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1.transform )catch()
						try( $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1.transform = $.'Attribute_Holder'.Lotus_IKFKChange.fkBone1.transform )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2.transform = $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2.transform )catch()
						try( $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2.transform = $.'Attribute_Holder'.Lotus_IKFKChange.fkBone2.transform )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3_2.transform = $.'Attribute_Holder'.Lotus_IKFKChange.fkBone3.transform )catch()
				)
				
				on bt02 pressed do with undo on
				(
					try( $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle1.transform = $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1.transform )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle2.transform = $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2.transform )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle3.transform = $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3.transform )catch()
				)
				
				on hideIKbone changed theState do with undo on
				(
					try
					(
						case of 
						(
							(theState == true):
								(
									try( hide $.'Attribute_Holder'.Lotus_IKFKChange.ikPickTarget )catch() ;try( hide $.'Attribute_Holder'.Lotus_IKFKChange.ikChain001 )catch()
									try( hide $.'Attribute_Holder'.Lotus_IKFKChange.ikBaseCircle )catch() ;try( hide $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1 )catch() 
									try( hide $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2 )catch() ;try( hide $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3 )catch() 
									try( hide $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1 )catch() ;try( hide $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1ed )catch() 
									try( hide $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2 )catch() ;try( hide $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2ed )catch() 
									try( hide $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3_2 )catch() ;try( hide $.'Attribute_Holder'.Lotus_IKFKChange.ikChain001 )catch() 
								)
							(theState == false):
								(
									try( unhide $.'Attribute_Holder'.Lotus_IKFKChange.ikPickTarget )catch() ;try( unhide $.'Attribute_Holder'.Lotus_IKFKChange.ikBaseCircle )catch() 		
								)
						)
					)catch()
				)
				
				on hideFKbone changed theState do with undo on
				(
					try
					(
						case of 
						(
							(theState == true):
								(			
									try( hide $.'Attribute_Holder'.Lotus_IKFKChange.fkBone1 )catch()   ;try( hide $.'Attribute_Holder'.Lotus_IKFKChange.fkBone2 )catch()
									try( hide $.'Attribute_Holder'.Lotus_IKFKChange.fkBone3 )catch() 
									try( hide $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle1 )catch() ;try( hide $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle2 )catch()
									try( hide $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle3 )catch() 
								)
							(theState == false):
								(
									try( unhide $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle1 )catch() ;try( unhide $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle2 )catch()
									try( unhide $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle3 )catch() 
								)
						)
					)catch()
				)
				
				on freezeBaseBone changed theState do with undo on
				(
					try
					(
						case of 
						(
							(theState == true):
								(			
									try( freeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone1 )catch() ;try( freeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone2 )catch()
									try( freeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone3 )catch() ;try( freeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone4 )catch()
									try( freeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone5 )catch()
								)
							(theState == false):
								(
									try( unfreeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone1 )catch() ;try( unfreeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone2 )catch()
									try( unfreeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone3 )catch() ;try( unfreeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone4 )catch()
									try( unfreeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone5 )catch() 
								)
						)
					)catch()
				)
				
				on selbt2 pressed do with undo on
				(
					temp = $
					select temp.'Attribute_Holder'.Lotus_IKFKChange.Bone1 
					selectMore temp.'Attribute_Holder'.Lotus_IKFKChange.Bone2 
					selectMore temp.'Attribute_Holder'.Lotus_IKFKChange.Bone3 
				)
				
				on NOsel changed theState do with undo on
				(
					try
					(
						case of 
						(
							(theState == true):
								(
									for i = 1 to $.'Attribute_Holder'.Lotus_IKFKChange.NOSelArray.count do
									(
										try( hide $.'Attribute_Holder'.Lotus_IKFKChange.NOSelArray[i] )catch()	
										try( freeze $.'Attribute_Holder'.Lotus_IKFKChange.NOSelArray[i] )catch()	
									)
								)
							(theState == false):
								(
									for i = 1 to $.'Attribute_Holder'.Lotus_IKFKChange.NOSelArray.count do
									(
										try( unhide $.'Attribute_Holder'.Lotus_IKFKChange.NOSelArray[i] )catch()	
										try( unfreeze $.'Attribute_Holder'.Lotus_IKFKChange.NOSelArray[i] )catch()	
									)								
								)
						)
					)catch()
				)	
				
				on activation pressed do with undo on
				(	
					if $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.sli01.value == 0 then
					(
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.sli01.value = 0  )catch()
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.sli01.changed(0) )catch()
					)
					if $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.sli01.value == 1 then
					(
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.sli01.value = 1  )catch()
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.sli01.changed(1) )catch() 
					)
					
					if $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideIKbone.checked == true then
					(
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideIKbone.changed(true) )catch()
					)
					else
					(
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideIKbone.changed(false) )catch()
					)
					if $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideFKbone.checked == true then
					(
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideFKbone.changed(true) )catch()
					)
					else
					(
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.hideFKbone.changed(false) )catch()
					)

					if $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.freezeBaseBone.checked == true then
					(
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.freezeBaseBone.changed(true) )catch()
					)
					else
					(
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.freezeBaseBone.changed(false) )catch()
					)
					
					if $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.NOsel.checked == true then
					(
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.NOsel.changed(true) )catch()
					)
					else
					(
						try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.NOsel.changed(false) )catch()
					)

					--删除IK上的关键帧
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1[3][1][2].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1[3][2][2].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1[3][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2[3][1][2].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2[3][2][2].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2[3][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1ed[3][1][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1ed[3][2][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1ed[3][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2ed[3][1][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2ed[3][2][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2ed[3][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3_2[3][1][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3_2[3][2][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3_2[3][3].controller #allKeys )catch()
	
					--校正基础骨骼上的IKFK切换的关键帧
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.bone1[3][1][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.bone1[3][2][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.bone1[3][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.bone2[3][1][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.bone2[3][2][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.bone2[3][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.bone3[3][1][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.bone3[3][2][3].controller #allKeys )catch()
					try(deleteKeys $.'Attribute_Holder'.Lotus_IKFKChange.bone3[3][3].controller #allKeys )catch()
					try  
					(
						contKeys = #()
						for i = 1 to (numKeys $[4][1].Lotus_IKFKChange[1].controller) do( append contKeys (getKeyTime $[4][1].Lotus_IKFKChange[1].controller i) )  --控制器的关键帧加入数组
						for i = 1 to contKeys.count do
						(
							addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.bone1[3][1][3][1].controller contKeys[i]
							addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.bone1[3][1][3][2].controller contKeys[i]
							addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.bone1[3][2][3][1].controller contKeys[i]
							addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.bone1[3][2][3][2].controller contKeys[i]
							addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.bone2[3][1][3][1].controller contKeys[i]
							addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.bone2[3][1][3][2].controller contKeys[i]
							addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.bone2[3][2][3][1].controller contKeys[i]
							addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.bone2[3][2][3][2].controller contKeys[i]
							try( addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.bone3[3][1][3][1].controller contKeys[i] )catch()
							try( addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.bone3[3][1][3][2].controller contKeys[i] )catch()
							try( addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.bone3[3][2][3][1].controller contKeys[i] )catch()
							try( addNewKey $.'Attribute_Holder'.Lotus_IKFKChange.bone3[3][2][3][2].controller contKeys[i] )catch()

							temp = ($[4][1].Lotus_IKFKChange[1].controller.keys[i].value)*100
							$.'Attribute_Holder'.Lotus_IKFKChange.bone1[3][1][3][1].controller.keys[i].value = 100 - temp
							$.'Attribute_Holder'.Lotus_IKFKChange.bone1[3][1][3][2].controller.keys[i].value = temp
							$.'Attribute_Holder'.Lotus_IKFKChange.bone1[3][2][3][1].controller.keys[i].value = 100 - temp
							$.'Attribute_Holder'.Lotus_IKFKChange.bone1[3][2][3][2].controller.keys[i].value = temp
							$.'Attribute_Holder'.Lotus_IKFKChange.bone2[3][1][3][1].controller.keys[i].value = 100 - temp
							$.'Attribute_Holder'.Lotus_IKFKChange.bone2[3][1][3][2].controller.keys[i].value = temp
							$.'Attribute_Holder'.Lotus_IKFKChange.bone2[3][2][3][1].controller.keys[i].value = 100 - temp
							$.'Attribute_Holder'.Lotus_IKFKChange.bone2[3][2][3][2].controller.keys[i].value = temp
							try( $.'Attribute_Holder'.Lotus_IKFKChange.bone3[3][1][3][1].controller.keys[i].value = 100 - temp )catch()
							try( $.'Attribute_Holder'.Lotus_IKFKChange.bone3[3][1][3][2].controller.keys[i].value = temp )catch()
							try( $.'Attribute_Holder'.Lotus_IKFKChange.bone3[3][2][3][1].controller.keys[i].value = 100 - temp )catch()
							try( $.'Attribute_Holder'.Lotus_IKFKChange.bone3[3][2][3][2].controller.keys[i].value = temp )catch()
						)
					)catch()
				)
				
				on boneToZero pressed do with undo on
				(
					try( $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1.transform = $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1.transform )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2.transform = $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2.transform )catch()						
				)
				
				on selbt1 pressed do with undo on
				(
					selectionArray = #()
					toSelArray = #()
					try( append selectionArray $)catch()
					try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1 )catch()
					try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2 )catch()
						try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1 )catch()
						try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2 )catch()
							try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1ed )catch()
							try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2ed )catch()
						try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3_2 )catch()
					try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3 )catch()
						try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.ikBaseCircle )catch()
						try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.ikPickTarget )catch()
						try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.ikChain001 )catch()

					try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.fkBone1 )catch()
					try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.fkBone2 )catch()
					try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.fkBone3 )catch()
					try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle1 )catch()
					try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle2 )catch()
					try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle3 )catch()
					
					try( append selectionArray $.'Attribute_Holder'.Lotus_IKFKChange.theIKFKLC )catch()
					
					for i = 1 to selectionArray.count do( if selectionArray[i] != () do (append toSelArray selectionArray[i]) )
					select toSelArray
				)
					
				on del1 pressed do with undo on
				(
					try( $.'Attribute_Holder'.Lotus_IKFKChange.Bone1[3][1].delete 3 ;$.'Attribute_Holder'.Lotus_IKFKChange.Bone1[3][2].delete 3 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.Bone2[3][1].delete 3 ;$.'Attribute_Holder'.Lotus_IKFKChange.Bone2[3][2].delete 3 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.Bone3[3][1].delete 3 ;$.'Attribute_Holder'.Lotus_IKFKChange.Bone3[3][2].delete 3 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.Bone0[3][2].delete 3 )catch()
					try( Lotus_FreezeTransform $.'Attribute_Holder'.Lotus_IKFKChange.Bone3 )catch() ;try( Lotus_FreezeTransform $.'Attribute_Holder'.Lotus_IKFKChange.Bone2 )catch()
					try( Lotus_FreezeTransform $.'Attribute_Holder'.Lotus_IKFKChange.Bone1 )catch()
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3 )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2 )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1 )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.fkBone1 )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.fkBone2 )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.fkBone3 )catch()
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikChain001 )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikPickTarget )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBaseCircle )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3_2 )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2ed )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2 )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1ed )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1 )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.theIKFKLC )catch()
					
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle1 )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle2 )catch()
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle3 )catch() ;
					
					try( unfreeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone1 )catch() ;try( unfreeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone2 )catch()
					try( unfreeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone3 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.Bone1.scale.controller = bezier_scale ();$.'Attribute_Holder'.Lotus_IKFKChange.Bone1.scale = [1,1,1] )catch()

					try( delete $ )catch()
				)	
				
				on del2 pressed do with undo on
				(
					try(boneTran1 = $.'Attribute_Holder'.Lotus_IKFKChange.Bone1.transform )catch()
					try(boneTran2 = $.'Attribute_Holder'.Lotus_IKFKChange.Bone2.transform )catch()
					try(boneTran3 = $.'Attribute_Holder'.Lotus_IKFKChange.Bone3.transform )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.Bone1[3][1].delete 3 ;$.'Attribute_Holder'.Lotus_IKFKChange.Bone1[3][2].delete 3 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.Bone2[3][1].delete 3 ;$.'Attribute_Holder'.Lotus_IKFKChange.Bone2[3][2].delete 3 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.Bone3[3][1].delete 3 ;$.'Attribute_Holder'.Lotus_IKFKChange.Bone3[3][2].delete 3 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.Bone0[3][2].delete 3 )catch()
					try( Lotus_FreezeTransform $.'Attribute_Holder'.Lotus_IKFKChange.Bone3 )catch() ;try( Lotus_FreezeTransform $.'Attribute_Holder'.Lotus_IKFKChange.Bone2 )catch()
					try( Lotus_FreezeTransform $.'Attribute_Holder'.Lotus_IKFKChange.Bone1 )catch()
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3 )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2 )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1 )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.fkBone1 )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.fkBone2 )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.fkBone3 )catch()
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikChain001 )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikPickTarget )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBaseCircle )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone3_2 )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2ed )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2 )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1ed )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1 )catch() 
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.theIKFKLC )catch()
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle1 )catch() ;try( delete $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle2 )catch()
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.fkCircle3 )catch() ;
					
					try( unfreeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone1 )catch() ;try( unfreeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone2 )catch()
					try( unfreeze $.'Attribute_Holder'.Lotus_IKFKChange.Bone3 )catch() 
					try($.'Attribute_Holder'.Lotus_IKFKChange.Bone1.transform = boneTran1 ;Lotus_FreezeTransform $.'Attribute_Holder'.Lotus_IKFKChange.Bone1 )catch()
					try($.'Attribute_Holder'.Lotus_IKFKChange.Bone2.transform = boneTran2 ;Lotus_FreezeTransform $.'Attribute_Holder'.Lotus_IKFKChange.Bone2 )catch()
					try($.'Attribute_Holder'.Lotus_IKFKChange.Bone3.transform = boneTran3 ;Lotus_FreezeTransform $.'Attribute_Holder'.Lotus_IKFKChange.Bone3 )catch()
							
					try( delete $ )catch()
				)	
			)
		)
		custAttributes.add IKFK_Change.modifiers[#Attribute_Holder] IKFKChange_roll BaseObject:true #unique 

		--引导节点对接
		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.bone0 = baseBone000)catch()
		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.bone1 = baseBone001)catch()
		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.bone2 = baseBone002)catch()
		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.bone3 = baseBone003)catch()
		
		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.NOSelArray = NOSelArray)catch()

		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.ikBone1 = ikBone001)catch()
		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.ikBone2 = ikBone002)catch()
			try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1 = ikBone001_1)catch()
			try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2 = ikBone002_2)catch()
				try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.ikBone1_1ed = ikBone001_1ed)catch()
				try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.ikBone2_2ed = ikBone002_2ed)catch()
			try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.ikBone3_2 = ikBone003_2)catch()
			try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.ikBone3 = ikBone003)catch()
			try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.ikBaseCircle = ikBaseCircle)catch()
			try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.ikPickTarget = theIKChain001_VHTarget)catch()
			try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.ikChain001 = theIKChain001)catch()

		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.fkBone1 = fkBone001)catch()
		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.fkBone2 = fkBone002)catch()
		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.fkBone3 = fkBone003)catch()
		
		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.fkCircle1 = fkCircle1)catch()
		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.fkCircle2 = fkCircle2)catch()
		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.fkCircle3 = fkCircle3)catch()
		
		try(IKFK_Change.'Attribute_Holder'.Lotus_IKFKChange.theIKFKLC = theIKFKLC)catch()
		
		--驱动IK末端骨骼控制
		Ori_Constraint_ = Orientation_Constraint()
		ikBone003[3][4][2][3].controller = Ori_Constraint_
		Ori_Constraint_.constraints.appendtarget ikBaseCircle 100
		
		--加入通用层
		try( layermanager.newLayerFromName "Lotus_IKFKCL_toHdie" )catch()
		Lotus_IKFKCL_toHdie = LayerManager.getLayerFromName "Lotus_IKFKCL_toHdie"
		for i in lcToHideArray do Lotus_IKFKCL_toHdie.addnode i
		free lcToHideArray
		try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.activation.pressed() )catch()
		
		--IK极向量自动化位移
		theIKChain001_VHTarget.pos.controller.Available.controller = Position_XYZ ()
		theIKChain001_VHTarget[3][1][3][1].controller = Float_Expression ()
		theIKChain001_VHTarget[3][1][3][1].track.addScalarTarget "a" ikBaseCircle[3][1][2][1]
		theIKChain001_VHTarget[3][1][3][1].track.setExpression ("if(a>0,a,0)")
		theIKChain001_VHTarget[3][1][3][1].controller = float_limit ()
		theIKChain001_VHTarget[3][1][3][1].controller.upper_limit = 90
		theIKChain001_VHTarget[3][1][3][1].controller.lower_limit = -90
		theIKChain001_VHTarget[3][1][3][2].controller = Float_Expression ()
		theIKChain001_VHTarget[3][1][3][2].track.addScalarTarget "a" ikBaseCircle[3][1][2][2]
		theIKChain001_VHTarget[3][1][3][2].track.setExpression ("if(a>0,a*10,0)")
		theIKChain001_VHTarget[3][1][3][2].controller = float_limit ()
		theIKChain001_VHTarget[3][1][3][2].controller.upper_limit = 90
		theIKChain001_VHTarget[3][1][3][2].controller.lower_limit = -90
		theIKChain001_VHTarget[3][1][3][3].controller = Float_Expression ()
		theIKChain001_VHTarget[3][1][3][3].track.addScalarTarget "a" ikBaseCircle[3][1][2][3]
		theIKChain001_VHTarget[3][1][3][3].track.setExpression ("if(a>0,a,a)")
		theIKChain001_VHTarget[3][1][3][3].controller = float_limit ()
		theIKChain001_VHTarget[3][1][3][3].controller.upper_limit = 90
		theIKChain001_VHTarget[3][1][3][3].controller.lower_limit = -90
		
		--设置选择集
		if selectionSets["IKFK_RefreshNode"] == undefined then ( selectionSets["IKFK_RefreshNode"] = IKFK_Change )else( select selectionSets["IKFK_RefreshNode"]; selectMore IKFK_Change; selectionSets["IKFK_RefreshNode"] = $ )
		clearSelection()
	)
)


Lotus_rig_HandIKFK2_()








