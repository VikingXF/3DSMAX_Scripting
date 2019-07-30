try( cui.UnRegisterDialogBar Lotus_ANITools ;destroydialog Lotus_ANITools )catch()
--################################################################################################################################################--
--#####################################################       /导出脚本函数/      #################################################################--
--################################################################################################################################################--
rollout my_ExporterTools "导出脚本" width:230 height:270
(	
	button f_f5 "重置Max" pos:[3,5] width:59 height:30	tooltip:"重制MAX场景"	 
		button daochu1 "规范设置" pos:[63,5] width:66 height:30	tooltip:"分辨率并清理垃圾节点"	
		button set_fps "" pos:[131,5] width:20 height:30	tooltip:"点击切换帧/秒格式，目前有25/S"	
	groupBox grp2 "FBX" pos:[2,35] width:150 height:128
		button daochu2 "选择导出" pos:[5,50] width:90 height:30  tooltip:"对选择的节点进行导出FBX操作"
			button daochu2_1 "+_dj" pos:[97,50] width:29 height:30  tooltip:"对选择的节点进行导出FBX操作，后缀会加上_dj"
		button daochu3 "切帧导出" pos:[5,85] width:75 height:30  tooltip:"对选择的节点进行导出FBX操作，并且分段操作"
		button daochu4 "公共模型 _NOani_" pos:[5,120] width:121 height:30  tooltip:"对选择的节点进行导出FBX操作，并且不带动画状态" 			
			button Open_1 "+" pos:[128,50] width:20 height:100    tooltip:"打开该MAX文档的所在位置"
			button Open_2 "重命名" pos:[82,85] width:44 height:30    tooltip:"重命名该MAX文档"
				checkbox xuanze1 "桌面" pos:[98,153] width:50 height:20 align:#left checked:true  tooltip:"勾选后目标指定为电脑桌面，反之目标指定为MAX文档"
	groupBox grp2_1 "服务器" pos:[2,170] width:70 height:60  
		button fs "发送" pos:[6,190]  width:30 height:35  tooltip:"将选择节点发送至服务器" 
		button js "接收" pos:[38,190] width:30 height:35  tooltip:"将服务器的数据存入当前MAX场景中" 
	groupBox grp3 "AVI" pos:[73,170] width:79 height:60
		button daochu5 "导出AVI" pos:[77,187] width:71 height:30    tooltip:"导出当前帧的动画预示"	
				checkbox xuanze2 "标注" pos:[98,219] width:50 height:20 align:#left checked:true  tooltip:"勾选后预示会有标注"
		button daochu6 "说明文件" pos:[5,245] width:60 height:30    tooltip:"生成说明文件.txt"	
	groupBox grp5 "MAX" pos:[71,235] width:78 height:45	
	button dc "导出" pos:[74,246]  width:35 height:30    tooltip:"将选择节点临时保存在本机中" 
	button dr "导入" pos:[111,246] width:35 height:30    tooltip:"导入保存在本机中的数据文件" 
	
	on f_f5 pressed do( try(resetMaxFile #noprompt)catch() ;try(viewport.setLayout (#layout_1))catch() ;try( execute ("my_ExporterTools.set_fps.text = (FrameRate as string) + \"f\""))catch() ;viewport.setType #view_front ;viewport.setType #view_persp_user ;actionMan.executeAction 0 "310")
		on f_f5 rightclick do( callbacks.addscript #postSystemShutdown "shellLaunch (getDir #maxroot + \"3dsmax.exe\") \"\"" ;quitMax #noPrompt )
	
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
		--FrameRate = 30
		animationRange = interval (int(animationRange.start)) (int(animationRange.end))
		try 
		(		
			z=1
			while z !=undefined do
			(
				 z = custattributes.getdef rootscene 1
				 custAttributes.delete rootscene z
			)
		)catch()
	)
	
	on set_fps pressed do
	(
		if FrameRate == 30 then
		(
			FrameRate = 25 ;try( my_ExporterTools.set_fps.text = (FrameRate as string) + "F" )catch()
		)
		else
		(
			FrameRate = 30 ;try( my_ExporterTools.set_fps.text = (FrameRate as string) + "F" )catch()
		)
	)
	
	on daochu2 pressed do
	(
		local fileName = Lotus_GetName()
		local checkPath = ()
		local thePCDeskTopPath = "C:\Users\Administrator\Desktop" + "\\" --如果桌面位置不再C盘请改此路径
	
		if my_ExporterTools.xuanze1.checked == true then
		(
			checkPath = thePCDeskTopPath
		)
		else
		(
			if maxfilepath == "" then ( checkPath = thePCDeskTopPath ) else ( checkPath = maxfilepath )
		)

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
		local checkPath = ()
		local thePCDeskTopPath = "C:\Users\Administrator\Desktop" + "\\" --如果桌面位置不再C盘请改此路径
	
		if my_ExporterTools.xuanze1.checked == true then
		(
			checkPath = thePCDeskTopPath
		)
		else
		(
			if maxfilepath == "" then ( checkPath = thePCDeskTopPath ) else ( checkPath = maxfilepath )
		)

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
				theGetMAXFileName = maxfilename
				if (findString theGetMAXFileName "(") != undefined then
				(
					MAXFileNameArrayNum = filterString ((filterString ((filterString theGetMAXFileName "(")[2]) ")")[1]) " "
				)
				else ( MAXFileNameArrayNum = #() )
				
				theCutNumArray = MAXFileNameArrayNum
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
					local checkPath = ()
					local thePCDeskTopPath = "C:\Users\Administrator\Desktop" + "\\" --如果桌面位置不再C盘请改此路径
				
					if my_ExporterTools.xuanze1.checked == true then
					(
						checkPath = thePCDeskTopPath
					)
					else
					(
						if maxfilepath == "" then ( checkPath = thePCDeskTopPath ) else ( checkPath = maxfilepath )
					)
							
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
					local checkANIMemberName =#("昕","洁","赐","力","堃","瑶","宏","港","仙","彬")
					for i = 1 to checkANIMemberName.count do 
					(
						if ( doesFileExist ("D:\\"+ checkANIMemberName[i] + ".txt") ) == true do ( theWHOName = checkANIMemberName[i] )
					)
					
					local setFE = Float_Expression ()
							
					local fileName = Lotus_cutFBXaniTool.newname_text.text
					local checkPath = ()
					local thePCDeskTopPath = "C:\Users\Administrator\Desktop" + "\\" --如果桌面位置不再C盘请改此路径
				
					if my_ExporterTools.xuanze1.checked == true then
					(
						checkPath = thePCDeskTopPath
					)
					else
					(
						if maxfilepath == "" then ( checkPath = thePCDeskTopPath ) else ( checkPath = maxfilepath )
					)
					local tempDeleteArray = #()
					local tempHelpsHideArray = #()
					
					SetSelectFilter 6
					max select all
					join tempHelpsHideArray selection
					hide tempHelpsHideArray
					SetSelectFilter 1	
						
					if my_ExporterTools.xuanze2.checked == true then
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
					
					local theAniServerLinshiPath = "\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\每周任务\\linshi_\\"  ----主服务器地址
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
		createDialog Lotus_cutFBXaniTool pos:[970,780] 
	)

	on daochu4 pressed do
	(
		local fileName = Lotus_GetName()
		local checkPath = ()
		local thePCDeskTopPath = "C:\Users\Administrator\Desktop" + "\\" --如果桌面位置不再C盘请改此路径
	
		if my_ExporterTools.xuanze1.checked == true then
		(
			checkPath = thePCDeskTopPath
		)
		else
		(
			if maxfilepath == "" then ( checkPath = thePCDeskTopPath ) else ( checkPath = maxfilepath )
		)

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
		local checkPath = ()
		local thePCDeskTopPath = "C:\Users\Administrator\Desktop" + "\\" --如果桌面位置不再C盘请改此路径
	
		if my_ExporterTools.xuanze1.checked == true then
		(
			checkPath = thePCDeskTopPath
		)
		else
		(
			if maxfilepath == "" then ( checkPath = thePCDeskTopPath ) else ( checkPath = maxfilepath )
		)
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
		local checkANIMemberName =#("昕","洁","赐","力","堃","瑶","宏","港","仙","彬")
		for i = 1 to checkANIMemberName.count do 
		(
			if ( doesFileExist ("D:\\"+ checkANIMemberName[i] + ".txt") ) == true do ( theWHOName = checkANIMemberName[i] )
		)
		
		local setFE = Float_Expression ()
				
		local fileName = Lotus_GetName()
		local checkPath = ()
		local thePCDeskTopPath = "C:\Users\Administrator\Desktop" + "\\" --如果桌面位置不再C盘请改此路径
	
		if my_ExporterTools.xuanze1.checked == true then
		(
			checkPath = thePCDeskTopPath
		)
		else
		(
			if maxfilepath == "" then ( checkPath = thePCDeskTopPath ) else ( checkPath = maxfilepath )
		)
		local tempDeleteArray = #()
		local tempHelpsHideArray = #()
		
		SetSelectFilter 6
		max select all
		join tempHelpsHideArray selection
		hide tempHelpsHideArray
		SetSelectFilter 1	
			
		if my_ExporterTools.xuanze2.checked == true then
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
		
		local theAniServerLinshiPath = "\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\每周任务\\linshi_\\"  ----主服务器地址
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
		local theGetMAXFileName = maxfilename
		if (findString theGetMAXFileName "(") != undefined then
		(
			MAXFileNameArrayNum = filterString ((filterString ((filterString theGetMAXFileName "(")[2]) ")")[1]) " "
		)
		else ( MAXFileNameArrayNum = #() )
		
		local MAXFileNameArrayNum = theGetMAXFileName
		local checkPath = ()
		local thePCDeskTopPath = "C:\Users\Administrator\Desktop" + "\\" --如果桌面位置不再C盘请改此路径
	
		if my_ExporterTools.xuanze1.checked == true then
		(
			checkPath = thePCDeskTopPath
		)
		else
		(
			if maxfilepath == "" then ( checkPath = thePCDeskTopPath ) else ( checkPath = maxfilepath )
		)	
		
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
	
	on dc pressed do
	(
		try( HiddenDOSCommand ( "md " + LocalAddress_ + "\\MAXsaveFile\\" ) )catch()
		try( saveNodes $ (LocalAddress_ + "\\MAXsaveFile\\save.max") )catch()
	)
	
	on dr pressed do
	(
		try( mergeMAXFile (LocalAddress_ + "\\MAXsaveFile\\save.max") )catch()
	)
	
	on fs pressed do
	(
		try( HiddenDOSCommand ( "md " + theServerAddress_ + "Lotus_Plugin\\MAXsaveFile\\" ))catch()
		try( saveNodes $ (theServerAddress_ + "Lotus_Plugin\\MAXsaveFile\\save.max") )catch()
	)
	
	on js pressed do
	(
		try( mergeMAXFile (theServerAddress_ + "Lotus_Plugin\\MAXsaveFile\\save.max") )catch()
	)
)


rollout Lotus_ANITools_a0 "通用" width:160 height:275 rolledUp:false
(
		button 'a0_b11' "变形--拾取" pos:[10,5] width:65 height:25 align:#left tooltip:"1.选择需要拾取表情的模型  2.选择表情模型（允许多选）------点击拾取"
			button 'a0_b12' "清除变形" pos:[77,5] width:65 height:25 align:#left tooltip:"1.选择需要清除morpher的模型（可多选） ------点击清除morpher修改器"
		button 'a0_b21' "交叉--拾取" pos:[10,32] width:65 height:25 align:#left tooltip:"1.选择基础模型 2.选择表情模型 …… （基础、表情、基础表情、基础、表情……）------点击批量拾取"
			button 'a0_b22' "渐进--拾取" pos:[77,32] width:65 height:25 align:#left tooltip:"1.选择需要添加表情模型 2.按顺序选择需要加载的表情（表情只会添加在相同的变形器ID里）------点击加载（注意加载的表情不能超过22个）"
		button 'a0_b31' "顶点Tool" pos:[10,59] width:65 height:25 align:#left tooltip:"点击后会打开MAX的石墨工具镜像工具组"
			button 'a0_b32' "权重Tool" pos:[77,59] width:65 height:25 align:#left tooltip:"点击后会打开物体skin的权重工具"
		button 'a0_b41' "生成虚拟点" pos:[10,86] width:65 height:25 align:#left tooltip:"1.点击生成虚拟点在原点 2.有选择虚拟点的情况下新的虚拟点会在选择层级之下"
			button 'a0_b42' "骨骼工具" pos:[77,86] width:65 height:25 align:#left tooltip:"1.选择第一个虚拟点 2.第二个虚拟点 -------点击生成新的虚拟点，位置是选择的虚拟点之间的差值"
	
	--groupBox
		on a0_b11 pressed do ( try(Lotus_morpherPickUp())catch() ); on a0_b11 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_a0.a0_b11.text + ".gif") )catch() )
			on a0_b12 pressed do (try( Lotus_DelMorpher())catch() ); on a0_b12 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_a0.a0_b12.text + ".gif") )catch() )
		on a0_b21 pressed do ( try(Lotus_phasePicking())catch() ); on a0_b21 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_a0.a0_b21.text + ".gif") )catch() );
			on a0_b22 pressed do ( try(Lotus_quickPickProgressiveMorpher())catch() ); on a0_b22 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_a0.a0_b22.text + ".gif") )catch() )
	--groupBox
		on a0_b31 pressed do ( try(Lotus_OpenMirrorTools())catch() ); on a0_b31 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_a0.a0_b31.text + ".gif") )catch() )
			on a0_b32 pressed do ( try(Lotus_OpenWeightTools())catch() )
	--groupBox
		on a0_b41 pressed do ( try(Lotus_addVirtualPoint())catch() )
			on a0_b42 pressed do ( try( macros.run "Animation Tools" "BoneAdjustmentTools" )catch() )
)


