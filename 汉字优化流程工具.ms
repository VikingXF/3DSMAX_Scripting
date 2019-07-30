
fn reName =
(
	ourModleArray =#()
	append  ourModleArray $ 	
	$.name = ourModleArray.count as string
)

rollout Texttools "汉字优化流程工具" width:300 height:115
(
	groupBox shape1 "拆分笔画" pos:[10,10] width:80 height:100
	
	button modledetach "拆分" pos:[15,30] width:70 height:25	
	button modleattach "合并" pos:[15,55] width:70 height:25
	
	
	groupBox shape2 "笔画命名" pos:[100,10] width:80 height:100
	
	button modlename "命名" pos:[105,30] width:70 height:25	
	spinner Uvalue "序号" pos:[105,65] range:[1,100,1]  type:#integer fieldWidth:30 tooltip:"笔画顺序"
	
	groupBox shape3 "自动笔画命名" pos:[190,10] width:100 height:50		
	checkbutton myCheckBox "顺序命名" pos:[200,30] width:70 height:25
	
	button zero "坐标归零" pos:[200,70] width:70 height:25
--------------------------------------------------------------------------------------------------	
-------执行拆分------------
	on modledetach pressed do
	(
		selectModle = (selection as array)[1]
		local selectName = "$"+selectModle.name
		max modify mode
		subobjectLevel = 5
		for i = 1 to 10000 do
		(
			selectModle.SetSelection #Face #{1}
			selectModle.ConvertSelection #Face #Element
			if (selectModle.ConvertSelection #Face #Element) == 0 then
			( 				
				exit;
			)	
			else
			(
				selectModle.EditablePoly.ConvertSelection #Face #Edge
				polyop.detachEdges selectModle (polyop.getEdgeSelection selectModle) delete:true asNode:true name:selectModle.name
			)		
		)

		delete selectModle
		execute ("select " + selectName + "*") 
		IsolateSelection.EnterIsolateSelectionMode()	
	)
--------------------------------------------------------------------------------------------------
-------执行合并------------
	on modleattach pressed do
	(
		selectModleArray = selection as array 
		convertTo selectModleArray Editable_Poly
		theBaseOBJ = selectModleArray[1]
		for i = 2 to selectModleArray.count do
		(
			theBaseOBJ.EditablePoly.attach selectModleArray[i] theBaseOBJ
		)
		
	)
--------------------------------------------------------------------------------------------------	
-------执行命名------------	
	on modlename pressed do
	(
		$.name = Uvalue.value as string
	
	)	
--------------------------------------------------------------------------------------------------	
-------执行自动命名------------	
	on myCheckBox changed State do	
	(
		if state == on then
		(								
			callbacks.addScript #selectionSetChanged "reName()" id:#reNameCallback
		
		)
		else
		(
			callbacks.removeScripts #selectionSetChanged id:#reNameCallback
		)	
	
	)	
	
--------------------------------------------------------------------------------------------------	
-------坐标归零------------		
	on zero pressed do
	with undo on
	(
		for i in selection do
		(
		    i.pivot.x = 0
		    i.pivot.y = 0
		    i.pivot.z = 0
		)
		
	)

	
)
createdialog Texttools