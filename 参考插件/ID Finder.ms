macroScript IDs
     category:"#todorScripts"
	toolTip:"IDs"
   
 (
	 
	 rollout IDs  "IDs" width:261 height:200
(
	
	label lbl1 "Change Object ID" pos:[11,15] width:127 height:19
	label lbl2 "Change Material Channel" pos:[11,54] width:127 height:19
	label outputs "Outputs" style_sunkenedge:true pos:[11,95] width:227 height:19
	
	button MaterialChannel "TO ZIRO" pos:[160,9] width:70 height:24	
	button btn2 "TO ZIRO" pos:[160,51] width:70 height:24
	button btn3 "PRINT" pos:[250,10] width:70 height:24
	button btn4 "PRINT" pos:[250,51] width:70 height:24

	label randomObjID "Random Object IDs" pos:[11,130] width:127 height:19
	button randomObjID_BTN "GO" pos:[250,160] width:70 height:24	
	editText from_feld "From" pos:[10,160] width:60 height:16
	editText to_feld "To" pos:[80,160] width:60 height:16
	
	--label SelectObjIDs "Select Object IDs" pos:[11,195] width:127 height:19
	editText SelectObjIDs_feld "Select Object IDs" pos:[10,195] width:160 height:16
	button SelectObjID_BTN "GO" pos:[250,195] width:70 height:24	
	
	
	global output_01 = "Output: "
	global from_feld_01 = 0
	global to_feld_01 = 1
	global newSelecttion = #()
	global SelectObjIDs_text = 0
	-----------------------------
	
	groupBox grp1 "About" pos:[12,240] width:200 height:100
				
				--lable
		    label lbl5 "ID Selecter v 1.0" pos:[29,260] width:140 height:54 enabled:true
				
		    label lbl3 "by Todor Vankov " pos:[29,275] width:140 height:54 enabled:true
				
		    label lbl4 "Click and visit my site : " pos:[29,300] width:140 height:54 enabled:true
			
		    hyperLink mysite "www.todorvankov.com" address:"www.todorvankov.com" color:[206,255,255] pos:[29,315]		
			-----------------------------

	
	on SelectObjIDs_feld entered text do
(   SelectObjIDs_text = text
	
	)
	
	
	on SelectObjID_BTN pressed do (
		

		g=getcurrentselection()
		
			for i = 1 to g.count do (
		S
				SelectObjIDs_text = SelectObjIDs_text as integer
				
				if ( g[i].gbufferchannel == SelectObjIDs_text ) then 
			(
						
	                   append  newSelecttion g[i]
				       print newSelecttion
					   select  newSelecttion
				)				
				
				
			
			)	
			
			
		)

	
	-----------------------------------------------------------
		on from_feld entered text do
(   from_feld_01 = text
	
	)
	
	on to_feld entered text do
(
	 to_feld_01 = text
	)
	------------------------------------------------------------
	
	on randomObjID_BTN pressed do (
		
		g=getcurrentselection()
		
			for i = 1 to g.count do (
		
				test1 = from_feld_01 as integer
				test2 = to_feld_01 as integer
			g[i].gbufferchannel = random test1 test2
				
			
			)	
			
			
		)
		
		
		
		
	
	
	--Print Obj. IDs
	on btn3 pressed  do (
	try(	
		
		 Outputs.text = "Output : "
		 output_01 = "Output: "
		 
	g=getcurrentselection()
				
		for i = 1 to g.count do (
		
			output_01 = output_01 + g[i].gbufferchannel as String + " "
			print output_01
			--sort output_01
			Outputs.text = output_01
			
			)					
	
	)catch()
)










--Print Mat IDs
	on btn4 pressed  do (
		 try(
			 
			 Outputs.text = "Output : "
		 output_01 = "Output: "
			
	g=getcurrentselection()
	
	for i = 1 to g.count do (
			
		
			
		meditMaterials[1] = g[i].material
			

		output_01 = output_01 + meditMaterials[1].effectsChannel as String + " "
			print output_01
			
			Outputs.text = output_01
		
		
			
	)	
		
		)catch()
)
	









	
	on MaterialChannel pressed  do (
	try(
	
	g=getcurrentselection()
				
		for i = 1 to g.count do (
			
			g[i].gbufferchannel = 0
		
			)
	
	)catch()
)
	
	
	
	
	on btn2 pressed  do (
		
		
		 try(
			
	g=getcurrentselection()
					
			
	for i = 1 to g.count do (
			
			
		meditMaterials[1] = g[i].material
			
		meditMaterials[1].effectsChannel = 0
		
			
		)	
		
		)catch()
	)	
)

--rollout Outputs  "Outputs" width:261 height:100
--(
--	label Outputs "Outputs" pos:[11,15] width:127 height:19
	
--)

   tv = NewRolloutFloater "IDs" 350 390
	addRollout IDs tv
  --  addRollout Outputs tv
)