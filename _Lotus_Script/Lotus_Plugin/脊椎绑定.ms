fn vertebraRigTool_CalculatedPointLength sel =  --计算顶点距离总和
(
	val = 0 ;try(for i = 1 to (sel.count - 1) do( val += distance sel[i] sel[i+1] ))catch();val	
)

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


fn Lts_pointInvolvePointToPoint nod1 nod2 num =  --权重值
(
	colArray = #(nod1 ,nod2)
	if colArray.count == 2 then
	(
		baseObj = colArray[colArray.count]
		deleteItem colArray colArray.count
		for i = 1 to colArray.count do
		(
			layNum
			for o = 3 to 100 do( if (colArray[i][3][1][o] as string) == "SubAnim:Available" then( layNum = o ;break ) )
			colArray[i][3][1][layNum].controller = Position_XYZ ()
			paramWire.connect baseObj[3][1][2] colArray[i][3][1][layNum] ("Zero_Pos_XYZ * " + (num as string))
			colArray[i][3][1].setname layNum baseObj.name
		)
	)
)

fn Lotus_jizui =
(
	--基础骨骼
	baseBoneArray = selection as array
	freezeArray = baseBoneArray
	for i in baseBoneArray do ( Lotus_FreezeTransform i )

	--创建隐藏层
	try( layermanager.newLayerFromName "hide" )catch()
	Lotus_Layer_toHdie = LayerManager.getLayerFromName "hide"

	--创建总控制大圈
	alCircle = Circle radius:30 pos:(baseBoneArray[1].pos) isSelected:on
	alCircle.name = "spinalControlCircle_"
	Lotus_FreezeTransform alCircle

	--创建曲线
	new_spline = line()
	addNewSpline new_spline
	for i = 1 to baseBoneArray.count do( addKnot new_spline 1 #corner #curve (baseBoneArray[i].pos) )
	for i = 1 to baseBoneArray.count do( setKnotType new_spline 1 i #bezier )
	updateshape new_spline
	new_spline.name = "spinalLine_" 
	try( Lotus_Layer_toHdie.addnode new_spline)catch()
	Lotus_FreezeTransform new_spline
	setTransformLockFlags new_spline #all

	--创建受曲线控制的点
	CVpointED = #()
	for i = 1 to (baseBoneArray.count) do
	(
		temp = #()
		for o = 1 to i do (append temp baseBoneArray[o])
		tempPoint = Point transform:( matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0] ) isSelected:off size:0.01 box:off cross:off centermarker:off axistripod:off drawontop:off constantscreensize:off 
		try( Lotus_Layer_toHdie.addnode tempPoint)catch()
		tempPoint.name = "CVpointED" + ( i as string )
		tempPoint.pos.controller = Path_Constraint()
		tempPoint.pos.controller.path = new_spline
		tempPoint.pos.controller.follow = on
		DeleteKeys (tempPoint[3][1][1].keys) #allKeys
		tempPoint.pos.controller.PERCENT = (vertebraRigTool_CalculatedPointLength temp)/(vertebraRigTool_CalculatedPointLength baseBoneArray)*100
		append CVpointED tempPoint
	)

	for i = 1 to (CVpointED.count - 1) do
	(
		CVpointED[i][3][2].controller = LookAt_Constraint ()
		CVpointED[i][3][2].controller.appendTarget CVpointED[i+1] 100
		CVpointED[i][3][2].controller.lookat_vector_length = 0
		CVpointED[i][3][2].controller.upnode_world = off
		CVpointED[i][3][2].controller.pickUpNode = CVpointED[i+1]
	)

	(CVpointED[CVpointED.count]).rotation.controller = LookAt_Constraint ()
	(CVpointED[CVpointED.count]).rotation.controller.appendTarget (baseBoneArray[baseBoneArray.count].children[1]) 100
	(CVpointED[CVpointED.count]).rotation.controller.lookat_vector_length = 0
	(CVpointED[CVpointED.count]).rotation.controller.upnode_world = off
	(CVpointED[CVpointED.count]).rotation.controller.pickUpNode = ((baseBoneArray[baseBoneArray.count]).children)[1]
	(CVpointED[CVpointED.count]).rotation.controller.target_axisFlip = off
	(CVpointED[CVpointED.count]).rotation.controller.target_axis = 0
	(CVpointED[CVpointED.count]).rotation.controller.upnode_axis = 2
	(CVpointED[CVpointED.count]).rotation.controller.StoUP_axis = 2

	--创建控制曲线的节点
	addmodifier new_spline (Spline_IK_Control())
	new_spline.modifiers[#Spline_IK_Control].createHelper(baseBoneArray.count)
	new_spline.modifiers[#Spline_IK_Control].linkTypes = 2
	new_spline.modifiers[#Spline_IK_Control].helper_centermarker = off
	new_spline.modifiers[#Spline_IK_Control].helper_axistripod = off
	new_spline.modifiers[#Spline_IK_Control].helper_cross = off
	new_spline.modifiers[#Spline_IK_Control].Box = off
	new_spline.modifiers[#Spline_IK_Control].drawontop = off
	new_spline.modifiers[#Spline_IK_Control].helper_size = 2
	sliderTime = 0f
	CVpointLC = new_spline.modifiers[#Spline_IK_Control].helper_list
	for i in CVpointLC do ( Lotus_FreezeTransform i ;try( Lotus_Layer_toHdie.addnode i)catch() ) 
	for i = 1 to CVpointLC.count do( CVpointLC[i].name = "spinalLine_p_" + (i as string) )

	--创建控制点的曲线
	CVpointLC_CV = #()
	for i = 1 to CVpointLC.count do
	(
		temp = Circle radius:(alCircle.radius*0.6) pos:CVpointLC[i].pos isSelected:on  wirecolor:(color 27 177 148)

		Lotus_FreezeTransform temp
		append CVpointLC_CV temp
		Lotus_pointTransfromLC CVpointLC[i] temp
		temp.name = "spinalCV_" + (i as string)
	)
	CVpointLC_CV.parent = alCircle
	for i in CVpointLC_CV do ( Lotus_FreezeTransform i )
	
	--制作控制点的曲线之间关系
	CVpointLC_CV[1].radius = 0.01
	setTransformLockFlags CVpointLC_CV[1] #all
	tempStr = (CVpointLC_CV[2].pos - CVpointLC_CV[1].pos) as string
	paramWire.connect CVpointLC_CV[2][3][1] CVpointLC_CV[1][3][1] ("Position - " + tempStr)
	newCV_LC_CV = CVpointLC_CV
	tempNode = CVpointLC_CV[1]
	deleteItem newCV_LC_CV 1 
	for i = 0 to newCV_LC_CV.count - 3 do
	(
		try
		(
			newCV_LC_CV[newCV_LC_CV.count - i].parent = newCV_LC_CV[newCV_LC_CV.count - i - 1] 
			Lotus_FreezeTransform newCV_LC_CV[newCV_LC_CV.count - i]
		)catch()
	)
	
	--重新锁定末端和前端被控制曲线的点轴向
	EDpoint_ = #()
	tempPoint = Point transform:( matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0] ) isSelected:off size:0.01 box:off cross:off centermarker:off axistripod:off drawontop:off constantscreensize:off 
	tempPoint.transform = CVpointED[CVpointED.count].transform
	tempPoint.name = "spinalCV_ST"
	try( Lotus_Layer_toHdie.addnode tempPoint)catch()
	animate off in coordsys local tempPoint.pos.x += 1
	tempPoint.parent = CVpointLC_CV[CVpointLC_CV.count]
	Lotus_FreezeTransform tempPoint
	(CVpointED[CVpointED.count]).rotation.controller.deleteTarget 1 
	(CVpointED[CVpointED.count]).rotation.controller.appendTarget tempPoint 100
	(CVpointED[CVpointED.count]).rotation.controller.pickUpNode = tempPoint
	append EDpoint_ tempPoint
	tempPoint = Point transform:( matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0] ) isSelected:off size:0.01 box:off cross:off centermarker:off axistripod:off drawontop:off constantscreensize:off 
	tempPoint.transform = CVpointED[1].transform
	tempPoint.name = "spinalCV_ED"
	try( Lotus_Layer_toHdie.addnode tempPoint)catch()
	animate off in coordsys local tempPoint.pos.x += 1
	tempPoint.parent = CVpointLC_CV[1]
	Lotus_FreezeTransform tempPoint 
	CVpointED[1].rotation.controller.appendTarget tempPoint 100
	CVpointED[1].rotation.controller.pickUpNode = tempPoint
	append EDpoint_ tempPoint

	--基础骨骼链接给被曲线控制的点
	for i = 1 to baseBoneArray.count do
	(
		Pos_Constraint_ = Position_Constraint()
		baseBoneArray[i][3][1][3].controller = Pos_Constraint_
		Pos_Constraint_.constraints.appendtarget CVpointED[i] 100
		Ori_Constraint_ = Orientation_Constraint()
		baseBoneArray[i][3][2][3].controller = Ori_Constraint_
		Ori_Constraint_.constraints.appendtarget CVpointED[i] 100
	)

	--在大曲线中建立记录属性
	try( deleteModifier alCircle alCircle.modifiers[EmptyModifier])catch()
	addmodifier alCircle (EmptyModifier ())			
	temp = attributes Lotus_IKFKChange
	(
		parameters parameters01 rollout: Lotus_IKFKChange
		(
			theBaseArray type:#nodeTab  tabSizeVariable:true
			thePointArray type:#nodeTab  tabSizeVariable:true
			theFreezeArray type:#nodeTab  tabSizeVariable:true
		)	
		rollout Lotus_IKFKChange "2.8"  
		(
			button  del "删除脊椎" pos:[10,70] width:140 height:30 
			button  freeBone "冻结骨骼" pos:[10,100] width:140 height:35 
			
			on del pressed do 
			(
				for i = 1 to $.'Attribute_Holder'.Lotus_IKFKChange.theBaseArray.count do
				(
					try( $.'Attribute_Holder'.Lotus_IKFKChange.theBaseArray[i][3][1].delete 3 )catch()
					try( $.'Attribute_Holder'.Lotus_IKFKChange.theBaseArray[i][3][2].delete 3 )catch()
					try( Lotus_FreezeTransform $.'Attribute_Holder'.Lotus_IKFKChange.theBaseArray[i] )catch()
				)
				for i = 1 to $.'Attribute_Holder'.Lotus_IKFKChange.thePointArray.count do
				(
					try( delete $.'Attribute_Holder'.Lotus_IKFKChange.thePointArray[i] )catch()
				)
				try( delete $ )catch()
			)
			
			on freeBone pressed do 
			(
				try( for i in $.'Attribute_Holder'.Lotus_IKFKChange.theFreezeArray do( freeze i ) )catch()
			)
		)
	)
	custAttributes.add alCircle.modifiers[#Attribute_Holder] temp

	--将节点记录其中
	append CVpointLC_CV tempNode
	try( alCircle.'Attribute_Holder'.Lotus_IKFKChange.theBaseArray = baseBoneArray )catch()
	try( alCircle.'Attribute_Holder'.Lotus_IKFKChange.theFreezeArray = freezeArray )catch()
	tempArrayTO = #()
	for i in CVpointED do ( append tempArrayTO i )
	append tempArrayTO new_spline
	for i in CVpointLC do ( append tempArrayTO i )
	for i in CVpointLC_CV do ( append tempArrayTO i )
	for i in EDpoint_ do ( append tempArrayTO i )
	try( alCircle.'Attribute_Holder'.Lotus_IKFKChange.thePointArray = tempArrayTO )catch()
	--将基础骨骼和大圈的scale绑定
	baseBoneArray[1]
	paramWire.connect alCircle[3][3] baseBoneArray[1][3][3] "Scale"
)

Lotus_jizui()




























