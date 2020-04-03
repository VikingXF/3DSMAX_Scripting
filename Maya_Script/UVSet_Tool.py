#-------------------------------------------------------------
#在3dmax中模型UVSet通道为1， 导入fbx到maya，名字是UVchanel1
#这和maya自带的模型UVSet名字map1 有区别， 当你编辑max模型，或者maya中做的模型
#与max做的模型合并时，maya会同时保留map1与UVchanel1 这使的你的模型会出现模型贴图不显示等问题
#解决方法就是，在max模型导入maya时，第一步就是要改模型UVSet的名字，及UVchanel1。
#此脚本功能大意是批量修改选中模型的UVSet的系列操作。
#
#
#尝试写脚本， bug 以及意见需求提交(不保证能解决) 请邮件联系：756427375@qq.com
#-------------------------------------------------------------

import maya.cmds as cmds
import pymel.core as pm


def UVSetsTool_Window():
    if cmds.window('UVSetsTool_Window', ex = 1):    
        cmds.deleteUI('UVSetsTool_Window', window=1);
		
    if cmds.windowPref('UVSetsTool_Window', ex = 1):    
        cmds.windowPref('UVSetsTool_Window', r = 1);

    window = str(cmds.window('UVSetsTool_Window', title="UVSetsTool（beta0.1）", wh=(400, 350)));  

    cmds.columnLayout(adj=1);   
    
    SelectedMode = cmds.radioButtonGrp("Mode1",label='Mode:', labelArray2=['Rename', 'TopUVSet'],numberOfRadioButtons=2,sl=1 )   
    cmds.radioButtonGrp("Mode2",label='',numberOfRadioButtons=2,labelArray2=["Copy","Delete"],shareCollection = SelectedMode)
    
    cmds.setParent( '..' ); 
    cmds.frameLayout(label="Rename UVSet",la="center")    
       
    cmds.textFieldGrp("OldUVSet",label='Old UVSet:', text='OldUVSet',en=1);    
    cmds.textFieldGrp("NewUVSet",label='New UVSet:', text='NewUVSet',en=1);  
    cmds.setParent( '..' ); 
    
    cmds.frameLayout(label="Move UVSet to Top")   
    cmds.textFieldGrp("UVSet1st",label='Which UVSet:', text='Which UVSet',en=0);     
    cmds.setParent( '..' );  
    
    cmds.frameLayout(label="Copy UVSet",la="center")    
    cmds.textFieldGrp("SourceUVSet",label='Copy:', text='SourceUVSet',en=0);    
    cmds.textFieldGrp("TragetUVSet",label='To:', text='TragetUVSet',en=0);  
    
    cmds.frameLayout(label="Delete UVSet")   
    cmds.textFieldGrp("DeleteUVSet",label='Delete UVSet:', text='Which UVSet',en=0);     
    cmds.setParent( '..' );  
    
    
    cmds.columnLayout(adj=1);   
    cmds.button(label = "Apply",command = DoFunction);    
    cmds.button(label = "Close",command = Close_window);    
    cmds.setParent( '..' );  
    cmdOnOldUVSet = "textFieldGrp -e -en 1 OldUVSet;"
    cmdOffOldUVSet = "textFieldGrp -e -en 0 OldUVSet;"
    
    cmdOnNewUVSet = "textFieldGrp -e -en 1 NewUVSet;"
    cmdOffNewUVSet = "textFieldGrp -e -en 0 NewUVSet;"
    
    cmdOn1stUVSet = "textFieldGrp -e -en 1 UVSet1st;"
    cmdOff1stUVSet = "textFieldGrp -e -en 0 UVSet1st;"
    
    cmdOnSourceUVSet = "textFieldGrp -e -en 1 SourceUVSet;"
    cmdOffSourceUVSet = "textFieldGrp -e -en 0 SourceUVSet;"
    
    cmdOnTragetUVSet = "textFieldGrp -e -en 1 TragetUVSet;"
    cmdOffTragetUVSet = "textFieldGrp -e -en 0 TragetUVSet;"
    
    cmdOnDeleteUVSet = "textFieldGrp -e -en 1 DeleteUVSet;"
    cmdOffDeleteUVSet = "textFieldGrp -e -en 0 DeleteUVSet;"
    
    
    cmds.radioButtonGrp("Mode1",on1 = lambda *args :pm.mel.eval((cmdOnOldUVSet + cmdOnNewUVSet + cmdOff1stUVSet + cmdOffSourceUVSet + cmdOffTragetUVSet + cmdOffDeleteUVSet)),
        on2= lambda *args:pm.mel.eval((cmdOffOldUVSet + cmdOffNewUVSet + cmdOn1stUVSet + cmdOffSourceUVSet + cmdOffTragetUVSet + cmdOffDeleteUVSet)),e=1)
    
    cmds.radioButtonGrp("Mode2",on1= lambda *args:pm.mel.eval((cmdOffOldUVSet + cmdOffNewUVSet + cmdOff1stUVSet + cmdOnSourceUVSet + cmdOnTragetUVSet + cmdOffDeleteUVSet)), 
        on2= lambda *args:pm.mel.eval((cmdOffOldUVSet + cmdOffNewUVSet + cmdOff1stUVSet + cmdOffSourceUVSet + cmdOffTragetUVSet + cmdOnDeleteUVSet)), e=1)
    
    cmds.showWindow('UVSetsTool_Window');  


