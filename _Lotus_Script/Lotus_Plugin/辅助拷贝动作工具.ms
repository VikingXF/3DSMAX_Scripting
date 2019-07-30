fn Lotus_RotateAlignment node1 node2  =   --旋转轴向匹配
(
	tempPos = node1.pos
	tempRot = node2.transform.rotationpart as matrix3
	node1.transform = tempRot
	node1.pos = tempPos
)
	
try( destroydialog Lotus_AlmightyANICopyTool )catch()
	
	--卷展栏保存按钮
	Lotus_AlmightyANICopyTool_RolloutBut_Save = #( "Lotus_AlmightyANICopyTool.save_pelvis" , "Lotus_AlmightyANICopyTool.save_Spine1" , "Lotus_AlmightyANICopyTool.save_Spine2" , "Lotus_AlmightyANICopyTool.save_Spine3"  , "Lotus_AlmightyANICopyTool.save_ribcage" ,;
											"Lotus_AlmightyANICopyTool.save_Neck1" , "Lotus_AlmightyANICopyTool.save_Neck2"  , "Lotus_AlmightyANICopyTool.save_head"  , "Lotus_AlmightyANICopyTool.save_RCollarbone"  , "Lotus_AlmightyANICopyTool.save_RUpperarm"  ,;
											"Lotus_AlmightyANICopyTool.save_RForearm"  , "Lotus_AlmightyANICopyTool.save_RPalm"  , "Lotus_AlmightyANICopyTool.save_LCollarbone"  , "Lotus_AlmightyANICopyTool.save_LUpperarm"  , "Lotus_AlmightyANICopyTool.save_LForearm"  ,;
											"Lotus_AlmightyANICopyTool.save_LPalm" , "Lotus_AlmightyANICopyTool.save_RThigh"  , "Lotus_AlmightyANICopyTool.save_RCalf" ,  "Lotus_AlmightyANICopyTool.save_RFoot" , "Lotus_AlmightyANICopyTool.save_LThigh"  ,;
											"Lotus_AlmightyANICopyTool.save_LCalf" , "Lotus_AlmightyANICopyTool.save_LFoot"	,"Lotus_AlmightyANICopyTool.save_do" )
	--卷展栏保存按钮
	Lotus_AlmightyANICopyTool_RolloutBut_load = #( "Lotus_AlmightyANICopyTool.load_pelvis" , "Lotus_AlmightyANICopyTool.load_Spine1" , "Lotus_AlmightyANICopyTool.load_Spine2" , "Lotus_AlmightyANICopyTool.load_Spine3"  , "Lotus_AlmightyANICopyTool.load_ribcage" ,;
											"Lotus_AlmightyANICopyTool.load_Neck1" , "Lotus_AlmightyANICopyTool.load_Neck2"  , "Lotus_AlmightyANICopyTool.load_head"  , "Lotus_AlmightyANICopyTool.load_RCollarbone"  , "Lotus_AlmightyANICopyTool.load_RUpperarm"  ,;
											"Lotus_AlmightyANICopyTool.load_RForearm"  , "Lotus_AlmightyANICopyTool.load_RPalm"  , "Lotus_AlmightyANICopyTool.load_LCollarbone"  , "Lotus_AlmightyANICopyTool.load_LUpperarm"  , "Lotus_AlmightyANICopyTool.load_LForearm"  ,;
											"Lotus_AlmightyANICopyTool.load_LPalm" , "Lotus_AlmightyANICopyTool.load_RThigh"  , "Lotus_AlmightyANICopyTool.load_RCalf" ,  "Lotus_AlmightyANICopyTool.load_RFoot" , "Lotus_AlmightyANICopyTool.load_LThigh"  ,;
											"Lotus_AlmightyANICopyTool.load_LCalf" , "Lotus_AlmightyANICopyTool.load_LFoot"	,"Lotus_AlmightyANICopyTool.load_in" ,"Lotus_AlmightyANICopyTool.load_load" ,"Lotus_AlmightyANICopyTool.load_saveCopyIn" ,;
											"Lotus_AlmightyANICopyTool.load_delCopyIn" ,"Lotus_AlmightyANICopyTool.load_boneTo_LH"	)
	--脚本目标物转存节点									
	LAAT_Alpha_s = #( "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_pelvis" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine1" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine2" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine3" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_ribcage" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Neck1" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Neck2" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_head" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RCollarbone" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RUpperarm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RForearm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RPalm" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LCollarbone" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LUpperarm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LForearm" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LPalm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RThigh" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RCalf" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RFoot" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LThigh" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LCalf" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LFoot" )
	--脚本转换节点1					
	LAAT_Alpha_sh = #( "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_pelvis" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine1" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine2" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine3" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_ribcage" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck1" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck2" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_head" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCollarbone" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RUpperarm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RForearm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RPalm" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCollarbone" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LUpperarm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LForearm" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LPalm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RThigh" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCalf" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RFoot" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LThigh" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCalf" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LFoot" )
	--脚本转换节点2								
	LAAT_Alpha_lh = #( "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_pelvis" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_Spine1" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_Spine2" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_Spine3" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_ribcage" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_Neck1" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_Neck2" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_head" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_RCollarbone" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_RUpperarm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_RForearm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_RPalm" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_LCollarbone" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_LUpperarm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_LForearm" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_LPalm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_RThigh" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_RCalf" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_RFoot" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_LThigh" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_LCalf" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.lh_LFoot" )
	--脚本目标物读取节点						
	LAAT_Alpha_l = #( "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_pelvis" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Spine1" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Spine2" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Spine3" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_ribcage" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Neck1" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Neck2" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_head" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RCollarbone" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RUpperarm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RForearm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RPalm" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LCollarbone" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LUpperarm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LForearm" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LPalm" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RThigh" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RCalf" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RFoot" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LThigh" , "Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LCalf" , ;
					"Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LFoot" )
											
	rollout Lotus_AlmightyANICopyTool "动作数据匹配工具v1.1" width:370 height:800
	(
		on Lotus_AlmightyANICopyTool open do --alpha点
		( 
			try( global Lotus_AlmightyANICopyToolP = $Lotus_AlmightyANICopyTool_alphaPoint )catch()
			if Lotus_AlmightyANICopyToolP == () then
			(
				global Lotus_AlmightyANICopyToolP = Point pos:[0,0,0] isSelected:off centermarker:off axistripod:off cross:off Box:off name:"Lotus_AlmightyANICopyTool_alphaPoint" ;try(Freeze Lotus_AlmightyANICopyToolP )catch()
				
				try( deleteModifier Lotus_AlmightyANICopyToolP Lotus_AlmightyANICopyToolP.modifiers[EmptyModifier])catch()
				addmodifier Lotus_AlmightyANICopyToolP (EmptyModifier ())
					
				temp = attributes cp  --添加隐藏节点属性
				(
					parameters NewRollout rollout: cp
					(
						--目标节点
						s_pelvis  type:#node ;s_Spine1  type:#node ;s_Spine2  type:#node ;s_Spine3  type:#node ;s_ribcage  type:#node ;s_Neck1  type:#node ;s_Neck2  type:#node ;s_head  type:#node ;s_RCollarbone  type:#node ;
						s_RUpperarm  type:#node ;s_RForearm  type:#node ;s_RPalm  type:#node ;s_LCollarbone  type:#node ;s_LUpperarm  type:#node ;s_LForearm  type:#node ;s_LPalm  type:#node ;s_RThigh  type:#node ;s_RCalf  type:#node ;
						s_RFoot  type:#node ;s_LThigh  type:#node ;s_LCalf  type:#node ;s_LFoot  type:#node 
						--转换节点1
						sh_pelvis  type:#node ;sh_Spine1  type:#node ;sh_Spine2  type:#node ;sh_Spine3  type:#node ;sh_ribcage  type:#node ;sh_Neck1  type:#node ;sh_Neck2  type:#node ;sh_head  type:#node ;sh_RCollarbone  type:#node ;
						sh_RUpperarm  type:#node ;sh_RForearm  type:#node ;sh_RPalm  type:#node ;sh_LCollarbone  type:#node ;sh_LUpperarm  type:#node ;sh_LForearm  type:#node ;sh_LPalm  type:#node ;sh_RThigh  type:#node ;sh_RCalf  type:#node ;
						sh_RFoot  type:#node ;sh_LThigh  type:#node ;sh_LCalf  type:#node ;sh_LFoot  type:#node 
						--转换节点2
						lh_pelvis  type:#node ;lh_Spine1  type:#node ;lh_Spine2  type:#node ;lh_Spine3  type:#node ;lh_ribcage  type:#node ;lh_Neck1  type:#node ;lh_Neck2  type:#node ;lh_head  type:#node ;lh_RCollarbone  type:#node ;
						lh_RUpperarm  type:#node ;lh_RForearm  type:#node ;lh_RPalm  type:#node ;lh_LCollarbone  type:#node ;lh_LUpperarm  type:#node ;lh_LForearm  type:#node ;lh_LPalm  type:#node ;lh_RThigh  type:#node ;lh_RCalf  type:#node ;
						lh_RFoot  type:#node ;lh_LThigh  type:#node ;lh_LCalf  type:#node ;lh_LFoot  type:#node 
						--读取节点
						l_pelvis  type:#node ;l_Spine1  type:#node ;l_Spine2  type:#node ;l_Spine3  type:#node ;l_ribcage  type:#node ;l_Neck1  type:#node ;l_Neck2  type:#node ;l_head  type:#node ;l_RCollarbone  type:#node ;
						l_RUpperarm  type:#node ;l_RForearm  type:#node ;l_RPalm  type:#node ;l_LCollarbone  type:#node ;l_LUpperarm  type:#node ;l_LForearm  type:#node ;l_LPalm  type:#node ;l_RThigh  type:#node ;l_RCalf  type:#node ;
						l_RFoot  type:#node ;l_LThigh  type:#node ;l_LCalf  type:#node ;l_LFoot  type:#node 
					)
					rollout cp ""
					(  )
				)
				custAttributes.add Lotus_AlmightyANICopyToolP.modifiers[#Attribute_Holder] temp
			)
		)
		on Lotus_AlmightyANICopyTool close do --清理内存
		( 
			Lotus_AlmightyANICopyTool.load_delCopyIn.pressed()
			try(delete Lotus_AlmightyANICopyToolP)catch() 
			try(globalVars.remove #Lotus_AlmightyANICopyToolP)catch() 
			Lotus_AlmightyANICopyTool_RolloutBut_Save = ();Lotus_AlmightyANICopyTool_RolloutBut_load = ()
			LAAT_Alpha_s = ();LAAT_Alpha_sh = ();LAAT_Alpha_lh = ();LAAT_Alpha_l = ()
			try(globalVars.remove #Lotus_AlmightyANICopyToolP_temp)catch() 
			Lotus_AlmightyANICopyToolP_temp = ()
		)
			
		button 'saveOrload' "切换读取模式" pos:[20,20] width:80 height:40 align:#left
		on saveOrload pressed do with undo on 
		(  
			if Lotus_AlmightyANICopyTool.saveOrload.text == "切换读取模式" then
			(
				Lotus_AlmightyANICopyTool.saveOrload.text = "读取模式"
				for i = 1 to Lotus_AlmightyANICopyTool_RolloutBut_Save.count do ( try(execute ( Lotus_AlmightyANICopyTool_RolloutBut_Save[i] + ".pos.x += 500" ))catch() )
				for i = 1 to Lotus_AlmightyANICopyTool_RolloutBut_Load.count do ( try(execute ( Lotus_AlmightyANICopyTool_RolloutBut_Load[i] + ".pos.x -= 500" ))catch() )
				try( delete Lotus_AlmightyANICopyToolP )catch()
			)else()
		)
		
		button 'save_do' "储存动作数据到后台" pos:[20,730] width:330 height:60 align:#left 
		on save_do pressed do with undo on 
		(
			--烘培每一帧的数据
			sliderTime = animationRange.start
			set animate on
			for i = animationRange.start to animationRange.end do
			(
				sliderTime += 1
				for o = 1 to LAAT_Alpha_s.count do 
				(
					if ( (execute LAAT_Alpha_s[o]) != () ) then( execute (LAAT_Alpha_sh[o] + ".transform = " + LAAT_Alpha_s[o] + ".transform") )
				)
			)
			sliderTime = animationRange.start
			--添加二级节点
			for i = 1 to LAAT_Alpha_sh.count do
			(
				if ( (execute LAAT_Alpha_sh[i]) != () ) then
				(
					temp = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:5 name:("LAAT_"+ (filterString LAAT_Alpha_lh[i] ".")[4])
					temp.wirecolor = color 255 255 0
					temp.transform = (execute LAAT_Alpha_sh[i]).transform
					temp.transform.controller = Link_Constraint ()
					temp.transform.controller.AddTarget (execute LAAT_Alpha_sh[i]) 0	
					execute ( LAAT_Alpha_lh[i] + " = " + "temp" )
				)
			)
			--选需要导出的节点
			clearSelection()
			tempArray = #()
			append tempArray Lotus_AlmightyANICopyToolP
			for i = 1 to LAAT_Alpha_s.count do( execute (LAAT_Alpha_s[i] + " = undefined") )
			for i = 1 to LAAT_Alpha_lh.count do
			(
				if ( (execute LAAT_Alpha_lh[i]) != () ) then
				(		
					append tempArray (execute LAAT_Alpha_sh[i])						
					append tempArray (execute LAAT_Alpha_lh[i])	
				)
			)
			--导出
			select tempArray
			try( HiddenDOSCommand ( "md " + LocalAddress_ + "\\AlmightyANICopyTool\\" ))catch()
			try( saveNodes tempArray (LocalAddress_ + "\\AlmightyANICopyTool\\temp.max") )catch()
		)
		
		button 'save_pelvis' "s盆骨" pos:[148,315] width:80 height:60 align:#left
		button 'save_Spine1' "s脊椎1" pos:[165,271] width:45 height:40 align:#left
		button 'save_Spine2' "s脊椎2" pos:[165,230] width:45 height:40 aelign:#left
		button 'save_Spine3' "s脊椎3" pos:[165,189] width:45 height:40 align:#left
		button 'save_ribcage' "s胸骨" pos:[147,127] width:80 height:60 align:#left
		button 'save_Neck1' "s脖子1" pos:[167,106] width:40 height:20 align:#left
		button 'save_Neck2' "s脖子2" pos:[167,84] width:40 height:20 align:#left
		button 'save_head' "s头" pos:[147,21] width:80 height:60 align:#left		
		button 'save_RCollarbone' "s右锁骨" pos:[72,121] width:90 height:35 align:#left
		button 'save_RUpperarm' "s右大臂" pos:[24,142] width:45 height:65 align:#left
		button 'save_RForearm' "s右小臂" pos:[24,209] width:45 height:65 align:#left
		button 'save_RPalm' "s右手掌" pos:[17,279] width:60 height:60 align:#left
		button 'save_LCollarbone' "s左锁骨" pos:[212,119] width:90 height:35 align:#left
		button 'save_LUpperarm' "s左大臂" pos:[305,142] width:45 height:65 align:#left
		button 'save_LForearm' "s左小臂" pos:[305,209] width:45 height:65 align:#left
		button 'save_LPalm' "s左手掌" pos:[298,279] width:60 height:60 align:#left
		button 'save_RThigh' "s右大腿" pos:[120,378] width:55 height:120 align:#left
		button 'save_RCalf' "s右小腿" pos:[120,500] width:55 height:120 align:#left
		button 'save_RFoot' "s右脚掌" pos:[120,626] width:55 height:80 align:#left
		button 'save_LThigh' "s左大腿" pos:[203,378] width:55 height:120 align:#left
		button 'save_LCalf' "s左小腿" pos:[203,500] width:55 height:120 align:#left
		button 'save_LFoot' "s左脚掌" pos:[203,626] width:55 height:80 align:#left
		
		on save_pelvis pressed do with undo on 
		( 	
			if save_pelvis.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_pelvis = selection[1] ;save_pelvis.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_pelvis.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_pelvis )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_pelvis = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_pelvis" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_pelvis.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_pelvis.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_pelvis.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_pelvis
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_pelvis = () ;save_pelvis.text = "s盆骨" ;save_pelvis.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_pelvis ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_pelvis = () )catch() )
		)
		on save_Spine1 pressed do with undo on 
		( 	
			if save_Spine1.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine1 = selection[1] ;save_Spine1.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_Spine1.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine1 )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine1 = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_Spine1" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine1.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine1.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine1.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine1
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine1 = () ;save_Spine1.text = "s脊椎1" ;save_Spine1.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine1 ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine1 = ())catch() )
		)		
		on save_Spine2 pressed do with undo on 
		( 	
			if save_Spine2.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine2 = selection[1] ;save_Spine2.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_Spine2.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine2 )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine2 = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_Spine2" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine2.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine2.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine2.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine2
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine2 = () ;save_Spine2.text = "s脊椎2" ;save_Spine2.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine2 ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine2 = ())catch() )
		)			
		on save_Spine3 pressed do with undo on 
		( 	
			if save_Spine3.text != "已激活" and selection[1] != () then
			(
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine3 = selection[1] ;save_Spine3.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_Spine3.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine3 )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine3 = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_Spine3" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine3.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine3.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine3.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine3
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Spine3 = () ;save_Spine3.text = "s脊椎3" ;save_Spine3.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine3 ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Spine3 = ())catch() )
		)		
		on save_ribcage pressed do with undo on 
		( 	
			if save_ribcage.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_ribcage = selection[1] ;save_ribcage.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_ribcage.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_ribcage )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_ribcage = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_ribcage" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_ribcage.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_ribcage.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_ribcage.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_ribcage
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_ribcage = () ;save_ribcage.text = "s胸骨" ;save_ribcage.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_ribcage ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_ribcage = ())catch() )
		)		
		on save_Neck1 pressed do with undo on 
		( 	
			if save_Neck1.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Neck1 = selection[1] ;save_Neck1.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_Neck1.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck1 )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck1 = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_Neck1" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck1.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck1.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Neck1.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Neck1
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Neck1 = () ;save_Neck1.text = "s脖子1" ;save_Neck1.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck1 ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck1 = ())catch() )
		)			
		on save_Neck2 pressed do with undo on 
		( 	
			if save_Neck2.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Neck2 = selection[1] ;save_Neck2.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_Neck2.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck2 )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck2 = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_Neck2" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck2.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck2.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Neck2.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Neck2
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_Neck2 = () ;save_Neck2.text = "s脖子2" ;save_Neck2.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck2 ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_Neck2 = ())catch() )
		)			
		on save_head pressed do with undo on 
		( 	
			if save_head.text != "已激活" and selection[1] != () then
			(
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_head = selection[1] ;save_head.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_head.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_head )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_head = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_head" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_head.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_head.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_head.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_head
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_head = () ;save_head.text = "s头" ;save_head.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_head ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_head = ())catch() )
		)			
		on save_RCollarbone pressed do with undo on 
		( 	
			if save_RCollarbone.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RCollarbone = selection[1] ;save_RCollarbone.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_RCollarbone.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCollarbone )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCollarbone = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_RCollarbone" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCollarbone.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCollarbone.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RCollarbone.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RCollarbone
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RCollarbone = () ;save_RCollarbone.text = "s右锁骨" ;save_RCollarbone.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCollarbone ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCollarbone = ())catch() )
		)			
		on save_RUpperarm pressed do with undo on 
		( 	
			if save_RUpperarm.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RUpperarm = selection[1] ;save_RUpperarm.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_RUpperarm.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RUpperarm )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RUpperarm = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_RUpperarm" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RUpperarm.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RUpperarm.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RUpperarm.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RUpperarm
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RUpperarm = () ;save_RUpperarm.text = "s右大臂" ;save_RUpperarm.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RUpperarm ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RUpperarm = ())catch() )
		)		
		on save_RForearm pressed do with undo on 
		( 	
			if save_RForearm.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RForearm = selection[1] ;save_RForearm.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_RForearm.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RForearm )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RForearm = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_RForearm" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RForearm.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RForearm.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RForearm.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RForearm
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RForearm = () ;save_RForearm.text = "s右小臂" ;save_RForearm.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RForearm ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RForearm = ())catch() )
		)			
		on save_RPalm pressed do with undo on 
		( 	
			if save_RPalm.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RPalm = selection[1] ;save_RPalm.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_RPalm.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RPalm )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RPalm = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_RPalm" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RPalm.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RPalm.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RPalm.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RPalm
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RPalm = () ;save_RPalm.text = "s右手掌" ;save_RPalm.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RPalm ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RPalm = ())catch() )
		)			
		on save_LCollarbone pressed do with undo on 
		( 	
			if save_LCollarbone.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LCollarbone = selection[1] ;save_LCollarbone.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_LCollarbone.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCollarbone )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCollarbone = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_LCollarbone" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCollarbone.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCollarbone.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LCollarbone.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LCollarbone
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LCollarbone = () ;save_LCollarbone.text = "s左锁骨" ;save_LCollarbone.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCollarbone ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCollarbone = ())catch() )
		)		
		on save_LUpperarm pressed do with undo on 
		( 	
			if save_LUpperarm.text != "已激活" and selection[1] != () then
			(
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LUpperarm = selection[1] ;save_LUpperarm.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_LUpperarm.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LUpperarm )catch()
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LUpperarm = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_LUpperarm" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LUpperarm.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LUpperarm.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LUpperarm.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LUpperarm				
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LUpperarm = () ;save_LUpperarm.text = "s左大臂" ;save_LUpperarm.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LUpperarm ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LUpperarm = ())catch() )
		)		
		on save_LForearm pressed do with undo on 
		( 	
			if save_LForearm.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LForearm = selection[1] ;save_LForearm.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_LForearm.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LForearm )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LForearm = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_LForearm" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LForearm.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LForearm.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LForearm.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LForearm
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LForearm = () ;save_LForearm.text = "s左小臂" ;save_LForearm.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LForearm ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LForearm = ())catch() )
		)		
		on save_LPalm pressed do with undo on 
		( 	
			if save_LPalm.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LPalm = selection[1] ;save_LPalm.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_LPalm.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LPalm )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LPalm = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_LPalm" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LPalm.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LPalm.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LPalm.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LPalm
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LPalm = () ;save_LPalm.text = "s左手掌" ;save_LPalm.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LPalm ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LPalm = ())catch() )
		)		
		on save_RThigh pressed do with undo on 
		( 	
			if save_RThigh.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RThigh = selection[1] ;save_RThigh.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_RThigh.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RThigh )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RThigh = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_RThigh" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RThigh.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RThigh.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RThigh.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RThigh
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RThigh = () ;save_RThigh.text = "s右大腿" ;save_RThigh.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RThigh ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RThigh = ())catch() )
		)		
		on save_RCalf pressed do with undo on 
		( 	
			if save_RCalf.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RCalf = selection[1] ;save_RCalf.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_RCalf.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCalf )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCalf = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_RCalf" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCalf.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCalf.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RCalf.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RCalf
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RCalf = () ;save_RCalf.text = "s右小腿" ;save_RCalf.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCalf ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RCalf = ())catch() )
		)			
		on save_RFoot pressed do with undo on 
		( 	
			if save_RFoot.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RFoot = selection[1] ;save_RFoot.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_RFoot.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RFoot )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RFoot = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_RFoot" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RFoot.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RFoot.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RFoot.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RFoot
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_RFoot = () ;save_RFoot.text = "s右脚掌" ;save_RFoot.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RFoot ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_RFoot = ())catch() )
		)			
		on save_LThigh pressed do with undo on 
		( 	
			if save_LThigh.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LThigh = selection[1] ;save_LThigh.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_LThigh.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LThigh )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LThigh = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_LThigh" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LThigh.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LThigh.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LThigh.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LThigh
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LThigh = () ;save_LThigh.text = "s左大腿" ;save_LThigh.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LThigh ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LThigh = ())catch() )
		)			
		on save_LCalf pressed do with undo on 
		( 	
			if save_LCalf.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LCalf = selection[1] ;save_LCalf.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_LCalf.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCalf )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCalf = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_LCalf" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCalf.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCalf.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LCalf.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LCalf
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LCalf = () ;save_LCalf.text = "s左小腿" ;save_LCalf.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCalf ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LCalf = ())catch() )
		)		
		on save_LFoot pressed do with undo on 
		( 	
			if save_LFoot.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LFoot = selection[1] ;save_LFoot.text = selection[1].name ;Lotus_AlmightyANICopyTool.save_LFoot.tooltip = selection[1].name ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LFoot )catch() 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LFoot = Point pos:[0,0,0] isSelected:on centermarker:false axistripod:false cross:false Box:true constantscreensize:false drawontop:false size:8 name:"LAAT_sh_LFoot" 
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LFoot.wirecolor = color 135 6 6
				Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LFoot.transform = Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LFoot.transform
				select Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LFoot
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.s_LFoot = () ;save_LFoot.text = "s左脚掌" ;save_LFoot.tooltip = "" ;delete Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LFoot ;Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.sh_LFoot = ())catch() )
		)			
		
		button 'load_in' "1.加载已存的动作数据" pos:[520,730] width:130 height:60 align:#left
		button 'load_load' "烘焙动作数据" pos:[660,730] width:190 height:60 align:#left
		button 'load_delCopyIn' "删除映射" pos:[515,600] width:90 height:40 align:#left
		button 'load_pelvis' "l盆骨" pos:[648,315] width:80 height:60 align:#left
		button 'load_Spine1' "l脊椎1" pos:[665,271] width:45 height:40 align:#left
		button 'load_Spine2' "l脊椎2" pos:[665,230] width:45 height:40 aelign:#left
		button 'load_Spine3' "l脊椎3" pos:[665,189] width:45 height:40 align:#left
		button 'load_ribcage' "l胸骨" pos:[647,127] width:80 height:60 align:#left
		button 'load_Neck1' "l脖子1" pos:[667,106] width:40 height:20 align:#left
		button 'load_Neck2' "l脖子2" pos:[667,84] width:40 height:20 align:#left
		button 'load_head' "l头" pos:[647,21] width:80 height:60 align:#left		
		button 'load_RCollarbone' "l右锁骨" pos:[572,121] width:90 height:35 align:#left
		button 'load_RUpperarm' "l右大臂" pos:[524,142] width:45 height:65 align:#left
		button 'load_RForearm' "l右小臂" pos:[524,209] width:45 height:65 align:#left
		button 'load_RPalm' "l右手掌" pos:[517,279] width:60 height:60 align:#left
		button 'load_LCollarbone' "l左锁骨" pos:[712,119] width:90 height:35 align:#left
		button 'load_LUpperarm' "l左大臂" pos:[805,142] width:45 height:65 align:#left
		button 'load_LForearm' "l左小臂" pos:[805,209] width:45 height:65 align:#left
		button 'load_LPalm' "l左手掌" pos:[798,279] width:60 height:60 align:#left
		button 'load_RThigh' "l右大腿" pos:[620,378] width:55 height:120 align:#left
		button 'load_RCalf' "l右小腿" pos:[620,500] width:55 height:120 align:#left
		button 'load_RFoot' "l右脚掌" pos:[620,626] width:55 height:80 align:#left
		button 'load_LThigh' "l左大腿" pos:[703,378] width:55 height:120 align:#left
		button 'load_LCalf' "l左小腿" pos:[703,500] width:55 height:120 align:#left
		button 'load_LFoot' "l左脚掌" pos:[703,626] width:55 height:80 align:#left
		
		on load_in pressed do with undo on --导入动作数据
		(
			Lotus_AlmightyANICopyTool.load_delCopyIn.pressed()
			try( mergeMAXFile (LocalAddress_ + "\\AlmightyANICopyTool\\temp.max") #select )catch()
			global Lotus_AlmightyANICopyToolP_temp = selection as array
			global Lotus_AlmightyANICopyToolP = $Lotus_AlmightyANICopyTool_alphaPoint
		)
		
		on load_load pressed do with undo on --烘焙动作数据到骨骼（控制器）
		(
			for i = 1 to LAAT_Alpha_l.count do
			(
				if ( (execute LAAT_Alpha_lh[i]) != () ) and ( (execute LAAT_Alpha_l[i]) != () ) then( Lotus_RotateAlignment (execute (LAAT_Alpha_lh[i])) (execute (LAAT_Alpha_l[i])) )
			)
			sliderTime = animationRange.start
			set animate on
			for i = animationRange.start to animationRange.end do
			(
				for o = 1 to LAAT_Alpha_l.count do 
				(
					try( (execute LAAT_Alpha_l[o]).transform = (execute LAAT_Alpha_lh[o]).transform  )catch()
				)
				sliderTime += 1
			)
			sliderTime = animationRange.start
		)
								
		on load_delCopyIn pressed do with undo on 
		(
			try(delete Lotus_AlmightyANICopyToolP_temp)catch() 
			try(globalVars.remove #Lotus_AlmightyANICopyToolP_temp)catch() 
		)
		
		on load_pelvis pressed do with undo on 
		( 	
			if load_pelvis.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_pelvis = selection[1] ;load_pelvis.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_pelvis.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_pelvis = () ;load_pelvis.text = "s盆骨" ;load_pelvis.tooltip = "" )catch() )
		)
		on load_Spine1 pressed do with undo on 
		( 	
			if load_Spine1.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Spine1 = selection[1] ;load_Spine1.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_Spine1.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Spine1 = () ;load_Spine1.text = "s脊椎1" ;load_Spine1.tooltip = "" )catch() )
		)		
		on load_Spine2 pressed do with undo on 
		( 	
			if load_Spine2.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Spine2 = selection[1] ;load_Spine2.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_Spine2.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Spine2 = () ;load_Spine2.text = "s脊椎2" ;load_Spine2.tooltip = "" )catch() )
		)			
		on load_Spine3 pressed do with undo on 
		( 	
			if load_Spine3.text != "已激活" and selection[1] != () then
			(
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Spine3 = selection[1] ;load_Spine3.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_Spine3.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Spine3 = () ;load_Spine3.text = "s脊椎3" ;load_Spine3.tooltip = "" )catch() )
		)		
		on load_ribcage pressed do with undo on 
		( 	
			if load_ribcage.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_ribcage = selection[1] ;load_ribcage.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_ribcage.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_ribcage = () ;load_ribcage.text = "s胸骨" ;load_ribcage.tooltip = "" )catch() )
		)		
		on load_Neck1 pressed do with undo on 
		( 	
			if load_Neck1.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Neck1 = selection[1] ;load_Neck1.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_Neck1.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Neck1 = () ;load_Neck1.text = "s脖子1" ;load_Neck1.tooltip = "" )catch() )
		)			
		on load_Neck2 pressed do with undo on 
		( 	
			if load_Neck2.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Neck2 = selection[1] ;load_Neck2.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_Neck2.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_Neck2 = () ;load_Neck2.text = "s脖子2" ;load_Neck2.tooltip = "" )catch() )
		)			
		on load_head pressed do with undo on 
		( 	
			if load_head.text != "已激活" and selection[1] != () then
			(
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_head = selection[1] ;load_head.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_head.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_head = () ;load_head.text = "s头" ;load_head.tooltip = "" )catch() )
		)			
		on load_RCollarbone pressed do with undo on 
		( 	
			if load_RCollarbone.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RCollarbone = selection[1] ;load_RCollarbone.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_RCollarbone.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RCollarbone = () ;load_RCollarbone.text = "s右锁骨" ;load_RCollarbone.tooltip = "" )catch() )
		)			
		on load_RUpperarm pressed do with undo on 
		( 	
			if load_RUpperarm.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RUpperarm = selection[1] ;load_RUpperarm.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_RUpperarm.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RUpperarm = () ;load_RUpperarm.text = "s右大臂" ;load_RUpperarm.tooltip = "" )catch() )
		)		
		on load_RForearm pressed do with undo on 
		( 	
			if load_RForearm.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RForearm = selection[1] ;load_RForearm.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_RForearm.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RForearm = () ;load_RForearm.text = "s右小臂" ;load_RForearm.tooltip = "" )catch() )
		)			
		on load_RPalm pressed do with undo on 
		( 	
			if load_RPalm.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RPalm = selection[1] ;load_RPalm.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_RPalm.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RPalm = () ;load_RPalm.text = "s右手掌" ;load_RPalm.tooltip = "" )catch() )
		)			
		on load_LCollarbone pressed do with undo on 
		( 	
			if load_LCollarbone.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LCollarbone = selection[1] ;load_LCollarbone.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_LCollarbone.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LCollarbone = () ;load_LCollarbone.text = "s左锁骨" ;load_LCollarbone.tooltip = "" )catch() )
		)		
		on load_LUpperarm pressed do with undo on 
		( 	
			if load_LUpperarm.text != "已激活" and selection[1] != () then
			(
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LUpperarm = selection[1] ;load_LUpperarm.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_LUpperarm.tooltip = selection[1].name )catch()
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LUpperarm = () ;load_LUpperarm.text = "s左大臂" ;load_LUpperarm.tooltip = "" )catch() )
		)		
		on load_LForearm pressed do with undo on 
		( 	
			if load_LForearm.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LForearm = selection[1] ;load_LForearm.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_LForearm.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LForearm = () ;load_LForearm.text = "s左小臂" ;load_LForearm.tooltip = "" )catch() )
		)		
		on load_LPalm pressed do with undo on 
		( 	
			if load_LPalm.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LPalm = selection[1] ;load_LPalm.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_LPalm.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LPalm = () ;load_LPalm.text = "s左手掌" ;load_LPalm.tooltip = "" )catch() )
		)		
		on load_RThigh pressed do with undo on 
		( 	
			if load_RThigh.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RThigh = selection[1] ;load_RThigh.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_RThigh.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RThigh = () ;load_RThigh.text = "s右大腿" ;load_RThigh.tooltip = "" )catch() )
		)		
		on load_RCalf pressed do with undo on 
		( 	
			if load_RCalf.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RCalf = selection[1] ;load_RCalf.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_RCalf.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RCalf = () ;load_RCalf.text = "s右小腿" ;load_RCalf.tooltip = "" )catch() )
		)			
		on load_RFoot pressed do with undo on 
		( 	
			if load_RFoot.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RFoot = selection[1] ;load_RFoot.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_RFoot.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_RFoot = () ;load_RFoot.text = "s右脚掌" ;load_RFoot.tooltip = "" )catch() )
		)			
		on load_LThigh pressed do with undo on 
		( 	
			if load_LThigh.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LThigh = selection[1] ;load_LThigh.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_LThigh.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LThigh = () ;load_LThigh.text = "s左大腿" ;load_LThigh.tooltip = "" )catch() )
		)			
		on load_LCalf pressed do with undo on 
		( 	
			if load_LCalf.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LCalf = selection[1] ;load_LCalf.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_LCalf.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LCalf = () ;load_LCalf.text = "s左小腿" ;load_LCalf.tooltip = "" )catch() )
		)		
		on load_LFoot pressed do with undo on 
		( 	
			if load_LFoot.text != "已激活" and selection[1] != () then
			( 
				try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LFoot = selection[1] ;load_LFoot.text = selection[1].name ;Lotus_AlmightyANICopyTool.load_LFoot.tooltip = selection[1].name )catch() 
			)
			else( try( Lotus_AlmightyANICopyToolP.'Attribute_Holder'.cp.l_LFoot = () ;load_LFoot.text = "s左脚掌" ;load_LFoot.tooltip = "" )catch() )
		)		
	)

	createdialog Lotus_AlmightyANICopyTool pos:[1300,130]