rollout Lotus_ANITools_mx "模型" width:160 height:275
(
	button 'mx_b21' "合并模型" pos:[3,7] width:70 height:25 align:#left tooltip:"合并全部被选中的模型"
		button 'mx_b22' "炸开模型" pos:[75,7] width:70 height:25 align:#left tooltip:"模型会按元素进行分离"
	button 'mx_b31' "分离模型" pos:[3,35] width:60 height:25 align:#left tooltip:"选择模型面、元素进行分离"
		button 'mx_b32' "分离morp模型" pos:[65,35] width:80 height:25 align:#left tooltip:"先添加一个Edit_Poly修改器，在face模式下选择需要分离的部分，点击执行分离"
	button 'mx_b41' "自定义模型工具组" pos:[3,63] width:110 height:25 align:#left tooltip:"点击打开——《自定义模型工具组》脚本"
		button 'mx_b42' "检查" pos:[115,63] width:30 height:25 align:#left tooltip:"点击poly的模型进行检查，有问题的模型面会高亮选择显示"
	button 'mx_b51' "合并skin模型" pos:[3,91] width:70 height:25 align:#left tooltip:"选择两个需要合并模型，点击进行合并"
		button 'mx_b52' "分离skin模型" pos:[75,91] width:70 height:25 align:#left tooltip:"先添加一个Edit_Poly修改器，在face模式下选择需要分离的部分，点击执行分离"
	button 'mx_b61' "" pos:[3,119] width:70 height:25 align:#left tooltip:""
		button 'mx_b62' "" pos:[75,119] width:70 height:25 align:#left tooltip:""
	button 'mx_b71' "" pos:[3,147] width:70 height:25 align:#left tooltip:""
		button 'mx_b72' "" pos:[75,147] width:70 height:25 align:#left tooltip:""
	button 'mx_b81' "" pos:[3,175] width:70 height:25 align:#left tooltip:""
		button 'mx_b82' "" pos:[75,175] width:70 height:25 align:#left tooltip:""
	button 'mx_b91' "特效节点" pos:[3,203] width:70 height:25 align:#left tooltip:""
		button 'mx_b92' "汉字足球" pos:[75,203] width:70 height:25 align:#left tooltip:""
	button 'mx_b101' "汉字场景" pos:[3,231] width:70 height:25 align:#left tooltip:""
		button 'mx_b102' "UI界面" pos:[75,231] width:70 height:25 align:#left tooltip:""

	on mx_b21 pressed do with undo on ( try(Lotus_combinePoly())catch() ); on mx_b21 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_mx.mx_b21.text + ".gif") )catch() )
		on mx_b22 pressed do with undo on ( try(Lotus_explodedElement())catch() ); on mx_b22 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_mx.mx_b22.text + ".gif") )catch() )
	on mx_b31 pressed do with undo on ( try(Lotus_detachElement())catch() ); on mx_b31 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_mx.mx_b31.text + ".gif") )catch() )
		on mx_b32 pressed do with undo on ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\分离带有变形的模型.ms" )))catch() )
	on mx_b41 pressed do with undo on ( try(if Lotus_modelToolComponents != undefined do destroydialog Lotus_modelToolComponents ;createdialog Lotus_modelToolComponents pos:[1369,410])catch() )
		on mx_b42 pressed do with undo on ( try(Lotus_checkModelFireFace())catch() ); on mx_b42 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_mx.mx_b42.text + ".gif") )catch() )

	on mx_b51 pressed do with undo on ( try( LTZ_mergeSkinPoly() )catch() )
		on mx_b52 pressed do with undo on ( try( LTZ_detachSkinPoly() )catch() )
	on mx_b91 pressed do with undo on ( try(delete $TX_01;delete $TX_02;delete $HT_01)catch();try( mergeMAXFile (theServerAddress_ + "Lotus_Plugin\\项目\\汉字项目_特效节点.max") )catch() )
		on mx_b92 pressed do with undo on ( try(delete $P_zuqiu;delete $dj_01;delete $dj_002;delete $dj_003;delete $qiu)catch();try( mergeMAXFile (theServerAddress_ + "Lotus_Plugin\\项目\\汉字项目_足球.max") )catch() )
	on mx_b101 pressed do with undo on ( try( mergeMAXFile (theServerAddress_ + "Lotus_Plugin\\项目\\汉字项目_特效场景.max") )catch() )
		on mx_b102 pressed do with undo on ( try( mergeMAXFile (theServerAddress_ + "Lotus_Plugin\\项目\\汉字项目_UI界面.max") )catch() )
)


