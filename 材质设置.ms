rollout RenderSettings "材质设置" width:216 height:325
(
	button 'btn1' "JPG材质球自动设置" pos:[27,45] width:160 height:25 align:#left
	button 'btn2' "PNG材质球设置(单独选择)" pos:[27,75] width:160 height:25 align:#left
	groupBox 'grp9' "材质设置" pos:[18,26] width:179 height:149 align:#left	
	label 'lbl4' "材质路径：" pos:[27,102] width:63 height:22 align:#left	
	editText 'edt5' "" pos:[24,118] width:165 height:48 align:#left
	
	on btn1 pressed  do   ------设置材质自发光，跟双面
	(
		for i=1 to scenematerials.count do
		(
			
			k = scenematerials[i] as string
			if k.count>18 then
            (
                kk = substring k  1 18    --获得材质属性子字符串，用于判断是否是“多维材质”
            )
			
			if kk == "#Multi/Sub-Object:" then
			(
				for j=1 to  scenematerials[i].MaterialList.count do
				(
					scenematerials[i].materialList[j].selfIllumAmount = 100   ----自发光0
					scenematerials[i].materialList[j].twoSided  = true   ----双面
					door_file = edt5.text+"\\"+scenematerials[i].materialList[j].name+".jpg"
					print(edt5.text+scenematerials[i].materialList[j].name+".jpg")
					scenematerials[i].materialList[j].diffuseMap =Bitmaptexture fileName:door_file
					scenematerials[i].materialList[j].showInViewport = on
				)
			)
			else
			(
				scenematerials[i].selfIllumAmount = 100    ----自发光100
				scenematerials[i].twoSided  = true       ----双面
				door_file =	edt5.text+"\\"+scenematerials[i].name+".jpg"
				print(edt5.text+scenematerials[i].name+".jpg")	
				scenematerials[i].diffuseMap =Bitmaptexture fileName:door_file
				scenematerials[i].showInViewport = on
			)
		)
	
	)
	on btn2 pressed  do
	(
		
		if selection.count > 0 then
		(
			s = selection as array
			for i=1 to s.count do
			(

				k = s[i].material as string
				if k.count>18 then
				(
					kk = substring k  1 18    --获得材质属性子字符串，用于判断是否是“多维材质”
				)
				if kk == "#Multi/Sub-Object:" then
				(
					break
				)
				else
				(
					door_file =	edt5.text+"\\"+s[i].material.name+".png"
					print(door_file)
					s[i].material.diffuseMap = Bitmaptexture fileName:door_file	
					s[i].material.opacityMap = Bitmaptexture fileName:door_file	
					s[i].material.opacityMap.monoOutput = 1
					s[i].material.showInViewport = on
					s[i].material.selfIllumAmount = 100 
					s[i].material.twoSided  = true       
					
				)
			
			)
			
		)
		else
		(
		messagebox ("请先选择一个物体")
		)
	)

	
)
createdialog RenderSettings