local tempOBJ = $
local judgeOBJorSEL = undefined
local judgeOBJorSEL_Num = undefined

fn Lotus_JudgeOBJorSEL =
(
	local tempOBJ = $
	local tempNum = 1

	for i in tempOBJ do 
	(
		if classOf tempOBJ[tempNum] as string != "Dummy" then
		(
			tempNum = tempNum + 1
		 )
		 else
		(
			judgeOBJorSEL = "yes"
			judgeOBJorSEL_Num = tempNum
		 )		 
	 )
 )


if maxfilepath != undefined do
(
	Lotus_JudgeOBJorSEL()
	
	if tempOBJ[2] as string != "SubAnim:Space_Warps" and judgeOBJorSEL == undefined then
	(
		local exportArr = #()
		local countNum = 1
		for i in 1 to tempOBJ.count do
		(			
			local tempCopyOBJ = copy tempOBJ[countNum]
			tempCopyOBJ.name = tempOBJ[countNum].name
			--tempCopyOBJ.pos.X = 0
			--tempCopyOBJ.pos.Y = 0
			resetXform tempCopyOBJ
			ConverttoPoly tempCopyOBJ
			tempCopyOBJ.rotation = quat -0.707107 0 0 0.707107
			WorldAlignPivot tempCopyOBJ
			tempCopyOBJ.rotation = quat 0.707107 0 0 0.707107
			append exportArr tempCopyOBJ
			countNum = countNum + 1		
		 )
		countNum = 1
		 
		for i in 1 to tempOBJ.count do
		(
			
			select exportArr[countNum]
			checkPath = maxfilepath
			export_op = exporterPlugin.classes
			export_fbx = export_op[9]
			FBXExporterSetParam "Animation" false 
			FBXExporterSetParam "BakeAnimation" true 
			FBXExporterSetParam "UseSceneName" true
			FBXExporterSetParam "FileVersion" #FBX201500
			exportfile (checkPath + exportArr[countNum].name +".FBX") #noprompt selectedonly:true using:export_fbx
			delete exportArr[countNum]
			countNum = countNum + 1
		 )
	 )
	 else()
	 
	 if judgeOBJorSEL != undefined then
	(
		Lotus_JudgeOBJorSEL()
		local selectBaseGroup = tempOBJ[judgeOBJorSEL_Num]
		maxOps.cloneNodes selectBaseGroup cloneType:#copy newNodes:&tempCopyOBJ
		local selectExpGroup = tempCopyOBJ
		select selectExpGroup
		Lotus_JudgeOBJorSEL()
		selectExpGroup[judgeOBJorSEL_Num].name = selectBaseGroup.name
		
		--selectExpGroup[judgeOBJorSEL_Num].pos.X = 0
		--selectExpGroup[judgeOBJorSEL_Num].pos.Y = 0
		resetXform selectExpGroup[judgeOBJorSEL_Num]
		ConverttoPoly selectExpGroup[judgeOBJorSEL_Num]
		selectExpGroup[judgeOBJorSEL_Num].rotation = quat -0.707107 0 0 0.707107
		WorldAlignPivot selectExpGroup[judgeOBJorSEL_Num]
		selectExpGroup[judgeOBJorSEL_Num].rotation = quat 0.707107 0 0 0.707107
		select selectExpGroup[judgeOBJorSEL_Num]
			
		checkPath = maxfilepath
		export_op = exporterPlugin.classes
		export_fbx = export_op[9]
		FBXExporterSetParam "Animation" false 
		FBXExporterSetParam "BakeAnimation" true 
		FBXExporterSetParam "UseSceneName" true
		FBXExporterSetParam "FileVersion" #FBX201500
		exportfile (checkPath + selectExpGroup[judgeOBJorSEL_Num].name +".FBX") #noprompt selectedonly:true using:export_fbx
		delete selectExpGroup[judgeOBJorSEL_Num]	 		
	 )
	 else()
	 
	if tempOBJ[2] as string == "SubAnim:Space_Warps" then
	(
		local tempCopyOBJ = copy tempOBJ
		tempCopyOBJ.name = tempOBJ.name
		--tempCopyOBJ.pos.X = 0
		--tempCopyOBJ.pos.Y = 0
		resetXform tempCopyOBJ
		ConverttoPoly tempCopyOBJ
		tempCopyOBJ.rotation = quat -0.707107 0 0 0.707107
		WorldAlignPivot tempCopyOBJ
		tempCopyOBJ.rotation = quat 0.707107 0 0 0.707107
		select tempCopyOBJ
			
		checkPath = maxfilepath
		export_op = exporterPlugin.classes
		export_fbx = export_op[9]
		FBXExporterSetParam "Animation" false 
		FBXExporterSetParam "BakeAnimation" true 
		FBXExporterSetParam "UseSceneName" true
		FBXExporterSetParam "FileVersion" #FBX201500
		exportfile (checkPath + tempCopyOBJ.name +".FBX") #noprompt selectedonly:true using:export_fbx
		delete tempCopyOBJ 
	 )
	 else() 	 
 )








