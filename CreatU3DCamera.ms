fn CreatU3DCamera =
(
	U3DCamera = ($'Main Camera'*)[1]
	U3DCameraFOV = (filterString (filterString U3DCamera.name "(")[2]  ")")[1] as float
	MAXCamera = Freecamera  fovType:2 targetDistance:1 nearclip:1 farclip:1000 nearrange:0 curFOV:U3DCameraFOV farrange:1000 mpassEnabled:off mpassRenderPerPass:off
	MAXCamera.transform = U3DCamera.transform	
	in coordsys local rotate MAXCamera (EulerAngles 0 180 0)
)
CreatU3DCamera()
