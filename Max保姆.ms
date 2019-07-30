/*
encryptscript "D:\\个人文件夹\\myscript\\maxall2.ms"
renameFile "D:\\个人文件夹\\myscript\\maxall2.mse" "e:\\交换文档\\Max保姆.mse"
*/

----------------------------------------关于	

rollout ab "About"
(
	groupbox gb1 "MAX保姆:" width:210 height:130
	label lab0 "版本: 2.9" pos:[95,25]
	label lab1 "回到天堂"  pos:[93,60]
	label lab2 "paradise@vip.qq.com"
	--label lab3 "QQ: 22233911"
	hyperlink mylink "版本更新" address:"http://bbs.hxsd.com/showthread.php?p=11127236&posted=1#post11127236" pos:[93,115] color:blue
)


----------------------------------------批量LookAt

	rollout batlookat "批量LookAt (场)"
		(	
			label lab1 "目标物体:无" pos:[20,10]
			pickbutton pic1 "选择目标物体" pos:[140,5] tooltip:"选择一个被LookAt物体"
			spinner sp1 "权重:" range:[0,100,50] width:70  pos:[25,33]
			spinner sp2 "Viewline Length:" rang:[-99999,99999,0] width:70 pos:[160,33]
			groupbox gb1 "Select LookAt Axis:" width:144 height:40 pos:[4,53]
			radiobuttons rb1 labels:#("X","Y","Z") pos:[10,70]
			checkbox cb1 "Flip" pos:[107,70]
			checkbox cb2 "替换原目标" pos:[155,70] checked:true

			button done1 "LookAt" pos:[60,100]
			button done2 "UnLook" pos:[130,100] tooltip:"取消LookAt"
			on pic1 picked obj do
				(
					global obj1 = undefined
					obj1 = obj
					lab1.caption = "目标物体:" + obj1.name as string
				)
			on done1 pressed do  with undo label:"批量Lookat" on
				(	
					if obj1 == undefined then messageBox "请选择目标物体"
						else
							if selection.count>0 then 
								(
									for a in selection do
										( 
											if classof a.rotation.controller == Euler_XYZ then
												(
													try
													(
														a.rotation.controller = rotation_list()
														try 
														(
															a.rotation.controller.lookat_constraint.controller
														)
														catch
														(
															a.rotation.controller.available.controller = lookat_constraint()
														)
														if cb2.checked == true then
															(
																n = a.rotation.controller.lookat_constraint.controller.getNumTargets()
																a.rotation.controller.lookat_constraint.controller.deleteTarget n
															)
														a.rotation.controller.lookat_constraint.controller.appendtarget obj1 sp1.value
														a.rotation.controller.lookat_constraint.controller.Vector_Length = sp2.value
														a.rotation.controller.lookat_constraint.controller.target_axis = (rb1.state-1)
														a.rotation.controller.lookat_constraint.controller.target_axisFlip = cb1.checked
													)
													catch
													(
														messageBox "LookAt失败"
														exit
													)
												)
												else 
													(
														try 
															(
																if cb2.checked == true then
																	(
																		n = a.rotation.controller.lookat_constraint.controller.getNumTargets()
																		a.rotation.controller.lookat_constraint.controller.deleteTarget n
																	)
																a.rotation.controller.lookat_constraint.controller.appendtarget obj1 sp1.value
																a.rotation.controller.lookat_constraint.controller.Vector_Length = sp2.value
																a.rotation.controller.lookat_constraint.controller.target_axis = (rb1.state-1)
																a.rotation.controller.lookat_constraint.controller.target_axisFlip = cb1.checked
																	
															)
														catch 
															(
																try
																(
																	a.rotation.controller.available.controller = lookat_constraint()
																	a.rotation.controller.lookat_constraint.controller.appendtarget obj1 sp1.value
																	a.rotation.controller.lookat_constraint.controller.Vector_Length = sp2.value
																	a.rotation.controller.lookat_constraint.controller.target_axis = (rb1.state-1)
																	a.rotation.controller.lookat_constraint.controller.target_axisFlip = cb1.checked
																)
																catch
																(
																	messageBox "LookAt失败"
																	exit
																)
															)

													)
	
										)
								)
								else messageBox "请选择物体"
				)
			on done2 pressed do with undo label:"批量UnLookAt" on
				(
					for a in selection do
					(
						try
							(
								n = a.rotation.controller.count
								for c = 1 to n do
									(
										if a.rotation.controller[c].name ==  "LookAt Constraint" then
											a.rotation.controller.delete c else()
									)
							)
						catch (false)
					)
				)
		)
		
----------------------------------------关联物体



	rollout insobj "关联物体 (场)"
	(
		fn insobjfn obj2 getbase getmtl getpos kepos inpos getrot kerot inrot getscl kescl inscl getvisb invib =
		(
			if selection.count>0 then
			(
				if getbase == true do
				(
					for a in selection do
					(
						instanceReplace a obj2
						a.objectoffsetpos = obj2.objectoffsetpos
						a.objectoffsetrot = obj2.objectoffsetrot
					)
				)
				if getmtl == true do
				(
					for a in selection do
					(
						try
							a.material = obj2.material
						catch
							false
					)
				)
				if getvisb == true do
				(
					for a in selection do
					(
						try
						(
							a.visibility = true
							if invib == true then
								a.visibility.controller = obj2.visibility.controller
							else
								a.visibility.controller = copy obj2.visibility.controller
						)
						catch
							false
					)
				)
				if getpos == true do
				(
						for a in selection do
						(
							savpos = a.pos
							try
							(
								if inpos == true then
									a.pos.controller = obj2.pos.controller
								else
									a.pos.controller = copy obj2.pos.controller
							)
							catch
								false
							if kepos == true do
								a.pos = savpos
						)
				)
				if getrot == true do
				(
						for a in selection do
						(
							savrot = a.rotation
							try
							(
								if inrot == true then
									a.rotation.controller = obj2.rotation.controller
								else
									a.rotation.controller = copy obj2.rotation.controller
							)
							catch
								false
							if kerot == true do
								a.rotation = savrot
						)
				)
				if getscl == true do
				(
						for a in selection do
						(
							savscl = a.scale
							try
							(
								if inscl == true then
									a.scale.controller = obj2.scale.controller
								else
									a.scale.controller = copy obj2.scale.controller
							)
							catch
								false
							if kescl == true do
								a.scale = savscl
						)
				)		
			)
			else 
				messageBox "请选择关联物体"
		)
		label lab1 "参照物体:无"
		pickbutton pic1 "选择参照物体" tooltip:"选择一个物体作为参照"
		checkbox thebase "关联属性" pos:[15,50] checked:true
		checkbox mtl "关联材质" pos:[95,50] checked:true
		groupbox mkeys "复制/实例关键帧:" pos:[10,70] width:220 height:100
		checkbox posi "移动" pos:[20,90]
		checkbox keeppos "保持当前位置" pos:[80,90] checked:true enabled:false
		checkbox inspos "实例" pos:[180,90] enabled:false
		checkbox rota "旋转" pos:[20,110]
		checkbox keeprot "保持当前角度" pos:[80,110] enabled:false
		checkbox insrot "实例" pos:[180,110] enabled:false
		checkbox scl "缩放" pos:[20,130]
		checkbox keepscl "保持当前缩放" pos:[80,130] enabled:false
		checkbox insscl "实例" pos:[180,130] enabled:false
		checkbox visb "可见性" pos:[20,150]
		checkbox insvib "实例" pos:[180,150] enabled:false
		button done1 "关联" tooltip:"选中一个或多个被取代物体" pos:[100,180]

		on posi changed state do
		(
			if posi.checked == true then
			(
				keeppos.enabled = true
				if keeppos.checked == false do
					inspos.enabled = true
			)
			else
			(
				keeppos.enabled = false
				inspos.enabled = false
			)
		)
		on keeppos changed state do
		(
			inspos.enabled = not inspos.enabled
			if keeppos.checked == true do
				inspos.checked = false
		)
		on rota changed state do
		(
			if rota.checked == true then
			(
				keeprot.enabled = true
				if keeprot.checked == false do
					insrot.enabled = true
			)
			else
			(
				keeprot.enabled = false
				insrot.enabled = false
			)
		)
		on keeprot changed state do
		(
			insrot.enabled = not insrot.enabled
			if keeprot.checked == true do
				insrot.checked = false
		)
		on scl changed state do
		(
			if scl.checked == true then
			(
				keepscl.enabled = true
				if keepscl.checked == false do
					insscl.enabled = true
			)
			else
			(
				keepscl.enabled = false
				insscl.enabled = false
			)
		)
		on keepscl changed state do
		(
			insscl.enabled = not insscl.enabled
			if keepscl.checked == true do
				insscl.checked = false
		)
		on visb changed state do
			insvib.enabled = not insvib.enabled
		on pic1 picked obj do
		(
			global objins = undefined
			objins = obj
			lab1.caption = "参照物体:" + objins.name as string
		)
		on done1 pressed do  with undo label:"关联物体" on
		(	
			if lab1.caption == "参照物体:无" then 
				messageBox "请选择参照物体"
			else
				insobjfn objins thebase.checked mtl.checked posi.checked keeppos.checked inspos.checked rota.checked keeprot.checked insrot.checked scl.checked keepscl.checked insscl.checked visb.checked insvib.checked
		)	)
		
----------------------------------------随机坐标		

	
	rollout ran "随机 移动/旋转/缩放 (坐)"
	(
		fn random_transform ck spl sph cki:ran.rint.checked sps:ran.rstp.value =
		(
			if ck == true then
			(
				if cki == true then
					global ran_tr = ((random spl sph) as integer)*sps
				else
					global ran_tr = random spl sph
			)
			else 
				global ran_tr = 0
		)
		
		fn ranP_sav cls_sta =
		(
			ran_val_save = #(#(),#(),#(),#())	
			ran_val_save[1][1] = ran.rlx.value
			ran_val_save[1][2] = ran.rhx.value
			ran_val_save[1][3] = ran.rx.checked
			ran_val_save[2][1] = ran.rly.value
			ran_val_save[2][2] = ran.rhy.value
			ran_val_save[2][3] = ran.ry.checked
			ran_val_save[3][1] = ran.rlz.value
			ran_val_save[3][2] = ran.rhz.value
			ran_val_save[3][3] = ran.rz.checked
			ran_val_save[4][1] = ran.coords.state
			ran_val_save[4][2] = ran.rint.checked
			ran_val_save[4][3] = ran.rstp.value
			ran_val_save[4][4] = ran.rstp.enabled
			ran_val_save[4][5] = ran.rloxy.checked
			ran_val_save[4][6] = ran.rloyz.checked
			ran_val_save[4][7] = ran.rloall.checked
			
			case cls_sta of
			(
				1: global ranP_val_save = ran_val_save
				2: global ranR_val_save = ran_val_save
				3: global ranS_val_save = ran_val_save
			)
		)
		radiobuttons tran_cls labels:#("移动","旋转","缩放") pos:[20,8]
		button reset "Reset" pos:[180,5] tooltip:"重设回默认参数"
		radiobuttons coords "坐标系:" labels:#("World","Local","Parent") pos:[40,30] default:1
		checkbox rx "X:" pos:[12,65] checked:true
		checkbox ry "Y:" pos:[12,85] checked:true
		checkbox rz "Z:" pos:[12,105]
		spinner rlx "MIN:" pos:[62,65] width:52 range:[-9999999,9999999,-10]
		spinner rhx "MAX:" pos:[142,65] width:52 range:[-9999999,9999999,10]
		spinner rly "MIN:" pos:[62,85] width:52 range:[-9999999,9999999,-10]
		spinner rhy "MAX:" pos:[142,85] width:52 range:[-9999999,9999999,10]
		spinner rlz "MIN:" pos:[62,105] width:52 range:[-9999999,9999999,-10]
		spinner rhz "MAX:" pos:[142,105] width:52 range:[-9999999,9999999,10]
		checkbutton rloxy ")" pos:[198,75] height:18 width:12
		checkbutton rloyz ")" pos:[198,95] height:18 width:12
		checkbutton rloall "§" pos:[215,73] height:42 width:12 checked:true
		checkbox rint "整数" pos:[20,130]
		spinner rstp "步幅:"  pos:[90,130] width:50 range:[-99999,99999,1] enabled:false type:#integer
		button done "解算" pos:[150,128] tooltip:"点/线/面 随机只支持Poly"
		label tips "点/线/面 目前只支持世界坐标下随机移动" pos:[10,160]
	
		on reset pressed do
		(
			ranP_val_save = ranR_val_save = ranS_val_save = undefined
			tran_cls.state = 1
			rlx.range = rly.range = rlz.range = rhx.range = rhy.range = rhz.range = [-99999999,99999999,0]
			rlx.value = rly.value = rlz.value = -10
			rhx.value = rhy.value = rhz.value = 10
			rx.checked = ry.checked = true
			rz.checked = false
			coords.state = 1
			rloxy.checked = false
			rloyz.checked = false
			rloall.checked = true
			rint.checked = false
			rstp.enabled = false
		)
		
		on tran_cls changed state do
		(
			case tran_cls.state of
			(
				1:
				(
					rlx.range = rly.range = rlz.range = rhx.range = rhy.range = rhz.range = [-99999999,99999999,0]
					rlx.value = rly.value = rlz.value = -10
					rhx.value = rhy.value = rhz.value = 10
					rx.checked = ry.checked = true
					rz.checked = false
					coords.state = 1
					rloxy.checked = false
					rloyz.checked = false
					rloall.checked = true
					rint.checked = false
					rstp.enabled = false
					
					try
					(
						rlx.value = ranP_val_save[1][1]
						rhx.value = ranP_val_save[1][2]
						rx.checked = ranP_val_save[1][3]
						rly.value = ranP_val_save[2][1]
						rhy.value = ranP_val_save[2][2]
						ry.checked = ranP_val_save[2][3]
						rlz.value = ranP_val_save[3][1]
						rhz.value = ranP_val_save[3][2]
						rz.checked = ranP_val_save[3][3]
						coords.state = ranP_val_save[4][1]
						rint.checked = ranP_val_save[4][2]
						rstp.value = ranP_val_save[4][3]
						rstp.enabled = ranP_val_save[4][4]
						rloxy.checked = ranP_val_save[4][5]
						rloyz.checked = ranP_val_save[4][6]
						rloall.checked = ranP_val_save[4][7]
					)
					catch
						false
				)
				2:
				(
					rlx.range = rly.range = rlz.range = rhx.range = rhy.range = rhz.range = [-99999999,99999999,0]
					rlx.value = rly.value = rlz.value = -360
					rhx.value = rhy.value = rhz.value = 360
					rx.checked = ry.checked = false
					rz.checked = true
					coords.state = 1
					rloxy.checked = false
					rloyz.checked = false
					rloall.checked = true
					rint.checked = false
					rstp.enabled = false
					
					try
					(
						rlx.value = ranR_val_save[1][1]
						rhx.value = ranR_val_save[1][2]
						rx.checked = ranR_val_save[1][3]
						rly.value = ranR_val_save[2][1]
						rhy.value = ranR_val_save[2][2]
						ry.checked = ranR_val_save[2][3]
						rlz.value = ranR_val_save[3][1]
						rhz.value = ranR_val_save[3][2]
						rz.checked = ranR_val_save[3][3]
						coords.state = ranR_val_save[4][1]
						rint.checked = ranR_val_save[4][2]
						rstp.value = ranR_val_save[4][3]
						rstp.enabled = ranR_val_save[4][4]
						rloxy.checked = ranR_val_save[4][5]
						rloyz.checked = ranR_val_save[4][6]
						rloall.checked = ranR_val_save[4][7]
					)
					catch
						false
				)
				3:
				(
					rlx.range = rly.range = rlz.range = rhx.range = rhy.range = rhz.range = [0,99999999,1]
					rlx.value = rly.value = rlz.value = 0.5
					rhx.value = rhy.value = rhz.value = 2
					rx.checked = ry.checked = rz.checked = true
					coords.state = 2
					rloxy.checked = false
					rloyz.checked = false
					rloall.checked = true
					rint.checked = false
					rstp.enabled = false
					
					try
					(
						rlx.value = ranS_val_save[1][1]
						rhx.value = ranS_val_save[1][2]
						rx.checked = ranS_val_save[1][3]
						rly.value = ranS_val_save[2][1]
						rhy.value = ranS_val_save[2][2]
						ry.checked = ranS_val_save[2][3]
						rlz.value = ranS_val_save[3][1]
						rhz.value = ranS_val_save[3][2]
						rz.checked = ranS_val_save[3][3]
						coords.state = ranS_val_save[4][1]
						rint.checked = ranS_val_save[4][2]
						rstp.value = ranS_val_save[4][3]
						rstp.enabled = ranS_val_save[4][4]
						rloxy.checked = ranS_val_save[4][5]
						rloyz.checked = ranS_val_save[4][6]
						rloall.checked = ranS_val_save[4][7]
					)
					catch
						false
				)
			)
		)
		
		on rloall changed state do
		(
			if rloall.checked == true then
			(
				rloxy.checked = false
				rloyz.checked = false
				rlz.value = rly.value = rlx.value
				rhz.value = rhy.value = rhx.value
			)
		)
		
		on rloxy changed state do
		(
			if rloxy.checked == true then
			(
				rloall.checked = false
				if rloyz.checked == false then
				(
					rly.value = rlx.value
					rhy.value = rhx.value
				)
				else
				(
					rlz.value = rlx.value
					rhz.value = rhx.value
				)
			)
		)
		
		on rloyz changed state do
		(
			if rloyz.checked == true then
			(
				rloall.checked = false
				rlz.value = rly.value
				rhz.value = rhy.value
			)
		)
		
		on rlx changed state do
		(	
			if rloall.checked == true then
				rly.value = rlz.value = rlx.value
			if rloxy.checked == true then
				if rloyz.checked == true then
					rlz.value = rlx.value
				else
					rly.value = rlx.value
		)
		on rhx changed state do
		(	
			if rloall.checked == true then
				rhy.value = rhz.value = rhx.value
			if rloxy.checked == true then
				if rloyz.checked == true then
					rhz.value = rhx.value
				else
					rhy.value = rhx.value
		)
		
		on rly changed state do
		(	
			if rloall.checked == true then
				rlx.value = rlz.value = rly.value
			if rloxy.checked == true and rloyz.checked == false then
				rlx.value = rly.value
			if rloyz.checked == true and rloxy.checked == false then
				rlz.value = rly.value
		)
		on rhy changed state do
		(	
			if rloall.checked == true then
				rhx.value = rhz.value = rhy.value
			if rloxy.checked == true and rloyz.checked == false then
				rhx.value = rhy.value
			if rloyz.checked == true and rloxy.checked == false then
				rhz.value = rhy.value
		)
		
		on rlz changed state do
		(
			if rloall.checked == true then
				rlx.value = rly.value = rlz.value
			if rloyz.checked == true then
				if rloxy.checked == true then
					rlx.value = rlz.value
				else
					rly.value = rlz.value
		)
		on rhz changed state do
		(
			if rloall.checked == true then
				rhx.value = rhy.value = rhz.value
			if rloyz.checked == true then
				if rloxy.checked == true then
					rhx.value = rhz.value
				else
					rhy.value = rhz.value
		)
		
		on rint changed state do
		(
			if rint.checked == true then
				rstp.enabled = true
			else
				rstp.enabled = false
		)
	
		on done pressed do  with undo label:"随机变换" on
		(
			ranP_sav tran_cls.state
			
			case tran_cls.state of
			(
				1:
				(
					if selection.count == 1 and classof $ == Editable_Poly and subobjectlevel != undefined and subobjectlevel != 0 then
					(
						if subobjectlevel == 1 then
						(
							for a in getvertselection $ do
							(
								random_transform rx.checked rlx.value rhx.value
									px1 = ran_tr
								random_transform ry.checked rly.value rhy.value
									py1 = ran_tr
								random_transform rz.checked rlz.value rhz.value
									pz1 = ran_tr
									
								polyop.movevert $ a [px1,py1,pz1]
							)
						)
						if subobjectlevel == 2 then
						(							
							edgesel = polyop.getedgeselection $
							for i = 1 to (edgesel as array).count do
							(
								random_transform rx.checked rlx.value rhx.value
									px1 = ran_tr
								random_transform ry.checked rly.value rhy.value
									py1 = ran_tr
								random_transform rz.checked rlz.value rhz.value
									pz1 = ran_tr
									
								vertsel = polyOp.getVertsUsingedge $ (edgesel as array)[i]
								polyOp.moveVert $ vertsel [px1,py1,pz1]
							)
						)
						if subobjectlevel == 3 then
						(
							borseled = #{}
							alledge = #{}
							theseled = polyop.getedgeselection $
							allbor = polyop.getopenedges $
							for i = 1 to polyop.getnumedges $ do
								append alledge i
							theseled = theseled - (alledge - allbor)
							while (theseled as array).count != 0 do
							(
								random_transform rx.checked rlx.value rhx.value
									px1 = ran_tr
								random_transform ry.checked rly.value rhy.value
									py1 = ran_tr
								random_transform rz.checked rlz.value rhz.value
								
								pz1 = ran_tr
								borseled = polyOp.getBorderFromEdge $ (theseled as array)[1]
								vertsel = polyOp.getVertsUsingedge $ borseled
								polyOp.moveVert $ vertsel [px1,py1,pz1]
								theseled -= borseled
							)
						)
						if subobjectlevel == 4 then
						(							
							facesel = polyop.getfaceselection $
							for i = 1 to (facesel as array).count do
							(
								random_transform rx.checked rlx.value rhx.value
									px1 = ran_tr
								random_transform ry.checked rly.value rhy.value
									py1 = ran_tr
								random_transform rz.checked rlz.value rhz.value
									pz1 = ran_tr
									
								vertsel = polyOp.getVertsUsingFace $ (facesel as array)[i]
								polyOp.moveVert $ vertsel [px1,py1,pz1]
							)
						)
						if subobjectlevel == 5 then
						(
							elmseled = #{}
							theseled = polyop.getfaceselection $
							while (theseled as array).count != 0 do
							(
								random_transform rx.checked rlx.value rhx.value
									px1 = ran_tr
								random_transform ry.checked rly.value rhy.value
									py1 = ran_tr
								random_transform rz.checked rlz.value rhz.value
									pz1 = ran_tr
		
								elmseled = polyOp.getElementsUsingFace $ (theseled as array)[1]
								vertsel = polyOp.getVertsUsingFace $ elmseled
								polyOp.moveVert $ vertsel [px1,py1,pz1]
								theseled -= elmseled 
							)
						)
					)
					else
					(
						for p in selection do 
						(
							random_transform rx.checked rlx.value rhx.value
							px1 = ran_tr
								
							random_transform ry.checked rly.value rhy.value
							py1 = ran_tr
								
							random_transform rz.checked rlz.value rhz.value
							pz1 = ran_tr
								
							if coords.state == 1 then
								in coordsys world move p [px1,py1,pz1]
							else if coords.state == 2 then
									in coordsys local move p [px1,py1,pz1]
								else if coords.state == 3 then
										in coordsys parent move p [px1,py1,pz1]
						)
					)
				)
				2:
				(
					for p in selection do 
					(
						random_transform rx.checked rlx.value rhx.value
						rx1 = ran_tr
						random_transform ry.checked rly.value rhy.value
						ry1 = ran_tr
						random_transform rz.checked rlz.value rhz.value
						rz1 = ran_tr
		
						if coords.state == 1 then
						(
							in coordsys world rotate p (angleaxis rx1 [1,0,0])
							in coordsys world rotate p (angleaxis ry1 [0,1,0])
							in coordsys world rotate p (angleaxis rz1 [0,0,1])
						)
						else if coords.state == 2 then
							(
								in coordsys local rotate p (angleaxis rx1 [1,0,0])
								in coordsys local rotate p (angleaxis ry1 [0,1,0])
								in coordsys local rotate p (angleaxis rz1 [0,0,1])
							)
							else if coords.state == 3 then
								(
									in coordsys parent rotate p (angleaxis rx1 [1,0,0])
									in coordsys parent rotate p (angleaxis ry1 [0,1,0])
									in coordsys parent rotate p (angleaxis rz1 [0,0,1])
								)
					)
				)
				3:
				(
					for p in selection do 
					(
						random_transform rx.checked rlx.value rhx.value
						sx1 = ran_tr
						random_transform ry.checked rly.value rhy.value
						sy1 = ran_tr
						random_transform rz.checked rlz.value rhz.value
						sz1 = ran_tr
						
						if rloall.checked == true then
							sz1 = sy1 = sx1
						if rloxy.checked == true and rloyz.checked == false then
							sy1 = sx1
						if rloyz.checked == true and rloxy.checked == false then
							sz1 = sy1
						if rloxy.checked == true and rloyz.checked == true then
							sz1 = sx1
	
						if rx.checked == true and ry.checked == true and rz.checked == true then
						(
							if coords.state == 1 then
								in coordsys world scale p [sx1,sy1,sz1]
							else if coords.state == 2 then
									in coordsys local scale p [sx1,sy1,sz1]
								else if coords.state == 3 then
										in coordsys parent scale p [sx1,sy1,sz1]
						)
						
						else if rx.checked == true and ry.checked == true then
						(
								if coords.state == 1 then
									in coordsys world scale p [sx1,sy1,1]
								else if coords.state == 2 then
										in coordsys local scale p [sx1,sy1,1]
									else if coords.state == 3 then
											in coordsys parent scale p [sx1,sy1,1]
						)
						else if rx.checked == true and rz.checked == true then
						(
							if coords.state == 1 then
								in coordsys world scale p [sx1,1,sz1]
							else if coords.state == 2 then
									in coordsys local scale p [sx1,1,sz1]
								else if coords.state == 3 then
										in coordsys parent scale p [sx1,1,sz1]
						)
						else if ry.checked == true and rz.checked == true then
						(
							if coords.state == 1 then
								in coordsys world scale p [1,sy1,sz1]
							else if coords.state == 2 then
									in coordsys local scale p [1,sy1,sz1]
								else if coords.state == 3 then
										in coordsys parent scale p [1,sy1,sz1]
						)
								
						else if rx.checked == true then
						(
							if coords.state == 1 then
								in coordsys world scale p [sx1,1,1]
							else if coords.state == 2 then
									in coordsys local scale p [sx1,1,1]
								else if coords.state == 3 then
										in coordsys parent scale p [sx1,1,1]
						)
						else if ry.checked == true then
						(
							if coords.state == 1 then
								in coordsys world scale p [1,sy1,1]
							else if coords.state == 2 then
									in coordsys local scale p [1,sy1,1]
								else if coords.state == 3 then
										in coordsys parent scale p [1,sy1,1]
						)
						else if rz.checked == true then
						(
							if coords.state == 1 then
								in coordsys world scale p [1,1,sz1]
							else if coords.state == 2 then
									in coordsys local scale p [1,1,sz1]
								else if coords.state == 3 then
										in coordsys parent scale p [1,1,sz1]
						)
					)
				)
			)
		)
	)
			

