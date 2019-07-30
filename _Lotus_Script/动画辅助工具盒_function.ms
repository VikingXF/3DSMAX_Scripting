
global theServerAddress_ = "\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\_Lotus_Script\\"  --设置服务器地址
global LocalAddress_ = "D:\\_Lotus_Script"  --设置本机地址

fn Lotus_Array_ModX theTargetArray =   --数组列位
(
	if (classof theTargetArray) == Array then
	(
		for i = 1 to theTargetArray.count do 
		(
			for o = 1 to theTargetArray.count do 
			(
				if theTargetArray[i].pos.x < theTargetArray[o].pos.x do
				(
					tempM = theTargetArray[o]
					theTargetArray[o] = theTargetArray[i]
					theTargetArray[i] = tempM
				)
			)
		)	
	)
)

fn Lotus_FreezeTransform NodeToZero =   --自制冻结变换
(
	NodeToZero.pos.controller = Position_XYZ()
	Lotus_FreezeTransformPL = positionLIst() 
	NodeToZero.pos.controller = Lotus_FreezeTransformPL
	Lotus_FreezeTransformPL.available.controller = position_xyz()
	Lotus_FreezeTransformPL.active = 2
	Lotus_FreezeTransformPL.setname 2 "Zero Pos XYZ" 
	NodeToZero.pos.controller[1].controller = bezier_position()
	Lotus_FreezeTransformPL.setName 1 "Frozen Position"
	
	NodeToZero.rotation.controller = Euler_xyz()
	Lotus_FreezeTransformRL = rotationList()  
	NodeToZero.rotation.controller = Lotus_FreezeTransformRL
	Lotus_FreezeTransformRL.available.controller =Euler_xyz()
	Lotus_FreezeTransformRL.active = 2
	Lotus_FreezeTransformRL.setname 2 "Zero Euler XYZ"
	Lotus_FreezeTransformRL.setName 1 "Frozen Rotation"
)

fn Lotus_StringConvertToPoint3 theString =   --字符串转换矢量
(
	if classof theString == String then
	(
		tempST = (filterString theString "[ ,]" )
		newPoint3 = [tempST[1] as float,tempST[2] as float,tempST[3] as float]
	)
)

fn Lotus_StringConvertToMatrix3 theString =  --字符串转换矩阵
(
	fn Lotus_StringConvertToPoint3 theString =
	(
		if classof theString == String then
		(
			tempST = (filterString theString "[ ,]" )
			newPoint3 = [tempST[1] as float,tempST[2] as float,tempST[3] as float]
		)
	)
	
	if classof theString == String then
	(
		tempST = (filterString theString "( )" )
		p1 = Lotus_StringConvertToPoint3 tempST[2]
		p2 = Lotus_StringConvertToPoint3 tempST[3]
		p3 = Lotus_StringConvertToPoint3 tempST[4]
		p4 = Lotus_StringConvertToPoint3 tempST[5]
		newMatrix3 = (matrix3 p1 p2 p3 p4)
	)
)

fn Lotus_StringConvertToQuat theString =  --字符串转行四元数
(
	if classof theString == String then
	(
		tempST = (filterString theString "( )" )
		p1 = tempST[2] as float
		p2 = tempST[3] as float
		p3 = tempST[4] as float
		p4 = tempST[5] as float
		newQuat = (quat p1 p2 p3 p4)
	)
)

fn lotus_saveTXT filepath filetext =  --内置函数写入文本
(
    if doesFileExist filepath == true then
    (
        fin = openfile filepath mode:"r+"
        seek fin #eof
        txt = filetext + "\n"
        format txt to:fin
        close fin
    )
    else
    (
        newfile = createFile filepath
        close newfile
        lotus_saveTXT filepath filetext
	)
)  

fn lotus_loadTXT filepath =  --内置函数逐行读取文本
(
    fin = openfile filepath
	seek fin #eof
    maxlen=filepos fin
    seek fin 0
    res = readChars fin maxlen errorAtEOF:false
	close fin
	tempArray = filterString res "\n"
	for i = 1 to tempArray.count do
	(
		tempArray[i][(tempArray[i].count)] = ""
	)
	tempArray
) 

fn Lotus_RotatePivotOnly obj toObj  =   --旋转质心轴向与之匹配
(
	ResetTransform obj
	rotValInv = toObj.rotation
	animate off in coordsys local obj.rotation *= rotValInv
	animate off in coordsys local obj.objectoffsetpos *= rotValInv
	animate off in coordsys local obj.objectoffsetrot *= rotValInv
)

fn Lotus_CopyFolder oldPath newPath =   --复制文件夹
(
	oldPathFilearray = GetDirectories (oldPath + "\\*")
	for i in oldPathFilearray do ( join oldPathFilearray (GetDirectories (i + "\\*")) )
		
	copy_files = #()
	append oldPathFilearray (oldPath + "\\")
	for i in oldPathFilearray do ( join copy_files (getFiles (i + "\\*")) )
	
	for i in copy_files do
	(
		oldPath_path = newPath + (replace ( getFilenamePath i) 1 oldPath.count "")
		makedir oldPath_path
		copyfile i ( oldPath_path  + (filenameFromPath i))   
	)
)

fn Lotus_GetName =  --读取MAX文档命名
(
	local num = 1
	local maxFileNameLength = maxfilename.count
	local strNameMaxFileN = maxfilename
	local targetValue = 0
	
	if strNameMaxFileN != "" then
	(
		for i in 1 to maxFileNameLength do
		(
			if maxfilename[num] == "(" then ( targetValue = num ) else ( num += 1 )
		)
		
		if targetValue == 0 then
		(
			strNameMaxFileN[maxFileNameLength] = ""
			strNameMaxFileN[maxFileNameLength-1] = ""
			strNameMaxFileN[maxFileNameLength-2] = ""
			strNameMaxFileN[maxFileNameLength-3] = ""	
			return strNameMaxFileN
		)
		else
		(
			kill = maxFileNameLength - targetValue + 1
			for i in 1 to kill do
			(
				strNameMaxFileN[targetValue] = ""
				targetValue = targetValue 
			)
			return strNameMaxFileN
		)
	)
	else ( strNameMaxFileN = "_" )
)

