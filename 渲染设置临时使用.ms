rollout RenderSettings "设置材质" width:216 height:200
(
	groupBox 'grp1' "材质设置" pos:[18,20] width:179 height:80 align:#left	
	button 'btn1' "材质球设置" pos:[27,42] width:160 height:25 align:#left	
	spinner 'WeldValue' "自发光数值" pos:[27,76] width:67 height:16 range:[0,100,0] scale:1 align:#left
	
	groupBox 'grp2' "材质设置说明" pos:[18,110] width:179 height:80 align:#left	
	label 'label' "批量设置材质球自发光===双面===diffuseMap贴图模式===OpacityMap贴图模式" pos:[25,130] width:165 height:50 align:#left	
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
					scenematerials[i].materialList[j].selfIllumAmount = RenderSettings.WeldValue.value   ----自发光
					scenematerials[i].materialList[j].twoSided  = true   ----双面
					if scenematerials[i].materialList[j].diffuseMapEnable == true then
					(
						
						scenematerials[i].materialList[j].diffuseMap.apply = false	
						scenematerials[i].materialList[j].diffuseMap.filtering = 0
						scenematerials[i].materialList[j].diffuseMap.monoOutput = 0
						scenematerials[i].materialList[j].diffuseMap.rgbOutput = 0
						scenematerials[i].materialList[j].diffuseMap.alphaSource = 2

					)
					if scenematerials[i].materialList[j].opacityMapEnable == true then
					(
						scenematerials[i].materialList[j].OpacityMap.apply = true	
						scenematerials[i].materialList[j].OpacityMap.filtering = 0
						scenematerials[i].materialList[j].OpacityMap.monoOutput = 1
						scenematerials[i].materialList[j].OpacityMap.rgbOutput = 1
						scenematerials[i].materialList[j].OpacityMap.alphaSource = 0
					
					)
				)
			)
			else
			(
				scenematerials[i].selfIllumAmount = RenderSettings.WeldValue.value    ----自发光
				scenematerials[i].twoSided  = true       ----双面
				if	scenematerials[i].diffuseMapEnable == true then
				(
					scenematerials[i].diffuseMap.apply = false	
					scenematerials[i].diffuseMap.filtering = 0
					scenematerials[i].diffuseMap.monoOutput = 0
					scenematerials[i].diffuseMap.rgbOutput = 0
					scenematerials[i].diffuseMap.alphaSource = 2

				)
				
				if	scenematerials[i].opacityMapEnable == true then
				(
					scenematerials[i].OpacityMap.apply = true	
					scenematerials[i].OpacityMap.filtering = 0
					scenematerials[i].OpacityMap.monoOutput = 1
					scenematerials[i].OpacityMap.rgbOutput = 1
					scenematerials[i].OpacityMap.alphaSource = 0       
				)
			)
		)
	
	)
	
	
)
createdialog RenderSettings