rollout RandomMaterialIDs "随机MaterialIDs" width:210 height:322
(
	checkbox 'chk1' "根据光滑组" pos:[120,20] width:77 height:18 align:#left
	button 'btn1' "模型随机Material IDs" pos:[23,40] width:164 height:27 enabled:true align:#left
	button 'btn2' "面随机Material IDs" pos:[23,73] width:164 height:27 align:#left
	groupBox 'grp8' "模型MaterialID设置" pos:[7,2] width:200 height:314 align:#left
	label 'lbl3' "选择模型随机ID" pos:[23,22] width:90 height:17 align:#left
	groupBox 'grp14' "信息反馈" pos:[13,149] width:186 height:159 align:#left
	button 'ClearInformation' "清除信息" pos:[115,162] width:80 height:19 toolTip:"" align:#left
	listBox 'Information' "单击选择模型" pos:[18,182] width:178 height:7 selection:1 align:#left
	spinner 'spn1' "" pos:[132,106] width:47 height:16 range:[0,20,1] scale:1 align:#left
	spinner 'spn2' "" pos:[132,125] width:47 height:16 range:[0,20,6] scale:1 align:#left
	label 'lbl11' "from：" pos:[99,107] width:35 height:17 align:#left
	label 'lbl12' "to：" pos:[99,125] width:34 height:17 align:#left
	label 'lbl13' "MaterialIDs：" pos:[30,115] width:66 height:28 align:#left
	
	
	---------------------选择模型自动MaterialIDs----------------------------------------------------------	
	fn AutoRandomMaterialIDs = 
	(	
		
		for i in selection do with undo on
		(
			try 
			(
			   selnone = polyOp.getFaceSelection i
			   facenum = polyOp.getNumFaces i
			   ----polyOp.setFaceSelection i #{1..facenum}
			   for j = 1 to facenum do
			   (
					polyOp.setFaceSelection i #{j}
					if chk1.checked then
					(
						r = i.EditablePoly.GetFaceSmoothingGroups j
						for k=1 to 100 do
						(
							r =r/2
							if (r == 0) do
							(
							  r =1
							  exit()
							)						
							if (r == 1) do
							(								
								r = k+1
								exit()								
							)												
						)								  
					)					
					else
					(
						r = random(RandomMaterialIDs.spn1.value as integer)(RandomMaterialIDs.spn2.value as integer)	
						
					)					
					i.EditablePoly.setMaterialIndex r 01
			   )		
			   tempitm = RandomMaterialIDs.Information.items
			   SomeError ="自动分配成功" 
				  Newitm = append tempitm SomeError 
				  RandomMaterialIDs.Information.items = Newitm
			)
			catch
			(
				tempitm = RandomMaterialIDs.Information.items
				SomeError =i.name+"自动分配IDs：没有成功" 
				  Newitm = append tempitm SomeError 
				  RandomMaterialIDs.Information.items = Newitm
			)
		)
	)	
	
	---------------------选择面自动MaterialIDs----------------------------------------------------------	
	fn FaceAutoRandomMaterialIDs = 
	(	
		
		
			try 
			(
			   selnone = polyOp.getFaceSelection $ 
			   facenum = polyOp.getNumFaces $
			   for i in selnone do with undo on
			   (	
					polyOp.setFaceSelection $ #{i}
					
					if chk1.checked then
					(					 			  
					  r = $.EditablePoly.GetFaceSmoothingGroups i
					  for k=1 to 100 do
					  (
							r =r/2
							if (r == 0) do
							(
							  r =1
							  exit()
							)						
							if (r == 1) do
							(								
								r = k+1
								exit()								
							)												
					  )				
					)					
					else
					(
						r = random(RandomMaterialIDs.spn1.value as integer)(RandomMaterialIDs.spn2.value as integer)					
					)
										
					$.EditablePoly.setMaterialIndex r 01
					
					
			   )
		
			   tempitm = RandomMaterialIDs.Information.items
			   SomeError ="自动分配成功" 
				Newitm = append tempitm SomeError 
				  RandomMaterialIDs.Information.items = Newitm
			)
			catch
			(
				tempitm = RandomMaterialIDs.Information.items
				SomeError =$.name+"自动分配IDs：没有成功" 
				  Newitm = append tempitm SomeError 
				  RandomMaterialIDs.Information.items = Newitm
			)
		
	)	
	
	---------------------点击自动MaterialIDs----------------------------------------------------------
	
	on btn1 pressed  do
		AutoRandomMaterialIDs()
	on btn2 pressed  do
		FaceAutoRandomMaterialIDs()
	on ClearInformation pressed  do
		RandomMaterialIDs.Information.items = #("")
)
createdialog RandomMaterialIDs