def Rename_UVSets(*args):   
    geo_list = cmds.ls(selection=True);   
    OldUVSetName = str(cmds.textFieldGrp("OldUVSet",q = 1,tx = 1));    
    NewUVSetName = str(cmds.textFieldGrp("NewUVSet",q = 1,tx = 1));
         
    for each in geo_list:
        cmds.select(each,add=False);
        try:            
            cmds.polyUVSet(rename = True,newUVSet = NewUVSetName,uvSet = OldUVSetName);
        except Exception as e:            
            print (e);

def MoveUVSet2Top(*args):
    geo_list = cmds.ls(selection=True);   
    for each in geo_list:
        indices = cmds.polyUVSet(each, query=True, allUVSets=True)
        UVSet_1st = indices[0];
        UVSet_1stNew = str(cmds.textFieldGrp("UVSet1st",q = 1,tx = 1));
        try:
            cmds.polyUVSet( reorder = True, nuv = UVSet_1st, uvSet = UVSet_1stNew);
        except Exception as e:
            print (e);
            
def CopyUVSet(*args):
    geo_list = cmds.ls(selection=True);
    SourceUVSetName = str(cmds.textFieldGrp("SourceUVSet",q = 1,tx = 1));    
    TargetUVSetName = str(cmds.textFieldGrp("TragetUVSet",q = 1,tx = 1));
    for each in geo_list:
        cmds.select(each,add=False);
        try:
            cmds.polyUVSet(copy =True,nuv=TargetUVSetName, uvSet = SourceUVSetName)
        except Exception as e:
            print (e);
    
def DeleteUVSet(*args):
    geo_list = cmds.ls(selection=True);
    DeleteUVSetName = str(cmds.textFieldGrp("DeleteUVSet",q = 1,tx = 1));    
    for each in geo_list:
        cmds.select(each,add=False);
        try:
            cmds.polyUVSet(delete = True,uvSet=DeleteUVSetName)
        except Exception as e:
            print (e);
            
def DoFunction(*args):
    
    RadioSeleted1 = int(cmds.radioButtonGrp("Mode1",query=True,select=1))
    RadioSeleted2 = int(cmds.radioButtonGrp("Mode2",query=True,select=1))
    if RadioSeleted2 == 0 :
        if RadioSeleted1 == 1:
            Rename_UVSets()
        else:
            MoveUVSet2Top()  
    if RadioSeleted1 == 0 :
        if RadioSeleted2 == 1:
            CopyUVSet()
        else:
            DeleteUVSet()  
    
        
def Close_window(*args):    

    cmds.deleteUI('UVSetsTool_Window', window=1);
    


UVSetsTool_Window();