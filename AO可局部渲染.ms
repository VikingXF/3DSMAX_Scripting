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
global aoFloater=newRolloutFloater "AO 支持矩形框渲染" 260 570 
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
addRollout ro_vrayao aoFloater