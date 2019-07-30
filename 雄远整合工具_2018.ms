if cj_tools != undefined then closeRolloutFloater cj_tools
	defaultRelfectMap = "d:/_common/refl.dds"
		defaultBlackMap = "d:/_common/black.dds"
		defaultEnvMap = "d:/_common/env.dds"





fn SnAttach =                 -----------------合并
(
if Selection.count != 0 then
	(
		
		BadX = #()
		GoodX = #()
		
		ArrayObj = Selection as Array

		Count = ArrayObj.count
		
		For i = 1 to Count do
		(
			try(
					if superClassof ArrayObj[i] == GeometryClass and Classof ArrayObj[i] != BoneGeometry and Classof ArrayObj[i] !=Biped_Object then
				(
					ConvertTo ArrayObj[i] PolyMeshObject
					
					PolyOp.getNumFaces ArrayObj[i] --Check
					
					Append GoodX ArrayObj[i]
				)
			)
			catch(	Append BadX ArrayObj[i].name)
		)
		
		if badX.count != 0 then
		(
			TextX = "出错: 无法塌陷: " + BadX as string
			messageBox TextX Title:"Collapse Multiple To Poly"
		)
		
		Master = GoodX[1]
		
		for O = 2 to GoodX.count do
		(
			Master.EditablePoly.Attach ArrayObj[O] Master
		)
		
		CenterPivot Master
		ResetXForm Master
		
		ConvertTo Master PolyMeshObject
		
		try ( Master.name = getFilenameFile maxFileName ) catch ( Master.name = "capobject" )
		Select Master
		
		Max Modify Mode
		
	)
	else( Messagebox "    No Selection ... !!          " Title:"Collapse Multiple To Poly"	)

)




fn SelectHelps =                --------------选择多余物体
(

actionMan.executeAction 0 "277"  -- Tools: Unhide All
hide lights
clearSelection()
select helpers
selectMore cameras
selectMore shapes
selectMore systems
selectMore spacewarps
actionMan.executeAction 0 "311"  -- Tools: Zoom Extents All Selected


)


fn selectall =   -------选择所有并显示所有
(


actionMan.executeAction 0 "40021"  -- Selection: Select All
actionMan.executeAction 0 "311"  -- Tools: Zoom Extents All Selected


)