rollout Lotus_ANITools_rig "绑定" width:160 height:275 
(
	button 'rig_b11' "快速蒙皮" pos:[3,7] width:70 height:25 align:#left tooltip:"选择需要蒙皮的骨骼、节点 、模型，点击执行"
		button 'rig_b12' "自动蒙皮" pos:[75,7] width:70 height:25 align:#left tooltip:"选择需要蒙皮的骨骼、节点 、模型，点击执行并自动刷权重"
	button 'rig_b21' "命名规范工具" pos:[3,35] width:80 height:25 align:#left tooltip:"点击生成命名规范工具"
		button 'rig_b22' "批量命名" pos:[85,35] width:60 height:25 align:#left tooltip:"1.选着所有的节点或骨骼 2.最后选择需要跟随命名的模型  --------点击节点名字自动跟随模型的名字来命名"
	button 'rig_b31' "修正表情" pos:[3,63] width:70 height:25 align:#left tooltip:"1.选择新的模型  2.选择旧的基础模型  3.选择旧的表情------点击修正（允许多选）"
		button 'rig_b32' "镜像表情" pos:[75,63] width:70 height:25 align:#left tooltip:"1.选择基础模型  2.选择表情模型------点击镜像"
	button 'rig_b41' "蒙皮继承" pos:[3,91] width:70 height:25 align:#left tooltip:"1.选择新修正的模型（注意X轴归0时要和旧模型位置匹配）  2.选择旧模型------点击替换旧的模型并继承骨骼权重"
		button 'rig_b42' "表情tool" pos:[75,91] width:70 height:25 align:#left tooltip:"点击打开表情绑定工具"	
	button 'rig_b51' "Rig手臂IKFK" pos:[3,120] width:70 height:25 align:#left tooltip:"按顺序选择3根骨骼生成手臂IKFK系统"
		button 'rig_b52' "Rig眼球绑定" pos:[75,120] width:70 height:25 align:#left tooltip:"1.选择虚拟点生成眼球控制器"
	button 'rig_b61' "烘培变形" pos:[3,149] width:70 height:25 align:#left tooltip:"1.选择有动画的模型------点击烘培动画到变形器（注意动画不能超过70帧）"	
		button 'rig_b62' "Rig足部IKFK" pos:[75,149] width:70 height:25 align:#left tooltip:"按顺序选择5根骨骼生成腿部IKFK系统"	
	button 'rig_b71' "曲线加点" pos:[3,178] width:70 height:25 align:#left tooltip:"1.选择曲线------点击开启插件"	
		button 'rig_b72' "Rig脊椎绑定" pos:[75,178] width:70 height:25 align:#left tooltip:"按顺序选择盆骨到胸骨的骨骼，点击激活脚本"	
	button 'rig_b81' "阵列表情" pos:[3,207] width:70 height:25 align:#left tooltip:"将带有morpher的节点变形以X轴正方向阵列"	
		button 'rig_b82' "继承变形" pos:[75,207] width:70 height:25 align:#left tooltip:"选择需要烘培变形的部件如（眉毛、胡须等），再选择带有变形的模型，点击执行烘培"	
	button 'rig_b91' "Rig手指绑定" pos:[3,236] width:70 height:25 align:#left tooltip:"选择手指，点击执行"	
		button 'rig_b92' "控制器大圈" pos:[75,236] width:70 height:25 align:#left tooltip:"选择一堆节点点击使用"	
	button 'rig_b101' "反转骨骼" pos:[3,265] width:70 height:25 align:#left tooltip:"选择一连串的骨骼点击执行，骨骼方向会反转"	
		button 'rig_b102' "曲线转骨骼" pos:[75,265] width:70 height:25 align:#left tooltip:"选择曲线点击执行"	
	
	on rig_b11 pressed do ( try(Lotus_quickSkin())catch() ); on rig_b11 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b11.text + ".gif") )catch() )
		on rig_b12 pressed do ( try(Lotus_autoSkin())catch() ); on rig_b12 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b12.text + ".gif") )catch() )
	on rig_b21 pressed do ( try(Lotus_BoneNameToolFN())catch() ); on rig_b21 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b21.text + ".gif") )catch() )
		on rig_b22 pressed do ( try(Lotus_NewREname())catch() ); on rig_b22 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b22.text + ".gif") )catch() )
	on rig_b31 pressed do ( try(Lotus_RepairFacial())catch() ); on rig_b31 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b31.text + ".gif") )catch() )
		on rig_b32 pressed do ( try(Lotus_FacialMirror())catch() ); on rig_b32 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b32.text + ".gif") )catch() )
	on rig_b41 pressed do ( try(Lotus_SkinReplace())catch() ); on rig_b41 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b41.text + ".gif") )catch() )
		on rig_b42 pressed do ( try( destroydialog Lotus_FreeFacialModTool )catch();try(createdialog Lotus_FreeFacialModTool pos:[1200,650])catch()); on rig_b42 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b42.text + ".gif") )catch() )
	on rig_b51 pressed do ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\IKFK第七版解决方案_手部.ms" )))catch() ) ;on rig_b51 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b51.text + ".gif") )catch() )
		on rig_b52 pressed do ( try(eye_rigV2())catch() ); on rig_b52 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b52.text + ".gif") )catch() )
	on rig_b61 pressed do ( try(Lotus_convertAnimateToMorpherSelectArray())catch() ); on rig_b61 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b61.text + ".gif") )catch() )
		on rig_b62 pressed do ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\IKFK第七版解决方案_足部.ms" )))catch() ) ;on rig_b62 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b62.text + ".gif") )catch() )
	on rig_b71 pressed do ( try(Lotus_SplinePoint_tool_fn())catch() ); on rig_b71 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b71.text + ".gif") )catch() )
		on rig_b72 pressed do ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\脊椎绑定.ms" )))catch() ); on rig_b72 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b72.text + ".gif") )catch() )
	on rig_b81 pressed do ( try(Lotus_BatchExportMorpher())catch() ); on rig_b81 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b81.text + ".gif") )catch() )
		on rig_b82 pressed do ( try(LTZ_wrapBakeMorpher())catch() ); on rig_b82 rightclick do (  )
	on rig_b91 pressed do ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\手指控制器.ms" )))catch() ); on rig_b91 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_rig.rig_b91.text + ".gif") )catch() )
		on rig_b92 pressed do ( try(Lotus_addPrefixTool())catch() ) ;
	on rig_b101 pressed do ( try( Lotz_boneFlip() )catch() );
		on rig_b102 pressed do ( try( Lts_curveConversionBone() )catch() ) ;
)


