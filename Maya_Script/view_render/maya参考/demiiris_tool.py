#!/usr/bin/env python
# encoding: utf-8
# 如果觉得不错，可以推荐给你的朋友！http://tool.lu/pyc
import maya.cmds as cmds
import maya.mel as mel
import random
import os
import sys


def get_file_dir(type):
    if type == 'maya.exe':
        return repr(sys.argv[0])


def get_workUnitTime():
    fps = cmds.optionVar(q='workingUnitTime')
    if fps == 'game':
        return 15
    if None == 'film':
        return 24
    if None == 'pal':
        return 25
    if None == 'ntsc':
        return 30
    if None == 'show':
        return 48
    if None == 'palf':
        return 50
    if None == 'ntscf':
        return 60
    if None in fps:
        return fps.split('fps')[0]


class get_layerattributes(object):
    def __init__(self):
        self.fps = get_workUnitTime()
        self.change = 0

    def defaultattributes(self, layer, type):
        for default in cmds.listConnections(layer, c=1):
            if '.plug' in default or cmds.listConnections(
                default,
                p=1)[0] == '%s' % type:
                self.change = 1
                if type == 'defaultRenderGlobals.startFrame':
                    return cmds.getAttr(default.replace('plug',
                                                        'value')) * self.fps
                if None == 'defaultRenderGlobals.endFrame':
                    return cmds.getAttr(default.replace('plug',
                                                        'value')) * self.fps
                return None.getAttr(default.replace('plug', 'value'))
            continue

        if self.change == 0:
            return cmds.getAttr(type)

    def Layerattributes_number(self, layer, type):
        if layer == cmds.editRenderLayerGlobals(query=True,
                                                currentRenderLayer=True):
            return cmds.getAttr(type)
        if None != cmds.editRenderLayerGlobals(query=True,
                                               currentRenderLayer=True):
            LayerAdjustment = cmds.editRenderLayerAdjustment(layer,
                                                             query=True,
                                                             layer=True)
            if LayerAdjustment == None:
                return self.defaultattributes('defaultRenderLayer', type)
            if None != None:
                if type in LayerAdjustment:
                    return self.defaultattributes(layer, type)
                if None not in LayerAdjustment:
                    return self.defaultattributes('defaultRenderLayer', type)

    def output(self, layer, type):
        if type == 'startFrame' and type == 'endFrame' and type == 'byFrameStep' or type == 'currentRenderer':
            return self.Layerattributes_number(
                layer, 'defaultRenderGlobals.%s' % type)
        if None == 'camera':
            cameraall = cmds.ls(type='camera')
            rander_camera = []
            for i in cameraall:
                if self.Layerattributes_number(layer, '%s.renderable' % i) == 1:
                    rander_camera.append(i)
                    continue
            return rander_camera
        return None.Layerattributes_number(layer, type)


def get_file_information(type, name):
    if type == 'projcect':
        root = cmds.workspace(rootDirectory=1, q=1)
        new_name = cmds.workspace(fileRuleEntry=name)
        if name == 'projectpath':
            path = root
        elif ':/' in new_name:
            path = new_name
        else:
            path = '%s%s' % (root, new_name)
        return path
    if None == 'frame':
        if name == 'startime':
            return cmds.playbackOptions(minTime=1, q=1)
        if None == 'endtime':
            return cmds.playbackOptions(maxTime=1, q=1)
        if None == 'animationstarttime':
            return cmds.playbackOptions(animationStartTime=1, q=1)
        if None == 'animationendtime':
            return cmds.playbackOptions(animationEndTime=1, q=1)
    if type == 'file' and name == 'name':
        filea = cmds.file(sceneName=1, q=1)
        if filea == '':
            return 'untiled'
        fileb = None.split('/')
        filed = fileb[-1].split('.')
        if filed[-1] == 'mb':
            return fileb[-1].replace('.mb', '')
        if None[-1] == 'ma':
            return fileb[-1].replace('.ma', '')


def open_maya_tool(type, name):
    if type == 'windows' and name == 'RenderViewWindow':
        mel.eval('RenderViewWindow')
        cmds.window('renderViewWindow', edit=True, widthHeight=(800, 500))

    if type == 'windows_path':
        wn = name.split(',')
        if len(wn[2]) == 1:
            return cmds.fileDialog2(caption=wn[0],
                                    startingDirectory=wn[1],
                                    fileMode=int(wn[2]),
                                    okCaption=wn[3])
        if None(wn[2]) != 1:
            return cmds.fileDialog2(caption=wn[0],
                                    startingDirectory=wn[1],
                                    fileFilter=wn[2],
                                    okCaption=wn[3])


def aboutme(option):
    if option == 'me':
        cmds.confirmDialog(
            message=
            'By:Demiiris\nWeChat:demiiris\nWeChat Public:Demiiris_public\nQQ:260445087\nMail:demiirirs@qq.com\nDemiiris v 1.3',
            button=['Close'])