----------------------------------------坐标复位

rollout transzero "坐标复位 (坐)"
(
		button poszero "Position" pos:[20,5] tooltip:"重设物体到场景中心"
		button rotzero "Rotation" pos:[93,5]  tooltip:"重设物体旋转角度为零"
		button sclzero "Scale" pos:[170,5] tooltip:"重设物体缩放为百分百"
	
		on poszero pressed do with undo label:"位移复位" on
		(
			for a in selection do a.pos = [0,0,0]
		)
		on rotzero pressed do with undo label:"角度复位" on
		(
			for a in selection do
			(
				a.rotation.controller.x_rotation = 0
				a.rotation.controller.y_rotation = 0
				a.rotation.controller.z_rotation = 0
			)
		)
		on sclzero pressed do with undo label:"缩放复位" on
		(
			for a in selection do a.scale = [1,1,1]
		)
)

		
----------------------------------------变换轴心
		
rollout transPivot "变换轴心点 (坐)" width:247 height:344
(
	
	local alignToObj=0,
		  usePivot
	pickButton alObj "对齐到:物体" pos:[14,4]		width:150		height:15
	button alSel "清除" 		pos:[180,4] 		width:35 		height:15 
	button al5 "X_Max" 		pos:[14,30] 		width:95 		height:15
	button al6 "X_Min" 		pos:[121,30] 		width:95 		height:15
	button al1 "Y_Max" 		pos:[14,50] 		width:95  	height:15
	button al3 "Y_Min" 		pos:[121,50] 		width:95 		height:15
	button al2 "Z_Max" 		pos:[14,70] 		width:95 		height:15
	button al4 "Z_Min" 		pos:[121,70] 		width:95 		height:15
	button alc  "中心"			pos:[14,90]		width:95		height:15
	button alR "随机" 			pos:[121,90] 		width:95		height:15
	spinner mult "倍率" 		pos:[24,120] 		width:75 		height:16		 range:[0,10,1]
	spinner multR "倍率随机" 	pos:[125,120] 	width:90 		height:16		 range:[0,10,0]
	
	----------------------
	fn rotatePivotOnly obj rotation = 
	( 
		local rotValInv=rotation as quat
		animate off
		in coordsys local obj.rotation*=RotValInv
		obj.objectoffsetrot*=RotValInv
		obj.objectoffsetpos*=RotValInv
	)
	on alObj picked obj do (alignToObj= obj; alObj.text=("对齐到: "+obj.name); sel=getCurrentSelection(); for i=1 to sel.count do (resetPivot sel[i];  rotatePivotOnly sel[i] alignToObj.rotation;  sel[i].pivot=alignToObj.pivot) )
	on alSel pressed do (alignToObj=0; alObj.text="对齐到:物体")
	on al1 pressed do with undo label:"Y_Max" on ( sel=getCurrentSelection(); for i=1 to sel.count do (obj=if alignToObj==0 then sel[i] else alignToObj; sel[i].pivot.y=obj.max.y+(mult.value-1+random 0.0 multR.value)*(obj.max.y-obj.min.y) ) )
	on al2 pressed do with undo label:"Z_Max" on ( sel=getCurrentSelection(); for i=1 to sel.count do (obj=if alignToObj==0 then sel[i] else alignToObj; sel[i].pivot.z=obj.max.z+(mult.value-1+random 0.0 multR.value)*(obj.max.z-obj.min.z) ) )
	on al3 pressed do with undo label:"Y_Min" on ( sel=getCurrentSelection(); for i=1 to sel.count do (obj=if alignToObj==0 then sel[i] else alignToObj; sel[i].pivot.y=obj.min.y-(mult.value-1+random 0.0 multR.value)*(obj.max.y-obj.min.y) ) )
	on al4 pressed do with undo label:"Z_Min" on ( sel=getCurrentSelection(); for i=1 to sel.count do (obj=if alignToObj==0 then sel[i] else alignToObj; sel[i].pivot.z=obj.min.z-(mult.value-1+random 0.0 multR.value)*(obj.max.z-obj.min.z) ) )
	on al5 pressed do with undo label:"X_Max" on ( sel=getCurrentSelection(); for i=1 to sel.count do (obj=if alignToObj==0 then sel[i] else alignToObj; sel[i].pivot.x=obj.max.x+(mult.value-1+random 0.0 multR.value)*(obj.max.x-obj.min.x) ) )
	on al6 pressed do with undo label:"X_Min" on ( sel=getCurrentSelection(); for i=1 to sel.count do (obj=if alignToObj==0 then sel[i] else alignToObj; sel[i].pivot.x=obj.min.x-(mult.value-1+random 0.0 multR.value)*(obj.max.x-obj.min.x) ) )
	on alc pressed do with undo label:"中心" on ( 
						sel=getCurrentSelection()
						for i=1 to sel.count do 
						(
							obj=if alignToObj==0 then sel[i] else alignToObj
							sel[i].pivot.x=obj.min.x+0.5*(obj.max.x-obj.min.x); sel[i].pivot.y=obj.min.y+0.5*(obj.max.y-obj.min.y); sel[i].pivot.z=obj.min.z+0.5*(obj.max.z-obj.min.z) )
					)
	on alr pressed do with undo label:"随机" on (
						sel=getCurrentSelection()
						for i=1 to sel.count do
						(
							obj=if alignToObj==0 then sel[i] else alignToObj
							sel[i].pivot.x=random (obj.min.x-(mult.value-1+random 0.0 multR.value)*(obj.max.x-obj.min.x)) (obj.max.x+(mult.value-1+random 0.0 multR.value)*(obj.max.x-obj.min.x))
							sel[i].pivot.y=random (obj.min.y-(mult.value-1+random 0.0 multR.value)*(obj.max.y-obj.min.y)) (obj.max.y+(mult.value-1+random 0.0 multR.value)*(obj.max.y-obj.min.y))
							sel[i].pivot.z=random (obj.min.z-(mult.value-1+random 0.0 multR.value)*(obj.max.z-obj.min.z)) (obj.max.z+(mult.value-1+random 0.0 multR.value)*(obj.max.z-obj.min.z))
						)
					)
	on transPivot open do ( usePivot=getCoordCenter(); toolMode.pivotCenter() )
	on transPivot close do case usePivot of( #local:toolMode.pivotCenter(); #selection:toolMode.selectionCenter(); #system:toolMode.transformCenter() )
)
	
----------------------------------------随机拾取



	rollout ransel "随机选择 (选)"
	( 
		fn rendersel selnum seled:false =
		(
			if classof $ == Editable_Poly and subobjectLevel != 0 and subobjectLevel != undefined then
			(	
				selfin = #{}
				theseledarr = #{}
				if subobjectLevel == 1 then
					theseled = $.EditablePoly.getSelection #Vertex
				else if subobjectLevel == 2 then
						theseled = $.EditablePoly.getSelection #edge
					else if subobjectLevel == 3 then
						(
							borselet = #{}
							borseled = #{}
							alledge = #{}
							theseled = polyop.getedgeselection $
							allbor = polyop.getopenedges $
							for i = 1 to polyop.getnumedges $ do
								append alledge i
							theseled = theseled - (alledge - allbor)
							while (theseled as array).count != 0 do
							(
								borseled = polyOp.getBorderFromEdge $ (theseled as array)[1]
								theseled -= borseled
								borselet +=borseled
							)
							theseledbor = borselet
							theseled = #{}
							while (theseledbor as array).count != 0 do
							(
								ktheseled = polyop.getborderfromedge $ (theseledbor as array)[1]
								append theseled (theseledbor as array)[1]
								theseledbor -= ktheseled
							)
						)
						else if subobjectLevel == 4 then
								theseled = $.EditablePoly.getSelection #face
							else if subobjectLevel == 5 then
									(
										elmselet = #{}
										elmseled = #{}
										theseled = polyop.getfaceselection $
										while (theseled as array).count != 0 do
										(
											elmseled = polyOp.getElementsUsingFace $ (theseled as array)[1]
											theseled -= elmseled 
											elmselet += elmseled
										)
										theseledelm = elmselet
										theseled = #{}
										while (theseledelm as array).count != 0 do
										(
											ktheseled = polyOp.getElementsUsingFace $ (theseledelm as array)[1]
											append theseled (theseledelm as array)[1]
											theseledelm -= ktheseled
										)
									)
				if seled == false then
				(	
					if subobjectLevel == 1 then
						j = polyOp.getNumVerts $
					else if subobjectLevel == 2 or subobjectLevel == 3 then
							j = polyOp.getNumedges $
						else if subobjectLevel == 4 or subobjectLevel == 5 then
								j = polyOp.getNumfaces $
					for i = 1 to j do
					(
						append selfin i
					)
				)
				else
					selfin = theseled
				if subobjectLevel == 1 or subobjectLevel == 2 or subobjectLevel == 4 then
					theseledarr = selfin as array
				else if subobjectLevel == 3 then
						(
							theseled = #{}
							if seled == false then
								selfin = polyop.getOpenEdges $
							while (selfin as array).count != 0 do
							(
								ktheseled = polyop.getborderfromedge $ (selfin as array)[1]
								append theseled (selfin as array)[1]
								selfin -= ktheseled
							)
							theseledarr = theseled as array
						)
						else if subobjectLevel == 5 then
								(
									theseled = #{}
									while (selfin as array).count != 0 do
									(
										ktheseled = polyOp.getElementsUsingFace $ (selfin as array)[1]
										append theseled (selfin as array)[1]
										selfin -= ktheseled
									)
									theseledarr = theseled as array
								)
				thenum = theseledarr.count
				theset1 = #{}
				theset2 = #()
				if selnum > thenum then
				selnum = thenum
				while theset2.count < selnum do
				(
					wantsel = random 1 thenum
					append theset1 theseledarr[wantsel]
					theset2 = theset1 as array
				)
				if subobjectLevel == 1 then
					$.EditablePoly.SetSelection #Vertex theset1
				else if subobjectLevel == 2 then
						$.EditablePoly.SetSelection #edge theset1
					else if subobjectLevel == 3 then
							(
								theset1bor = #{}
								theset1borfin = #{}
								for i = 1 to (theset1 as array).count do
								(
									theset1bor = polyOp.getBorderFromEdge $ (theset1 as array)[i]
									theset1borfin += theset1bor
								)
								$.EditablePoly.SetSelection #edge theset1borfin
							)
						else if subobjectLevel == 4 then
								$.EditablePoly.SetSelection #face theset1
							else if subobjectLevel == 5 then
									(
										theset1elm = #{}
										theset1elmfin = #{}
										for i = 1 to (theset1 as array).count do
										(
											theset1elm = polyOp.getElementsUsingFace $ (theset1 as array)[i]
											theset1elmfin += theset1elm
										)
										$.EditablePoly.SetSelection #face theset1elmfin
									)
			)
			else
			(
				if seled == true then
				(
					sel = getCurrentSelection()
					nu = sel.count
					clearSelection()
					n = 0
					if nu > selnum then
						(
							while n < selnum do
								(	
									selectmore sel [(random 1 nu) as integer]
									sel2 = getCurrentSelection()
									n = sel2.count
								)
						)
							else select sel
				)
				else
				(
					renobjs = for a in objects where a.ishidden == false collect a
					sel = renobjs
					nu = sel.count
					clearSelection()
					n = 0
					if nu > selnum then
						(
							while n < selnum do
								(	
									selectmore sel [(random 1 nu) as integer]
									sel2 = getCurrentSelection()
									n = sel2.count
								)
						)
							else select renobjs
				)
		
			)
		)
		
	fn getuseful renrad =
	(
		if renrad == 1 then
		(
			if classof $ == Editable_Poly and subobjectLevel != 0 and subobjectLevel != undefined then
			(
				if subobjectLevel == 1 then
					global ranselnum = (getnumVerts $) as string
				else if subobjectLevel == 2 then
						global ranselnum = (polyop.getnumedges $) as string
					else if subobjectLevel == 3 then
						(
							theseled = #{}
							selfin = polyop.getOpenEdges $
							while (selfin as array).count != 0 do
							(
								ktheseled = polyop.getborderfromedge $ (selfin as array)[1]
								append theseled (selfin as array)[1]
								selfin -= ktheseled
							)
							global ranselnum = (theseled as array).count as string
						)
						else if subobjectLevel == 4 then
								global ranselnum = (getnumfaces $) as string
							else if subobjectLevel == 5 then
								(
									selfin = #{}
									for i = 1 to (polyOp.getNumfaces $) do
										(
											append selfin i
										)
									theseled = #{}
									while (selfin as array).count != 0 do
									(
										ktheseled = polyOp.getElementsUsingFace $ (selfin as array)[1]
										append theseled (selfin as array)[1]
										selfin -= ktheseled
									)
									global ranselnum = (theseled as array).count as string
								)
							
			)
			else
			(
				global ranselnum = (for a in objects where a.ishidden == false collect a).count as string
			)
		)
		else
		(
			if classof $ == Editable_Poly and subobjectLevel != 0 and subobjectLevel != undefined then
			(
				if subobjectLevel == 1 then
					global ranselnum = ((getVertselection $) as array).count as string
				else if subobjectLevel == 2 then
						global ranselnum = ((getedgeselection $) as array).count as string
					else if subobjectLevel == 3 then
						(
							borselet = #{}
							borseled = #{}
							alledge = #{}
							theseled = polyop.getedgeselection $
							allbor = polyop.getopenedges $
							for i = 1 to polyop.getnumedges $ do
								append alledge i
							theseled = theseled - (alledge - allbor)
							while (theseled as array).count != 0 do
							(
								borseled = polyOp.getBorderFromEdge $ (theseled as array)[1]
								theseled -= borseled
								borselet +=borseled
							)
							theseledbor = borselet
							theseled = #{}
							while (theseledbor as array).count != 0 do
							(
								ktheseled = polyop.getborderfromedge $ (theseledbor as array)[1]
								append theseled (theseledbor as array)[1]
								theseledbor -= ktheseled
							)
							global ranselnum = (theseled as array).count as string
						)
						else if subobjectLevel == 4 then
								global ranselnum = ((getfaceselection $) as array).count as string
							else if subobjectLevel == 5 then
								(	
									elmselet = #{}
									elmseled = #{}
									theseled = polyop.getfaceselection $
									while (theseled as array).count != 0 do
									(
										elmseled = polyOp.getElementsUsingFace $ (theseled as array)[1]
										theseled -= elmseled 
										elmselet += elmseled
									)
									theseledelm = elmselet
									theseled = #{}
									while (theseledelm as array).count != 0 do
									(
										ktheseled = polyOp.getElementsUsingFace $ (theseledelm as array)[1]
										append theseled (theseledelm as array)[1]
										theseledelm -= ktheseled
									)
									global ranselnum = (theseled as array).count as string
								)
			)
			else
			(
				global ranselnum = (for a in objects where a.ishidden == false and a.isselected == true collect a).count as string
			)
		)
	)
		radiobuttons rad1 labels:#("所有对象  ", "已选对象  ") default:1 pos:[45,5]
		spinner num1 "数量"  type:#integer width:50 pos:[55,27] range:[0,99999999,0]
		spinner num2 "百分之" width:50 range:[0,100,0] pos:[150,27]
		label cansle "可选对象:" pos:[80,50]
		label selnumlb "未知" pos:[135,50]
		button pic1 "拾取" tooltip:"Poly物体在点/线/面模式下将自动切换为点/线/面选取"
		label ranselinfo "* 点线面选取仅支持Poly物体 *" 
		
		on num1 changed state do
		(
			getuseful rad1.state
			selnumlb.caption = ranselnum
			selnumlb.pos = [140,50]
			num2.value = num1.value / ((selnumlb.caption) as float) * 100
		)
		on num2 changed state do
		(
			getuseful rad1.state
			selnumlb.caption = ranselnum
			selnumlb.pos = [140,50]
			num1.value = num2.value * ((selnumlb.caption) as float) / 100
		)
		on pic1 rightclick do
		(
			getuseful rad1.state
			selnumlb.caption = ranselnum
			selnumlb.pos = [140,50]
			num2.value = num1.value / ((selnumlb.caption) as float) * 100
		)
		on rad1 changed state do
		(
			getuseful rad1.state
			selnumlb.caption = ranselnum
			selnumlb.pos = [140,50]
			num2.value = num1.value / ((selnumlb.caption) as float) * 100
		)
		on pic1 pressed do with undo label:"随机拾取" on
		(	
			selnumlb.caption = "右击拾取刷新"
			selnumlb.pos = [80,50]
			num2.value = 0
			if rad1.state == 1 then
				seled = false
			else
				seled =true
			rendersel num1.value seled:seled
		)	
)


----------------------------------------颜色选择


	rollout colorsel "按线框颜色选择 (选)"
	( 
		fn piccolorobj colorobj seltst=
		(
			case seltst of
			(
				1:
					(
						if keyboard.altPressed == true then
						(
							colobj = for a in objects where a.wirecolor == colorobj collect a
							selobj = for a in selection collect a
							for i = 1 to colobj.count do
							(
								if finditem selobj colobj[i] != 0 then
								(
									delnum = finditem selobj colobj[i]
									deleteitem selobj delnum
								)
							)
							if selobj.count != 0 then
							(
								select selobj
							)
							else
								clearselection()
						)
						else
						(
							if keyboard.controlPressed == true then
								selectmore (for a in objects where a.wirecolor == colorobj collect a)
							else
								select (for a in objects where a.wirecolor == colorobj collect a)
						)
					)
				2: select (for a in objects where a.wirecolor == colorobj collect a)
				3: selectmore (for a in objects where a.wirecolor == colorobj collect a)
				4:
					(
						colobj = for a in objects where a.wirecolor == colorobj collect a
						selobj = for a in selection collect a
						for i = 1 to colobj.count do
						(
							if finditem selobj colobj[i] != 0 then
							(
								delnum = finditem selobj colobj[i]
								deleteitem selobj delnum
							)
						)
						if selobj.count != 0 then
						(
							select selobj
						)
						else
							clearselection()
					)
			)
		)

		radiobuttons piccolorrad labels:#("Keyboard","重选","加选","减选") default:1 pos:[40,5]
		checkbutton picobj "选择" pos:[140,20] width:50 height:30 tooltip:"Keyboard模式时: Ctrl:加选 / Alt:减选"
	
		on picobj changed state do with undo label:"按颜色拾取" on
		(
			while picobj.checked == true do
			(
				if keyboard.escpressed == true then
				(
					picobj.checked = false
					exit
				)
				picingobj = pickobject()
				if picobj.checked == false then
					exit
				if picingobj == undefined then
				(
					picobj.checked = false
					exit
				)
				try
					objcolor = picingobj.wirecolor
				catch
					false
				piccolorobj objcolor piccolorrad.state
			)
		)
	)
	
----------------------------------------极点面选择


	rollout bad_elem_sel "极点/多边面 选择 (选)"
	( 
		groupbox picedgevert "极点拾取:" width:210 height:90 pos:[13,5]
		checkbox mincheck pos:[23,27] width:10
		spinner minvt "Min:" range:[0,99999999,2] type:#integer pos:[55,27] width:40
		label xiao "<" pos:[100,27]
		checkbutton conn "=" pos:[111,27] width:14 height:14 checked:true tooltip:"锁定Min/Max值"
		label da "<" pos:[130,27]
		spinner maxvt "Max:" range:[0,99999999,2] type:#integer pos:[155,27] width:40
		checkbox maxcheck pos:[200,27] width:10
		checkbox nobord "忽略外缘" align:#center
		button picvt "拾取" tooltip:"多用于寻找废点/三星点/五星点"

		groupbox picedgeface "多边面拾取:" width:210 height:70 pos:[13,99]
		checkbox mincheckf pos:[23,121] width:10
		spinner minfc "Min:" range:[3,99999999,5] type:#integer pos:[55,121] width:40
		label xiaof "<" pos:[100,121]
		checkbutton connf "=" pos:[111,121] width:14 height:14 checked:true tooltip:"锁定Min/Max值"
		label daf "<" pos:[130,121]
		spinner maxfc "  ∽  " range:[3,99999999,5] type:#integer pos:[155,121] width:40 enabled:false
		checkbox maxcheckf pos:[200,121] width:10 checked:true
		button picfc "拾取" tooltip:"多用于寻找非四边形面"
		
-------极点拾取
		fn fine_edge_vert minnum maxnum minch maxch nobor =
		(
			if selection.count == 1 then
			(
				if classof $ != Editable_Poly then
				(
					if queryBox "是否转换成Poly" then
					(
						try
							converttopoly $
						catch
							false
					)
		
				)
			)
			else
				messagebox "请选择单个物体"
			if classof $ == Editable_Poly then
			(
				subobjectLevel = 0
				subobjectLevel = 1
				getvt = #()
				borevert = #()
				for i = 1 to polyop.getnumverts $ do
				(
					boredge = polyOp.getOpenEdges $
					borevert = polyOp.getVertsUsingEdge $ boredge
					vtused = polyOp.getEdgesUsingVert $ i
					vtusedcon = (vtused as array).count
					if minch == false and maxch == false then
					(
						if vtusedcon >= minnum and vtusedcon <= maxnum then
						(
							append getvt i
						)
					)
					else
					(
						if maxch == false then
						(
							if vtusedcon <= maxnum then
							(
								append getvt i
							)
						)
						else
						(
							if minch == false then
							(
								if vtusedcon >= minnum then
								(
									append getvt i
								)
							)
							else
								append getvt i
						)
					)
				)
				if nobor == false then
				(
					polyop.setvertselection $ getvt
				)
				else
				(
					for i = 1 to (borevert as array).count do
					(
						if finditem getvt (borevert as array)[i] != 0 then
						(
							delnum = finditem getvt (borevert as array)[i]
							deleteitem getvt delnum
						)
					)
					polyop.setvertselection $ getvt
				)
			)
			else
			(
				if selection.count == 1 then
					messagebox "目前只支持Poly类型"
			)
		)

		on mincheck changed state do
		(
			if mincheck.checked == true then
			(
				minvt.enabled = false
				minvt.caption = " ∽"
			)
			else 
			(
				minvt.enabled = true
				minvt.caption = "Min:"
			)
		)
		on maxcheck changed state do
		(
			if maxcheck.checked == true then
			(
				maxvt.enabled = false
				maxvt.caption = " ∽"
			)
			else 
			(
				maxvt.enabled = true
				maxvt.caption = "Max:"
			)
		)
		on minvt changed state do
		(
			if conn.checked == true or maxvt.value < minvt.value then
			(
				maxvt.value = minvt.value
			)
		)
		on maxvt changed state do
		(
			if conn.checked == true or minvt.value > maxvt.value then
			(
				minvt.value = maxvt.value
			)
		)
		on conn changed state do
		(
			if conn.checked == true then
				maxvt.value = minvt.value
		)
		on picvt pressed do with undo label:"极点选择" on
			fine_edge_vert minvt.value maxvt.value mincheck.checked maxcheck.checked nobord.checked
			
-------多边形拾取

		fn fine_edge_face minnum maxnum minch maxch =
		(
			if selection.count == 1 then
			(
				if classof $ != Editable_Poly then
				(
					if queryBox "是否转换成Poly" then
					(
						try
							converttopoly $
						catch
							false
					)
		
				)
			)
			else
				messagebox "请选择单个物体"
			if classof $ == Editable_Poly then
			(
				subobjectLevel = 0
				subobjectLevel = 4
				getfc = #()
				for i = 1 to polyop.getnumfaces $ do
				(
					fcused = polyOp.getEdgesUsingFace $ i
					fcusedcon = (fcused as array).count
					if minch == false and maxch == false then
					(
						if fcusedcon >= minnum and fcusedcon <= maxnum then
						(
							append getfc i
						)
					)
					else
					(
						if maxch == false then
						(
							if fcusedcon <= maxnum then
							(
								append getfc i
							)
						)
						else
						(
							if minch == false then
							(
								if fcusedcon >= minnum then
								(
									append getfc i
								)
							)
							else
								append getfc i
						)
					)
				)
					polyop.setfaceselection $ getfc
			)
			else
			(
				if selection.count == 1 then
					messagebox "目前只支持Poly类型"
			)
		)
		on mincheckf changed state do
		(
			if mincheckf.checked == true then
			(
				minfc.enabled = false
				minfc.caption = " ∽"
			)
			else 
			(
				minfc.enabled = true
				minfc.caption = "Min:"
			)
		)
		on maxcheckf changed state do
		(
			if maxcheckf.checked == true then
			(
				maxfc.enabled = false
				maxfc.caption = " ∽"
			)
			else 
			(
				maxfc.enabled = true
				maxfc.caption = "Max:"
			)
		)
		on minfc changed state do
		(
			if connf.checked == true or maxfc.value < minfc.value then
			(
				maxfc.value = minfc.value
			)
		)
		on maxfc changed state do
		(
			if connf.checked == true or minfc.value > maxfc.value then
			(
				minfc.value = maxfc.value
			)
		)
		on picfc pressed do with undo label:"多边面选择" on
			fine_edge_face minfc.value maxfc.value mincheckf.checked maxcheckf.checked
	)
	
----------------------------------------摄像机选择


	rollout cam_sel "选择摄像机看不见的物体 (选)"
	(
		fn picnosee Chid Cstep Cset CrangeS CrangeE =
		(
			noselset = #()
			avcam = getActiveCamera()
			
			if superclassof avcam != camera then
				st = en = slidertime
			else
			(
				st = animationrange.start
				en = animationrange.end
			)
				
			if Cset == true and st != en do
			(
				st = CrangeS
				en = CrangeE
			)
			
			if st < animationrange.start do st = animationrange.start
			if en > animationrange.end do en = animationrange.end
			
			
			for i = st to en by Cstep do
			(
				if keyboard.escPressed == true then exit
				slidertime = i
				nosel = boxpicknode (box2 [0,0] [10000,10000])
				if st != en then
					hide nosel
				for j = 1 to nosel.count do
				(
					if finditem noselset nosel[j] == 0 then
						append noselset nosel[j]
				)
			)
			noselset
			unhide noselset
			objuse = for a in objects where a.ishidden == false and (finditem noselset a == 0) collect a
			
			undo label:"摄像机拾取" on
			(
				if Chid == true then
				(
					hide objuse
					try
					(
						unhide avcam
						unhide avcam.target
					)
					catch()
				)
				else
				(
					select objuse
					try
						deselect #(avcam,avcam.target)
					catch()
				)
			)
		)
		checkbox hid_sel "隐藏看不见的物体    " pos:[95,5] checked:true
		spinner camselstep "隔帧:" range:[1,9999999,10] type:#integer width:50 pos:[35,5]
		checkbox selrange "拾取时间段:    " pos:[18,25]
		spinner selstar range:[-99999999,99999999,0] type:#integer pos:[126,26] width:40 enabled:false
		label camto "to" pos:[170,25]
		spinner selend range:[-99999999,99999999,100] type:#integer pos:[180,25] width:40 enabled:false
		button nosee "拾取" 


		on selrange changed state do
		(
			if selrange.checked == true then
			(
				selstar.enabled = true
				selend.enabled = true
			)
			else
			(
				selstar.enabled = false
				selend.enabled = false
			)
		)
		on nosee pressed do
		(
			picnosee hid_sel.checked camselstep.value selrange.checked selstar.value selend.value
		)
	)
	
----------------------------------------位图选择


	rollout bitmap_sel "按位图灰度选择点 (选)"
	(
		fn bitmapcreate bmoffset bmflip =
		(
			ifmesh = 0
			ifbitmap = 0
		
				
			for a in selection do
			(
				if classof a != Editable_mesh do
					ifmesh = 1
					
				if a.material != undefined then
				(
					if classof a.material.diffusemap != Bitmaptexture then
						ifbitmap = 1
				)
				else
					ifbitmap = 1
			)
			if ifmesh == 1 and ifbitmap ==0 do
			(
				if queryBox "目前只支持Mesh物体，是否全部塌陷成Mesh" then
				(
					try
						converttomesh $
					catch
						messagebox "无法转换！"
				)
			)
			if ifbitmap == 1 do
				messagebox "请赋予所有物体贴图"
			ifmesh = 0
			for a in selection do
			(
				if classof a != Editable_mesh do
					ifmesh = 1
			)
			if ifmesh == 0 and ifbitmap == 0 do
			(
				rollout bmcring "正在解算" width:320 height:55
				(
					label Info "完成 " pos:[20,2]
					label ab "Esc强行退出" pos:[220,2]
					progressBar cring1 "" pos:[10,20] width:300 height:8 color:yellow
					progressBar cring2 "" pos:[10,40] width:300 height:8
				)
				createdialog bmcring
				j = 0
				for mapobj in selection do
				(
					bmcring.cring2.value = (100/(selection.count) as float)*j
					j += 1
					mybitmap = openBitmap mapobj.material.diffusemap.filename
					mybitmapWidth = mybitmap.width - 1 
					mybitmapheight = mybitmap.height - 1
					mynums = meshop.getNumMapVerts mapobj.mesh 1
					mydelvert = #()
					for i = 1 to mynums do
					(
						if keyboard.escPressed == true then exit
						bmcring.cring1.value = (100/(mynums + 1) as float)*i
						myvert = meshop.getMapVert mapobj.mesh 1 i
						mypixels = getpixels mybitmap [(mod myvert.x 1.0) * mybitmapheight,mybitmapheight - (mod myvert.y 1.0) * mybitmapheight] 1
						mypixelcolor = mypixels[1]
						if bmflip != false then
						(
							if (mypixelcolor.r + mypixelcolor.g + mypixelcolor.b)/3 > ((bmoffset+1)*127.5) as integer then
							(
								Vmeshlist = meshop.getMapFacesUsingMapVert mapobj.mesh 1 i
								Mvertlist = meshop.getMapVertsUsingMapFace mapobj.mesh 1 (Vmeshlist as array)[1]
								vtindex = finditem (Mvertlist as array) i
								Fvertlist = meshop.getVertsUsingFace mapobj.mesh (Vmeshlist as array)[1]
								wantvert = (Fvertlist as array)[vtindex]
								append mydelvert wantvert
							)
						)
						else
						(
							if (mypixelcolor.r + mypixelcolor.g + mypixelcolor.b)/3 <= ((bmoffset+1)*127.5) as integer then
							(
								Vmeshlist = meshop.getMapFacesUsingMapVert mapobj.mesh 1 i
								Mvertlist = meshop.getMapVertsUsingMapFace mapobj.mesh 1 (Vmeshlist as array)[1]
								vtindex = finditem (Mvertlist as array) i
								Fvertlist = meshop.getVertsUsingFace mapobj.mesh (Vmeshlist as array)[1]
								wantvert = (Fvertlist as array)[vtindex]
								append mydelvert wantvert
							)
						)
					)
						setVertSelection mapobj mydelvert
				)
				destroyDialog bmcring
				subobjectlevel = 1
			)
		)

		spinner bitmapoffset "黑白偏移:" range:[-1,1,0] width:70 pos:[70,5] scale:0.01
		checkbox bitmapflip "反色" pos:[155,5]
		button makeobj "拾取" tooltip:"根据位图灰度值选择点，请尽量使用黑白分明的位图" pos:[90,25]

		on makeobj pressed do  with undo label:"按位图拾取点" on
		(
			bitmapcreate bitmapoffset.value bitmapflip.checked
		)
	)

----------------------------------------一键材质

	rollout del_material "一键材质 (材)"
		(
			button dem1 "移除材质" width:180
			button SelUnMtl "选中无材质物体" width:180
			button SceneLib "导入场景/选中物体材质到编辑器" width:180 tooltip:"选择为空时导入所有场景材质"
			button ResetMtl "重设材质球" width:180
			
			on dem1 pressed do  with undo label:"移除材质" on
			(
				try
				(
					for a in selection do
					(
						a.material = undefined
					)
				)
				catch
					false
			)
			on SelUnMtl pressed do with undo label:"选择" on
			(
				clearselection()
				select (for a in objects where a.material == undefined and (superclassof a == GeometryClass or (superclassof a == shape and a.render_renderable == true and a.render_displayRenderMesh == true)) and classof a != Targetobject and a.ishidden == false collect a)
			)
			on SceneLib pressed do
			(
				Selobj = if selection.count != 0 then selection as array else objects as array
				ScnMtl = for a in sceneMaterials where (for b in Selobj where b.material == a collect b).count != 0 collect a
				for i = 1 to meditMaterials.count do
				(
					try
						meditMaterials[i] = ScnMtl[i]
					catch
					(
						meditMaterials[i] = standard()
						meditMaterials[i].name = "Standard_" + i as string
					)
				)
			)
			on ResetMtl pressed do
			(
				for i = 1 to meditMaterials.count do
				(
					meditMaterials[i] = Standard()
					meditMaterials[i].name = "Standard_" + i as string
				)
			)
		)

----------------------------------------更改可见性

	rollout vis_change "更改可见性 (场)"
	(
		fn visib visval=
		(
			try
			(
				for a in selection do
				(
					a.visibility = true
					a.visibility.controller.value = visval
				)
			)
			catch
				false
		)
		spinner vis pos:[60,5] width:45 range:[0,1,0.5]
	 	button visb "更改可见性" pos:[110,5] tooltip:"更改可见性"
		on visb pressed do with undo label:"更改可见性" on
		(
			visib vis.value
		)
	)
----------------------------------------关键帧工具
		
	rollout keychangedtools "关键帧转换 (动)" width:165 height:298
	(
		button hit1 "子物体动画转关键帧"  width:136 height:21
		button hit2 "路径动画转关键帧"  width:136 height:21
		button hit3 "反转关键帧"  width:136 height:21

		on hit1 pressed do  with undo label:"子物体动画转关键帧" on
		(
			if selection.count ==0 then 
				(
					messagebox "请选择一个要处理的物体" beep:false
				)
				else
					(
						
						mybox = $
						mypoint = Point ()
						
						s = animationrange.end
						for i in 0 to s do
							(
								if keyboard.escPressed == true do exit
								sliderTime = i 
								with animate on
									(
										mypoint.transform = mybox.transform
									)
							)
						setInheritanceFlags mybox #all
						mybox.parent = undefined
						for i in 0 to s do
							(
								if keyboard.escPressed == true do exit
								sliderTime = i 
								with animate on
									(
										mybox.transform = mypoint.transform
									)
							)
						delete mypoint
			)
		)
		on hit2 pressed do with undo label:"路径动画转关键帧" on
		(
			if selection.count ==0 then 
				(
					messagebox "请选择一个要处理的物体" beep:false
				)
				else
					(
						
						mybox = $
						mypoint = Point ()
						s = animationrange.end
						for i in 0 to s do
							(
								if keyboard.escPressed == true do exit
								sliderTime = i 
								with animate on
									(
										mypoint.transform = mybox.transform
									)
							)
						eee = mybox.pos.controller
						try ( eee.delete 2 ) catch ()
						for i in 0 to s do
							(
								if keyboard.escPressed == true do exit
								sliderTime = i 
								with animate on
									(
										mybox.transform = mypoint.transform
									)
							)
						delete mypoint
					)
		)
		on hit3 pressed do with undo label:"反转关键帧" on
		(
			
			for i in selection do
				(
					EndT = animationrange.end + 1
					if classOf i == Biped_Object then
						( 
							messagebox "本工具不支持CS骨骼" beep:false 
							fetchmaxfile quiet:true
							exit
						)
					else
						(
							reverseTime i.transform.controller 0 EndT  #incleft
							deleteTime i.transform.controller 0 1  #incleft
						)
				)
		)
	)


----------------------------------------随机关键帧

	rollout keyrantools "随机移动关键帧 (动)" width:165 height:298
	(
		spinner rankey1 "Min:" range:[-9999999,99999999,-5] width:50 pos:[50,5] type:#integer
		spinner rankey2 "Max:" range:[-9999999,99999999,5] width:50 pos:[150,5] type:#integer
		checkbox ranmovesel "移动选中帧  " pos:[70,25]
		button done "移动" 
		
		on done pressed do with undo label:"随机关键帧" on
		(
			for a in selection do
			(
				if ranmovesel.checked == true then
					movekeys a (random rankey1.value rankey2.value) #selection
				else
					movekeys a (random rankey1.value rankey2.value)
			)
		)
	)

----------------------------------------绑定表面

rollout pathsurface "约束到物体表面 (场)"
(
	button done1 "约束" tooltip:"将选中物体绑定到目标物体表面"
	on done1 pressed do
	(	
		if selection.count == 0 then 
		messagebox "请选择物体" else
		(
		messagebox "警告！该功能目前不支持撤销！"
		Global AttachToSurfaceByLocalZ
		Struct AttachToSurfaceByLocalZStruct
		(
			FilterObj = undefined,
			BindSurf = undefined,
			BindObj = undefined,
			bindIntersect = undefined,
			
			fn AlreadySelected Bindobj = (for FilterObj in (selection as array) do (if Bindobj == FilterObj do (return false)) return true ),

			fn ZPositive Dobj DSurf =
				(
					Dray = ray Dobj.pos Dobj.dir
					DIntersect = intersectRayex DSurf Dray
					TestDist = distance Dobj.pos DIntersect[1].pos
					return #(TestDist, DIntersect)
				),
			
			fn ZNegative Dobj DSurf =
				(
					Dray = ray Dobj.pos -Dobj.dir
					DIntersect = intersectRayex DSurf Dray
					TestDist = distance Dobj.pos DIntersect[1].pos
					return #(TestDist, DIntersect)
				),
			
			fn DoAttachToSurfaceByLocalZ BindObj =
				(
					if $ != undefined then
					(
						BindSurf = pickObject filter:AlreadySelected rubberband:$.center
						
						if BindSurf != undefined do
							(
								rollout AttachToSurfaceByLocalZDialog "绑定到物体表面" width:525 height:30
									(
										label AttachtoSurfaceProgressInfo "正在绑定..." pos:[10,2] width:505 height:20
										progressBar AttachtoSurfaceProgress "" pos:[10,20] width:505 height:8
									)
									createdialog AttachToSurfaceByLocalZDialog
								
								progressSteps = 100.0 / BindObj.count
								
								BindObj = selection as array
								
								progressCount = 0
			
								Max Create mode
								
								if (classof BindSurf) != Editable_mesh do
									(
										addmodifier BindSurf (Mesh_Select())
										BindSurf.modifiers[1].name = "BindSurfMeshSelect"
									)
								
								objectsNotBound = #()
								
								for obj in BindObj do
									with redraw off
										(
										progressCount += 1
										
										AttachToSurfaceByLocalZDialog.AttachtoSurfaceProgressInfo.caption = ("Object: " + obj.name as string)
										AttachToSurfaceByLocalZDialog.AttachtoSurfaceProgress.value = progressSteps * progressCount
										
										TestZPos = (try (ZNegative obj BindSurf) catch ())
										TestZNeg = (try (ZPositive obj BindSurf) catch ())
										
										addmodifier BindSurf (NormalModifier())
										BindSurf.modifiers[1].name = "BindSurfNormalMod"
										BindSurf.modifiers[#BindSurfNormalMod].flip = on
										
										TestZPosFlip = (try (ZNegative obj BindSurf) catch ())
										TestZNegFlip = (try (ZPositive obj BindSurf) catch ())
										
										deleteModifier BindSurf BindSurf.modifiers[#BindSurfNormalMod]
										
										DistanceArray = #()
										
										if TestZPos != undefined do (append DistanceArray TestZPos[1])
										if TestZNeg != undefined do (append DistanceArray TestZNeg[1])
										if TestZPosFlip != undefined do (append DistanceArray TestZPosFlip[1])
										if TestZNegFlip != undefined do (append DistanceArray TestZNegFlip[1])
										
										sort DistanceArray
										
										ShortestDistance = DistanceArray[1]
										
										FinalRay = #()
										
										if ((try (finditem TestZPos ShortestDistance) catch()) != undefined) and ((try (finditem TestZPos ShortestDistance) catch()) != 0) do
											(
												if Obj.modifiers[#BindObjMeshSelect] != undefined do (deleteModifier Obj Obj.modifiers[#BindObjMeshSelect])

												append FinalRay ((TestZPos[2])[2] - 1)
												append FinalRay ((TestZPos[2])[3])
											)
										if ((try (finditem TestZNeg ShortestDistance) catch()) != undefined) and ((try (finditem TestZNeg ShortestDistance) catch()) != 0) do
											(
												if Obj.modifiers[#BindObjMeshSelect] != undefined do (deleteModifier Obj Obj.modifiers[#BindObjMeshSelect])

												append FinalRay ((TestZNeg[2])[2] - 1)
												append FinalRay ((TestZNeg[2])[3])
											)
										if ((try (finditem TestZPosFlip ShortestDistance) catch()) != undefined) and ((try (finditem TestZPosFlip ShortestDistance) catch()) != 0) do
											(
												if Obj.modifiers[#BindObjMeshSelect] != undefined do (deleteModifier Obj Obj.modifiers[#BindObjMeshSelect])

												append FinalRay ((TestZPosFlip[2])[2] - 1)
												append FinalRay (meshOp.getBaryCoords BindSurf ((TestZPosFlip[2])[2]) ((TestZPosFlip[2])[1].pos))
											)

										if ((try (finditem TestZNegFlip ShortestDistance) catch()) != undefined) and ((try (finditem TestZNegFlip ShortestDistance) catch()) != 0) do
											(
												if Obj.modifiers[#BindObjMeshSelect] != undefined do (deleteModifier Obj Obj.modifiers[#BindObjMeshSelect])
											
												append FinalRay ((TestZNegFlip[2])[2] - 1)
												append FinalRay (meshOp.getBaryCoords BindSurf ((TestZNegFlip[2])[2]) ((TestZNegFlip[2])[1].pos))
											)
										
										if (FinalRay[1] != undefined) and (FinalRay[2] != undefined) then
											(
												d = Point size:2 centermarker:true axistripod:false cross:false box:false constantscreensize:false drawontop:false
												d.position.controller = attachment()
												d.position.controller.node = BindSurf
												addnewkey d.position.controller 0
												k = attachctrl.getkey d.position.controller 1

												k.face = FinalRay[1]
												k.coord = FinalRay[2]
													
												sliderTime += 1
												sliderTime -= 1
												
												Obj.parent = d
												d.name = ("SurfAtt_" + Obj.name)
												setTransformLockFlags d #all
														
											)
											else
											(
												if Obj.modifiers[#BindObjMeshSelect] != undefined do (deleteModifier Obj Obj.modifiers[#BindObjMeshSelect])
												append objectsNotBound obj
											)
										gc()
									)
								destroyDialog AttachToSurfaceByLocalZDialog
								if BindSurf.modifiers[#BindSurfMeshSelect] != undefined do (deleteModifier BindSurf BindSurf.modifiers[#BindSurfMeshSelect])
								if objectsNotBound.count > 0 do
									(
										select objectsNotBound
										messageBox "无法绑定，选择物体Z轴与目标物体表面不相交" title:"Attach to Surface Error"
									)
							)
					)
					else
					(
						messageBox "请选择物体" title:"Attach to Surface Error"
					)
				)
		)

	AttachToSurfaceByLocalZ = AttachToSurfaceByLocalZStruct()

	AttachToSurfaceByLocalZ.BindObj = selection as array

	AttachToSurfaceByLocalZ.DoAttachToSurfaceByLocalZ AttachToSurfaceByLocalZ.BindObj

		)
	)

)

----------------------------------------物体切割

global CGSplitchunks
global CGSplitpos
global ifcut = undefined
	rollout CGSplitroll "物体切割 (物)"
	(
		
		button splitbutt "切割" width: 62 height: 22 align:#center tooltip: "Split up model to chunks."
		spinner splitspin "细分:" range:[1,100,10] type:#integer align:#center fieldwidth:36
		checkbox splitcheck "独立物体" checked:true
		checkbox splitcheck2 "建立拓扑结构" checked:false
		checkbox splitcheck3 "设置材质ID" checked:true
		checkbox splitcheck4 "细分内面" checked:false
		radiobuttons splitrad "" labels:#("类型 1   ","类型 2   ") default: 1 columns: 2 enabled:false
		spinner splitspin3 "扰乱程度:" range:[0.0,10000.0,0.0] align:#center fieldwidth:46 enabled:false
		group "结果校验:"
		(
		spinner splitspin2 "Move chunks:" range:[0.0,10000.0,0.0] align:#center fieldwidth:46
		)
		
		on splitcheck changed state do splitspin2.enabled = state
		on splitcheck4 changed state do (splitspin3.enabled = state ; splitrad.enabled = state)
		on splitbutt pressed do
		(
			if ifcut != 1 then
			(
				if queryBox "警告！该功能目前不支持撤销！是否继续？" then
				(
					 ifcut = 1
					if selection.count == 1 then
						converttopoly $
					else
						messagebox "请选择物体"
				)
				else
					 ifcut = 0
			)
			else
				(
					if selection.count == 1 then
						converttopoly $
					else
						messagebox "请选择物体"
				)
			if selection.count == 1 and ifcut != 0 then undo off
				(
				if classof $ != Editable_Poly then
				(
					converttopoly $
				)
				setWaitcursor()
				try(suspendEditing())catch()
				numval = splitspin.value
				polyop.setFaceSelection $.baseobject #all
				distMin = $.min-$.pivot
				distMax = $.max-$.pivot
				for i = 1 to numval do --split up object with slice mod and cap holes
					(
					addmodifier $ (SliceModifier slice_type:1)
					randomrot = quat (random -1.0 1.0) (random -1.0 1.0) (random -1.0 1.0) (random -1.0 1.0)
					$.modifiers[#Slice].Slice_Plane.rotation = randomrot
					randpos = [(random distMin.x distMax.x),(random distMin.y distMax.y),(random distMin.z distMax.z)]
					$.modifiers[#Slice].Slice_Plane.position = randpos
					convertTo $ Editable_Poly
					polyOp.capHolesByEdge $.baseobject #all
					if keyboard.escpressed == true do exit
					)
				try(resumeEditing())catch()
				disablesceneredraw()
				if splitcheck2.state == true do --build inner topology by selecting inside verts and connectiong, then removing created edges on the outside
					(
					inif = polyop.getFaceSelection $.baseobject
					allaf = polyop.getNumFaces $.baseobject
					innerf = #{1..allaf} - inif
					oute = polyop.getEdgesUsingFace $.baseobject inif
					polyop.setVertSelection $.baseobject (polyop.getVertsUsingFace $.baseobject innerf)
					$.EditablePoly.ConnectVertices ()
					oute2 = polyop.getEdgesUsingFace $.baseobject (polyop.getFaceSelection $.baseobject)
					polyop.setEdgeSelection $.baseobject (oute2-oute)
					$.remove selLevel:#Edge
					)
				if splitcheck3.state == true do --set material ID's
					(
					inif = polyop.getFaceSelection $.baseobject
					polyOp.setFaceMatID $.baseobject inif 1
					allaf = polyop.getNumFaces $.baseobject
					inf = #{1..allaf} - inif
					polyOp.setFaceMatID $.baseobject inf 2
					)
				if splitcheck4.state == true do --mess up inside by tesselating the inside faces and moving the resulting verts randomly
					(
					$.tesselateBy = splitrad.state - 1
					inif = polyop.getFaceSelection $.baseobject
					allaf = polyop.getNumFaces $.baseobject
					inf = #{1..allaf} - inif
					polyop.setFaceSelection $.baseobject inf
					polyOp.tessellateByFace $.baseobject inf
					polyOp.tessellateByFace $.baseobject (polyop.getFaceSelection $.baseobject)
					allef = polyop.getNumFaces $.baseobject
					ino = #{1..allef} - (polyop.getFaceSelection $.baseobject)
					allav = polyop.getNumVerts $.baseobject
					innv = #{1..allav} - (polyop.getVertsUsingFace $.baseobject ino)
					for w in innv do
						(
						randvec = normalize ([(random 0.0 10.0),(random 0.0 10.0),(random 0.0 10.0)] - [(random 0.0 10.0),(random 0.0 10.0),(random 0.0 10.0)])
						curp = polyop.getVert $.baseobject w node:$
						polyop.setVert $.baseobject w (curp + (randvec * splitspin3.value)) node:$
						)
					)
				if splitcheck.state == true then --explode elements to seperate objects
					(
					Selobj = $
					splitval = 0
					max select all
					while splitval == 0 do --get a random face and detach the element wich the face is on, then select a new random face and so on until there is no faces left
						(
						elmf = polyop.getElementsUsingFace Selobj.baseobject 1
						polyOp.detachFaces Selobj.baseobject elmf delete:true asNode:true node:Selobj
						if (polyop.getNumFaces Selobj.baseobject) == 0 do (splitval = 1 ; delete Selobj)
						if keyboard.escpressed == true do (splitval = 1 ; delete Selobj)
						)
					max select invert
					CGSplitchunks = selection as array --put all the chunks into an array for later moving
					CGSplitpos = for p in CGSplitchunks collect p.pos --put the positions of all chunks into an array
					)
				else (CGSplitchunks = #() ; CGSplitpos = #())
				enablesceneredraw()
				setArrowcursor()
				gc()
				redrawviews()
				)
			)
		on splitspin2 changed value do undo off
			(
			if CGSplitchunks.count != 0 do --move all chunks
				try(
				selnum = 0
				allpos = [0,0,0]
				for d in CGSplitchunks do (selnum += 1 ; allpos += d.center)
				midpos = allpos/selnum
				for w = 1 to selnum do
					(
					levec = normalize (CGSplitchunks[w].center-midpos)
					CGSplitchunks[w].pos = CGSplitpos[w] + (levec * value)
					)
				)catch()
			)
	)
	
----------------------------------------自身镜像	
	rightAr=#()
	leftAr=#()
	centerAr=#()
	tempAr=#()	
	rollout mirrorVerts "自身镜像 (物)"
	(
		fn getMirrorData mirobj threshold:0.01=
		(
			rightAr=#()
			leftAr=#()
			centerAr=#()
			tempAr=#()
				
			baseObj=mirobj.baseObject
			vertSel=(polyOp.getVertSelection baseObj)as array
			
			
			for i = 1 to vertSel.count do
			(
				pos=polyOp.getVert baseObj vertSel[i]	
				if pos.x < -threshold then 
				(
					append rightAr vertSel[i]
				)
				if pos.x < threshold and pos.x > -threshold then
				(
					append centerAr vertSel[i]
				)
				if pos.x > threshold then 
				(
					append tempAr vertSel[i]
				)
			)
			
			for i in rightAr do
			(
				pos=polyOp.getVert baseObj i
				found=false
				for c = 1 to tempAr.count do
				(
					cPos=(polyOp.getVert baseObj tempAr[c])*[-1,1,1]
					dist=distance cPos pos
					if dist<threshold then
					(
						append leftAr tempAr[c]
						deleteItem tempAr c
						found=true
						exit
					)
				)
				if found==false then append leftAr undefined
			)
			#(rightAr.count,leftAr.count,centerAr.count)
		)
		
		fn mirrorMorph symmetry:false=
		(
			for i = 1 to rightAr.count do
			(
				if leftAr[i]!=undefined do
				(
					Rpos=polyOp.getVert $ rightAr[i]
					if symmetry==false then Lpos=polyOp.getVert $ leftAr[i]
					polyOp.setVert $ leftAr[i] (((Rpos-$.pos)*[-1,1,1])+$.pos)
					if symmetry==false then polyOp.setVert $ rightAr[i] (((Lpos-$.pos)*[-1,1,1])+$.pos)
				)
			)
			if symmetry==false then
			(
				for i = 1 to centerAr.count do
				(
					Cpos=polyOp.getVert $ centerAr[i]
					polyOp.setVert $ centerAr[i] (((Cpos-$.pos)*[-1,1,1])+$.pos)
				)
			)else
			(
				for i = 1 to centerAr.count do
				(
					Cpos=polyOp.getVert $ centerAr[i]
					polyOp.setVert $ centerAr[i] (((Cpos-$.pos)*[0,1,1])+$.pos)
				)
			)
		)
		pickbutton get "拾取参照物" tooltip:"拾取未改动前的物体状态，尽量使用左右对称状态"
		checkbox chk1 "左右对称" checked:true pos:[50,32]
		checkbox chk2 "只镜像选中点  " pos:[120,32]
		button mir "镜像" tooltip:"改动物体一边之后进行左右镜像"
		
		on get picked obja do
		(	
			obj1 = obja
			if classof obj1 == Editable_Poly then
			(				
				get.caption = "参照物体:" + obj1.name as string
				
				if chk2.checked == false then
				(
					y = #{}
					n = polyOp.getNumVerts obj1
					for i = 1 to n do 
					(
						append y i
					)
					obj1.EditablePoly.SetSelection #Vertex y
				)
				
				getMirrorData obj1
			)
			else messagebox"请塌陷成Poly"
		)
		
		on chk2 changed state do
		(
			get.caption = "拾取参照物"
		)
		
		on mir pressed do  with undo label:"自身镜像" on
		(
			if get.caption == "拾取参照物"  then
			( 
				messagebox "请拾取参照物"
			)
			else
			(
				if selection.count ==1 and classof $ == Editable_Poly then
				(
					if chk1.checked == true then
					(
						mirrorMorph symmetry:true
					)
					else
					(
						mirrorMorph()
					)
				)
				else
				(
					messagebox"请选中单个Poly物体"
				)
			)
		)
	)

----------------------------------------镜像坐标

	rollout mirtran "坐标镜像 (坐)"
	(
		fn mirrorObjects mirobj1 mirobj2 dontAffectChildren:false=
		(
			getObj=mirobj1
			setObj=mirobj2
			cTms=for x in setObj.children collect x.transform
			
			pos=getObj.pos
			rot=getObj.rotation
			
			setObj.rotation=(quat rot.x (rot.y*-1) (rot.z*-1) rot.w)
			setObj.pos=pos*[-1,1,1]
			
		 	if dontAffectChildren then (for i = 1 to setObj.children.count do (setObj.children[i].transform=cTms[i]))
		)
		pickbutton obja "选择参照物"
		pickbutton objb "选择目标物"
		checkbox chk "影响子物体" checked:true pos:[75,60]
		button mir "镜像" tooltip:"移动并旋转目标物体到参照物体坐标在X轴向的对称点上"
		
		on obja picked obj1 do
		(
			global mobj1 = undefined
			mobj1 = obj1
			obja.caption = "参照物体:" + mobj1.name as string
		)
		
		on objb picked obj2 do
		(
			global mobj2 = undefined
			mobj2 = obj2
			objb.caption = "目标物体:" + mobj2.name as string
		)
		
		on mir pressed do with undo label:"镜像坐标" on
		(
			if obja.caption == "选择参照物" or objb.caption == "选择目标物" then
			(
				messagebox "请选择参照物与目标物"
			)
			else
			(
				if chk.checked == true then
				(
					mirrorObjects mobj1 mobj2
				)
				else mirrorObjects mobj1 mobj2 dontAffectChildren:true
			)
		)
	)


----------------------------------------加强 ring loop


rollout seledge "隔行 Ring/Loop  (物)"
(
	fn seledgering step:2 num:1 ori1:true ori2:true rorl:true =
	(	
		if selection.count == 1 then
		(
			if classof $ != Editable_Poly then
			(
				if queryBox "是否转换成Poly" then
				(
					try
						converttopoly $
					catch
						false
				)
			)
		)
		else
			messagebox "请选择单个物体"
		if classof $ == Editable_Poly then
		(	
			finalset = #{}
			gedgeset2 = $.getSelection #Edge
			constep = 100.0/(gedgeset2 as array).count
			subobjectLevel = 2
			rollout loopandring "正在解算" width:320 height:50
			(
				label Info "完成 " pos:[20,2]
				label ab "Esc强行退出" pos:[220,2]
				progressBar loopandring1 "" pos:[10,20] width:300 height:8 color:yellow
				progressBar loopandring2 "" pos:[10,35] width:300 height:8
			)
			createdialog loopandring
			for z = 1 to (gedgeset2 as array).count do
			(
				if keyboard.escPressed == true then exit
				gedgeset1 = #{}
				$.EditablePoly.SetSelection #Edge (append gedgeset1 (gedgeset2 as array)[z])
				j = 1
				base = polyOp.getEdgeSelection $
				if rorl == true then
				(
					$.EditablePoly.SelectEdgeRing ()
				)
				else
				(
					$.EditablePoly.SelectEdgeLoop ()
				)
				edgeset = $.EditablePoly.getSelection #Edge
				arredgeset1 = edgeset as array
				numedge = arredgeset1.count
				arredgeset2 = #()
				arredgeset3 = #()
				$.EditablePoly.SetSelection #Edge base
				arredgeset1 = base as array
			
				for i = 1 to numedge do
				(	
					if keyboard.escPressed == true then exit
					loopandring.loopandring1.value = (100/(numedge+1) as float)*i
					edgeset = $.EditablePoly.getSelection #Edge
					arredgeset1 = edgeset as array
					append arredgeset2 arredgeset1[1]
					j = numedge-i+1
					if arredgeset1[1] != arredgeset3[1] then
					(
						edgesetx = $.EditablePoly.getSelection #Edge
						arredgeset3 = edgesetx as array
						if rorl == true then
						(
							$.setRingShift 1 true false
						)
						else
						(
							$.setLoopShift 1 true false
						)
					)
					else 
					(	
						deleteItem arredgeset2 i
						exit
					)
				)
				$.EditablePoly.SetSelection #Edge base
				for i = 1 to j do
				(	
					if keyboard.escPressed == true then exit
					loopandring.loopandring1.value = (100/(numedge+1) as float)*(i+(numedge+1-j)) 
					if rorl == true then
					(
						$.setRingShift -1 true false
					)
					else
					(
						$.setLoopShift -1 true false
					)
					edgeset = $.EditablePoly.getSelection #Edge
					arredgeset1 = edgeset as array
					append arredgeset2 arredgeset1[1]
				)
				if ori1 == true and ori2 == false then
				(
					for i = 1 to numedge-j by (step+num-1) do
					(
						for y = 1 to num do
						(
							if (i+y-1) <= (numedge-j) then
								append finalset arredgeset2[i+y-1]
						)
					)
				)
				
				if ori2 == true and ori1 == false then
				(	
					append finalset arredgeset2[1]
					for y = 1 to num-1 do
					(
						try 
							append finalset arredgeset2[numedge-j+y]
						catch
							false
					)
		
					for i = numedge-j to numedge by (step+num-1) do
					(
						if i > numedge-j then
						(
							for y = 1 to num do
							(
								try 
									append finalset arredgeset2[i+y-1]
								catch
									false
							)
						)
					)
				)
				
				if ori1 == true and ori2 == true then
				(
					for i = 1 to numedge-j by (step+num-1) do
					(
						for y = 1 to num do
						(
							if (i+y-1) <= (numedge-j) then
								append finalset arredgeset2[i+y-1]
						)
					)
					for i = numedge-j-num+1 to numedge by (step+num-1) do
					(
						if i > numedge-j then
						(
							for y = 1 to num do
							(
								try 
									append finalset arredgeset2[i+y-1]
								catch
									false
							)
						)
					)
				)
				loopandring.loopandring2.value = constep*z
				loopandring.loopandring2.color = ( color 0 0 (((245.0/((gedgeset2 as array).count))*z) as integer +10) )
				loopandring.Info.caption = "完成 " + ((constep*(z)) as integer) as string + "%"
			)
			$.EditablePoly.SetSelection #Edge finalset
			destroyDialog loopandring
		)
		else
		(
			if selection.count == 1 then
				messagebox "目前只支持Poly类型"
		)
	)
	spinner step "间隔" width:50 type:#integer range:[1,999999,1] pos:[50,7]
	spinner num "相邻" width:50 type:#integer range:[1,999999,1] pos:[150,7]
	label exp "方向:" pos:[70,30]
	checkbox ori1 "＋" pos:[110,30] checked:true
	checkbox ori2 "－" pos:[150,30] checked:true
	button ring "Ring" pos:[70,50]
	button loop "Loop" pos:[130,50]
	--button ringup "↑" height:10 width:10 pos:[70,50]
	--button ringdw "↓" height:10 width:10 pos:[70,61]
	--button loopup "↑" height:10 width:10 pos:[131,50]
	--button loopdw "↓" height:10 width:10 pos:[131,61]
	on ring pressed do  with undo label:"Pre Ring" on
	(
		seledgering step:(step.value+1) num:num.value ori1:ori1.checked ori2:ori2.checked rorl:true
	)
	on loop pressed do  with undo label:"Pre Loop" on
	(
		seledgering step:(step.value+1) num:num.value ori1:ori1.checked ori2:ori2.checked rorl:false
	)
)

---------------------------------------- 超级排序

	 finset = #()
	 finset2 = #()
	 finset3 = #()
	 finalset = #()
	rollout taxis "按坐标排序  (动)"
	(
		fn taxis1 selset selset_test1 =
		(
			finset = #()
			j = 1
			c = #()
			while selset.count != 0 do
			(	
				delnumset = #(1)
				finset[j] = #()
				append finset[j] selset[1]
				for i = 2 to selset.count do
				(
					case selset_test1 of
					(
						1: (
								a = selset[1].pos.x 
								b = selset[i].pos.x
							)
						2: (
								a = selset[1].pos.y 
								b = selset[i].pos.y
							)
						3: (
								a = selset[1].pos.z
								b = selset[i].pos.z
							)
					)
					if a == b then
					(	
						append finset[j] selset[i]
						append delnumset i
					)
				)
				i = 1
				y = 0
				while i <= delnumset.count do
				(
					deleteItem selset (delnumset[i]-y)
					i += 1
					y += 1
				)
				j += 1
			)
			for j = 1 to finset.count do
			(
				for i = j to finset.count do
				(
					case selset_test1 of
					(
						1: (
								a = (finset[j])[1].pos.x 
								b = (finset[i])[1].pos.x
							)
						2: (
								a = (finset[j])[1].pos.y 
								b = (finset[i])[1].pos.y
							)
						3: (
								a = (finset[j])[1].pos.z 
								b = (finset[i])[1].pos.z
							)
					)
					if a > b then
					(
						c = finset[j]
						finset[j] = finset[i]
						finset[i] = c
					)
				)
			)
		)
		fn taxis2 selset_test1 selset_test2 =
		(
			taxis1 (selection as array) selset_test1
			secfinset = finset
			finset2 = #()
			for i = 1 to secfinset.count do
			(
				taxis1 secfinset[i] selset_test2
				append finset2 finset
			)
		)
		
		fn taxis3 selset_test1 selset_test2 selset_test3 =
		(
			taxis2 selset_test1 selset_test2
			thifinset = finset2
			finset3 = #()
			for i = 1 to thifinset.count do
			(
				finset3[i] = #()
				for j = 1 to thifinset[i].count do
					(
						taxis1 (thifinset[i])[j] selset_test3
						append finset3[i] finset
					)
			)
		)
		
		fn taxisrename taxisname selset_test1 selset_test2 selset_test3 =
		(
			case selset_test1 of
			(
				1: (
						name1 = "X"
					)
				2: (
						name1 = "Y"
					)
				3: (
						name1 = "Z"
					)
			)
			case selset_test2 of
			(
				1: (
						name2 = "X"
					)
				2: (
						name2 = "Y"
					)
				3: (
						name2 = "Z"
					)
			)
			case selset_test3 of
			(
				1: (
						name3 = "X"
					)
				2: (
						name3 = "Y"
					)
				3: (
						name3 = "Z"
					)
			)
			for i = 1 to finset3.count do
			(
				for j = 1 to finset3[i].count do
				(
					for k = 1 to finset3[i][j].count do
					(
						finset3[i][j][k].name = taxisname + name1 + i as string + "_" + name2 + j as string + "_" + name3 + k as string
					)
				)
			)
		)
		
		
		fn seltaxis on2 on3 n1 n2 n3 =
		(
			s1 = 1
			s2 = 1
			e1 = 1
			clearselection()
			try
			(
				if on2 == false then
				(
					s1 = 1
					e1 = finalset[n1].count
				)
				else
				(
					s1 = n2
					e1 = n2
				)
				for i = s1 to e1 do
				(
					if on3 == false then
					(
						s2 = 1
						e2 = finalset[n1][i].count
					)
					else
					(
						s2 = n3
						e2 = n3
					)
					for j = s2 to e2 do
					(	
						selectmore finalset[n1][i][j]
					)
				)
			)
			catch
				messagebox "undefined"
		)
		
		fn fmovekeys on2 on3 num =
		(
			y = num
			for i = 1 to finalset.count do
			(
				for j = 1 to finalset[i].count do
				(
					for k = 1 to finalset[i][j].count do
					(
						movekeys finalset[i][j][k] y
						if on3 == true then
							y += num
					)
					if on2 == true and on3 == false then
						y += num
				)
				if on2 == false then
					y += num
			)
		)
		groupbox grouptaxis "排序" pos:[5,5] width:220 height:110
		dropdownlist n1 "1:" items:#("X","Y","Z") selection:1 width:30 pos:[35,20]
		dropdownlist n2 "2:" items:#("Y","Z") selection:1 width:30 pos:[92,20]
		dropdownlist n3 "3:" items:#("Z") selection:1 width:30 pos:[150,20]
		checkbox rename "重命名" pos:[30,66]
		edittext name "名字:" enabled:false width:90 pos:[100,67] text:"Taxis_"
		button taxisb "排序" tooltip:"根据XYZ坐标将场景中被选中物体按位置顺序储存于'finalset'矩阵中"
		groupbox groupwatch "查看" pos:[5,120] width:220 height:70
		checkbox ch2 pos:[65,140] width:15
		checkbox ch3 pos:[135,140] width:15 enabled:false
		spinner c1 "X:"  width:40 pos:[20,140] range:[1,99999999,1] type:#integer
		spinner c2 "Y:"  width:40 pos:[90,140] range:[1,99999999,1] type:#integer enabled:false
		spinner c3 "Z:"  width:40 pos:[160,140] range:[1,99999999,1] type:#integer enabled:false
		button choose "选择" tooltip:"根据XYZ顺序选择已排序物体"
		groupbox mkg "移动关键帧" pos:[5,200] width:220 height:60
		label lb1 "X:" pos:[45,215]
		label lb2 "Y:" pos:[100,215]
		label lb3 "Z:" pos:[155,215]
		checkbox ch0 "X" width:15 pos:[65,215] enabled:false checked:true
		checkbox ch4 "Y" width:15 pos:[120,215] 
		checkbox ch5 "Z" width:15 pos:[175,215] enabled:false
		button mkb "移动关键祯" pos:[40,232] tooltip:"根据坐标顺序移动已排序物体关键帧"
		spinner mks "步幅:" pos:[140,235] width:40  range:[-99999999,99999999,10] type:#integer
		
		on ch2 changed state do
		(
			if ch2.checked == true then
			(
				c2.enabled = true
				ch3.enabled = true
				ch4.checked = true
				ch5.enabled = true
			)
			else
			(
				c2.enabled = false
				c3.enabled = false
				ch3.checked = false
				ch3.enabled = false
				ch4.checked = false
				ch5.checked = false
				ch5.enabled = false
			)	
		)
		on ch3 changed state do
		(
			if ch3.checked == true then
			(
				c3.enabled = true
				ch5.checked = true
			)
			else
			(
				c3.enabled = false
				ch5.checked = false
			)
		)
		on ch4 changed state do
		(
			if ch4.checked == true then
			(
				ch2.checked = true
				ch3.enabled = true
				ch5.enabled = true
			)
			else
			(
				ch2.checked = false
				ch3.enabled = false
				ch3.checked = false
				ch5.enabled = false
				ch5.checked = false
			)
		)
		on ch5 changed state do
		(
			if ch5.checked == true then
			(
				ch3.checked = true
			)
			else
			(
				ch3.checked = false
			)
		)		
		
		on rename changed state do
		(
			if rename.checked == false then
				name.enabled = false
			else
				name.enabled = true
		)
		
		
		on n1 selected state do
		(
			case n1.items[n1.selection] of
			(
				"X":
				(
					n2.items = #("Y","Z")
					case n2.items[n2.selection] of
					(
						"X": n3.items = #("Z")
						"Y": n3.items = #("Z")
						"Z": n3.items = #("Y")
					)
				)
				"Y":
				(
					n2.items = #("X","Z")
					case n2.items[n2.selection] of
					(
						"X": n3.items = #("Z")
						"Y": n3.items = #("Z")
						"Z": n3.items = #("X")
					)
				)
				"Z":
				(
					n2.items = #("X","Y")
					case n2.items[n2.selection] of
					(
						"X": n3.items = #("Y")
						"Y": n3.items = #("X")
						"X": n3.items = #("Y")
					)
				)
			)
		)
		
		on n2 selected state do
		(
			case n2.items[n2.selection] of
			(
				"X":
				(
					if n1.selection == 2
					then
						n3.items = #("Z")
					else
						n3.items = #("Y")
				)
				"Y":
				(
					if n1.selection == 1
					then
						n3.items = #("Z")
					else
						n3.items = #("X")
				)
				"Z":
				(
					if n1.selection == 2
					then
						n3.items = #("X")
					else
						n3.items = #("Y")
				)
			)
		)
		
		on taxisb pressed do  with undo label:"排序" on
		(
			case n1.items[n1.selection] of
			(
				"X":
				(
					ux = 1
				)
				"Y":
				(
					ux = 2
				)
				"Z":
				(
					ux = 3
				)
			)
			case n2.items[n2.selection] of
			(
				"X":
				(
					uy = 1
				)
				"Y":
				(
					uy = 2
				)
				"Z":
				(
					uy = 3
				)
			)
			case n3.items[n3.selection] of
			(
				"X":
				(
					uz = 1
				)
				"Y":
				(
					uz = 2
				)
				"Z":
				(
					uz = 3
				)
			)
		
			c1.caption = n1.items[n1.selection]
			c2.caption = n2.items[n2.selection]
			c3.caption = n3.items[n3.selection]
			lb1.caption = n1.items[n1.selection]
			lb2.caption = n2.items[n2.selection]
			lb3.caption = n3.items[n3.selection]
			
			taxis3 ux uy uz
			if rename.checked == true then
				taxisrename name.text ux uy uz
			finalset = finset3
			messagebox "阵列已存入 'finalset' 中"
			
		)
		on choose pressed do with undo label:"选择" on
		(	
			seltaxis ch2.checked ch3.checked c1.value c2.value c3.value
		)
		on mkb pressed do with undo label:"移动关键帧" on
		(
			fmovekeys ch2.checked ch3.checked mks.value
		)
	)

	
----------------------------------------简化样条线


rollout dfspline "简化样条线  (物)"
(
	fn dfline delangle predfline =
	(		
		for a in selection do
		(
			if classof a == SplineShape or classof a == line then
			(
				dellist = #()
				numsp = numsplines a
				for i = 1 to numsp do
				(
					numkn = numKnots a i
					dellist[i] = #()
					stopdel = 0
					for j = 1 to numkn - 2 do
					(
						knpos1 = getKnotPoint a i j
						knpos2 = getKnotPoint a i (j+1)
						knpos3 = getKnotPoint a i (j+2)
						try
						(
							angletst = acos (dot (normalize (knpos1 - knpos2)) (normalize(knpos3 - knpos2)))
							if angletst > delangle and stopdel < predfline then
							(
								append dellist[i] (j+1)
								stopdel += 1
							)
							else
								stopdel = 0
						)
						catch
							messagebox "错误"
					)
				)
				for i = 1 to numsp do
				(
					if dellist[i].count != 0 then
					(
						for j = 1 to dellist[i].count do
						(
							delj = dellist[i][(dellist[i].count + 1 - j)]
							deleteknot a i delj
						)
					)
				)
			)
			else
				messagebox "本程序只支持可编辑样条线"
		)
	)
	spinner deleteangle "拐角容差" range:[0,180,170] width:80
	spinner predel "限制" range:[0,99999999,3] type:#integer width:50
	button refspline "优化" tooltip:"三个连续节点的角度值大于拐角容差将删除中间节点，限制值控制最多不连续删除的节点数"
	on refspline pressed do
	(
		ifconver = undefined
		for a in selection do
		(
			if classof a != SplineShape and classof a != line then
			(
				ifconver = 1
			)
		)
		if ifconver == 1 then
		(
			if queryBox "是否转换成可编辑样条线" then 
			(
				try
				(
					for a in selection do with undo label:"塌陷样条线" on
					(
						converttoSplineShape a
					)
				)
				catch
					messagebox "无法转换！"
			)
		)
		ifconver = undefined
		for a in selection do
		(
			if classof a == SplineShape or classof a == line then
			(
				ifconver = 1
			)
		)
		if ifconver == 1 then
		(
			oplinecopset = #()
			oplinecopold = #()
			pivotdisset = #()
			for a in selection do
			(
				oplinecop = copy a
				append oplinecopold a
				append oplinecopset oplinecop
				oplinecop.wirecolor = a.wirecolor
			)
			select oplinecopset
			dfline deleteangle.value predel.value
			
			for i = 1 to oplinecopset.count do
			(
				objrpivot = oplinecopset[i].pivot
				ResetPivot oplinecopset[i]
				objrpivotres = oplinecopset[i].pivot
				pivotdis = objrpivot - objrpivotres
				append pivotdisset pivotdis
			)
			undo label:"优化样条线" on
			(
				for i = 1 to oplinecopold.count do
				(
					objupivot = oplinecopold[i].pivot
					ResetPivot oplinecopold[i]
					oplinecopold[i].pos = objupivot
					oplinecopold[i].baseobject = oplinecopset[i].baseobject
					oplinecopold[i].pivot = objupivot + pivotdisset[i]
					oplinecopold[i].pos = objupivot
				)
			)
			for a in oplinecopold do with undo off
				InstanceMgr.MakeObjectsUnique a #prompt
			select oplinecopold
			delete oplinecopset
			subobjectLevel = 1
		)
		else
			messagebox "请选择样条线"
	)
)


----------------------------------------定点复制


seeobjects = boxPickNode (box2 [0,0] [10000,10000])
objarr = (for a in seeobjects where superclassof a == GeometryClass collect a) as array
rollout poscopy "定点复制  (场)"
(
	pickbutton pic_ref "拾取参照物"
	checkbox ifautogrid "附着物体" checked:true pos:[35,32]
	checkbox ifnormal "对齐法线" checked:true pos:[130,32]
	checkbox dargscale "拖拽缩放" checked:true pos:[35,50]
	radiobuttons cporrf labels:#("Copy","Instance","Reference")
	checkbutton copy_obj "复制" tooltip:"如果太卡，启用附着物体时尽量隐藏用不到的物体"
	
	on ifautogrid changed state do
	(
		if ifautogrid.checked == false then
		(
			ifnormal.checked = false
			ifnormal.enabled = false
		)
		else
		(
			ifnormal.checked = true
			ifnormal.enabled = true
		)
	)
	on dargscale changed state do
	(
		if dargscale.checked == false then
			scalesp.enabled = true
		else
			scalesp.enabled = false
	)
	on pic_ref picked obj do
	(
		if isGroupMember obj == true and isOpenGroupMember obj == false then
		(
			oldselect = selection as array
			select obj
			newgroup = $ as array
			select oldselect
			pic_group = for a in newgroup where finditem newgroup a.parent == 0 collect a
			pic_ref.caption = "参照物:" + pic_group[1].name as string
		)
		else
			pic_ref.caption = "参照物:" + obj.name as string
	)
	on copy_obj changed state do with undo label:"定点复制" on
	(
		objarr = (for a in geometry where a.ishidden == false collect a) as array
		tool poscopytool
		(
			local objpos,objtrans,poscopy_newobj,objcopying,mouseclipos,mousesclposx,mousesclposy,mousesclpos
			
			fn objcopying objref setpos setdir=
			(
				try
				(
					if isGroupMember objref == true and isopenGroupMember objref == false then
					(
						oldselect = selection as array
						select poscopy.pic_ref.object
						newgroup = $ as array
						select oldselect
						pic_group = for a in newgroup where finditem newgroup a.parent == 0 collect a
						case poscopy.cporrf.state of
						(
							1: maxOps.cloneNodes pic_group cloneType:#copy newNodes:&gopref
							2: maxOps.cloneNodes pic_group cloneType:#instance newNodes:&gopref
							3: maxOps.cloneNodes pic_group cloneType:#reference newNodes:&gopref
						)
						radydel = for a in gopref where isGroupMember a != true collect a
						poscopy_group = for a in gopref where finditem gopref a.parent == 0 collect a
						delete (for a in radydel where finditem poscopy_group a == 0 collect a)
						poscopy_newobj = poscopy_group[1]
					)
					else
					(
						case poscopy.cporrf.state of
						(
							1: poscopy_newobj = copy objref
							2: poscopy_newobj = instance objref
							3: poscopy_newobj = reference objref
						)
					)
					if objref.boxmode == true then
						poscopy_newobj.boxMode = true
					poscopy_newobj.scale = poscopy.pic_ref.object.scale
				)
				catch
				(
					poscopy_newobj = box()
					poscopy_newobj.wirecolor = black
					poscopy_newobj.name = "出错替代物"
					messagebox "参照物已失效！"
				)
				if poscopy.ifnormal.checked == true then
					poscopy_newobj.transform = setdir
				poscopy_newobj.pos = setpos
			)
			
			on freeMove do
			(
				c = undefined
				mouseRay = mapScreenToWorldRay mouse.pos
				getobjs = (for a in objarr where (IntersectRay a mouseRay) != undefined collect a)
				for j = 1 to getobjs.count do
				(
					for i = j to getobjs.count do
					(
						if (distance (IntersectRay getobjs[j] mouseRay).pos mouseRay.pos) > (distance (IntersectRay getobjs[i] mouseRay).pos mouseRay.pos) then
						(
							c = getobjs[j]
							getobjs[j] = getobjs[i]
							getobjs[i] = c
						)
					)
				)
				if poscopy.ifautogrid.checked == true then
				(
				try
					copyposgrid = IntersectRay getobjs[1] mouseRay
				catch
					copyposgrid = ray worldPoint [0,0,1]
				)
				else
				(
					copyposgrid = ray worldPoint [0,0,1]
				)
				objtrans = matrixfromnormal (copyposgrid.dir)
				objpos = copyposgrid.pos
				if poscopy_newobj != undefined then
				(
					if poscopy.ifnormal.checked == true then
						poscopy_newobj.transform = objtrans
					poscopy_newobj.pos = objpos
					try
						poscopy_newobj.scale = poscopy.pic_ref.object.scale
					catch()
				)
				else
				(
					try
					(
						objcopying poscopy.pic_ref.object objpos objtrans
						poscopy_newobj.scale = poscopy.pic_ref.object.scale
					)
					catch()
					poscopy_newobj.visibility = true
					poscopy_newobj.visibility.controller.value = 0.5
				)
			)
			
			on mousePoint clickno do
			(
				if clickno != 1 then
				(
					try
						poscopy_newobj.visibility.controller.value = poscopy.pic_ref.object.visibility.controller.value
					catch
						poscopy_newobj.visibility.controller.value = 1
					poscopy_newobj = undefined
					seeobjects = boxPickNode (box2 [0,0] [10000,10000])
					objarr = (for a in seeobjects where superclassof a == GeometryClass collect a) as array
				)
				else
					mouseclipos = mouse.pos
			)
			
			on mousemove clickno do
			(
				if (mouse.pos.x - mouseclipos.x) / 100 >= 0 then
				(
					mousesclposx = ((mouse.pos.x - mouseclipos.x) / 100) + 1
				)
				else if (mouse.pos.x - mouseclipos.x) / 100 > -1 then
					(
						mousesclposx = ((mouse.pos.x - mouseclipos.x) / 100) + 1
					)
					else
						mousesclposx = 0
						
				if ((mouse.pos.y - mouseclipos.y) / 100) <= 0 then
				(
					mousesclposy = -(((mouse.pos.y - mouseclipos.y) / 100) - 1)
				)
				else if (mouse.pos.y - mouseclipos.y) / 100 < 1 then
					(
						mousesclposy = -(((mouse.pos.y - mouseclipos.y) / 100) - 1)
					)
					else
						mousesclposy = 0
						
				c = undefined
				mouseRay = mapScreenToWorldRay mouse.pos
				getobjs = (for a in objarr where (IntersectRay a mouseRay) != undefined collect a)
				for j = 1 to getobjs.count do
				(
					for i = j to getobjs.count do
					(
						if (distance (IntersectRay getobjs[j] mouseRay).pos mouseRay.pos) > (distance (IntersectRay getobjs[i] mouseRay).pos mouseRay.pos) then
						(
							c = getobjs[j]
							getobjs[j] = getobjs[i]
							getobjs[i] = c
						)
					)
				)
				if poscopy.ifautogrid.checked == true then
				(
				try
					copyposgrid = IntersectRay getobjs[1] mouseRay
				catch
					copyposgrid = ray worldPoint [0,0,1]
				)
				else
				(
					copyposgrid = ray worldPoint [0,0,1]
				)
				objtrans = matrixfromnormal (copyposgrid.dir)
				objpos = copyposgrid.pos
				
				mousesclpos = mousesclposx * mousesclposy
				
				if poscopy_newobj != undefined then
				(
					if lbutton then
					(
						if poscopy.dargscale.checked == true then
						try
							poscopy_newobj.scale = [mousesclpos,mousesclpos,mousesclpos] * poscopy.pic_ref.object.scale
						catch()
						else
						(
							if poscopy.ifnormal.checked == true then
								poscopy_newobj.transform = objtrans
							poscopy_newobj.pos = objpos
							try
								poscopy_newobj.scale = poscopy.pic_ref.object.scale
							catch()
						)
					)
					else
					(
						if poscopy.ifnormal.checked == true then
							poscopy_newobj.transform = objtrans
						poscopy_newobj.pos = objpos
						try
							poscopy_newobj.scale = poscopy.pic_ref.object.scale
						catch()
						mouseclipos = mouse.pos
					)
				)
				else
				(
					try
						objcopying poscopy.pic_ref.object objpos objtrans
					catch()
					poscopy_newobj.visibility = true
					poscopy_newobj.visibility.controller.value = 0.5
				)
			)
			
			on mouseAbort clickno do
			(
				poscopy.copy_obj.checked = false
				delete poscopy_newobj
			)
		)
		if copy_obj.checked == true then
		(
			if pic_ref.caption == "拾取参照物" then
			(
				copy_obj.checked = false
				messagebox "请拾取参照物！"
			)
			else
			(
				startTool poscopytool
			)
		)
		else
		(
			stopTool poscopytool
		)
	)
)


----------------------------------------丢失贴图

	LostTex = 0
	MtlNum = 1
	IfExit = false
	LostTexSet = #()
rollout LostMtlObj "寻找丢失贴图 (材)"
(

	fn FindFile FilePath FileName SetPath IfSub ProFin =
	( 
		if FilePath.count >45 then
		(
			ProFin.caption = (substring FilePath 1 20) + "....." + (substring FilePath (FilePath.count - 20) FilePath.count)
		)
		else
		(
			ProFin.caption = FilePath
		)
		if ( doesFileExist (FilePath + FileName) ) == true then
		(
			try
				SetPath.filename = FilePath + FileName
			catch
			(
				try
					SetPath.HDRIMapName = FilePath + FileName
				catch()
			)
			IfExit = true
		)
		else
		(
			if (GetDirectories (FilePath + "*")).count != 0 and IfSub == true and keyboard.escPressed != true do
			(
				for i = 1 to (GetDirectories (FilePath + "*")).count do
				(
					if IfExit != true then
						FindFile (GetDirectories (FilePath + "*"))[i] FileName SetPath IfSub ProFin
					if IfExit == true or IfExit == undefined do
					(
						exit
						IfExit = true
					)
				)
			)
		)
	)
	fn Insing Texing =
	(
		if (findItem sceneMaterials meditMaterials[MtlNum]) == 0 then
		(
			meditMaterials[MtlNum] = Texing
			MtlNum += 1
		)
		else
		(
			MtlNum += 1
			Insing Texing
		)
	)
	fn SameNameTex InSet OutSet =
	(
		SubSet1 = #()
		SubSet2 = #()
		for i = 1 to InSet.count do
		(
			a = try filenameFromPath InSet[i].filename catch filenameFromPath InSet[i].HDRIMapName
			b = try filenameFromPath InSet[1].filename catch filenameFromPath InSet[1].HDRIMapName
			if a == b then
			(
				append SubSet1 InSet[i]
			)
			else
			(
				append SubSet2 InSet[i]
			)
		)
		append OutSet SubSet1
		if SubSet2.count != 0 and keyboard.escPressed != true do
			SameNameTex SubSet2 OutSet
	)
	
	fn FindTex TheTex TheLib TheType TheNull TheClear =
	(
		fn InsLibType Type Tex =
		(
			case Type of
			(
				1:
				(
					meditMaterials[MtlNum] = Tex
					MtlNum += 1
				)
				2:
				(
					Insing Tex
				)
				3:
				(
					meditMaterials[MtlNum] = standard()
					meditMaterials[MtlNum] = Tex
					MtlNum += 1
				)
			)
		)
		if getNumSubTexmaps TheTex > 0 then
		(
			for i = 1 to (getNumSubTexmaps TheTex) do
			(
				if (getSubTexmap TheTex i) != undefined and keyboard.escPressed != true do
					FindTex (getSubTexmap TheTex i) TheLib TheType TheNull TheClear
			)
		)
		else
		(
			if superclassof TheTex == textureMap do
			(
				try
				(
					if doesFileExist TheTex.filename == false and (if TheNull == false then (TheTex.filename != "") else true) do
					(
						LostTex = 1
						if TheLib == true do
						(
							InsLibType TheType TheTex
						)
						if TheClear == true do
						(
							TheTex.filename = ""
						)
						append LostTexSet TheTex
					)
				)
				catch
				(
					try
					(
						if doesFileExist TheTex.HDRIMapName == false and (if TheNull == false then (TheTex.HDRIMapName != "") else true) do
						(
							LostTex = 1
							if TheLib == true do
							(
								InsLibType TheType TheTex
							)
							if TheClear == true do
							(
								TheTex.HDRIMapName = ""
							)
							append LostTexSet TheTex
						)
					)
					catch()
				)
			)
		)
	)
	
	
	fn FindMtl TheMtl TheLib TheType TheNull TheClear =
	(
		FindTex TheMtl TheLib TheType TheNull TheClear
		try
		(
			if getNumSubMtls TheMtl > 0 and keyboard.escPressed != true do
			(
				for i = 1 to (getNumSubMtls TheMtl) do
				(
					FindMtl (getSubMtl TheMtl i) TheLib TheType TheNull TheClear
				)
			)
		)
		catch()
	)
	
	checkbox InsLib "导入失效贴图到材质编辑器:             " checked:true
	radiobuttons InsType labels:#("重置","添加","覆盖")
	checkbox NullMap "查找空路径   "
	checkbox IfSelect "选中贴图失效的物体      " 
	checkbox Replace "清空失效贴图  (无法撤销!)            "
	checkbox FindMap "搜索贴图:      "
	button MapPath "设置贴图目录" pos:[20,127] width:140 enabled:false tooltip:"未指定路径"
	checkbox FindSub "子目录" pos:[165,130] checked:true enabled:false
	button done "查找" width:80 pos:[70,160] tooltip:"材质球更改均无法撤销"
	
	rollout FindingMtl "正在解算" width:320 height:60
	(
		label Info "正在搜索: " pos:[5,2]
		label path "" pos:[15,22] width:320
		label ab "Esc强行退出" pos:[220,2]
		progressBar Pr1 "" pos:[10,45] width:300 height:8
	)


	Local FilePath
	
	on InsLib changed state do
	(
		if InsLib.checked == true then
			InsType.enabled = true
		else
			InsType.enabled = false
	)
	on Replace changed state do
	(
		if Replace.checked == true then
		(
			FindMap.enabled = false
			MapPath.enabled = false
			FindSub.enabled = false
		)
		else
		(
			FindMap.enabled = true
			if FindMap.checked == true do
			(
				MapPath.enabled = true
				FindSub.enabled = true
			)
				
		)
	)
	on FindMap changed state do
	(
		if FindMap.checked == true then
		(
			MapPath.enabled = true
			FindSub.enabled = true
		)
		else
		(
			MapPath.enabled = false
			FindSub.enabled = false
		)
	)
	on MapPath pressed do
	(
		FilePath = getSavePath()
		try
		(
			MapPath.caption = (substring FilePath 1 20) + "..."
			MapPath.tooltip = FilePath
		)
		catch()
	)
	on done pressed do
	(
		createdialog FindingMtl
		MtlNum = 1
		if classof FilePath != string do
			FilePath = "undefined"
		if IfSelect.checked == true do
			clearselection()
		if InsLib.checked == true and InsType.state == 1 do
		(
			for i = 1 to meditMaterials.count do
			(
				meditMaterials[i] = Standard()
				meditMaterials[i].name = "Standard_" + i as string
			)
		)
		undo label:"选择" on
		(
			LostTexSet = #()
			for i = 1 to sceneMaterials.count do
			(
				FindingMtl.Pr1.value = (100/sceneMaterials.count as float)*(i-1)
				FindingMtl.path.caption = sceneMaterials[i].name
				if keyboard.escPressed != true do
				(
					FindMtl sceneMaterials[i] InsLib.checked InsType.state NullMap.checked Replace.checked
					IfExit = false
				)
				if IfSelect.checked == true do
				(
					if LostTex == 1 do
					(
						selectmore (for a in objects where a.material == sceneMaterials[i] collect a)
					)
				)
				LostTex = 0
			)
			if FindMap.checked == true and replace.checked == false do
			(
				FixSet = #()
				TheTexSet = #()
				SameNameTex LostTexSet FixSet
				for i = 1 to FixSet.count do
				(
					append TheTexSet FixSet[i][1]
				)
				for i = 1 to TheTexSet.count do
				(
					FindingMtl.Pr1.value = (100/TheTexSet.count as float)*(i-1)
					if filenameFromPath TheTexSet[i].filename != "" do
					try
					(
						FindFile ( if FilePath[FilePath.count] != "\\" then (FilePath + "\\") else FilePath ) (filenameFromPath TheTexSet[i].filename)  TheTexSet[i] FindSub.checked FindingMtl.path
					)
					catch
					(
						try
						(
							FindFile ( if FilePath[FilePath.count] != "\\" then (FilePath + "\\") else FilePath ) (filenameFromPath TheTexSet[i].HDRIMapName)  TheTexSet[i] FindSub.checked FindingMtl.path
						)
						catch()
					)
					IfExit = false
				)
				for i = 1 to FixSet.count do
				(
					for j = 1 to FixSet[i].count do
					(
						try
						(
							FixSet[i][j].filename = try FixSet[i][1].filename catch FixSet[i][1].HDRIMapName
						)
						catch
						(
							try
							(
								FixSet[i][j].HDRIMapName = try FixSet[i][1].filename catch FixSet[i][1].HDRIMapName
							)
							catch()
						)
					)
				)
			)
		)
		DestroyDialog FindingMtl
	)
)


----------------------------------------材质通道


ChannelsColor = #()
ChnCount = 0
ChnColNum = 1
rollout MakeChannels "快速生成通道 (材)"
(
	fn StatChnNum GetMtl Mul Ble =
	(
		if Classof GetMtl == Blend and GetMtl.Mask != undefined and Ble == true then
		(
			StatChnNum GetMtl.map1 Mul Ble
			StatChnNum GetMtl.map2 Mul Ble
		)
		else if Classof GetMtl == Multimaterial and Mul == true then
			(
				for i = 1 to getnumsubmtls GetMtl do
					StatChnNum GetMtl[i] Mul Ble
			)
		else
			ChnCount += 1
	)
	fn RandomColor =
	(
		c = 256.^3.
		n = 1 
		t = 2
		while (t^3)-t < ChnCount do
			t += 1
		ChnCount = (t^3)-t
		Step = ((c/ChnCount)^(1./3)) as integer
		while n != 0 and n < 255 do
		(
			if Step <= 255./n and Step > 255./(n+1) then
			(
				Step = 255/n
				n = 0
			)
			else
				n += 1
		)
		for i = 0 to 255 by Step do
		(
			r = i
			for j = 0 to 255 by Step do
			(
				g = j
				for k = 0 to 255 by Step do
				(
					b = k
					if r != g or g != b or b != r do
						append ChannelsColor (color r g b)
				)
			)
		)
	)
	fn SetChn GetMtl SetMtl Mul Ble Opa =
	(
		if Classof GetMtl == blend and GetMtl.Mask != undefined and Ble == true then
		(
			SetMtl.mask = GetMtl.mask
			if Classof GetMtl.map1 == Blend and GetMtl.map1.Mask != undefined and Ble == true then
			(
				SetMtl.map1 = blend()
				SetMtl.map1.name = SetMtl.name + "_1"
				SetMtl.map1.mask = GetMtl.map1.mask
				SetChn GetMtl.map1 SetMtl.map1 Mul Ble Opa
			)
			else if Classof GetMtl.map1 == Multimaterial and Mul == true then
				(
					SetMtl.map1 = Multimaterial()
					SetMtl.map1.name = SetMtl.name + "_1"
					SetMtl.map1.materialList.count = GetMtl.map1.materialList.count
					SetMtl.map1.mapEnabled = GetMtl.map1.mapEnabled
					SetMtl.map1.materialIDList = GetMtl.map1.materialIDList
					SetChn GetMtl.map1 SetMtl.map1 Mul Ble Opa
				)
				else
				(
					SetMtl.map1 = Standard()
					SetMtl.map1.name = SetMtl.name + "_1"
					SetChn GetMtl.map1 SetMtl.map1 Mul Ble Opa
				)

			if Classof GetMtl.map2 == Blend and GetMtl.map2.Mask != undefined and Ble == true then
			(
				SetMtl.map2 = blend()
				SetMtl.map2.name = SetMtl.name + "_2"
				SetMtl.map2.mask = GetMtl.map2.mask
				SetChn GetMtl.map2 SetMtl.map2 Mul Ble Opa
			)
			else if Classof GetMtl.map2 == Multimaterial and Mul == true then
				(
					SetMtl.map2 = Multimaterial()
					SetMtl.map2.name = SetMtl.name + "_2"
					SetMtl.map2.materialList.count = GetMtl.map2.materialList.count
					SetMtl.map2.mapEnabled = GetMtl.map2.mapEnabled
					SetMtl.map2.materialIDList = GetMtl.map2.materialIDList
					SetChn GetMtl.map2 SetMtl.map2 Mul Ble Opa
				)
				else
				(
					SetMtl.map2 = Standard()
					SetMtl.map2.name = SetMtl.name + "_2"
					SetChn GetMtl.map2 SetMtl.map2 Mul Ble Opa
				)
		)
		else if Classof GetMtl == Multimaterial and Mul == true then
			(
				SetMtl.materialList.count = GetMtl.materialList.count
				SetMtl.mapEnabled = GetMtl.mapEnabled
				SetMtl.materialIDList = GetMtl.materialIDList
	
				for i = 1 to getnumsubmtls GetMtl do
				(
					if Classof GetMtl[i] == Blend and GetMtl[i].Mask != undefined and Ble == true then
					(
						SetMtl[i] = blend()
						SetMtl[i].name = SetMtl.name + "_" + i as string
						SetMtl[i].mask = GetMtl[i].mask
						SetChn GetMtl[i] SetMtl[i] Mul Ble Opa
					)
					else if Classof GetMtl[i] == Multimaterial and Mul == true then
						(
							SetMtl[i] = Multimaterial()
							SetMtl[i].name = SetMtl.name + "_" + i as string
							SetMtl[i].materialList.count = GetMtl[i].materialList.count
							SetMtl[i].mapEnabled = GetMtl[i].mapEnabled
							SetMtl[i].materialIDList = GetMtl[i].materialIDList
							SetChn GetMtl[i] SetMtl[i] Mul Ble Opa
						)
						else
						(
							SetMtl[i] = Standard()
							SetMtl[i].name = SetMtl.name + "_" + i as string
							SetChn GetMtl[i] SetMtl[i] Mul Ble Opa
						)
				)
			)
			else
			(
				SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
				ChnColNum += 1
				SetMtl.Selfillumination = 100
				SetMtl.Glossiness = 0
				SetMtl.Soften = 0
				SetMtl.name = "Channel_R" + ChannelsColor[ChnColNum].r as string + "_G" + ChannelsColor[ChnColNum].g as string + "_B" + ChannelsColor[ChnColNum].b as string
				if Opa == true do
				(
					try
					(
						SetMtl.Opacitymap = GetMtl.Opacitymap
						SetMtl.Opacity = GetMtl.Opacity
					)
					catch()
				)
			)
	)
	fn ColorChannels Mul Ble Opa UMO =
	(
		ChannelsColor = #()
		ChnCount = 0
		ChnColNum = 1
		ScnMtl = for a in sceneMaterials where (for b in objects where b.material == a collect b).count != 0 collect a
		ScnUnMtlObj = for a in objects where a.material == undefined and (superclassof a == GeometryClass or (superclassof a == shape and a.render_renderable == true)) collect a
		for GetMtl in ScnMtl do
		(
			StatChnNum GetMtl Mul Ble
		)
		if UMO == 1 then
			ChnCount += 1
		else
			ChnCount += ScnUnMtlObj.count
		RandomColor()
		for GetMtl in ScnMtl do
		(
			SetMtl = Standard()
			SetMtl.name = "Channel_" + GetMtl.name
			if Classof GetMtl == blend and GetMtl.Mask != undefined and Ble == true then
			(
				SetMtl = blend()
				SetMtl.name = "Channel_" + GetMtl.name
				SetChn GetMtl SetMtl Mul Ble Opa
			)
			else if Classof GetMtl == Multimaterial and Mul == true then
				(
					SetMtl = Multimaterial()
					SetMtl.name = "Channel_" + GetMtl.name
					SetChn GetMtl SetMtl Mul Ble Opa
				)
				else
				(
					SetMtl.name = "Channel_" + GetMtl.name
					SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
					ChnColNum += 1
					SetMtl.Selfillumination = 100
					SetMtl.Glossiness = 0
					SetMtl.Soften = 0
					if Opa == true do
					(
						try
						(
							SetMtl.Opacitymap = GetMtl.Opacitymap
							SetMtl.Opacity = GetMtl.Opacity
						)
						catch()
					)
				)
			(for a in objects where a.material == GetMtl collect a).material = SetMtl
		)
		if UMO == 1 then
		(
			SetMtl = Standard()
			SetMtl.name = "Channel_UnMtl" 
			SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
			ChnColNum += 1
			SetMtl.Selfillumination = 100
			SetMtl.Glossiness = 0
			SetMtl.Soften = 0
			ScnUnMtlObj.material = SetMtl
		)
		else
		(
			for a in ScnUnMtlObj do
			(
				SetMtl = Standard()
				SetMtl.name = "Channel_" + a.name
				SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
				ChnColNum += 1
				SetMtl.Selfillumination = 100
				SetMtl.Glossiness = 0
				SetMtl.Soften = 0
				a.material = SetMtl
			)
		)
	)
	fn MakeLib =
	(
		ChannelsColor = #()
		ChnCount = meditMaterials.count
		RandomColor()
		for i = 1 to meditMaterials.count do
		(
			meditMaterials[i] = Standard()
			meditMaterials[i].name = "Channel_" + i as string
			meditMaterials[i].Ambient = meditMaterials[i].diffuse = meditMaterials[i].Specular = ChannelsColor[i]
			meditMaterials[i].Selfillumination = 100
			meditMaterials[i].Glossiness = 0
			meditMaterials[i].Soften = 0
		)
	)
	fn FindMtl TheMtl Name =
	(
		if classof TheMtl == Standardmaterial do
		(
			TheMtl.Ambient = TheMtl.diffuse = TheMtl.Specular = ChannelsColor[ChnColNum]
			TheMtl.name = TheMtl.name + "_" + Name
		)
		if getNumSubMtls TheMtl > 0 and keyboard.escPressed != true do
		(
			for i = 1 to (getNumSubMtls TheMtl) do
			(
				FindMtl (getSubMtl TheMtl i) Name
			)
		)
	)
	fn LayerChn Type =
	(
		ChannelsColor = #()
		ChnColNum = 1
		ChnCount = LayerManager.count
		RandomColor()
		ScnMtl = for a in sceneMaterials where (for b in objects where b.material == a collect b).count != 0 collect a
		LayerSet = #()
		if Type == 1 then
		(
			for i = 1 to LayerManager.count do
			(
				LayerSet[i] = for a in objects where a.INodeLayerProperties.layer.name == (LayerManager.getLayer (i-1)).name collect a
				for GetMtl in ScnMtl do
				(
					ObjTmp = for a in LayerSet[i] where a.material == GetMtl collect a
					if ObjTmp.count != 0 do
					(
						SetMtl = copy GetMtl
						SetMtl.name = GetMtl.name + "_" + (LayerManager.getLayer (i-1)).name
						FindMtl SetMtl (LayerManager.getLayer (i-1)).name
						ObjTmp.material = SetMtl
					)
				)
				ChnColNum += 1
			)
		)
		else
		(
			for i = 1 to LayerManager.count do
			(
				LayerSet[i] = for a in objects where a.INodeLayerProperties.layer.name == (LayerManager.getLayer (i-1)).name collect a
				SetMtl = standard()
				SetMtl.name = "Channel_" + (LayerManager.getLayer (i-1)).name
				SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
				ChnColNum += 1
				SetMtl.Selfillumination = 100
				SetMtl.Glossiness = 0
				SetMtl.Soften = 0
				LayerSet[i].material = SetMtl
			)
		)
	)
	fn GroupChn Type Sub =
	(
		ChannelsColor = #()
		ChnColNum = 1
		ScnMtl = for a in sceneMaterials where (for b in objects where b.material == a collect b).count != 0 collect a
		UnGrpObj = for a in objects where isGroupMember a == false and (superclassof a == GeometryClass or (superclassof a == shape and a.render_renderable == true)) collect a
		Grp = (for b in (for a in helpers where classof a == Dummy collect a) where isGroupHead b == true collect b)
		if Sub == false do
			Grp = for a in Grp where try isGroupHead a.parent == false catch true collect a
		if Type == 1 then
		(
			ChnCount = ScnMtl.count
			RandomColor()
			ScnMtl = for a in sceneMaterials where (for b in objects where b.material == a collect b).count != 0 collect a
			for i = 1 to Grp.count do
			(
				for GetMtl in ScnMtl do
				(
					if Sub == true then
						ObjTmp = for a in (for b in Grp[i] where b.parent == Grp[i] collect b) where a.material == GetMtl collect a
					else
						ObjTmp = for a in (for b in Grp[i] collect b) where a.material == GetMtl collect a
					if ObjTmp.count != 0 do
					(
						SetMtl = copy GetMtl
						SetMtl.name = GetMtl.name + "_" + Grp[i].name
						FindMtl SetMtl Grp[i].name
						ObjTmp.material = SetMtl
					)
				)
				ChnColNum += 1
			)
			for GetMtl in ScnMtl do
			(
				ObjTmp = for a in UnGrpObj where a.material == GetMtl collect a
				if ObjTmp.count != 0 do
				(
					SetMtl = copy GetMtl
					SetMtl.name = GetMtl.name + "_UnGroup"
					FindMtl SetMtl "UnGroup"
					ObjTmp.material = SetMtl
				)
				ChnColNum += 1
			)
		)
		else
		(
			ChnCount = Grp.count + UnGrpObj.count
			RandomColor()
			for i = 1 to Grp.count do
			(
				if Sub == true then
					ObjTmp = for a in Grp[i] where a.parent == Grp[i] collect a
				else
					ObjTmp = for a in Grp[i] Collect a
				SetMtl = standard()
				SetMtl.name = "Channel_" + Grp[i].name
				SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
				ChnColNum += 1
				SetMtl.Selfillumination = 100
				SetMtl.Glossiness = 0
				SetMtl.Soften = 0
				ObjTmp.material = SetMtl
			)
			for i = 1 to UnGrpObj.count do
			(
				SetMtl = standard()
				SetMtl.name = "Channel_" + UnGrpObj[i].name
				SetMtl.Ambient = SetMtl.diffuse = SetMtl.Specular = ChannelsColor[ChnColNum]
				ChnColNum += 1
				SetMtl.Selfillumination = 100
				SetMtl.Glossiness = 0
				SetMtl.Soften = 0
				UnGrpObj[i].material = SetMtl
			)
		)
	)

	groupbox MtlGroup pos:[7,0] width:220 height:120
	checkbox OnlyMtl "仅生成材质球  " pos:[15,15]
	checkbox UseGroup "仅按组划分" pos:[15,75]
	checkbox UseLayer "仅按层划分" pos:[15,50]
	checkbox SubGrp "识别子群组" pos:[15,95] enabled:false
	dropdownlist UnMtl "将无材质物体:" items:#("统一颜色","独立颜色") pos:[130,15] width:90
	checkbox BleMtl "识别混和材质  " checked:true pos:[120,80]
	checkbox IdMtl "识别多维材质  " checked:true pos:[120,60]
	checkbox OpaMtl "识别透明遮罩  " checked:true pos:[120,100]
	groupbox SysGroup pos:[7,120] width:220 height:40
	checkbox CloseLight "自动关闭所有灯光     " checked:true pos:[15,135]
	--checkbox ScanRen "自动切换为Scanline渲染器          " pos:[15,155]
	button Done "生成通道材质" pos:[70,165]
	
	on UseGroup changed state do
	(
		if UseGroup.checked == true then
		(
			UseLayer.enabled  = false
			UnMtl.enabled = false
			SubGrp.enabled = true
		)
		else
		(
			UseLayer.enabled  = true
			SubGrp.enabled = false
			UnMtl.enabled = true
		)
	)

	on UseLayer changed state do
	(
		if UseLayer.checked == true then
		(
			UnMtl.enabled = false
			UseGroup.enabled = false
		)
		else
		(
			UnMtl.enabled = true
			UseGroup.enabled = true
		)
	)
	
	on OnlyMtl changed state do
	(
		if OnlyMtl.checked == true then
		(
			UnMtl.enabled = false
			UseLayer.enabled = false
			UseGroup.enabled = false
			IdMtl.enabled = false
			BleMtl.enabled = false
			OpaMtl.enabled = false
			SubGrp.enabled = false
		)
		else
		(
			IdMtl.enabled = true
			BleMtl.enabled = true
			OpaMtl.enabled = true
			if UseLayer.checked == false and UseGroup.checked == false do
			(
				UnMtl.enabled = true
			)
			if UseLayer.checked == false do
				UseGroup.enabled = true
			if UseGroup.checked == false then
				UseLayer.enabled = true
			else
				SubGrp.enabled = true
		)
	)
	
	on Done pressed do with undo label:"材质通道" on
	(
		if OnlyMtl.checked == true then
			MakeLib()
		else
		(
			if BleMtl.checked == true or IdMtl.checked == true or OpaMtl.checked == true do
			(
				if UnMtl.selected == "统一颜色" then UMO = 1 else UMO = 2
				ColorChannels IdMtl.checked BleMtl.checked OpaMtl.checked UMO
			)
			if UseLayer.checked == true do
			(
				if BleMtl.checked == true or IdMtl.checked == true or OpaMtl.checked == true then
					LayerChn 1
				else
					LayerChn 2
			)
			if UseGroup.checked == true do
			(
				if BleMtl.checked == true or IdMtl.checked == true or OpaMtl.checked == true then
					GroupChn 1 SubGrp.checked
				else
					GroupChn 2 SubGrp.checked
			)
		)
		if CloseLight.checked == true do
			for a in lights do try a.on = false catch(try a.enabled = false catch())
	)
)

----------------------------------------灯光工具

rollout LightTools "灯光工具 (场)"
(
	button LightsOff "关闭所有/选中灯光" pos:[1,5] tooltip:"选择为空或者按住Shift关闭所有灯"
	button LightsOn "打开所有/选中灯光" pos:[118,5] tooltip:"选择为空或者按住Shift打开所有灯"
	button LightsHide "隐藏灯光" pos:[25,30]
	button LightsUnHide "显示灯光" pos:[125,30]
	groupbox grp0 "统一设置灯光排除物体:" pos:[3,63] width:230 height:145
	radioButtons ExInType "" pos:[50,85] width:145 height:16 labels:#("Exclude     ", "Include") columns:2
	dropdownlist IfAdd items:#("替换原设置","添加到原设置") width:80 pos:[15,135]
	groupBox grp1 "" pos:[100,102] width:124 height:65
	checkbox grp1chk "" pos:[75,110]
	radioButtons SdwType "" pos:[110,115] width:110 height:48 labels:#("Illumination", "Shadow Casting", "Both") columns:1 enabled:false
	button Setup "设置" tooltip:"将所有选中的物体从所有选中的灯光中排除" pos:[50,175]
	button Reset "清空" tooltip:"清空排除列表" pos:[140,175]
	
	on grp1chk changed state do
		SdwType.enabled = not SdwType.enabled
	
	on LightsOff pressed do with undo label:"关闭灯光" on
	(
		if (for a in selection where superclassof a == light collect a).count != 0 and keyboard.shiftPressed != true then
			for a in (for a in lights where a.isselected == true collect a) do try a.on = false catch(try a.enabled = false catch())
		else
			for a in lights do try a.on = false catch(try a.enabled = false catch())
	)
	on LightsOn pressed do with undo label:"打开灯光" on
	(
		if (for a in selection where superclassof a == light collect a).count != 0 and keyboard.shiftPressed != true then
			for a in (for a in lights where a.isselected == true collect a) do try a.on = true catch(try a.enabled = true catch())
		else
			for a in lights do try a.on = true catch(try a.enabled = true catch())
	)
	on LightsHide pressed do with undo label:"隐藏灯光" on
	(
		lig = (for a in lights where classof a != Targetobject collect a)
		if selection.count != 0 do
			lig = for a in lig where a.isselected == true collect a
		hide lig
	)
	on LightsUnHide pressed do with undo label:"显示灯光" on
		unhide lights
	on Setup pressed do
	(
		ExcObj = for a in selection where superclassof a == GeometryClass and classof a != Targetobject or (superclassof a == shape and a.render_renderable == true) collect a
		ExcLight = for a in selection where superclassof a == light collect a
		for a in ExcLight do
		(
			try
			(
				if ExInType.state == 1 then
				(
					if IfAdd.selected == "替换原设置" then
						a.excludeList = ExcObj
					else
						a.excludeList += ExcObj
				)
				else
				(
					if  IfAdd.selected == "替换原设置" then
						a.includeList = ExcObj
					else
						a.includeList += ExcObj
				)
				if grp1chk.checked == true do
					a.inclExclType = SdwType.state
			)
			catch()
		)
	)
	on Reset pressed do
	(
		ExcLight = for a in selection where superclassof a == light collect a
		for a in ExcLight do
		(
			try
			(
				if a.excludeList != undefined then
					a.excludeList = #()
				else
					a.includeList = #()
			)
			catch()
		)
	)

)

----------------------------------------摄像机工具

rollout CamTools "摄像机工具 (场)"
(
	button CamHide "隐藏摄像机" pos:[15,5]
	button CamUnHide "显示摄像机" pos:[125,5]
	on CamHide pressed do with undo label:"隐藏摄像机" on
	(
		cam = (for a in cameras where classof a != Targetobject collect a)
		if selection.count != 0 do
			cam = for a in cam where a.isselected == true collect a
		hide cam
	)
	on CamUnHide pressed do with undo label:"显示摄像机" on
		unhide cameras
)

----------------------------------------群组工具

rollout GroupTools "群组工具 (场)"
(
	button OpenGroup "打开所有/选中组" pos:[10,5] tooltip:"选择为空或者按住Shift打开所有组"
	button CloseGroup "关闭所有/选中组" pos:[125,5] tooltip:"选择为空或者按住Shift关闭所有组"
	on OpenGroup pressed do with undo label:"打开所有组" on
	(
		Gou = (for b in (for a in helpers where classof a == Dummy collect a) where isGroupHead b == true collect b)
		if selection.count != 0 and keyboard.shiftPressed != true do
			Gou = for a in Gou where a.isselected == true collect a
		for i = 1 to Gou.count do
		(
			setGroupOpen Gou[i] true
		)
	)
	on CloseGroup pressed do with undo label:"关闭所有组" on
	(
		Gou = (for b in (for a in helpers where classof a == Dummy collect a) where isGroupHead b == true collect b)
		if selection.count != 0 and keyboard.shiftPressed != true do
			Gou = for a in Gou where a.isselected == true collect a
		for i = 1 to Gou.count do
		(
			setGroupOpen Gou[i] false
		)
	)
)


----------------------------------------选中关联

rollout SelectIns "选中实例物体 (选)"
(
	button Sel "选择实例物体"
	on Sel pressed do with undo label:"选择" on
	(
		if selection.count == 1 then
		(
			selectmore (for a in objects where a.baseobject == $.baseobject collect a)
		)
		else
			messagebox "请选择单个物体"
	)
)

----------------------------------------选择空物体

rollout SelectEmp "选中空物体 (选)"
(
	button SelEmp "选择"
	on SelEmp pressed do with undo label:"选择" on
	(
		select (for a in objects where try(getnumfaces a.mesh == 0)catch(try(numKnots a == 0)catch(false)) collect a)
	)
)


----------------------------------------寻找丢失Vray代理

IfExit = false

rollout LostMesh "寻找丢失代理 (场)"
( 
	button MapPath "设置目录" pos:[20,5] width:140 tooltip:"未指定路径"
	checkbox FindSub "子目录" pos:[165,8] checked:true
	checkbox IfSelect "选中寻找失败物体      " align:#center checked:true
	button done "查找"
	
	fn FindMesh FilePath FileName SetPath IfSub ProFin Ifsel =
	(
		if FilePath.count >45 then
		(
			ProFin.caption = (substring FilePath 1 20) + "....." + (substring FilePath (FilePath.count - 20) FilePath.count)
		)
		else
		(
			ProFin.caption = FilePath
		)
		if ( doesFileExist (FilePath + FileName) ) == true then
		(
			if IfSel == true do
			(
				deselect SetPath
			)
			try
				SetPath.filename = FilePath + FileName
			catch()
			IfExit = true
		)
		else
		(
			if (GetDirectories (FilePath + "*")).count != 0 and IfSub == true and keyboard.escPressed != true do
			(
				for i = 1 to (GetDirectories (FilePath + "*")).count do
				(	
					if IfExit != true then
						FindMesh (GetDirectories (FilePath + "*"))[i] FileName SetPath IfSub ProFin Ifsel
					else
					(
						exit
						IfExit = true
					)
				)
			)
		)
	)
	
	fn SameNameFile InSet OutSet =
	(
		SubSet1 = #()
		SubSet2 = #()
		for i = 1 to InSet.count do
		(
			if filenameFromPath InSet[i].filename == filenameFromPath InSet[1].filename then
			(
				append SubSet1 InSet[i]
			)
			else
			(
				append SubSet2 InSet[i]
			)
		)
		append OutSet SubSet1
		if SubSet2.count != 0 and keyboard.escPressed != true do
			SameNameFile SubSet2 OutSet
	)
	
	rollout FindingMesh "正在解算" width:320 height:60
	(
		label Info "正在搜索: " pos:[5,2]
		label path "" pos:[15,22] width:320
		label ab "Esc强行退出" pos:[220,2]
		progressBar Pr1 "" pos:[10,45] width:300 height:8
	)
	
	local FilePath
	
	on MapPath pressed do
	(
		FilePath = getSavePath()
		try
		(
			MapPath.caption = (substring FilePath 1 20) + (if FilePath.count > 20 then "..." else "")
			MapPath.tooltip = FilePath
		)
		catch()
	)
	on done pressed do
	(
		createdialog FindingMesh
		if classof FilePath != string do
			FilePath = "undefined"
		if IfSelect.checked == true do
			clearselection()
		meshset00 = for a in objects where classof a == VRayProxy or classof a == VR代理 collect a
		lostmeshset = for a in meshset00 where (doesFileExist a.filename) != true collect a
		if lostmeshset.count > 0 do
		(
			ProxySet = #()
			SameNameFile lostmeshset ProxySet
			meshset = #()
			for i = 1 to ProxySet.count do
			(
				append meshset ProxySet[i][1]
			)
			
			for i = 1 to meshset.count do
			(
				FindingMesh.Pr1.value = (100/meshset.count as float)*(i-1)
				FindingMesh.path.caption = meshset[i].name
				if keyboard.escPressed != true do
				(
					if IfSelect.checked == true do
						selectmore meshset[i]
					FindMesh ( if FilePath[FilePath.count] != "\\" then (FilePath + "\\") else FilePath ) (filenameFromPath meshset[i].filename) meshset[i] FindSub.checked FindingMesh.path IfSelect.checked
					IfExit = false
				)
			)
			
			for i = 1 to ProxySet.count do
			(
				for j = 1 to ProxySet[i].count do
				(
					ProxySet[i][j].filename = ProxySet[i][1].filename
				)
			)
		)
		DestroyDialog FindingMesh
	)
)


----------------------------------------按材质塌陷

MtlCollConPl = 0
MtlCon = 0
SaveFaceNum = 1000000
GrpLaySet = #()
rollout CollByMtl "按材质塌陷 (材)"
(
	fn MtlColl CollObjM ConPr AllPr Num Pr =
	(
		undo off
		(
			gc()
			local CollObj,CollObj2
			ExitTst = true
			meshop_attach = meshop.attach
			rollout Colling "正在解算" width:320 height:100
			(
				label ab "Esc强行退出" pos:[220,2]
				label Mtl "Mtl:" pos:[10,40]
				progressBar Pr1 pos:[37,45] width:270 height:8
				label Obj "Obj:" pos:[10,20]
				progressBar Pr2  pos:[37,25] width:270 height:8
				label Grp "Grp:" pos:[10,60]
				progressBar Pr3  pos:[37,65] width:270 height:8
				label Scn "Scn:" pos:[10,80]
				progressBar Pr4  pos:[37,85] width:270 height:8
			)
			createdialog Colling
			CollObj = for a in CollObjM where try (a.material;true)catch(false) collect a
			Con = CollObj.count
			Colling.Pr1.value = 100 - (ConPr * Con)
			Colling.Pr3.value = AllPr
			Colling.pr4.value = Pr
			absface = 0
			for i = 1 to Con do
			(
				try
				(
					absface += getnumfaces (CollObj[i]).mesh
				)
				catch
				(
					absface += (((CollObj[i].sides*((CollObj[i].steps*((numKnots CollObj[i])-1))+(numKnots CollObj[i])))-CollObj[i].sides)*2)+((CollObj[i].sides-2)*2)
				)
			)
			absface = absface/Con
			CollObj2 = CollObj
			CollObj = (for a in CollObj where try(getnumfaces a.mesh <= absface)catch( ((((a.sides*((a.steps*((numKnots a)-1))+(numKnots a)))-a.sides)*2)+((a.sides-2)*2)) <= absface) collect a)
			if CollObj.count <= 1 do
				CollObj = CollObj2
			GoNum = (for a in CollObj where (try (getnumfaces a.mesh < (Num/2)) catch( try (((((a.sides*((a.steps*((numKnots a)-1))+(numKnots a)))-a.sides)*2)+((a.sides-2)*2)) < (Num/2)) catch (false))) collect a).count
			if GoNum > 1 do
			(
				Con = CollObj.count/2
				for i = 1 to Con while ExitTst do
				(
					if keyboard.escPressed == true do ExitTst = false
					Colling.Pr2.value = (100/(CollObj.count/2) as float)*i
					Obj1 = CollObj[i]
					ObjFace1 = try (getnumfaces (Obj1).mesh) catch ((((((Obj1).sides*(((Obj1).steps*((numKnots (Obj1))-1))+(numKnots (Obj1))))-(Obj1).sides)*2)+(((Obj1).sides-2)*2)))
					if ObjFace1 < SaveFaceNum do
					(
						while ObjFace1 + (try (getnumfaces (CollObj[i+1]).mesh) catch ((((((CollObj[i+1]).sides*(((CollObj[i+1]).steps*((numKnots (CollObj[i+1]))-1))+(numKnots (CollObj[i+1]))))-(CollObj[i+1]).sides)*2)+(((CollObj[i+1]).sides-2)*2)))) >= Num and i <= Con do
						(
							i += 1
						)
						if i <= Con then
						(
							Obj2 = CollObj[i+1]
							if classof Obj1 != Editable_mesh do
								convertTo Obj1 editable_mesh
							if (Obj2.scale.x*Obj2.scale.y*Obj2.scale.z)<0 then
							(
								if classof Obj2 != Editable_mesh do
									convertTo Obj2 editable_mesh
								try
									meshop_attach Obj1 Obj2.baseobject sourcenode:Obj2
								catch
								(
									convertTo Obj1 editable_mesh
									convertTo Obj2 editable_mesh
								)
							)
							else
							(
								try
									meshop_attach Obj1 Obj2
								catch
									convertTo Obj1 editable_mesh
							)
							try
								deleteitem CollObj (i+1)
							catch()
						)
						else
							SaveFaceNum = getnumfaces (CollObj[i-1]).mesh
					)
				)
				if keyboard.escPressed != true do
					MtlColl CollObjM ConPr AllPr Num Pr
			)
			destroydialog Colling
			clearUndoBuffer()
		)
	)
	fn CollCon CollObj AllPr Num Pr =
	(
		undo off
		(
			ConPr = 100./CollObj.count
			if keyboard.escPressed != true do
				MtlColl CollObj ConPr AllPr Num Pr
		)
	)
	fn CollCheck Obj Hid Sel Num Pr =
	(
		undo off
		(
			Obj = for a in Obj where try (a.material;true)catch(false) collect a
			RealNum = Num * 10000
			SaveFaceNum = RealNum
			local AllPr
			CollObjTmp = #()
			n = 1
			c = 1
			CollObj = for a in Obj where a.material != undefined and (superclassof a == GeometryClass or (superclassof a == shape and a.render_renderable == true and a.render_displayRenderMesh == true)) collect a
			if Hid == true do
				CollObj = for a in CollObj where a.ishidden == false collect a
			if Sel == true do
			(
				if selection.count != 0 do
					CollObj = for a in CollObj where a.isselected == true collect a
			)
			while c == 1 and c != 0 do
			(
				if CollObj[n] != undefined then
				(
					CollObjTmp = for a in CollObj where a.material == CollObj[n].material collect a
					c = CollObjTmp.count
					n += 1
				)
				else
					c = 0
			)
			GoNum = (for a in CollObjTmp where (try (getnumfaces a.mesh < (RealNum/2)) catch( try (((((a.sides*((a.steps*((numKnots a)-1))+(numKnots a)))-a.sides)*2)+((a.sides-2)*2)) < (RealNum/2)) catch (false)))collect a).count
			if CollObjTmp.count > 1 and GoNum > 1 and keyboard.escPressed != true do
			(
				AllPr = (MtlCollConPl/MtlCon as float)*100
				MtlCollConPl += 1
				CollCon CollObjTmp AllPr RealNum Pr
				CollCheck Obj Hid Sel Num Pr
			)
		)
	)


	Dropdownlist NoMtl "" items:#("忽略","合并") width:50 pos:[35,5] selection:2
	label tips "所有无材质物体" pos:[95,9]
	checkbox ifhide "不塌陷隐藏物体" pos:[5,55] checked:true
	checkbox ifselect "只塌陷选择物体" pos:[5,35] checked:true
	checkbox ifgroup "按组塌陷" pos:[120,55] checked:true
	checkbox ifsubgroup "Sub" pos:[195,55]
	checkbox iflayer "按层塌陷" pos:[120,35] enabled:false
	spinner theface "单个物体面数不超过(万):" range:[1,9999999,100] type:#integer width:130 pos:[75,75]
	checkbox save "提示保存" pos:[35,95] checked:true
	button UnLock "视图解锁" pos:[125,95] tooltip:"如果出错导致视图被锁定，按此键解锁视图"
	button Coll "塌陷" tooltip:"选择为空时塌陷所有" width:80
	
	rollout TipSave "警告!" width:400
	(
		label wranging1 "该操作运算量极大且无法撤销!请保存文件以防意外!"
		label wranging2 "塌陷前最好先重启3ds Max,请勿一次塌陷过多物体/面数!"
		label wranging3 "该版本尚不能彻底释放内存，塌陷后请重启3ds Max!"
		button goon "继续" pos:[105,65] width:80
		button stopb "取消" pos:[210,65] width:80
		checkbox savet "不再提示   " pos:[165,90]
		
		on goon pressed do
		(
			if savet.checked == true do
				CollByMtl.save.checked = false
			freeSceneBitmaps()
			DisableSceneRedraw()
			St = timestamp()
			Nm = GrpLaySet.count
			for i = 1 to Nm do
			(
				pr4 = (100/Nm as float)*(i-1)
				MtlCollConPl = 0
				MtlCon = (for a in sceneMaterials where (for b in ((if ifhide.checked == true then for d in (if ifselect.checked == true and selection.count != 0 then for c in GrpLaySet[i] where c.isselected == true collect c else GrpLaySet[i]) where d.ishidden == false collect d else GrpLaySet[i])) where b.material == a collect b).count != 0 collect a).count
				CollCheck GrpLaySet[i] ifhide.checked ifselect.checked theface.value pr4
			)
			Et = timestamp()
			format "耗时:%秒\n" ((Et-St)/1000.)
			EnableSceneRedraw()
			gc()
			freeSceneBitmaps()
			destroydialog TipSave
		)
		on stopb pressed do
			destroydialog TipSave
	)
	
	on ifgroup changed state do
	(
		if ifgroup.checked == true then
		(
			iflayer.enabled = false
			ifsubgroup.enabled = true
		)
		else
		(
			iflayer.enabled = true
			ifsubgroup.enabled = false
		)
	)
	
	on iflayer changed state do
	(
		if iflayer.checked == true then
			ifgroup.enabled = false
		else
			ifgroup.enabled = true
	)
	
	on UnLock pressed do
		EnableSceneRedraw()
	on Coll pressed do
	(
		UnMtl = standard()
		UnMtl.name = "UnMtlObj"
		if NoMtl.selected == "合并" do
			(for a in objects where a.material == undefined and (superclassof a == GeometryClass and classof a != Targetobject or (superclassof a == shape and a.render_renderable == true and a.render_displayRenderMesh == true)) collect a).material = UnMtl
		GrpLaySet = #()
		Type = (if iflayer.checked == true then 1 else if ifgroup.checked == true then if ifsubgroup.checked == true then 3 else 2 else 0)
		if Type == 1 then
		(
			for i = 1 to LayerManager.count do
			(
				GrpLaySet[i] = for a in objects where a.INodeLayerProperties.layer.name == (LayerManager.getLayer (i-1)).name collect a
			)
		)
		else if Tpye != 0 then
		(
			Grp = (for b in (for a in helpers where classof a == Dummy collect a) where isGroupHead b == true collect b)
			if Type == 3 then
			(
				for i = 1 to Grp.count do
					GrpLaySet[i] = for a in Grp[i] where a.parent == Grp[i] and isgrouphead a == false collect a
			)
			else
			(
				Grp = for a in Grp where try isGroupHead a.parent == false catch true collect a
				for i = 1 to Grp.count do
					GrpLaySet[i] = for a in Grp[i] where isgrouphead a == false Collect a
			)
			append GrpLaySet (for a in objects where isGroupMember a == false collect a)
		)
		else
		(
			GrpLaySet[1] = objects as array
		)
		destroydialog TipSave
		if save.checked == true then
			createdialog TipSave
		else
		(
			freeSceneBitmaps()
			DisableSceneRedraw()
			St = timestamp()
			Nm = GrpLaySet.count
			for i = 1 to Nm do
			(
				pr4 = (100/Nm as float)*(i-1)
				MtlCollConPl = 0
				MtlCon = (for a in sceneMaterials where (for b in ((if ifhide.checked == true then for d in (if ifselect.checked == true and selection.count != 0 then for c in GrpLaySet[i] where c.isselected == true collect c else GrpLaySet[i]) where d.ishidden == false collect d else GrpLaySet[i])) where b.material == a collect b).count != 0 collect a).count
				CollCheck GrpLaySet[i] ifhide.checked ifselect.checked theface.value pr4
			)
			Et = timestamp()
			format "耗时:%秒\n" ((Et-St)/1000.)
			EnableSceneRedraw()
			gc()
			freeSceneBitmaps()
		)
	)
)


----------------------------------------丢失UV

rollout FindMissUv "选择丢失UV的物体 (U)"
(
	fn MissUvw Num:1 =
	(
		meshop_getMapSupport = meshop.getMapSupport
		MissUv = for a in geometry where meshop_getMapSupport a.mesh Num == false collect a
		Select MissUv
	)
	spinner UvChn "查找UV通道" range:[1,99999999,1] type:#integer width:80
	button Find "选择"
	on Find pressed do
		MissUvw Num:UvChn.value
)

----------------------------------------rolloutfloater

if newR != undefined do closerolloutfloater newR
newR = newrolloutfloater "MAX保姆" 250 500 30 100

----------------------------------------工具

chk_ransel = true
chk_colorsel = true
chk_bad_elem_sel = true
chk_cam_sel = true
chk_bitmap_sel = true
chk_SelectIns = true
chk_SelectEmp = true

chk_ran = true
chk_transzero = true
chk_transPivot = true
chk_mirtran = true

chk_insobj = true
chk_poscopy = true
chk_batlookat = true
chk_pathsurface = true
chk_vis_change = true
chk_LightTools = true
chk_camTools = true
chk_GroupTools = true
chk_LostMesh = true

chk_seledge = true
chk_dfspline = true
chk_CGSplitroll = true
chk_mirrorVerts = true

chk_del_material = true
chk_LostMtlObj = true
chk_MakeChannels = true
chk_CollByMtl = true

chk_FindMissUv = true

chk_taxis = true
chk_keychangedtools = true
chk_keyrantools = true

rollout maxtools "★---------- 工具箱 ----------★"
(
	checkbutton seltools "选择工具" width:55 height:20 pos:[5,5] tooltip:"选择工具"
	checkbutton transformtools "坐标工具" width:55 height:20 pos:[62,5] tooltip:"坐标工具"
	checkbutton scenetools "场景编辑" width:55 height:20 pos:[119,5] tooltip:"场景编辑"
	checkbutton objtools "物体编辑" width:55 height:20 pos:[176,5] tooltip:"物体编辑"
	checkbutton materialtools "材质工具" width:55 height:20 pos:[5,28] tooltip:"材质工具"
	checkbutton uvwtools "UVW工具" width:55 height:20 pos:[62,28] tooltip:"UVW工具"
	checkbutton animationtools "动画工具" width:55 height:20 pos:[119,28] tooltip:"动画工具"
	checkbutton particletools "粒子工具" width:55 height:20 pos:[176,28] tooltip:"粒子工具"
	label toolstips "PS: 右击按钮可过滤选择"
	
	fn Destroyfilter =
	(
		DestroyDialog maxtools.seltoolsfilter
		DestroyDialog maxtools.transformtoolsfilter
		DestroyDialog maxtools.scenetoolsfilter
		DestroyDialog maxtools.objtoolsfilter
		DestroyDialog maxtools.materialtoolsfilter
		DestroyDialog maxtools.uvwtoolsfilter
		DestroyDialog maxtools.animationtoolsfilter
	)

-------选择工具
	fn seltoolson =
	(
		if chk_ransel == true do
			addrollout ransel newR rolledUp:on
		if chk_colorsel == true do
			addrollout colorsel newR rolledUp:on
		if chk_bad_elem_sel == true do
			addrollout bad_elem_sel newR rolledUp:on
		if chk_cam_sel == true do
			addrollout cam_sel newR rolledUp:on
		if chk_bitmap_sel == true do
			addrollout bitmap_sel newR rolledUp:on
		if chk_SelectIns == true do
			addrollout SelectIns newR rolledUp:on
		if chk_SelectEmp == true do
			addrollout SelectEmp newR rolledUp:on
	)
	fn seltoolsoff =
	(
		removeRollout ransel newR
		removerollout colorsel newR
		removerollout bad_elem_sel newR
		removerollout cam_sel newR
		removerollout bitmap_sel newR
		removerollout SelectIns newR
		removerollout SelectEmp newR
	)
	rollout seltoolsfilter "选择工具"
	(
		button st_all "全选" pos:[5,5]
		button st_none "全不选" pos:[55,5]
		checkbox st_ran "随机选择" checked:chk_ransel
		checkbox st_color "按线框颜色选择" checked:chk_colorsel
		checkbox st_bad_elem "极点/多边面 选择" checked:chk_bad_elem_sel
		checkbox st_cam "选择看不到的物体" checked:chk_cam_sel 
		checkbox st_bitmap "按位图灰度拾取点" checked:chk_bitmap_sel
		checkbox st_SelectIns "选中实例物体" checked:chk_SelectIns
		checkbox st_SelectEmp "选中空物体" checked:chk_SelectEmp
		button donechange "确定"
		on st_all pressed do
			st_ran.checked = st_color.checked = st_bad_elem.checked = st_cam.checked = st_bitmap.checked = st_SelectIns.checked = st_SelectEmp.checked = chk_ransel = chk_colorsel = chk_bad_elem_sel = chk_cam_sel = chk_bitmap_sel = chk_SelectIns = chk_SelectEmp = true
		on st_none pressed do
			st_ran.checked = st_color.checked = st_bad_elem.checked = st_cam.checked = st_bitmap.checked = st_SelectIns.checked = st_SelectEmp.checked = chk_ransel = chk_colorsel = chk_bad_elem_sel = chk_cam_sel = chk_bitmap_sel = chk_SelectIns = chk_SelectEmp = false
		on donechange pressed do
		(
			if st_ran.checked == true then
				chk_ransel = true
			else
				chk_ransel = false
			if st_color.checked == true then
				chk_colorsel = true
			else
				chk_colorsel = false
			if st_bad_elem.checked == true then
				chk_bad_elem_sel = true
			else
				chk_bad_elem_sel = false
			if st_cam.checked == true then
				chk_cam_sel = true
			else
				chk_cam_sel = false
			if st_bitmap.checked == true then
				chk_bitmap_sel = true
			else
				chk_bitmap_sel = false
			if st_SelectIns.checked == true then
				chk_SelectIns = true
			else
				chk_SelectIns = false
			if st_SelectEmp.checked == true then
				chk_SelectEmp = true
			else
				chk_SelectEmp = false
			DestroyDialog seltoolsfilter
			seltoolsoff()
			if seltools.checked == true then
			(
				seltoolson()
			)
		)
	)
	
	on seltools changed state do
	(
		try
			Destroyfilter()
		catch()
		if seltools.checked == true then
		(
			seltoolson()
		)
		else
		(
			seltoolsoff()
		)
	)
	
	on seltools rightclick do
	(
		try
			DestroyDialog maxtools.seltoolsfilter
		catch()
		createdialog seltoolsfilter pos:mouse.screenpos
	)

-------坐标工具
	fn transformtoolson =
	(
		if chk_ran == true do
			addrollout ran newR rolledUp:on
		if chk_transzero == true do
			addrollout transzero newR rolledUp:on
		if chk_transPivot == true do
			addrollout transPivot newR rolledUp:on
		if chk_mirtran == true do
			addrollout mirtran newR rolledUp:on
	)
	fn transformtoolsoff =
	(
		removeRollout ran newR
		removerollout transzero newR
		removerollout transPivot newR
		removerollout mirtran newR
	)
	rollout transformtoolsfilter "坐标工具"
	(
		button st_all "全选" pos:[5,5]
		button st_none "全不选" pos:[55,5]
		checkbox st_ran "随机 移动/旋转/缩放" checked:chk_ran
		checkbox st_zero "坐标复位" checked:chk_transzero
		checkbox st_pivot "变换轴心" checked:chk_transPivot
		checkbox st_mir "镜像坐标" checked:chk_mirtran
		button donechange "确定"
		on st_all pressed do
			st_ran.checked = st_zero.checked = st_pivot.checked = st_mir.checked = chk_ran = chk_transzero = chk_transPivot = chk_mirtran = true
		on st_none pressed do
			st_ran.checked = st_zero.checked = st_pivot.checked = st_mir.checked = chk_ran = chk_transzero = chk_transPivot = chk_mirtran = false
		on donechange pressed do
		(
			if st_ran.checked == true then
				chk_ran = true
			else
				chk_ran = false
			if st_zero.checked == true then
				chk_transzero = true
			else
				chk_transzero = false
			if st_pivot.checked == true then
				chk_transPivot = true
			else
				chk_transPivot = false
			if st_mir.checked == true then
				chk_mirtran = true
			else
				chk_mirtran = false
			DestroyDialog transformtoolsfilter
			transformtoolsoff()
			if transformtools.checked == true then
			(
				transformtoolson()
			)
		)
	)
	
	on transformtools changed state do
	(
		try
			Destroyfilter()
		catch()
		if transformtools.checked == true then
		(
			transformtoolson()
		)
		else
		(
			transformtoolsoff()
		)
	)
	
	on transformtools rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog transformtoolsfilter pos:mouse.screenpos
	)

-------场景编辑
	fn scenetoolson =
	(
		if chk_insobj == true do
			addrollout insobj newR rolledUp:on
		if chk_poscopy == true do
			addrollout poscopy newR rolledUp:on
		if chk_batlookat == true do
			addrollout batlookat newR rolledUp:on
		if chk_pathsurface == true do
			addrollout pathsurface newR rolledUp:on
		if chk_vis_change == true do
			addrollout vis_change newR rolledUp:on
		if chk_LightTools == true do
			addrollout LightTools newR rolledUp:on
		if chk_camTools == true do
			addrollout camTools newR rolledUp:on
		if chk_GroupTools == true do
			addrollout GroupTools newR rolledUp:on
		if chk_LostMesh == true do
			addrollout LostMesh newR rolledUp:on
	)
	fn scenetoolsoff =
	(
		removeRollout insobj newR
		removerollout poscopy newR
		removerollout batlookat newR
		removerollout pathsurface newR
		removerollout vis_change newR
		removerollout LightTools newR
		removerollout camTools newR
		removerollout GroupTools newR
		removerollout LostMesh newR
	)
	rollout scenetoolsfilter "场景编辑工具"
	(
		button st_all "全选" pos:[5,5]
		button st_none "全不选" pos:[55,5]
		checkbox st_insobj "关联物体" checked:chk_insobj
		checkbox st_poscopy "定点复制" checked:chk_poscopy
		checkbox st_batlookat "批量LookAt" checked:chk_batlookat
		checkbox st_pathsurface "约束到物体表面" checked:chk_pathsurface
		checkbox st_vis_change "更改可见性" checked:chk_vis_change
		checkbox st_LightTools "灯光工具" checked:chk_LightTools
		checkbox st_camTools "摄像机工具" checked:chk_camTools
		checkbox st_GroupTools "群组工具" checked:chk_GroupTools
		checkbox st_LostMesh "寻找丢失代理" checked:chk_LostMesh
		button donechange "确定"
		on st_all pressed do
			st_insobj.checked = st_poscopy.checked = st_batlookat.checked = st_pathsurface.checked = st_vis_change.checked = st_LightTools.checked = st_camTools.checked = st_GroupTools.checked = st_LostMesh.checked = chk_insobj = chk_poscopy = chk_batlookat = chk_pathsurface = chk_vis_change = chk_LightTools = chk_camTools = chk_GroupTools = true
		on st_none pressed do
			st_insobj.checked = st_poscopy.checked = st_batlookat.checked = st_pathsurface.checked = st_vis_change.checked = st_LightTools.checked = st_camTools.checked = st_GroupTools.checked = st_LostMesh.checked = chk_insobj = chk_poscopy = chk_batlookat = chk_pathsurface = chk_vis_change = chk_LightTools = chk_camTools = chk_GroupTools = false
		on donechange pressed do
		(
			if st_insobj.checked == true then
				chk_insobj = true
			else
				chk_insobj = false
			if st_poscopy.checked == true then
				chk_poscopy = true
			else
				chk_poscopy = false
			if st_batlookat.checked == true then
				chk_batlookat = true
			else
				chk_batlookat = false
			if st_pathsurface.checked == true then
				chk_pathsurface = true
			else
				chk_pathsurface = false
			if st_vis_change.checked == true then
				chk_vis_change = true
			else
				chk_vis_change = false
			if st_LightTools.checked == true then
				chk_LightTools = true
			else
				chk_LightTools = false
			if st_camTools.checked == true then
				chk_camTools = true
			else
				chk_camTools = false
			if st_GroupTools.checked == true then
				chk_GroupTools = true
			else
				chk_GroupTools = false
			if st_LostMesh.checked == true then
				chk_LostMesh = true
			else
				chk_LostMesh = false
			DestroyDialog scenetoolsfilter
			scenetoolsoff()
			if scenetools.checked == true then
			(
				scenetoolson()
			)
		)
	)
	
	on scenetools changed state do
	(
		try
			Destroyfilter()
		catch()
		if scenetools.checked == true then
		(
			scenetoolson()
		)
		else
		(
			scenetoolsoff()
		)
	)
	
	on scenetools rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog scenetoolsfilter pos:mouse.screenpos
	)

-------物体编辑
	fn objtoolson =
	(
		if chk_seledge == true do
			addrollout seledge newR rolledUp:on
		if chk_dfspline == true do
			addrollout dfspline newR rolledUp:on
		if chk_CGSplitroll == true do
			addrollout CGSplitroll newR rolledUp:on
		if chk_mirrorVerts == true do
			addrollout mirrorVerts newR rolledUp:on
	)
	fn objtoolsoff =
	(
		removeRollout seledge newR
		removerollout dfspline newR
		removerollout CGSplitroll newR
		removerollout mirrorVerts newR
	)
	rollout objtoolsfilter "物体编辑工具"
	(
		button st_all "全选" pos:[5,5]
		button st_none "全不选" pos:[55,5]
		checkbox st_seledge "隔行 Ring/Loop" checked:chk_seledge
		checkbox st_dfspline "简化样条线" checked:chk_dfspline
		checkbox st_CGSplitroll "物体切割" checked:chk_CGSplitroll
		checkbox st_mirrorVerts "自身镜像" checked:chk_mirrorVerts
		button donechange "确定"
		on st_all pressed do
			st_seledge.checked = st_dfspline.checked = st_CGSplitroll.checked = st_mirrorVerts.checked = chk_seledge = chk_dfspline = chk_CGSplitroll = chk_mirrorVerts = true
		on st_none pressed do
			st_seledge.checked = st_dfspline.checked = st_CGSplitroll.checked = st_mirrorVerts.checked = chk_seledge = chk_dfspline = chk_CGSplitroll = chk_mirrorVerts = false
		on donechange pressed do
		(
			if st_seledge.checked == true then
				chk_seledge = true
			else
				chk_seledge = false
			if st_dfspline.checked == true then
				chk_dfspline = true
			else
				chk_dfspline = false
			if st_CGSplitroll.checked == true then
				chk_CGSplitroll = true
			else
				chk_CGSplitroll = false
			if st_mirrorVerts.checked == true then
				chk_mirrorVerts = true
			else
				chk_mirrorVerts = false
			DestroyDialog objtoolsfilter
			objtoolsoff()
			if objtools.checked == true then
			(
				objtoolson()
			)
		)
	)
	
	on objtools changed state do
	(
		try
			Destroyfilter()
		catch()
		if objtools.checked == true then
		(
			objtoolson()
		)
		else
		(
			objtoolsoff()
		)
	)
	
	on objtools rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog objtoolsfilter pos:mouse.screenpos
	)

-------材质工具
	fn materialtoolson =
	(
		if chk_del_material == true do
			addrollout del_material newR rolledUp:on
		if chk_LostMtlObj == true do
			addrollout LostMtlObj newR rolledUp:on
		if chk_MakeChannels == true do
			addrollout MakeChannels newR rolledUp:on
		if chk_CollByMtl == true do
			addrollout CollByMtl newR rolledUp:on
	)
	fn materialtoolsoff =
	(
		removeRollout del_material newR
		removeRollout LostMtlObj newR
		removeRollout MakeChannels newR
		removeRollout CollByMtl newR
	)
	rollout materialtoolsfilter "材质工具"
	(
		button st_all "全选" pos:[5,5]
		button st_none "全不选" pos:[55,5]
		checkbox st_del_material "一键材质" checked:chk_del_material
		checkbox st_LostMtlObj "寻找丢失贴图" checked:chk_LostMtlObj
		checkbox st_MakeChannels "材质通道" checked:chk_MakeChannels
		checkbox st_CollByMtl "按材质塌陷" checked:chk_CollByMtl
		button donechange "确定"
		on st_all pressed do
			st_del_material.checked = st_LostMtlObj.checked = st_MakeChannels.checked = st_CollByMtl.checked = chk_del_material = chk_LostMtlObj = chk_MakeChannels = chk_CollByMtl = true
		on st_none pressed do
			st_del_material.checked = st_LostMtlObj.checked = st_MakeChannels.checked = st_CollByMtl.checked = chk_del_material = chk_LostMtlObj = chk_MakeChannels = chk_CollByMtl =false
		on donechange pressed do
		(
			if st_del_material.checked == true then
				chk_del_material = true
			else
				chk_del_material = false
			if st_LostMtlObj.checked == true then
				chk_LostMtlObj = true
			else
				chk_LostMtlObj = false
			if st_MakeChannels.checked == true then
				chk_MakeChannels = true
			else
				chk_MakeChannels = false
			if st_CollByMtl.checked == true then
				chk_CollByMtl = true
			else
				chk_CollByMtl = false
			DestroyDialog materialtoolsfilter
			materialtoolsoff()
			if materialtools.checked == true then
			(
				materialtoolson()
			)
		)
	)
	
	on materialtools changed state do
	(
		try
			Destroyfilter()
		catch()
		if materialtools.checked == true then
		(
			materialtoolson()
		)
		else
		(
			materialtoolsoff()
		)
	)
	
	on materialtools rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog materialtoolsfilter pos:mouse.screenpos
	)
	
-------UVW工具


	fn uvwtoolson =
	(
		if chk_FindMissUv == true do
			addrollout FindMissUv newR rolledUp:on
	)
	fn uvwtoolsoff =
	(
		removeRollout FindMissUv newR
	)
	rollout uvwtoolsfilter "UVW工具"
	(
		button st_all "全选" pos:[5,5]
		button st_none "全不选" pos:[55,5]
		checkbox st_FindMissUv "选择丢失UV" checked:chk_FindMissUv
		button donechange "确定"
		on st_all pressed do
			st_FindMissUv.checked = chk_FindMissUv = true
		on st_none pressed do
			st_FindMissUv.checked = chk_FindMissUv = false
		on donechange pressed do
		(
			if st_FindMissUv.checked == true then
				chk_FindMissUv = true
			else
				chk_FindMissUv = false
			DestroyDialog uvwtoolsfilter
			uvwtoolsoff()
			if uvwtools.checked == true then
			(
				uvwtoolson()
			)
		)
	)
	
	on uvwtools changed state do
	(
		try
			Destroyfilter()
		catch()
		if uvwtools.checked == true then
		(
			uvwtoolson()
		)
		else
		(
			uvwtoolsoff()
		)
	)
	
	on uvwtools rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog uvwtoolsfilter pos:mouse.screenpos
	)
	
-------动画工具
	fn animationtoolson =
	(
		if chk_taxis == true do
			addrollout taxis newR rolledUp:on
		if chk_keychangedtools == true do
			addrollout keychangedtools newR rolledUp:on
		if chk_keyrantools == true do
			addrollout keyrantools newR rolledUp:on
	)
	fn animationtoolsoff =
	(
		removeRollout taxis newR
		removerollout keychangedtools newR
		removerollout keyrantools newR
	)
	rollout animationtoolsfilter "动画工具"
	(
		button st_all "全选" pos:[5,5]
		button st_none "全不选" pos:[55,5]
		checkbox st_taxis "坐标排序" checked:chk_taxis
		checkbox st_keychangedtools "关键帧转换" checked:chk_keychangedtools
		checkbox st_keyrantools "随机移动关键帧" checked:chk_keyrantools
		button donechange "确定"
		on st_all pressed do
			st_taxis.checked = st_keychangedtools.checked = st_keyrantools.checked = chk_taxis = chk_keychangedtools = chk_keyrantools = true
		on st_none pressed do
			st_taxis.checked = st_keychangedtools.checked = st_keyrantools.checked = chk_taxis = chk_keychangedtools = chk_keyrantools = false
		on donechange pressed do
		(
			if st_taxis.checked == true then
				chk_taxis = true
			else
				chk_taxis = false
			if st_keychangedtools.checked == true then
				chk_keychangedtools = true
			else
				chk_keychangedtools = false
			if st_keyrantools.checked == true then
				chk_keyrantools = true
			else
				chk_keyrantools = false
			DestroyDialog animationtoolsfilter
			animationtoolsoff()
			if animationtools.checked == true then
			(
				animationtoolson()
			)
		)
	)
	
	on animationtools changed state do
	(
		try
			Destroyfilter()
		catch()
		if animationtools.checked == true then
		(
			animationtoolson()
		)
		else
		(
			animationtoolsoff()
		)
	)
	
	on animationtools rightclick do
	(
		try
			Destroyfilter()
		catch()
		createdialog animationtoolsfilter pos:mouse.screenpos
	)

-------粒子工具
	on particletools changed state do
	(
		messagebox "该功能开发中.."
		particletools.checked = false
	)
)


addrollout ab newR --rolledUP:on
addrollout maxtools newR