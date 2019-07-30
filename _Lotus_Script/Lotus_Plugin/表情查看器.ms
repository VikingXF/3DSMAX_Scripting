global faceLcObj = selection[1]
try( destroydialog morpherLC )catch()
global morpherLC
rollout morpherLC "角色表情" width:1170 height:900
(	
	subrollout 'sub1' "" pos:[10,40] width:1150 height:870 align:#left
)
createdialog morpherLC pos:[600,50] 	
if faceLcObj != undefined do
(
	midStr = ""
	theH = 1
	theS = 1
	posX = 10
	posY = 10
	startStr = 
"rollout channelName \"\" width:1500 height:900
(	
	button 'bt1' \"数字归零\" pos:[10,10] width:130 height:30 align:#left
	
	on bt1 pressed do
	(
		try
		(
			max modify mode
			modPanel.setCurrentObject faceLcObj.modifiers[#Morpher]
			findCTS = windows.getchildhwnd #max \"Zero Active Channel Values\" 
			uiaccessor.pressbutton findCTS[1]
		)catch()
	)
"
	channelArray = #()
	for i = 1 to 400 do( if (WM3_MC_GetName faceLcObj.modifiers[#Morpher] i) != "" and (WM3_MC_GetName faceLcObj.modifiers[#Morpher] i) != "- empty -" then ( appendIfUnique channelArray i ) )
	for i = 1 to channelArray.count do
	(
		theS += 1
		posX += 140
		morpherName = (WM3_MC_GetName faceLcObj.modifiers[#Morpher] channelArray[i])
		if (mod i 8 ) == 0.0 then
		(
			theH += 1
			theS = 1
			posX = 10
			posY += 40
		)	
	midStr +=
"	groupBox h"+ (theH as string) +"s"+ (theS as string) +"g \""+ morpherName +"\" pos:["+ (posX as string) +","+ (posY as string) +"] width:130 height:40 align:#left
slider h"+ (theH as string) +"s"+ (theS as string) +"s pos:["+ (posX as string) +"+5,"+ (posY as string) +"+15] width:130 height:40 type:#float range:[-100,100,0.1] ticks:0 controller:faceLcObj.modifiers[#Morpher]["+ (channelArray[i] as string) +"]

"	
	)
	endStr =
")
"
execute ( startStr + midStr + endStr )
)
try( AddSubRollout morpherLC.sub1 channelName )catch()