--#######/ mx_合并模型 /##################
fn Lotus_combinePoly = 
(
	selectOBJarray = selection as array 
	convertTo selectOBJarray Editable_Poly
	theBaseOBJ = selectOBJarray[1]
	for i = 2 to selectOBJarray.count do
	(
		theBaseOBJ.EditablePoly.attach selectOBJarray[i] theBaseOBJ
	)
	try( $.pivot = [0,0,0] )catch()
	
	try
	(
		t=trackviewnodes;n=t[#Max_MotionClip_Manager];deleteTrackViewController t n.controller
		(getproperty trackviewnodes.Anim_Layer_Control_Manager.controller #animlayers).count=0
	)
	catch()
)

--#######/ mx_炸开模型 /##################
fn Lotus_explodedElement = 
(
	selectOBJ = (selection as array)[1]
	if (classof selectOBJ) == Editable_Poly then 
	(
		max modify mode
		subobjectLevel = 4
		for i = 1 to 100000 do
		(
			selectOBJ.SetSelection #Face #{1}
			selectOBJ.ConvertSelection #Face #Element
			if (selectOBJ.ConvertSelection #Face #Element) == 0 then
			( 
				exit ;
			)	
			else
			(
				selectOBJ.EditablePoly.ConvertSelection #Face #Edge
				polyop.detachEdges selectOBJ (polyop.getEdgeSelection selectOBJ) delete:true asNode:true name:selectOBJ.name
			)
			try( $.pivot = [0,0,0] )catch()
		)
		
		delete selectOBJ
		
		try
		(
			t=trackviewnodes;n=t[#Max_MotionClip_Manager];deleteTrackViewController t n.controller
			(getproperty trackviewnodes.Anim_Layer_Control_Manager.controller #animlayers).count=0
		)
		catch()
	)
)

--#######/ mx_分离模型 /##################
fn Lotus_detachElement = 
(
	selectOBJ = (selection as array)[1]
	if (classof selectOBJ) == Editable_Poly then 
	(
		try
		(
			polyop.detachFaces selectOBJ (polyop.getFaceSelection selectOBJ) delete:true asNode:true name:"temp_detachElement_000"		
			$.pivot = [0,0,0]
		)catch()
	)
)