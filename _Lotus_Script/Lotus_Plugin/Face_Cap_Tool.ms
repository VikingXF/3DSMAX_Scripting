fn FaceCapTool_getMorpher =
(
	pickBlendshapesArray = #("eyeBlinkRight","mouthLowerDownLeft","mouthDimpleRight","browInnerUp","mouthPressLeft","mouthStretchRight","mouthFunnel","mouthLowerDownRight","browOuterUpRight",
	"jawOpen","eyeBlinkLeft","mouthPressRight","jawRight","mouthShrugLower","mouthFrownLeft","cheekPuff","mouthStretchLeft","mouthUpperUpRight","mouthShrugUpper","mouthSmileLeft","mouthClose",
	"jawLeft","mouthDimpleLeft","mouthFrownRight","mouthPucker","mouthSmileRight","mouthUpperUpLeft","browOuterUpLeft")
	
	allarray = selection as array
	theBase = allarray[1]
	deleteitem allarray 1
	
	if theBase.modifiers[#Morpher] == undefined then( addmodifier theBase (Morpher ()) ;theBase.modifiers[#Morpher].Autoload_of_targets = 1 )
		
	for i = 70 to 100 do( try( WM3_MC_Delete theBase.morpher i )catch() )
	
	for i = 1 to pickBlendshapesArray.count do
	(
		for o = 1 to allarray.count do 
		(
			if allarray[o].name == pickBlendshapesArray[i] then
			(
				try
				( 
					WM3_MC_BuildFromNode theBase.morpher (i+69) allarray[o] 
				)catch()
			)	
		)	
	)	
)
--FaceCapTool_getMorpher()

fn FaceCapTool_fbxImporter OBJ filePath =
(
	fn FaceCapTool_copyK baseHead imPorterHead =
	(
		for i = 65 to 100 do 
		(
			for o = 1 to 100 do
			(
				if (filterString baseHead.morpher[i].name " ")[2] == (filterString imPorterHead.morpher[o].name " ")[2] and baseHead.morpher[i].name != "- empty -" then
				(
					temp = imPorterHead.morpher[o].track
					baseHead.morpher[i].track = temp
				)	
			)
		)
	)
	
	baseHead = OBJ
	importFile filePath #noprompt
	theWAVPath = (filterString filePath ".")[1] + ".wav"
	prosound.append theWAVPath
	
	delete $grp_eyeLeft ;delete $eyeLeft ;delete $grp_eyeRight ;delete $eyeRight ;delete $teeth 
	imPorterHead = $head
	imPorterHead.name = "imPorterHead" + ( random 0 99 as string ) + ( random 0 99 as string )
	
	FaceCapTool_copyK baseHead imPorterHead
	delete imPorterHead
	select baseHead
	max zoomext sel
)


try( destroydialog Lotus_FaceCapTool )catch()
rollout Lotus_FaceCapTool "Lotus_FaceCapTool" width:150 height:180
(
	button bt1  "3打开面捕FBX文件" pos:[10,10] width:130 height:70   tooltip:""
	button bt2  "2打开音频" pos:[10,90] width:130 height:40   tooltip:""
	button bt3  "1升级角色表情" pos:[10,132] width:130 height:40  tooltip:""

	on bt1 pressed do with undo on
	(
		obj = (selection as array)[1]
		thePath = getOpenFileName()
		if thePath != undefined and obj != undefined then ( FaceCapTool_fbxImporter obj thePath )
	)
	
	on bt2 pressed do with undo on( try( prosound.open ())catch() )
	on bt3 pressed do with undo on
	( 
		obj = (selection as array)[1]
		thePath = getOpenFileName()
		if thePath != undefined and obj != undefined then
		(
			importFile thePath #noprompt
			obj_IMface = selection as array
			select obj ;selectMore obj_IMface
			try( FaceCapTool_getMorpher())catch() 
			delete obj_IMface
			select obj
			max zoomext sel
		)
	)
)

createdialog Lotus_FaceCapTool pos:[1547,350]

















