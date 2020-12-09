global ml_dirtmaterial
global fl_dirtmaterial
global mtl_switch=1
global vrayDirtmapSetting
try vrayDirtmapSetting=VRayDirt() catch undefined
fn isLoadedVray targetslot assign:false=
	(
	try
	(
	if (targetslot==1) then slot=renderers.production
	else slot=renderers.draft
	)
	catch()
	--is vray even installed?
	a=(findItem RendererClass.classes vray)
	if (a!=0) then
		(
		--detect if ANY VRay version is active
		if (findString (slot as string) "VRay"!=undefined) or (findString (slot as string) "V_Ray"!=undefined) then return true
		else
			(
			if assign then 
				(
				if (queryBox "VRay 不是当前渲染器。   \n是否继续？" title:"警告") then
					(
					--store current
					--dumb maxscript can only assign to currently avtive renderer slots
					b=renderer
					case targetslot of
						(
						1:	(
							renderer=#production
							renderers.production=RendererClass.classes[a]()
							)
						2:	(
							renderer=#draft
							renderers.draft=RendererClass.classes[a]()
							)
						)
					--reassign current
					renderer=b
					return true
					)
				)
			)
		)
	return false
	)

fn fl_vrayao_render =
(
render renderType:(getrendertype())
)
--detect light/dark ui for icons and hyperlink
global hyperlink_color, ui_color
if (colorMan.getColor #text).x < 0.2 then 
	(
	ui_color=3
	hyperlink_color=(color 8 8 136)
	)
else
	(
	ui_color=1
	hyperlink_color=white
	)
global ro_vrayao
global version
global aoFloater=newRolloutFloater "材质设置 AO 支持矩形框渲染" 260 570 
rollout ro_vrayao "Vray AO render" width:260 height:596
(
	GroupBox grp2 "Image Sampler Override" pos:[25,432] width:195 height:46
	button btn_render "render" pos:[67,485] width:113 height:26
	checkbox chk_override "Optimized rQMC Anti-Aliasing" pos:[41,453] width:160 height:15 checked:true
	spinner spn_subdivs "subdivs.............." pos:[50,205] width:156 height:16 range:[1,1000,16] type:#integer
	GroupBox grp_sky "Skylight optional" pos:[25,236] width:195 height:72 enabled:false
	radiobuttons rdo_skytype "" pos:[56,256] width:142 height:16 enabled:false labels:#("Sphere   ", "Dome") columns:2
	GroupBox grp25 "Method" pos:[25,13] width:195 height:41
	radiobuttons option_method "" pos:[45,31] width:185 height:16 labels:#("Dirtmap         ", "Skylight") columns:2
	GroupBox grp_dirt "Dirtmap optional" pos:[25,118] width:195 height:113
	spinner spn_dirtradius "radius................" pos:[50,139] width:156 height:16 range:[0,100000,100] type:#worldunits
	GroupBox grp31 "AO material type" pos:[25,61] width:195 height:49
	radiobuttons grp_mtl "" pos:[45,82] width:190 height:16 labels:#("standard", "VRayLightMtl") default:2 columns:2
	spinner spn_distribution "分布（对比度）" pos:[51,161] width:155 height:16 range:[0,10000,0]
	spinner spn_folloff "falloff................." pos:[49,183] width:157 height:16 range:[0,10000,0]
	GroupBox grp12 "Image sampler(Antialiasing)" pos:[25,309] width:195 height:115
	dropdownList imagesampler "Image sampler" pos:[38,326] width:165 height:41 items:#("Fixed", "Adaptive QMC", "Adaptive subdivision") selection:3
	dropdownList anti_filter "Antialiasing filter" pos:[38,372] width:134 height:41 items:#("Area", "Mitchell-Netravali", "Catmull-Rom", "VRayLanczosFilter") selection:3
	checkbox filter_checkbox "Checkbox" pos:[181,394] width:13 height:15 checked:true
	spinner spn_vrlight "Subdivs" pos:[61,282] width:126 height:16 enabled:false range:[1,1000,16]
	
	--choose mateial type 选择材质类型

	on btn_render pressed do
	(
		
	
	--version checking
		err=undefined
		if findString (vray() as string) "VRay_Adv_1_0" != undefined then err="出错啦，要求Vray 1.5及以上版本！\nonly works with Vray 1.5 or higher."
		if findString (vray() as string) "VRay_Adv_1_45" != undefined then err="出错啦，要求Vray 1.5及以上版本！\nonly works with Vray 1.5 or higher."
		if findString (vray() as string) "VRay_Adv_1_46" != undefined then err="出错啦，要求Vray 1.5及以上版本！\nonly works with Vray 1.5 or higher."
	
		if (isLoadedVray 1)==false then err="当前渲染器不是Vray，请设置成Vray先！\nPlease assign VRay as the current renderer!"
		
		if err != undefined then messageBox err title:"出错！Error!"
	
		else(
		local hcoverride=#()
		
		append hcoverride "gi_on=false"
		
		if chk_override.state==true then
			(
			--optimial AA QMC settings
			append hcoverride "twoLevel_useQMCSamplerThresh=true"
			append hcoverride "qmc_earlyTermination_amount=0.85"
			append hcoverride "qmc_earlyTermination_threshold=0.001"		
		)
		append hcoverride "options_hiddenLights=false"
		append hcoverride "options_defaultLights=false"		
		append hcoverride "options_overrideMtl_on=true"
		
	   --skylight
		if option_method.state==2 then append hcoverride "options_overrideMtl_mtl=VRayMtl diffuse:(color 255 255 255)"
		else (
			if mtl_switch==1 then
		--dirtmap
				(		fl_dirtmaterial=Standardmaterial ()
						fl_dirtmaterial.twoSided = on
						fl_dirtmaterial.Diffuse = color 255 255 255
						fl_dirtmaterial.ambient = color 255 255 255
						fl_dirtmaterial.SelfIllumAmount = 100
						fl_dirtmaterial.diffuseMap=vrayDirtmapSetting
						fl_dirtmaterial.diffuseMap.radius=spn_dirtradius.value
						fl_dirtmaterial.diffuseMap.subdivs=spn_subdivs.value
						fl_dirtmaterial.diffuseMap.Distribution =spn_distribution.value
						fl_dirtmaterial.diffuseMap.falloff=spn_folloff.value
						append hcoverride "options_overrideMtl_mtl=fl_dirtmaterial"
				)
			else
				(
						ml_dirtmaterial=VrayLightMtl()
						ml_dirtmaterial.twoSided =on
						ml_dirtmaterial.color=(color 255 255 255)
						ml_dirtmaterial.texmap=vrayDirtmapSetting
						ml_dirtmaterial.texmap.radius=spn_dirtradius.value
						ml_dirtmaterial.texmap.subdivs=spn_subdivs.value
						ml_dirtmaterial.texmap.Distribution =spn_distribution.value
						ml_dirtmaterial.texmap.falloff=spn_folloff.value
						append hcoverride "options_overrideMtl_mtl=ml_dirtmaterial"
				)
		)	
		append hcoverride "options_reflectionRefraction=false"
		if filter_checkbox.state==true then
		(	append hcoverride"filter_on=true"
			case anti_filter.selection of
			(
			1: append hcoverride"filter_kernel=Area()"
			2: append hcoverride"filter_kernel=Mitchell_Netravali()"
			3: append hcoverride"filter_kernel=Catmull_Rom()"
			4: append hcoverride"filter_kernel=VRayLanczosFilter()"
	
			)
		)
		else 
		(	append hcoverride"filter_on=false"
		)
	    case imagesampler.selection of
		(
			1: 	append hcoverride "imageSampler_type=0"
			2:   append hcoverride "imageSampler_type=1"
			3:  append hcoverride "imageSampler_type=2"
		)
		append hcoverride "ColorMapping_type=0"
		append hcoverride "ColorMapping_DarkMult=1"
		append hcoverride "ColorMapping_BrightMult=1"
		append hcoverride "ColorMapping_gamma=1"
	
		disableSceneRedraw()
		
		--snapshot of current vray settings
		current_snapshot=#()
		for i in (getpropnames vray) do
			(
			val=getProperty renderers.current i
			if (classOf val)==String then val="\""+val+"\""
			append current_snapshot ( (i as string)+"="+(val as string) )
			)
			
		--apply overrides
		for i in hcoverride do
			(
			try execute ("renderers.current."+i)
			catch()
			)
		
		--detect active lights to disable
		ml_activelights=#()
		for i in lights do
			(
			try if i.on then append ml_activelights i
			catch()
			try if i.enabled then append ml_activelights i
			catch()
			)
		
		for i in ml_activelights do 
			(
			try i.on=false
			catch()
			try i.enabled=false
			catch()
			)
		
		--start rendering
		
		if option_method.state==2 then (
				if rdo_skytype.state==2 then
					(
					--dome
					ml_dome=VRayLight dome_spherical:off size0:0 size1:0 type:1 multiplier:1 on:on invisible:on subdivs:spn_vrlight.value
					fl_vrayao_render()
					delete ml_dome
				)
				else
					(
					--sphere
					ml_dome=VRayLight dome_spherical:on size0:0 size1:0 type:1 multiplier:1 on:on invisible:on subdivs:spn_vrlight.value
					fl_vrayao_render()
					delete ml_dome
				)
		)
		else (
			--dirtmap
					--ml_dome=VRayLight dome_spherical:off size0:0 size1:0 type:1 multiplier:1 on:on invisible:on subdivs:spn_subdivs.value
					fl_vrayao_render()
					--delete ml_dome
			)
		
		
		--restore original vray settings
		for i in current_snapshot do
			(
			try execute ("renderers.current."+i)
			catch()
			)
		
		--restore lights
		for i in ml_activelights do
			(
			try i.on=true
			catch()
			try i.enabled=true
			catch()		
			)
			
		enableSceneRedraw()
		
	)
	
	)
	on option_method changed state do
	(
			case option_method.state of
				(
				1:( grp_sky.enabled=false
					grp_mtl.enabled=true
					grp_dirt.enabled=true
					spn_dirtradius.enabled=true
					rdo_skytype.enabled=false
					spn_distribution.enabled=true
					spn_folloff.enabled=true
					spn_subdivs.enabled=true
					spn_vrlight.enabled=false
				)
				2:(grp_dirt.enabled=false
					grp_mtl.enabled=false
					grp_sky.enabled=true
					spn_dirtradius.enabled=false
					rdo_skytype.enabled=true
					spn_distribution.enabled=false
					spn_folloff.enabled=false
					spn_subdivs.enabled=false
					spn_vrlight.enabled=true
				)
	
			)
		)
	on grp_mtl changed state do
	(
		case grp_mtl.state of
		(
		1:(mtl_switch=1)
		2:(mtl_switch=0)
		)
	)
	on filter_checkbox changed state do
	(
			case filter_checkbox.checked of
			(
			true: anti_filter.enabled=true
			false: anti_filter.enabled=false
			)
		)
)

rollout RenderSettings "设置材质" width:216 height:200
(
	groupBox 'grp1' "材质设置" pos:[18,20] width:179 height:80 align:#left	
	button 'btn1' "材质球设置" pos:[27,42] width:160 height:25 align:#left	
	spinner 'WeldValue' "自发光数值" pos:[27,76] width:67 height:16 range:[0,100,30] scale:1 align:#left
	
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



rollout MaterialsColorSettings "彩色材质通道" width:216 height:200
(
	button 'MCSbtn' "彩色材质通道" pos:[20,10] width:200 height:35 align:#left	
	on MCSbtn pressed  do
	(
		if scenematerials.count>0 then
		(
			qqq=queryBox "确定转为通道吗?" title:"不论场景材质数量!!"
			if qqq==true then
			(
				global geo=geometry as array
				global m=scenematerials
				global md=meditMaterials
				global nm=0
				disableSceneRedraw()
				--以下关闭灯光
				for i in lights do  
				(
					try i.enabled=off catch()
				)
				global ss = m.count
				--以上关闭灯光
				global cc=#()
				cc= #(
					  (color 255    0   0) , (color 253 161  115), (color 187  164   7), (color  0  160 174), (color  18   0   255), (color 255   0   120),
					  (color 93   106 174) , (color  0    65   0), (color 255  115 115), (color 255 135   7), (color 144   126  7 ), (color 45    92    7),
					  (color 0   112  122) , (color  12   0  168), (color 161    0  76), (color  0  255   0), (color 222   128 115), (color 197   105   7),
					  (color 98   86    7) , (color  68   151  0), (color   0   84  91), (color 120  0  255), (color  82     0  39), (color 126    0    0),
					  (color 192 133  114) , (color 139   75   7), (color 205  255   7), (color  92  206  0), (color  0    150 255), (color 246   0   255),
					  (color 139 142  181) , (color 150  136 115), (color 255  223   7), (color  144 164  7), (color  0    105 114), (color   0    71 121),
					  (color 89    0   92) , (color  95   96   0), (color 139  169 159), (color  0  116 198), (color 172    0  178), (color   0   255 255),
					  (color 134    0  91) , (color 172  139 139), (color 159  125 115), (color 105  58   7), (color 179   204   7), (color 113   253   0),
					  (color 255 128   26) , (color  26  155 255), (color 185   26 199), (color   92  74 26), (color  75    43  26), (color  75    26  34),
					  (color 93  124   26) , (color  117 255  26), (color 166   26 255), (color  126 26 199), (color 104   104 104), (color  26    57  26),
					  (color 26   75   75) , (color  56   26  75), (color 117  118  26), (color  26 255 182), (color 255    26 155), (color 26   52   168),
					  (color 84   26   26) , (color  75   73  26), (color 73   26   75), (color  26  67  75), (color 113    79  26), (color 26  118    26),
				-------------------------------固定色72个
					  (color 213   45   0) , (color 213   87   0), (color 213  129   0), (color 213  171  0), (color 213   213   0), (color 213   255   0),
					  (color 213   45  45) , (color 213   45  87), (color 213   45 129), (color 213  45 171), (color 213    45 213), (color 213    45 255),
					  (color 213   87  45) , (color 213   87  87), (color 213   87 129), (color 213  87 171), (color 213    87 213), (color 213    87 255),
					  (color 213   129 45) , (color 213   129 87), (color 213  129 129), (color 213 129 171), (color 213   129 213), (color 213   129 255),
					  (color 213   171 45) , (color 213   171 87), (color 213  171 129), (color 213 171 171), (color 213   171 213), (color 213   171 255),
					  (color 213   213 45) , (color 213   213 87), (color 213  213 129), (color 213 213 171),                        (color 213   213 255),
					  (color 213   255 45) , (color 213   255 87), (color 213  255 129), (color 213 255 171), (color 213   255 213), (color 213   255 255),
				------------213开头----------41个
					  (color 255   45   0) , (color 255   87   0), (color 255  129   0), (color 255  171  0), (color 255   213   0), (color 255   255   0),
					  (color 255   45  45) ,                       (color 255   45 129),                      (color 255    45 213), (color 255    45 255),
					  (color 255   87  45) , (color 255   87  87), (color 255   87 129), (color 255  87 171), (color 255    87 213), (color 255    87 255),
											 (color 255   129 87), (color 255  129 129), (color 255 129 171), (color 255   129 213), (color 255   129 255),
					  (color 255   171 45) , (color 255   171 87), (color 255  171 129), (color 255 171 171), (color 255   171 213), (color 255   171 255),
					  (color 255   213 45) , (color 255   213 87), (color 255  213 129), (color 255 213 171), (color 255   213 213), (color 255   213 255),
					  (color 255   255 45) , (color 255   255 87), (color 255  255 129), (color 255 255 171), (color 255   255 213),
				------------255开头---------38个
					  (color 87   45   0) , (color 87   87   0), (color 87  129   0), (color 87  171  0), (color 87   213   0), (color 87   255   0),
					  (color 87   45  45) , (color 87   45  87), (color 87   45 129), (color 87  45 171), (color 87    45 213), (color 87    45 255),
					  (color 87   87  45) ,                      (color 87   87 129), (color 87  87 171), (color 87    87 213), (color 87    87 255),
					  (color 87   129 45) , (color 87   129 87), (color 87  129 129), (color 87 129 171), (color 87   129 213), (color 87   129 255),
											(color 87   171 87), (color 87  171 129), (color 87 171 171), (color 87   171 213), (color 87   171 255),
											(color 87   213 87), (color 87  213 129), (color 87 213 171), (color 87   213 213), (color 87   213 255),
											(color 87   255 87), (color 87  255 129), (color 87 255 171),                       (color 87   255 255),
				------------87开头---------37个
					  (color 129   45   0) , (color 129   87   0),                       (color 129  171  0), (color 129   213   0), (color 129   255   0),
					  (color 129   45  45) , (color 129   45  87), (color 129   45 129), (color 129  45 171), (color 129    45 213), (color 129    45 255),
					  (color 129   87  45) , (color 129   87  87), (color 129   87 129), (color 129  87 171), (color 129    87 213), (color 129    87 255),
					  (color 129   129 45) , (color 129   129 87),                       (color 129 129 171), (color 129   129 213), (color 129   129 255),
					  (color 129   171 45) , (color 129   171 87), (color 129  171 129), (color 129 171 171), (color 129   171 213), (color 129   171 255),
					  (color 129   213 45) , (color 129   213 87), (color 129  213 129), (color 129 213 171), (color 129   213 213), (color 129   213 255),
					  (color 129   255 45) , (color 129   255 87), (color 129  255 129), (color 129 255 171), (color 129   255 213), (color 129   255 255),
				------------129开头--------40个
											 (color 171   87   0), (color 171  129   0), (color 171  171  0), (color 171   213   0), (color 171   255   0),
					  (color 171   45  45) , (color 171   45  87), (color 171   45 129), (color 171  45 171), (color 171    45 213),  
					  (color 171   87  45) , (color 171   87  87), (color 171   87 129), (color 171  87 171), (color 171    87 213), (color 171    87 255),
					  (color 171   129 45) , (color 171   129 87), (color 171  129 129), (color 171 129 171), (color 171   129 213), (color 171   129 255),
					  (color 171   171 45) , (color 171   171 87), (color 171  171 129),                      (color 171   171 213), (color 171   171 255),
					  (color 171   213 45) , (color 171   213 87), (color 171  213 129), (color 171 213 171), (color 171   213 213), (color 171   213 255),
					  (color 171   255 45) , (color 171   255 87), (color 171  255 129), (color 171 255 171), (color 171   255 213), (color 171   255 255),
				------------171开头-------39个
					  (color 0   45   0) , (color 0   87   0), (color 0  129   0), (color 0  171  0),                      (color 0   255   0),
					  (color 0   45  45) , (color 0   45  87), (color 0   45 129), (color 0  45 171), (color 0    45 213), (color 0    45 255),
					  (color 0   87  45) , (color 0   87  87),                     (color 0  87 171), (color 0    87 213), (color 0    87 255),
					  (color 0   129 45) ,                     (color 0  129 129), (color 0 129 171), (color 0   129 213), (color 0   129 255),
					  (color 0   171 45) , (color 0   171 87), (color 0  171 129),                    (color 0   171 213), (color 0   171 255),
					  (color 0   213 45) , (color 0   213 87), (color 0  213 129), (color 0 213 171), (color 0   213 213), (color 0   213 255),
					  (color 0   255 45) ,                     (color 0  255 129),                    (color 0   255 213), (color 0   255 255),
				-------------0开头-------36个
					  (color 45   45   0) , (color 45   87   0), (color 45  129   0), (color 45  171  0), (color 45   213   0), 
											(color 45   45  87), (color 45   45 129), (color 45  45 171), (color 45    45 213), (color 45    45 255),
					  (color 45   87  45) , (color 45   87  87), (color 45   87 129), (color 45  87 171),                        
					  (color 45   129 45) , (color 45   129 87), (color 45  129 129), (color 45 129 171), (color 45   129 213), (color 45   129 255),
					  (color 45   171 45) , (color 45   171 87), (color 45  171 129), (color 45 171 171), (color 45   171 213),
											(color 45   213 87), (color 45  213 129), (color 45 213 171), (color 45   213 213), (color 45   213 255),
											(color 45   255 87), (color 45  255 129), (color 45 255 171), (color 45   255 213), (color 45   255 255),
				-------------45开头------35个
					  (color 255   0   0),(color 255  0  150),  (color 198  0  255),  (color 144   0 255),  (color 90 0 255),   (color 0 162 255),  
					 (color   0 252 255),(color    0 255 96),  (color 210  255  0),   (color 255 228  0),  (color 255 192 0),  (color 255 120 0),  
					 (color 255  48   0),(color 173  58 216),  (color 109 107 216),   (color 83 168 147),  (color 97 168 83),  (color 168 149 83), 
					 (color 255 153 126),(color 255 126 126),  (color 255 126 190),   (color 229 126 255), (color 126 132 255),(color 126 196 255),
					 (color 125 255 253),(color 125 255 153),  (color 153 101 34),    (color 235 255 125), (color 255 186 131), (color 255 134 86),
					  (color 233 255 86), (color 114 255 86),   (color 86 255 189),   (color 86 255 237),   (color 86 213 255), (color 86 154 255), 
					 (color 126 86 255),  (color 233 86 255),  (color 255 86 181),    (color 222 86 146),  (color 255 191 191), (color 255 191 232), 
					 (color 191 235 255),(color 191 255 226),  (color 220 255 191),   (color 255 232 191), (color 210 133 133), (color 210 176 133),
					 (color 178 210 133),(color 133 207 210),  (color 133 147 210),   (color 162 133 210), (color 210 133 176), (color 204 88 88),  
					  (color 204 154  88), (color 189 204  88), (color 88 204 118),    (color 75 153 150),  (color 75 101 153),  (color 126 75 153),
					  (color 153 75 81),  (color 153 34 34),    (color 153 34 101),    (color 129 34 153),  (color 62 34 153),   (color 34  153 56), 
					 (color 153 152 34), (color 34 153 132),   (color 88 163 122),    (color 180 173 112)
					)
			
				rollout aa "材质进程" width:300 height:60
				(

					label lab2  wight:300
					progressBar doit_prog2 color:red 
					on aa OPEN DO 
					( 
						for j=1 to ss do
						(
							---------------------------------------------------------------------------------------------------------Standardmaterial
							if j>=1 and j<=72 do
							(
								if classof m[j] == Standardmaterial or classof m[j] == Standard do
								(
									m[j].shaderType = 1
									m[j].adTextureLock = on
									m[j].adLock = on
									m[j].dsLock = on
									m[j].Diffuse =cc[j]
									m[j].useSelfIllumColor = off
									m[j].selfIllumAmount = 100
									m[j].specularLevel = 0
									m[j].glossiness = 0
									m[j].Soften = 0
									m[j].opacity = 100
									m[j].ambientMapEnable = off
									m[j].diffuseMapEnable = off
									m[j].specularMapEnable = off
									m[j].specularLevelMapEnable = off
									m[j].glossinessMapEnable = off
									m[j].selfillumMapEnable = off
									m[j].opacityMapEnable = off
									m[j].filterMapEnable = off
									m[j].bumpMapEnable = off
									m[j].reflectionMapEnable = off
									m[j].refractionMapEnable = off
									m[j].displacementMapEnable = off
									m[j].opacityFallOffType = 0
									m[j].opacityFallOff = 0 
								)
							---------------------------------------------------------------------------------------------------------Standardmaterial
							---------------------------------------------------------------------------------------------------------no Standardmaterial
								if ( classof m[j] != MultiMaterial ) do
								(
									if classof m[j] != Standardmaterial or classof m[j] != Standard do
									(	
										if j>=1 and j<=24 do
										(
											md[j] = Standardmaterial name:m[j].name
											ssbb=for i in geo where i.Material==m[j] collect i
											ssbb.Material=md[j]
											md[j].adLock = on
											md[j].dsLock = on
										    md[j].Diffuse =cc[j]
											md[j].selfIllumAmount = 100
											md[j].specularLevel = 0
											md[j].glossiness = 0
										)
										if j>=25 and j<=72 do
										(
											num=integer(j/24)
											md[j-24*num+1] = Standardmaterial name:m[j].name
											ssbb=for i in geo where i.Material==m[j] collect i
											ssbb.Material=md[j-24*num+1]
											md[j-24*num+1].adLock = on
											md[j-24*num+1].dsLock = on
										    md[j-24*num+1].Diffuse =cc[j]
											md[j-24*num+1].selfIllumAmount = 100
											md[j-24*num+1].specularLevel = 0
											md[j-24*num+1].glossiness = 0
										)
									)
								) 
							)--------------------------------------------------------------------------------------------------------[if j>=1 and j<=72 do]end
							---------------------------------------------------------------------------------------------------------no Standardmaterial
							---------------------------------------------------------------------------------------------------------ss>72
							if j>=73 and j<=255 do
							(
								if classof m[j] == Standardmaterial or classof m[j] == Standard do
								(
									m[j].shaderType = 1
									m[j].adTextureLock = on
									m[j].adLock = on
									m[j].dsLock = on
									kkk=random 73 408
									m[j].Diffuse =cc[kkk]
									m[j].useSelfIllumColor = off
									m[j].selfIllumAmount = 100
									m[j].specularLevel = 0
									m[j].glossiness = 0
									m[j].Soften = 0
									m[j].opacity = 100
									m[j].ambientMapEnable = off
									m[j].diffuseMapEnable = off
									m[j].specularMapEnable = off
									m[j].specularLevelMapEnable = off
									m[j].glossinessMapEnable = off
									m[j].selfillumMapEnable = off
									m[j].opacityMapEnable = off
									m[j].filterMapEnable = off
									m[j].bumpMapEnable = off
									m[j].reflectionMapEnable = off
									m[j].refractionMapEnable = off
									m[j].displacementMapEnable = off
									m[j].opacityFallOffType = 0
									m[j].opacityFallOff = 0 
								)
							---------------------------------------------------------------------------------------------------------Standardmaterial
							---------------------------------------------------------------------------------------------------------no Standardmaterial
								if ( classof m[j] != MultiMaterial ) do
								(
									if classof m[j] != Standardmaterial or classof m[j] != Standard do
									(	
										num=integer(j/24)
										md[j-24*num+1] = Standardmaterial name:m[j].name
										ssbb=for i in geo where i.Material==m[j] collect i
										ssbb.Material=md[j-24*num+1]
										md[j-24*num+1].adLock = on
										md[j-24*num+1].dsLock = on
										kkk=random 73 408
										md[j-24*num+1].Diffuse =cc[kkk]
										md[j-24*num+1].selfIllumAmount = 100
										md[j-24*num+1].specularLevel = 0
										md[j-24*num+1].glossiness = 0
									) 
								)
							)--------------------------------------------------[if j>=73 and j<=255 do]end
							-----------------------***************************************************************************************                             
							---------------------------------------------------------------------------------------------------------no Standardmaterial
							---------------------------------------------------------------------------------------------------------ss>72
							if j>=256 do
							(
							---------------------------------------------------------------------------------------------------------Standardmaterial
								if classof m[j] == Standardmaterial or classof m[j] == Standard do
								(
									m[j].shaderType = 1
									m[j].adTextureLock = on
									m[j].adLock = on
									m[j].dsLock = on
									m[j].Diffuse =color (random 0 255) (random 0 255) (random 0 255)
									m[j].useSelfIllumColor = off
									m[j].selfIllumAmount = 100
									m[j].specularLevel = 0
									m[j].glossiness = 0
									m[j].Soften = 0
									m[j].opacity = 100
									m[j].ambientMapEnable = off
									m[j].diffuseMap = undefined
									m[j].specularMapEnable = off
									m[j].specularLevelMapEnable = off
									m[j].glossinessMapEnable = off
									m[j].selfillumMapEnable = off
									m[j].opacityMapEnable = off
									m[j].filterMapEnable = off
									m[j].bumpMapEnable = off
									m[j].reflectionMapEnable = off
									m[j].refractionMapEnable = off
									m[j].displacementMapEnable = off
									m[j].opacityFallOffType = 0
									m[j].opacityFallOff = 0
								)
							---------------------------------------------------------------------------------------------------------Standardmaterial
							---------------------------------------------------------------------------------------------------------no Standardmaterial
								if ( classof m[j] != MultiMaterial ) do
								(
									if classof m[j] != Standardmaterial or classof m[j] != Standard do
									(	               
										num=integer(j/24)
										md[j-24*num+1] = Standardmaterial name:m[j].name
										ssbb=for i in geo where i.Material==m[j] collect i
										ssbb.Material=md[j-24*num+1]
										md[j-24*num+1].adLock = on
										md[j-24*num+1].dsLock = on
										md[j-24*num+1].Diffuse =color (random 0 255) (random 0 255) (random 0 255)
										md[j-24*num+1].selfIllumAmount = 100
										md[j-24*num+1].specularLevel = 0
										md[j-24*num+1].glossiness = 0
									)                                  
								)
							)----------------------------------[if j>=256 do]end
							-----------------------------------------------------------------------------------------------------------------------
							if ( classof m[j] == MultiMaterial ) then   -----------------------多维次材质
							(
								nm=nm+1	
								tempMultimaterial = Multimaterial  name:m[j].name  numsubs:m[j].numsubs
								ssbb=for i in geo where i.Material==m[j] collect i
								if ssbb.count>0 do
								(					
									for kk=1 to tempMultimaterial.numsubs do
									(    
										tempMultimaterial.materialList[kk]= Standardmaterial name:(m[j].materialList[kk].name )
										tempMultimaterial.materialList[kk].useSelfIllumColor = off
										tempMultimaterial.materialList[kk].selfIllumAmount = 100
										tempMultimaterial.materialList[kk].specularLevel = 0
										tempMultimaterial.materialList[kk].Diffuse = color (random 0 255) (random 0 255) (random 0 255)								
									)
									ssbb.Material=tempMultimaterial
								)
							)                                           -----------------------多维次材质
						-------------------------------------------------------------------------------------------------
						-----------------------------------------------------------------------------------------------------------------------
							lab2.text ="curent mater:    "+scenematerials[j].name
							doit_prog2.value = 100.*j/ss
						)---------------------------[for j=1 to ss do] end
					)--------------------------------------------------------------------[on aa OPEN DO] end

				)
				createDialog aa
			
			)
			else
			(
				pushPrompt ("通道程序终止。")
			)		
			if qqq==true do
			(
				destroyDialog aa
				messagebox "通道完成!!" title:"silkroad"
				if nm==0 do
				(
					pushPrompt (ss as string+"  个场景材质")
				)
				if nm>0 do
				(
					pushPrompt (ss as string+"  个场景材质。" + nm as string +"个多维次材质!")
				)
				clearSelection()
				EnableSceneRedraw()
			)
		)---------------------------------------------------------------------[scenematerials.count>0] end
		else
		(
			messagebox "没有材质!" title:"silkroad"
		)
			
		)
)

addRollout RenderSettings aoFloater
addRollout ro_vrayao aoFloater
addRollout MaterialsColorSettings aoFloater