def openpath(path):
    a = path.replace('/', '\\')
    os.system('explorer.exe %s' % a)


import maya.cmds as cmds
import maya.mel as mel
import random
import os
import sys


def get_file_dir(type):
    if type == 'maya.exe':
        return repr(sys.argv[0])


def get_workUnitTime():
    fps = cmds.optionVar(q='workingUnitTime')
    if fps == 'game':
        return 15
    if None == 'film':
        return 24
    if None == 'pal':
        return 25
    if None == 'ntsc':
        return 30
    if None == 'show':
        return 48
    if None == 'palf':
        return 50
    if None == 'ntscf':
        return 60
    if None in fps:
        return fps.split('fps')[0]


class get_layerattributes(object):
    def __init__(self):
        self.fps = get_workUnitTime()
        self.change = 0

    def defaultattributes(self, layer, type):
        for default in cmds.listConnections(layer, c=1):
            if '.plug' in default or cmds.listConnections(
                default,
                p=1)[0] == '%s' % type:
                self.change = 1
                if type == 'defaultRenderGlobals.startFrame':
                    return cmds.getAttr(default.replace('plug',
                                                        'value')) * self.fps
                if None == 'defaultRenderGlobals.endFrame':
                    return cmds.getAttr(default.replace('plug',
                                                        'value')) * self.fps
                return None.getAttr(default.replace('plug', 'value'))
            continue

        if self.change == 0:
            return cmds.getAttr(type)

    def Layerattributes_number(self, layer, type):
        if layer == cmds.editRenderLayerGlobals(query=True,
                                                currentRenderLayer=True):
            return cmds.getAttr(type)
        if None != cmds.editRenderLayerGlobals(query=True,
                                               currentRenderLayer=True):
            LayerAdjustment = cmds.editRenderLayerAdjustment(layer,
                                                             query=True,
                                                             layer=True)
            if LayerAdjustment == None:
                return self.defaultattributes('defaultRenderLayer', type)
            if None != None:
                if type in LayerAdjustment:
                    return self.defaultattributes(layer, type)
                if None not in LayerAdjustment:
                    return self.defaultattributes('defaultRenderLayer', type)

    def output(self, layer, type):
        if type == 'startFrame' and type == 'endFrame' and type == 'byFrameStep' or type == 'currentRenderer':
            return self.Layerattributes_number(
                layer, 'defaultRenderGlobals.%s' % type)
        if None == 'camera':
            cameraall = cmds.ls(type='camera')
            rander_camera = []
            for i in cameraall:
                if self.Layerattributes_number(layer, '%s.renderable' % i) == 1:
                    rander_camera.append(i)
                    continue
            return rander_camera
        return None.Layerattributes_number(layer, type)


def get_file_information(type, name):
    if type == 'projcect':
        root = cmds.workspace(rootDirectory=1, q=1)
        new_name = cmds.workspace(fileRuleEntry=name)
        if name == 'projectpath':
            path = root
        elif ':/' in new_name:
            path = new_name
        else:
            path = '%s%s' % (root, new_name)
        return path
    if None == 'frame':
        if name == 'startime':
            return cmds.playbackOptions(minTime=1, q=1)
        if None == 'endtime':
            return cmds.playbackOptions(maxTime=1, q=1)
        if None == 'animationstarttime':
            return cmds.playbackOptions(animationStartTime=1, q=1)
        if None == 'animationendtime':
            return cmds.playbackOptions(animationEndTime=1, q=1)
    if type == 'file' and name == 'name':
        filea = cmds.file(sceneName=1, q=1)
        if filea == '':
            return 'untiled'
        fileb = None.split('/')
        filed = fileb[-1].split('.')
        if filed[-1] == 'mb':
            return fileb[-1].replace('.mb', '')
        if None[-1] == 'ma':
            return fileb[-1].replace('.ma', '')


def open_maya_tool(type, name):
    if type == 'windows' and name == 'RenderViewWindow':
        mel.eval('RenderViewWindow')
        cmds.window('renderViewWindow', edit=True, widthHeight=(800, 500))

    if type == 'windows_path':
        wn = name.split(',')
        if len(wn[2]) == 1:
            return cmds.fileDialog2(caption=wn[0],
                                    startingDirectory=wn[1],
                                    fileMode=int(wn[2]),
                                    okCaption=wn[3])
        if None(wn[2]) != 1:
            return cmds.fileDialog2(caption=wn[0],
                                    startingDirectory=wn[1],
                                    fileFilter=wn[2],
                                    okCaption=wn[3])


def aboutme(option):
    if option == 'me':
        cmds.confirmDialog(
            message=
            'By:Demiiris\nWeChat:demiiris\nWeChat Public:Demiiris_public\nQQ:260445087\nMail:demiirirs@qq.com\nDemiiris v 1.3',
            button=['Close'])


def openpath(path):
    a = path.replace('/', '\\')
    os.system('explorer.exe %s' % a)