rollout scencecheck "陈雄远模型_检查流程" width:364 height:538
(



fn SelctionCount = scencecheck.lbx1.items = #("请选择模型")   ----------判断选择物体

	fn Scaleinformation =   -------------------------判断法线
	(
	for o in selection do
	(
	if (o.scale) != [1,1,1] do scencecheck.lbx1.items = append scencecheck.lbx1.items ( o.name + "没 xform,可能会出现法线问题" )

	   )
	      

	   
	)

fn Xfromobject =  -------------xform
(
try
(

  for i in geometry do  ------selection
		(
			------- Scaleinformation()
			  ResetXForm i
		       convertTopoly i
	     )
	---------scencecheck.lbx1.items = append scencecheck.lbx1.items ( "xform成功" )
	)		
catch
 (
  tempitm = scencecheck.lbx1.items
 SomeError ="xform没有成功" 
 Newitm = append tempitm SomeError 
 scencecheck.lbx1.items = Newitm
)

 )

fn removeIsoVerts =   ---------------移除顶点
(
   try 
    (
 for i in selection do i.EditablePoly.deleteIsoVerts ()

	   ) 
   catch
   (
  tempitm = scencecheck.lbx1.items
 SomeError ="去除顶点-\没有成功,可能有不可编辑的物体" 
 Newitm = append tempitm SomeError 
 scencecheck.lbx1.items = Newitm
  )
 
)
 
fn weldvers =                             -----------焊接顶点
(
for i in selection do
		(
		try
		(
		
		   i.weldThreshold = scencecheck.spn_cweldthr.value
	        polyOp.weldVertsByThreshold i #{1..(i.GetNumVertices())};
						)
			
			catch 
			(
			select i
		  tempitm = scencecheck.lbx1.items
 SomeError =i.name+"焊接顶点没有成功" 
 Newitm = append tempitm SomeError 
 scencecheck.lbx1.items = Newitm
			)
			)

)

fn FaceAutosmooth =              ----------自动光滑
(
    for i in selection do with undo on
   (
   try 
    (
     selnone = polyOp.getFaceSelection i
     facenum = polyOp.getNumFaces i
	 polyOp.setFaceSelection i #{1..facenum}
	 i.EditablePoly.autosmooth ()
	 polyOp.setFaceSelection i selnone
		
	 )
	 catch
	 (
	  tempitm = scencecheck.lbx1.items
 SomeError =i.name+"自动光滑=\没有成功" 
 Newitm = append tempitm SomeError 
 scencecheck.lbx1.items = Newitm
	 )
	     )
		
)


fn resetmatball =                 -------------重置所有的材质球
 ( 
 macros.run "Medit Tools" "clear_medit_slots"

 )   



fn objnametosencename =      ------------------------------模型匹配场景名
(
   MyAry = selection
    CountNum=1
     
    for i in MyAry do
    (
	basenum= 1
 NumberPad=( basenum + (CountNum-1) ) as string
 if NumberPad.count == 1 do NumberPad=( "0"+NumberPad )
 i.name =( getFilenameFile maxFileName ) + "_" + NumberPad
 CountNum+=1
    )

  
) 

fn KEYCheckfn =   ------------------------------------检查关键帧
(

tempitm = scencecheck.lbx1.items
	 SomeError ="关键帧检查如下："
	  Newitm = append tempitm SomeError 
	  scencecheck.lbx1.items = Newitm
		for i in selection do
             	(
	
	  b = i.controller[1].controller.keys.count
	   if b > 0 do
	     (
		 select i
	  tempitm = scencecheck.lbx1.items
	 SomeError =$.name+ "模型中有动画关键帧，请检查是否要删除"
	  Newitm = append tempitm SomeError 
	  scencecheck.lbx1.items = Newitm
	       )
	   
	           )
)

fn AllInformation = 
(
Alloobj ="总共有 "+ ( objects.count as string ) + " 个物件 "
GEO= geometry.count as string + " 个可编辑物体 "
scencecheck.lbx1.items = append scencecheck.lbx1.items Alloobj
scencecheck.lbx1.items = append scencecheck.lbx1.items GEO
if selection.count > 0 do  scencecheck.lbx1.items = append scencecheck.lbx1.items ( selection.count as string + "个被选择" )

)

fn samenamemat=
(
Samename = 1
 a = sceneMaterials.count-1 

 for n = 1 to a do
 (
  m = n+1
	        for i = m to sceneMaterials.count do
	            (

	              if sceneMaterials[n].name == sceneMaterials[i].name do Samename+=1 
				               i+=1
	           )
			   n+=1
			   )
	           if Samename > 1 do  messagebox (Samename as string + "个同名材质" )
)

	button 'btn_batchone' " 批处理   " pos:[10,108] width:98 height:21 align:#left
	checkbox 'chk_selectall' "" pos:[11,134] width:19 height:16 checked:true align:#left
	checkbox 'chk_Xfrom' "" pos:[91,135] width:16 height:16 checked:true align:#left
	checkbox 'chk_removeislover' "" pos:[11,154] width:19 height:16 checked:true align:#left
	checkbox 'chk_weldvert' "" pos:[11,254] width:16 height:16 checked:false align:#left
	checkbox 'chk_autosmooth' "" pos:[90,154] width:17 height:16 checked:true align:#left
	checkbox 'chk_matname' "" pos:[11,174] width:18 height:16 checked:true align:#left
	checkbox 'chk_restmatball' "" pos:[11,194] width:17 height:16 checked:true align:#left
	checkbox 'chk_selectname' "" pos:[11,234] width:17 height:16 enabled:true checked:false align:#left
	button 'btn_selecthelp' "编辑模型以外的物体" pos:[5,27] width:151 height:20 enabled:true toolTip:"" align:#left
	checkbutton 'ckb_checkbackground' "8   模型接缝UV拉伸  " pos:[5,346] width:149 height:22 align:#left
	button 'btn_poivttozero' "移到原点" pos:[91,370] width:63 height:21 align:#left
	button 'btn_poivttocenter' "移到中心的下方" pos:[155,370] width:92 height:21 align:#left
	button 'btn_selectkong' "选择空物体       " pos:[5,49] width:151 height:20 align:#left
	button 'btn_creatfile' "创建上传文件夹" pos:[6,417] width:93 height:21 align:#left
	button 'btn_copyfile' "复制文件" pos:[191,416] width:58 height:22 align:#left
	button 'btn_matpath' "7 材质路径及多余文件" pos:[5,323] width:149 height:22 align:#left
	checkbutton 'ckb_povitmove' "9 质心修改" pos:[5,370] width:83 height:21 align:#left
	button 'btn_attchselectmodl' "合并模型" pos:[6,72] width:149 height:21 align:#left
	
		
	spinner 'spn_cweldthr' "" pos:[111,251] width:40 height:16 range:[0,100,0.01] align:#left
	listbox 'lbx1' "                 " pos:[165,41] width:182 height:21 items:#("信息栏", "11-25更新", "批量多边面检查", "同名材质检查", "创建S3目录") align:#left
	checkbox 'chk_keyinformation' "" pos:[11,213] width:18 height:16 checked:true align:#left
	button 'btn_matreplay' "材质球检查" pos:[26,172] width:81 height:18 align:#left
	button 'btn_matnamebig' "6 人工检查材质球  " pos:[5,300] width:149 height:23 align:#left
	button 'btn_weldselect' "焊接顶点" pos:[26,253] width:82 height:16 align:#left
	button 'btn_ambientColor' "渲染法线" pos:[241,345] width:61 height:23 align:#left
	checkbutton 'ckb_backface' "开\关背面显示" pos:[156,345] width:83 height:23 align:#left
	label 'lbl_single' "单击: 选择物体或模型" pos:[164,37] width:139 height:15 align:#left
	label 'lbl3' "有出现问题，请把问题反馈给陈雄远，谢谢！" pos:[10,444] width:339 height:24 align:#left
	button 'btn_replayname' "模型自动匹配场景名" pos:[26,232] width:123 height:18 align:#left
	button 'btn_singledown' "Z轴下移到0点" pos:[249,369] width:91 height:21 align:#left
	edittext 'edt_nametext' "" pos:[53,276] width:106 height:22 align:#left
	button 'btn_renametool' "命名" pos:[5,276] width:48 height:21 align:#left
	button 'btn_turntga' "psd 转 tga" pos:[6,393] width:59 height:21 align:#left
	button 'btn_selectalls' "选择所有" pos:[26,132] width:61 height:18 align:#left
	button 'btn_xforms' "Xfrom" pos:[108,133] width:45 height:18 align:#left
	button 'btn42' "多余顶点" pos:[26,152] width:61 height:18 align:#left
	button 'btn_autosmooths' "光滑组" pos:[108,152] width:45 height:18 align:#left
	button 'btn_resetmats' "重置材质球" pos:[26,192] width:81 height:18 align:#left
	button 'btn_keyinfors' "检查关键帧" pos:[26,212] width:81 height:18 align:#left
	button 'btn_dftotrs' "复制透明通道" pos:[67,393] width:89 height:21 align:#left
	button 'btn_clearinformation' "清除信息" pos:[286,37] width:65 height:18 align:#left
	GroupBox 'grp1' "" pos:[6,98] width:151 height:175 align:#left
	checkbox 'chk_S3file' "Checkbox" pos:[105,419] width:16 height:15 align:#left
	
			
	
		
		
	
		  
	button 'btn_S3' "S3目录" pos:[124,416] width:64 height:22 align:#left
	button 'btn_S3matstand' "转S3标准材质" pos:[158,393] width:90 height:21 align:#left
	button 'btn_S3planemat' "转植物" pos:[249,393] width:45 height:21 align:#left
	button 'btn_S3glassmat' "转玻璃" pos:[295,393] width:45 height:21 align:#left
	on btn_batchone pressed do
	with undo on
		(
		
		lbx1.items = #()
		lbx1.caption = "检查情况"
		     
			if chk_selectall.checked do select geometry
			AllInformation()
			if chk_Xfrom.checked do Xfromobject()
			if chk_removeislover.checked do removeIsoVerts()
			if chk_weldvert.checked do weldvers() 		 -------i.weldThreshold = spn_cweldthr.value
		 	if chk_autosmooth.checked do FaceAutosmooth()
			if chk_restmatball.checked do resetmatball() 
			if chk_selectname.checked do objnametosencename()
		 	if chk_keyinformation.checked do KEYCheckfn()
		
			----------------------------------------------------材质检查
			if chk_matname.checked do 
			(
			 scencecheck.lbx1.items = append scencecheck.lbx1.items ( "共有 "+sceneMaterials.count as string + " 个材质球")
			  if sceneMaterials.count > 1 do samenamemat()		
			for i in geometry do 
		         (
		 if i.material == undefined do
		             (
		    select i
		   messageBox (i.name + "没有材质的模型")
		   			)
		        )
		  for n = 1 to sceneMaterials.count do
	(
	if classof sceneMaterials[n] == Multimaterial do
	(
	
	scencecheck.lbx1.items = append scencecheck.lbx1.items (sceneMaterials[n].name+"是多维材质")
	meditMaterials[activeMeditSlot] = sceneMaterials[n]
		  MatEditor.Open() 
		  n+=1
	)
	
	
	)
		  
		)
	
			
			
			
			
			------------------------------------------------------------
			
			toolMode.pivotCenter()
		
			  )
	on btn_selecthelp pressed do
	(
	
		SelectHelps()
		try (if lbx1.items != #() do lbx1.items = #()) catch()
	  
	if selection.count == 0 do lbx1.items = #("没有多余物体")
	lbx1.caption ="选择的物体为："
	if selection.count > 0 do
	(
	 SelectName = for i in selection collect i.name
	 lbx1.items = SelectName
	)
		
		)
	on ckb_checkbackground changed state do
	(
		
		viewcolor = getVPortBGColor()
		tempcolor = ambientColor
		if state then
	         (
	           setVPortBGColor (color 150 255 175)
			  ambientColor = color 0 0 0 
			  renderers.current = mental_ray_renderer()
	renderers.current.Enable_Material_Override = true
	renderers.current.Override_Material = DoubleSided ()
	renderers.current.Override_Material.material1.diffuse = white
	renderers.current.Override_Material.material1.selfIllumAmount = 100
	renderers.current.Override_Material.material2.diffuse = red
	renderers.current.Override_Material.material2.selfIllumAmount = 100
			  )
		   else
	       (
		  
	       setVPortBGColor viewcolor
	       ambientColor = tempcolor
	renderers.current = Default_Scanline_Renderer()
	        	        )
		
		)
	on btn_poivttozero pressed do
	with undo on
		(
				 for i in selection do
		   (
		    	i.pivot.x = 0
		    	i.pivot.y = 0
		    	i.pivot.z = 0
		   )
		
			)
	on btn_poivttocenter pressed do
	with undo on
		(
			for i in selection do
		   (
		   n = $selection.center
		     i.pivot.x = n[1]
		    	i.pivot.y = n[2]
		    	i.pivot.z = 0
				
		   )
			)
	on btn_selectkong pressed do
	(
	clearSelection()
	
	obj = #()
			for i in geometry do
			(
			    a = getPolygonCount i
			    if a[1] == 0 then append obj i
			)
			if obj.count !=0 do
	         (
			 select obj 
			 actionMan.executeAction 0 "311"  -- Tools: Zoom Extents All Selected
			  SelectName = for i in selection collect i.name
	 lbx1.items = SelectName
	          )
	       
	
	try ( if selection.count == 0 do lbx1.items = #("没有空物体") ) catch ()
	
	
	lbx1.caption = "空物体数量为："
	
		)
	on btn_creatfile pressed do
	(
		makeDir ( maxFilePath +"3D" )
		makeDir ( maxFilePath +"设计稿" )
		makeDir ( maxFilePath +"截图" )
		if chk_S3file.checked do makeDir ( maxFilePath +"S3" )
		edt_copyfilepath.text = maxFilePath as string
		lbx1.items = #("创建完成")
		)
	on btn_copyfile pressed do
	(
		utilitypanel.openutility Resource_Collector
		)
	on btn_matpath pressed do
		macros.run "Asset Tracking System" "AssetTrackingSystemShow"
	on ckb_povitmove changed state do
	(
			if maxops.pivotmode != #pivotonly
					then maxops.pivotmode = #pivotonly
					else maxops.pivotmode = #none
		)
	on btn_attchselectmodl pressed do
	with undo on
	     ( 
		 setCommandPanelTaskMode #create
		 SnAttach()
		 edt_nametext.text = getFilenameFile maxFileName
		 setCommandPanelTaskMode #modify
		 )
	on lbx1 selected nameIndex do
	(
	try 	select (getNodeByName lbx1.items[nameIndex]) catch ()
	)
	on btn_matreplay pressed do
	(
	 scencecheck.lbx1.items = append scencecheck.lbx1.items (sceneMaterials.count as string + "个多维材质")
				for i in geometry do 
		         (
		 if i.material == undefined do
		             (
		    select i
		   messageBox (i.name + "没有材质的模型")
		   			)
		        )
		  for n = 1 to sceneMaterials.count do
	(
	if classof sceneMaterials[n] == Multimaterial do
	(
	scencecheck.lbx1.items = append scencecheck.lbx1.items (sceneMaterials[n].name+"是多维材质")
	
	meditMaterials[activeMeditSlot] = sceneMaterials[n]
	n+=1
		  MatEditor.Open() 
		
	)
	
	
	)
	
		
		)
	on btn_matnamebig pressed do
	(
			materialBrowseDlg #mats
				 mtlBrowser.browseFrom #scene
		)
	on btn_weldselect pressed do
	(
	if selection.count ==0 then SelctionCount()
			else(
	               try 
	        (
	              for i in selection do i.weldThreshold = spn_cweldthr.value
		            weldvers()
		   ) 
	                  catch (lbx1.items = #("有模型处于不可编辑状态")  )
	                )
	 scencecheck.lbx1.items = #("焊接顶点操作完成")
	
		)
	on btn_ambientColor pressed do
		render viewport.getType()
	on ckb_backface changed state do
	(
	   for i in geometry do
	    (
	    if state then i.backfacecull = on
		else i.backfacecull = off
	
	
	     )
	)
	on btn_replayname pressed do
	(
	if selection.count ==0 then SelctionCount()
			else 
	( 
	objnametosencename() 
	 scencecheck.lbx1.items = #("自动匹配完成")
	)
	)
	on btn_singledown pressed do
	with undo on
		(
			for i in selection do
		   (
		   n = $selection.center
		   i.pivot.z = 0
				
		   )
			)
	on btn_renametool pressed do
	(
	for i in selection do
	  (
	 i.name = uniquename edt_nametext.text
	   lbx1.items = #("重命名完成") 
	  )
	)
	on btn_turntga pressed do
	with undo on
	  (
	  if selection.count == 0 do  lbx1.items = #("你没有选择物体","请全选所有物体，","程序自动将所有psd 转成tga")
	
		for i in selection do 
		  (
	  	if i.mat != undefined then 
		(
		    try
		     (		
				mattype = i.mat
		    mattype = mattype as string
		    mattype1 = i.mat.name + ":Standard"
			if mattype == mattype1 then
		(
		mapnamepath = i.material.diffuseMap.fileName
		mapname = getFilenameFile mapnamepath
		mappath = getFilenamePath mapnamepath
		maptype = getFilenameType mapnamepath
		   if maptype == ".psd" then 
		    (
		mapnew = mappath + mapname + ".tga"
		i.material.diffuseMap.fileName = mapnew
		lbx1.items = #("已经转tga")
		    )
		   else ( lbx1.items = #("已经没有psd转了") )
			
		)
		else  lbx1.items = #(i.name + "不是标准材质")
		     )
		   catch 
		   (
		select i
		tempitm = lbx1.items
		        Newitm = append tempitm #( i.name + "材质不能转") 
		    lbx1.items = Newitm
		
		     )
		)
		else lbx1.items = #(i.name + "没有材质") 
		)
		)
	on btn_selectalls pressed do
	(
		select geometry
		)
	on btn_xforms pressed do
	(
			with undo on
			(
	if selection.count ==0 then SelctionCount()
			else Xfromobject()	
	 scencecheck.lbx1.items = #("xform完成")
				)
		)
	on btn42 pressed do
	(
			with undo on
			(
				if selection.count ==0 then SelctionCount()
			else removeIsoVerts()
	scencecheck.lbx1.items = #("去除多余顶点成功")
	
				)
		)
	on btn_autosmooths pressed do
	(
			with undo on 
			(
			if selection.count ==0 then SelctionCount()
					else FaceAutosmooth()
	         scencecheck.lbx1.items = #("自动光滑组完成")
			)
		)
	on btn_resetmats pressed do
	(
	resetmatball()
		 scencecheck.lbx1.items = #("已经重置完材质球")
		)
	on btn_keyinfors pressed do
	(
			if selection.count ==0 then SelctionCount()
					else KEYCheckfn()
		)
	on btn_dftotrs pressed do
	with undo on
		  (
		if selection.count == 0 do lbx1.items = #("请选择物体")
		 
		        for i in selection do
				 (
				  try 
		             (
		               	if i.mat == undefine then 
				                (
				  lbx1.items = #("该物体没有材质")
				  select i
				               )
		             else
				    (
					a =  i.mat.diffuseMap.fileName 
				     i.material.opacityMap=(bitmaptexture())   
				      i.material.opacityMap.bitmap = openBitMap a
		               i.material.opacityMap.monoOutput = 1
					showTextureMap i.material on
		             lbx1.items = #((i.name + "复制透明通道成功"))
					)
			
				 )
				 			catch 
				(
				select i
				lbx1.items = #(i.name + "无法复制通道" )
				)
				)
			
			)
	on btn_clearinformation pressed do
	(
	scencecheck.lbx1.items =#("")
	)
	on btn_S3 pressed do
		makeDir ( maxFilePath +"S3" )
	on btn_S3matstand pressed do
	(
		
		)
	on btn_S3planemat pressed do
	(
		
		)
	on btn_S3glassmat pressed do
	(
		
		)
)





















cj_tools=newrolloutfloater "检查流程" 370 500 
addrollout scencecheck cj_tools




