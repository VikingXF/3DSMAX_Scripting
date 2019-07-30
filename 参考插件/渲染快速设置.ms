
	global mr_rt_tracedepth = 6 --Mental Ray Raytrace Depths (def:maximumrelect:refract:tracedepth)
	
	global	mr_as_samples = 2    --Mental Ray Area Shadows Samples | Both U's and V's (uv) (def:Area_U_Samples)
	global	mr_sl_sm_mapsize = 512  --Mental Ray & Scanline Shadow map size (def:map_size)
	global	mr_sm_samples = 4    --Mental Ray shadow map samples (def:samples)
		
    	--caustics
	global	mr_Ca_acc = 2 --Mental Ray Caustic Accuracy (def:CausticAccuracy)
	global	mr_cs_rad = 75 --Mental Ray Caustics radius (def:CausticRadius)
	global  mr_ca_light_photons = 4 --Indirect illumination : caustic accuracy in lights

	--Anti-aliasing
	global	mr_aa_smpls_min = -3 --Mental Ray anti-aliasing filter samples minimum (def:MinimumSamples)
	global	mr_aa_smpls_max = -2 --Mental Ray anti-aliasing filter samples maximum (def:MaximumSamples)

	--Final Gatherth
	global	mr_fg_rad = 300 --Mental Ray Final Gather Radius (def:FinalGatherRadius)
	global	mr_fg_acc = 10 --Mental Ray Final Gather Samples/Accuracy (def:FinalGatherAccuracy)
	global	mr_fg_flt = 3  --Mental Ray Final Gather Filter (def:FinalGatherFilter)
	global  mr_fg_tracedepth --Mental ray Final gather Trace depths def (FinalGatherReflectionDepth:FinalGatherRefractionDepth:FinalGatherTraceDepth)
	

		--Gi
	global	mr_gi_samples = 10 --Mental Ray Global Illumination Samples (def:GlobalIllumAccuracy)
    global  mr_gi_max_sample_rad = 250 --Mental Ray global illumination max sampele radius (def:GlobalIllumRadius)
--Constructs AND Functions : 

