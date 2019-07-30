--------------------------Ver.  1.1     Author : Si-Chung Yuan 2017.9 --------------------------------------------------------------
(
vposCA = attributes vipos
(
	parameters main 
	(
	 	vpos 		type:#point3Tab tabSizeVariable:true animatable:false
	)	

)

sprboneCA = attributes sprbTM
(
	parameters main
	(
		boneTM	type:#matrix3
	)	

)
local framestart, frameEnd
local simbones = #(), bone_TM = #(), preTimebone_TM = #(), prePos = #(), bcnt = #()
rollout springMagic_rol "Spring Magic V1.1" width:230
(
	spinner delaysp "Spring" type:#float scale:0.01 range:[0.01,1,0.3] align:#left height:20 width:60
	spinner scaleMotion "Scale Motion" type:#float scale:0.01 range:[0,999,1] align:#right height:20 width:75 offset:[5,-25] 
	spinner subs "Subs" type:#integer range:[1,30,1] align:#left height:20 width:60
	spinner upspring "XSpring" type:#float scale:0.01 range:[0.1,1,0.3] align:#right height:20 width:70 offset:[5,-25] 
	spinner bnum "Bones num" type:#integer range:[0,1000,50] align:#left height:20 width:60
	checkBox loops "Loops" type:#integer range:[0,100,0] align:#right height:20 width:50 offset:[5,-25]
	

	group "Bone Pose"
	(
	button pasteRp "Paste" toolTip:"Select first bone" align:#left height:20 width:50
	button setRp "Set" toolTip:"Select first bone" align:#left height:20 width:50 offset:[55,-25] 
	button stretch "straight" align:#left height:20 width:50 offset:[110,-25] 
	)
	group "KeyRange"
	(
	radiobuttons a1 labels:#("Active", "Custom") align:#left width:80 height:20 offset:[-5,0]
	spinner aframeStart type:#integer align:#left width:40 height:20 range:[-10000,100000,1] offset:[110,-25] 
	spinner aframeEnd "To" type:#integer align:#left width:45 height:20 range:[0,100000,10] offset:[155,-25] 

	)

	group "Apply"
	(
	button applybone "Bake" toolTip:"Select first bone" align:#left height:20 width:60 offset:[0,-0] 
	progressbar doit_prog color:red align:#left height:15 width:120 offset:[90,-20] 
	)
	label lab_aut "Author:  Si-Chung Yuan" align:#left
	
	fn setStartEndFrame = (
		if a1.state == 1 then (
			framestart = animationRange.start-1f
			frameEnd = animationRange.end-1f
		) else (
			framestart = aframeStart.value-1f as time
			frameEnd = aframeEnd.value-1f as time
		)
	)

	fn getBoneChain bone = (
		
		local bonechain = #()
		local bonetype = classof bone
		local num = 1

		if bone.parent == undefined do ( messageBox (((bone.name as string)+"must have parent!")) ; continue)

		local parnode = bone.parent
		while bone!=undefined do (
			bonechain[num] = bone
			childfind = false
			if bone.children.count == 0 or num>bnum.value then exit
			else (
				for c in bone.children do
					if  classof c == bonetype or classof c == Dummy then (bone = c;num += 1 ;childfind = true;exit)
					else continue
				if childfind == false do bone = undefined
			)
		)----end while
		--format "bonechain = %\n" bonechain
		append simBones bonechain

		local pTM = parnode.transform
		local preTM = #()
		local bTM = #()

		for j in 1 to bonechain.count do (
			if classof bonechain[j] == Dummy and classof bonechain[j].controller == BipSlave_Control then(
				for i = 1 to (custAttributes.count bonechain[j]) do (
					a = CustAttributes.get bonechain[j] i
					if isProperty a "boneTM" do (
						CustAttributes.delete bonechain[j] i
						isDelete  = true
					)
				)
			)else
				if not isProperty bonechain[j] "boneTM" then 
				(
					CustAttributes.add bonechain[j] sprboneCA
					bonechain[j].boneTM = bonechain[j].transform * inverse bonechain[j].parent.transform
				)
			
			if isProperty bonechain[j] "boneTM" then
				append bTM bonechain[j].boneTM
			else
				append bTM (bonechain[j].transform * inverse bonechain[j].parent.transform)
			
			append preTM bonechain[j].transform
			
		)	
		if bonechain.count > 1 then
			append prePos bonechain[2].transform.pos
		else (
			bbox = nodeGetBoundingBox bonechain[1] bonechain[1].transform
			append prePos (bonechain[1].transform.pos + bonechain[1].transform.row1 * bbox[2].x)
		)
		
		-------------- 	Add End  -----------------------------------------------------------------------------------------
		if bnum.value >= bonechain.count do (
			if bonechain.count > 1 then (
				ltm = copy bTM[bTM.count]
				append bTM ltm
			)else (
				ltm = matrix3 1
				bbox = nodeGetBoundingBox bonechain[1] bonechain[1].transform
				ltm.pos = [bbox[2].x, 0 ,0]
				append bTM ltm
			)
			tm = ltm * bonechain[preTM.count].transform
			append preTM tm
		)
		
		if classof bonechain[bonechain.count] == Dummy and \
			classof bonechain[bonechain.count].controller == BipSlave_Control do
			bonechain.count = bonechain.count - 1
		if bonechain.count > bnum.value do bonechain.count = bnum.value

		append bcnt bTM.count
		----------------------------------------------------------------------------------------------------------
		
		append preTimebone_TM preTM
		append bone_TM bTM
	format "bTM.count=% preTM.count=% bonechain.count=%\n" bTM.count preTM.count bonechain.count	
	)
	on applybone pressed do with undo on (
		
	simbones=#()

	setStartEndFrame()

	-------------- Clear  array
	simBones = #()
	bone_TM = #()
	preTimebone_TM = #()
	prePos = #()
	bcnt = #()
	
	delay = delaysp.value

	for object in selection do 
		if superClassOf object == GeometryClass do 
			at time frameStart getBoneChain object
	
	
-----------------------Start  to  calculate---------------
	loopsv = if loops.checked then 2 else 1 
	subframe = 1f/subs.value
	
	pv = 100.0/ loopsv / (frameEnd - framestart + 1)
	doit_prog.value = 0.0
	totalVal = 0
	
	for L = 1 to loopsv do (
		
		for t = framestart to frameEnd do (
			if keyboard.escPressed then exit
			--slidertime = tf			------Play
			currtTime = t

			for sf in 1 to subs.value do (
				currtTime += subframe

				for i in 1 to simbones.count do (
					currentPTM = at time currtTime simbones[i][1].parent.transform
					
					for j in 1 to simbones[i].count do (
						
						targetboneTM = bone_TM[i][j] * currentPTM
						currentPos  = if j==1 then prePos[i] else preTimebone_TM[i][j+1].pos
						tpos = targetboneTM.pos
							
						----------Twist X -------------
						angX = acos(dot (normalize preTimebone_TM[i][j].row1) (normalize targetboneTM.row1))
						newTM1 = copy preTimebone_TM[i][j]
						
						vt1 = normalize (cross preTimebone_TM[i][j].row1 targetboneTM.row1)
							
						if angX >0.001 do rotate newTM1 (quat angX -vt1) 
					
						newTM1.pos = tpos

						angY1 = acos(dot (normalize newTM1[2]) (normalize targetboneTM.row2))	
						ssvt = cross (normalize newTM1[2]) (normalize targetboneTM.row2)

						xaxisdelay = (upspring.value + ((simbones[i].count-j)/(simbones[i].count)*(1.0-upspring.value)) )
						angY1 = angY1 * xaxisdelay
						if dot ssvt targetboneTM.row1 >0 do angY1 = -angY1
						if abs angY1 >0.001 do rotate newTM1 (quat angY1 targetboneTM.row1) 
						newTM1.pos = tpos
						targetboneTM = copy newTM1
						-----------------------------------------------------------------------------------------------------------------------------------------	
						
						tvector = normalize targetboneTM.row1
						cvector = normalize (currentPos - tpos)
						vt = normalize (cross cvector tvector)
						angel = acos(dot (normalize cvector) (normalize tvector))
						
						angel *= (1.0-delay)
						sangel = angel 
						if j == 1 do angel *= scaleMotion.value
						ttm = copy targetboneTM
						
						rotate targetboneTM (quat angel vt)
						if j == 1 do rotate ttm (quat sangel vt)
						targetboneTM.pos = ttm.pos = tpos

						if L == loopsv and sf == subs.value do (

							animate on at time (t + 1f)
							(
								if classof simbones[i][j].controller == BipSlave_Control and classof simbones[i][j] != Dummy then
									biped.setTransform simbones[i][j] #rotation targetboneTM.rotation true
								else if classof simbones[i][j] == CATBone then
									simbones[i][j].transform = copy targetboneTM
								else 
									simbones[i][j].rotation.controller.value = targetboneTM.rotation * inverse currentPTM.rotation
							)
						)

						currentPTM = copy targetboneTM
						preTimebone_TM[i][j] = copy targetboneTM
						
						if j == 1 do 
							prePos[i] = bone_TM[i][j+1].pos * ttm


						preTimebone_TM[i][j+1].pos = bone_TM[i][j+1].pos * targetboneTM	
						

					)-----end for j	
				)----end for bones
			)
			totalVal += pv
			if totalVal >= 20.0 do (
				doit_prog.value += totalVal
				totalVal = 0.0
			)
		)----end for t
	)----end for Loops
	doit_prog.value = 100.0
	)
	on pasteRp pressed do (

	--	if selection.count == 0 do return root

		for bone in selection do (
			local bonetype = classof bone
			if superClassOf bone == shape do continue
			--if bonetype != Biped_Object do return root
			if bone.parent == undefined do return root
			local bones=#()
			local num = 1
			while bone!=undefined do (
				bones[num] = bone
				childfind = false
				if bone.children.count == 0 then exit
				else (
					for c in bone.children do
						if  classof c == bonetype or classof c == Dummy then (bone = c;num += 1 ;childfind = true;exit)
						else continue
					if childfind == false do bone = undefined
				)
			)----end while
			
			for b in bones do 
				if isProperty b "boneTM" do (
					animate on
					(
						if classof b == CATBone then (

							b.transform = b.boneTM * b.parent.transform

						) else if classof b == Biped_Object then biped.setTransform b #rotation (b.boneTM*b.parent.transform).rotation true
						else if classof b.controller != BipSlave_Control
							do b.rotation.controller.value = b.boneTM.rotation
					)
				)
		)----end for bone
	)

	on setRp pressed do (
	
		for obj in selection do (

			local objtype = classof obj
			if superClassOf obj != GeometryClass do continue
			if obj.parent == undefined do return root
			local bones=#()
			append bones obj
			
			while obj != undefined do (
				if keyboard.escPressed then exit
				isfind = false
				for c in obj.children do 
					if  classof c == objtype or classof c == Dummy then (
						append bones c
						obj = c
						isfind = true
						exit
					)else continue
				if not isfind do 
					obj = undefined
			)

			for b in bones do
				if classof b == objtype do (
					if not isProperty b "boneTM" do 
						CustAttributes.add b sprboneCA
				
					b.boneTM = b.transform*(inverse b.parent.transform)
				)
			
		)
	
	)
	on stretch pressed do with undo on (
		
		for bone in selection do (
			if bone.children.count == 0 do return root
			bone = bone.children[1]
			bonetype = classof bone
			if superClassOf bone == shape do continue
			--if bonetype != BoneGeometry and bonetype != Biped_Object do return root
			if bone.parent == undefined do return root
			local bones=#()
			local num = 1
			while bone!=undefined do (
				bones[num] = bone
				childfind = false
				if bone.children.count == 0 then exit
				else (
					for c in bone.children do
						if  classof c == bonetype or classof c == Dummy then (bone = c;num += 1 ;childfind = true;exit)
						else continue
					if childfind == false do bone = undefined
				)
			)----end while
			for b in bones do (
				if bonetype == Biped_Object then 
					biped.setTransform b #rotation b.parent.transform.rotation true
				else (
					c = copy b.parent.transform
					c.pos = b.transform.position
					b.transform = c
				)
			)
		)---end for bone
	)
	
	on realt changed state do with undo on (
	if state == true then startTool movevertex prompt:"Hello!"
	else stopTool movevertex

	)
	on springMagic_rol open do (
		aframestart.value = animationRange.start
		aframeEnd.value = animationRange.end
	)
)
createDialog springMagic_rol

)