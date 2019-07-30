rollout RenderSettings "渲染设置" width:216 height:325
(
	button 'btn1' "材质球自发光开100以及双面" pos:[27,45] width:160 height:25 align:#left
	button 'btn2' "统一设置材质路径" pos:[27,72] width:160 height:25 align:#left
	button 'btn3' "普通渲染设置" pos:[28,198] width:160 height:25 align:#left
	groupBox 'grp8' "渲染设置" pos:[5,2] width:203 height:314 align:#left
	groupBox 'grp9' "材质设置" pos:[18,26] width:179 height:149 align:#left
	groupBox 'grp10' "渲染设置" pos:[16,178] width:181 height:130 align:#left
	label 'lbl4' "材质路径：" pos:[27,102] width:63 height:22 align:#left
	label 'lbl5' "渲染输出路径：" pos:[27,228] width:87 height:22 align:#left
	editText 'edt5' "" pos:[24,118] width:165 height:48 align:#left
	editText 'edt6' "" pos:[23,245] width:165 height:48 align:#left
	
	
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
					scenematerials[i].materialList[j].selfIllumAmount = 100   ----自发光100
					scenematerials[i].materialList[j].twoSided  = true   ----双面
					
				)
			)
			else
			(
				scenematerials[i].selfIllumAmount = 100    ----自发光100
				scenematerials[i].twoSided  = true       ----双面
			)
		)
	
	)
	on btn2 pressed  do       ------------设置材质路径
	(
		ATSOps.SetPath edt5.text     
	)
	
	
	
	on btn3 pressed  do          ---------渲染设置（Default Scanline Renderer）
	(
		try renderers.current = RendererClass.classes[1]() catch()
		rendTimeType = 2
		renderWidth = 1920
		renderHeight  = 1080
		rendOutputFilename =  edt6.text
		rendSaveFile = true
	)
	
)
createdialog RenderSettings