function setsettings mr_as_samples mr_sl_sm_mapsize mr_sm_samples mr_Ca_acc mr_cs_rad mr_aa_smpls_min mr_aa_smpls_max mr_fg_rad mr_fg_acc mr_fg_flt mr_gi_samples mr_fg_tracedepth mr_rt_tracedepth mr_gi_max_sample_rad mr_ca_light_photons=     --Set the settings
(
		undo off -- yes :)
		
		
		for i in lights where hasProperty i "Area_U_Samples" do i.Area_U_Samples = mr_as_samples  --MENTALRAY AREA SHADOWS
		for i in lights where hasProperty i "Area_V_Samples" do i.Area_V_Samples = mr_as_samples  --MENTALRAY AREA SHADOWS
	
		for i in lights where hasProperty i "samples" do i.samples = mr_sm_samples           --MENTAL RAY SHADOW MAPS
		for i in lights where hasProperty i "map_size" do i.map_size = mr_sl_sm_mapsize		 --MENTAL RAY SHADOW MAPS / SCANLINE SHADOWS
		for i in lights where hasProperty i "mapsize" do i.mapsize = mr_sl_sm_mapsize		 --SCANLINE SHADOW MAPS

		--caustics
		
		
		if renderers.current.CausticsEnable == true then   --Mr Caustics settings
		(
			renderers.current.CausticAccuracy = mr_Ca_acc
			renderers.current.UseCausticRadius = true              --HUSK
			renderers.current.CausticRadius = mr_cs_rad
			renderers.current.GlobalLightCausticPhotons = 100
			
		 	for i in lights where hasProperty i "affectDiffuse" do i.baseObject.mental_ray__Indirect_Illumination_custom_attribute.mrII_GlobalCausticPhotonMultiplier = mr_ca_light_photons  --every light have "affectdiffuse" property, except the skylight :)
			for i in lights where hasProperty i "Area_U_Samples" do i.baseObject.mental_ray__Indirect_Illumination_custom_attribute.mrII_GlobalCausticPhotonMultiplier = mr_ca_light_photons  --every light have "affectdiffuse" property, mr arealights didnt respond :)


			)
		
		
		renderers.current.MaximumReflections = mr_rt_tracedepth --Mr Raytrace depth
		renderers.current.MaximumRefractions = mr_rt_tracedepth --Mr Raytrace depth
		renderers.current.MaximumTraceDepth = mr_rt_tracedepth  --Mr Raytrace depth
		renderers.current.MinimumSamples = mr_aa_smpls_min    --Mr aa-Samples
		renderers.current.MaximumSamples = mr_aa_smpls_max    --Mr aa-Samples


		if renderers.current.FinalGatherEnable2 ==true do     --Mr Final Gather Settings
		(
			renderers.current.UseFinalGatherRadius = true
			renderers.current.FinalGatherRadius = mr_fg_rad 
			renderers.current.FinalGatherAccuracy = mr_fg_acc
			renderers.current.FinalGatherFilter = mr_fg_flt
		
			renderers.current.FinalGatherReflectionDepth = mr_fg_tracedepth
			renderers.current.FinalGatherRefractionDepth = mr_fg_tracedepth
			renderers.current.FinalGatherTraceDepth = mr_fg_tracedepth

		
		)
		
		if renderers.current.GlobalIllumEnable ==true do      --Mr Global Illumination settings
		(
			renderers.current.GlobalIllumAccuracy = mr_gi_samples 
			renderers.current.GlobalIllumRadius = mr_gi_max_sample_rad
		)
	

	
)	--End of function "set the settings"


	
	rollout a "渲染快速设置  QQ:272392069" width:410 height:80
	(
	label xuanrlbl "渲染器切换:" pos:[13,15] width:70 height:23
	dropdownList xrqh "" pos:[89,13] width:78 height:22 items:#("默认扫描线","经典mental_ray","华丽VRay")
	Button an  "" pos:[174,12] 
	
	------------------------------------------------------
		groupBox grp1 "经典Mr--设置" pos:[10,49] width:179 height:65
		button button_low "低" pos:[23,65] width:28 height:21 enabled:false
		button button_mid "中" pos:[51,65] width:28 height:21 enabled:false 
		button button_nice "好" pos:[79,65] width:28 height:21 enabled:false
		button button_high "高" pos:[108,65] width:28 height:21 enabled:false
		button button_ultra "很高" pos:[136,65] width:40 height:21 enabled:false
		checkbox gi_chk_bx "GI" pos:[24,90] width:40 height:20 enabled:false checked:false 
		checkbox fg_chk_bx "聚焦" pos:[76,90] width:49 height:20 enabled:false checked:false
		checkbox ca_chk_bx "焦散" pos:[132,90] width:45 height:20 enabled:false checked:false
	
	--MR渲染设置
	
	
		GroupBox grp2 "华丽Vray--设置" pos:[10,119] width:179 height:85
		button button_vlow "低" pos:[23,135] width:28 height:21 enabled:false
		button button_vmid "中" pos:[51,135] width:28 height:21 enabled:false 
		button button_vnice "好" pos:[79,135] width:28 height:21 enabled:false
		button button_vhigh "高" pos:[108,135] width:28 height:21 enabled:false
		button button_vultra "很高" pos:[136,135] width:40 height:21 enabled:false
		checkbox vgi_chk_bx "GI" pos:[24,160] width:40 height:20 enabled:false checked:false 
		checkbox vca_chk_bx "焦散" pos:[76,160] width:45 height:20 enabled:false checked:false
		checkbox vhuise_chk_bx "素模" pos:[132,160] width:49 height:20 enabled:false checked:false
		
		checkbox vgi_keep "保持" pos:[24,180]  height:20 enabled:false checked:false 


	--vR渲染设置

on  xrqh selected i do
		(
			if i == 1
					do
					(

try renderers.current = RendererClass.classes[1]() catch()
				 	
			button_low.enabled = false 
			button_mid.enabled = false 
			button_nice.enabled = false  
			button_high.enabled = false  
			button_ultra.enabled = false 
			gi_chk_bx.enabled = false  
			fg_chk_bx.enabled = false 
			ca_chk_bx.enabled = false 
			
			button_vlow.enabled = false 
			button_vmid.enabled = false 
			button_vnice.enabled = false  
			button_vhigh.enabled = false  
			button_vultra.enabled = false 
			vgi_chk_bx.enabled = false  
			vca_chk_bx.enabled = false 
			vhuise_chk_bx.enabled = false 
			vgi_keep.enabled = false

	)
			if  i == 2
					do
					(
	try renderers.current = RendererClass.classes[3]() catch()
	
			button_low.enabled = true
			button_mid.enabled = true
			button_nice.enabled = true 
			button_high.enabled = true 
			button_ultra.enabled = true
			gi_chk_bx.enabled = true 
			fg_chk_bx.enabled = true
			ca_chk_bx.enabled = true
			
					button_vlow.enabled = false 
					button_vmid.enabled = false 
					button_vnice.enabled = false  
					button_vhigh.enabled = false  
					button_vultra.enabled = false 
					vgi_chk_bx.enabled = false  
					vhuise_chk_bx.enabled = false 
					vca_chk_bx.enabled = false 
					vgi_keep.enabled = false
				 		)
				if  i  == 3
					do
					(

					try renderers.current = RendererClass.classes[4]() catch()
					
					button_low.enabled = false 
					button_mid.enabled = false 
					button_nice.enabled = false  
					button_high.enabled = false  
					button_ultra.enabled = false 
					gi_chk_bx.enabled = false  
					fg_chk_bx.enabled = false 
					ca_chk_bx.enabled = false 
					 
					button_vlow.enabled = true
					button_vmid.enabled = true
					button_vnice.enabled = true  
					button_vhigh.enabled = true 
					button_vultra.enabled = true 
					vgi_chk_bx.enabled = true  
					vca_chk_bx.enabled = true 
					vhuise_chk_bx.enabled = true 
					vgi_keep.enabled = true
				
	)
		)
		
on an pressed do
(
if classof renderers.current == mental_ray_renderer do 
	(
	button_low.enabled = true
	button_mid.enabled = true
	button_nice.enabled = true 
	button_high.enabled = true 
	button_ultra.enabled = true
	gi_chk_bx.enabled = true 
	fg_chk_bx.enabled = true
	ca_chk_bx.enabled = true
)
)		




	on button_low pressed do    --LOW 

	(
		mr_rt_tracedepth = 4
		mr_as_samples = 1    
	 	mr_sl_sm_mapsize = 512 
	 	mr_sm_samples = 4  
	 	mr_Ca_acc = 8
	 	mr_ca_light_photons = 8
		mr_cs_rad = 75 
	 	mr_aa_smpls_min = -3 
	 	mr_aa_smpls_max = -2 
		mr_fg_rad = 300
 		mr_fg_acc = 16
 		mr_fg_flt = 1  
 		mr_fg_tracedepth = 3
		
		if 	renderers.current.FinalGatherEnable2 == true then 	mr_gi_samples = 25 else mr_gi_samples = 250
		mr_gi_max_sample_rad = 25
	 	
		setsettings mr_as_samples mr_sl_sm_mapsize mr_sm_samples mr_Ca_acc mr_cs_rad mr_aa_smpls_min mr_aa_smpls_max mr_fg_rad mr_fg_acc mr_fg_flt mr_gi_samples mr_fg_tracedepth mr_rt_tracedepth mr_gi_max_sample_rad mr_ca_light_photons
	 	
		for i in meditMaterials where hasProperty i "Samples" do i.samples = 16
		pushprompt "mR_pRime:LOW"
	)
    
 	on button_mid pressed do    --Mid
	(
		mr_rt_tracedepth = 4
	  	mr_as_samples = 2
	  	mr_sl_sm_mapsize = 1024
	  	mr_sm_samples = 8
	  	mr_Ca_acc = 25
		mr_ca_light_photons = 16
	  	mr_cs_rad = 75

	  	mr_aa_smpls_min = -3
	  	mr_aa_smpls_max = -1
		mr_fg_rad = 150
 	 	mr_fg_acc = 32
 	 	mr_fg_flt = 1
 	 	mr_fg_tracedepth = 5
		
		if 	renderers.current.FinalGatherEnable2 == true then 	mr_gi_samples = 50 else mr_gi_samples = 500
		mr_gi_max_sample_rad = 50
      
  		setsettings mr_as_samples mr_sl_sm_mapsize mr_sm_samples mr_Ca_acc mr_cs_rad mr_aa_smpls_min mr_aa_smpls_max mr_fg_rad mr_fg_acc mr_fg_flt mr_gi_samples mr_fg_tracedepth mr_rt_tracedepth mr_gi_max_sample_rad mr_ca_light_photons
	
		for i in meditMaterials where hasProperty i "Samples" do i.samples = 32
	    pushprompt "mR_pRime:MID"
 	)

	on button_nice pressed do    --Nice
	(
		mr_rt_tracedepth = 5
	  	mr_as_samples = 4
	  	mr_sl_sm_mapsize = 2048
	  	mr_sm_samples = 32
	  	mr_Ca_acc = 50
	  	mr_ca_light_photons = 128
		mr_cs_rad = 75

	  	mr_aa_smpls_min = -2
	  	mr_aa_smpls_max = 1

		mr_fg_rad = 128
 	 	mr_fg_acc = 64
 	 	mr_fg_flt = 1
              	    mr_fg_tracedepth = 8
 	 	
		if 	renderers.current.FinalGatherEnable2 == tre then 	mr_gi_samples = 75 else mr_gi_samples = 1000
		mr_gi_max_sample_rad = 25

		setsettings mr_as_samples mr_sl_sm_mapsize mr_sm_samples mr_Ca_acc mr_cs_rad mr_aa_smpls_min mr_aa_smpls_max mr_fg_rad mr_fg_acc mr_fg_flt mr_gi_samples mr_fg_tracedepth mr_rt_tracedepth mr_gi_max_sample_rad mr_ca_light_photons
	 	 	
		for i in meditMaterials where hasProperty i "Samples" do i.samples = 64
	    pushprompt "mR_pRime:NICE"
 	)
	
	on button_high pressed do    --high
	(
	  	mr_rt_tracedepth = 6
		mr_as_samples = 8
	  	mr_sl_sm_mapsize = 4096
	  	mr_sm_samples = 64
	  	mr_Ca_acc = 75
	  	mr_ca_light_photons = 512
		mr_cs_rad = 75
	  	
		mr_aa_smpls_min = -1
	  	mr_aa_smpls_max = 2
		
		mr_fg_rad = 100
 	 	mr_fg_acc = 256
 	 	mr_fg_flt = 1
 		mr_fg_tracedepth = 10	  
	
		if 	renderers.current.FinalGatherEnable2 == true then mr_gi_samples = 150 else mr_gi_samples = 1500
		mr_gi_max_sample_rad = 50
	 
	    setsettings mr_as_samples mr_sl_sm_mapsize mr_sm_samples mr_Ca_acc mr_cs_rad mr_aa_smpls_min mr_aa_smpls_max mr_fg_rad mr_fg_acc mr_fg_flt mr_gi_samples mr_fg_tracedepth mr_rt_tracedepth mr_gi_max_sample_rad mr_ca_light_photons

 	 	
		for i in meditMaterials where hasProperty i "Samples" do i.samples = 256
        pushprompt "mR_pRime:HIGH"
 	)

	on button_ultra pressed do    --ultra
	(
		mr_rt_tracedepth = 8
	  	mr_as_samples = 16
	  	mr_sl_sm_mapsize = 8192
	  	mr_sm_samples = 128
	  	mr_Ca_acc = 100
	  	mr_cs_rad = 75
	    mr_ca_light_photons = 1024
	 	mr_aa_smpls_min = -1
	  	mr_aa_smpls_max = 3
	
		mr_fg_rad = 90
 	 	mr_fg_acc = 512
 	 	mr_fg_flt = 1
 		mr_fg_tracedepth = 12	  
	
 		if 	renderers.current.FinalGatherEnable2 == true then 	mr_gi_samples = 500 else mr_gi_samples = 2000
		mr_gi_max_sample_rad = 100
	   

		setsettings mr_as_samples mr_sl_sm_mapsize mr_sm_samples mr_Ca_acc mr_cs_rad mr_aa_smpls_min mr_aa_smpls_max mr_fg_rad mr_fg_acc mr_fg_flt mr_gi_samples mr_fg_tracedepth mr_rt_tracedepth mr_gi_max_sample_rad mr_ca_light_photons

  		for i in meditMaterials where hasProperty i "Samples" do i.samples = 256 
		pushprompt "mR_pRime:ULTRA (EXTREME RENDERTIMES!)"
 	)



		----------------------------------------
		----------设置----------------------
		----------------------------------------
		

		
		on gi_chk_bx changed state do             ---- 开启/关闭 GI
		(
			if state == on do 
			(
				renderers.current.GlobalIllumEnable =true
			)
			if state == off then renderers.current.GlobalIllumEnable =false
		) 
	
			

		on fg_chk_bx changed state do			-- 开启/关闭  最终聚焦
		(
			if state == on do renderers.current.FinalGatherEnable2 =true
			if state == off then renderers.current.FinalGatherEnable2 =false
		) 
	
		on ca_chk_bx changed state do          -- 开启/关闭  焦散
		(
			if state == on then 
			(
				renderers.current.CausticsEnable = true
			)
			
			if state == off then 
			(
				
				renderers.current.CausticsEnable = false			
			)
		) 



		on vgi_chk_bx changed state do             ---- 开启/关闭vr GI
		(
			if state == on do 
			(
				renderers.current.gi_on = true
			)
			if state == off then renderers.current.gi_on = false
		) 
	
		
		on vca_chk_bx changed state do             ---- 开启/关闭vr GI
		(
			if state == on do 
			(
				renderers.current.Caustics_on = true
			)
			if state == off then renderers.current.Caustics_on = false
		) 

	on button_vlow pressed do
	(-- 低 
		renderers.current.gi_on = true			--间接照明					
		renderers.current.gi_refractCaustics = true --间接照明.折射
		renderers.current.gi_reflectCaustics = false --间接照明.反射
		renderers.current.gi_primary_type = 0	--间接照明.首次倍增.引擎
		renderers.current.gi_primary_multiplier = 1.0 --间接照明.首次倍增
		renderers.current.gi_secondary_type = 3  --间接照明.二次倍增.引擎
		renderers.current.gi_secondary_multiplier = 0.8 
		renderers.current.gi_irradmap_minRate = -5
		renderers.current.gi_irradmap_maxRate = -5
		renderers.current.gi_irradmap_subdivs = 10--发光贴图.半球细分
		renderers.current.gi_irradmap_interpSamples = 10--发光贴图.查补采样
		renderers.current.gi_irradmap_colorThreshold = 0.4
		renderers.current.gi_irradmap_normalThreshold = 0.3
		renderers.current.gi_irradmap_distThreshold = 0.1
		renderers.current.gi_irradmap_showCalcPhase = true
		renderers.current.gi_irradmap_showdirectlight = true
		renderers.current.Lightcache_subdivs = 50 --灯光缓存细分
		renderers.current.lightcache_showCalcPhase = 1
		renderers.current.imageSampler_type = 0  --采样类型（固定）
		renderers.current.filter_on = true  --开启抗锯齿
		renderers.current.filter_kernel = Area()  --抗锯齿类型
		renderers.current.options_defaultLights = false --关闭默认场景灯光
		renderers.current.environment_gi_on = true
		renderers.current.environment_gi_color = [255,255,255]
		renderers.current.environment_gi_color_multiplier = 1
		renderers.current.environment_rr_on = true
		renderers.current.environment_rr_color = [0,0,0]
		renderers.current.environment_rr_color_multiplier = 1.0
		renderers.current.colorMapping_type = 6
		renderers.current.system_region_x = 70 --渲染区域大小
		renderers.current.qmc_earlyTermination_threshold= 1  --Noise_threshold
		renderers.current.qmc_earlyTermination_amount=1  --Adaptive_amount
		renderers.current.system_vrayLog_show = false
	)

on button_vmid pressed do
(--中
		renderers.current.gi_on = true			--间接照明					
		renderers.current.gi_refractCaustics = true --间接照明.折射
		renderers.current.gi_reflectCaustics = false --间接照明.反射
		renderers.current.gi_primary_type = 0	--间接照明.首次倍增.引擎
		renderers.current.gi_primary_multiplier = 1.0 --间接照明.首次倍增
		renderers.current.gi_secondary_type = 3  --间接照明.二次倍增.引擎
		renderers.current.gi_secondary_multiplier = 0.8 
		renderers.current.gi_irradmap_minRate = -4
		renderers.current.gi_irradmap_maxRate = -3
		renderers.current.gi_irradmap_subdivs = 30--发光贴图.半球细分
		renderers.current.gi_irradmap_interpSamples = 20--发光贴图.查补采样
		renderers.current.gi_irradmap_colorThreshold = 0.4
		renderers.current.gi_irradmap_normalThreshold = 0.2
		renderers.current.gi_irradmap_distThreshold = 0.1
		renderers.current.gi_irradmap_showCalcPhase = true
		renderers.current.gi_irradmap_showdirectlight = true
		renderers.current.Lightcache_subdivs = 200 --灯光缓存细分
		renderers.current.lightcache_showCalcPhase = 1
		renderers.current.imageSampler_type = 0  --采样类型（固定）
		renderers.current.filter_on = true  --开启抗锯齿
		renderers.current.filter_kernel = Area()  --抗锯齿类型
		renderers.current.options_defaultLights = false --关闭默认场景灯光
		renderers.current.environment_gi_on = true
		renderers.current.environment_gi_color = [255,255,255]
		renderers.current.environment_gi_color_multiplier = 1
		renderers.current.environment_rr_on = true
		renderers.current.environment_rr_color = [0,0,0]
		renderers.current.environment_rr_color_multiplier = 1.0
		renderers.current.colorMapping_type = 6
		renderers.current.system_region_x = 60 --渲染区域大小
		renderers.current.qmc_earlyTermination_threshold= 0.05  --Noise_threshold
		renderers.current.qmc_earlyTermination_amount=0.9 --Adaptive_amount
		renderers.current.system_vrayLog_show = false
)
on	button_vnice pressed do
(
	-- 好
		renderers.current.gi_on = true			--间接照明					
		renderers.current.gi_refractCaustics = true --间接照明.折射
		renderers.current.gi_reflectCaustics = false --间接照明.反射
		renderers.current.gi_primary_type = 0	--间接照明.首次倍增.引擎
		renderers.current.gi_primary_multiplier = 1.0 --间接照明.首次倍增
		renderers.current.gi_secondary_type = 3  --间接照明.二次倍增.引擎
		renderers.current.gi_secondary_multiplier = 0.8 
		renderers.current.gi_irradmap_minRate = -3
		renderers.current.gi_irradmap_maxRate = -1
		renderers.current.gi_irradmap_subdivs = 40--发光贴图.半球细分
		renderers.current.gi_irradmap_interpSamples = 30--发光贴图.查补采样
		renderers.current.colorMapping_type = 6
		renderers.current.gi_irradmap_colorThreshold = 0.3
		renderers.current.gi_irradmap_normalThreshold = 0.3
		renderers.current.gi_irradmap_distThreshold = 0.5
		
		renderers.current.gi_irradmap_showCalcPhase = true
		renderers.current.gi_irradmap_showdirectlight = true
		renderers.current.lightcache_adaptiveTracing = on
		renderers.current.Lightcache_subdivs = 500 --灯光缓存细分
		renderers.current.lightcache_showCalcPhase = 1
		
		renderers.current.imageSampler_type = 2 --采样类型（固定）
		
		renderers.current.filter_on = true  --开启抗锯齿
		
		renderers.current.filter_kernel = Catmull_Rom()  --抗锯齿类型
		
		renderers.current.options_defaultLights = false --关闭默认场景灯光
		
		renderers.current.environment_gi_on = true
		renderers.current.environment_gi_color = [255,255,255]
		renderers.current.environment_gi_color_multiplier = 1
		renderers.current.environment_rr_on = true
		renderers.current.environment_rr_color = [0,0,0]
		renderers.current.environment_rr_color_multiplier = 1.0
		
		renderers.current.system_region_x = 50 --渲染区域大小

		renderers.current.qmc_earlyTermination_threshold= 0.01  --Noise_threshold
		renderers.current.qmc_earlyTermination_amount=0.85 --Adaptive_amount
		renderers.current.system_vrayLog_show = false
		)

on button_vhigh pressed do
(
--高
		renderers.current.gi_on = true			--间接照明					
		renderers.current.gi_refractCaustics = true --间接照明.折射
		renderers.current.gi_reflectCaustics = false --间接照明.反射
		renderers.current.gi_primary_type = 0	--间接照明.首次倍增.引擎
		renderers.current.gi_primary_multiplier = 1.0 --间接照明.首次倍增
		renderers.current.gi_secondary_type = 3  --间接照明.二次倍增.引擎
		renderers.current.gi_secondary_multiplier = 0.8 
		renderers.current.gi_irradmap_minRate = -3
		renderers.current.gi_irradmap_maxRate = -1
		renderers.current.gi_irradmap_subdivs = 50--发光贴图.半球细分
		renderers.current.gi_irradmap_interpSamples = 30--发光贴图.查补采样
		renderers.current.gi_irradmap_colorThreshold = 0.1
		renderers.current.gi_irradmap_normalThreshold = 0.3
		renderers.current.gi_irradmap_distThreshold = 0.1
		renderers.current.gi_irradmap_showCalcPhase = true
		renderers.current.gi_irradmap_showdirectlight = true
		renderers.current.lightcache_adaptiveTracing = on
		renderers.current.Lightcache_subdivs = 1000 --灯光缓存细分
		renderers.current.lightcache_showCalcPhase = 1
		renderers.current.imageSampler_type = 2 --采样类型（只是应）
		renderers.current.filter_on = true  --开启抗锯齿
		renderers.current.filter_kernel = Catmull_Rom()  --抗锯齿类型
		renderers.current.options_defaultLights = false --关闭默认场景灯光
		renderers.current.environment_gi_on = true
		renderers.current.environment_gi_color = [255,255,255]
		renderers.current.environment_gi_color_multiplier = 1
		renderers.current.environment_rr_on = true
		renderers.current.environment_rr_color = [0,0,0]
		renderers.current.environment_rr_color_multiplier = 1.0
		renderers.current.colorMapping_type = 6
		renderers.current.system_region_x = 50 --渲染区域大小
		renderers.current.qmc_earlyTermination_threshold= 0.01  --Noise_threshold
		renderers.current.qmc_earlyTermination_amount=0.1 --Adaptive_amount
		renderers.current.system_vrayLog_show = false

)
	on button_vhigh pressed do
	(
	-- 很高
		renderers.current.gi_on = true			--间接照明					
		renderers.current.gi_refractCaustics = true --间接照明.折射
		renderers.current.gi_reflectCaustics = false --间接照明.反射
		renderers.current.gi_primary_type = 0	--间接照明.首次倍增.引擎
		renderers.current.gi_primary_multiplier = 1.0 --间接照明.首次倍增
		renderers.current.gi_secondary_type = 3  --间接照明.二次倍增.引擎
		renderers.current.gi_secondary_multiplier = 0.8 
		renderers.current.gi_irradmap_minRate = -3
		renderers.current.gi_irradmap_maxRate = 0
		renderers.current.gi_irradmap_subdivs = 68--发光贴图.半球细分
		renderers.current.gi_irradmap_interpSamples = 30--发光贴图.查补采样
		renderers.current.gi_irradmap_colorThreshold = 0.2
		renderers.current.gi_irradmap_normalThreshold = 0.1
		renderers.current.gi_irradmap_distThreshold = 0.3
		renderers.current.gi_irradmap_showCalcPhase = true
		renderers.current.gi_irradmap_showdirectlight = true
		renderers.current.lightcache_adaptiveTracing = on
		renderers.current.Lightcache_subdivs = 1500 --灯光缓存细分
		renderers.current.lightcache_showCalcPhase = 1
		renderers.current.imageSampler_type = 2 --采样类型（只是应）
		renderers.current.filter_on = true  --开启抗锯齿
		renderers.current.filter_kernel = Catmull_Rom()  --抗锯齿类型
		renderers.current.options_defaultLights = false --关闭默认场景灯光
		renderers.current.environment_gi_on = true
		renderers.current.colorMapping_type =6
		renderers.current.environment_gi_color = [255,255,255]
		renderers.current.environment_gi_color_multiplier = 1
		renderers.current.environment_rr_on = true
		renderers.current.environment_rr_color = [0,0,0]
		renderers.current.environment_rr_color_multiplier = 1.0
		renderers.current.system_region_x = 50 --渲染区域大小
		renderers.current.qmc_earlyTermination_threshold= 0.01  --Noise_threshold
		renderers.current.qmc_earlyTermination_amount=0.1 --Adaptive_amount
		renderers.current.system_vrayLog_show = false
)

		on vhuise_chk_bx changed state do             ---- 开启/关闭 单一材质渲染
		(
			if state == on do 
			(
			renderers.current.options_overrideMtl_on=true
		renderers.current.options_overrideMtl_mtl=VRayMtl diffuse:(color 220 220 220)

			)
			if state == off then 
			(
			renderers.current.options_overrideMtl_on=false
			)
		) 

		on vgi_keep changed state do 
		(
		if state == on do 
			(
			renderers.current.adv_irradmap_mode = 2
			renderers.current.adv_irradmap_saveFileName = "c:\a.vrmap"
			renderers.current.adv_irradmap_loadFileName = "c:\a.vrmap"
			
			renderers.current.lightcache_saveFileName = "c:\a.vrlmap"
			renderers.current.lightcache_mode = 2
			renderers.current.lightcache_loadFileName = "c:\a.vrlmap"
			)
		if state == off then 
			(	
			renderers.current.adv_irradmap_mode = 0
			renderers.current.lightcache_mode = 0
			renderers.current.adv_irradmap_saveFileName = ""
			renderers.current.adv_irradmap_loadFileName = ""
			renderers.current.lightcache_saveFileName = ""
			renderers.current.lightcache_loadFileName = ""			
			)	
		)

)



----------------------------------------------------------------------------------------------------------------
createDialog  a 200 230 200 125 style: #(#style_resizing, #style_toolwindow, #style_sysmenu)

