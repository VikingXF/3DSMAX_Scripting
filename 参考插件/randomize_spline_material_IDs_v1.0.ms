/*
***  RANDOMIZE SPLINE M,ATERIAL IDS v1.0  ***

Script Name:	randomize_spline_material_ids.ms
Compatible:	3dsMax 2012 and higher
Version:		v1.0
Release date:  November 20, 2018
Last update:	November 20, 2018
Code by:		Hernan A. Rodenstein
Website:		www.splinedynamics.com/free-3dsmax-scripts/

Description:
Randomize the material IDs in every spline of the selected shapes. Options to choose: use existing IDs or use range.

Revision History: -
*/

macroScript Randomize_Spline_MatIDs
category:"Spline Dynamics - free scripts"
tooltip:"Randomize Spline Material IDs"
buttontext:"RandSpIDs"
(
	global rndMatIDFloater
	global rndMatIDFloaterPos = [407,77]
	global RL_randMatIDs

	rollout RL_randMatIDs "Randomize Spline Mat.IDs"
	(				
		radiobuttons rbOptions "" labels:#("Use existing", "Use range") offsets:#([0,4],[4,4]) columns:2 align:#left offset:[0,8]
		spinner spnMinID "min ID" range:[1,999,1] type:#integer fieldwidth:30 align:#left offset:[0,6] across:2 enabled:false
		spinner spnMaxID "max ID" range:[1,999,10] type:#integer fieldwidth:30 align:#right offset:[0,6] enabled:false
		button btnRanSplineIDs "RANDOMIZE IDs" width:150 height:30 align:#center offset:[0,12]
		
		label txtAbout1 "Randomize Spline Mat.IDs V1.0" align:#center offset:[0,10]
		hyperLink hlinkAbout "www.SplineDynamics.com" color:blue hoverColor:(color 0 255 255) visitedColor:blue address:"http://www.splinedynamics.com" align:#center offset:[0,-2]
		
		fn randSplineMatIDs shpArr minID:1 maxID:10 useExisting:true =
		(			
			for shp in shpArr do (
				nSplines = numsplines shp
				for spl=1 to nSplines do (
					nSegs = numsegments shp spl					
					if useExisting then (
						idArr = #()
						for seg=1 to nSegs do appendIfUnique idArr (getMaterialID shp spl seg)
						for seg=1 to nSegs do (
							setMaterialID shp spl seg idArr[(random 1 idArr.count)]
						)
					) else (
						for seg=1 to nSegs do (
							setMaterialID shp spl seg (random minID maxID)
						)
					)					
				)
				updateShape shp
			)			
		)
		
		on rbOptions changed state do (
			if state==1 then (
				spnMinID.enabled = false
				spnMaxID.enabled = false
			) else (
				spnMinID.enabled = true
				spnMaxID.enabled = true
			)			
		)
		
		on spnMinID changed val do (
			if val>spnMaxID.value then spnMaxID.value = val
		)
		
		on spnMaxID changed val do (
			if val<spnMinID.value then spnMinID.value = val
		)
		
		on btnRanSplineIDs pressed do (
			
			if selection.count>0 then (
				shpArr = (for obj in selection where (classOf obj.baseObject)==line or (classOf obj.baseObject)==splineShape collect obj) as array
				if shpArr.count>0 then (
					randSplineMatIDs shpArr minID:spnMinID.value maxID:spnMaxID.value useExisting:(if rbOptions.state==1 then true else false)
				) else (
					messageBox "Only Editable Splines allowed."
				)
			) else (
				messageBox "Nothing selected."
			)
		)
	) -- end rollout	
	
	try (
		closerolloutfloater rndMatIDFloater
		rndMatIDFloaterPos = rndMatIDFloater.pos
	) catch()
	
	rndMatIDFloater = newrolloutfloater "Randomize Spline Mat.IDs V1.0" 200 200
	rndMatIDFloater.pos = rndMatIDFloaterPos
	addrollout RL_randMatIDs rndMatIDFloater rolledup:false
	
)