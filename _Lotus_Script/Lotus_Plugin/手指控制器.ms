fn Lotus_handRig =
(
	base = selection as array
	cur_Array = #()

	--最大曲线
	alphaCur = Rectangle length:(base[1].width * 0.2) width:(base[1].width * 0.2) cornerRadius:0.2  isSelected:on wirecolor:(color 88 199 225)
	alphaCur.transform = base[base.count].transform
	in coordsys local move alphaCur [base[1].width * 1.2,0,0]
	alphaCur.name = base[base.count].name + "_cur"
	alphaCur.parent = base[base.count]
	Lotus_FreezeTransform alphaCur
	for i = 1 to 3 do
	(
		alphaCur[3][1][2][i].controller = float_limit ()
		alphaCur[3][1][2][i].controller.upper_limit = 0
		alphaCur[3][1][2][i].controller.lower_limit = 0
		alphaCur[3][2][2][i].controller = float_limit ()
		alphaCur[3][2][2][i].controller.upper_limit = 0
		alphaCur[3][2][2][i].controller.lower_limit = 0
	)

	--控制曲线搭建
	num = 1
	for i = 1 to base.count do
	(
		num *= 0.8
		pA = Rectangle length:(base[i].width * num) width:(base[i].width * num) cornerRadius:0.1  isSelected:on wirecolor:(color 88 199 225)
		pA.transform = base[i].transform
		pA.name = base[i].name + "_cur"
		in coordsys local move pA [0,0,base[i].width * 3]
		pA.pivot = base[i].pivot
		append cur_Array pA	
	)
	for i = 1 to (cur_Array.count - 1) do( cur_Array[i+1].parent = cur_Array[i] )
	cur_Array[1].parent = base[1].parent
	for i in cur_Array  do( Lotus_FreezeTransform i )

	--约束骨骼
	for i = 1 to (base.count - 1) do 
	(
		Pos_Constraint_ = Position_Constraint()
		base[i][3][1][3].controller = Pos_Constraint_
		Pos_Constraint_.constraints.appendtarget cur_Array[i] 100
		base[i][3][2][3].controller = LookAt_Constraint ()
		base[i][3][2][3].controller.appendTarget cur_Array[i+1] 100
		base[i][3][2][3].controller.lookat_vector_length = 0
		base[i][3][2][3].controller.upnode_world = off
		base[i][3][2][3].controller.pickUpNode = cur_Array[i+1]
	)
	Ori_Constraint_ = Orientation_Constraint()
	base[base.count][3][2][3].controller = Ori_Constraint_
	Ori_Constraint_.constraints.appendtarget cur_Array[cur_Array.count] 100
			
	--在大曲线中建立记录属性
	try( deleteModifier alphaCur alphaCur.modifiers[EmptyModifier])catch()
	addmodifier alphaCur (EmptyModifier ())			
	temp = attributes rollout01
	(
		parameters parameters01 rollout: rollout01
		(
			theBaseArray type:#nodeTab  tabSizeVariable:true
			thePointArray type:#nodeTab  tabSizeVariable:true
		)	
		rollout rollout01 ""  
		(
			button  del "删除手指控制器" pos:[10,68] width:140 height:30 
			
			on del pressed do 
			(
				for i = 1 to $.'Attribute_Holder'.rollout01.theBaseArray.count do
				(
					try( $.'Attribute_Holder'.rollout01.theBaseArray[i][3][1].delete 3 )catch()
					try( $.'Attribute_Holder'.rollout01.theBaseArray[i][3][2].delete 3 )catch()
					try( Lotus_FreezeTransform $.'Attribute_Holder'.rollout01.theBaseArray[i] )catch()
				)
				for i = 1 to $.'Attribute_Holder'.rollout01.thePointArray.count do
				(
					try( delete $.'Attribute_Holder'.rollout01.thePointArray[i] )catch()
				)
				try( delete $ )catch()
			)
		)
	)
	custAttributes.add alphaCur.modifiers[#Attribute_Holder] temp

	--将节点记录其中
	try( alphaCur.'Attribute_Holder'.rollout01.theBaseArray = base )catch()
	try( alphaCur.'Attribute_Holder'.rollout01.thePointArray = cur_Array )catch()
)


Lotus_handRig()