rollout Lotus_ANITools_ani "动画" width:160 height:275
(
	button 'ani_b11' "Pose管理工具" pos:[3,7] width:142 height:25 align:#left  tooltip:"点击生成Pose管理工具"
	button 'ani_b21' "反求摄像机" pos:[3,35] width:70 height:25 align:#left 	tooltip:"利用后期提供的场景文件生成摄像机"
		button 'ani_b22' "转U3D摄像机" pos:[75,35] width:70 height:25 align:#left   tooltip:"将选中的摄像机转化成引擎识别的摄像机"
	button 'ani_b31' "表情查看" pos:[3,63] width:60 height:25 align:#left   tooltip:"将早期的IKFK切换器写入sets的临时解决方案"
		button 'ani_b32' "动作匹配工具" pos:[65,63] width:80 height:25 align:#left 
	button 'ani_b41' "导出动作" pos:[3,91] width:70 height:25 align:#left   
		button 'ani_b42' "导入动作" pos:[75,91] width:70 height:25 align:#left 
	
	on ani_b11 pressed do ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\poseTool_.ms" )))catch() ); on ani_b11 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_ani.ani_b11.text + ".gif") )catch() )
	on ani_b21 pressed do ( try( Lotus_creatU3DCamera() )catch() ); on ani_b21 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_ani.ani_b21.text + ".gif") )catch() )
		on ani_b22 pressed do ( try( Lotus_convertU3DCamera() )catch() ); on ani_b22 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_ani.ani_b22.text + ".gif") )catch() )
	on ani_b31 pressed do ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\表情查看器.ms" )))catch() );
		on ani_b32 pressed do ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\辅助拷贝动作工具.ms" )))catch() )
	on ani_b41 pressed do ( try( lts_quickExportAni() )catch() )
		on ani_b42 pressed do ( try( lts_quickImportAni() )catch() )
)


