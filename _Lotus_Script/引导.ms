	execute (openFile ("\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\_Lotus_Script\\动画辅助工具盒_function.ms"))
	execute (openFile ("\\\\10.1.1.16\\app事业部\\主创团队\\3D美术组\\培训课\\动作组\\0动画参考资料\\_Lotus_Script\\动画辅助工具盒_ui.ms"))

	try
	(
		local theA = "\\\\10.1.1.16\\app事业部\\主创团队\3D美术组\\培训课\\动作组\\0动画参考资料\\_Lotus_Script\\引导.ms"
		local theB = (scriptsPath + "startup\\引导.ms")
		if doesFileExist theB != true then ( copyFile theA theB )
	)catch()