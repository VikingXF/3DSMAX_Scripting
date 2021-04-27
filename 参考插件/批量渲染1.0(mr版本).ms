fn numCV0000 num = 
(
	num = (filterString (num as string) "f")[1] as integer
	case of
	(
		( (0 <= num) and (num < 10) ): num = "000" + (num as string)
		( (10 <= num) and (num < 100) ): num = "00" + (num as string)
		( (100 <= num) and (num < 1000) ): num = "0" + (num as string)
		( (1000 <= num) and (num < 10000) ): num = (num as string)
	)
)

basePath = "D:\\0批量渲染"  --主路径
HiddenDOSCommand ("md " + basePath) 
thePath = "C:\Users\Administrator\Desktop\cc"   --批处理的文件夹路径
RanderWidth = 1920
RanderHeight = 1080


PathFileArray = getfiles ( thePath + "\\*.max" )
for i = 1 to PathFileArray.count do
(
	loadMaxFile PathFileArray[i] quiet:true
	--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--
	--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓批量操作的命令↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--
	--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--
	
	if keyboard.escPressed == true then
	(
		exit;
	)
	else
	(
		HiddenDOSCommand ("md " + basePath + "\\" + (filterString maxfilename ".")[1] ) 
		max vpt camera
		try(viewport.setLayout (#layout_1))catch()
			
		renderers.production = mental_ray_renderer()
		
		for i = animationRange.start to animationRange.end do
		(
			if keyboard.escPressed == true then
			(
				exit;
			)
			else
			(
				sliderTime = i	
				windows.processPostedMessages()
				try( render outputSize: [RanderWidth,RanderHeight] vfb:off outputFile:( basePath + "\\" + (filterString maxfilename ".")[1] + "\\" + (numCV0000 i) + ".png" ) gamma:2.2 )catch()
				print (( "\\" + (filterString maxfilename ".")[1] + "\\" + (numCV0000 i) + ".jpg" ) + "_______________已完成")
			)
		)
	)


	--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--
	--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑批量操作的命令↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--
	--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--
	--saveMaxFile PathFileArray[i] quiet:true
)


