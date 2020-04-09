import maya.cmds as cmds
def addpre(bb):
	cmds.progressWindow(isInterruptable=1)
	for i in range(bb[0],bb[1]+1):
		print (i)
		cmds.currentTime(i)
		cmds.RenderIntoNewWindow()
		if cmds.progressWindow(query=1, isCancelled=1) : 
			break
	cmds.progressWindow(endProgress=1)
cmds.window('BatchRender')
cmds.columnLayout()
cmds.text(label='StartFrame')
a=cmds.textField(tx='5')
cmds.text(label='EndFrame')
aa=cmds.textField(tx='10')
cmds.button(label='Begin to render',w=220,h=50,command='b=cmds.textField(a,q=1,tx=1);ba=cmds.textField(aa,q=1,tx=1);addpre((int(b),int(ba)))')
cmds.showWindow()