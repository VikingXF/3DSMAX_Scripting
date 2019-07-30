 --#######/  mx_模型检查5边面 /##################
fn Lotus_checkModelFireFace = 
(
	baseOBJ = (selection as array)[1]
	fireVertexFaceNum = #()
	polyop.getNumFaces baseOBJ 	
	for i = 1 to (polyop.getNumFaces baseOBJ) do
	(
		baseOBJ.EditablePoly.SetSelection #Face #{i}
		if (baseOBJ.EditablePoly.ConvertSelection #Face #Vertex) > 4 then( append fireVertexFaceNum i )
	)	
	if fireVertexFaceNum.count != 0 then
	(
		try( baseOBJ.EditablePoly.SetSelection #Face ( fireVertexFaceNum as BitArray ) ;subobjectLevel = 4)catch()
	)
	else
	(
		print ("该模型没有4边以上的面")
		clearSelection()
	)
)
Lotus_checkModelFireFace()