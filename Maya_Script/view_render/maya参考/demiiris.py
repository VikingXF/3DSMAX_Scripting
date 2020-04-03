#!/usr/bin/env python
# encoding: utf-8
# 如果觉得不错，可以推荐给你的朋友！http://tool.lu/pyc
import maya.cmds as cmds
import maya.mel as mel
import random
import os
import sys
import demiiris_tool
import demiiris_help
import file_render
import view_render
mel.eval('python "import maya.cmds as cmds"')
mel.eval('python "import maya.mel as mel"')
mel.eval('python "import random,os,sys"')
mel.eval('python "import demiiris_tool"')
mel.eval('python "import demiiris_help"')
mel.eval('python "import file_render"')
mel.eval('python "import view_render"')
cmds.menu(p='MayaWindow', label='Demiiris', tearOff=True, aob=1)
cmds.menuItem(
    label='View Render',
    command=
    'demiiris_tool.open_maya_tool("windows","RenderViewWindow");view_render.view_render_windows()')
cmds.menuItem(
    label='File Render',
    command=
    'demiiris_tool.open_maya_tool("windows","RenderViewWindow");file_render.file_render_windows()')
cmds.menuItem(divider=True)
cmds.menuItem(label='about', command='demiiris_tool.aboutme("me")')
import maya.cmds as cmds
import maya.mel as mel
import random
import os
import sys
import demiiris_tool
import demiiris_help
import file_render
import view_render
mel.eval('python "import maya.cmds as cmds"')
mel.eval('python "import maya.mel as mel"')
mel.eval('python "import random,os,sys"')
mel.eval('python "import demiiris_tool"')
mel.eval('python "import demiiris_help"')
mel.eval('python "import file_render"')
mel.eval('python "import view_render"')
cmds.menu(p='MayaWindow', label='Demiiris', tearOff=True, aob=1)
cmds.menuItem(
    label='View Render',
    command=
    'demiiris_tool.open_maya_tool("windows","RenderViewWindow");view_render.view_render_windows()')
cmds.menuItem(
    label='File Render',
    command=
    'demiiris_tool.open_maya_tool("windows","RenderViewWindow");file_render.file_render_windows()')
cmds.menuItem(divider=True)
cmds.menuItem(label='about', command='demiiris_tool.aboutme("me")')