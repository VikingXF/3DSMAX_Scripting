
--版权：本.强强（qq：42564365） 2004.12
--版本：1.0
--本脚本完全免费，用户可以自由使用、修改本脚本。如果本脚本给你造成数据丢失，本人概不负责。

rollout info "场景信息" 
(
	editText lb1 "物体数量: "	pos:[57,10] width:122 height:15 enabled:false
	editText lb2 "材质球数: " 	pos:[57,28] width:122 height:15 enabled:false
	button b_rf "刷新"	 	pos:[17,10] width:33 height:33
	on b_rf pressed do (lb1.text=$*.count as string; lb2.text=scenematerials.count as string)
)
------------------------------------------------------------------
rollout sceneCleanUp "场景整理"
(
	local num_s=0--第几屏
	button b_clr 	"清空材质编辑器" 				width:175
	button b_get 	"将材质导入材质编辑器/下一屏" 	width:175
	button b_merM	"合并同名材质"				width:175
	button b_atM 	"按材质塌陷（选择/所有）物体" 		 		width:175 
	button b_colE	"分别塌陷每个物体" 		 	width:175
	button b_chan	"转换为通道渲染场景"		 	width:175 
	checkbox mConv "转换所有材质（---> Standard）" 
	------------------------------------------------------
	fn clearME = -----清空材质编辑器
	( 
		for i=1 to meditmaterials.count do 
		(
			meditmaterials[i]=standard()
			meditmaterials[i].name=(i as string+"-Default")
		)
		for i=1 to 24 do updateMTLInMedit meditmaterials[i]
		max mtledit
	)
	------------------
	fn getMat = ----将场景材质导入材质编辑器
	(
		num=(mod scenematerials.count 24) as integer
		num_sA=ceil(scenematerials.count as float/24) as integer
		for i=1 to 24 do
		(
			if i>num and num_s == num_sA then
			(
				meditMaterials[i]=standard()
				meditmaterials[i].name=(i as string+"-Default")
			)
			else		meditMaterials[i]=scenematerials[i+(num_s-1)*24]
		)
		for i=1 to 24 do updateMTLInMedit meditmaterials[i]
		max mtledit
	)
	------------------
	fn mergeM = ----合并同名材质
	(
		baseM=#()
		noUseM=#()
		--for i=1 to scenematerials.count do 
		--(
		--	mc=scenematerials[i]
		--	typeM=filterstring (mc as string) ":"
		--	if typeM[2] == "Standard" do (append baseM mc;exit )
		--)
		baseM[1]=scenematerials[1]
		numM=scenematerials.count
		for i=2 to numM do --找出场景中没有同名的所有材质（同名的只取第一个）
		(
			mc=scenematerials[i]
			--typeM=filterstring (mc as string) ":"
			--if typeM[2] == "Standard" do
			--(
				if okMtlForScene mc ==false then append baseM mc
				else 
				(
					find=0
					for j=1 to baseM.count do ( if mc.name == baseM[j].name then (find=1; exit) )
					if find==0 then append baseM mc else append noUseM mc
				)
			--)
		)
		numB=baseM.count
		numG=geometry.count
		for i=1 to numG do
		(
			for j=1 to numB do
			(
				if geometry[i].material as string !="undefined" then
				(
					if geometry[i].material.name ==baseM[j].name then geometry[i].material=baseM[j]
				)
			)
		)
		for m=1 to noUseM.count do deleteItem scenematerials (findItem scenematerials noUseM[m])
	)--end mergeM
	-------------------
	fn collByM = ----根据材质塌陷场景物体
	(
		objM=#()
		collGo=#()
		mt=#()
		geo=#()
		geoAr=geometry as array
		numM=scenematerials.count
		for i=1 to numM do ( mt[i]=scenematerials[i] as string ;	collGo[i]=0)
		gi=1 ----找出需要处理的物体
		selC=getCurrentSelection()
		selCount=selC.count
		if selCount ==0 then geo=geoAr  else
		(
			for i=1 to selCount do
			( 
				if (findItem geoAr selC[i]) != 0 then 
				(
					geo[gi]=selC[i]
					gi+=1
				)
			)
		)---
		geoCount=geo.count
		--print ("geoCount: "+geoCount as string)
		for i=1 to geoCount do --attatch
		(
			for j=1 to numM do
			(
				if geo[i].material as string == mt[j]   do
				(
					if collGo[j] == 0 then
					(
						objM[j]=geo[i]
						convertToMesh objM[j]
						collGo[j]=1
					)
					else attach objM[j] geo[i]
					exit()
				)--end if
			)--end for
		)--end for
		geo=#()
		geoAr=#()
		selC=#()
	)--end collByM
	-------------------
	fn convChan = ----将材质转换为通道渲染材质
	(
		DisableSceneRedraw()
		numM=scenematerials.count
		if numM>160 then contGo=queryBox "材质数太多超过通道能分辨的范围,需要继续（就转换前160个）吗?"  title: "警告:"
		if contGo == true or numM<161 do
		( --材质>160不处理
		if numM>160 then numM=160
		c_o=#(color 255 0 0,color 255 126 0,color 255 255 0,color 0 255 0,color 0 255 255,color 0 126 255,color 0 0 255,color 126 0 255,color 255 0 255,color 255 0 126 )
		c_f=#(color 255 0 0,color 255 126 0,color 255 255 0,color 0 255 0,color 0 255 255,color 0 126 255,color 0 0 255,color 126 0 255,color 255 0 255,color 255 0 126 )
		for i=11 to numM do
		(
			oi=(mod (i-1) 10) as integer +1
			c_c=copy c_o[oi]
			do ( c_c.s = 255- (random 0 3)*65 ; c_c.v = 255- (random 0 3)*65 ; c_c.R=c_c.R as integer ; c_c.G=c_c.G as integer ; c_c.B=c_c.B as integer )
			while ((findItem c_f c_c) > 0)
			append c_f c_c
		)
		conv_on=0
		if mConv.checked == true do conv_on=1
		for i=1 to numM do
		(
			mc=scenematerials[i]
			if (classof mc as string) == "Standardmaterial" then
			(
				mc.diffuse=c_f[i]
				mc.selfIllumAmount=100
				mc.specularlevel=0
				mc.glossiness=0
				mc.opacity=100
				mc.opacityFallOff=0
				mc.ambientMapEnable=off
				mc.diffuseMapEnable = off
				mc.specularMapEnable = off
				mc.specularLevelMapEnable = off
				mc.glossinessMapEnable = off
				mc.selfillumMapEnable = off
				--mc.opacityMapEnable = off
				mc.filterMapEnable = off
				mc.bumpMapEnable = off
				mc.reflectionMapEnable = off
				mc.refractionMapEnable = off
				mc.displacementMapEnable = off
			)
			else if conv_on == 1 do
			(
				mcS=mc as string
				mcN=mc.name
				scenematerials[i]=standard()
				mc=scenematerials[i]
				mc.name=mcN
				mc.diffuse=c_f[i]
				mc.selfIllumAmount=100
				for obj in geometry do ( if (obj.material as string) == mcS then obj.material = mc )
			)
		)--end for
		)--end 160
		EnableSceneRedraw() 
	)--end convChan
	-------------------
	on b_clr pressed do clearME()
	on b_get pressed do (if num_s>=ceil(scenematerials.count as float/24) then num_s=0; num_s+=1; getMat())
	on b_colE pressed do for i=1 to geometry.count do 	convertToMesh geometry[i]
	on b_merM pressed do (undo on (mergeM()))
	on b_atM pressed do collByM()
	on b_chan pressed do (convChan();num_s=1; getMat(); for i=1 to lights.count do if (lights[i].baseObject as string) != "Target" then lights[i].enabled=off)
)--end rollout
-------------------------------------------------------------------
rollout aboutRBF "使用说明"
(
	label l1 "版权所有：本.强强(QQ:42564365)"
	label l12 "1: 当材质调入编辑器时，如果材质数大于24，可以通过此按钮循环显示。" width:190 height:40 pos:[4,30]
	label l13 "2: 按材质塌陷物体时，如果有选择，则只塌陷选择部分。没有选择则塌陷场景所有物体。" width:190 height:40 pos:[4,75]
	label l2  "3: 转换为通道渲染功能，最大支持160个场景材质，同时灯光将被关闭。默认只转换标准材质，钩选转换所有后其他类型将被转换为标准材质。" width:190 height:70  pos:[4,120]
)
--------------------------------------------------------------------
if undefined != floaterM then closeRolloutFloater floaterM
floaterM=newRolloutFloater "BeforeRender_V1.0" 220 465
addRollout info floaterM rolledUp:false
addRollout sceneCleanUP floaterM
addrollout aboutRBF floaterM rolledUp:true
--------------------------------------