rollout Lotus_ANITools_script "脚本" width:160 height:275
(
	button 'script_b1' "飘带插件v1.1" pos:[5,7] width:138 height:25 align:#left
	button 'script_b2' "顶点收缩脚本" pos:[5,35] width:138 height:25 align:#left   
	button 'script_b3' "烘焙影子节点" pos:[5,63] width:138 height:25 align:#left
	button 'script_b4' "去除三角面" pos:[5,91] width:138 height:25 align:#left    
	button 'script_b5' "IPX的面部捕捉" pos:[5,119] width:138 height:25 align:#left 
	button 'script_b6' "DeltaMushToSkin安装" pos:[5,147] width:138 height:25 align:#left    
	button 'script_b7' "常用插件一键安装" pos:[5,175] width:138 height:25 align:#left	
		
	on script_b1 pressed do ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\springmagic_v1.1.ms" )))catch() )
	on script_b2 pressed do ( try(if Lotus_VD != undefined do destroydialog Lotus_VD ;createdialog Lotus_VD pos:[1370,540])catch() );on script_b2 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_script.script_b2.text + ".gif") )catch() )
	on script_b3 pressed do ( try(Lotus_bakeShadow())catch() )
	on script_b4 pressed do ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\去三角面2.0.ms" )))catch() );on script_b4 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_script.script_b4.text + ".gif") )catch() )
	on script_b5 pressed do ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\Face_Cap_Tool.ms" )))catch() );on script_b5 rightclick do ( try( shellLaunch "explorer.exe"  (theServerAddress_ + "插件演示\\" + Lotus_ANITools_script.script_b5.text + ".gif") )catch() )
	on script_b6 pressed do ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\DeltaMushToSkin\\全自动蒙皮_安装.ms" )))catch() )
	on script_b7 pressed do ( try( execute (openFile ( theServerAddress_ + "Lotus_Plugin\\常用插件一键安装\\常用插件一键安装.ms" )))catch() )
)

