fn Lotus_installNormalPlugins =
(
	thePluginsName = #("Deformation Cleaner_64.dlm" ,"TopoRelax.dlm" ,"TurboReverse.dlm","GhostTrailsMax2016_64.dlm")
	PluginsServerAddress = theServerAddress_ + "Lotus_Plugin\\常用插件一键安装\\"
	PluginsMAXAddress = (substring scriptsPath 1 ((findString scriptsPath "scripts") - 1)) + "plugins\\"

	for i = 1 to thePluginsName.count do
	(
		copyFile (PluginsServerAddress + thePluginsName[i]) (PluginsMAXAddress + thePluginsName[i] ) 
		print (thePluginsName[i] + "------安装成功")
	)
	print "插件安装完毕，请重新启动3DSMAX"
)
Lotus_installNormalPlugins()









