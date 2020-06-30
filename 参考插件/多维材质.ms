--macroScript MicrotestV1_0 category:"maxtool"
--(
--------------------------------------------------------------------------------------------------------rollout param1 开始
rollout param1 "关于" width:162 height:300
(
	button btn1 "脚 本 说 明" pos:[6,8] width:150 height:25
	on btn1 pressed do
		messagebox"本脚本由***开发编写,用于完成一些琐碎的工作和一些容易忽略的问题\n技术支持:王军;郭纯忠" title:"脚本说明"
)
----------------------------------------------------------------------------------------------------------------------------rollout param1 完
--*************************************************************************************************************************--
-----------------------------------------------------------------------------------------------------------------------------rollout param2开始

rollout param2 "删除多余多维子材质" width:162 height:300
(
local theMat, uniqueMats, mapTo, theObj
struct aMat (theInstance, theDiffusemap)

	pickbutton PickObj "优 化 材 质" pos:[6,8] width:150 height:25
	 

label l_nMatIDs_t "物体最多ID数目:" across:2 align:#left
label l_nMatIDs_n ""

label l_nSubMats_t "之前子材质数目:" across:2 align:#left
label l_nSubMat_n ""

label l_nUniqueSubMats_t "当前子材质数目:" across:2 align:#left
label l_nUniqueSubMat_n ""

	on PickObj picked obj do ---转化网格
	(	theObj=obj
	     select obj
		--if classof obj != Editable_mesh do
		--	if canConvertTo obj mesh then
		--		convertToMesh obj
		--	else
		--		throw "Cannot convert object to Editable Mesh"
		macros.run "Modifier Stack" "Convert_to_Mesh"
		PickObj.text=obj.name
		
		theMat=obj.material --获取材质
		if classof theMat != Multimaterial do throw "Object Material not a MultiMaterial"
		l_nSubMat_n.text=theMat.numsubs as string
		local SubMatUsed=#()
		for f=1 to obj.numfaces do
			SubMatUsed[getFaceMatID obj f]=true
		    l_nMatIDs_n.text=SubMatUsed.count as string
		    uniqueMats=#()
		    mapTo=#()
		for m=1 to theMat.numsubs do
		(	if SubMatUsed[m] != true do continue
			local thisMatDBitmap=undefined
			if classof theMat[m] == StandardMaterial do
				if classof theMat[m].diffusemap == Bitmaptexture do
					thisMatDBitmap=theMat[m].diffusemap.filename
			if thisMatDBitmap == undefined do
			(	append uniqueMats (aMat theMat[m] thisMatDBitmap)
				mapTo[m]=uniqueMats.count
				continue
			)
			local foundMatch=false
			for p=1 to uniqueMats.count do
				if thisMatDBitmap == uniqueMats[p].theDiffusemap do
				(	mapTo[m]=p
					foundMatch=true
					continue
				)
			if not foundMatch do 
			(	append uniqueMats (aMat theMat[m] thisMatDBitmap)
				mapTo[m]=uniqueMats.count
			)
		)
		l_nUniqueSubMat_n.text=uniqueMats.count as string
	
     	local NewMMat=Multimaterial numsubs:uniqueMats.count name:theObj.name
		for m=1 to uniqueMats.count do
			NewMMat[m]=copy uniqueMats[m].theInstance
		for f=1 to theObj.numfaces do
		(	local oldID=getFaceMatID theObj f
			setFaceMatID theObj f mapTo[oldID]
		)
		theObj.material=NewMMat
		update theObj
		PickObj.text= "第一步：优化材质"
		
		meditMaterials[1]=theobj.material
	   	     a=meditMaterials[1].materialIDList
			 for i = 1 to a.count do 
				(
				showTextureMap meditMaterials[1].materialList[a[i]] on
				)
	)
	  
)

---------------------------------------------------------------------------------------------------------------------rollout param2完
--********************************************************************************************************************--
---------------------------------------------------------------------------------------------------------------------rollout param3 开始
rollout param3 "清空材质球" width:162 height:321
(
     local chkname=#()
	button btn1 "清空材质球" pos:[17,5] width:128 height:21
	button btn5 "清空勾选" pos:[102,27] width:60 height:18
	GroupBox grp1 "预保留的材质球" pos:[2,47] width:158 height:266
	checkbox chk1 "chkbox1" pos:[60,65] width:14 height:11 checked:false
	label lbl2 "材质球1" pos:[6,65] width:50 height:18
	label lbl3 "材质球7" pos:[6,185] width:50 height:18
	label lbl4 "材质球2" pos:[6,85] width:50 height:18
	label lbl5 "材质球3" pos:[6,105] width:50 height:18
	label lbl6 "材质球6" pos:[6,165] width:50 height:18
	label lbl7 "材质球8" pos:[6,205] width:50 height:18
	label lbl8 "材质球9" pos:[6,225] width:50 height:18
	label lbl9 "材质球11" pos:[6,265] width:60 height:18
	label lbl10 "材质球10" pos:[6,245] width:60 height:18
	label lbl11 "材质球4" pos:[6,125] width:50 height:18
	label lbl12 "材质球5" pos:[6,145] width:50 height:18
	label lbl13 "材质球12" pos:[6,285] width:60 height:18
	checkbox chk2 "chkbox2" pos:[60,85] width:14 height:11 checked:false
	checkbox chk3 "chkbox3" pos:[60,105] width:14 height:11 checked:false
	checkbox chk4 "chkbox4" pos:[60,125] width:14 height:11 checked:false
	label lbl14 "材质球14" pos:[80,85] width:60 height:18
	label lbl15 "材质球13" pos:[80,65] width:60 height:18
	label lbl30 "材质球15" pos:[80,105] width:60 height:18
	label lbl31 "材质球16" pos:[80,125] width:60 height:18
	label lbl32 "材质球17" pos:[80,145] width:60 height:18
	label lbl33 "材质球18" pos:[80,165] width:60 height:18
	label lbl34 "材质球19" pos:[80,185] width:60 height:18
	label lbl35 "材质球20" pos:[80,205] width:60 height:18
	label lbl36 "材质球21" pos:[80,225] width:60 height:18
	label lbl37 "材质球22" pos:[80,245] width:60 height:18
	label lbl38 "材质球23" pos:[80,265] width:60 height:18
	label lbl39 "材质球24" pos:[80,285] width:60 height:18
	checkbox chk5 "chkbox5" pos:[60,145] width:14 height:11 checked:false
	checkbox chk6 "chkbox6" pos:[60,165] width:14 height:11 checked:false
	checkbox chk7 "chkbox7" pos:[60,185] width:14 height:11 checked:false
	checkbox chk8 "chkbox8" pos:[60,205] width:14 height:11 checked:false
	checkbox chk9 "chkbox9" pos:[60,225] width:14 height:11 checked:false
	checkbox chk10 "chkbox10" pos:[59,245] width:14 height:11 checked:false
	checkbox chk11 "chkbox11" pos:[60,265] width:14 height:11 checked:false
	checkbox chk12 "chkbox12" pos:[60,285] width:14 height:11 checked:false
	checkbox chk13 "chkbox13" pos:[140,65] width:14 height:11 checked:false
	checkbox chk14 "chkbox14" pos:[140,85] width:14 height:11 checked:false
	checkbox chk15 "chkbox15" pos:[140,105] width:14 height:11 checked:false
	checkbox chk18 "chkbox18" pos:[140,165] width:14 height:11 checked:false
	checkbox chk17 "chkbox17" pos:[140,145] width:14 height:11 checked:false
	checkbox chk16 "chkbox16" pos:[140,125] width:14 height:11 checked:false
	checkbox chk19 "chkbox19" pos:[140,185] width:14 height:11 checked:false
	checkbox chk20 "chkbox20" pos:[140,205] width:14 height:11 checked:false
	checkbox chk24 "chkbox24" pos:[140,285] width:14 height:11 checked:false
	checkbox chk23 "chkbox23" pos:[140,265] width:14 height:11 checked:false
	checkbox chk22 "chkbox22" pos:[140,245] width:14 height:11 checked:false
	checkbox chk21 "chkbox21" pos:[140,225] width:14 height:11 checked:false
---------------------------------------------------------------------------------------------------------------------rollout param3完
on btn1 pressed do
	(    chkname[1]=chk1.checked
		chkname[2]=chk2.checked
		chkname[3]=chk3.checked
		chkname[4]=chk4.checked
		chkname[5]=chk5.checked
		chkname[6]=chk6.checked
		chkname[7]=chk7.checked
		chkname[8]=chk8.checked
		chkname[9]=chk9.checked
		chkname[10]=chk10.checked
		chkname[11]=chk11.checked
		chkname[12]=chk12.checked
		chkname[13]=chk13.checked
		chkname[14]=chk14.checked
		chkname[15]=chk15.checked
		chkname[16]=chk16.checked
		chkname[17]=chk17.checked
		chkname[18]=chk18.checked
		chkname[19]=chk19.checked
		chkname[20]=chk20.checked
		chkname[21]=chk21.checked
		chkname[22]=chk22.checked
		chkname[23]=chk23.checked
		chkname[24]=chk24.checked   
		for i in 1 to 24 do		(
		if chkname[i]!=true do		   (
		      meditMaterials[i] = Standardmaterial()		      meditMaterials[i].name = i as string + " - Default"
		    )		 )
	)
---------------------------------------------------------------------------------------------------------------------rollout param3完
on btn5 pressed  do
(
chk1.checked=off
chk2.checked=off
chk3.checked=off
chk4.checked=off
chk5.checked=off
chk6.checked=off
chk7.checked=off
chk8.checked=off
chk9.checked=off
chk10.checked=off
chk11.checked=off
chk12.checked=off
chk13.checked=off
chk14.checked=off
chk15.checked=off
chk16.checked=off
chk17.checked=off
chk18.checked=off
chk19.checked=off
chk20.checked=off
chk21.checked=off
chk22.checked=off
chk23.checked=off
chk24.checked=off
)
)
---------------------------------------------------------------------------------------------------------------------rollout param3完
--********************************************************************************************************************--
---------------------------------------------------------------------------------------------------------------------rollout param4 开始

rollout param4 "材质修复" width:162 height:300
(
  local c
  local str
--按钮1	
	button btn1 "修复多维材质类型与显示" pos:[0,8] width:165 height:25
--按钮2	
	button btn2 "命名及修复多维材质名称" pos:[0,71] width:165 height:25
--按钮3
	button btn5 "命名standard材质球名称" pos:[0,40] width:165 height:25

--------------------------------------------------------------------------------------------按钮1开始
----------------------------------------------------------------------------------------按钮1完
----------------------------------------------------------------------------------------按钮2	开始
--------------------------------------------------------------------------------------------------------------按钮2完
--------------------------------------------------------------------------------------------------------------按钮3开始
	button btn4 "透明贴图赋予" pos:[0,103] width:165 height:25
---------------------------------------------------------------------------------------------------------------------按钮3完	
on btn1 pressed do
	( 	--global str = #()
		g=selection.count
		if g !=1 or classof $.material != Multimaterial then 
		messagebox "请选择一个具有多维材质的物体！！"title:"类型不匹配"
		else
			(
			j = $.material.numsubs
	 		for i in 1 to j do
				( 
				$.material.materialList[i].shaderType = 1
				$.material.materialList[i].adTextureLock = on
				showTextureMap $.material.materialList[i] on
				)
			messagebox "材质类型与显示修复完成！"title:"完成！"
			)
	)
---------------------------------------------------------------------------------------------------------------------按钮3完	
on btn2 pressed do
	( 	
		g=selection.count
	if g !=1 or classof $.material != Multimaterial then 
		messagebox "请选择一个具有多维材质的物体！"title:"类型不匹配"
	else
	(----------else1
		pickedobj = $.material
		j = pickedobj.numsubs
		$.material.name = $.name
		--global str = #() 
	     c=1
	     str = #()
		for i in 1 to j do
		(       
			if $.material.materialList[i].diffuseMap == undefined then
				(
				
	              str[c]=i as string + "号子材质没有diffuse贴图"
				c=c+1
				--ttr=i as string + "号材质没有diffuse贴图"
				--messagebox ttr
				)
			else
			 (	a=getFilenameFile $.material.materialList[i].diffuseMap.filename
				$.material.materialList[i].name=a
			     $.material.materialList[i].diffuseMap.name = a
				m = getFilenameFile $.material.materialList[i].diffuseMap.filename
				n = getFilenamepath $.material.materialList[i].diffuseMap.filename
				o = getFilenameType $.material.materialList[i].diffuseMap.filename
				p = maxFilepath
				temname = n+m+o
				semname = p+m+o
				l=(getFiles temname).count
				k=(getFiles semname).count
				if l ==0 and k ==0 do
					(
					str[c]=i as string + "号子材质diffuse贴图丢失"
					c=c+1
					)
	              if $.material.materialList[i].opacityMap != undefined do 
		   
		              (  	--a=getFilenameFile $.material.materialList[i].diffuseMap.filename
				         $.material.materialList[i].opacityMap.name = a
				         $.material.materialList[i].opacityMap.filename = a+"_alpha.jpg"
		                  m = getFilenameFile $.material.materialList[i].opacityMap.filename
				         n = getFilenamepath $.material.materialList[i].opacityMap.filename
				         o = getFilenameType $.material.materialList[i].opacityMap.filename
				         p = maxFilepath
				         temname = n+m+o
				         semname = p+m+o
				         l=(getFiles temname).count
				         k=(getFiles semname).count
	                          if l ==0 and k ==0 do
					           (
					              str[c]=i as string + "号子材质opcity贴图丢失"
					              c=c+1
					           )
	                    )
				)
	
	
				      --
	                    --$.material.materialList[i].opacityMap.bitmaptex.Reload()
	      )----------end for
			
	if c==1 then
		messagebox "修复材质名称完成！"title:"完成！"
	                      
	else
		(   
		    rollout diffusemaperror "没有被命名的子材质" width:400 height:300
				(
				    listbox diffusemaperror_cbx "通道列表" pos:[11,12] width:300 height:10 items:str
				 )
			createDialog diffusemaperror "没有被命名的子材质"
		 )
	    )----------end eles1
	)----------end btn2
---------------------------------------------------------------------------------------------------------------------按钮3完	
on btn5 pressed do
	( 	c=1
	     str = #()
	     for i in 1 to 24 do
		   (
		        if classof meditMaterials[i] == Standardmaterial do
				  (
				     if meditMaterials[i].diffuseMap != undefined do
					 (
					     m = getFilenameFile meditMaterials[i].diffuseMap.filename
				         n = getFilenamepath meditMaterials[i].diffuseMap.filename
				         o = getFilenameType meditMaterials[i].diffuseMap.filename
				         p = maxFilepath
				         temname = n+m+o
				         semname = p+m+o
				         l=(getFiles temname).count
				         k=(getFiles semname).count
				            if l ==0 and k ==0 then
					          (
					             str[c]=i as string + "号材质diffuse贴图丢失"
					             c=c+1
					          )
						   else
						   (
						         a=getFilenameFile meditMaterials[i].diffuseMap.filename
				                  meditMaterials[i].name=a
			                       meditMaterials[i].diffuseMap.name = a
							 if meditMaterials[i].opacityMap != undefined do
							      (
								         meditMaterials[i].opacityMap.name = a
								         --meditMaterials[i].opacityMap.filename = a+"_alpha.jpg"
						                  m = getFilenameFile meditMaterials[i].opacityMap.filename
								         n = getFilenamepath meditMaterials[i].opacityMap.filename
								         o = getFilenameType meditMaterials[i].opacityMap.filename
								         p = maxFilepath
								         temname = n+m+o
								         semname = p+m+o
								         l=(getFiles temname).count
								         k=(getFiles semname).count
					                          if l ==0 and k ==0 do
									           (
									              str[c]=i as string + "号材质opcity贴图丢失"
									              c=c+1
									           )
	                                   )
	                            )
	                      )
	               )
	        )----------end for
		if c==1 then
		   messagebox "材质名称完成！"title:"完成！"
	     else
			(   
				rollout diffusemaperror "丢失的材质" width:400 height:250
					(
					    listbox diffusemaperror_cbx "丢失的材质列表" pos:[11,12] width:300 height:10 items:str
					 )
				createDialog diffusemaperror "丢失的材质"
	          )
	)----------end btn5
---------------------------------------------------------------------------------------------------------------------按钮3完	
on btn4 pressed  do
(
	 nond=medit.GetActiveMtlSlot()
	 if classof meditMaterials[nond]!= Standardmaterial then
	 messagebox "所选材质型不是标准材质"title:"错误！"
	 else(
	
						if meditMaterials[nond].diffuseMap == undefined then
							messagebox "所选材质没有diffuse贴图"title:"完成！"
						else
							(
							m = getFilenameFile meditMaterials[nond].diffuseMap.filename
							n = getFilenamepath meditMaterials[nond].diffuseMap.filename
							o = getFilenameType meditMaterials[nond].diffuseMap.filename
							p = maxFilepath
							kk=0
							mp=mapPaths.count ()
										
							for mpn in 1 to mp do
								(
								gq=mapPaths.get(mpn)+ "\\" 
								remname = gq+m+o
								jk=(getFiles remname).count
								if jk != 0 then
								(kk = 1
								exit)
								)
							temname = n+m+o
							semname = p+m+o
							l=(getFiles temname).count
							k=(getFiles semname).count
							if l !=1 and k !=1 and kk !=1 then
								messagebox "所选材质diffuse贴图丢失"title:"完成！"
							else
								(
								a=getFilenameFile meditMaterials[nond].diffuseMap.filename
								meditMaterials[nond].name=a
								meditMaterials[nond].diffuseMap.name = a
									
										om = m+"_alpha"
										kk=0
										mp=mapPaths.count ()
										
											for mpn in 1 to mp do
											(
												gq=mapPaths.get(mpn)+ "\\" 
												remname = gq+om+o
												jk=(getFiles remname).count
												if jk != 0 then
													(kk = 1
													exit)
													
											)
										temname = n+om+o
										semname = p+om+o
										l=(getFiles temname).count
										k=(getFiles semname).count
										if l !=0 or k !=0 or kk !=0 then
											( 
	 										meditMaterials[nond].opacityMap = Bitmaptexture fileName:semname
											meditMaterials[nond].opacityMap.name = a
											medd=m+o
											mfdd=om+o
											if l == 1 do
											(meditMaterials[nond].opacityMap.filename = temname
											str="透明贴图添加完成！\n在"+n as string+"发现\n"+medd as string+"\n的透明贴图\n"+mfdd as string
											messagebox str title:"完成！")
											
											if l != 1 and k == 1 do										
											(meditMaterials[nond].opacityMap.filename = semname
											str="透明贴图添加完成！\n在"+p as string+"发现\n"+medd as string+"\n的透明贴图\n"+mfdd as string
											messagebox str title:"完成！")
											
											
											--if l != 1 and k != 1 and kk == 1 do
											--(meditMaterials[nond].opacityMap.filename = remname
											--str="透明贴图添加完成！\n在"+gq as string+"发现\n"+medd as string+"\n的透明贴图\n"+mfdd as string
											--messagebox str title:"完成！"
											--)
											)
										else
										 messagebox "没有找到透明贴图"
	
											
	
	
											
										)
								)
						
						--messagebox "完成！"title:"完成！"
			)

	)
)
---------------------------------------------------------------------------------------------------------------------rollout param4完
--*****************************************************************************************************************--
---------------------------------------------------------------------------------------------------------------------rollout param5开始
rollout param5 "多维材质贴图检查" width:162 height:300
(      
      local n
   --global error=#()
   --global error_1=#()
      local error
      local error_1
--button btn1 "是否缺少Diffuse贴图" pos:[6,8] width:150 height:25
button btn2 "多维材质贴图检查" pos:[6,15] width:150 height:25

--按钮1
 /*on btn1 pressed do
		( 	
			if $ selection.count!=1 or classof $.material != Multimaterial then 
				messagebox "请选择一个具有多维材质的物体！"title:"请选择一个具有多维材质的物体！"
				else
					(
					j = $.material.numsubs
					for i in 1 to j do
						(       
							if $.material.materialList[i].diffuseMap == undefined do
							(
							str=i as string + "号材质没有diffuse贴图"
							messagebox str
							)
						)
					messagebox "检查完成！"title:"检查完成！"
					)
		)*/
--按钮2

on btn2 pressed do
	(     error=#()
           error_1=#() 
          local n=1
	     if selection.count!=1 or classof $.material != Multimaterial then 
		   messagebox "请选择一个具有多维材质的物体！"title:"类型不匹配"
	    else     ---------else1
		   ( error=#()
              error_1=#()
			local j = $.material.numsubs
			for i in 1 to j do    ----------for1
			     (       
			        if $.material.materialList[i].diffuseMap == undefined then
			           (
			             error[n]=i as string + "号子材质没有diffuse贴图"
					    error_1[n]=i as string + "号子材质没有diffuse贴图"
			             n=n+1
			            )
			        else ----------else2
			            ( 
						local v = getFilenameFile $.material.materialList[i].diffuseMap.filename
						local f = getFilenamepath $.material.materialList[i].diffuseMap.filename
						local g = getFilenameType $.material.materialList[i].diffuseMap.filename
						local h = maxFilepath
						local gq=""
						local remname=""
						local kk=0
						local mp=mapPaths.count()
						for mpn in 1 to mp do
					     (
							gq=mapPaths.get(mpn)+ "\\" 
							remname = gq+v+g
							jk=(getFiles remname).count
							if jk != 0 then
								(kk = 1
								exit)
							
					     )
						temname = f+v+g
						semname = h+v+g
						r=(getFiles temname).count
						s=(getFiles semname).count
						if r ==0 and s ==0 and kk ==0 then
						   (
						     error[n]=i as string + "号子材质diffuse贴图丢失"
							 error_1[n]=i as string + "号子材质diffuse贴图丢失"
							n=n+1
						    )
						else   ----------else3
                              (	
			                 y= $.material.materialList[i].diffusemap.bitmap.height
			                 z= $.material.materialList[i].diffusemap.bitmap.width				
	                          swich1=on
	                          swich2=on
	
                              for k in 1 to 10 do
					          (
					             a=pow(2)(k)
                                    if y ==a do
							      swich1=off
                                   if z ==a do
							      swich2=off
					          )
					     if swich1==on or swich2==on do
					         (
							 error[n]=i as string +"号子材质的diffuse贴图不符合规范！贴图分辨率为"+y as string+"×"+z as string
							  if s==1 and r==0 and kk==0 then
							     error_1[n]=semname
						     else 
							     error_1[n]=temname
							 n=n+1
                                 )
					   

                               )----------end else3

		     	         ) ----------end else2
				   if $.material.materialList[i].opacityMap != undefined do
			              /*(
			               error[n]=i as string + "号子材质没有opcity贴图"
					      error_1[n]=i as string + "号子材质没有opcity贴图"
			               n=n+1
			               )*/
						 --else
						 (      ----------if
						         vv = getFilenameFile $.material.materialList[i].opacityMap.filename
						         ff = getFilenamepath $.material.materialList[i].opacityMap.filename
						         gg = getFilenameType $.material.materialList[i].opacityMap.filename
								hh = maxFilepath
								temname_1 = ff+vv+gg
								semname_1 = hh+vv+gg
								rr=(getFiles temname_1).count
								ss=(getFiles semname_1).count
								if rr ==0 and ss ==0 then
								   (
								     error[n]=i as string + "号子材质opcity贴图丢失"
									error_1[n]=i as string + "号子材质opcity贴图丢失"
									n=n+1
								    )
								else   --------else4
		                              (	
					                 yy= $.material.materialList[i].opacityMap.bitmap.height
					                 zz= $.material.materialList[i].opacityMap.bitmap.width				
			                          swich3=on
			                          swich4=on
			
		                              for k in 1 to 10 do
							          (
							             a=pow(2)(k)
		                                    if yy ==a do
									      swich3=off
		                                   if zz ==a do
									      swich4=off
							          )
							     if swich3==on or swich4==on do
							         (
									 error[n]=i as string +"号子材质的opacity贴图不符合规范！贴图分辨率为"+yy as string+"×"+zz as string
							          if rr==0 and ss==1 then
							              error_1[n]=semname_1
						              else error_1[n]=temname_1
									n=n+1
                                          )

						            )----------else4
		 
				             )----------end if
				     )  ----------end for1            
               if n!=1 then
			       ( 
			         rollout diffuse_error "通道贴图错误" width:550 height:400
			         ( 
					   local w = 1
			        	   listbox diffuserror_cbx "通道贴图错误" pos:[11,12] width:500 height:20 items:error
			        	   edittext edt2 "图片路径" pos:[14,341] width:496 height:26 text:error_1[w]
			        	   on diffuserror_cbx selected sel do
				          (
                           	    w=diffuserror_cbx.selection
						    edt2.text=error_1[w]
						)
                       
			        
					)
				   createDialog diffuse_error "通道贴图错误"

				   )
		     else 
			       messagebox "检查完成！没有错误"title:"检查完成！"	
   
      )----------end else1
	         



)----------end btn2
)----------end rollout param5
---------------------------------------------------------------------------------------------------------rollout param5完
--*********************************************************************************************************--
---------------------------------------------------------------------------------------------------------
rollout param6 "others" width:162 height:320
(
    local nousemap
    local b
	button btn1 "当前路径没用贴图查找" pos:[6,15] width:150 height:25
	button btn2 "清除光滑组" pos:[13,52] width:136 height:30
---------------------------------------------------------------------------------------------------------	
	button btn3 "一键导出3ds" pos:[26,90] width:105 height:29
---------------------------------------------------------------------------------------------------------	

	label 说明 "说明：先塌陷成mesh，pivot到物体中心，在当前max文件夹下生成.3ds文件" pos:[3,126] width:152 height:73
	button btn4 "按物体的面detach" pos:[12,194] width:138 height:38
---------------------------------------------------------------------------------------------------------

	button btn5 "按多维材质IDdetach" pos:[12,249] width:138 height:38
---------------------------------------------------------------------------------------------------------

	on btn1 pressed do
	(
	g=selection.count
	if g !=1 or classof $.material != Multimaterial then 
	messagebox "请选择一个具有多维材质的物体！！"title:"类型不匹配"
	else
	(
		pathmap=maxFilepath+"*.jpg"
		a=getFiles pathmap
		pickedobj = $.material
		yi= pickedobj.numsubs
		xi=a.count
		nousemap=#()
		b=1
		for i in 1 to xi do
		(
		      for j in 1 to yi do
			  (     
			      if $.material.materialList[j].diffuseMap != undefined do
		
					(  
					 if a[i]==$.material.materialList[j].diffuseMap.filename then
					     exit
					  else 
					      (  
						    if $.material.materialList[j].opacityMap != undefined then
						      (
		                              if a[i]==$.material.materialList[j].opacityMap.filename then
		                                 exit
								  else
									(
								           if j==yi do
									  (
									         nousemap[b]=a[i]
									         b=b+1
									  )
								    )
							  )
						   else
						   (
						     	if j==yi do
									  (
									    nousemap[b]=a[i]
									    b=b+1
									  )
						   )
						)
					)	  
		       )
		)
		
		if b!=1 then
		         ( 
				rollout nousemaperror "当前max文件夹下没有用到的贴图" width:550 height:400
				  ( 
					local w = 1
					listbox nousemaperror_cbx "没用到的贴图" pos:[11,12] width:500 height:20 items:nousemap
					edittext edt2 "图片路径" pos:[14,341] width:496 height:26 text:nousemap[w]
					on nousemaperror_cbx selected sel do
					 (
			            w=nousemaperror_cbx.selection
					   edt2.text=nousemap[w]
					 )
		            )
				createDialog nousemaperror "当前max文件夹下没有用到的贴图"
		
				)
		else 
			 messagebox "检查完成！没有错误"title:"没有错误！"
	  )	
	)
---------------------------------------------------------------------------------------------------------
on btn2 pressed do
	(
	g=selection.count
	if g==0 do 
	messagebox  "请选择一个或多个物体！！"title:"请选择物体！"
	if g==1 do 
	(	
		convertto $ editable_poly
		face_numer=$.GetNumFaces()
		$.EditablePoly.SetSelection #Face #{1..face_numer}
		$.ButtonOp #ClearSmoothingGroups
		convertTo $ TriMeshGeometry
		messagebox "完成！"title:"完成！"
	)
	if g>1 do 
	(	selection_all=getCurrentSelection()
	  for i in 1 to g do	
		(
		convertto selection_all[i] editable_poly
		face_numer=selection_all[i].GetNumFaces()
		selection_all[i].EditablePoly.SetSelection #Face #{1..face_numer}
		selection_all[i].ButtonOp #ClearSmoothingGroups
		convertTo selection_all[i] TriMeshGeometry
		)
	  	messagebox "完成！"title:"完成！"
	)
	)
---------------------------------------------------------------------------------------------------------

on btn3 pressed do
	(
	if selection.count!=1 then 
	   messagebox "请选择最终完成的模型！"title:"请选择最终完成的模型！"
	else
	(
	convertTo $ TriMeshGeometry
	CenterPivot $
	a= maxFilepath
	b= maxFilename
	c=a+b
	d=getFilenameFile c
	expname=a+d+".3ds"
	exportFile expname #noPrompt
	messagebox "导出完成！"title:"完成！"
	)
	)
---------------------------------------------------------------------------------------------------------
on btn4 pressed do
(
g=selection.count
if g==0 do 
   messagebox  "请选择一个或多个物体！！"title:"请选择物体！"
if g==1 do
	(
	convertTo $ PolyMeshObject
	obj=$
	currentname=$.name
	p = polyop.getNumFaces obj
	for i in p to 2 by -1 do
	   (
	      a=currentname+"newname0"+(i-1) as string
	      polyOp.detachFaces obj #{i} asNode:true  name:a
	   )
	messagebox "完成！"title:"完成！"
     )
if g>1 do 	
   (
   selection_obj=getCurrentSelection()
   for i in 1 to g do
       (
	   convertTo selection_obj[i] PolyMeshObject
	   currentname=selection_obj[i].name
	   p = polyop.getNumFaces selection_obj[i]
	   for j in p to 2 by -1 do
	   (
	      a=currentname+"newname0"+(j-1) as string
	      polyOp.detachFaces selection_obj[i] #{j} asNode:true  name:a
	   )
	   )
   messagebox "完成！"title:"完成！"
   )
)
---------------------------------------------------------------------------------------------------------
on btn5 pressed do
(
g=selection.count
if g==0 do 
messagebox "请选择物体！"title:"请选择物体！"
if g==1  do
(
  if classof $.material == Multimaterial then
  (
    convertTo $ PolyMeshObject
    obj=$
	j = obj.material.numsubs
	currentname=$.name
	objcollect=#()
	l=1
	for i in j to 1 by -1 do
	  (
		a="newname"+(i) as string
		obj.EditablePoly.selectByMaterial i
		facegroup=polyOp.getFaceSelection obj
		objcollect=polyOp.detachFaces obj facegroup asNode:true  name:a
	  )
	b=select $'newname*'
	selection_obj=getCurrentSelection()
	for k in j to 1 by -1 do
	  (
		selection_obj[l].material=obj.material.materialList[k]
		selection_obj[l].name=currentname+"detachobj"+k as string
		convertTo selection_obj[l] TriMeshGeometry
		l=l+1
	  )
	delete obj
	messagebox "完成！"title:"完成！"
  )
  else 
  (
   messagebox "请选择一个或多个具有多维材质的物体！！"title:"类型不匹配"
  )
)

if g>1 do 
(
  selection_obj=getCurrentSelection()
  d=on
  for c in 1 to g do
	(
	if classof selection_obj[c].material != Multimaterial do
	d=off
	)
   if d==off then
   messagebox "请选择一个或多个具有多维材质的物体！！"title:"类型不匹配"
   else
	   (
	 for i in 1 to g do
	   (
		convertTo selection_obj[i] PolyMeshObject
		currentname=selection_obj[i].name
		j = selection_obj[i].material.numsubs
		objcollect=#()
		l=1
		for m in j to 1 by -1 do
		  (
			a="newname"+(m) as string
			selection_obj[i].EditablePoly.selectByMaterial m
			facegroup=polyOp.getFaceSelection selection_obj[i]
			objcollect=polyOp.detachFaces selection_obj[i] facegroup asNode:true  name:a
		  )
		 b=select $'newname*'
		 selection_obj1=getCurrentSelection()
		 for k in j to 1 by -1 do
		  (
			selection_obj1[l].material=selection_obj[i].material.materialList[k]
			selection_obj1[l].name=currentname+"detachobj"+k as string
			convertTo selection_obj1[l] TriMeshGeometry
			l=l+1
		  )
		  delete selection_obj[i]
	
	   )
	messagebox "完成！"title:"完成！"
	)
)
)--------end btn5

)
---------------------------------------------------------------------------------------------------------rollout param6完
--*********************************************************************************************************--
---------------------------------------------------------------------------------------------------------

if floater != undefined do
(
closerolloutfloater floater
)
floater=newrolloutfloater"小脚本" 176 440
addrollout param1 floater
addrollout param2 floater
addrollout param3 floater
addrollout param4 floater
addrollout param5 floater
addrollout param6 floater
--)