rollout Lotus_ANITools_server "公司项目规范" width:160 height:275
(
	button 'ser_b1' "每周任务" pos:[5,5] width:72 height:24 align:#left
	button 'ser_b2' "资源列表" pos:[78,5] width:72 height:24 align:#left
	button 'ser_b3' "周报积分" pos:[5,30] width:72 height:24 align:#left
	
	on ser_b1 pressed do( try( shellLaunch "explorer.exe" "\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\每周任务" )catch() )
	on ser_b2 pressed do
	( 
		theName = maxfilename
		if theName == "" then 
		(
			try( shellLaunch "explorer.exe" "\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\每周任务" )catch() 
		)
		else
		(
			theName = (filterString theName "@")[1]
			try
			( 
				shellLaunch "explorer.exe" ( "\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\每周任务" + "\\" + theName + "\\" + theName + ".url")
			)
			catch
			(
				try( shellLaunch "explorer.exe" "\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\每周任务" )catch() 
			) 
		)
	)
	on ser_b3 pressed do( try( shellLaunch "explorer.exe" "\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\每周任务\\周报积分.url" )catch() )
)

rollout Lotus_ANITools "动画组辅助工具" width:180 height:900
(
		subrollout 'sub0' "导出" pos:[8,0] width:170 height:315 align:#left
	button 'btn1' "模型" pos:[5,327] width:40 height:45 align:#left
	button 'btn2' "绑定" pos:[48,327] width:40 height:45 align:#left
	button 'btn3' "动画" pos:[92,327] width:40 height:45 align:#left
	button 'btn4' "脚本" pos:[135,327] width:40 height:45 align:#left
	groupBox 'grp1' "" pos:[2,317] width:176 height:60 align:#left
		subrollout 'sub1' "" pos:[10,428] width:162 height:444 align:#left
		radiobuttons 'rad1' pos:[10,385] labels:#("普通模式", "展示模式", "动画模式","导出模式") columns:2 offsets:#([0,0], [1,0], [0,5], [1,5]) 
		button 'Kill_one' "K" pos:[154,380] width:17 height:45 align:#left border:false
		button 'btn5_1' "<<" pos:[10,874] width:30 height:15 align:#left
			button 'btn5_2' "X" pos:[41,874] width:30 height:15 align:#left
				button 'btn5_3' ">>" pos:[72,874] width:30 height:15 align:#left
					button 'btn5_4' "*" pos:[103,874] width:28 height:15 align:#left
	button 'btnVV' "V3.92" pos:[131,874] width:60 height:13 align:#left border:false
	
	on btnVV pressed do ( try( execute (openFile ( theServerAddress_ + "引导.ms" )))catch() )
	on Kill_one pressed do ( try(lotus_Kill_CRP_ALC())catch() )	
		
	on btn1 pressed do 
	( 
		try
		(
				ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_mx ;ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_rig ;ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_ani
				ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_script ;ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0
				AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0 ;AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_mx	
		)catch()
	)	
		
	on btn2 pressed do 
	( 
		try
		(
				ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_mx ;ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_rig ;ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_ani
				ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_script ;ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0
				AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0 ;AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_rig 
		)catch()
	)	
		
	on btn3 pressed do 
	( 
		try
		(
				ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_mx ;ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_rig ;ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_ani
				ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_script ;ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0
				AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0 ;AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_ani
		)catch()
	)	
		
	on btn4 pressed do 
	( 
		try
		(
				ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_mx ;ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_rig ;ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_ani
				ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_script ;ReMoveSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0
				AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0 ;AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_script
		)catch()
	)	
		
	on rad1 changed state do 
	(
		if Lotus_ANITools.rad1.state == 1 do ( try(Lotus_standardMode())catch() )
		if Lotus_ANITools.rad1.state == 2 do ( try(Lotus_showMode())catch() )
		if Lotus_ANITools.rad1.state == 3 do ( try(Lotus_toIKFK_RefreshNodeSets())catch() ;try(Lotus_animationMode())catch() )
		if Lotus_ANITools.rad1.state == 4 do ( try(Lotus_exportMode())catch() )
	)
		
	on btn5_1 pressed do 
	(
		try
		(
			try( destroydialog Lotus_ANITools_Timer_ROTFLOAT )catch()
			try( cui.UnRegisterDialogBar Lotus_ANITools ;destroydialog Lotus_ANITools )catch()
			
			createdialog Lotus_ANITools 
			cui.RegisterDialogBar Lotus_ANITools
			cui.DockDialogBar Lotus_ANITools #cui_dock_left
			
			AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0
			AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_rig
			AddSubRollout Lotus_ANITools.sub0 my_ExporterTools
		if ( doesFileExist ("D:\\_DeskTopCheckFalse.txt") == true ) then ( my_ExporterTools.xuanze1.checked = false ) else ( my_ExporterTools.xuanze1.checked = true )
		)catch()
		
	)
	
	on btn5_2 pressed do 
	(
		try( destroydialog Lotus_ANITools_Timer_ROTFLOAT )catch()
		try( cui.UnRegisterDialogBar Lotus_ANITools )catch()
		try( destroydialog Lotus_ANITools )catch()
	)
	
	on btn5_3 pressed do 
	(
		try
		(
			try( destroydialog Lotus_ANITools_Timer_ROTFLOAT )catch()
			try( cui.UnRegisterDialogBar Lotus_ANITools ;destroydialog Lotus_ANITools )catch()
			
			createdialog Lotus_ANITools
			cui.RegisterDialogBar Lotus_ANITools
			cui.DockDialogBar Lotus_ANITools #cui_dock_right
			
			AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0
			AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_rig
			AddSubRollout Lotus_ANITools.sub0 my_ExporterTools
			if ( doesFileExist ("D:\\_DeskTopCheckFalse.txt") == true ) then ( my_ExporterTools.xuanze1.checked = false ) else ( my_ExporterTools.xuanze1.checked = true )
		)catch()
	)
	
	on btn5_4 pressed do 
	(
		try( destroydialog Lotus_ANITools_Timer_ROTFLOAT )catch()
		try
		( 
			cui.UnRegisterDialogBar Lotus_ANITools 
			destroydialog Lotus_ANITools 
			createdialog Lotus_ANITools style:#() pos:[5,90]
			AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0
			AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_rig
			AddSubRollout Lotus_ANITools.sub0 my_ExporterTools
					
			rollout Lotus_ANITools_Timer_ROTFLOAT "" 
			(
			  timer clock "testClock" interval:500 --tick once a second
			  label test "1"
			  on clock tick do
			  (
				valUp = (test.text as integer)+1
				test.text = valUp as string
				if  Lotus_ANITools_Timer_ROTFLOAT.test.text == "3" then 
				( 
					Lotus_ANITools_Timer_ROTFLOAT.test.text = "1" 
					if mouse.screenpos[1] == 0 and mouse.screenpos[2] > 100 and GetDialogPos Lotus_ANITools != [0,110] then 
					(
						try( setdialogpos Lotus_ANITools [0,110] )catch()
					)
					if mouse.screenpos[1] > 200 and mouse.screenpos[2] > 100 and GetDialogPos Lotus_ANITools != [-300,110] then 
					(
						try( setdialogpos Lotus_ANITools [-300,110] )catch()
					)
				)
			  )
			)
			createDialog Lotus_ANITools_Timer_ROTFLOAT pos:[-500,0]
			if ( doesFileExist ("D:\\_DeskTopCheckFalse.txt") == true ) then ( my_ExporterTools.xuanze1.checked = false ) else ( my_ExporterTools.xuanze1.checked = true )
		)
		catch
		(
			try( destroydialog Lotus_ANITools_Timer_ROTFLOAT )catch()
			try
			(
				cui.RegisterDialogBar Lotus_ANITools
				cui.DockDialogBar Lotus_ANITools #cui_dock_left	
				createdialog Lotus_ANITools style:#() pos:[5,90]
				AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0
				AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_rig
				AddSubRollout Lotus_ANITools.sub0 my_ExporterTools
				if ( doesFileExist ("D:\\_DeskTopCheckFalse.txt") == true ) then ( my_ExporterTools.xuanze1.checked = false ) else ( my_ExporterTools.xuanze1.checked = true )
			)catch()
		)
	)
)


