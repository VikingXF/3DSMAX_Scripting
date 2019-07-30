rollout renametool "命名" width:162 height:300
(
	spinner 'spn1' "点上下命名" pos:[16,56] width:64 height:16 range:[0,100,1] type:#integer scale:1 align:#left
	edittext 'edt1' "" pos:[80,16] width:63 height:20 align:#left
	button 'btn1' "获取名字" pos:[16,18] width:56 height:19 align:#left
	button 'btn2' "命名数值归0" pos:[16,88] width:120 height:19 align:#left
	on spn1 changed val do
	(
		a = spn1.value
		a as array
		$.name = edt1.text + a
		$.name = uniquename edt1.text as string
		
	)
	on btn1 pressed do
	(	
		
		if selection.count == 1 do renametool.edt1.text = $.name
		
	)
	on btn2 pressed do
	(
			clearSelection()
			renametool.spn1.value = 1
		)
)





-----------------------


c_tools = newrolloutfloater "拆字工具"  200 200
addrollout renametool c_tools


--------------------------------