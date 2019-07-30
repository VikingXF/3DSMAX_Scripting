try
(
	Global PolyObj
	Global edges = #{}
	Global removeEdgeCandidate = #{}
	Global removeEdge = #{}
	Global edgeLens = #()
	Global checkFace = #()

	fn FilterPoly obj = classof obj == Editable_Poly

	fn edgeLen num =
	(
		val
		if edgeLens[num] != undefined then 
		( 
			val = edgeLens[num] 
		)
		else
		(
			polyOp.setEdgeSelection PolyObj #{num}
			polyObj.convertselection #edge #vertex
			verts = (polyOp.getVertSelection polyObj) as array
			v1 = polyOp.getVert polyObj verts[1]
			v2 = polyOp.getVert polyObj verts[2]
			val = length(v1-v2)
			edgeLens[num] = val
		)
		val
	)


	PolyObj = (selection as array)[1]
	removeEdgeCandidate = #{}
	removeEdge = #{}
	edgeNum = (polyOp.getNumEdges polyObj)
	edges = #{1..edgeNum}
	keepSm = 1

	for i=1 to edgeNum do edgeLens[i] = undefined
	for i in edges do
	(
		checkFace = (polyOp.getFacesUsingEdge polyObj i) as array
		num = checkFace.count
		if num == 1 then 
		( 
			edges = edges - #{i} 
		)
		else if keepSm == 1 do
		(
			sm1 = polyObj.getFaceSmoothingGroups checkFace[1]
			sm2 = polyObj.getFaceSmoothingGroups checkFace[2]
			res = bit.and sm1 sm2
			if res == 0 then ( edges = edges - #{i} )
		)
	)


	for i in edges do
	(
		checkFace = (polyOp.getFacesUsingEdge polyObj i) as array
		arr1 = (polyOp.getMapFace polyObj 1 checkFace[1]) as bitArray
		arr2 = (polyOp.getMapFace polyObj 1 checkFace[2]) as bitArray
		if (((arr1+arr2) as array).count) > 4 then( edges = edges - #{i} )
	)

	angThres = 45

	for i in edges do
	(
		polyOp.setEdgeSelection polyObj #{i}
		polyObj.convertSelection #edge #face
		checkFace = (polyOp.getFaceSelection polyObj) as array
		n1 = polyOp.getFaceNormal polyObj checkFace[1]
		n2 = polyOp.getFaceNormal polyObj checkFace[2]
		valA = acos(dot n1 n2)
		if valA > angThres then edges = edges - #{i}
	)

	faceNum = polyOp.getNumFaces polyObj
	--print (edges as string)

	for i = 1 to faceNum do
	(
		--print i
		polyOp.setfaceSelection polyObj i
		polyObj.convertSelection #face #edge
		currentEdges = (polyOp.getEdgeSelection polyObj)-(-edges)
		--print currentEdges
		perimeters = #()
		for j in currentEdges do( append perimeters (edgeLen(j)) )
		if perimeters.count!=0 do
		(
			maxEdgeNum = (currentEdges as array)[findItem perimeters (amax perimeters)]
			if removeEdgeCandidate[maxEdgeNum] then ( append removeEdge maxEdgeNum )else ( append removeEdgeCandidate maxEdgeNum )
		)
	)

	polyOp.setEdgeSelection polyObj removeEdge
	undo "Detriangulate" on polyObj.remove selLevel:#edge
	
)catch()

 