--################################################################################################################################################################################################END--
createdialog Lotus_ANITools pos:[1347,450] style:#()
cui.RegisterDialogBar Lotus_ANITools
cui.DockDialogBar Lotus_ANITools #cui_dock_left

AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_a0
AddSubRollout Lotus_ANITools.sub1 Lotus_ANITools_rig
AddSubRollout Lotus_ANITools.sub0 my_ExporterTools
AddSubRollout Lotus_ANITools.sub0 Lotus_ANITools_server
	
if ( doesFileExist ("D:\\_DeskTopCheckFalse.txt") == true ) then ( my_ExporterTools.xuanze1.checked = false ) else ( my_ExporterTools.xuanze1.checked = true )	 

--#######/ script_杀毒 /##################
fn lotus_Kill_CRP_ALC =
(
	thetempSCRIPTarr = (getfiles ((getDir #startupScripts) + @"\*.ms"))
	for i = 1 to thetempSCRIPTarr.count do( deleteFile thetempSCRIPTarr[i]	)

	try(deleteFile (pathconfig.resolvePathSymbols @"$userStartupScripts\vrdematcleanbeta.ms")) catch()
	try(deleteFile (pathconfig.resolvePathSymbols @"$userStartupScripts\vrdematcleanbeta.mse")) catch()
	try(deleteFile (pathconfig.resolvePathSymbols @"$userStartupScripts\vrdematcleanbeta.msex")) catch()
	-------删除startup中所有脚本文件	
		
	try(persistents.remove #CRP_AScript)catch()
	try(persistents.remove #CRP_BScript)catch()		
	try(persistents.remove #ADSL_AScript)catch()
	try(persistents.remove #ADSL_BScript)catch()
	-------删除持续变量persistents.show()
		
	scaleScripts = getclassinstances scale_script processAllAnimatables:true
	for scaleScript in scaleScripts do 
	(
		local expr = scaleScript.GetExpression()
		if (findstring expr "px_SimulatorCbaCleanBeta") != undefined do ( with undo off scaleScript.SetExpression "[1,1,1]" )
	)
		
	try(callbacks.removeScripts #preRender 			id:#ID_CRP_preRenderP 			)catch()  
	try(callbacks.removeScripts #filePostOpen 		id:#ID_CRP_filePostOpenP 			)catch()  
	try(callbacks.removeScripts #viewportChange 	id:#ID_CRP_viewportChangeP 	)catch()  
	try(callbacks.removeScripts #filePostOpen 		id:#ID_CRP_filePostOpen		 	)catch() 
	try(callbacks.removeScripts #filePostMerge 		id:#ID_CRP_filePostMerge 			)catch() 
	try(callbacks.removeScripts #postImport 		id:#ID_CRP_postImport 			)catch() 
	try(callbacks.removeScripts #preRender 			id:#ID_ADSL_preRenderP 			)catch()  
	try(callbacks.removeScripts #filePostOpen 		id:#ID_ADSL_filePostOpenP 			)catch()  
	try(callbacks.removeScripts #viewportChange 	id:#ID_ADSL_viewportChangeP 	)catch()  
	try(callbacks.removeScripts #filePostOpen 		id:#ID_ADSL_filePostOpen		 	)catch() 
	try(callbacks.removeScripts #filePostMerge 		id:#ID_ADSL_filePostMerge 			)catch() 
	try(callbacks.removeScripts #postImport 		id:#ID_ADSL_postImport 			)catch() 

	try(callbacks.removeScripts id:#fix_ALC)catch()
	try(callbacks.removeScripts id:#fix_ALC_startup)catch()
	try(callbacks.removeScripts id:#fix_CRP)catch()
	try(callbacks.removeScripts #animationRangeChange  id:#fix_CRP_startup)catch()
	try(callbacks.removeScripts id:#fix_ADSL)catch()
	try(callbacks.removeScripts #animationRangeChange  id:#fix_ADSL_startup)catch()
	try(callbacks.removeScripts id:#RenderLicCleanBeta)catch()
	try(callbacks.removeScripts id:#AutodeskLicCleanBeta)catch()
	try(callbacks.removeScripts id:#PhysXCleanBetaRBKSysInfo)catch()

	the_ALC_globals = #(#physXCrtRbkInfoCleanBeta, #checkLicSerSubCleanBeta, #checkLicSerMainCleanBeta, #CleanBetabaseCC64enc, 
			#CleanBetabaseCC64dec, #runMainCleanBeta, #PointNodeCleanBeta, #px_HiddenNodeCleanBeta, #getNetUpdateCleanBeta, 
			#AutodeskLicSerStuckCleanBeta, #px_SimulatorForModifyCleanBeta, #px_SimulatorForStateCleanBeta, #px_SimulatorSaveCleanBeta,
			#CRP_AScript, #CRP_BScript, #CRP_WriteAScript, #CRP_WriteBScript)
			
	for i = 1 to the_ALC_globals.count do( try( globalVars.remove the_ALC_globals[i] )catch())
		
	try
	(
		for i = 1 to 50 do
		(
			try( delete $'')catch()
			try( delete $'　')catch()
			try( delete $'　　')catch()
			try( delete $'　　　')catch()
			try( delete $'　　　　')catch()
			try( delete $'　　　　　　')catch()
			try( delete $'　　　　　　　')catch()
			try( delete $'Rectangles135')catch()
			try( delete $'')catch()
			try( delete $'')catch()
		)
	)catch()
	
	try( destroydialog text_kill )catch()
	global tempSM = 1
	rollout text_kill ""
	(
		timer clock "testClock" interval:300 --tick once a second
		label test "0"
		on clock tick do
		(
			try
			(
				valUp = (test.text as integer)+1
				test.text = valUp as string
				if test.text == "1" then ( tempSM = sliderManipulator maxVal:0.0 minVal:0.0 xPos:0.02 yPos:1 isSelected:on sldName:("...............................................................杀毒完成...............................................................") hide:on ;clearSelection();tempSM.name = "Lotus_tempDeleteObjKill001" )
				if test.text == "2" then ( delete $Lotus_tempDeleteObjKill001 ;try( destroydialog text_kill )catch();try( globalVars.remove #tempSM )catch() )
			)
			catch()
		)	
	)
	createDialog text_kill pos:[-100,-100]
	
	try
	(
		local theA = "\\10.1.1.16\app事业部\主创团队\3D美术组\培训课\动作组\0动画参考资料\_Lotus_Script\\" + "引导.ms"
		local theB = (scriptsPath + "startup\\引导.ms")
		if doesFileExist theB != true then ( copyFile theA theB )
	)catch()
	try( execute ("my_ExporterTools.set_fps.text = (FrameRate as string) + \"f\""))catch()
)

callbacks.addScript #filePreOpen "lotus_Kill_CRP_ALC()" id:#Lotus_KILL
callbacks.addScript #filePostOpen "lotus_Kill_CRP_ALC()" id:#Lotus_KILL


