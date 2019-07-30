fn Lotus_installDeltaMushToSkin =
(
	pluginsPathINI = theServerAddress_ + "Lotus_Plugin\\DeltaMushToSkin\\deltamushtoskin_serial.ini"
	pluginsPathDLM = theServerAddress_ + "Lotus_Plugin\\DeltaMushToSkin\\DeltaMushToSkin.dlm"

	tempNum = findString DwfExportPreferences.logFileName "ENU"
	theCrackInFile = (substring DwfExportPreferences.logFileName 1 (tempNum + 3)) + "plugcfg_ln\\deltamushtoskin_serial.ini"

	tempNum = findString scriptsPath "scripts"
	thePluginsInFile = (substring scriptsPath 1 (tempNum - 1)) + "plugins\\DeltaMushToSkin.dlm"

	if (doesFileExist theCrackInFile == false) and (doesFileExist thePluginsInFile == false) then
	( 
		copyFile pluginsPathINI theCrackInFile ;copyFile pluginsPathDLM thePluginsInFile 
		print "安装DeltaMushToSkin成功，请重启3dsmax"
	)
	
	tempOBJ = Box lengthsegs:0 widthsegs:0 heightsegs:0 length:0 width:0 height:0 mapcoords:on
	select tempOBJ
	max modify mode
	try
	(
		addModifier tempOBJ (DeltaMushToSkin ()) ui:on
		print "DeltaMushToSkin脚本安装成功,功能可以正常使用"
		delete tempOBJ
	)
	catch
	(
		copyFile pluginsPathINI theCrackInFile ;copyFile pluginsPathDLM thePluginsInFile 
		print "DeltaMushToSkin安装中...请重启3dsmax完成安装"
	)
)
Lotus_installDeltaMushToSkin()