fn Lts_pointInvolvePoint nod1 nod2 num =  --跟随节点、目标节点、权重值
(
	colArray = #(nod1 ,nod2)
	if colArray.count >= 2 then
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


fn eliminateZeroBone =  --清除没有权重的骨骼
(
	obj_Skin = (selection as array)[1]
	max modify mode
	modPanel.setCurrentObject obj_Skin.modifiers[#Skin]
	SkinBoneID = #()  --有权重骨骼ID集合
	bone_count = skinOps.GetNumberBones obj_Skin.modifiers[#Skin] --蒙皮骨骼的数量
	skin_index=#{1.. bone_count} --骨骼蒙皮ID列表
	numSkinVerts = #{1..(skinOps.getNumberVertices obj_Skin.modifiers[#Skin])} --获取参与蒙皮的点

	for n=1 to numSkinVerts.count do                                                                                              ----------------------原作者---------------------------
	( 																															   -------------------AnimationTool-----------------------
		numBoneWeights = skinOps.getVertexWeightCount obj_Skin.modifiers[#Skin] n    --每个点有几根骨骼影响	                           -------------------Author:乔磊-------------------------        
																																   ------------------QQ:409856476-------------------------
		for b=1 to numBoneWeights do																							   ---------------------- by Joe--------------------------
		(                     																									   ------------------QQ: 738746223------------------------
			boneID       = skinOps.getVertexWeightBoneID obj_Skin.modifiers[#Skin] n b  --获取第n个点参与的第b个骨骼的ID
			append SkinBoneID boneID
		)
	)
	SkinBoneID = makeUniqueArray SkinBoneID ----去除数组中重复的元素
	SkinBoneID = sort SkinBoneID  ----数组排序
	skin_index = skin_index as array    ----位数组转数组

	deleteBonesID = #()
	for i = 1 to skin_index.count do
	(
		toDel = 0
		for o = 1 to SkinBoneID.count do ( if skin_index[i] == SkinBoneID[o] do ( toDel = 1 ) )
		if toDel == 0 do ( append deleteBonesID skin_index[i] )
	)
	deleteBonesName = #()
	for i = 1 to deleteBonesID.count do
	(
		append deleteBonesName ( skinOps.GetBoneName obj_Skin.modifiers[#Skin] deleteBonesID[i] 1 )
	)

	for i = 1 to deleteBonesName.count do
	( 
		try
		(
			select obj_Skin
			for o = 1 to ( skinOps.GetNumberBones obj_Skin.modifiers[#Skin] ) do
			(	
				if (skinOps.GetBoneName obj_Skin.modifiers[#Skin] o 1 == deleteBonesName[i] ) then( skinOps.removebone obj_Skin.modifiers[#Skin] o  )
			)
			clearSelection()
		)catch()
	)
)

fn Lts_bdBone arr =  --选择节点生成骨骼
(
	fn boneEnd slBone =
	(
		posArray = #()
		temp = point()
		temp.transform = slBone.transform
		in coordsys local move temp [slBone.length,0,0]
		pos = temp.pos
		posArray[1] = pos
		in coordsys local move temp [1,0,0]
		pos = temp.pos
		posArray[2] = pos
		delete temp
		posArray
	)
	newBoneArr = #()
	arr = selection as array
	
	for i = 1 to (arr.count - 1) do
	(
		BoneStartPoint = arr[i].transform.pos
		BoneEndpoint =  arr[i+1].transform.pos
		newBone                     = bonesys.createbone BoneStartPoint BoneEndpoint (arr[i].dir*[1,-1,1] )
		newBone.width               = 1
		newBone.height              = 1
		newBone.taper               = 90
		newBone.name                = arr[i].name + "_Ltz"	
		append newBoneArr newBone 
	)
	BoneStartPoint = (boneEnd newBoneArr[newBoneArr.count])[1]
	BoneEndpoint =  (boneEnd newBoneArr[newBoneArr.count])[2]
	newBone                     = bonesys.createbone BoneStartPoint BoneEndpoint newBoneArr[newBoneArr.count].dir 
	newBone.width               = 1
	newBone.height              = 1
	newBone.taper               = 90
	newBone.name                = newBoneArr[newBoneArr.count].name + "_ed"	
	append newBoneArr newBone 
	for i = 0 to (newBoneArr.count - 2) do( newBoneArr[newBoneArr.count-i].parent = newBoneArr[newBoneArr.count-i-1] )
	newBoneArr
)


-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>↑↑↑↑通用函数↑↑↑↑>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>--

----------------------------------普通模式----------------------------------------------------------------------------
fn Lotus_standardMode =
(
	max unfreeze all
	max display mode
	findCTS = windows.getchildhwnd #max "None" 
	uiaccessor.pressbutton findCTS[1]
	try( Lotus_IKFKCL_toHdie = LayerManager.getLayerFromName "Lotus_IKFKCL_toHdie" )catch()
	try( Lotus_IKFKCL_toHdie.ishidden = false )catch()
	try( Lotus_IKFKCL_toHdie = LayerManager.getLayerFromName "hide" )catch()
	try( Lotus_IKFKCL_toHdie.ishidden = false )catch()
)

----------------------------------展示模式----------------------------------------------------------------------------
fn Lotus_showMode =
(
	hideByCategory.geometry = false
	hideByCategory.shapes = true
	hideByCategory.lights = true
	hideByCategory.cameras = true
	hideByCategory.helpers = true
	hideByCategory.spaceWarps = true
	hideByCategory.particles = true
	hideByCategory.bones = true 
)

----------------------------------动画模式----------------------------------------------------------------------------
fn Lotus_animationMode =
(
	SetSelectFilter 2
	max select all
	allGeometryArray = selection as array
	allGeometryArray_KcsBoneArray = #()
	for i = 1 to allGeometryArray.count do( if (classof allGeometryArray[i]) as string  != "Biped_Object" then( append allGeometryArray_KcsBoneArray allGeometryArray[i] ))
	allGeometryArray_KcsBoneArray.showFrozenInGray = off
	select allGeometryArray_KcsBoneArray
	max freeze selection
	SetSelectFilter 1
	hideByCategory.geometry = false
	hideByCategory.shapes = false
	hideByCategory.lights = false
	hideByCategory.cameras = false
	hideByCategory.helpers = false
	hideByCategory.spaceWarps = false
	hideByCategory.particles = false
	hideByCategory.bones = false 
	
	if selectionSets["IKFK_RefreshNode"] != undefined then
	(
		max modify mode
		for i = 1 to selectionSets["IKFK_RefreshNode"].count do 
		(
			try( select selectionSets["IKFK_RefreshNode"][i] )catch()
			try
			(
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
			)catch()
			try( $.'Attribute_Holder'.Lotus_IKFKChange.Lotus_IKFKChange.freeBone.pressed() )catch()
		)
	)
	try( Lotus_IKFKCL_toHdie = LayerManager.getLayerFromName "hide" )catch()
	try( Lotus_IKFKCL_toHdie.ishidden = true )catch()
	clearSelection()
)

----------------------------------导出模式----------------------------------------------------------------------------
fn Lotus_exportMode =
(
	max unhide all
	max unfreeze all
	findCTS = windows.getchildhwnd #max "None" 
	uiaccessor.pressbutton findCTS[1]
	hideByCategory.geometry = false
	hideByCategory.shapes = true
	hideByCategory.lights = true
	hideByCategory.cameras = true
	hideByCategory.helpers = false
	hideByCategory.spaceWarps = false
	hideByCategory.particles = false
	hideByCategory.bones = false 
	try( Lotus_IKFKCL_toHdie = LayerManager.getLayerFromName "Lotus_IKFKCL_toHdie" )catch()
	try( Lotus_IKFKCL_toHdie.ishidden = true )catch()
)

--#############################################################################################################################################--
--#####################################################         /通用/        #################################################################--
--#############################################################################################################################################--
--******/ a0_变形-拾取 /##################
fn Lotus_morpherPickUp =
(
	if $ != undefined then
	(
		pickUpOBJArr = #()
		join pickUpOBJArr $
		
		skinBaseOBJ = pickUpOBJArr[1]
		pickUpToNum = 2
		blendshapesEffectiveChannel = 1

		if pickUpOBJArr.count >= 2 then
		(	
			if skinBaseOBJ.modifiers[#Morpher] == undefined then
			(
				addmodifier skinBaseOBJ (Morpher ())
				skinBaseOBJ.modifiers[#Morpher].Autoload_of_targets = 1
			)

			for i in 1 to pickUpOBJArr.count - 1 do 
			(
				local tempNum = 1
				for i in 1 to pickUpOBJArr.count do
				(
					try
					(
						if skinBaseOBJ[4][1][tempNum] as string == "SubAnim:__empty" then
						(
							blendshapesEffectiveChannel = tempNum
							break
						)
						else
						(
							tempNum += 1
						)
					)catch()
				)
				WM3_MC_BuildFromNode skinBaseOBJ.morpher blendshapesEffectiveChannel pickUpOBJArr[pickUpToNum]	
				WM3_MC_SetValue skinBaseOBJ.morpher blendshapesEffectiveChannel 100.0
				pickUpToNum += 1
			)
		)	
	)
)

--******/ a0_清除变形 /##################
fn Lotus_DelMorpher =
(
	local tempa = $
	
	if tempa != undefined then
	(
		local tempc = 1
		
		if tempa[1] as string == "SubAnim:Visibility"  then 
		(
			if tempa.modifiers[1] != undefined  then ( deleteModifier tempa 1 )
		)
		else
		(
			for i in 1 to tempa.count do 
			(
				if tempa[tempc].modifiers[#Morpher] != undefined then
				(
					deleteModifier tempa[tempc] tempa[tempc].modifiers[#Morpher]
				)	
				tempc = tempc + 1
			)
			local tempc = 1
		)
	)	
)

--******/ a0_交叉-拾取 /##################
fn Lotus_phasePicking = 
(
	local tempArr = $
	
	if tempArr != undefined  and mod tempArr.count 2 == 0.0 then
	(	
		local phasePickingArray = selection as array
		local baseOBJNum = 1

		clearSelection()

		for i = 1 to (phasePickingArray.count / 2) do 
		(
			local baseOBJ = phasePickingArray[baseOBJNum]
			local facialOBJ = phasePickingArray[baseOBJNum + 1]

			select baseOBJ
			selectMore facialOBJ
			try( Lotus_morpherPickUp() )catch()
			
			baseOBJNum += 2
			i += 1
			clearSelection()
		)
	)
)

--******/ a0_渐进-拾取 /##################
fn Lotus_quickPickProgressiveMorpher =
(
	local temp = $
	
	if temp != undefined then
	(
		local quickPickFacialArray = selection as array
		local baseOBJ = quickPickFacialArray[1]
		deleteItem quickPickFacialArray 1
		Lotus_Array_ModX(quickPickFacialArray) --根据X轴位置规律排列数组里的物体

		local tempCountNum = 1
		local modifiersPassageCount = 1

		if baseOBJ.modifiers[#Morpher] as string != "Morpher:Morpher"and quickPickFacialArray.count < 23 then
		(
			addmodifier baseOBJ (Morpher ()) 
			baseOBJ.modifiers[#Morpher].Autoload_of_targets = 1
				
			WM3_MC_BuildFromNode baseOBJ.morpher modifiersPassageCount quickPickFacialArray[1]
					
			for i in 1 to quickPickFacialArray.count - 1 do
			(
				tempCountNum += 1
				WM3_AddProgressiveMorphNode baseOBJ.morpher modifiersPassageCount quickPickFacialArray[tempCountNum]
			)	
		)
		else
		(
			for i in 1 to 98 do
			(
				if baseOBJ.modifiers[#Morpher][tempCountNum] as string == "SubAnim:__empty" then 
				(
					break
				)
				else
				(
					tempCountNum += 1
				)
			)
			
			modifiersPassageCount = tempCountNum
			tempCountNum = 1

			WM3_MC_BuildFromNode baseOBJ.morpher modifiersPassageCount quickPickFacialArray[1]	
			
			for i in 1 to quickPickFacialArray.count - 1 do
			(
				tempCountNum += 1
				WM3_AddProgressiveMorphNode baseOBJ.morpher modifiersPassageCount quickPickFacialArray[tempCountNum]
			)	
			
			WM3_SetProgressiveMorphTension baseOBJ.morpher modifiersPassageCount 0.0
			free quickPickFacialArray
		)
	)
)

--******/ a0_顶点tool /##################
fn Lotus_OpenMirrorTools = 
(
	macros.run "PolyTools" "Symmetry_Tools"
)

--******/ a0_权重tool /##################
fn Lotus_OpenWeightTools =
(
	local temp = selection as array
	
	if temp.count == 1 then
	(
		if  temp[1].modifiers[#Skin] != undefined then
		(
			skinOps.weightTool temp[1].modifiers[#Skin]
		)
	)
)

--******/ a0_添加点 /##################
fn Lotus_addVirtualPoint =
(
	local _selectionTemp = $
	
	if _selectionTemp == undefined then 
	(
		local tempPoint = Point transform:( matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0] ) isSelected:on size:7 box:on cross:off centermarker:off axistripod:off drawontop:off constantscreensize:off 
		select tempPoint
	)
	else
	(
		local temp_a_1
		local temp_a_2
		
		if abs(_selectionTemp.max.X - _selectionTemp.min.X) > abs(_selectionTemp.max.Y - _selectionTemp.min.Y) then
		(
			temp_a_1 = _selectionTemp.max.X
			temp_a_2 = _selectionTemp.min.X
		)
		else
		(
			temp_a_1 = _selectionTemp.max.Y
			temp_a_2 = _selectionTemp.min.Y
		)
		if abs(temp_a_1 - temp_a_2) < abs(_selectionTemp.max.Z - _selectionTemp.min.Z) then 
		(
			temp_a_1 = _selectionTemp.max.X
			temp_a_2 = _selectionTemp.min.X
		)
		
		local _theScaleX = (temp_a_1 - temp_a_2)/70
			
		if classOf _selectionTemp == point then
		(
			local tempSize = _selectionTemp.size
			local newPoint = copy _selectionTemp
			newPoint.size = tempSize * 0.9
			newPoint.parent = _selectionTemp
			select newPoint
		)	
		else
		(
			local tempPoint = Point transform:( matrix3 [1,0,0] [0,0,1] [0,-1,0] (_selectionTemp.pos) ) isSelected:on size:(7 * _theScaleX) box:on
			select tempPoint
		)
	)
)

/*
--#######/ a0_交替增加 /##################  (暂停使用)
fn Lotus_crossAddNewPoint = 
(	
	local temp = $
	
	if temp != undefined and temp[1] as string != "SubAnim:Visibility" and temp.count == 2 then
	(
		local h_e_point = selection as array
		local homePoint = h_e_point[1]
		local endPoint = h_e_point[2]
		
		select endPoint
		local newEndPoint = copy $
		
		local tempPos = homePoint.pos - endPoint.pos
		newEndPoint.pos += tempPos * -1

		newEndPoint.parent = endPoint
		select endPoint
		selectmore newEndPoint
	)
)
*/

--#############################################################################################################################################--
--#####################################################         /模型/          ###############################################################--
--#############################################################################################################################################--
--#######/ mx_合并模型 /##################
fn Lotus_combinePoly = 
(
	selectOBJarray = selection as array 
	convertTo selectOBJarray Editable_Poly
	theBaseOBJ = selectOBJarray[1]
	for i = 2 to selectOBJarray.count do
	(
		theBaseOBJ.EditablePoly.attach selectOBJarray[i] theBaseOBJ
	)
	try( $.pivot = [0,0,0] )catch()
	
	try
	(
		t=trackviewnodes;n=t[#Max_MotionClip_Manager];deleteTrackViewController t n.controller
		(getproperty trackviewnodes.Anim_Layer_Control_Manager.controller #animlayers).count=0
	)
	catch()
)

--#######/ mx_炸开模型 /##################
fn Lotus_explodedElement = 
(
	selectOBJ = (selection as array)[1]
	if (classof selectOBJ) == Editable_Poly then 
	(
		max modify mode
		subobjectLevel = 4
		for i = 1 to 100000 do
		(
			selectOBJ.SetSelection #Face #{1}
			selectOBJ.ConvertSelection #Face #Element
			if (selectOBJ.ConvertSelection #Face #Element) == 0 then
			( 
				exit ;
			)	
			else
			(
				selectOBJ.EditablePoly.ConvertSelection #Face #Edge
				polyop.detachEdges selectOBJ (polyop.getEdgeSelection selectOBJ) delete:true asNode:true name:selectOBJ.name
			)
			try( $.pivot = [0,0,0] )catch()
		)
		
		delete selectOBJ
		
		try
		(
			t=trackviewnodes;n=t[#Max_MotionClip_Manager];deleteTrackViewController t n.controller
			(getproperty trackviewnodes.Anim_Layer_Control_Manager.controller #animlayers).count=0
		)
		catch()
	)
)

--#######/ mx_分离模型 /##################
fn Lotus_detachElement = 
(
	selectOBJ = (selection as array)[1]
	if (classof selectOBJ) == Editable_Poly then 
	(
		try
		(
			polyop.detachFaces selectOBJ (polyop.getFaceSelection selectOBJ) delete:true asNode:true name:"temp_detachElement_000"		
			$.pivot = [0,0,0]
		)catch()
	)
)

--#######/  mx_建模工具组 /##################
try( destroydialog Lotus_modelToolComponents )catch()
--------------------------------------------------------------------------------------------------------
fn Lotus_MTC_pickButton_PushAndPull =
(
	max modify mode
	try( uiaccessor.pressbutton (windows.getchildhwnd #max "Push/Pull" )[1] )catch()
)

--------------------------------------------------------------------------------------------------------
fn Lotus_MTC_pickButton_Relax =
(
	max modify mode
	try( uiaccessor.pressbutton (windows.getchildhwnd #max "Relax" )[1] )catch()
)

--------------------------------------------------------------------------------------------------------
fn Lotus_MTC_pickButton_BrushOptions =
(
	max modify mode
	try( uiaccessor.pressbutton (windows.getchildhwnd #max "Brush Options" )[1] )catch()
)

--------------------------------------------------------------------------------------------------------
fn Lotus_relax =
(
	if subobjectLevel == 1 then( $.Relax()	)else( $.EditablePoly.Relax () )
)

--------------------------------------------------------------------------------------------------------
rollout Lotus_modelToolComponents "建模工具组" width:161 height:452
(
	groupBox 'grp1' "Soft Selection" pos:[6,5] width:149 height:83 align:#left
		button 'btn1_1' "Shrink" pos:[12,25] width:67 height:26 align:#left
		button 'btn1_2' "Grow" pos:[82,25] width:67 height:26 align:#left
		button 'btn1_3' "Ring" pos:[13,55] width:67 height:26 align:#left
		button 'btn1_4' "Loop" pos:[83,55] width:67 height:26 align:#left

	checkbox 'chk2' " Preserve UVs" pos:[19,92] width:140 height:18
	
	groupBox 'grp3' "Sort Selection" pos:[6,118] width:149 height:154 align:#left
		checkbox 'chk3_1' "Use Soft Selection" pos:[14,143] width:132 height:18 align:#left
		checkbox 'chk3_2' "Edge Distance:" pos:[19,165] width:90 height:18 align:#left
			spinner 'spn3_3' "" pos:[110,165] width:36 height:16 range:[1,20000,0] scale:1 align:#left 
		spinner 'spn3_4' "Falloff:      " pos:[18,195] width:100 height:16 range:[0,20000,20] scale:0.01 align:#left 
		spinner 'spn3_5' "Pinch:        " pos:[18,217] width:100 height:16 range:[0,20000,0] scale:0.01 align:#left
		spinner 'spn3_6' "Bubble:     " pos:[18,239] width:100 height:16 range:[0,20000,0] scale:0.01 align:#left
	
	button 'btn4_1' "Relax" pos:[5,275] width:81 height:25 align:#left
	button 'btn4_2' "Sym_Tools" pos:[89,275] width:66 height:25 align:#left
	
	groupBox 'grp5' "Paint Deformation" pos:[6,304] width:149 height:142 align:#left
		button 'btn5_1' "Push/Pull" pos:[13,324] width:67 height:35 align:#left
		button 'btn5_2' "Relax" pos:[82,324] width:67 height:35 align:#left
		spinner 'spn5_3' "Brush Size:         " pos:[15,367] width:100 height:16 range:[0,200,20] scale:0.01 align:#left
		spinner 'spn5_4' "Brush Strength:  " pos:[15,387] width:100 height:16 range:[-5,5,0.50] scale:0.01 align:#left
			button 'btn5_5' "Brush Options" pos:[12,412] width:138 height:25 align:#left
			
	/*groupBox*/
		/*button*/on btn1_1 pressed do with undo on ( try ($.ShrinkSelection())catch() )	
		/*button*/on btn1_2 pressed do with undo on ( try ($.GrowSelection())catch() )	
		/*button*/on btn1_3 pressed do with undo on ( try ($.SelectEdgeRing())catch() )	
		/*button*/on btn1_4 pressed do with undo on ( try ($.SelectEdgeLoop())catch() )	
			
	/*checkbox*/on chk2 changed theState do with undo on ( if chk2.checked == true then ( try ($.preserveUVs = on )catch() )else( try ($.preserveUVs = off )catch() ))	
		
	/*groupBox*/
		/*checkbox*/on chk3_1 changed theState do with undo on ( try(if chk3_1.checked == true then ( $.useSoftSel = true )else( $.useSoftSel = false ))catch() )	
		/*checkbox*/on chk3_2 changed theState do with undo on ( try(if chk3_2.checked == true then ( $.ssUseEdgeDist = true )else( $.ssUseEdgeDist = false ))catch() )
			/*spinner*/on spn3_3 changed theState do with undo on ( try( $.ssEdgeDist = spn3_3.Value )catch() )
		/*spinner*/on spn3_4 changed theState do with undo on ( try( $.falloff = spn3_4.Value )catch() )
		/*spinner*/on spn3_5 changed theState do with undo on ( try( $.pinch = spn3_5.Value )catch() )
		/*spinner*/on spn3_6 changed theState do with undo on ( try( $.bubble = spn3_6.Value )catch() )
	
	/*button*/on btn4_1 pressed do with undo on ( try ( Lotus_relax() )catch() )
	/*button*/on btn4_2 pressed do with undo on ( macros.run "PolyTools" "Symmetry_Tools" )	
	
	/*groupBox*/
		/*button*/on btn5_1 pressed do with undo on ( Lotus_MTC_pickButton_PushAndPull() )
		/*button*/on btn5_2 pressed do with undo on ( Lotus_MTC_pickButton_Relax() )
		/*spinner*/on spn5_3 changed theState do with undo on ( try( $.paintDeformSize = spn5_3.Value )catch() )
		/*spinner*/on spn5_4 changed theState do with undo on ( try( $.paintDeformStrength = spn5_4.Value )catch() )
			/*button*/on btn5_5 pressed do with undo on ( Lotus_MTC_pickButton_BrushOptions() ) 
 )	

 --#######/  mx_模型检查5边面 /##################
fn Lotus_checkModelFireFace = 
(
	baseOBJ = (selection as array)[1]
	fireVertexFaceNum = #()
	polyop.getNumFaces baseOBJ 	
	for i = 1 to (polyop.getNumFaces baseOBJ) do
	(
		baseOBJ.EditablePoly.SetSelection #Face #{i}
		if (baseOBJ.EditablePoly.ConvertSelection #Face #Vertex) > 4 then( append fireVertexFaceNum i )
	)	
	if fireVertexFaceNum.count != 0 then
	(
		try( baseOBJ.EditablePoly.SetSelection #Face ( fireVertexFaceNum as BitArray ) ;subobjectLevel = 4)catch()
		print ("注意！该模型有五边面")
	)
	else
	(
		print ("模型通过")
		clearSelection()
	)
)

 --#######/  mx_合并带蒙皮的模型 /##################
fn LTZ_mergeSkinPoly =
(
	selArray = selection as array
	maxOps.cloneNodes selArray cloneType:#copy newNodes:&copyArray
	select copyArray
	Lotus_combinePoly()
	baseObj = selection[1]
	max modify mode
	addmodifier baseObj (Skin_Wrap ())
	baseObj.modifiers[#Skin_Wrap].falloff = 8
	baseObj.modifiers[#Skin_Wrap].distance = 0.06
	baseObj.modifiers[#Skin_Wrap].faceLimit = 20
	baseObj.modifiers[#Skin_Wrap].weightAllVerts = on
	baseObj.modifiers[#Skin_Wrap].meshList = selArray
	findCTS = windows.getchildhwnd #max "Convert To Skin" 
	uiaccessor.pressbutton findCTS[1]
	deleteModifier baseObj baseObj.modifiers[#Skin_Wrap]
	baseObj.modifiers[#Skin].filter_vertices = on
	baseObj.modifiers[#Skin].bone_Limit = 4
	baseObj.modifiers[#Skin].clearZeroLimit = 0.02	
	delete selArray
)

 --#######/  mx_分离带蒙皮的模型 /##################
fn LTZ_detachSkinPoly =
(
	baseOBJ = (selection as array)[1]
	max modify mode
	maxOps.cloneNodes baseOBJ cloneType:#copy newNodes:&copyOBJ
	copyOBJ = copyOBJ[1]
	select copyOBJ
	subobjectLevel = 4
	modPanel.setCurrentObject copyOBJ.modifiers[#Edit_Poly]
	deleteFaceArray = copyOBJ.modifiers[#Edit_Poly].getSelection #Face
	deleteModifier copyOBJ copyOBJ.modifiers[#Edit_Poly]
	modPanel.setCurrentObject copyOBJ.baseObject
	subobjectLevel = 4
	copyOBJ.EditablePoly.SetSelection #Face deleteFaceArray
	copyOBJ.EditablePoly.delete #Face
	subobjectLevel = 0
	modPanel.setCurrentObject copyOBJ.modifiers[#Skin]
	select baseOBJ
	deleteModifier baseOBJ baseOBJ.modifiers[#Edit_Poly]
	modPanel.setCurrentObject baseOBJ.baseObject
	subobjectLevel = 4
	baseOBJ.EditablePoly.SetSelection #Face deleteFaceArray
	max select invert
	baseOBJ.EditablePoly.delete #Face
	subobjectLevel = 0
	modPanel.setCurrentObject copyOBJ.modifiers[#Skin]
	select baseOBJ
	eliminateZeroBone()
	select baseOBJ
	eliminateZeroBone()
)


--#############################################################################################################################################--
--#####################################################         /绑定/          ###############################################################--
--#############################################################################################################################################--
--#######/ rig_快速蒙皮 /##################
fn Lotus_quickSkin = 
(
	selectObj = selection as array
	skinOBJ = ""
	quickSkinArray = #()
	skinOBJArray = #()
	screeningIsCompleteArr = #()
	
	if selectObj != undefined then
	(
		for i in selectObj do( if (classof i as string) == "PolyMeshObject" or (classof i as string) == "Editable_mesh" or (classof i as string) == "Editable_Poly" then( append skinOBJArray i )else( append quickSkinArray i ) )
		skinOBJ = skinOBJArray[1]
		
		if skinOBJ != undefined then
		(
			if skinOBJ.modifiers[#Skin] as string != "Skin:Skin" then 
			(
				select skinOBJ
				max modify mode
				addModifier skinOBJ (skin())
				skinOBJ.modifiers[#Skin].bone_Limit = 4
				skinOBJ.modifiers[#Skin].clearZeroLimit = 0.02
				skinOBJ.modifiers[#Skin].filter_vertices = on
				skinOBJ.modifiers[#Skin].showNoEnvelopes = on
				for i = 1 to quickSkinArray.count do ( skinOps.addbone skinOBJ.modifiers[#Skin] (getNodeByName quickSkinArray[i].name ) 1)
				skinOps.weightTool skinOBJ.modifiers[#Skin]
			)
			else
			(
				select skinOBJ			
				max modify mode
				theSkinOBJBoneNum = skinOps.GetNumberBones skinOBJ.modifiers[#Skin]
				
				for i = 1 to quickSkinArray.count do
				(
					tempName = quickSkinArray[i].name
					boneIsExistInSkin = false
					
					for o = 1 to theSkinOBJBoneNum do 
					( 
						if (skinOps.GetBoneName skinOBJ.modifiers[#Skin] o 1) == tempName then ( boneIsExistInSkin = true ) 
					)
					if boneIsExistInSkin == false then ( append screeningIsCompleteArr quickSkinArray[i] )
				)	
				screeningIsCompleteArr = makeUniqueArray screeningIsCompleteArr
				for i = 1 to screeningIsCompleteArr.count do ( skinOps.addbone skinOBJ.modifiers[#Skin] (getNodeByName screeningIsCompleteArr[i].name ) 1)
				skinOps.weightTool skinOBJ.modifiers[#Skin]
			)
		)
	)
)

/*
--#######/ rig_移除骨骼 /##################
fn Lotus_removeBone =
(
	local selectObj = selection as array
	
	if selectObj != undefined and selectObj.count == 2 then
	(
		local removeBoneArr = selection as array
		local skinOBJ = removeBoneArr[removeBoneArr.count]
		deleteItem removeBoneArr removeBoneArr.count
		select skinOBJ

		local theSkinOBJBoneNum = skinOps.GetNumberBones skinOBJ.modifiers[#Skin]
		tempName = "name"
		
		for i = 1 to removeBoneArr.count do
		(
			local tempName = removeBoneArr[i].name
			
			for ii = 1 to theSkinOBJBoneNum - 1 do
			(	
				if skinOps.GetBoneName skinOBJ.modifiers[#Skin] ii 1 == tempName then
				(	
					skinOps.RemoveBone skinOBJ.modifiers[#Skin] ii 
					break
				)
			)
		)
	)
)*/

--#######/ rig_全自动蒙皮 /##################
fn Lotus_autoSkin =
(
	try(Lotus_quickSkin())catch()
	skinOBJ = (selection as array)[1]
	select skinOBJ ;max modify mode
	sliderTime = 0f
	try
	(
		addModifier skinOBJ (DeltaMushToSkin ()) ui:on
		findCTS = windows.getchildhwnd #max "Bind with nearest bones" 
		uiaccessor.pressbutton findCTS[1]
		skinOBJ.modifiers[#DeltaMushToSkin].weight = 0.91
		skinOBJ.modifiers[#DeltaMushToSkin].iter = 39
		findCTS = windows.getchildhwnd #max "Create input animation" 
		uiaccessor.pressbutton findCTS[1]
		skinOBJ.modifiers[#DeltaMushToSkin].boneLimit = 4
		skinOBJ.modifiers[#DeltaMushToSkin].solverIterations = 6
		--skinOBJ.modifiers[#DeltaMushToSkin].solverIterations = 12
		findCTS = windows.getchildhwnd #max "Solve Skin weights" 
		uiaccessor.pressbutton findCTS[1]
		findCTS = windows.getchildhwnd #max "Replace and remove proxy" 
		uiaccessor.pressbutton findCTS[1]
	)catch()
)

--#######/ rig_骨骼命名 /##################
fn Lotus_BoneNameToolFN =
(
	try( destroydialog Lotus_BoneNameTool )catch()

	rollout Lotus_BoneNameTool "骨骼命名规范工具" width:505 height:770
	(
		button 'Pelvis' "盆骨" pos:[185,326] width:80 height:60 align:#left
		button 'Spine1' "脊椎1" pos:[202,282] width:45 height:40 align:#left
		button 'Spine2' "脊椎2" pos:[202,241] width:45 height:40 align:#left
		button 'Spine3' "脊椎3" pos:[202,200] width:45 height:40 align:#left
		button 'Ribcage' "胸骨" pos:[184,138] width:80 height:60 align:#left
		button 'Neck1' "脖子1" pos:[204,117] width:40 height:20 align:#left
		button 'Neck2' "脖子2" pos:[204,95] width:40 height:20 align:#left
		button 'Head' "头" pos:[184,52] width:80 height:40 align:#left
		button 'Head_ed' "头e" pos:[184,32] width:80 height:20 align:#left
		on 'Pelvis' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Pelvis.name )catch() )
		on 'Spine1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Spine1.name ;max select child)catch() )
		on 'Spine2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Spine2.name ;max select child)catch() )
		on 'Spine3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Spine3.name ;max select child)catch() )
		on 'Ribcage' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Ribcage.name )catch() )
		on 'Neck1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Neck1.name ;max select child)catch() )
		on 'Neck2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Neck2.name )catch() )
		on 'Head' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Head.name )catch() )
		on 'Head_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Head_ed.name ;max select child)catch() )
		
			button 'RCollarbone' "右锁骨" pos:[87,140] width:70 height:20 align:#left
			button 'RUpperarm' "右大臂" pos:[61,153] width:45 height:65 align:#left
			button 'RForearm' "右小臂" pos:[61,220] width:45 height:65 align:#left
			button 'RPalm' "右手掌" pos:[56,290] width:60 height:60 align:#left
				button 'RH_thumb_st' "拇s" pos:[122,295] width:25 height:20 align:#left
				button 'RH_thumb1' "拇1" pos:[122,315] width:25 height:20 align:#left
				button 'RH_thumb2' "拇2" pos:[123,335] width:25 height:20 align:#left
				button 'RH_thumb3' "拇3" pos:[123,355] width:25 height:20 align:#left
				button 'RH_thumb_ed' "拇e" pos:[123,375] width:25 height:20 align:#left
				button 'RH_index_st' "食s" pos:[100,365] width:20 height:20 align:#left
				button 'RH_index1' "食1" pos:[100,385] width:20 height:20 align:#left
				button 'RH_index2' "食2" pos:[100,405] width:20 height:20 align:#left
				button 'RH_index3' "食3" pos:[100,425] width:20 height:20 align:#left
				button 'RH_index_ed' "食e" pos:[100,445] width:20 height:20 align:#left
				button 'RH_middle_st' "中s" pos:[77,365] width:20 height:20 align:#left
				button 'RH_middle1' "中1" pos:[77,385] width:20 height:20 align:#left
				button 'RH_middle2' "中2" pos:[77,405] width:20 height:20 align:#left
				button 'RH_middle3' "中3" pos:[77,425] width:20 height:20 align:#left
				button 'RH_middle_ed' "中e" pos:[77,445] width:20 height:20 align:#left
				button 'RH_ring_st' "无s" pos:[53,365] width:20 height:20 align:#left
				button 'RH_ring1' "无1" pos:[53,385] width:20 height:20 align:#left
				button 'RH_ring2' "无2" pos:[53,405] width:20 height:20 align:#left
				button 'RH_ring3' "无3" pos:[53,425] width:20 height:20 align:#left
				button 'RH_ring_ed' "无e" pos:[53,445] width:20 height:20 align:#left
				button 'RH_little_st' "小s" pos:[28,335] width:20 height:20 align:#left
				button 'RH_little1' "小1" pos:[28,355] width:20 height:20 align:#left
				button 'RH_little2' "小2" pos:[28,375] width:20 height:20 align:#left
				button 'RH_little3' "小3" pos:[28,395] width:20 height:20 align:#left
				button 'RH_little_ed' "小e" pos:[28,415] width:20 height:20 align:#left
			on 'RCollarbone' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RCollarbone.name )catch() )
			on 'RUpperarm' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RUpperarm.name )catch() )
			on 'RForearm' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RForearm.name )catch() )
			on 'RPalm' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RPalm.name )catch() )
				on 'RH_thumb_st' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_thumb_st.name ;max select child)catch() )
				on 'RH_thumb1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_thumb1.name ;max select child)catch() )
				on 'RH_thumb2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_thumb2.name ;max select child)catch() )
				on 'RH_thumb3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_thumb3.name ;max select child)catch() )
				on 'RH_thumb_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_thumb_ed.name )catch() )
				on 'RH_index_st' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_index_st.name ;max select child)catch() )
				on 'RH_index1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_index1.name ;max select child)catch() )
				on 'RH_index2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_index2.name ;max select child)catch() )
				on 'RH_index3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_index3.name ;max select child)catch() )
				on 'RH_index_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_index_ed.name )catch() )
				on 'RH_middle_st' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_middle_st.name ;max select child)catch() )
				on 'RH_middle1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_middle1.name ;max select child)catch() )
				on 'RH_middle2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_middle2.name ;max select child)catch() )
				on 'RH_middle3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_middle3.name ;max select child)catch() )
				on 'RH_middle_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_middle_ed.name )catch() )
				on 'RH_ring_st' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_ring_st.name ;max select child)catch() )
				on 'RH_ring1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_ring1.name ;max select child)catch() )
				on 'RH_ring2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_ring2.name ;max select child)catch() )
				on 'RH_ring3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_ring3.name ;max select child)catch() )
				on 'RH_ring_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_ring_ed.name )catch() )
				on 'RH_little_st' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_little_st.name ;max select child)catch() )
				on 'RH_little1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_little1.name ;max select child)catch() )
				on 'RH_little2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_little2.name ;max select child)catch() )
				on 'RH_little3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_little3.name ;max select child)catch() )
				on 'RH_little_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RH_little_ed.name )catch() )

			button 'LCollarbone' "左锁骨" pos:[290,140] width:70 height:20 align:#left
			button 'LUpperarm' "左大臂" pos:[342,153] width:45 height:65 align:#left
			button 'LForearm' "左小臂" pos:[342,220] width:45 height:65 align:#left
			button 'LPalm' "左手掌" pos:[338,290] width:60 height:60 align:#left
				button 'LH_thumb_st' "拇s" pos:[307,295] width:25 height:20 align:#left
				button 'LH_thumb1' "拇1" pos:[307,315] width:25 height:20 align:#left
				button 'LH_thumb2' "拇2" pos:[308,335] width:25 height:20 align:#left
				button 'LH_thumb3' "拇3" pos:[308,355] width:25 height:20 align:#left
				button 'LH_thumb_ed' "拇e" pos:[308,375] width:25 height:20 align:#left
				button 'LH_index_st' "食s" pos:[335,365] width:20 height:20 align:#left
				button 'LH_index1' "食1" pos:[335,385] width:20 height:20 align:#left
				button 'LH_index2' "食2" pos:[335,405] width:20 height:20 align:#left
				button 'LH_index3' "食3" pos:[335,425] width:20 height:20 align:#left
				button 'LH_index_ed' "食e" pos:[335,445] width:20 height:20 align:#left
				button 'LH_middle_st' "中s" pos:[358,365] width:20 height:20 align:#left
				button 'LH_middle1' "中1" pos:[358,385] width:20 height:20 align:#left
				button 'LH_middle2' "中2" pos:[358,405] width:20 height:20 align:#left
				button 'LH_middle3' "中3" pos:[358,425] width:20 height:20 align:#left
				button 'LH_middle_ed' "中e" pos:[358,445] width:20 height:20 align:#left
				button 'LH_ring_st' "无s" pos:[381,365] width:20 height:20 align:#left
				button 'LH_ring1' "无1" pos:[381,385] width:20 height:20 align:#left
				button 'LH_ring2' "无2" pos:[381,405] width:20 height:20 align:#left
				button 'LH_ring3' "无3" pos:[381,425] width:20 height:20 align:#left
				button 'LH_ring_ed' "无e" pos:[381,445] width:20 height:20 align:#left
				button 'LH_little_st' "小s" pos:[407,335] width:20 height:20 align:#left
				button 'LH_little1' "小1" pos:[407,355] width:20 height:20 align:#left
				button 'LH_little2' "小2" pos:[407,375] width:20 height:20 align:#left
				button 'LH_little3' "小3" pos:[407,395] width:20 height:20 align:#left
				button 'LH_little_ed' "小e" pos:[407,415] width:20 height:20 align:#left
			on 'LCollarbone' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LCollarbone.name )catch() )
			on 'LUpperarm' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LUpperarm.name )catch() )
			on 'LForearm' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LForearm.name )catch() )
			on 'LPalm' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LPalm.name )catch() )
				on 'LH_thumb_st' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_thumb_st.name ;max select child)catch() )
				on 'LH_thumb1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_thumb1.name ;max select child)catch() )
				on 'LH_thumb2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_thumb2.name ;max select child)catch() )
				on 'LH_thumb3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_thumb3.name ;max select child)catch() )
				on 'LH_thumb_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_thumb_ed.name )catch() )
				on 'LH_index_st' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_index_st.name ;max select child)catch() )
				on 'LH_index1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_index1.name ;max select child)catch() )
				on 'LH_index2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_index2.name ;max select child)catch() )
				on 'LH_index3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_index3.name ;max select child)catch() )
				on 'LH_index_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_index_ed.name )catch() )
				on 'LH_middle_st' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_middle_st.name ;max select child)catch() )
				on 'LH_middle1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_middle1.name ;max select child)catch() )
				on 'LH_middle2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_middle2.name ;max select child)catch() )
				on 'LH_middle3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_middle3.name ;max select child)catch() )
				on 'LH_middle_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_middle_ed.name )catch() )
				on 'LH_ring_st' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_ring_st.name ;max select child)catch() )
				on 'LH_ring1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_ring1.name ;max select child)catch() )
				on 'LH_ring2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_ring2.name ;max select child)catch() )
				on 'LH_ring3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_ring3.name ;max select child)catch() )
				on 'LH_ring_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_ring_ed.name )catch() )
				on 'LH_little_st' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_little_st.name ;max select child)catch() )
				on 'LH_little1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_little1.name ;max select child)catch() )
				on 'LH_little2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_little2.name ;max select child)catch() )
				on 'LH_little3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_little3.name ;max select child)catch() )
				on 'LH_little_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LH_little_ed.name )catch() )
			
			button 'RHip' "右胯骨" pos:[157,387] width:55 height:40 align:#left
			button 'RThigh' "右大腿" pos:[157,429] width:55 height:80 align:#left
			button 'RCalf' "右小腿" pos:[157,511] width:55 height:120 align:#left
			button 'RFoot' "右脚掌" pos:[157,637] width:55 height:80 align:#left
				button 'RF_thumb1' "拇1" pos:[128,609] width:25 height:25 align:#left
				button 'RF_thumb2' "拇2" pos:[101,609] width:25 height:25 align:#left
				button 'RF_thumb3' "拇3" pos:[74,609] width:25 height:25 align:#left
				button 'RF_thumb_ed' "拇e" pos:[47,609] width:25 height:25 align:#left
				button 'RF_index1' "食1" pos:[123,636] width:30 height:25 align:#left
				button 'RF_index2' "食2" pos:[92,636] width:30 height:25 align:#left
				button 'RF_index3' "食3" pos:[61,636] width:30 height:25 align:#left
				button 'RF_index_ed' "食e" pos:[31,636] width:30 height:25 align:#left
				button 'RF_middle1' "中1" pos:[123,664] width:30 height:25 align:#left
				button 'RF_middle2' "中2" pos:[92,664] width:30 height:25 align:#left
				button 'RF_middle3' "中3" pos:[61,664] width:30 height:25 align:#left
				button 'RF_middle_ed' "中e" pos:[31,664] width:30 height:25 align:#left
				button 'RF_ring1' "无1" pos:[123,691] width:30 height:25 align:#left
				button 'RF_ring2' "无2" pos:[92,691] width:30 height:25 align:#left
				button 'RF_ring3' "无3" pos:[61,691] width:30 height:25 align:#left
				button 'RF_ring_ed' "无e" pos:[31,691] width:30 height:25 align:#left
				button 'RF_little1' "小1" pos:[123,717] width:30 height:25 align:#left
				button 'RF_little2' "小2" pos:[92,717] width:30 height:25 align:#left
				button 'RF_little3' "小3" pos:[61,717] width:30 height:25 align:#left
				button 'RF_little_ed' "小e" pos:[31,717] width:30 height:25 align:#left
			on 'RHip' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RHip.name )catch() )
			on 'RThigh' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RThigh.name )catch() )
			on 'RCalf' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RCalf.name )catch() )
			on 'RFoot' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RFoot.name )catch() )
				on 'RF_thumb1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_thumb1.name ;max select child)catch() )
				on 'RF_thumb2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_thumb2.name ;max select child)catch() )
				on 'RF_thumb3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_thumb3.name ;max select child)catch() )
				on 'RF_thumb_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_thumb_ed.name )catch() )
				on 'RF_index1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_index1.name ;max select child)catch() )
				on 'RF_index2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_index2.name ;max select child)catch() )
				on 'RF_index3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_index3.name ;max select child)catch() )
				on 'RF_index_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_index_ed.name )catch() )
				on 'RF_middle1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_middle1.name ;max select child)catch() )
				on 'RF_middle2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_middle2.name ;max select child)catch() )
				on 'RF_middle3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_middle3.name ;max select child)catch() )
				on 'RF_middle_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_middle_ed.name )catch() )
				on 'RF_ring1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_ring1.name ;max select child)catch() )
				on 'RF_ring2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_ring2.name ;max select child)catch() )
				on 'RF_ring3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_ring3.name ;max select child)catch() )
				on 'RF_ring_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_ring_ed.name )catch() )
				on 'RF_little1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_little1.name ;max select child)catch() )
				on 'RF_little2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_little2.name ;max select child)catch() )
				on 'RF_little3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_little3.name ;max select child)catch() )
				on 'RF_little_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.RF_little_ed.name )catch() )
			
			button 'LHip' "左胯骨" pos:[240,387] width:55 height:40 align:#left
			button 'LThigh' "左大腿" pos:[240,429] width:55 height:80 align:#left
			button 'LCalf' "左小腿" pos:[240,511] width:55 height:120 align:#left
			button 'LFoot' "左脚掌" pos:[240,637] width:55 height:80 align:#left
				button 'LF_thumb1' "拇1" pos:[301,608] width:25 height:25 align:#left
				button 'LF_thumb2' "拇2" pos:[328,608] width:25 height:25 align:#left
				button 'LF_thumb3' "拇3" pos:[355,608] width:25 height:25 align:#left
				button 'LF_thumb_ed' "拇e" pos:[382,608] width:25 height:25 align:#left
				button 'LF_index1' "食1" pos:[300,635] width:30 height:25 align:#left
				button 'LF_index2' "食2" pos:[332,635] width:30 height:25 align:#left
				button 'LF_index3' "食3" pos:[362,635] width:30 height:25 align:#left
				button 'LF_index_ed' "食e" pos:[396,635] width:25 height:25 align:#left
				button 'LF_middle1' "中1" pos:[300,663] width:30 height:25 align:#left
				button 'LF_middle2' "中2" pos:[332,663] width:30 height:25 align:#left
				button 'LF_middle3' "中3" pos:[362,663] width:30 height:25 align:#left
				button 'LF_middle_ed' "中e" pos:[396,663] width:30 height:25 align:#left
				button 'LF_ring1' "无1" pos:[300,690] width:30 height:25 align:#left
				button 'LF_ring2' "无2" pos:[332,690] width:30 height:25 align:#left
				button 'LF_ring3' "无3" pos:[362,690] width:30 height:25 align:#left
				button 'LF_ring_ed' "无e" pos:[396,690] width:30 height:25 align:#left
				button 'LF_little1' "小1" pos:[300,716] width:30 height:25 align:#left
				button 'LF_little2' "小2" pos:[332,716] width:30 height:25 align:#left
				button 'LF_little3' "小3" pos:[364,716] width:30 height:25 align:#left
				button 'LF_little_ed' "小e" pos:[396,716] width:30 height:25 align:#left
			on 'LHip' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LHip.name )catch() )
			on 'LThigh' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LThigh.name )catch() )
			on 'LCalf' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LCalf.name )catch() )
			on 'LFoot' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LFoot.name )catch() )
				on 'LF_thumb1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_thumb1.name ;max select child)catch() )
				on 'LF_thumb2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_thumb2.name ;max select child)catch() )
				on 'LF_thumb3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_thumb3.name ;max select child)catch() )
				on 'LF_thumb_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_thumb_ed.name )catch() )
				on 'LF_index1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_index1.name ;max select child)catch() )
				on 'LF_index2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_index2.name ;max select child)catch() )
				on 'LF_index3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_index3.name ;max select child)catch() )
				on 'LF_index_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_index_ed.name )catch() )
				on 'LF_middle1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_middle1.name ;max select child)catch() )
				on 'LF_middle2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_middle2.name ;max select child)catch() )
				on 'LF_middle3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_middle3.name ;max select child)catch() )
				on 'LF_middle_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_middle_ed.name )catch() )
				on 'LF_ring1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_ring1.name ;max select child)catch() )
				on 'LF_ring2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_ring2.name ;max select child)catch() )
				on 'LF_ring3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_ring3.name ;max select child)catch() )
				on 'LF_ring_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_ring_ed.name )catch() )
				on 'LF_little1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_little1.name ;max select child)catch() )
				on 'LF_little2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_little2.name ;max select child)catch() )
				on 'LF_little3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_little3.name ;max select child)catch() )
				on 'LF_little_ed' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LF_little_ed.name )catch() )
				
		button 'Tail1' "尾巴1" pos:[424,486] width:55 height:27 align:#left
		button 'Tail2' "尾巴2" pos:[424,515] width:55 height:27 align:#left
		button 'Tail3' "尾巴3" pos:[424,544] width:55 height:27 align:#left
		button 'Tail4' "尾巴4" pos:[424,573] width:55 height:27 align:#left
		button 'Tail5' "尾巴5" pos:[424,601] width:55 height:27 align:#left
			on 'Tail1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Tail1.name )catch() )
			on 'Tail2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Tail2.name )catch() )
			on 'Tail3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Tail3.name )catch() )
			on 'Tail4' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Tail4.name )catch() )
			on 'Tail5' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Tail5.name )catch() )
		
		button 'REar1' "右耳1" pos:[142,20] width:40 height:20 align:#left
		button 'REar2' "右耳2" pos:[101,20] width:40 height:20 align:#left
		button 'REar3' "右耳3" pos:[60,20] width:40 height:20 align:#left
		button 'REar4' "右耳4" pos:[19,20] width:40 height:20 align:#left
			on 'REar1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.REar1.name )catch() )
			on 'REar2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.REar2.name )catch() )
			on 'REar3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.REar3.name )catch() )
			on 'REar4' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.REar4.name )catch() )
		
		button 'LEar1' "左耳1" pos:[266,21] width:40 height:20 align:#left
		button 'LEar2' "左耳2" pos:[307,21] width:40 height:20 align:#left
		button 'LEar3' "左耳3" pos:[348,21] width:40 height:20 align:#left
		button 'LEar4' "左耳4" pos:[389,21] width:40 height:20 align:#left
			on 'LEar1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LEar1.name )catch() )
			on 'LEar2' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LEar2.name )catch() )
			on 'LEar3' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LEar3.name )catch() )
			on 'LEar4' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LEar4.name )catch() )
		
		button 'REye1' "右眼" pos:[405,76] width:30 height:25 align:#left
		button 'LEye1' "左眼" pos:[454,76] width:30 height:25 align:#left
		button 'Nose' "鼻" pos:[430,108] width:30 height:25 align:#left
		button 'Jaw' "下颚" pos:[428,140] width:35 height:25 align:#left
			on 'REye1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.REye1.name )catch() )
			on 'LEye1' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.LEye1.name )catch() )
			on 'Nose' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Nose.name )catch() )
			on 'Jaw' pressed do with undo on ( try( (selection as array)[1].name = Lotus_BoneNameTool.Jaw.name )catch() )
		
		button 'bt00' ">>重命名工具<<" pos:[20,520] width:105 height:50 align:#left
			on 'bt00' pressed do with undo on ( try( macros.run "Tools" "RenameObjects" )catch() )
	)

	createdialog Lotus_BoneNameTool pos:[1100,130]
)

