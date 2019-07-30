
rollout uvtools "合并UV" width:200 height:135
(
	groupBox shape1 "UV Template" pos:[10,10] width:80 height:120
	spinner Uvalue "U" pos:[20,30] range:[1,32,1]  type:#integer fieldWidth:30 tooltip:"设置W格子数"
	spinner Vvalue "V" pos:[22,50] range:[1,32,1]  type:#integer fieldWidth:30 tooltip:"设置H格子数"
	button UVscale "确定缩放" pos:[15,70] width:70 height:25	
	button UVresetscale "还原缩放" pos:[15,95] width:70 height:25	
	
	groupBox shape2 "UV Transform" pos:[100,10] width:80 height:90
	button upbutton "上" pos:[110,30] width:25 height:25		
	button downbutton "下" pos:[140,30] width:25 height:25	
	button leftbutton "左" pos:[110,60] width:25 height:25	
	button rightbutton "右" pos:[140,60] width:25 height:25	
		
	
	on UVscale pressed do
	(
		a = 1.0/uvtools.Uvalue.value 
		b = 1.0/uvtools.Vvalue.value 
		$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY a b [0,0,0]
	)
	
	on UVresetscale pressed do
	(
		a = uvtools.Uvalue.value 
		b = uvtools.Vvalue.value 
		$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY a b [0,0,0]
	)
	
	on upbutton pressed do
	(
 
		b = 1.0/uvtools.Vvalue.value 
		$.modifiers[#unwrap_uvw].unwrap2.MoveSelected [0,b,0]
	)

	on downbutton pressed do
	(

		b = 1.0/uvtools.Vvalue.value 
		$.modifiers[#unwrap_uvw].unwrap2.MoveSelected [0,-b,0]
	)


	on leftbutton pressed do
	(
		a = 1.0/uvtools.Uvalue.value 
		
		$.modifiers[#unwrap_uvw].unwrap2.MoveSelected [-a,0,0]
	)


	on rightbutton pressed do
	(
		a = 1.0/uvtools.Uvalue.value 
		
		$.modifiers[#unwrap_uvw].unwrap2.MoveSelected [a,0,0]
	)
		
	
	
	
)
createdialog uvtools





