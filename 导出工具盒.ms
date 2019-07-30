if my_tools !=undefined do try( cui.UnRegisterDialogBar my_tools ;destroydialog my_tools )catch()

-------------------------------------------------------------------------------------------	
fn Lotus_GetName =
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

fn Lotus_GetNameIsNum =
(
	local theGetMAXFileName = maxfilename

	if (findString theGetMAXFileName "(") != undefined then
	(
		MAXFileNameArrayNum = filterString ((filterString ((filterString theGetMAXFileName "(")[2]) ")")[1]) " "
	)
	else ( MAXFileNameArrayNum = #() )
)

fn Lotus_GetCheckPath =
(	
	local thePCDeskTopPath = "C:\Users\Administrator\Desktop" + "\\" --如果桌面位置不再C盘请改此路径
	
	if my_tools.xuanze1.checked == true then
	(
		checkPath = thePCDeskTopPath
	)
	else
	(
		if maxfilepath == "" then ( checkPath = thePCDeskTopPath ) else ( checkPath = maxfilepath )
	)
	return checkPath	
)	

fn Lotus_clean_Attributes =
(
	z=1
	while z !=undefined do
	(
		 x = rootscene
		 z = custattributes.getdef x 1
		 custAttributes.delete x z
	)
)

--------------------------------------------------------------------------------------------------------------------------------
rollout my_tools "导出脚本" width:180 height:320
(	
	groupBox grp1 "设置" pos:[10,10] width:160 height:50
		button daochu1 "规范设置" pos:[15,25] width:150 height:30	tooltip:"设置FPS、分辨率并清理垃圾节点"	 									
	groupBox grp2 "FBX" pos:[10,60] width:160 height:125
		button daochu2 "选择导出" pos:[15,75] width:95 height:30  tooltip:"选择需要导出FBX的部分点击导出"
			button daochu2_1 "+_dj" pos:[112,75] width:30 height:30
		button daochu3 "切帧导出" pos:[15,110] width:80 height:30
		button daochu4 "公共模型 _NOani_" pos:[15,145] width:126 height:30   tooltip:"选择需要导出FBX的部分点击导出，后缀会加上_dj"			
			button Open_1 "+" pos:[145,75] width:20 height:100    tooltip:"选择需要导出FBX的部分点击导出无动画文件，后缀会加上_NOani_0"
			button Open_2 "重命名" pos:[97,110] width:45 height:30    tooltip:"选择需要导出FBX的部分点击导出无动画文件，后缀会加上_NOani_0"
				checkbox xuanze1 "桌面" pos:[110,178] width:50 height:20 align:#left checked:true  tooltip:"勾选后会导出到桌面，反之会在MAX文档旁边"
	groupBox grp3 "AVI" pos:[10,195] width:160 height:56
		button daochu5 "导出AVI" pos:[15,212] width:150 height:30    tooltip:"导出AVI动画"	
				checkbox xuanze2 "标注" pos:[110,244] width:50 height:20 align:#left checked:true  tooltip:"勾选后预示会有标注"
	groupBox grp4 "说明" pos:[10,260] width:160 height:56
		button daochu6 "生成说明文件" pos:[15,280] width:150 height:30    tooltip:"生成说明文件"		
			button v_sm "v3.23" pos:[122,1] width:50 height:13  border:false
	
	on daochu1 pressed do
	(		
		local killLayerArray = #()		
		(layerManager.getLayer 0).current = true
		
		for i = 0 to (layerManager.count - 1) do ( if ((layerManager.getLayer i).getNumChildren() == 0) then( append killLayerArray ((layerManager.getLayer i).name) ) )
		for i = 1 to killLayerArray.count do ( LayerManager.deleteLayerByName killLayerArray[i] )
		
		try
		(
			t=trackviewnodes;n=t[#Max_MotionClip_Manager];deleteTrackViewController t n.controller
			(getproperty trackviewnodes.Anim_Layer_Control_Manager.controller #animlayers).count=0
		)
		catch()
				 
		renderWidth = 1024
		renderHeight = 576
		FrameRate = 25
		animationRange = interval (int(animationRange.start)) (int(animationRange.end))

		Lotus_clean_Attributes()			
	)
	
	on daochu2 pressed do
	(
		local fileName = Lotus_GetName()
		local checkPath = Lotus_GetCheckPath()
				
		export_op = exporterPlugin.classes
		export_fbx = export_op[9]
		FBXExporterSetParam "Animation" true 
		FBXExporterSetParam "BakeAnimation" true 
		FBXExporterSetParam "UseSceneName" true
		FBXExporterSetParam "FileVersion" #FBX201500

		exportfile (checkPath + fileName +".FBX") #noprompt selectedonly:true using:export_fbx
	)

	on daochu2_1 pressed do
	(			
		local fileName = Lotus_GetName()
		local checkPath = Lotus_GetCheckPath()

		export_op = exporterPlugin.classes
		export_fbx = export_op[9]
		FBXExporterSetParam "Animation" true 
		FBXExporterSetParam "BakeAnimation" true 
		FBXExporterSetParam "UseSceneName" true
		FBXExporterSetParam "FileVersion" #FBX201500

		exportfile (checkPath + fileName +"_dj.FBX") #noprompt selectedonly:true using:export_fbx				
	)
	
	on daochu3 pressed do
	(
		try( destroydialog Lotus_cutFBXaniTool )catch()
		if (maxfilename != "") then ( global oldFileName = Lotus_GetName() + "_") else ( global oldFileName = "" )
		global theCutParagraph = 1
		global Lotus_cutFBXaniTool_theSelectionOBJ = selection as array

		rollout Lotus_cutFBXaniTool "Lotus_cutFBXaniTool" width:505 height:92
		(
			edittext st_text "开始帧:" pos:[15,23]  width:120
			edittext ed_text "结束帧:" pos:[15,51]  width:120
			edittext newname_text "段落命名:" pos:[160,20]  width:328 text:oldFileName
			button bt_000 "智" pos:[160,45] width:30 height:30 align:#center
			button bt_001 "执行FBX分段" pos:[203,45] width:100 height:30 align:#center
			button bt_002 "执行分段AVI生成" pos:[307,45] width:100 height:30 align:#center
			button bt_003 "关闭" pos:[410,45] width:75 height:30 align:#center
			
			on st_text entered txt do ( if txt as integer == undefined do ( try( Lotus_cutFBXaniTool.st_text.text = "")catch() ))
			on ed_text entered txt do ( if txt as integer == undefined do ( try( Lotus_cutFBXaniTool.ed_text.text = "")catch() ))
				
			on bt_000 pressed do
			(
				theCutNumArray = Lotus_GetNameIsNum()
				
				if theCutNumArray.count != 0 then
				(
					Lotus_cutFBXaniTool.st_text.text = (filterString theCutNumArray[theCutParagraph] "-")[1]
					Lotus_cutFBXaniTool.ed_text.text = (filterString theCutNumArray[theCutParagraph] "-")[2]
					Lotus_cutFBXaniTool.newname_text.text = Lotus_GetName() + "_" + (theCutParagraph as string)
					
					theCutParagraph += 1
					if theCutParagraph >= (theCutNumArray.count + 1) then
					(
						theCutParagraph = 1
					)
				)
				select Lotus_cutFBXaniTool_theSelectionOBJ
			)
			
			on bt_001 pressed do
			(
				Lotus_cutFBXaniTool_theSelectionOBJ = selection as array
				if Lotus_cutFBXaniTool.st_text.text != "" and Lotus_cutFBXaniTool.ed_text.text != "" do
				(
					baseST = animationRange.start
					baseed = animationRange.end
					theStartNum = Lotus_cutFBXaniTool.st_text.text as integer
					theEndNum = Lotus_cutFBXaniTool.ed_text.text as integer
					animationRange = interval theStartNum theEndNum 
					
					fileName = Lotus_cutFBXaniTool.newname_text.text
					checkPath = Lotus_GetCheckPath()
							
					export_op = exporterPlugin.classes
					export_fbx = export_op[9]
					FBXExporterSetParam "Animation" true 
					FBXExporterSetParam "BakeAnimation" true 
					FBXExporterSetParam "UseSceneName" true
					FBXExporterSetParam "FileVersion" #FBX201500

					exportfile (checkPath + fileName +".FBX") #noprompt selectedonly:true using:export_fbx
					
					animationRange = interval baseST baseed 
				)
				select Lotus_cutFBXaniTool_theSelectionOBJ
			)
			
			on bt_002 pressed do
			(
				Lotus_cutFBXaniTool_theSelectionOBJ = selection as array
				if Lotus_cutFBXaniTool.st_text.text != "" and Lotus_cutFBXaniTool.ed_text.text != "" do
				(
					baseST = animationRange.start
					baseed = animationRange.end
					theStartNum = Lotus_cutFBXaniTool.st_text.text as integer
					theEndNum = Lotus_cutFBXaniTool.ed_text.text as integer
					animationRange = interval theStartNum theEndNum 
					
					global theWHOName = ""
					local checkANIMemberName =#("昕","洁","赐","力","堃","瑶","宏","港","黄")
					for i = 1 to checkANIMemberName.count do 
					(
						if ( doesFileExist ("D:\\"+ checkANIMemberName[i] + ".txt") ) == true do ( theWHOName = checkANIMemberName[i] )
					)
					
					local setFE = Float_Expression ()
							
					local fileName = Lotus_cutFBXaniTool.newname_text.text
					local checkPath = Lotus_GetCheckPath()
					local tempDeleteArray = #()
					local tempHelpsHideArray = #()
					
					SetSelectFilter 6
					max select all
					join tempHelpsHideArray selection
					hide tempHelpsHideArray
					SetSelectFilter 1	
						
					if my_tools.xuanze2.checked == true then
					(
						for i in 1 to 3 do
						(
							Lotus_SM000 = sliderManipulator maxVal:0.0 minVal:0.0 xPos:0.02 yPos:1 isSelected:on sldName:("动画师：" + theWHOName) hide:on
							join tempDeleteArray Lotus_SM000
							Lotus_SM000_1 = sliderManipulator maxVal:0.0 minVal:0.0 xPos:0.3 yPos:1 isSelected:on sldName:("分辨率：" + renderWidth as string + "*" + renderHeight as string) hide:on
							join tempDeleteArray Lotus_SM000_1
							Lotus_SM001 = sliderManipulator maxVal:0.0 minVal:0.0 xPos:0.5 yPos:1 isSelected:on sldName:("时长：" + integer animationrange.start as string + "-" + integer animationrange.end as string) hide:on
							join tempDeleteArray Lotus_SM001
							Lotus_SM002 = sliderManipulator maxVal:animationrange.end minVal:0.0 xPos:0.65 yPos:1 isSelected:on sldName:"当前帧：" 
							Lotus_SM002.value.controller = setFE 
							Lotus_SM002.value.controller.SetExpression "F"
							join tempDeleteArray Lotus_SM002
							Lotus_SM003 = sliderManipulator maxVal:0.0 minVal:0.0 xPos:0.83 yPos:1 isSelected:on sldName:("帧数率：" + FrameRate as string) hide:on
							join tempDeleteArray Lotus_SM003
						)
					)		

					createPreview outputAvi:true start:animationrange.start end:animationrange.end percentSize:100 fps:frameRate dspBones:false dspHelpers:true
					previewScenePath = (getDir #preview) + "\\_scene.avi"
					reNameToPath = checkPath + fileName + theWHOName + ".avi"
					try(deleteFile reNameToPath) catch()
					copyFile previewScenePath reNameToPath	
					
					local theAniServerLinshiPath = "\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\每周任务\\linshi_\\"
					local tempTolinshiAVI = theAniServerLinshiPath + fileName + theWHOName + ".avi"
					try(deleteFile tempTolinshiAVI) catch()
					try(copyFile previewScenePath tempTolinshiAVI)catch()
					
					local theFileName = maxfilename

					local sendToServerSwitch = false
					local sendToServerProjectPath = undefined

					try( theProjectCode = (filterString theFileName "@")[1] )catch( theProjectCode = undefined )
					
					if theProjectCode != undefined then
					(
						local theAniServerPath = "\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\每周任务"  ----主服务器地址
						local serverProjectArray = GetDirectories (theAniServerPath + "\*")
						
						if ( doesFileExist theAniServerPath ) == true then
						(
							for i = 1 to serverProjectArray.count do
							(
								temp_a = filterString serverProjectArray[i] "\\"
								temp_a = temp_a[temp_a.count]
								temp_a = (filterString temp_a "_")[1]
								
								if theProjectCode as string == temp_a then
								(
									sendToServerProjectPath = serverProjectArray[i]
									sendToServerSwitch = true
								)
								else( break )
							)	
						)

						if sendToServerSwitch == true then
						(
							if ( doesFileExist ( sendToServerProjectPath + "\动作") ) == false then 
							(
								HiddenDOSCommand ( "md " + sendToServerProjectPath + "\动作" )
							)
							
							try
							(
								sendToServerProjectPath = ( sendToServerProjectPath + "\动作\\" + fileName + theWHOName + ".avi" )
								deleteFile sendToServerProjectPath
								copyFile previewScenePath sendToServerProjectPath
							)
							catch()
						)
					)
					
					delete tempDeleteArray
					unhide tempHelpsHideArray
					free tempHelpsHideArray
					
					animationRange = interval baseST baseed 
					select Lotus_cutFBXaniTool_theSelectionOBJ
				)
			)
			
			
			on bt_003 pressed do ( try( destroydialog Lotus_cutFBXaniTool )catch();globalVars.remove #theCutParagraph;globalVars.remove #Lotus_cutFBXaniTool_theSelectionOBJ )
		)
		createDialog Lotus_cutFBXaniTool pos:[970,780] style:#(#style_minimizebox)	
	)

	on daochu4 pressed do
	(
		local fileName = Lotus_GetName()
		local checkPath = Lotus_GetCheckPath()

		export_op = exporterPlugin.classes
		export_fbx = export_op[9]
		FBXExporterSetParam "Animation" false 
		FBXExporterSetParam "BakeAnimation" true 
		FBXExporterSetParam "UseSceneName" true
		FBXExporterSetParam "FileVersion" #FBX201500

		exportfile (checkPath + fileName + "_NOani_0" +".FBX") #noprompt selectedonly:true using:export_fbx	
	)
	
	on xuanze1 changed theState do
	(
		local tempDeskTopCheck = "D:\\_DeskTopCheckFalse.txt"
		if xuanze1.checked != true then ( HiddenDOSCommand ("echo. > " + tempDeskTopCheck ) )else( deleteFile tempDeskTopCheck )
	)
			 
	on Open_1 pressed do	 
	(
		local checkPath = Lotus_GetCheckPath()
		shellLaunch "explorer.exe" checkPath										
	)
	
	on Open_2 pressed do	 
	(
		try( destroydialog Lotus_REnameTool )catch()
		if (maxfilename != "") then ( global oldFileName = (filterString maxfilename ".")[1] ) else ( global oldFileName = "" )

		rollout Lotus_REnameTool "Lotus_REnameTool" width:1200 height:95
		(
			edittext edit_text_item "重新命名:" pos:[50,20] text:oldFileName width:1100 
			button bt_001 "执行重命名" pos:[450,50] width:165 height:30 align:#center
			button bt_002 "关闭" pos:[630,50] width:115 height:30 align:#center
		 
			on bt_001 pressed do
			(
				theOldPath_NewName = maxfilepath + maxfilename
				theNewPath_NewName = maxfilepath + Lotus_REnameTool.edit_text_item.text + ".max"
				if theOldPath_NewName != theNewPath_NewName then
				(
					if ( saveMaxFile theNewPath_NewName ) == true  then ( deleteFile theOldPath_NewName ) 
				)
				try( destroydialog Lotus_REnameTool )catch();try( globalVars.remove #oldFileName )catch()
			)
		  
			on bt_002 pressed do ( try( destroydialog Lotus_REnameTool )catch();try( globalVars.remove #oldFileName )catch() )
		)
		createDialog Lotus_REnameTool pos:[270,750] style:#(#style_minimizebox)							
	)
			 
	on daochu5 pressed do
	(
		global theWHOName = ""
		local checkANIMemberName =#("昕","洁","赐","力","堃","瑶","宏","港","黄")
		for i = 1 to checkANIMemberName.count do 
		(
			if ( doesFileExist ("D:\\"+ checkANIMemberName[i] + ".txt") ) == true do ( theWHOName = checkANIMemberName[i] )
		)
		
		local setFE = Float_Expression ()
				
		local fileName = Lotus_GetName()
		local checkPath = Lotus_GetCheckPath()
		local tempDeleteArray = #()
		local tempHelpsHideArray = #()
		
		SetSelectFilter 6
		max select all
		join tempHelpsHideArray selection
		hide tempHelpsHideArray
		SetSelectFilter 1	
			
		if my_tools.xuanze2.checked == true then
		(
			for i in 1 to 3 do
			(
				Lotus_SM000 = sliderManipulator maxVal:0.0 minVal:0.0 xPos:0.02 yPos:1 isSelected:on sldName:fileName hide:on
				join tempDeleteArray Lotus_SM000
				Lotus_SM000_1 = sliderManipulator maxVal:0.0 minVal:0.0 xPos:0.3 yPos:1 isSelected:on sldName:("分辨率：" + renderWidth as string + "*" + renderHeight as string) hide:on
				join tempDeleteArray Lotus_SM000_1
				Lotus_SM001 = sliderManipulator maxVal:0.0 minVal:0.0 xPos:0.5 yPos:1 isSelected:on sldName:("时长：" + integer animationrange.start as string + "-" + integer animationrange.end as string) hide:on
				join tempDeleteArray Lotus_SM001
				Lotus_SM002 = sliderManipulator maxVal:animationrange.end minVal:0.0 xPos:0.65 yPos:1 isSelected:on sldName:"当前帧：" 
				Lotus_SM002.value.controller = setFE 
				Lotus_SM002.value.controller.SetExpression "F"
				join tempDeleteArray Lotus_SM002
				Lotus_SM003 = sliderManipulator maxVal:0.0 minVal:0.0 xPos:0.83 yPos:1 isSelected:on sldName:("帧数率：" + FrameRate as string) hide:on
				join tempDeleteArray Lotus_SM003
			)
		)		

		createPreview outputAvi:true start:animationrange.start end:animationrange.end percentSize:100 fps:frameRate dspBones:false dspHelpers:true
		previewScenePath = (getDir #preview) + "\\_scene.avi"
		reNameToPath = checkPath + fileName + theWHOName + ".avi"
		try(deleteFile reNameToPath) catch()
		copyFile previewScenePath reNameToPath	
		
		local theAniServerLinshiPath = "\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\每周任务\\linshi_\\"
		local tempTolinshiAVI = theAniServerLinshiPath + fileName + theWHOName + ".avi"
		try(deleteFile tempTolinshiAVI) catch()
		try(copyFile previewScenePath tempTolinshiAVI)catch()
		
		local theFileName = maxfilename

		local sendToServerSwitch = false
		local sendToServerProjectPath = undefined

		try( theProjectCode = (filterString theFileName "@")[1] )catch( theProjectCode = undefined )
		
		if theProjectCode != undefined then
		(
			local theAniServerPath = "\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\每周任务"  ----主服务器地址
			local serverProjectArray = GetDirectories (theAniServerPath + "\*")
			
			if ( doesFileExist theAniServerPath ) == true then
			(
				for i = 1 to serverProjectArray.count do
				(
					temp_a = filterString serverProjectArray[i] "\\"
					temp_a = temp_a[temp_a.count]
					temp_a = (filterString temp_a "_")[1]
					
					if theProjectCode as string == temp_a then
					(
						sendToServerProjectPath = serverProjectArray[i]
						sendToServerSwitch = true
					)
					else( break )
				)	
			)

			if sendToServerSwitch == true then
			(
				if ( doesFileExist ( sendToServerProjectPath + "\动作") ) == false then 
				(
					HiddenDOSCommand ( "md " + sendToServerProjectPath + "\动作" )
				)
				
				try
				(
					sendToServerProjectPath = ( sendToServerProjectPath + "\动作\\" + fileName + theWHOName + ".avi" )
					deleteFile sendToServerProjectPath
					copyFile previewScenePath sendToServerProjectPath
				)
				catch()
			)
		)
		
		delete tempDeleteArray
		unhide tempHelpsHideArray
		free tempHelpsHideArray
	)	

	on daochu6 pressed do	
	(
		local MAXFileNameExtract = Lotus_GetName()
		local MAXFileNameArrayNum = Lotus_GetNameIsNum()
		local checkPath = Lotus_GetCheckPath()	
		
		local temp_ = checkPath + MAXFileNameExtract + "说明文件" + ".txt"
		
		if ( doesFileExist temp_ ) != true then
		(
			HiddenDOSCommand ("echo. > " + checkPath + MAXFileNameExtract + "说明文件" + ".txt")
			HiddenDOSCommand ("echo " + "--文件名：" + MAXFileNameExtract + " > " + checkPath + MAXFileNameExtract + "说明文件" + ".txt")
			
			for i = 1 to 3 do
			(
				HiddenDOSCommand ("(echo " + "_" + ") >> " + checkPath + MAXFileNameExtract + "说明文件" + ".txt")
			)
			
			if MAXFileNameArrayNum.count > 0 do
			(
				for i = 1 to MAXFileNameArrayNum.count do 
				(
					HiddenDOSCommand ("(echo " + "" + MAXFileNameArrayNum[i] + "\\\\（如：待机...）" + ") >> " + checkPath + MAXFileNameExtract + "说明文件" + ".txt")
				)
			)
			
			for i = 1 to 3 do
			(
				HiddenDOSCommand ("(echo " + "_" + ") >> " + checkPath + MAXFileNameExtract + "说明文件" + ".txt")
			)
			
			HiddenDOSCommand ("(echo " + "选择模型在BlendShapes组件下以下参数从0过渡到100有相应效果" + ") >> " + checkPath + MAXFileNameExtract + "说明文件" + ".txt")
			
			for i = 1 to 3 do
			(
				HiddenDOSCommand ("(echo " + "（如：blend_001...）" + ") >> " + checkPath + MAXFileNameExtract + "说明文件" + ".txt")
			)
			
			for i = 1 to 3 do
			(
				HiddenDOSCommand ("(echo " + "_" + ") >> " + checkPath + MAXFileNameExtract + "说明文件" + ".txt")
			)
			
			HiddenDOSCommand ("(echo " + "其他说明" + ") >> " + checkPath + MAXFileNameExtract + "说明文件" + ".txt")
			HiddenDOSCommand ("(echo " + "（如：将XX道具挂在XX节点下...）" + ") >> " + checkPath + MAXFileNameExtract + "说明文件" + ".txt")
			
			shellLaunch "explorer.exe"  temp_
		)
		else
		(
			if queryBox "说明文件已经存在>>> \n是否删除旧的说明文件?" beep:false then ( try(deleteFile temp_)catch() )
		)
	)
)

-------------------------------------------------------------------------------------------------------------------------------------------------------		
createdialog my_tools pos:[1347,92]
cui.RegisterDialogBar my_tools
cui.DockDialogBar my_tools #cui_dock_left

--cui.UnRegisterDialogBar my_tools
-------------------------------------------------------------------------------------------------------------------------------------------------------
if ( doesFileExist ("D:\\_DeskTopCheckFalse.txt") == true ) then ( my_tools.xuanze1.checked = false ) else ( my_tools.xuanze1.checked = true )