--#######/ rig_跟随命名 /##################

fn Lotus_NewREname = 
(
	selectPointREname = selection as array 
	for i = 1 to (selectPointREname.count - 1) do 
	(
		selectPointREname[i].name = (selectPointREname[selectPointREname.count]).name + "_" + (i as string)
	)
)

--#######/ rig_修正表情 /##################

fn Lotus_RepairFacial =
(
	local tempArr = $
	
	if tempArr != undefined and tempArr.count >= 3 then
	(
		local repairFacial = tempArr[1]
		local baseFacial = tempArr[2]
		local baseFacial_to = undefined
		
		if tempArr.count >= 4 then 
		(
			local tempCount = 3
			
			addmodifier baseFacial (Morpher ())
			baseFacial.modifiers[#Morpher].Autoload_of_targets = 1	
				
			for i in 1 to tempArr.count - 2 do
			(			
				local baseFacial_to = tempArr[tempCount]
				
				copyObj1 = copy repairFacial
				copyObj1.pos = baseFacial.pos

				addmodifier copyObj1 (Skin_Wrap ())
				copyObj1.modifiers[#Skin_Wrap].falloff = 10
				copyObj1.modifiers[#Skin_Wrap].distance = 0.01
				copyObj1.modifiers[#Skin_Wrap].weightAllVerts = on
				copyObj1.modifiers[#Skin_Wrap].meshList = #(baseFacial)
				WM3_MC_BuildFromNode baseFacial.morpher 1 baseFacial_to
				
				max time start
				WM3_MC_SetValue baseFacial.morpher 1 0.0
				set animate on
				sliderTime = 30f
				WM3_MC_SetValue baseFacial.morpher 1 100.0
				set animate off
				max time start
				sliderTime = 30f
				
				convertTo copyObj1 Editable_Poly
				copyObj1.pos = baseFacial_to.pos
				move copyObj1 [0,0,-200]
				copyObj1.name = baseFacial_to.name	
				
				tempCount = tempCount + 1	
				max time start
			 )
				 
			local tempCount = 3
			deleteModifier baseFacial 1				
		)
		else
		(
			local baseFacial_to = tempArr[3]
			
			copyObj1 = copy repairFacial
			copyObj1.pos = baseFacial.pos

			addmodifier copyObj1 (Skin_Wrap ())
			copyObj1.modifiers[#Skin_Wrap].falloff = 10
			copyObj1.modifiers[#Skin_Wrap].distance = 0.01
			copyObj1.modifiers[#Skin_Wrap].weightAllVerts = on
			copyObj1.modifiers[#Skin_Wrap].meshList = #(baseFacial)
			addmodifier baseFacial (Morpher ())
			baseFacial.modifiers[#Morpher].Autoload_of_targets = 1	
			WM3_MC_BuildFromNode baseFacial.morpher 1 baseFacial_to
			
			max time start
			WM3_MC_SetValue baseFacial.morpher 1 0.0
			set animate on
			sliderTime = 30f
			WM3_MC_SetValue baseFacial.morpher 1 100.0
			set animate off
			max time start
			sliderTime = 30f
			
			convertTo copyObj1 Editable_Poly
			copyObj1.pos = baseFacial_to.pos
			move copyObj1 [0,0,-200]
			copyObj1.name = baseFacial_to.name	
			
			deleteModifier baseFacial 1	
			max time start
		 )
	)
)

--#######/ rig_镜像表情 /##################
fn Lotus_FacialMirror = 
(	
	local tempArr = $
	
	if tempArr != undefined  then
	(		
		if tempArr.count == 2 then
		(
			local mirrorFacial = tempArr[2]
			local baseFacial = tempArr[1]
			
			local temp_a = random 0 99 as string
			local temp_b = random 0 99 as string
			local temp_c = random 0 99 as string
			local temp_d = random 0 99 as string
			local temp_e = random 0 99 as string
			local randNameNum = temp_a + temp_b + temp_c + temp_d + temp_e
			
			maxOps.cloneNodes baseFacial cloneType:#copy newNodes:&copyObj1
			copyObj1.name = "_temp_mirrorFacial_"
			copyObj1.pos = baseFacial.position
			
			scale $_temp_mirrorFacial_ [-1,1,1]
			addmodifier $_temp_mirrorFacial_ (Skin_Wrap ())
			$_temp_mirrorFacial_.modifiers[#Skin_Wrap].falloff = 0.001
			$_temp_mirrorFacial_.modifiers[#Skin_Wrap].distance = 0.001
			$_temp_mirrorFacial_.modifiers[#Skin_Wrap].faceLimit = 30
			$_temp_mirrorFacial_.modifiers[#Skin_Wrap].weightAllVerts = on
			$_temp_mirrorFacial_.modifiers[#Skin_Wrap].meshList = #(baseFacial)
			
			addmodifier baseFacial (Morpher ())
			baseFacial.modifiers[#Morpher].Autoload_of_targets = 1
			WM3_MC_BuildFromNode baseFacial.morpher 1 mirrorFacial
			
			max time start
			WM3_MC_SetValue baseFacial.morpher 1 0.0
			set animate on
			sliderTime = 5f
			WM3_MC_SetValue baseFacial.morpher 1 100.0
			set animate off
			max time start
			sliderTime = 5f
			
			convertTo $_temp_mirrorFacial_ Editable_Poly
			$_temp_mirrorFacial_.pos = mirrorFacial.pos
			move $_temp_mirrorFacial_ [80,0,0]
			scale $_temp_mirrorFacial_ [-1,1,1]
			deleteModifier baseFacial 1	
			max time start
			clearSelection()
			$_temp_mirrorFacial_.name = $_temp_mirrorFacial_.name + randNameNum
		)
	)
)

--#######/ rig_蒙皮继承 /##################
fn Lotus_SkinReplace = 
(
	local temp = $
	
	if temp != undefined then
	(
		local tempArr = #()
		join tempArr $
		
		if tempArr.count == 2 then
		(
			local skinReOBJ = tempArr[1]
			local baseOBJ = tempArr[2]
			
			skinReOBJ.pos.X = baseOBJ.pos.X
			
			addmodifier skinReOBJ (Skin_Wrap ())
			skinReOBJ.modifiers[#Skin_Wrap].falloff = 8
			skinReOBJ.modifiers[#Skin_Wrap].distance = 0.06
			skinReOBJ.modifiers[#Skin_Wrap].faceLimit = 20
			skinReOBJ.modifiers[#Skin_Wrap].weightAllVerts = on
			skinReOBJ.modifiers[#Skin_Wrap].meshList = #(baseOBJ)
			skinReOBJ.modifiers[#Skin_Wrap].Blend = on
			skinReOBJ.modifiers[#Skin_Wrap].blendDistance = 5.5
			select skinReOBJ
			max modify mode
			findCTS = windows.getchildhwnd #max "Convert To Skin" 
			uiaccessor.pressbutton findCTS[1]
			deleteModifier skinReOBJ skinReOBJ.modifiers[#Skin_Wrap]
			skinReOBJ.modifiers[#Skin].filter_vertices = on
			skinReOBJ.modifiers[#Skin].bone_Limit = 4
			skinReOBJ.modifiers[#Skin].clearZeroLimit = 0.02	

			skinReOBJ.name = baseOBJ.name
			delete baseOBJ
			clearSelection()
		)
	)
)

--#######/ rig_绑定表情2.0 /##################
temp_facialLC_PATH = theServerAddress_ + "Lotus_Plugin\\控制器样式\\"
fn Lotus_FreeFacialModTool_getMorNum theSel =   
(
	blendshapesEffectiveChannel = undefined
	if theSel.modifiers[#Morpher] == undefined then 
	( 	
		addmodifier theSel ( Morpher () )
		theSel.modifiers[#Morpher].Autoload_of_targets = 1 
	)
	for i = 1 to 100 do ( if theSel.modifiers[#Morpher][i] as string == "SubAnim:__empty" do( blendshapesEffectiveChannel = i ;exit ))
	blendshapesEffectiveChannel
)

fn Lotus_FreeFacialModTool_reNameAddNum =   
(
	tempArray = $FrFaMo_lc*
	theBigNum = 1
	
	for i = 1 to ( tempArray.count ) do
	(
		theNumA = (filterString tempArray[i].name "FrFaMo_lc")[1] as integer
		if theNumA >= theBigNum then ( theBigNum = theNumA ;theBigNum += 1 )
	)
	theBigNum
)

fn Lotus_FreeFacialModTool_TOhideLayer theNode =   
(
	try( layerTOhide = layermanager.newLayerFromName "hide")catch()
	layerTOhide = layermanager.getLayerFromName "hide"
	layerTOhide.addnode theNode
)

rollout Lotus_FreeFacialModTool "FreeFacialModTool" width:284 height:170
(
	radiobuttons 'rad1' pos:[11,143] labels:#("10", "5", "20","1") default:2
	Button 'btn1' "十字型" pos:[12,13] width:120 height:120 align:#left
	Button 'btn2' "上" pos:[191,11] width:40 height:40 align:#left
	Button 'btn3' "下" pos:[191,93] width:40 height:40 align:#left
	Button 'btn4' "左" pos:[150,52] width:40 height:40 align:#left
	Button 'btn5' "右" pos:[232,51] width:40 height:40 align:#left
	Button 'btn5_1' "右上" pos:[232,11] width:40 height:40 align:#left
	Button 'btn6' "上下" pos:[150,93] width:40 height:40 align:#left
	Button 'btn7' "左右" pos:[232,93] width:40 height:40 align:#left
	Button 'btn8' "口型" pos:[191,52] width:40 height:40 align:#left
	Button 'btn9' "控制器替换" pos:[160,138] width:100 height:25 align:#left
	
	on btn1 pressed do
	(
		if (selection as array)[1] != undefined and (superclassof (selection as array)[1]) == GeometryClass then
		(
			COENum = (Lotus_FreeFacialModTool_reNameAddNum()) as string
			theBaseOBJ = (selection as array)[1]
			COEff = ((theBaseOBJ.max.x - theBaseOBJ.min.x)*(theBaseOBJ.max.y - theBaseOBJ.min.y))/3236.29
			
			a = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , 0 , 40 * COEff]) isSelected:on
			a_1 = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , -15, 40 * COEff]) isSelected:on 
			a.wirecolor = color 0 0 0
			Lotus_FreeFacialModTool_TOhideLayer a
			try( mergeMAXFile (temp_facialLC_PATH + "LOTUS_fra_RULD.max") )catch()
			$LOTUS_fra_RULD.pos = a_1.pos
			delete a_1
			a_1 = $LOTUS_fra_RULD
			a_1.parent = a
			a.name = "FrFaMo_lc" + COENum 
			a_1.name = "FrFaMo" + COENum
			
			Lotus_FreezeTransform a_1
			
			num = 5
			case of
			(
				(Lotus_FreeFacialModTool.rad1.state == 1): num = 10
				(Lotus_FreeFacialModTool.rad1.state == 2): num = 5
				(Lotus_FreeFacialModTool.rad1.state == 3): num = 20
				(Lotus_FreeFacialModTool.rad1.state == 4): num = 1
			)
			Lotus_FreeFacialModTool_backNum = num
			
			a_1[3][1][2][1].controller = float_limit ()
			a_1[3][1][2][1].controller.upper_limit = Lotus_FreeFacialModTool_backNum
			a_1[3][1][2][1].controller.lower_limit = Lotus_FreeFacialModTool_backNum * -1
			a_1[3][1][2][2].controller = float_limit ()
			a_1[3][1][2][2].controller.upper_limit = Lotus_FreeFacialModTool_backNum
			a_1[3][1][2][2].controller.lower_limit = Lotus_FreeFacialModTool_backNum * -1
			a_1[3][1][2][3].controller = float_limit ()
			a_1[3][1][2][3].controller.upper_limit = 0
			a_1[3][1][2][3].controller.lower_limit = 0
				
			tempOBJ_R = copy theBaseOBJ
			try (deleteModifier tempOBJ_R 1;deleteModifier tempOBJ_R 1)catch()
			tempOBJ_R.pos = [200 * COEff , -15 , 120 * COEff]
			tempOBJ_U = copy tempOBJ_R
			tempOBJ_U.pos = [tempOBJ_R.pos.x - (50 * COEff) , tempOBJ_R.pos.y , tempOBJ_R.pos.z + (50 * COEff)]
			tempOBJ_L = copy tempOBJ_R
			tempOBJ_L.pos = [tempOBJ_R.pos.x - (100 * COEff) , tempOBJ_R.pos.y , tempOBJ_R.pos.z]
			tempOBJ_D = copy tempOBJ_R
			tempOBJ_D.pos = [tempOBJ_R.pos.x - (50 * COEff) , tempOBJ_R.pos.y , tempOBJ_R.pos.z - (50 * COEff)]
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_R
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum ( COENum as string + "_RULD_R" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][1]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*" + ((100.0/Lotus_FreeFacialModTool_backNum)-0.01)as string + ",0)")
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_U
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum ( COENum as string + "_RULD_U" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*" + ((100.0/Lotus_FreeFacialModTool_backNum)-0.01)as string + ",0)")
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_L
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum ( COENum as string + "_RULD_L" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][1]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a<0,a*" + (((100.0/Lotus_FreeFacialModTool_backNum)-0.01)* -1 )as string + ",0)")
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_D
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum ( COENum as string + "_RULD_D" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a<0,a*" + (((100.0/Lotus_FreeFacialModTool_backNum)-0.01)* -1 )as string + ",0)")
			select a
		)
	)
	
	on btn2 pressed do
	(
		if (selection as array)[1] != undefined and (superclassof (selection as array)[1]) == GeometryClass then
		(
			COENum = (Lotus_FreeFacialModTool_reNameAddNum()) as string
			theBaseOBJ = (selection as array)[1]
			COEff = ((theBaseOBJ.max.x - theBaseOBJ.min.x)*(theBaseOBJ.max.y - theBaseOBJ.min.y))/3236.29

			a = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , 0 , 40 * COEff]) isSelected:on
			a_1 = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , -15, 40 * COEff]) isSelected:on 
			a.wirecolor = color 0 0 0
			Lotus_FreeFacialModTool_TOhideLayer a
			try( mergeMAXFile (temp_facialLC_PATH + "LOTUS_fra_U.max") )catch()
			$LOTUS_fra_U.pos = a_1.pos
			delete a_1
			a_1 = $LOTUS_fra_U
			a_1.parent = a
			a.name = "FrFaMo_lc" + COENum 
			a_1.name = "FrFaMo" + COENum
			
			Lotus_FreezeTransform a_1
				
			num = 5
			case of
			(
				(Lotus_FreeFacialModTool.rad1.state == 1): num = 10
				(Lotus_FreeFacialModTool.rad1.state == 2): num = 5
				(Lotus_FreeFacialModTool.rad1.state == 3): num = 20
				(Lotus_FreeFacialModTool.rad1.state == 4): num = 1
			)
			Lotus_FreeFacialModTool_backNum = num
			
			a_1[3][1][2][1].controller = float_limit ()
			a_1[3][1][2][1].controller.upper_limit = 0
			a_1[3][1][2][1].controller.lower_limit = 0
			a_1[3][1][2][2].controller = float_limit ()
			a_1[3][1][2][2].controller.upper_limit = Lotus_FreeFacialModTool_backNum
			a_1[3][1][2][2].controller.lower_limit = 0
			a_1[3][1][2][3].controller = float_limit ()
			a_1[3][1][2][3].controller.upper_limit = 0
			a_1[3][1][2][3].controller.lower_limit = 0
			
			tempOBJ_R = copy theBaseOBJ
			try (deleteModifier tempOBJ_R 1;deleteModifier tempOBJ_R 1)catch()
			tempOBJ_R.pos = [200 * COEff , -15 , 120 * COEff]
			tempOBJ_U = copy tempOBJ_R
			tempOBJ_U.pos = [tempOBJ_R.pos.x - (50 * COEff) , tempOBJ_R.pos.y , tempOBJ_R.pos.z + (50 * COEff)]
			delete tempOBJ_R
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_U
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum ( COENum as string + "_U" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*" + ((100.0/Lotus_FreeFacialModTool_backNum)-0.01)as string + ",0)")
			select a
		)
	)
	
	on btn3 pressed do
	(
		if (selection as array)[1] != undefined and (superclassof (selection as array)[1]) == GeometryClass then
		(
			COENum = (Lotus_FreeFacialModTool_reNameAddNum()) as string
			theBaseOBJ = (selection as array)[1]
			COEff = ((theBaseOBJ.max.x - theBaseOBJ.min.x)*(theBaseOBJ.max.y - theBaseOBJ.min.y))/3236.29
			
			a = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , 0 , 40 * COEff]) isSelected:on
			a_1 = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , -15, 40 * COEff]) isSelected:on 
			a.wirecolor = color 0 0 0
			Lotus_FreeFacialModTool_TOhideLayer a
			try( mergeMAXFile (temp_facialLC_PATH + "LOTUS_fra_D.max") )catch()
			$LOTUS_fra_D.pos = a_1.pos
			delete a_1
			a_1 = $LOTUS_fra_D
			a_1.parent = a
			a.name = "FrFaMo_lc" + COENum 
			a_1.name = "FrFaMo" + COENum
			
			Lotus_FreezeTransform a_1
			
			num = 5
			case of
			(
				(Lotus_FreeFacialModTool.rad1.state == 1): num = 10
				(Lotus_FreeFacialModTool.rad1.state == 2): num = 5
				(Lotus_FreeFacialModTool.rad1.state == 3): num = 20
				(Lotus_FreeFacialModTool.rad1.state == 4): num = 1
			)
			Lotus_FreeFacialModTool_backNum = num
			
			a_1[3][1][2][1].controller = float_limit ()
			a_1[3][1][2][1].controller.upper_limit = 0
			a_1[3][1][2][1].controller.lower_limit = 0
			a_1[3][1][2][2].controller = float_limit ()
			a_1[3][1][2][2].controller.upper_limit = 0
			a_1[3][1][2][2].controller.lower_limit = Lotus_FreeFacialModTool_backNum * -1
			a_1[3][1][2][3].controller = float_limit ()
			a_1[3][1][2][3].controller.upper_limit = 0
			a_1[3][1][2][3].controller.lower_limit = 0
			
			tempOBJ_R = copy theBaseOBJ
			try (deleteModifier tempOBJ_R 1;deleteModifier tempOBJ_R 1)catch()
			tempOBJ_R.pos = [200 * COEff , -15 , 120 * COEff]
			tempOBJ_D = copy tempOBJ_R
			tempOBJ_D.pos = [tempOBJ_R.pos.x - (50 * COEff) , tempOBJ_R.pos.y , tempOBJ_R.pos.z - (50 * COEff)]
			delete tempOBJ_R
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_D
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum (COENum as string + "_D" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a<0,a*" + ((-100.0/Lotus_FreeFacialModTool_backNum)-0.01)as string + ",0)")
			select a
		)
	)
	
	on btn4 pressed do
	(
		if (selection as array)[1] != undefined and (superclassof (selection as array)[1]) == GeometryClass then
		(
			COENum = (Lotus_FreeFacialModTool_reNameAddNum()) as string
			theBaseOBJ = (selection as array)[1]
			COEff = ((theBaseOBJ.max.x - theBaseOBJ.min.x)*(theBaseOBJ.max.y - theBaseOBJ.min.y))/3236.29

			a = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , 0 , 40 * COEff]) isSelected:on
			a_1 = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , -15, 40 * COEff]) isSelected:on 
			a.wirecolor = color 0 0 0
			Lotus_FreeFacialModTool_TOhideLayer a
			try( mergeMAXFile (temp_facialLC_PATH + "LOTUS_fra_L.max") )catch()
			$LOTUS_fra_L.pos = a_1.pos
			delete a_1
			a_1 = $LOTUS_fra_L
			a_1.parent = a
			a.name = "FrFaMo_lc" + COENum 
			a_1.name = "FrFaMo" + COENum
			
			Lotus_FreezeTransform a_1
			
			num = 5
			case of
			(
				(Lotus_FreeFacialModTool.rad1.state == 1): num = 10
				(Lotus_FreeFacialModTool.rad1.state == 2): num = 5
				(Lotus_FreeFacialModTool.rad1.state == 3): num = 20
				(Lotus_FreeFacialModTool.rad1.state == 4): num = 1
			)
			Lotus_FreeFacialModTool_backNum = num
			
			a_1[3][1][2][1].controller = float_limit ()
			a_1[3][1][2][1].controller.upper_limit = 0
			a_1[3][1][2][1].controller.lower_limit = Lotus_FreeFacialModTool_backNum * -1
			a_1[3][1][2][2].controller = float_limit ()
			a_1[3][1][2][2].controller.upper_limit = 0
			a_1[3][1][2][2].controller.lower_limit = 0
			a_1[3][1][2][3].controller = float_limit ()
			a_1[3][1][2][3].controller.upper_limit = 0
			a_1[3][1][2][3].controller.lower_limit = 0
			
			tempOBJ_R = copy theBaseOBJ
			try (deleteModifier tempOBJ_R 1;deleteModifier tempOBJ_R 1)catch()
			tempOBJ_R.pos = [200 * COEff , -15 , 120 * COEff]
			tempOBJ_L = copy tempOBJ_R
			tempOBJ_L.pos = [tempOBJ_R.pos.x - (50 * COEff) , tempOBJ_R.pos.y , tempOBJ_R.pos.z - (50 * COEff)]
			delete tempOBJ_R
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_L
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum ( COENum as string + "_L" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][1]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a<0,a*" + ((-100.0/Lotus_FreeFacialModTool_backNum)-0.01)as string + ",0)")
			select a
		)
	)
	
	on btn5 pressed do
	(
		if (selection as array)[1] != undefined and (superclassof (selection as array)[1]) == GeometryClass then
		(
			COENum = (Lotus_FreeFacialModTool_reNameAddNum()) as string
			theBaseOBJ = (selection as array)[1]
			COEff = ((theBaseOBJ.max.x - theBaseOBJ.min.x)*(theBaseOBJ.max.y - theBaseOBJ.min.y))/3236.29
			
			a = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , 0 , 40 * COEff]) isSelected:on
			a_1 = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , -15, 40 * COEff]) isSelected:on 
			a.wirecolor = color 0 0 0
			Lotus_FreeFacialModTool_TOhideLayer a
			try( mergeMAXFile (temp_facialLC_PATH + "LOTUS_fra_R.max") )catch()
			$LOTUS_fra_R.pos = a_1.pos
			delete a_1
			a_1 = $LOTUS_fra_R
			a_1.parent = a
			a.name = "FrFaMo_lc" + COENum 
			a_1.name = "FrFaMo" + COENum
			
			Lotus_FreezeTransform a_1
			
			num = 5
			case of
			(
				(Lotus_FreeFacialModTool.rad1.state == 1): num = 10
				(Lotus_FreeFacialModTool.rad1.state == 2): num = 5
				(Lotus_FreeFacialModTool.rad1.state == 3): num = 20
				(Lotus_FreeFacialModTool.rad1.state == 4): num = 1
			)
			Lotus_FreeFacialModTool_backNum = num
			
			a_1[3][1][2][1].controller = float_limit ()
			a_1[3][1][2][1].controller.upper_limit = Lotus_FreeFacialModTool_backNum
			a_1[3][1][2][1].controller.lower_limit = 0
			a_1[3][1][2][2].controller = float_limit ()
			a_1[3][1][2][2].controller.upper_limit = 0
			a_1[3][1][2][2].controller.lower_limit = 0
			a_1[3][1][2][3].controller = float_limit ()
			a_1[3][1][2][3].controller.upper_limit = 0
			a_1[3][1][2][3].controller.lower_limit = 0
			
			tempOBJ_R = copy theBaseOBJ
			try (deleteModifier tempOBJ_R 1;deleteModifier tempOBJ_R 1)catch()
			tempOBJ_R.pos = [200 * COEff , -15 , 120 * COEff]
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_R
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum (COENum as string + "_R" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][1]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*" + ((100.0/Lotus_FreeFacialModTool_backNum)-0.01)as string + ",0)")
			select a
		)
	)
	
	on btn5_1 pressed do
	(
		if (selection as array)[1] != undefined and (superclassof (selection as array)[1]) == GeometryClass then
		(
			COENum = (Lotus_FreeFacialModTool_reNameAddNum()) as string
			theBaseOBJ = (selection as array)[1]
			COEff = ((theBaseOBJ.max.x - theBaseOBJ.min.x)*(theBaseOBJ.max.y - theBaseOBJ.min.y))/3236.29
			
			a = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , 0 , 40 * COEff]) isSelected:on
			a_1 = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , -15, 40 * COEff]) isSelected:on 
			a.wirecolor = color 0 0 0
			Lotus_FreeFacialModTool_TOhideLayer a
			try( mergeMAXFile (temp_facialLC_PATH + "LOTUS_fra_RU.max") )catch()
			$LOTUS_fra_RU.pos = a_1.pos
			delete a_1
			a_1 = $LOTUS_fra_RU
			a_1.parent = a
			a.name = "FrFaMo_lc" + COENum 
			a_1.name = "FrFaMo" + COENum
			
			Lotus_FreezeTransform a_1
			
			num = 5
			case of
			(
				(Lotus_FreeFacialModTool.rad1.state == 1): num = 10
				(Lotus_FreeFacialModTool.rad1.state == 2): num = 5
				(Lotus_FreeFacialModTool.rad1.state == 3): num = 20
				(Lotus_FreeFacialModTool.rad1.state == 4): num = 1
			)
			Lotus_FreeFacialModTool_backNum = num
			
			a_1[3][1][2][1].controller = float_limit ()
			a_1[3][1][2][1].controller.upper_limit = Lotus_FreeFacialModTool_backNum
			a_1[3][1][2][1].controller.lower_limit = 0
			a_1[3][1][2][2].controller = float_limit ()
			a_1[3][1][2][2].controller.upper_limit = Lotus_FreeFacialModTool_backNum
			a_1[3][1][2][2].controller.lower_limit = 0
			a_1[3][1][2][3].controller = float_limit ()
			a_1[3][1][2][3].controller.upper_limit = 0
			a_1[3][1][2][3].controller.lower_limit = 0
			
			tempOBJ_R = copy theBaseOBJ
			try (deleteModifier tempOBJ_R 1;deleteModifier tempOBJ_R 1)catch()
			tempOBJ_R.pos = [200 * COEff , -15 , 120 * COEff]
			tempOBJ_U = copy tempOBJ_R
			tempOBJ_U.pos = [tempOBJ_R.pos.x - (50 * COEff) , tempOBJ_R.pos.y , tempOBJ_R.pos.z + (50 * COEff)]
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_R
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum (COENum as string + "_UD_R" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][1]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*" + ((100.0/Lotus_FreeFacialModTool_backNum)-0.01)as string + ",0)")
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_U
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum (COENum as string + "_UD_U" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*" + ((100.0/Lotus_FreeFacialModTool_backNum)-0.01)as string + ",0)")
			select a
		)
	)
	
	on btn6 pressed do
	(
		if (selection as array)[1] != undefined and (superclassof (selection as array)[1]) == GeometryClass then
		(
			COENum = (Lotus_FreeFacialModTool_reNameAddNum()) as string
			theBaseOBJ = (selection as array)[1]
			COEff = ((theBaseOBJ.max.x - theBaseOBJ.min.x)*(theBaseOBJ.max.y - theBaseOBJ.min.y))/3236.29
			
			a = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , 0 , 40 * COEff]) isSelected:on
			a_1 = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , -15, 40 * COEff]) isSelected:on 
			a.wirecolor = color 0 0 0
			Lotus_FreeFacialModTool_TOhideLayer a
			try( mergeMAXFile (temp_facialLC_PATH + "LOTUS_fra_UD.max") )catch()
			$LOTUS_fra_UD.pos = a_1.pos
			delete a_1
			a_1 = $LOTUS_fra_UD
			a_1.parent = a
			a.name = "FrFaMo_lc" + COENum 
			a_1.name = "FrFaMo" + COENum
			
			Lotus_FreezeTransform a_1
			
			num = 5
			case of
			(
				(Lotus_FreeFacialModTool.rad1.state == 1): num = 10
				(Lotus_FreeFacialModTool.rad1.state == 2): num = 5
				(Lotus_FreeFacialModTool.rad1.state == 3): num = 20
				(Lotus_FreeFacialModTool.rad1.state == 4): num = 1
			)
			Lotus_FreeFacialModTool_backNum = num
			
			a_1[3][1][2][1].controller = float_limit ()
			a_1[3][1][2][1].controller.upper_limit = 0
			a_1[3][1][2][1].controller.lower_limit = 0
			a_1[3][1][2][2].controller = float_limit ()
			a_1[3][1][2][2].controller.upper_limit = Lotus_FreeFacialModTool_backNum
			a_1[3][1][2][2].controller.lower_limit = Lotus_FreeFacialModTool_backNum * -1
			a_1[3][1][2][3].controller = float_limit ()
			a_1[3][1][2][3].controller.upper_limit = 0
			a_1[3][1][2][3].controller.lower_limit = 0
			
			tempOBJ_R = copy theBaseOBJ
			try (deleteModifier tempOBJ_R 1;deleteModifier tempOBJ_R 1)catch()
			tempOBJ_R.pos = [200 * COEff , -15 , 120 * COEff]
			tempOBJ_U = copy tempOBJ_R
			tempOBJ_U.pos = [tempOBJ_R.pos.x - (50 * COEff) , tempOBJ_R.pos.y , tempOBJ_R.pos.z + (50 * COEff)]
			tempOBJ_D = copy tempOBJ_R
			tempOBJ_D.pos = [tempOBJ_R.pos.x - (50 * COEff) , tempOBJ_R.pos.y , tempOBJ_R.pos.z - (50 * COEff)]
			delete tempOBJ_R
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_U
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum (COENum as string + "_UD_U" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*" + ((100.0/Lotus_FreeFacialModTool_backNum)-0.01)as string + ",0)")
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_D
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum (COENum as string + "_UD_D" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a<0,a*" + (((100.0/Lotus_FreeFacialModTool_backNum)-0.01)* -1 )as string + ",0)")
			select a
		)
	)
	
	on btn7 pressed do
	(
		if (selection as array)[1] != undefined and (superclassof (selection as array)[1]) == GeometryClass then
		(
			COENum = (Lotus_FreeFacialModTool_reNameAddNum()) as string
			theBaseOBJ = (selection as array)[1]
			COEff = ((theBaseOBJ.max.x - theBaseOBJ.min.x)*(theBaseOBJ.max.y - theBaseOBJ.min.y))/3236.29
			
			a = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , 0 , 40 * COEff]) isSelected:on
			a_1 = Circle radius:3  transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [50 * COEff , -15, 40 * COEff]) isSelected:on 
			a.wirecolor = color 0 0 0
			Lotus_FreeFacialModTool_TOhideLayer a
			try( mergeMAXFile (temp_facialLC_PATH + "LOTUS_fra_LR.max") )catch()
			$LOTUS_fra_LR.pos = a_1.pos
			delete a_1
			a_1 = $LOTUS_fra_LR
			a_1.parent = a
			a.name = "FrFaMo_lc" + COENum 
			a_1.name = "FrFaMo" + COENum
			
			Lotus_FreezeTransform a_1
			
			num = 5
			case of
			(
				(Lotus_FreeFacialModTool.rad1.state == 1): num = 10
				(Lotus_FreeFacialModTool.rad1.state == 2): num = 5
				(Lotus_FreeFacialModTool.rad1.state == 3): num = 20
				(Lotus_FreeFacialModTool.rad1.state == 4): num = 1
			)
			Lotus_FreeFacialModTool_backNum = num
			
			a_1[3][1][2][1].controller = float_limit ()
			a_1[3][1][2][1].controller.upper_limit = Lotus_FreeFacialModTool_backNum
			a_1[3][1][2][1].controller.lower_limit = Lotus_FreeFacialModTool_backNum * -1
			a_1[3][1][2][2].controller = float_limit ()
			a_1[3][1][2][2].controller.upper_limit = 0
			a_1[3][1][2][2].controller.lower_limit = 0
			a_1[3][1][2][3].controller = float_limit ()
			a_1[3][1][2][3].controller.upper_limit = 0
			a_1[3][1][2][3].controller.lower_limit = 0
			
			tempOBJ_R = copy theBaseOBJ
			try (deleteModifier tempOBJ_R 1;deleteModifier tempOBJ_R 1)catch()
			tempOBJ_R.pos = [200 * COEff , -15 , 120 * COEff]
			tempOBJ_L = copy tempOBJ_R
			tempOBJ_L.pos = [tempOBJ_R.pos.x - (100 * COEff) , tempOBJ_R.pos.y , tempOBJ_R.pos.z]
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_R
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum (COENum as string + "_LR_R" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][1]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*" + ((100.0/Lotus_FreeFacialModTool_backNum)-0.01)as string + ",0)")
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_L
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum (COENum as string + "_LR_L" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1[3][1][2][1]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a<0,a*" + (((100.0/Lotus_FreeFacialModTool_backNum)-0.01)* -1 )as string + ",0)")
			select a
		)
	)
	
		on btn8 pressed do
	(
		if (selection as array)[1] != undefined and (superclassof (selection as array)[1]) == GeometryClass then
		(
			
			COENum = (Lotus_FreeFacialModTool_reNameAddNum()) as string
			theBaseOBJ = (selection as array)[1]
			COEff = ((theBaseOBJ.max.x - theBaseOBJ.min.x)*(theBaseOBJ.max.y - theBaseOBJ.min.y))/3236.29
			
			try( mergeMAXFile (temp_facialLC_PATH + "LOTUS_Rectangle.max") )catch()
			$LOTUS_Rectangle.pos = [50 * COEff , 0 , 40 * COEff]
			a_1 = $LOTUS_Rectangle
			a_1.name = "FrFaMo_lc" + COENum
			a_1_a = $LOTUS_Rectangle_a
			a_1_a.name = "LTS_R_a"+ COENum
			a_1_o = $LOTUS_Rectangle_o
			a_1_o.name = "LTS_R_o"+ COENum
			a_1_e = $LOTUS_Rectangle_e
			a_1_e.name = "LTS_R_e"+ COENum
			a_1_i = $LOTUS_Rectangle_i
			a_1_i.name = "LTS_R_i"+ COENum
			a_1_u = $LOTUS_Rectangle_u
			a_1_u.name = "LTS_R_u"+ COENum
			a_1_yu = $LOTUS_Rectangle_yu
			a_1_yu.name = "LTS_R_yu"+ COENum
			
			num = 5
			case of
			(
				(Lotus_FreeFacialModTool.rad1.state == 1): num = 10
				(Lotus_FreeFacialModTool.rad1.state == 2): num = 5
				(Lotus_FreeFacialModTool.rad1.state == 3): num = 20
				(Lotus_FreeFacialModTool.rad1.state == 4): num = 1
			)
			Lotus_FreeFacialModTool_backNum = num
			
			tempOBJ_a = copy theBaseOBJ
			try (deleteModifier tempOBJ_a 1;deleteModifier tempOBJ_a 1)catch()
			tempOBJ_a.pos = [80 * COEff , -15 , 110 * COEff]
			tempOBJ_o = copy tempOBJ_a
			tempOBJ_o.pos.x += 70 * COEff
			tempOBJ_e = copy tempOBJ_o
			tempOBJ_e.pos.x += 70 * COEff
			tempOBJ_i = copy tempOBJ_e
			tempOBJ_i.pos.x += 70 * COEff
			tempOBJ_u = copy tempOBJ_i
			tempOBJ_u.pos.x += 70 * COEff
			tempOBJ_yu = copy tempOBJ_u
			tempOBJ_yu.pos.x += 70 * COEff
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_a
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum ( COENum as string + "_Rec_a" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1_a[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*20,0)")
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_o
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum ( COENum as string + "_Rec_o" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1_o[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*20,0)")
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_e
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum ( COENum as string + "_Rec_e" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1_e[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*20,0)")
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_i
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum ( COENum as string + "_Rec_i" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1_i[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*20,0)")
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_u
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum ( COENum as string + "_Rec_u" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1_u[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*20,0)")
			
			theCHanlNum = Lotus_FreeFacialModTool_getMorNum theBaseOBJ
			WM3_MC_BuildFromNode theBaseOBJ.morpher theCHanlNum tempOBJ_yu
			WM3_MC_SetName theBaseOBJ.morpher theCHanlNum ( COENum as string + "_Rec_yu" )
			theBaseOBJ.morpher[theCHanlNum].track = float_expression()
			theBaseOBJ.morpher[theCHanlNum].track.AddScalarTarget "a" a_1_yu[3][1][2][2]
			theBaseOBJ.morpher[theCHanlNum].track.SetExpression ("if(a>0,a*20,0)")
			select a_1
		)
	)
	
	on btn9 pressed do
	(
		if (selection as array)[1] != undefined and (superclassof (selection as array)[1]) == shape and (superclassof (selection as array)[2]) == shape then
		(
			theBaceShape = (selection as array)[1]
			theChanShape = (selection as array)[2]
			theBaceShape.transform = theChanShape.transform
			try( theBaceShape.Children[1].wirecolor = theChanShape.Children[1].wirecolor )catch()
			try( delete theChanShape.Children )catch()
			try( delete theChanShape )catch()
		)
	)
)

--#######/ rig_眼球绑定2.5 /##################
fn eye_rigV2 =
(
	the_LRLR = "L"
	setMaxLimit = 10
	eye_TPoint = (selection as array)[1]
	try ( if eye_TPoint.pos.x > 0 then ( the_LRLR = "R" )else( the_LRLR = "L" ))catch()
	eye_TPoint.name += ("_" + the_LRLR)
	pupilP = eye_TPoint.size * -0.25
	ControllerRatio = 0.35
	LookATDistance = -40
	nodeArray = #()
			
	Circle_b002 = Circle radius:3 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [eye_TPoint.position.x + 45,eye_TPoint.position.y + -15,eye_TPoint.position.z + 10]) isSelected:on							
	Circle_b002.name = "eye_lc" + "_" + the_LRLR
	Circle_b002.parent = eye_TPoint
	Circle_b002.wirecolor = color 88 144 225
	append nodeArray Circle_b002 

	maxOps.cloneNodes eye_TPoint cloneType:#copy newNodes:&BasePoint
	BasePoint = BasePoint[1]
	BasePoint.name = "eye_base" + "_" + the_LRLR
	BasePoint.size = eye_TPoint.size * ControllerRatio
	BasePoint.wirecolor = color 28 28 177
	BasePoint.parent = eye_TPoint
	append nodeArray BasePoint

	maxOps.cloneNodes eye_TPoint cloneType:#copy newNodes:&BasePoint_target
	BasePoint_target = BasePoint_target[1]
	BasePoint_target.name = "eye_front" + "_" + the_LRLR
	BasePoint_target.size = eye_TPoint.size * ControllerRatio * 0.5
	BasePoint_target.wirecolor = color 28 28 177
	move BasePoint_target [0,pupilP,0]
	BasePoint_target.parent = BasePoint
	append nodeArray BasePoint_target

	Circle_a = Circle radius:3 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [eye_TPoint.position.x,eye_TPoint.position.y + LookATDistance,eye_TPoint.position.z]) isSelected:on							
	Circle_a.name = "eye_target" + "_" + the_LRLR
	Circle_a.parent = eye_TPoint
	Circle_a.wirecolor = color 28 28 177
	append nodeArray Circle_a

	maxOps.cloneNodes eye_TPoint cloneType:#copy newNodes:&eye_up
	eye_up = eye_up[1]
	eye_up.name = "eye_up" + "_" + the_LRLR
	eye_up.size = eye_TPoint.size * ControllerRatio * 0.5
	eye_up.wirecolor = color 145 28 177
	eye_up.parent = eye_TPoint
	append nodeArray eye_up

	maxOps.cloneNodes eye_TPoint cloneType:#copy newNodes:&eye_down
	eye_down = eye_down[1]
	eye_down.name = "eye_down" + "_" + the_LRLR
	eye_down.size = eye_TPoint.size * ControllerRatio * 0.4
	eye_down.wirecolor = color 108 8 136
	eye_down.parent = eye_TPoint
	append nodeArray eye_down

	temp_exp = ExposeTm pos:[eye_TPoint.position.x,eye_TPoint.position.y,eye_TPoint.position.z] isSelected:on
	temp_exp.name = "eye_exposeTm" + "_" + the_LRLR
	temp_exp.size = 1
	temp_exp.parent = eye_TPoint
	temp_exp.exposeNode = BasePoint
	append nodeArray temp_exp
	
	theStrint = text size:(eye_TPoint.size * ControllerRatio * 0.5) kerning:0 leading:0 isSelected:on text:"目" font:"@黑体"
	theStrint.name = "eyeString" + "_" + the_LRLR 
	theStrint.transform = eye_TPoint.transform
	theStrint.parent = eye_TPoint
	in coordsys local rotate theStrint (EulerAngles 0 0 -90)
	
	try( Lotus_FreezeTransform eye_TPoint )catch()
	try( Lotus_FreezeTransform Circle_b002 )catch()
	try( Lotus_FreezeTransform Circle_a )catch()
	try( Lotus_FreezeTransform BasePoint )catch()
	try( Lotus_FreezeTransform BasePoint_target )catch()
	try( Lotus_FreezeTransform Circle_a )catch()
	try( Lotus_FreezeTransform eye_up )catch()
	try( Lotus_FreezeTransform eye_down )catch()
	try( Lotus_FreezeTransform temp_exp )catch()
	try( Lotus_FreezeTransform theStrint )catch()
	Circle_b002[3][1][3].controller = Position_XYZ ()
	
	BasePoint[3][2][2].controller = LookAt_Constraint ()
	BasePoint[3][2][2].controller.appendTarget Circle_a 100
	BasePoint[3][2][2].controller.lookat_vector_length = 0
	BasePoint[3][2][2].controller.target_axis = 2 
	BasePoint[3][2][2].controller.StoUP_axis = 1 
	BasePoint[3][2][2].controller.upnode_axis = 1
	BasePoint[3][2][2].controller.upnode_world = off
	BasePoint[3][2][2].controller.pickUpNode = Circle_a

	Circle_b002[3][1][2][1].controller = float_limit ()
	Circle_b002[3][1][2][1].controller.upper_limit = setMaxLimit
	Circle_b002[3][1][2][1].controller.lower_limit = 0
	Circle_b002[3][1][2][2].controller = float_limit ()
	Circle_b002[3][1][2][2].controller.upper_limit = setMaxLimit
	Circle_b002[3][1][2][2].controller.lower_limit = 0
	Circle_b002[3][1][2][3].controller = float_limit ()
	Circle_b002[3][1][2][3].controller.upper_limit = 0
	Circle_b002[3][1][2][3].controller.lower_limit = 0

	eye_up[3][2][2][1].track = float_expression()
	eye_up[3][2][2][1].track.AddScalarTarget "a" Circle_b002[3][1][2][1]
	eye_up[3][2][2][1].track.AddScalarTarget "b" Circle_b002[3][2][2][2]
	eye_up[3][2][2][1].track.AddScalarTarget "c" temp_exp[4][2]		
	eye_up[3][2][2][1].track.SetExpression "if(a>0,(a)*-0.085+b*-1+c*0.2,0)"
	
	eye_up[3][2][2][3].track = float_expression()
	eye_up[3][2][2][3].track.AddScalarTarget "a" Circle_b002[3][2][2][3]
	eye_up[3][2][2][3].track.AddScalarTarget "c" temp_exp[4][3]
	eye_up[3][2][2][3].track.SetExpression "a*0.3+c*0.2"

	eye_up[3][2][2][2].track = float_expression()
	eye_up[3][2][2][2].track.AddScalarTarget "a" Circle_b002[3][2][2][2]
	eye_up[3][2][2][2].track.SetExpression "a*0.1"
		
	eye_down[3][2][2][1].track = float_expression()
	eye_down[3][2][2][1].track.AddScalarTarget "a" Circle_b002[3][1][2][2]
	eye_down[3][2][2][1].track.AddScalarTarget "c" temp_exp[4][2]
	eye_down[3][2][2][1].track.SetExpression "if(a>0,a*0.075+c*0.2,0)"
	
	eye_down[3][2][2][2].track = float_expression()
	eye_down[3][2][2][2].track.AddScalarTarget "c" temp_exp[4][3]
	eye_down[3][2][2][2].track.SetExpression "if(c>0,c*0.2,0)"
	
	try( deleteModifier theStrint eye_TPoint.modifiers[EmptyModifier])catch()
	addmodifier theStrint (EmptyModifier ())	
	temp = attributes rollout01
	(
		parameters parameters01 rollout: rollout01
		(
			thePointArray type:#nodeTab  tabSizeVariable:true
		)	
		rollout rollout01 ""  
		(
			button  del "删除眼球控制器" pos:[10,68] width:140 height:30 
			on del pressed do 
			(
				for i = 1 to $.'Attribute_Holder'.rollout01.thePointArray.count do( try( delete $.'Attribute_Holder'.rollout01.thePointArray[i] )catch() ) ;delete $
			)
		)
	)
	custAttributes.add theStrint.modifiers[#Attribute_Holder] temp	
	try( theStrint.'Attribute_Holder'.rollout01.thePointArray = nodeArray )catch()
)

--#######/ rig_烘培动画 /##################
fn Lotus_convertAnimateToMorpherSelectArray =
(
	if selection.count == 1 then
	(
		local baseOBJ = selection[1]
		local maxDistance
		
		local baseOBJ_theX = baseOBJ.max.X - baseOBJ.min.X
		local baseOBJ_theZ = baseOBJ.max.Z - baseOBJ.min.Z
		
		case of 
		(
			(baseOBJ_theX > baseOBJ_theZ): maxDistance = baseOBJ_theX
			(baseOBJ_theZ > baseOBJ_theX): maxDistance = baseOBJ_theZ
			(baseOBJ_theZ = baseOBJ_theX): maxDistance = baseOBJ_theZ
		)

		local posDistance = maxDistance * 3
		local atKeyFrameTime = animationrange.start
		local timeVariable = 3
		
		set animate off
			
		local theENDtime = (animationrange.end - animationrange.start)/timeVariable
		if theENDtime != ((theENDtime as string) as integer) then
		(
			theENDtime = ((theENDtime as string) as integer) + 1 
		)

		for i in 1 to theENDtime do
		(
			sliderTime = atKeyFrameTime
			maxOps.cloneNodes baseOBJ cloneType:#instance newNodes:&nnl
			select nnl
			sliderTime = timeVariable * i
			convertTo nnl Editable_Poly
			nnl.pos.x = posDistance + maxDistance * i * 1.3
		)
		sliderTime = atKeyFrameTime
	)
)

--#######/ rig_变形加减 /##################
fn Lotus_blendShapes_Cross =
(
	try( destroydialog Lotus_blendshapesCross)catch()
	rollout Lotus_blendshapesCross "变形加减" width:189 height:80
	(
		button btn1 "选择原始模型" pos:[5,5] width:180 height:30 tooltip:"指定原始的模型"
		button btn2 "《执行》" pos:[5,38] width:180 height:39 enabled:false tooltip:"1.选择渐进变形最后一个模型 2.加选新的渐进变形过程模型 3.点击执行"
		
		on btn1 pressed do
		(
			try
			(
				temp = selection as array
				if temp.count == 1 then 
				( 
					btn1.text = ">>" + $.name + "<<" 
					global Lotus_blendshapesCross_baseOBJ = $
				)
				if btn1.text != "选择原始模型" then ( btn2.enabled = true )
			)catch()
		)
		
		on btn2 pressed do
		(
			try
			(
				tempArr = selection as array
				newtempArr = deepcopy tempArr
				deleteItem newtempArr 1
				Lotus_Array_ModX(newtempArr)
				theCrossArr = #()

				for i = 1 to (newtempArr.count - 1) do
				(
					tempOBJ = copy tempArr[1]
					tempOBJ.pos.z = (tempOBJ.pos.z + newtempArr[1].pos.z) / 2
					tempOBJ.pos.y = (tempOBJ.pos.y + newtempArr[i+1].pos.y) / 2
					tempOBJ.pos.x = (newtempArr[i].pos.x + newtempArr[i+1].pos.x) / 2
					append theCrossArr tempOBJ
					select tempOBJ
					selectMore Lotus_blendshapesCross_baseOBJ
					selectMore newtempArr[i]
					Lotus_morpherPickUp()
				)
				
				tempOBJ = copy tempArr[1]
				tempOBJ.pos = theCrossArr[theCrossArr.count].pos
				tempOBJ.pos.x += abs(theCrossArr[theCrossArr.count].pos.x - theCrossArr[theCrossArr.count-1].pos.x)
				select tempOBJ
				selectMore Lotus_blendshapesCross_baseOBJ
				selectMore newtempArr[newtempArr.count]
				Lotus_morpherPickUp()
				clearSelection() 
			)catch()
		)
	)
	createdialog Lotus_blendshapesCross pos:[190,750]
)

--#######/ rig_曲线加点 /##################
fn Lotus_SplinePoint_tool_fn = 
(	
	global theSplineBase = (selection as array)[1]
	global theSplinePointArray = #()
	
	rollout Lotus_SplinePoint_tool "曲线布点" width:115 height:85
	(
		spinner 'spn1' "节点数量: " pos:[5,5] width:100 height:20 range:[2,200,7] scale:1 align:#left
		spinner 'spn2' "节点大小: " pos:[5,25] width:100 height:20 range:[0.01,100000,10] scale:1 align:#left
		radiobuttons 'rad1' labels:#("Cross" , "Box") 
		
		on spn1 changed state do 
		(
			theSplineBase = (selection as array)[1]
			
			try(delete theSplinePointArray)catch()
			theSplinePointArray = #()
			
			if (superclassof theSplineBase == shape) then
			(	
				tempString_cross = on
				tempString_box = off
				if Lotus_SplinePoint_tool.rad1.state == 2 then ( tempString_cross = off;tempString_box = on )
				tempPoint = Point transform:( matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0] ) isSelected:on size:7 box:tempString_box cross:tempString_cross centermarker:off axistripod:off drawontop:off constantscreensize:off 
				tempPoint.size = Lotus_SplinePoint_tool.spn2.Value
				append theSplinePointArray tempPoint
				tempPoint.pos.controller = Path_Constraint()
				tempPoint.pos.controller.path = theSplineBase
				tempPoint.pos.controller.follow = on
				DeleteKeys (tempPoint[3][1][1].keys) #allKeys
				
				num = 100.0 / Lotus_SplinePoint_tool.spn1.Value
				for i = 1 to Lotus_SplinePoint_tool.spn1.Value do 
				(
					newPoint = copy tempPoint
					append theSplinePointArray newPoint
					newPoint.pos.controller.PERCENT = num * i
				)
				select theSplineBase
			)
		)
		
		on spn2 changed state do ( try( theSplinePointArray.size = Lotus_SplinePoint_tool.spn2.Value )catch() )
		
		on rad1 changed state do 
		(
			if	Lotus_SplinePoint_tool.rad1.state == 1 then ( theSplinePointArray.cross = on;theSplinePointArray.box = off )
			if	Lotus_SplinePoint_tool.rad1.state == 2 then ( theSplinePointArray.cross = off;theSplinePointArray.box = on )
		)
		
		on Lotus_SplinePoint_tool close do ( try (globalVars.remove #theSplinePointArray )catch();try (globalVars.remove #theSplineBase )catch())
	)
	createdialog Lotus_SplinePoint_tool pos:[1190,750]
)

--#######/ rig_阵列表情 /##################
fn Lotus_BatchExportMorpher =
(
	selectObj = selection[1]
	theDistance = (selectObj.max.x - selectObj.min.x) * 1.3
	newObj = copy selectObj
	
	max modify mode
	try( deleteModifier newObj newObj.modifiers[#Skin] )catch()
	modPanel.setCurrentObject newObj.modifiers[#Morpher]
	
	for i = 1 to (WM3_NumberOfChannels $.modifiers[#Morpher]) do 
	(
		try
		(
			if newObj.modifiers[#Morpher][i] as string != "SubAnim:__empty" then
			(
				newObj.pos.x += theDistance
				WM3_SetChannelPos newObj.modifiers[#Morpher] i
				findCTS = windows.getchildhwnd #max "Extract" 
				uiaccessor.pressbutton findCTS[1]
			)
		)catch()
	)		
	delete newObj
)

--#######/ rig_继承变形 /##################
fn LTZ_wrapBakeMorpher =
(
	fn 模型烘焙表情并关联_fn_修正表情 =
	(
		local tempArr = $
		
		if tempArr != undefined and tempArr.count >= 3 then
		(
			local repairFacial = tempArr[1]
			local baseFacial = tempArr[2]
			local baseFacial_to = undefined
			theDistance = (baseFacial.max.x - baseFacial.min.x) * 1.3
			
			if tempArr.count >= 4 then 
			(
				local tempCount = 3
				
				addmodifier baseFacial (Morpher ())
				baseFacial.modifiers[#Morpher].Autoload_of_targets = 1	
					
				for i = 1 to tempArr.count - 2 do
				(			
					local baseFacial_to = tempArr[tempCount]
					
					copyObj1 = copy repairFacial
					copyObj1.pos = baseFacial.pos

					addmodifier copyObj1 (Skin_Wrap ())
					copyObj1.modifiers[#Skin_Wrap].falloff = 8
					copyObj1.modifiers[#Skin_Wrap].distance = 0.06
					copyObj1.modifiers[#Skin_Wrap].faceLimit = 20
					copyObj1.modifiers[#Skin_Wrap].weightAllVerts = on
					copyObj1.modifiers[#Skin_Wrap].meshList = #(baseFacial)
					WM3_MC_BuildFromNode baseFacial.morpher 1 baseFacial_to
					
					max time start
					WM3_MC_SetValue baseFacial.morpher 1 0.0
					set animate on
					sliderTime = 5f
					WM3_MC_SetValue baseFacial.morpher 1 100.0
					set animate off
					max time start
					sliderTime = 5f
					
					convertTo copyObj1 Editable_Poly
					copyObj1.pos = baseFacial_to.pos
					move copyObj1 [theDistance,0,0]
					copyObj1.name = baseFacial_to.name	
					
					tempCount = tempCount + 1	
					max time start
					print ("完成度———" + (i as string) + "/" + ((tempArr.count - 2) as string) )
				 )
					 
				local tempCount = 3
				deleteModifier baseFacial 1				
			)
			else
			(
				local baseFacial_to = tempArr[3]
				
				copyObj1 = copy repairFacial
				copyObj1.pos = baseFacial.pos

				addmodifier copyObj1 (Skin_Wrap ())
				copyObj1.modifiers[#Skin_Wrap].falloff = 8
				copyObj1.modifiers[#Skin_Wrap].distance = 0.06
				copyObj1.modifiers[#Skin_Wrap].faceLimit = 20
				copyObj1.modifiers[#Skin_Wrap].weightAllVerts = on
				copyObj1.modifiers[#Skin_Wrap].meshList = #(baseFacial)
				addmodifier baseFacial (Morpher ())
				baseFacial.modifiers[#Morpher].Autoload_of_targets = 1	
				WM3_MC_BuildFromNode baseFacial.morpher 1 baseFacial_to
				
				max time start
				WM3_MC_SetValue baseFacial.morpher 1 0.0
				set animate on
				sliderTime = 30f
				WM3_MC_SetValue baseFacial.morpher 1 100.0
				set animate off
				max time start
				sliderTime = 30f
				
				convertTo copyObj1 Editable_Poly
				copyObj1.pos = baseFacial_to.pos
				move copyObj1 [theDistance,0,0]
				copyObj1.name = baseFacial_to.name	
				
				deleteModifier baseFacial 1	
				max time start
			 )
		)
	)
	baseObj = (selection as array)[1]
	targetObj = (selection as array)[2]
	actionMan.executeAction 0 "197" 
	maxOps.cloneNodes targetObj cloneType:#copy newNodes:&copyObj
	copyObj = copyObj[1]
	convertTo copyObj Editable_Poly
	max modify mode
	select targetObj
	actionMan.executeAction 0 "197" 
	Lotus_BatchExportMorpher()
	hide targetObj
	max select all
	morpherArray = (selection as array)
	tempNum = morpherArray.count
	max unhide all
	select baseObj
	selectmore copyObj
	selectmore morpherArray
	actionMan.executeAction 0 "197" 
	模型烘焙表情并关联_fn_修正表情()
	hide baseObj
	hide copyObj
	hide morpherArray
	max select all
	morpherArray2 = (selection as array)
	max unhide all
	select baseObj
	selectmore morpherArray2
	Lotus_morpherPickUp()
	select baseObj
	modPanel.setCurrentObject baseObj.modifiers[#Morpher]
	findCTS = windows.getchildhwnd #max "Zero Active Channel Values" 
	uiaccessor.pressbutton findCTS[1]
	try(delete copyObj)catch()
	for i = 1 to morpherArray.count do ( try(delete morpherArray[i])catch() )
	for i = 1 to morpherArray2.count do ( try(delete morpherArray2[i])catch() )
	maxOps.cloneNodes targetObj cloneType:#copy newNodes:&copyObj
	copyObj = copyObj[1]
	select baseObj
	selectmore copyObj
	Lotus_SkinReplace()
	select targetObj
	max zoomext sel
	for i = 1 to tempNum do
	(
		baseObj.modifiers[#Morpher][i].track = float_expression()
		baseObj.modifiers[#Morpher][i].track.AddScalarTarget "a" targetObj.modifiers[#Morpher][i]
		baseObj.modifiers[#Morpher][i].track.SetExpression "a"
	)
)

--#######/ rig_控制器大圈 /##################
fn Lotus_addPrefixTool =
(
	allNode = selection as array
	baseRec = Rectangle length:(selection.max.x * 2) width:(selection.max.x * 2) cornerRadius:0 isSelected:on 
	Lotus_FreezeTransform baseRec
	baseRec_2 = Rectangle length:(baseRec.length * 0.9) width:(baseRec.width * 0.9) cornerRadius:0 isSelected:on 
	baseRec_2.parent = baseRec
	baseRec_2.wirecolor = baseRec.wirecolor
	Lotus_FreezeTransform baseRec_2
	setTransformLockFlags baseRec_2 #all
	--给大圈添加节点
	try( deleteModifier baseRec baseRec.modifiers[EmptyModifier])catch()
	addmodifier baseRec (EmptyModifier ())			
	temp = attributes rollout01
	(
		parameters parameters01 rollout: rollout01
		(
			theBaseArray type:#nodeTab  tabSizeVariable:true
		)	
		rollout rollout01 ""  
		(
			groupBox gro "命名" pos:[5,5] width:150 height:160 
				edittext text1  pos:[10,25] width:130 height:20 
				button bt1 "去除前缀命名" pos:[15,60] width:125 height:29 
				button bt2 "删除所有组件" pos:[15,90] width:125 height:29 
				button bt3 "选择组件" pos:[15,130] width:125 height:29 
			
			on text1 entered txt do 
			(
				try
				(
					findStr = "--"
					txt = (filterString txt "\n")[1]
					for i = 1 to theBaseArray.count do
					(
						if theBaseArray[i] != undefinedthen then
						(
							num = filterString theBaseArray[i].name findStr
							if num.count == 1 then( theBaseArray[i].name = txt + findStr + theBaseArray[i].name )else( theBaseArray[i].name = txt + findStr + num[2] )
						)
					)
					num = filterString $.name findStr
					if num.count == 1 then( $.name = txt + findStr + $.name )else( $.name = txt + findStr + num[2] )
				)catch()
			)
			
			on bt1 pressed do 
			(
				try
				(
					findStr = "--"
					for i = 1 to theBaseArray.count do
					(
						if theBaseArray[i] != undefinedthen then
						(
							num = filterString theBaseArray[i].name findStr
							if num.count == 1 then(  )else( theBaseArray[i].name = num[2] )
						)
					)
					num = filterString $.name findStr
					if num.count == 1 then(  )else( $.name = num[2] )
				)catch()
			)
			
			on bt2 pressed do 
			(
				for i = 1 to theBaseArray.count do( try($.modifiers[#Attribute_Holder].Lotus_IKFKChange.Lotus_IKFKChange.del1.pressed())catch() )
				try
				(
					newArray = #()
					for i = 1 to $.'Attribute_Holder'.rollout01.theBaseArray.count do 
					(
						if $.'Attribute_Holder'.rollout01.theBaseArray[i] != undefined then ( append newArray $.'Attribute_Holder'.rollout01.theBaseArray[i] )
					)
					for i = 1 to newArray.count do( if(classof newArray[i]) as string != "Plane_Angle" then( delete newArray[i] ) )
					for i = 1 to newArray.count do( try(delete newArray[i])catch() )
					free newArray
					delete $
				)catch()
			)	
			
			on bt3 pressed do 
			(
				newArray = #()
				for i = 1 to $.'Attribute_Holder'.rollout01.theBaseArray.count do 
				(
					if $.'Attribute_Holder'.rollout01.theBaseArray[i] != undefined then ( append newArray $.'Attribute_Holder'.rollout01.theBaseArray[i] )
				)
				try( select newArray )catch()
			)	
		)
	)
	custAttributes.add baseRec.modifiers[#Attribute_Holder] temp
	append allNode baseRec_2
	try( baseRec.'Attribute_Holder'.rollout01.theBaseArray = allNode )catch()
)

--#######/ rig_反转骨骼 /##################
fn Lotz_boneFlip =
(
	fn boneFlip_Lts_bdBone arr =  --选择节点生成骨骼
	(
		fn boneEnd slBone =
		(
			posArray = #()
			temp = point()
			temp.transform = slBone.transform
			in coordsys local move temp [slBone.length,0,0]
			pos = temp.pos
			posArray[1] = pos
			in coordsys local move temp [1,0,0]
			pos = temp.pos
			posArray[2] = pos
			delete temp
			posArray
		)
		newBoneArr = #()
		arr = selection as array
		
		for i = 1 to (arr.count - 1) do
		(
			BoneStartPoint = arr[i].transform.pos
			BoneEndpoint =  arr[i+1].transform.pos
			newBone                     = bonesys.createbone BoneStartPoint BoneEndpoint (arr[i].dir*[1,1,1] )
			newBone.width               = 1
			newBone.height              = 1
			newBone.taper               = 90
			newBone.name                = arr[i].name 	
			append newBoneArr newBone 
		)
		BoneStartPoint = (boneEnd newBoneArr[newBoneArr.count])[1]
		BoneEndpoint =  (boneEnd newBoneArr[newBoneArr.count])[2]
		newBone                     = bonesys.createbone BoneStartPoint BoneEndpoint newBoneArr[newBoneArr.count].dir 
		newBone.width               = 1
		newBone.height              = 1
		newBone.taper               = 90
		newBone.name                = newBoneArr[newBoneArr.count].name 	
		append newBoneArr newBone 
		for i = 0 to (newBoneArr.count - 2) do( newBoneArr[newBoneArr.count-i].parent = newBoneArr[newBoneArr.count-i-1] )
		newBoneArr
	)

	boneArray = selection as array
	newBoneArray = #()
	if classof boneArray[1] == BoneGeometry and boneArray.count >= 2 then
	(
		for i = 1 to boneArray.count do
		(
			append newBoneArray boneArray[boneArray.count - i + 1]
		)
		clearSelection()
		for i = 1 to newBoneArray.count do ( selectmore newBoneArray[i] )
		newBone = boneFlip_Lts_bdBone selection
		for i = 1 to newBone.count do( newBone[i].name = boneArray[i].name )
		delete boneArray
		select newBone
	)
)
--#######/ rig_曲线转骨骼 /##################
fn Lts_curveConversionBone =
(
	baseShapes = selection[1]
	case (classof baseShapes) of
	(
		Editable_Poly:
		(	
			baseShapes.EditablePoly.createShape "tempShapeg4h7j8k3f4" on baseShapes
			addmodifier $tempShapeg4h7j8k3f4 (Spline_IK_Control ())
			select $tempShapeg4h7j8k3f4
			max modify mode
			findCTS = windows.getchildhwnd #max "Create Helpers" 
			uiaccessor.pressbutton findCTS[1]
			$tempShapeg4h7j8k3f4.modifiers[#Spline_IK_Control].createHelper
			$tempShapeg4h7j8k3f4.modifiers[#Spline_IK_Control].helper_size = 0
			tempPoint = $tempShapeg4h7j8k3f4.modifiers[#Spline_IK_Control].helper_list
			select (tempPoint as array)
			sliderTime = 0f
			newBone = Lts_bdBone selection
			delete $tempShapeg4h7j8k3f4
			for i in tempPoint do ( try( delete i )catch() )
			for i in newBone do ( Lotus_FreezeTransform i )
			select baseShapes
			modPanel.setCurrentObject baseShapes.baseObject	
			subobjectLevel = 2				
		)
		SplineShape:
		(	
			addmodifier baseShapes (Spline_IK_Control ())
			max modify mode
			findCTS = windows.getchildhwnd #max "Create Helpers" 
			uiaccessor.pressbutton findCTS[1]
			baseShapes.modifiers[#Spline_IK_Control].createHelper
			baseShapes.modifiers[#Spline_IK_Control].helper_size = 0
			tempPoint = baseShapes.modifiers[#Spline_IK_Control].helper_list
			select (tempPoint as array)
			sliderTime = 0f
			newBone = Lts_bdBone selection
			delete baseShapes
			for i in tempPoint do ( try( delete i )catch() )
			for i in newBone do ( Lotus_FreezeTransform i )
		)	
		line:
		(	
			addmodifier baseShapes (Spline_IK_Control ())
			max modify mode
			findCTS = windows.getchildhwnd #max "Create Helpers" 
			uiaccessor.pressbutton findCTS[1]
			baseShapes.modifiers[#Spline_IK_Control].createHelper
			baseShapes.modifiers[#Spline_IK_Control].helper_size = 0
			tempPoint = baseShapes.modifiers[#Spline_IK_Control].helper_list
			select (tempPoint as array)
			sliderTime = 0f
			newBone = Lts_bdBone selection
			delete baseShapes
			for i in tempPoint do ( try( delete i )catch() )
			for i in newBone do ( Lotus_FreezeTransform i )
		)			
	)
)

--#############################################################################################################################################--
--#####################################################         /动画/          ###############################################################--
--#############################################################################################################################################--
fn Lotus_addPointAndBakeTransform =   ----------还未使用
(
	theSelectedPoint = $
	tempPoint = Point transform:( matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0] ) isSelected:on size:10 box:on cross:off centermarker:off axistripod:off drawontop:off constantscreensize:off 
	Lotus_FreezeTransform tempPoint
	sliderTime = animationrange.start
	tempPoint.pos = theSelectedPoint.pos
	tempPoint.rotation = theSelectedPoint.rotation
	tempPoint.scale = theSelectedPoint.scale
	set animate on
	for i = 0 to animationrange.end do
	(
		sliderTime = i
		tempPoint.transform = theSelectedPoint.transform
		select tempPoint
		max set key keys
	)
)

--#######/ ani_添加摄像机 /##################
fn Lotus_creatU3DCamera =
(
	U3DCamera = ($'Camera'*)[1]
	U3DCameraFOV = (filterString (filterString U3DCamera.name "(")[2]  ")")[1] as float
	MAXCamera = Freecamera  fovType:2 targetDistance:1 nearclip:1 farclip:1000 nearrange:0 curFOV:U3DCameraFOV farrange:1000 mpassEnabled:off mpassRenderPerPass:off
	MAXCamera.transform = U3DCamera.transform	
	in coordsys local rotate MAXCamera (EulerAngles 0 180 0)
)

--#######/ ani_转U3D摄像机 /##################
fn Lotus_convertU3DCamera =
(
	theTargetCam = (selection as array)[1]  
	max time start
	theFreeCam = Freecamera fov:(theTargetCam.fov) fovType:2 nearclip:1 farclip:1000 nearrange:0 farrange:1000 mpassEnabled:off mpassRenderPerPass:off 
	theFreeCam.transform = theTargetCam.transform
	theFreeCam.name = theTargetCam.name 
	set animate on
	for i = 1 to ((filterString (animationRange.end as string) "f")[1] as integer) do
	(
		sliderTime = i
		theFreeCam.transform = theTargetCam.transform
		theFreeCam.fov = theTargetCam.fov
	)
)

--#######/ ani_IKFK节点加入sets /##################
fn Lotus_toIKFK_RefreshNodeSets =
(
	max Select All
	temp = selection as array
	arr = #()
	for i = 1 to temp.count do
	(
		try( if temp[i].modifiers[#Attribute_Holder].Lotus_IKFKChange as string == "Lotus_IKFKChange:Lotus_IKFKChange" then (append arr temp[i] ) )catch()
	)
	temp = arr
	a = #()
	if selectionSets["IKFK_RefreshNode"] == undefined then 
	( 
		selectionSets["IKFK_RefreshNode"] = arr 
	)
	else
	( 
		for i = 1 to selectionSets["IKFK_RefreshNode"].count do( append a selectionSets["IKFK_RefreshNode"][i] )
		for i = 1 to temp.count do( append a temp[i] )
		selectionSets["IKFK_RefreshNode"] = a
	)
	clearSelection()
)

--#######/ ani_快速导出动作 /##################
fn lts_quickExportAni =
(
	tempSArray = selection as array
	thePathAndName = "D:\\Documents\\3dsMax\\sceneassets\\animations\\ltz_temp.xaf"
	LoadSaveAnimation.saveAnimation thePathAndName tempSArray "" "" 
	tempSarrayName =#()
	for i = 1 to tempSArray.count do( append tempSarrayName tempSArray[i].name )
	HiddenDOSCommand ( "md " + LocalAddress_ + "\quickAni" )
	for i = 1 to tempSarrayName.count do( lotus_saveTXT (LocalAddress_ + "\\quickAni\\saveNodeName.txt") tempSarrayName[i] )
)	
		
--#######/ ani_快速读取动作 /##################		
fn lts_quickImportAni =
(		
	tempSArray = selection as array
	toSelArray = #()
	tempSArrayName = lotus_loadTXT (LocalAddress_ + "\\quickAni\\saveNodeName.txt")
	for i = 1 to tempSArray.count do
	(
		num = 0
		for o = 1 to tempSArrayName.count do( if tempSArray[i].name == tempSArrayName[o] then(  num = 1 ) )
		if num == 1 then ( append toSelArray tempSArray[i] )
	)
	thePathAndName = "D:\\Documents\\3dsMax\\sceneassets\\animations\\ltz_temp.xaf"
	LoadSaveAnimation.loadAnimation thePathAndName toSelArray relative:false insert:false
)
	

--#############################################################################################################################################--
--#####################################################        /脚本/           ###############################################################--
--#############################################################################################################################################--
--#######/ script_腐蚀工具 /##################
try( destroydialog Lotus_VD )catch()
rollout Lotus_VD "腐蚀工具" width:165 height:60  rolledUp:false
(
		Button 'btn1' "选择横截面的顶点" pos:[10,10] width:145 height:40 align:#left border:true
			
	on btn1 pressed do     
	(
		baseOBJ = $
		theOBJ = copy baseOBJ
		vertexDifPosArray = #()
		
		subobjectLevel = 0
		modPanel.setCurrentObject $.baseObject
		
		theOBJ.pos.x += ( theOBJ.max.x - theOBJ.min.x )*1.3
		select theOBJ
		max zoomext sel
		macros.run "Modifier Stack" "SubObject_1"

		baseVertexArray = #()
		targetVertexArray = #()

		baseVertexArray = polyop.getVertSelection theOBJ as array
		theOBJ.EditablePoly.GrowSelection ()
		targetVertexArray  = polyop.getVertSelection theOBJ as array
		theEndVertexArray = deepcopy targetVertexArray

		for i = 1 to baseVertexArray.count do 
		(
			tempNum = findItem targetVertexArray baseVertexArray[i]
			if tempNum != 0 do (deleteItem targetVertexArray tempNum)
		)

		for i = 1 to baseVertexArray.count do 
		(
			tempONOFF = 0
			tempArray = #()
				
			for o = 1 to baseVertexArray.count do 
			(
				if (( polyop.getVert theOBJ baseVertexArray[i]) as string == (polyop.getVert theOBJ baseVertexArray[o]) as string ) then
				(
					append tempArray baseVertexArray[o]
				)
			)
				
			if (vertexDifPosArray.count == 0) then
			(
				append vertexDifPosArray tempArray
			)
			else
			(
				for o = 1 to vertexDifPosArray.count do 
				(
					if ( ( polyop.getVert theOBJ tempArray[1]) as string != ( polyop.getVert theOBJ vertexDifPosArray[o][1]) as string ) then
					(
						tempONOFF += 1
					)
				)
				
				if (tempONOFF == vertexDifPosArray.count) do (append vertexDifPosArray tempArray)
			)
		)

		for i = 1 to vertexDifPosArray.count do 
		(
			tempNum = undefined
				
			theOBJ.EditablePoly.SetSelection #Vertex (vertexDifPosArray[i]as bitarray )
			theOBJ.EditablePoly.GrowSelection ()
			growSelectionArray = polyop.getVertSelection theOBJ as array

			for o = 1 to targetVertexArray.count do 
			(
				if (findItem growSelectionArray targetVertexArray[o]) != 0 then ( tempNum = o )
			)

			try(targetVertexPos = polyop.getVert theOBJ targetVertexArray[tempNum])catch()
			try(polyop.setVert theOBJ vertexDifPosArray[i] targetVertexPos)catch()
		)

		try(theOBJ.EditablePoly.SetSelection #Vertex (theEndVertexArray as bitarray))catch()		
	)
)

--#######/ script_烘焙影子节点 /##################
fn Lotus_bakeShadow =
(
	local temp = selection as array
	if temp.count == 1 then
	(
		thePelvis = $
		tempExposeTransformPoint = ExposeTransform transform:( matrix3 (thePelvis.transform[1]) thePelvis.transform[2] (thePelvis.transform[3]) (thePelvis.transform[4]) ) isSelected:on size:7 box:on
		tempExposeTransformPoint.parent = thePelvis
		tempExposeTransformPoint.exposeNode = thePelvis
		tempPoint = Point transform:( matrix3 [1,0,0] [0,0,1] [0,-1,0] [thePelvis.transform[4].x,thePelvis.transform[4].y,thePelvis.transform[4].z - 20] ) isSelected:on size:7 box:on
		tempPoint[3][1][1].track = float_expression()
		tempPoint[3][1][1].track.AddScalarTarget "a" tempExposeTransformPoint[4][14]
		tempPoint[3][1][1].track.SetExpression "a*1"
		tempPoint[3][1][2].track = float_expression()
		tempPoint[3][1][2].track.AddScalarTarget "a" tempExposeTransformPoint[4][15]
		tempPoint[3][1][2].track.SetExpression "a*1"
		try
		(
			mergeMaxFile (theServerAddress_ + "库\\影子面片\\gsh_yy.max") #mergeDups #useSceneMtlDups quiet:true
			theYYY = $yy
			theYYY.transform = tempPoint.transform
			theYYY.parent = tempPoint
			theYYY.name = "dj_yy_" + ((random 0 9)as string)+((random 0 9)as string)+((random 0 9)as string)+((random 0 9)as string)
		)catch()
		select theYYY
	)
)

--#######/ 口型烘焙 /##################
fn bakeAudioAni_V1 =
(
	try( destroydialog BAARollout )catch()

	rollout BAARollout "BakeAudio v1.0" width:160 height:130
	(
		button 'btn1' "proSound" pos:[10,10] width:140 height:30 align:#left
		button 'btn2' "设置烘培段落" pos:[10,60] width:140 height:30 align:#left
		button 'btn3' "开始烘培" pos:[10,90] width:140 height:30 align:#left
		
		on btn1 pressed do with undo on ( try( prosound.open() )catch() )
		on btn2 pressed do with undo on ( try( animationRange = interval (prosound.start 1) (prosound.end 1)  )catch(); try( sliderTime = prosound.start 1 )catch())	
		on btn3 pressed do with undo on 
		( 
			try
			( 
				if (selection as array).count == 1 do
				(
					baseLC = (selection as array)[1]
					LC = Point pos:[baseLC.pos.x,baseLC.pos.y,baseLC.pos.z] isSelected:on box:on cross:off axistripod:off centermarker:on size:2 constantscreensize:off drawontop:off 
					Lotus_RotatePivotOnly LC baseLC
					LC.parent = baseLC.parent
					Lotus_FreezeTransform LC
					sliderTime = animationRange.start
					LC.transform = baseLC.transform
					set animate on
					for i = 1 to (integer (animationRange.end - animationRange.start)) + 1 do ( sliderTime += 1; LC.transform = baseLC.transform )
					baseLC.pos.controller.Zero_Pos_XYZ.controller.Y_Position.controller = bezier_float ()
					baseLC.pos.controller.Zero_Pos_XYZ.controller.Y_Position.controller = float_limit ()
					baseLC.pos.controller.Zero_Pos_XYZ.controller.Y_Position.controller.upper_limit = 0
					baseLC.pos.controller.Zero_Pos_XYZ.controller.Y_Position.controller.lower_limit = 0
					sliderTime = animationRange.start
					baseLC.transform = LC.transform 
					for i = 1 to (integer (animationRange.end - animationRange.start)) + 1 do( sliderTime += 1; baseLC.transform = LC.transform ) ;select baseLC ;delete LC	
				)
			)catch() )		
	)
	createdialog BAARollout pos:[1300,450]
)

