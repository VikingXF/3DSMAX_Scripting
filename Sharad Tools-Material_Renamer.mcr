macroScript Material_Renamer category:"Sharad Tools" tooltip:"Material_Renamer"
(
				try destroyDialog :: mltRenamer catch()
				rollout mltRenamer "Material and Object Renamer" width:400 height:530
	(
	
				--UI of script start here 
				radiobuttons objORmat "Choose Things to rename:" labels:#("Scene Objects", "Scene Material") pos:[180,10] offsets:#([0,0], [0,0])
				label 'lbl1' "(Right click to select)" pos:[10,15] --width:115 height:41 align:#left
				multilistbox ObjNames "Scene Objects" pos:[10,30] width:380 height:25 
				
				checkbox 'CKBname' pos:[10,390] checked:true
				editText 'ETBname' "Base Name" pos:[35,390] width:150 height:15 align:#left
				checkbox 'CKNumbered' "    Numbered:" pos:[10,415]
				editText 'ETBaseNumber' "Base:" text:"000" pos:[100,415] width:85 height:15 align:#left
				checkbox 'CKPrefix' pos:[10,440]
				editText 'ETPrefix' "Prefix" pos:[35,440] width:150 height:15 align:#left
				checkbox 'CKSuffix' pos:[10,465]
				editText 'ETSuffix' "Suffix" pos:[35,465] width:150 height:15 align:#left
				button 'BTrename' "Rename" pos:[50,490] width:100 height:30 align:#left
				
				groupBox 'GBreplace' "Replace text" pos:[190,390] Width:205 height:100 align:#left
				editText 'ETfind' "Find text:      " pos:[205,410] width:180 height:15 align:#left
				editText 'ETreplace' "Replace with:" pos:[205,430] width:180 height:15 align:#left
				button 'BTreplace' "Replace" pos:[245,455] width:100 height:30 align:#left
				--UI of script end here
			
					--variables defining starts
					local sceneObjNames = #()
					local sceneObjs = #()
					
					local sceneMats = #()
					local sceneMatNames = #()
					

					 
					--variables defining ends	
					
					on mltRenamer open do
					(
						sceneObjNames = for i in objects where superclassof i==GeometryClass and classof i!=Targetobject and not i.isHiddenInVpt collect i.name
						ObjNames.items = sceneObjNames
					)
					
					--Useful function defining starts here
					
					
					
						-- function for updating object names in list starts
						fn updateObjList =
							(	
								sceneObjNames = for i in objects where superclassof i==GeometryClass and classof i!=Targetobject and not i.isHiddenInVpt collect i.name
								ObjNames.items = sceneObjNames
							)								
							-- function for updating object names in list ends
							
						fn updateMatList =
							(	
								sceneMatNames = for i in scenematerials collect i.name
								ObjNames.items = sceneMatNames
							)
						
							
						fn NumPlease str = ((trimLeft str "0123456789").count == 0) -- function for accepting only numbers...Number please
						
						fn selectObjects = 
							(
								if objORmat.state==1 
								do
								(
									local templist=ObjNames.selection as array 
									clearselection()
									local sceneObjsNames=for i in objects where (superclassof i==GeometryClass and classof i!=Targetobject and not i.isHiddenInVpt) collect i.name
									for i in templist do (selectmore (getNodeByName sceneObjsNames[i]))
									updateObjList()
								)
								if objORmat.state==2  do
								(
									local sceneMats = for i in scenematerials collect i
									local templist = ObjNames.selection as array
									local selMat=for i in templist collect sceneMats[i]
										clearselection()
									for mat in selMat do (selectmore (for o in objects where mat==o.material collect o))
									updateMatList()
								)
								
							)
					
					--Useful function defining ends here
						
						on ObjNames rightClick do (selectObjects())
						
						
						--Changing cpation of multilistbox start
							on objORmat changed state do 
								(
									if objORmat.state==1
									then (ObjNames.caption="Scene Objects"
										updateObjList())
									else (ObjNames.caption="Scene Materials"
												updateMatList())
								)
						--Changing cpation of multilistbox ends		
								
						on ETBaseNumber changed txt do
							(
								if not NumPlease txt do
								(messagebox "You can type only numbers!"
									ETBaseNumber.text="000")
							)--- for accepting only numbers in base number field
						
						
						On BTrename pressed do
										(
												
												if objORmat.state==1 do
												(
													sceneObjs=for i in objects where (superclassof i==GeometryClass and classof i!=Targetobject and not i.isHiddenInVpt) collect i
													local templist = ObjNames.selection as array
														
													
													
													if CKBname.state==true do  
													(  if ETBname.text!="" 
														then
														(
															if templist.count==0
															then
															(
																(for i in sceneObjs do i.name=ETBname.text
																updateObjList())
															)
															else
															(
																(for i in templist do sceneObjs[i].name=ETBname.text
																updateObjList())
															)
														)
														else (messagebox "Enter text in Base Name field!!!")	
													)
													
													
													if CKNumbered.state==true do
															(	
																if CKBname.state==true and ETBname.text=="" 	then updateObjList()
																		
																	else
																		(	
																			if templist.count==0
																			then
																			(
																				local baseNum=ETBaseNumber.text as integer
																				for i in sceneObjs do 
																				(  
																					i.name=i.name + formattedPrint baseNum format:"3.3d"
																					baseNum=baseNum as integer + 1
																				)
																				updateObjList()	
																			)
																			else
																			(
																				local baseNum=ETBaseNumber.text as integer
																				for i in templist do 
																				(  
																					sceneObjs[i].name=sceneObjs[i].name + formattedPrint baseNum format:"3.3d"
																					baseNum=baseNum as integer + 1
																				)
																				updateObjList()	
																			)
																		)	
															)
															
													if CKPrefix.state==true do		
															( 
																if ETPrefix.text !="" 
																do
																	(	if templist.count==0
																		then
																		(
																			for i in sceneObjs do (i.name=ETPrefix.text + i.name)	
																			updateObjList()
																		)
																		else
																		(
																			for i in templist do (sceneObjs[i].name=ETPrefix.text + sceneObjs[i].name)	
																			updateObjList()
																		)
																	)
															)
															
															
													if CKSuffix.state==true do
															( 
																if ETSuffix.text !="" 
																do
																	(	if templist.count==0
																		then
																		(
																			for i in sceneObjs do (i.name= i.name + ETSuffix.text)	
																			updateObjList()
																		)
																		else
																		(
																			for i in templist do (sceneObjs[i].name=sceneObjs[i].name + ETSuffix.text)	
																			updateObjList()
																		)
																	)
															)
															
															
												)	
											
											if objORmat.state==2 do
											(
												updateMatList()
												local sceneMats = for i in scenematerials collect i
												local templist = ObjNames.selection as array
												
												if CKBname.state==true do  
													(  
														if ETBname.text!="" 
														then
														(
															if templist.count==0
															then
															(
																for i in sceneMats do i.name=ETBname.text
																updateMatList()
															)
															else
															(
																for i in templist do sceneMats[i].name=ETBname.text
																updateMatList()
															)
														)
																
														else (messagebox "Enter valid text.")	
													)
													
													
													if CKNumbered.state==true do
															(	
																if CKBname.state==true and ETBname.text=="" then updateMatList()
																else
																(if templist.count==0
																	then
																	(	local baseNum=ETBaseNumber.text as integer
																		for i in sceneMats do 
																		(  
																			i.name=i.name + formattedPrint baseNum format:"3.3d"
																			baseNum=baseNum as integer + 1
																		)
																		updateMatList()
																	)
																	else
																	(	local baseNum=ETBaseNumber.text as integer
																		for i in templist do 
																		(  
																			sceneMats[i].name=sceneMats[i].name + formattedPrint baseNum format:"3.3d"
																			baseNum=baseNum as integer + 1
																		)
																		updateMatList()
																	)
																)
															)
															
													if CKPrefix.state==true do		
															( 
																if ETPrefix.text !="" 
																do
																	(	if templist.count==0
																		then
																		(
																			for i in sceneMats do (i.name=ETPrefix.text + i.name)	
																			updateMatList()
																		)
																		else
																		(
																			for i in templist do (sceneMats[i].name=ETPrefix.text + sceneMats[i].name)	
																			updateMatList()
																		)
																	)
															)
-- 															
-- 															
													if CKSuffix.state==true do
															( 
																if ETSuffix.text !="" 
																do
																	(	if templist.count==0
																		then
																		(
																			for i in sceneMats do (i.name= i.name + ETSuffix.text)	
																			updateMatList()
																		)
																		else
																		(
																			for i in templist do (sceneMats[i].name=sceneMats[i].name + ETSuffix.text)	
																			updateMatList()
																		)
																	)
															)
												
												
												
											)

												
										)


						On BTreplace pressed do
										(
											if objORmat.state==1 do
											(
													updateObjList()
													sceneObjs=for i in objects where (superclassof i==GeometryClass and classof i!=Targetobject and not i.isHiddenInVpt) collect i
														
													local FString = ETfind.text
													local RString = ETreplace.text
													local listSelObj=#()
													if FString !="" 
														do
															( 
																local templist = ObjNames.selection as array
																if templist.count == 0 
																	then
																	(
																		for i in sceneObjs do (i.name=substituteString i.name FString RString)						
																		updateObjList()
																	)
																	else
																	(
																		for i in templist do (sceneObjs[i].name=substituteString sceneObjs[i].name FString RString)						
																		updateObjList()
																	)
															)		
											)
											if objORmat.state==2 do
											(
													updateMatList()
													local sceneMats = for i in scenematerials collect i
														
													local FString = ETfind.text
													local RString = ETreplace.text
													if FString !="" 
														do
															(
																local templist = ObjNames.selection as array
																if templist.count == 0 
																	then
																	(
																		for i in sceneMats do (i.name =substituteString i.name FString RString)
																		updateMatList()
																	)	
																	else
																	(
																		for i in ObjNames.selection do (sceneMats[i].name =substituteString sceneMats[i].name FString RString)
																		updateMatList()
																	)
															)		
											)
										)


										
	)
						
	Createdialog mltRenamer
) 