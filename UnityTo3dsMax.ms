rollout ModelSettings "UnityTo3dsMax" width:386 height:344
(
	groupBox 'grp01' "模型处理" pos:[12,9] width:226 height:160 align:#left
	button 'Quadrify' "Quadrify All(三角面转四边面)" pos:[47,100] width:168 height:26 align:#left
	button 'VertexWeld' "顶点焊接" pos:[48,66] width:84 height:26 align:#left
	checkbox 'Quadrifychk' "Checkbox" pos:[29,111] width:11 height:14 align:#left
	checkbox 'VertexWeldchk' "Checkbox" pos:[28,73] width:12 height:13 align:#left
	spinner 'WeldValue' "" pos:[140,72] width:76 height:16 range:[0,1,0.001] align:#left
	button 'BatchProcessing' "一键批处理" pos:[46,133] width:168 height:26 align:#left
	groupBox 'grp02' "材质处理" pos:[12,178] width:226 height:153 align:#left
	button 'btn33' "Button" pos:[114,111] width:0 height:0 align:#left
	button 'btn1' "JPG材质球自动设置" pos:[45,198] width:168 height:26 align:#left
	button 'btn2' "PNG材质球设置（单独选择）" pos:[45,232] width:168 height:26 align:#left
	label 'lbl5' "材质路径" pos:[45,265] width:60 height:19 align:#left
	editText 'Pathedt' "" pos:[45,284] width:168 height:37 align:#left
	listBox 'Information' "选择模型" pos:[251,53] width:120 height:17 align:#left
	groupBox 'grp03' "信息反馈" pos:[243,10] width:136 height:320 align:#left
	button 'ClearInformation' "清除信息" pos:[308,29] width:61 height:26 align:#left
	button 'ConvertToPoly' "Convert To Editable Poly" pos:[47,33] width:168 height:26 align:#left
	checkbox 'ConvertToPolychk' "Checkbox" pos:[28,39] width:11 height:14 align:#left
	button 'U3dToMaxCamera' "U3d转MaxCamera" pos:[250,300] width:120 height:26 align:#left
	
	
	
----------------------U3d转MaxCamera---------------------------------------------------------
fn CreatU3DCamera =
(
	U3DCamera = ($Main_Camera*)[1]
	U3DCameraFOV = (filterString (filterString U3DCamera.name "(")[2]  ")")[1] as float
	MAXCamera = Freecamera  fovType:2
	MAXCamera.transform = U3DCamera.transform	
	MAXCamera.curFOV = U3DCameraFOV
	in coordsys local rotate MAXCamera (EulerAngles 0 180 0)

)
	
----------------------ConvertToPoly---------------------------------------------------------
	fn ConvToPoly = 
	(
		
		for i in selection do with undo on
		(
			try
				(
					---select i;
					macros.run "Modifier Stack" "Convert_to_Poly"
					
					tempitm =  ModelSettings.Information.items
					SomeError ="ConvToPoly成功" 
					Newitm = append tempitm SomeError 
					ModelSettings.Information.items = Newitm
			
				)
				catch 
				(
					--select i
					tempitm =  ModelSettings.Information.items
					SomeError =i.name+"ConvToPoly没有成功" 
					Newitm = append tempitm SomeError 
					ModelSettings.Information.items = Newitm
				)
			
		
		)	
		
	)
	
----------------------三角面转四边面---------------------------------------------------------	
	fn TriangleToQuadrify = 
	(

		arr = for s in selection collect s
		for i in arr do
		(
			try
				(
					select i;
					macros.run "Modifier Stack" "Convert_to_Poly"
					macros.run "PolyTools" "Quadrify"
					
					tempitm =  ModelSettings.Information.items
					SomeError ="Quadrify成功" 
					Newitm = append tempitm SomeError 
					ModelSettings.Information.items = Newitm
			
				)
				catch 
				(
					select i
					tempitm =  ModelSettings.Information.items
					SomeError =i.name+"Quadrify没有成功" 
					Newitm = append tempitm SomeError 
					ModelSettings.Information.items = Newitm
				)
			
		
		)		
		
	)
	
	----------------------顶点焊接---------------------------------------------------------	
	fn VWeld = 
	(
			arr = for s in selection collect s
			for i in arr do
			(
				try
				(
					i.weldThreshold = ModelSettings.WeldValue.value
					polyOp.weldVertsByThreshold i #{1..(i.GetNumVertices())};
			
					tempitm = ModelSettings.Information.items
					SomeError ="焊接顶点成功" 
					Newitm = append tempitm SomeError 
					ModelSettings.Information.items= Newitm
			
				)
				catch 
				(
					select i
					tempitm =  ModelSettings.Information.items
					 SomeError =i.name+"焊接顶点没有成功" 
					   Newitm = append tempitm SomeError 
					   ModelSettings.Information.items = Newitm
				)
			)

	)
-----------------------转Camera--------------------------------------------------------		
	on U3dToMaxCamera pressed do
	(		
		CreatU3DCamera()
	)
	-----------------------转poly--------------------------------------------------------		
	on ConvertToPoly pressed do
	(		
		ConvToPoly()
	)
	-----------------------三角面转四边面--------------------------------------------------------		
	on Quadrify pressed do
	(		
		TriangleToQuadrify()
	)
	-----------------------缝合点--------------------------------------------------------		
	on VertexWeld pressed do
	(		
		VWeld()
	)
	
	-----------------------一键批处理--------------------------------------------------------		
	on BatchProcessing pressed do
	(
		if ConvertToPolychk.checked do ConvToPoly()
		if VertexWeldchk.checked do VWeld()
		if Quadrifychk.checked do TriangleToQuadrify()
		
		
	)

	----------------------JPG材质球自动设置---------------------------------------------------------	
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
					door_file = Pathedt.text+"\\"+scenematerials[i].materialList[j].name+".jpg"
					print(Pathedt.text+scenematerials[i].materialList[j].name+".jpg")
					scenematerials[i].materialList[j].diffuseMap =Bitmaptexture fileName:door_file
					scenematerials[i].materialList[j].showInViewport = on
				)
			)
			else
			(
				scenematerials[i].selfIllumAmount = 100    ----自发光100
				scenematerials[i].twoSided  = true       ----双面
				door_file =	Pathedt.text+"\\"+scenematerials[i].name+".jpg"
				print(Pathedt.text+scenematerials[i].name+".jpg")	
				scenematerials[i].diffuseMap =Bitmaptexture fileName:door_file
				scenematerials[i].showInViewport = on
			)
		)
	
	)
	----------------------PNG材质球设置（单独选择）---------------------------------------------------------
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
					door_file =	Pathedt.text+"\\"+s[i].material.name+".png"
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
	-----------------------清除信息--------------------------------------------------------		
	on ClearInformation pressed  do
		ModelSettings.Information.items = #("")
	
)
createdialog ModelSettings