fn CreatU3DCamera =
(
	U3DCamera = ($Main_Camera*)[1]
	U3DCameraFOV = (filterString (filterString U3DCamera.name "(")[2]  ")")[1] as float
	MAXCamera = Freecamera  fovType:2
	MAXCamera.transform = U3DCamera.transform	
	MAXCamera.curFOV = U3DCameraFOV
	in coordsys local rotate MAXCamera (EulerAngles 0 180 0)

)
CreatU3DCamera()
