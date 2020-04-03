
import maya.cmds as cmds
import maya.mel as mel
import os
import demiiris_tool
import demiiris_help

class view_render_bath:
    
    def __init__(self):
        self.render_bath_break = 0
        self.view_render_progress = 0

    
    def rendercamera(self, layername, frame, rendercamera):
        render_camera = rendercamera.split(',')
        end = len(render_camera)
        cmds.progressWindow(edit = True, minValue = 0, progress = 0, maxValue = end)
        for i in render_camera:
            cmds.progressWindow(edit = True, status = 'Render Camera: ' + i)
            if cmds.progressWindow(query = True, isCancelled = True):
                self.render_bath_break = 1
            if self.render_bath_break == 1:
                break
            mel.eval('print("Layer:%s          Frame:%s          Camera:%s\\n")' % (layername, frame, i))
            mel.eval('renderWindowRenderCamera render renderView %s' % i)
            if cmds.progressWindow(query = True, isCancelled = True):
                self.render_bath_break = 1
            if self.render_bath_break == 1:
                break
            cmds.progressWindow(edit = True, step = 1)
        

    
    def renderframe(self, layernm, layername, layerfame, solver, solvernm, rendercamera, imagesize):
        pr_name = '%s_%s' % (layername, layernm)
        solve_frame = layerfame
        if solver == 2:
            solve_frame = range(solvernm, layerfame[-1] + 1)
        cmds.editRenderLayerGlobals(currentRenderLayer = layername)
        size = imagesize.split('x')
        cmds.setAttr('defaultResolution.width', l = 0)
        cmds.setAttr('defaultResolution.height', l = 0)
        cmds.setAttr('defaultResolution.width', int(size[0]))
        cmds.setAttr('defaultResolution.height', int(size[1]))
        cmds.progressBar('pr_%s' % pr_name, edit = True, minValue = 0, maxValue = 100)
        framenm = 0
        for frame in solve_frame:
            if cmds.progressWindow(query = True, isCancelled = True):
                self.render_bath_break = 1
            if self.render_bath_break == 1:
                break
            cmds.currentTime(frame)
            if frame in layerfame:
                framenm += 1
                cmds.progressBar('pr_%s' % pr_name, edit = True, pr = framenm * 100 / len(layerfame))
                self.rendercamera(layername, frame, rendercamera)
            if self.render_bath_break == 1:
                break
                continue

    
    def renderbath(self, renderLayer, indexn, solver, solvernm, output_image):
        if renderLayer == None:
            demiiris_help.view_render_help('sel')
        elif renderLayer[0].split('/')[3] == '':
            demiiris_help.view_render_help('render_No_camera')
        else:
            cmds.modelEditor('modelPanel4', edit = 1, displayAppearance = 'wireframe')
            mel.eval('setRendererInModelPanel base_OpenGL_Renderer modelPanel4')
            layer_nm = 0
            cmds.progressBar('pr_render_layer', edit = 1, pr = 0)
            for (layer, layernm) in zip(renderLayer, indexn):
                layer_nm += 1
                rl = layer.split('/')
                layername = rl[0]
                pr_name = '%s_%s' % (layername, layernm)
                cmds.progressBar('pr_%s' % pr_name, edit = True, pr = 0)
            
            project_path = demiiris_tool.get_file_information('projcect', 'images')
            work_path = demiiris_tool.get_file_information('projcect', 'projectpath')
            change_image_path = 0
            if (':\\' in output_image or '\\\\' in output_image) and project_path != output_image.replace('\\', '/'):
                change_image_path = 1
                cmds.workspace(fileRule = [
                    'images',
                    output_image])
            
        cmds.progressWindow(title = 'Render Camera', progress = 0, status = 'Render Camera: None', isInterruptable = True)
        cmds.progressBar('pr_render_layer', edit = True, minValue = 0, maxValue = 100)
        layer_nm = 0
        open_render_view()
        for (layer, layernm) in zip(renderLayer, indexn):
            if cmds.progressWindow(query = True, isCancelled = True):
                self.render_bath_break = 1
            if self.render_bath_break == 1:
                break
            layer_nm += 1
            rl = layer.split('/')
            layername = rl[0]
            f = rl[1].split(',')
            layerfame = sorted(set(range(int(float(f[0])), int(float(f[1])) + 1, int(float(f[2])))))
            sf = rl[2]
            if sf != '-':
                sd = sf.split(',')
                sfn = map(int, sd)
                layerfame = sorted(set(sfn))
            rendercamera = rl[3]
            imagesize = rl[4]
            self.renderframe(layernm, layername, layerfame, solver, solvernm, rendercamera, imagesize)
            if self.render_bath_break == 1:
                break
            cmds.progressBar('pr_render_layer', edit = 1, pr = layer_nm * 100 / len(renderLayer))
        
        if change_image_path == 1:
            image_path = project_path.replace(work_path, '')
            cmds.workspace(fileRule = [
                'images',
                image_path])
        return self.render_bath_break
        cmds.progressWindow(endProgress = 1)



def view_parameter(type, name):
    sellist = cmds.textScrollList('renderLayer', query = True, selectItem = True)
    selectIndex = cmds.textScrollList('renderLayer', query = True, selectIndexedItem = True)
    if sellist == None:
        demiiris_help.view_render_help('sel')
    elif type == 'Set_up_attributes':
        for (i, n) in zip(sellist, selectIndex):
            cmds.textScrollList('renderLayer', e = 1, removeItem = i)
            b = i.split('/')
            c = b[1].split(',')
            if name == 'StartFrameint':
                c[0] = '%s' % cmds.intField('StartFrameint', query = 1, value = 1)
            if name == 'EndFrameint':
                c[1] = '%s' % cmds.intField('EndFrameint', query = 1, value = 1)
            if name == 'ByFrameint':
                c[2] = '%s' % cmds.intField('ByFrameint', query = 1, value = 1)
            if name == 'single_frame_off':
                b[2] = '-'
            if name == 'single_frame':
                sf = cmds.textField('single_frame', q = 1, text = 1).split(',')
                sf.append('')
                sd = set(sf)
                sd.remove('')
                sfd = []
                for i in sd:
                    
                    try:
                        sfd.append(int(i))
                    continue
                    None
                    None
                    break
                    continue

                
                sfdd = str(sorted(sfd))
                b[2] = sfdd.replace('[', '').replace(']', '').replace(' ', '')
            if name == 'render_camera':
                chamgecamera = set(cmds.textField('render_camera', text = 1, q = 1).split(','))
                cameraall = cmds.ls(type = 'camera')
                camera_render = []
                for ca in chamgecamera:
                    if ca in cameraall:
                        camera_render.append(ca)
                        continue
                if camera_render != []:
                    b[3] = ','.join(camera_render)
                
            b[1] = ','.join(c)
            add = '/'.join(b)
            cmds.textScrollList('renderLayer', edit = True, appendPosition = [
                n,
                add])
        
        for g in selectIndex:
            cmds.textScrollList('renderLayer', edit = True, selectIndexedItem = g)
        
    if type == 'diplay':
        frameramge = sellist[0].split('/')
        frameint = frameramge[1].split(',')
        if name == 'frame':
            cmds.intField('StartFrameint', e = 1, value = float(frameint[0]))
            cmds.intField('EndFrameint', e = 1, value = float(frameint[1]))
            cmds.intField('ByFrameint', e = 1, value = float(frameint[2]))
        if name == 'total':
            cmds.text('render_layer_total', edit = 1, label = 'Total:%s' % len(sellist))
        if name == 'layer_progress':
            pr = cmds.columnLayout('View_Render_layer_progress', q = 1, ca = 1)
            if pr != None:
                for i in pr:
                    cmds.deleteUI(i)
                
            for (rl, n) in zip(sellist, selectIndex):
                rl_pr = rl.split('/')
                pr_name = '%s_%s' % (rl_pr[0], n)
                f = rl_pr[1].split(',')
                layerfame = sorted(set(range(int(float(f[0])), int(float(f[1])) + 1, int(float(f[2])))))
                sf = rl_pr[2]
                if sf != '-':
                    sd = sf.split(',')
                    sfn = map(int, sd)
                    layerfame = sorted(set(sfn))
                cmds.rowLayout(p = 'View_Render_layer_progress', numberOfColumns = 3, columnWidth3 = (100, 53, 150), adjustableColumn = 3)
                cmds.text('l%s' % pr_name, label = rl_pr[0].split(':')[-1])
                cmds.text(label = 'Frame:%s' % len(layerfame))
                cmds.progressBar('pr_%s' % pr_name, width = 250)
                cmds.setParent('..')
            
        if name == 'single_frame':
            cmds.textField('single_frame', edit = 1, text = frameramge[2])
            if frameramge[2] == '-':
                cmds.textField('single_frame', edit = 1, en = 0)
                cmds.radioButtonGrp('single_frame_change', edit = 1, select = 1)
            else:
                cmds.textField('single_frame', edit = 1, en = 1)
                cmds.radioButtonGrp('single_frame_change', edit = 1, select = 2)
        if name == 'render_camera':
            cmds.textField('render_camera', edit = 1, text = frameramge[3])
        


def get_Image_format(render_engine, i):
    if render_engine == 'arnold':
        return cmds.getAttr('defaultArnoldDriver.aiTranslator')
    if None == 'redshift':
        redshift_format_number = demiiris_tool.get_layerattributes().output(i, 'redshiftOptions.imageFormat')
        redshift_Image_format = {
            0: 'iff',
            1: 'exr',
            2: 'png',
            3: 'tga',
            4: 'jpg',
            5: 'tif' }
        return redshift_Image_format.get(redshift_format_number)
    if None == 'vray':
        vray_format = demiiris_tool.get_layerattributes().output(i, 'vraySettings.imageFormatStr')
        if vray_format == None:
            return 'png'
        return None
    if render_engine == 'mentalRay' and render_engine == 'mayaSoftware' and render_engine == 'mayaHardware' and render_engine == 'mayaHardware2' or render_engine == 'turtle':
        Image_format_number = demiiris_tool.get_layerattributes().output(i, 'defaultRenderGlobals.imageFormat')
        Image_Format = {
            0: 'gif',
            1: 'pic',
            2: 'rla',
            3: 'tif',
            4: 'tif16',
            5: 'sgi',
            6: 'als',
            7: 'iff',
            8: 'jpg',
            9: 'eps',
            10: 'iff16',
            11: 'cin',
            12: 'yuv',
            13: 'sgi16',
            16: 'sgi16',
            19: 'tga',
            20: 'bmp',
            23: 'avi',
            31: 'psd',
            32: 'png',
            35: 'dds',
            36: 'Layered(psd)',
            51: 'exr' }
        return Image_Format.get(Image_format_number)


def Refresh_layer():
    allLayer = cmds.ls(type = 'renderLayer')
    layer_dict = { }
    for i in allLayer:
        layer_dict[cmds.getAttr(i + '.do')] = i
    
    sorted(layer_dict)
    layerrenderinformation = []
    for i in layer_dict.values():
        if cmds.getAttr(i + '.renderable') == True:
            render_camera = ','.join(demiiris_tool.get_layerattributes().output(i, 'camera'))
            render_engine = demiiris_tool.get_layerattributes().output(i, 'defaultRenderGlobals.currentRenderer')
            image_size = '%sx%s' % (demiiris_tool.get_layerattributes().output(i, 'defaultResolution.width'), demiiris_tool.get_layerattributes().output(i, 'defaultResolution.height'))
            Image_format = get_Image_format(render_engine, i)
            single_frame = '-'
            layer_frame_range = '%s/%s,%s,%s/%s/%s/%s/%s/%s' % (i, demiiris_tool.get_layerattributes().output(i, 'startFrame'), demiiris_tool.get_layerattributes().output(i, 'endFrame'), demiiris_tool.get_layerattributes().output(i, 'byFrameStep'), single_frame, render_camera, image_size, render_engine, Image_format)
            layerrenderinformation.append(layer_frame_range)
            continue
    cmds.textScrollList('renderLayer', e = 1, ra = 1)
    cmds.textScrollList('renderLayer', e = 1, a = layerrenderinformation)
    pr = cmds.columnLayout('View_Render_layer_progress', q = 1, ca = 1)
    if pr != None:
        for i in pr:
            cmds.deleteUI(i)
        
    rcp = cmds.popupMenu('render_camera_popupMenu', q = 1, itemArray = 1)
    if rcp != None:
        for i in rcp:
            cmds.deleteUI(i)
        
    cameraall = cmds.ls(type = 'camera')
    for a in cameraall:
        cmds.menuItem(parent = 'render_camera_popupMenu', label = a, command = 'view_render.change_render_set("set_camera",",%s")' % a)
    
    if ','.join(demiiris_tool.get_layerattributes().output('defaultRenderLayer', 'camera')) == '':
        demiiris_help.view_render_help('No_camera')


def aboutme():
    cmds.confirmDialog(message = 'By:demiiris\nWeChat:demiiris\nWeChat Public:Demiiris_public\nQQ:260445087\nMail:demiirirs@qq.com\nView Render v 2.0', button = [
        'Close'])


def open_render_view():
    cmds.optionVar(iv = ('renderViewRenderSelectedObj', 0))
    cmds.optionVar(iv = ('renderViewRenderAllLayers', 0))
    cmds.optionVar(iv = ('renderViewAutoRenderRegion', 0))
    cmds.optionVar(iv = ('renderViewAutoResize', 0))
    mel.eval('global int $renderViewShadowsMode = 0')
    mel.eval('global int $renderViewGlowPassMode = 0')
    mel.eval('setTestResolutionVar(1)')


def change_render_set(type, name):
    if type == 'render_camera':
        if name == 1:
            cmds.textField('render_camera', en = 0, edit = 1)
        if name == 0:
            cmds.textField('render_camera', en = 1, edit = 1)
        
    if type == 'set_camera':
        cmds.textField('render_camera', edit = 1, insertText = name)
    if type == 'output_image':
        outname = cmds.textField('output_image_path', text = 1, q = 1)
        if ':\\' in outname or '\\\\' in outname:
            cmds.text('output_image_display', edit = 1, label = 'Output:%s' % (outname + '/tmp').replace('/', '\\'))
        
    if type == 'del_Scroll':
        sellist = cmds.textScrollList('renderLayer', query = True, selectItem = True)
        alllist = cmds.textScrollList('renderLayer', query = True, allItems = True)
        selectIndex = cmds.textScrollList('renderLayer', query = True, selectIndexedItem = True)
        if sellist == None:
            demiiris_help.view_render_help('sel')
        elif name == 'del_sel':
            for aa in cmds.textScrollList('renderLayer', q = 1, selectItem = 1):
                cmds.textScrollList('renderLayer', e = 1, removeItem = aa)
            
        if name == 'reverse':
            if len(sellist) <= 1:
                demiiris_help.view_render_help('reverse')
            else:
                sellist.reverse()
                for (i, n) in zip(sellist, selectIndex):
                    cmds.textScrollList('renderLayer', e = 1, removeItem = i)
                    cmds.textScrollList('renderLayer', edit = True, appendPosition = [
                        n,
                        i])
                
                for g in selectIndex:
                    cmds.textScrollList('renderLayer', edit = True, selectIndexedItem = g)
                
        if sellist == alllist:
            demiiris_help.view_render_help('all_sel')
        elif name == 'move_up':
            for (i, n) in zip(sellist, selectIndex):
                if n == 1:
                    demiiris_help.view_render_help('move_min')
                    continue
                cmds.textScrollList('renderLayer', e = 1, removeItem = i)
                cmds.textScrollList('renderLayer', edit = True, appendPosition = [
                    n - 1,
                    i])
            
            for g in selectIndex:
                cmds.textScrollList('renderLayer', edit = True, selectIndexedItem = g - 1)
            
        if name == 'move_down':
            for (i, n) in zip(sellist, selectIndex):
                if n == len(alllist):
                    demiiris_help.view_render_help('move_max')
                    continue
                cmds.textScrollList('renderLayer', e = 1, removeItem = i)
                cmds.textScrollList('renderLayer', edit = True, appendPosition = [
                    n + 1,
                    i])
            
            for g in selectIndex:
                cmds.textScrollList('renderLayer', edit = True, selectIndexedItem = g + 1)
            
        


def view_render_data(name):
    if name == 'save':
        if cmds.objExists('View_Render_detail_data'):
            cmds.setAttr('View_Render_detail_data.model_solver', l = 0)
            cmds.setAttr('View_Render_detail_data.Layer_detail', l = 0)
            cmds.setAttr('View_Render_detail_data.Output_Image', l = 0)
        else:
            View_Render = cmds.createNode('dof', n = 'View_Render_detail_data')
            cmds.addAttr(View_Render, ln = 'model_solver', dt = 'string')
            cmds.addAttr(View_Render, ln = 'Layer_detail', dt = 'string')
            cmds.addAttr(View_Render, ln = 'Output_Image', dt = 'string')
        model_solver = '%s %s' % (cmds.radioButtonGrp('is_solver_type', q = 1, select = 1), cmds.intField('Is_Solver', value = 1, q = 1))
        view_render_renderLayer_all = ' '.join(cmds.textScrollList('renderLayer', allItems = 1, q = 1))
        view_render_output_image_path = cmds.textField('output_image_path', text = 1, q = 1)
        cmds.setAttr('View_Render_detail_data.model_solver', model_solver, type = 'string', l = 1)
        cmds.setAttr('View_Render_detail_data.Layer_detail', view_render_renderLayer_all, type = 'string', l = 1)
        cmds.setAttr('View_Render_detail_data.Output_Image', view_render_output_image_path, type = 'string', l = 1)
    if name == 'set':
        if cmds.objExists('View_Render_detail_data'):
            model_solver = cmds.getAttr('View_Render_detail_data.model_solver')
            view_render_renderLayer_all = cmds.getAttr('View_Render_detail_data.Layer_detail')
            view_render_output_image_path = cmds.getAttr('View_Render_detail_data.Output_Image')
            cmds.radioButtonGrp('is_solver_type', e = 1, select = int(model_solver.split(' ')[0]))
            if model_solver.split(' ')[0] == '2':
                cmds.intField('Is_Solver', e = 1, en = 1)
            cmds.intField('Is_Solver', e = 1, value = int(model_solver.split(' ')[1]))
            cmds.textScrollList('renderLayer', append = view_render_renderLayer_all.split(' '), e = 1)
            cmds.textField('output_image_path', text = view_render_output_image_path, e = 1)
            cmds.text('output_image_display', e = 1, label = 'Output:%s' % view_render_output_image_path + '\\tmp')
            if view_render_renderLayer_all.replace('[', '').split(' ')[0].split('/')[3] == '':
                demiiris_help.view_render_help('No_camera')
            cameraall = cmds.ls(type = 'camera')
            for a in cameraall:
                cmds.menuItem(parent = 'render_camera_popupMenu', label = a, command = 'view_render.change_render_set("set_camera",",%s")' % a)
            
        else:
            Refresh_layer()
            outputimages = demiiris_tool.get_file_information('projcect', 'images')
            cmds.textField('output_image_path', edit = 1, text = outputimages.replace('/', '\\'))
            cmds.text('output_image_display', edit = 1, label = 'Output:%s' % (outputimages + '/tmp').replace('/', '\\'))
            View_Render = cmds.createNode('dof', n = 'View_Render_detail_data')
            cmds.addAttr(View_Render, ln = 'model_solver', dt = 'string')
            cmds.addAttr(View_Render, ln = 'Layer_detail', dt = 'string')
            cmds.addAttr(View_Render, ln = 'Output_Image', dt = 'string')
            model_solver = '%s %s' % (cmds.radioButtonGrp('is_solver_type', q = 1, select = 1), cmds.intField('Is_Solver', value = 1, q = 1))
            view_render_renderLayer_all = ' '.join(cmds.textScrollList('renderLayer', allItems = 1, q = 1))
            view_render_output_image_path = cmds.textField('output_image_path', text = 1, q = 1)
            cmds.setAttr('View_Render_detail_data.model_solver', model_solver, type = 'string', l = 1)
            cmds.setAttr('View_Render_detail_data.Layer_detail', view_render_renderLayer_all, type = 'string', l = 1)
            cmds.setAttr('View_Render_detail_data.Output_Image', view_render_output_image_path, type = 'string', l = 1)


def view_render_windows():
    startime = demiiris_tool.get_file_information('frame', 'startime')
    animationstarttime = demiiris_tool.get_file_information('frame', 'animationstarttime')
    endtime = demiiris_tool.get_file_information('frame', 'endtime')
    outputimages = demiiris_tool.get_file_information('projcect', 'images') + '/tmp'
    if cmds.dockControl('View_Render', exists = True):
        cmds.deleteUI('View_Render')
    view_render_win = cmds.window(title = 'View Render', widthHeight = (300, 350), menuBar = True)
    cmds.popupMenu()
    cmds.menuItem(label = 'help', command = 'demiiris_help.view_render_help("detail")')
    cmds.menuItem(label = 'about', command = 'view_render.aboutme()')
    cmds.scrollLayout(cr = 1)
    cmds.text(label = 'Select Render Layers')
    cmds.textScrollList('renderLayer', allowMultiSelection = True, deleteKeyCommand = 'view_render.change_render_set("del_Scroll","del_sel");view_render.view_render_data("save")', selectCommand = "view_render.view_parameter('diplay','layer_progress');view_render.view_parameter('diplay','total');view_render.view_parameter('diplay','frame');view_render.view_parameter('diplay','single_frame');view_render.view_parameter('diplay','render_camera')")
    cmds.text('output_image_display', label = '%s' % outputimages.replace('/', '\\'))
    cmds.rowLayout(numberOfColumns = 3, columnWidth3 = (100, 100, 100))
    cmds.button(label = 'File Move Up', c = 'view_render.change_render_set("del_Scroll","move_up")')
    cmds.button(label = 'File Move Down', c = 'view_render.change_render_set("del_Scroll","move_down")')
    cmds.button(label = 'File Sort Reverse', c = 'view_render.change_render_set("del_Scroll","reverse")')
    cmds.setParent('..')
    cmds.radioButtonGrp('is_solver_type', label = 'Model Solver', labelArray2 = [
        'NO',
        'Yes'], numberOfRadioButtons = 2, select = 1, columnWidth3 = (100, 125, 40), onCommand1 = "cmds.intField('Is_Solver',e=1,en=0)", onCommand2 = "cmds.intField('Is_Solver',e=1,en=1)", changeCommand = "view_render.view_render_data('save')")
    cmds.rowColumnLayout(numberOfColumns = 2)
    cmds.text(label = '                   Is Solver  ')
    cmds.intField('Is_Solver', value = animationstarttime, en = 0, width = 50, changeCommand = "view_render.view_render_data('save')")
    cmds.setParent('..')
    cmds.radioButtonGrp(label = 'Frame Ramge From', labelArray2 = [
        'File Layer Attributes',
        'Custom Layer Frame'], numberOfRadioButtons = 2, select = 1, columnWidth3 = (100, 125, 40), onCommand1 = "cmds.intField('StartFrameint',e=1,en=0);cmds.intField('EndFrameint',e=1,en=0);cmds.intField('ByFrameint',e=1,en=0)", onCommand2 = "cmds.intField('StartFrameint',e=1,en=1);cmds.intField('EndFrameint',e=1,en=1);cmds.intField('ByFrameint',e=1,en=1)")
    cmds.rowColumnLayout(numberOfColumns = 6)
    cmds.text(label = '              Start Frame  ')
    cmds.intField('StartFrameint', value = startime, en = 0, width = 50, changeCommand = "view_render.view_parameter('Set_up_attributes','StartFrameint');view_render.view_parameter('diplay','layer_progress');view_render.view_render_data('save')")
    cmds.text(label = 'End Frame')
    cmds.intField('EndFrameint', value = endtime, en = 0, width = 50, changeCommand = "view_render.view_parameter('Set_up_attributes','EndFrameint');view_render.view_parameter('diplay','layer_progress');view_render.view_render_data('save')")
    cmds.text(label = 'By Frame')
    cmds.intField('ByFrameint', value = 1, en = 0, width = 50, changeCommand = "view_render.view_parameter('Set_up_attributes','ByFrameint');view_render.view_parameter('diplay','layer_progress');view_render.view_render_data('save')")
    cmds.setParent('..')
    cmds.radioButtonGrp('single_frame_change', label = 'Set Single Frame', labelArray2 = [
        'NO',
        'Yes'], numberOfRadioButtons = 2, select = 1, columnWidth3 = (100, 125, 40), onCommand1 = "cmds.textField('single_frame',e=1,en=0,text='-');view_render.view_parameter('Set_up_attributes','single_frame_off');view_render.view_parameter('diplay','layer_progress');view_render.view_render_data('save')", onCommand2 = "cmds.textField('single_frame',e=1,en=1)")
    cmds.rowLayout(numberOfColumns = 2, columnWidth2 = (104, 200), adjustableColumn = 2)
    cmds.text(label = '              Single Frame')
    cmds.textField('single_frame', text = '-', en = 0, width = 50, changeCommand = "view_render.view_parameter('Set_up_attributes','single_frame');view_render.view_parameter('diplay','layer_progress');view_render.view_render_data('save')")
    cmds.setParent('..')
    cmds.rowLayout(numberOfColumns = 2, columnWidth2 = (104, 200), adjustableColumn = 2)
    cmds.text('render_camera', label = '        Render Camera')
    cmds.popupMenu(parent = 'render_camera', alt = True, ctl = True)
    cmds.menuItem(label = 'Enable', command = 'view_render.change_render_set("render_camera",cmds.textField("render_camera",en=1,q=1))')
    cmds.textField('render_camera', en = 0, width = 50, changeCommand = "view_render.view_parameter('Set_up_attributes','render_camera');view_render.view_render_data('save')")
    cmds.popupMenu('render_camera_popupMenu', parent = 'render_camera')
    cmds.setParent('..')
    cmds.rowLayout(numberOfColumns = 2, columnWidth2 = (104, 200), adjustableColumn = 2)
    cmds.text(label = '           Output Image')
    cmds.textField('output_image_path', width = 50, changeCommand = 'view_render.change_render_set("output_image","aaa");view_render.view_render_data("save")')
    cmds.setParent('..')
    cmds.rowLayout(numberOfColumns = 4)
    cmds.button(label = 'Open Path Image', command = 'demiiris_tool.openpath(cmds.textField("output_image_path",q=1,text=1)+"/tmp")')
    cmds.button(label = 'Refresh Render', command = "view_render.Refresh_layer();cmds.progressBar('pr_render_layer',edit=1,pr=0);view_render.view_render_data('save')")
    cmds.button(label = 'Start Render', bgc = [
        0.8,
        0.3,
        0.3], command = "view_render.view_render_bath().renderbath(cmds.textScrollList('renderLayer',query=True,selectItem=True),cmds.textScrollList( 'renderLayer', query=True, selectIndexedItem=True),cmds.radioButtonGrp('is_solver_type',q=1,select=1),cmds.intField('Is_Solver',value=1,q=1),cmds.textField('output_image_path',q=1,text=1))")
    cmds.setParent('..')
    cmds.text(label = 'Layer Progress\nNotes: Press "ESC" to interrupt the rendering . . . . .')
    cmds.rowLayout(numberOfColumns = 3, columnWidth3 = (80, 46, 200), adjustableColumn = 3)
    cmds.text(label = 'All Render Layer')
    cmds.text('render_layer_total', label = 'Total:0')
    cmds.progressBar('pr_render_layer', minValue = 0, maxValue = 100, width = 260)
    cmds.setParent('..')
    cmds.columnLayout('View_Render_layer_progress', adjustableColumn = 1)
    cmds.dockControl('View_Render', l = 'View Render', area = 'right', visible = 1, content = view_render_win, allowedArea = [
        'right',
        'left'])
    view_render_data('set')

import maya.cmds as cmds
import maya.mel as mel
import os
import demiiris_tool
import demiiris_help

class view_render_bath:
    
    def __init__(self):
        self.render_bath_break = 0
        self.view_render_progress = 0

    
    def rendercamera(self, layername, frame, rendercamera):
        render_camera = rendercamera.split(',')
        end = len(render_camera)
        cmds.progressWindow(edit = True, minValue = 0, progress = 0, maxValue = end)
        for i in render_camera:
            cmds.progressWindow(edit = True, status = 'Render Camera: ' + i)
            if cmds.progressWindow(query = True, isCancelled = True):
                self.render_bath_break = 1
            if self.render_bath_break == 1:
                break
            mel.eval('print("Layer:%s          Frame:%s          Camera:%s\\n")' % (layername, frame, i))
            mel.eval('renderWindowRenderCamera render renderView %s' % i)
            if cmds.progressWindow(query = True, isCancelled = True):
                self.render_bath_break = 1
            if self.render_bath_break == 1:
                break
            cmds.progressWindow(edit = True, step = 1)
        

    
    def renderframe(self, layernm, layername, layerfame, solver, solvernm, rendercamera, imagesize):
        pr_name = '%s_%s' % (layername, layernm)
        solve_frame = layerfame
        if solver == 2:
            solve_frame = range(solvernm, layerfame[-1] + 1)
        cmds.editRenderLayerGlobals(currentRenderLayer = layername)
        size = imagesize.split('x')
        cmds.setAttr('defaultResolution.width', l = 0)
        cmds.setAttr('defaultResolution.height', l = 0)
        cmds.setAttr('defaultResolution.width', int(size[0]))
        cmds.setAttr('defaultResolution.height', int(size[1]))
        cmds.progressBar('pr_%s' % pr_name, edit = True, minValue = 0, maxValue = 100)
        framenm = 0
        for frame in solve_frame:
            if cmds.progressWindow(query = True, isCancelled = True):
                self.render_bath_break = 1
            if self.render_bath_break == 1:
                break
            cmds.currentTime(frame)
            if frame in layerfame:
                framenm += 1
                cmds.progressBar('pr_%s' % pr_name, edit = True, pr = framenm * 100 / len(layerfame))
                self.rendercamera(layername, frame, rendercamera)
            if self.render_bath_break == 1:
                break
                continue

    
    def renderbath(self, renderLayer, indexn, solver, solvernm, output_image):
        if renderLayer == None:
            demiiris_help.view_render_help('sel')
        elif renderLayer[0].split('/')[3] == '':
            demiiris_help.view_render_help('render_No_camera')
        else:
            cmds.modelEditor('modelPanel4', edit = 1, displayAppearance = 'wireframe')
            mel.eval('setRendererInModelPanel base_OpenGL_Renderer modelPanel4')
            layer_nm = 0
            cmds.progressBar('pr_render_layer', edit = 1, pr = 0)
            for (layer, layernm) in zip(renderLayer, indexn):
                layer_nm += 1
                rl = layer.split('/')
                layername = rl[0]
                pr_name = '%s_%s' % (layername, layernm)
                cmds.progressBar('pr_%s' % pr_name, edit = True, pr = 0)
            
            project_path = demiiris_tool.get_file_information('projcect', 'images')
            work_path = demiiris_tool.get_file_information('projcect', 'projectpath')
            change_image_path = 0
            if (':\\' in output_image or '\\\\' in output_image) and project_path != output_image.replace('\\', '/'):
                change_image_path = 1
                cmds.workspace(fileRule = [
                    'images',
                    output_image])
            
        cmds.progressWindow(title = 'Render Camera', progress = 0, status = 'Render Camera: None', isInterruptable = True)
        cmds.progressBar('pr_render_layer', edit = True, minValue = 0, maxValue = 100)
        layer_nm = 0
        open_render_view()
        for (layer, layernm) in zip(renderLayer, indexn):
            if cmds.progressWindow(query = True, isCancelled = True):
                self.render_bath_break = 1
            if self.render_bath_break == 1:
                break
            layer_nm += 1
            rl = layer.split('/')
            layername = rl[0]
            f = rl[1].split(',')
            layerfame = sorted(set(range(int(float(f[0])), int(float(f[1])) + 1, int(float(f[2])))))
            sf = rl[2]
            if sf != '-':
                sd = sf.split(',')
                sfn = map(int, sd)
                layerfame = sorted(set(sfn))
            rendercamera = rl[3]
            imagesize = rl[4]
            self.renderframe(layernm, layername, layerfame, solver, solvernm, rendercamera, imagesize)
            if self.render_bath_break == 1:
                break
            cmds.progressBar('pr_render_layer', edit = 1, pr = layer_nm * 100 / len(renderLayer))
        
        if change_image_path == 1:
            image_path = project_path.replace(work_path, '')
            cmds.workspace(fileRule = [
                'images',
                image_path])
        return self.render_bath_break
        cmds.progressWindow(endProgress = 1)



def view_parameter(type, name):
    sellist = cmds.textScrollList('renderLayer', query = True, selectItem = True)
    selectIndex = cmds.textScrollList('renderLayer', query = True, selectIndexedItem = True)
    if sellist == None:
        demiiris_help.view_render_help('sel')
    elif type == 'Set_up_attributes':
        for (i, n) in zip(sellist, selectIndex):
            cmds.textScrollList('renderLayer', e = 1, removeItem = i)
            b = i.split('/')
            c = b[1].split(',')
            if name == 'StartFrameint':
                c[0] = '%s' % cmds.intField('StartFrameint', query = 1, value = 1)
            if name == 'EndFrameint':
                c[1] = '%s' % cmds.intField('EndFrameint', query = 1, value = 1)
            if name == 'ByFrameint':
                c[2] = '%s' % cmds.intField('ByFrameint', query = 1, value = 1)
            if name == 'single_frame_off':
                b[2] = '-'
            if name == 'single_frame':
                sf = cmds.textField('single_frame', q = 1, text = 1).split(',')
                sf.append('')
                sd = set(sf)
                sd.remove('')
                sfd = []
                for i in sd:
                    
                    try:
                        sfd.append(int(i))
                    continue
                    None
                    None
                    break
                    continue

                
                sfdd = str(sorted(sfd))
                b[2] = sfdd.replace('[', '').replace(']', '').replace(' ', '')
            if name == 'render_camera':
                chamgecamera = set(cmds.textField('render_camera', text = 1, q = 1).split(','))
                cameraall = cmds.ls(type = 'camera')
                camera_render = []
                for ca in chamgecamera:
                    if ca in cameraall:
                        camera_render.append(ca)
                        continue
                if camera_render != []:
                    b[3] = ','.join(camera_render)
                
            b[1] = ','.join(c)
            add = '/'.join(b)
            cmds.textScrollList('renderLayer', edit = True, appendPosition = [
                n,
                add])
        
        for g in selectIndex:
            cmds.textScrollList('renderLayer', edit = True, selectIndexedItem = g)
        
    if type == 'diplay':
        frameramge = sellist[0].split('/')
        frameint = frameramge[1].split(',')
        if name == 'frame':
            cmds.intField('StartFrameint', e = 1, value = float(frameint[0]))
            cmds.intField('EndFrameint', e = 1, value = float(frameint[1]))
            cmds.intField('ByFrameint', e = 1, value = float(frameint[2]))
        if name == 'total':
            cmds.text('render_layer_total', edit = 1, label = 'Total:%s' % len(sellist))
        if name == 'layer_progress':
            pr = cmds.columnLayout('View_Render_layer_progress', q = 1, ca = 1)
            if pr != None:
                for i in pr:
                    cmds.deleteUI(i)
                
            for (rl, n) in zip(sellist, selectIndex):
                rl_pr = rl.split('/')
                pr_name = '%s_%s' % (rl_pr[0], n)
                f = rl_pr[1].split(',')
                layerfame = sorted(set(range(int(float(f[0])), int(float(f[1])) + 1, int(float(f[2])))))
                sf = rl_pr[2]
                if sf != '-':
                    sd = sf.split(',')
                    sfn = map(int, sd)
                    layerfame = sorted(set(sfn))
                cmds.rowLayout(p = 'View_Render_layer_progress', numberOfColumns = 3, columnWidth3 = (100, 53, 150), adjustableColumn = 3)
                cmds.text('l%s' % pr_name, label = rl_pr[0].split(':')[-1])
                cmds.text(label = 'Frame:%s' % len(layerfame))
                cmds.progressBar('pr_%s' % pr_name, width = 250)
                cmds.setParent('..')
            
        if name == 'single_frame':
            cmds.textField('single_frame', edit = 1, text = frameramge[2])
            if frameramge[2] == '-':
                cmds.textField('single_frame', edit = 1, en = 0)
                cmds.radioButtonGrp('single_frame_change', edit = 1, select = 1)
            else:
                cmds.textField('single_frame', edit = 1, en = 1)
                cmds.radioButtonGrp('single_frame_change', edit = 1, select = 2)
        if name == 'render_camera':
            cmds.textField('render_camera', edit = 1, text = frameramge[3])
        


def get_Image_format(render_engine, i):
    if render_engine == 'arnold':
        return cmds.getAttr('defaultArnoldDriver.aiTranslator')
    if None == 'redshift':
        redshift_format_number = demiiris_tool.get_layerattributes().output(i, 'redshiftOptions.imageFormat')
        redshift_Image_format = {
            0: 'iff',
            1: 'exr',
            2: 'png',
            3: 'tga',
            4: 'jpg',
            5: 'tif' }
        return redshift_Image_format.get(redshift_format_number)
    if None == 'vray':
        vray_format = demiiris_tool.get_layerattributes().output(i, 'vraySettings.imageFormatStr')
        if vray_format == None:
            return 'png'
        return None
    if render_engine == 'mentalRay' and render_engine == 'mayaSoftware' and render_engine == 'mayaHardware' and render_engine == 'mayaHardware2' or render_engine == 'turtle':
        Image_format_number = demiiris_tool.get_layerattributes().output(i, 'defaultRenderGlobals.imageFormat')
        Image_Format = {
            0: 'gif',
            1: 'pic',
            2: 'rla',
            3: 'tif',
            4: 'tif16',
            5: 'sgi',
            6: 'als',
            7: 'iff',
            8: 'jpg',
            9: 'eps',
            10: 'iff16',
            11: 'cin',
            12: 'yuv',
            13: 'sgi16',
            16: 'sgi16',
            19: 'tga',
            20: 'bmp',
            23: 'avi',
            31: 'psd',
            32: 'png',
            35: 'dds',
            36: 'Layered(psd)',
            51: 'exr' }
        return Image_Format.get(Image_format_number)


def Refresh_layer():
    allLayer = cmds.ls(type = 'renderLayer')
    layer_dict = { }
    for i in allLayer:
        layer_dict[cmds.getAttr(i + '.do')] = i
    
    sorted(layer_dict)
    layerrenderinformation = []
    for i in layer_dict.values():
        if cmds.getAttr(i + '.renderable') == True:
            render_camera = ','.join(demiiris_tool.get_layerattributes().output(i, 'camera'))
            render_engine = demiiris_tool.get_layerattributes().output(i, 'defaultRenderGlobals.currentRenderer')
            image_size = '%sx%s' % (demiiris_tool.get_layerattributes().output(i, 'defaultResolution.width'), demiiris_tool.get_layerattributes().output(i, 'defaultResolution.height'))
            Image_format = get_Image_format(render_engine, i)
            single_frame = '-'
            layer_frame_range = '%s/%s,%s,%s/%s/%s/%s/%s/%s' % (i, demiiris_tool.get_layerattributes().output(i, 'startFrame'), demiiris_tool.get_layerattributes().output(i, 'endFrame'), demiiris_tool.get_layerattributes().output(i, 'byFrameStep'), single_frame, render_camera, image_size, render_engine, Image_format)
            layerrenderinformation.append(layer_frame_range)
            continue
    cmds.textScrollList('renderLayer', e = 1, ra = 1)
    cmds.textScrollList('renderLayer', e = 1, a = layerrenderinformation)
    pr = cmds.columnLayout('View_Render_layer_progress', q = 1, ca = 1)
    if pr != None:
        for i in pr:
            cmds.deleteUI(i)
        
    rcp = cmds.popupMenu('render_camera_popupMenu', q = 1, itemArray = 1)
    if rcp != None:
        for i in rcp:
            cmds.deleteUI(i)
        
    cameraall = cmds.ls(type = 'camera')
    for a in cameraall:
        cmds.menuItem(parent = 'render_camera_popupMenu', label = a, command = 'view_render.change_render_set("set_camera",",%s")' % a)
    
    if ','.join(demiiris_tool.get_layerattributes().output('defaultRenderLayer', 'camera')) == '':
        demiiris_help.view_render_help('No_camera')


def aboutme():
    cmds.confirmDialog(message = 'By:demiiris\nWeChat:demiiris\nWeChat Public:Demiiris_public\nQQ:260445087\nMail:demiirirs@qq.com\nView Render v 2.0', button = [
        'Close'])


def open_render_view():
    cmds.optionVar(iv = ('renderViewRenderSelectedObj', 0))
    cmds.optionVar(iv = ('renderViewRenderAllLayers', 0))
    cmds.optionVar(iv = ('renderViewAutoRenderRegion', 0))
    cmds.optionVar(iv = ('renderViewAutoResize', 0))
    mel.eval('global int $renderViewShadowsMode = 0')
    mel.eval('global int $renderViewGlowPassMode = 0')
    mel.eval('setTestResolutionVar(1)')


def change_render_set(type, name):
    if type == 'render_camera':
        if name == 1:
            cmds.textField('render_camera', en = 0, edit = 1)
        if name == 0:
            cmds.textField('render_camera', en = 1, edit = 1)
        
    if type == 'set_camera':
        cmds.textField('render_camera', edit = 1, insertText = name)
    if type == 'output_image':
        outname = cmds.textField('output_image_path', text = 1, q = 1)
        if ':\\' in outname or '\\\\' in outname:
            cmds.text('output_image_display', edit = 1, label = 'Output:%s' % (outname + '/tmp').replace('/', '\\'))
        
    if type == 'del_Scroll':
        sellist = cmds.textScrollList('renderLayer', query = True, selectItem = True)
        alllist = cmds.textScrollList('renderLayer', query = True, allItems = True)
        selectIndex = cmds.textScrollList('renderLayer', query = True, selectIndexedItem = True)
        if sellist == None:
            demiiris_help.view_render_help('sel')
        elif name == 'del_sel':
            for aa in cmds.textScrollList('renderLayer', q = 1, selectItem = 1):
                cmds.textScrollList('renderLayer', e = 1, removeItem = aa)
            
        if name == 'reverse':
            if len(sellist) <= 1:
                demiiris_help.view_render_help('reverse')
            else:
                sellist.reverse()
                for (i, n) in zip(sellist, selectIndex):
                    cmds.textScrollList('renderLayer', e = 1, removeItem = i)
                    cmds.textScrollList('renderLayer', edit = True, appendPosition = [
                        n,
                        i])
                
                for g in selectIndex:
                    cmds.textScrollList('renderLayer', edit = True, selectIndexedItem = g)
                
        if sellist == alllist:
            demiiris_help.view_render_help('all_sel')
        elif name == 'move_up':
            for (i, n) in zip(sellist, selectIndex):
                if n == 1:
                    demiiris_help.view_render_help('move_min')
                    continue
                cmds.textScrollList('renderLayer', e = 1, removeItem = i)
                cmds.textScrollList('renderLayer', edit = True, appendPosition = [
                    n - 1,
                    i])
            
            for g in selectIndex:
                cmds.textScrollList('renderLayer', edit = True, selectIndexedItem = g - 1)
            
        if name == 'move_down':
            for (i, n) in zip(sellist, selectIndex):
                if n == len(alllist):
                    demiiris_help.view_render_help('move_max')
                    continue
                cmds.textScrollList('renderLayer', e = 1, removeItem = i)
                cmds.textScrollList('renderLayer', edit = True, appendPosition = [
                    n + 1,
                    i])
            
            for g in selectIndex:
                cmds.textScrollList('renderLayer', edit = True, selectIndexedItem = g + 1)
            
        


def view_render_data(name):
    if name == 'save':
        if cmds.objExists('View_Render_detail_data'):
            cmds.setAttr('View_Render_detail_data.model_solver', l = 0)
            cmds.setAttr('View_Render_detail_data.Layer_detail', l = 0)
            cmds.setAttr('View_Render_detail_data.Output_Image', l = 0)
        else:
            View_Render = cmds.createNode('dof', n = 'View_Render_detail_data')
            cmds.addAttr(View_Render, ln = 'model_solver', dt = 'string')
            cmds.addAttr(View_Render, ln = 'Layer_detail', dt = 'string')
            cmds.addAttr(View_Render, ln = 'Output_Image', dt = 'string')
        model_solver = '%s %s' % (cmds.radioButtonGrp('is_solver_type', q = 1, select = 1), cmds.intField('Is_Solver', value = 1, q = 1))
        view_render_renderLayer_all = ' '.join(cmds.textScrollList('renderLayer', allItems = 1, q = 1))
        view_render_output_image_path = cmds.textField('output_image_path', text = 1, q = 1)
        cmds.setAttr('View_Render_detail_data.model_solver', model_solver, type = 'string', l = 1)
        cmds.setAttr('View_Render_detail_data.Layer_detail', view_render_renderLayer_all, type = 'string', l = 1)
        cmds.setAttr('View_Render_detail_data.Output_Image', view_render_output_image_path, type = 'string', l = 1)
    if name == 'set':
        if cmds.objExists('View_Render_detail_data'):
            model_solver = cmds.getAttr('View_Render_detail_data.model_solver')
            view_render_renderLayer_all = cmds.getAttr('View_Render_detail_data.Layer_detail')
            view_render_output_image_path = cmds.getAttr('View_Render_detail_data.Output_Image')
            cmds.radioButtonGrp('is_solver_type', e = 1, select = int(model_solver.split(' ')[0]))
            if model_solver.split(' ')[0] == '2':
                cmds.intField('Is_Solver', e = 1, en = 1)
            cmds.intField('Is_Solver', e = 1, value = int(model_solver.split(' ')[1]))
            cmds.textScrollList('renderLayer', append = view_render_renderLayer_all.split(' '), e = 1)
            cmds.textField('output_image_path', text = view_render_output_image_path, e = 1)
            cmds.text('output_image_display', e = 1, label = 'Output:%s' % view_render_output_image_path + '\\tmp')
            if view_render_renderLayer_all.replace('[', '').split(' ')[0].split('/')[3] == '':
                demiiris_help.view_render_help('No_camera')
            cameraall = cmds.ls(type = 'camera')
            for a in cameraall:
                cmds.menuItem(parent = 'render_camera_popupMenu', label = a, command = 'view_render.change_render_set("set_camera",",%s")' % a)
            
        else:
            Refresh_layer()
            outputimages = demiiris_tool.get_file_information('projcect', 'images')
            cmds.textField('output_image_path', edit = 1, text = outputimages.replace('/', '\\'))
            cmds.text('output_image_display', edit = 1, label = 'Output:%s' % (outputimages + '/tmp').replace('/', '\\'))
            View_Render = cmds.createNode('dof', n = 'View_Render_detail_data')
            cmds.addAttr(View_Render, ln = 'model_solver', dt = 'string')
            cmds.addAttr(View_Render, ln = 'Layer_detail', dt = 'string')
            cmds.addAttr(View_Render, ln = 'Output_Image', dt = 'string')
            model_solver = '%s %s' % (cmds.radioButtonGrp('is_solver_type', q = 1, select = 1), cmds.intField('Is_Solver', value = 1, q = 1))
            view_render_renderLayer_all = ' '.join(cmds.textScrollList('renderLayer', allItems = 1, q = 1))
            view_render_output_image_path = cmds.textField('output_image_path', text = 1, q = 1)
            cmds.setAttr('View_Render_detail_data.model_solver', model_solver, type = 'string', l = 1)
            cmds.setAttr('View_Render_detail_data.Layer_detail', view_render_renderLayer_all, type = 'string', l = 1)
            cmds.setAttr('View_Render_detail_data.Output_Image', view_render_output_image_path, type = 'string', l = 1)


def view_render_windows():
    startime = demiiris_tool.get_file_information('frame', 'startime')
    animationstarttime = demiiris_tool.get_file_information('frame', 'animationstarttime')
    endtime = demiiris_tool.get_file_information('frame', 'endtime')
    outputimages = demiiris_tool.get_file_information('projcect', 'images') + '/tmp'
    if cmds.dockControl('View_Render', exists = True):
        cmds.deleteUI('View_Render')
    view_render_win = cmds.window(title = 'View Render', widthHeight = (300, 350), menuBar = True)
    cmds.popupMenu()
    cmds.menuItem(label = 'help', command = 'demiiris_help.view_render_help("detail")')
    cmds.menuItem(label = 'about', command = 'view_render.aboutme()')
    cmds.scrollLayout(cr = 1)
    cmds.text(label = 'Select Render Layers')
    cmds.textScrollList('renderLayer', allowMultiSelection = True, deleteKeyCommand = 'view_render.change_render_set("del_Scroll","del_sel");view_render.view_render_data("save")', selectCommand = "view_render.view_parameter('diplay','layer_progress');view_render.view_parameter('diplay','total');view_render.view_parameter('diplay','frame');view_render.view_parameter('diplay','single_frame');view_render.view_parameter('diplay','render_camera')")
    cmds.text('output_image_display', label = '%s' % outputimages.replace('/', '\\'))
    cmds.rowLayout(numberOfColumns = 3, columnWidth3 = (100, 100, 100))
    cmds.button(label = 'File Move Up', c = 'view_render.change_render_set("del_Scroll","move_up")')
    cmds.button(label = 'File Move Down', c = 'view_render.change_render_set("del_Scroll","move_down")')
    cmds.button(label = 'File Sort Reverse', c = 'view_render.change_render_set("del_Scroll","reverse")')
    cmds.setParent('..')
    cmds.radioButtonGrp('is_solver_type', label = 'Model Solver', labelArray2 = [
        'NO',
        'Yes'], numberOfRadioButtons = 2, select = 1, columnWidth3 = (100, 125, 40), onCommand1 = "cmds.intField('Is_Solver',e=1,en=0)", onCommand2 = "cmds.intField('Is_Solver',e=1,en=1)", changeCommand = "view_render.view_render_data('save')")
    cmds.rowColumnLayout(numberOfColumns = 2)
    cmds.text(label = '                   Is Solver  ')
    cmds.intField('Is_Solver', value = animationstarttime, en = 0, width = 50, changeCommand = "view_render.view_render_data('save')")
    cmds.setParent('..')
    cmds.radioButtonGrp(label = 'Frame Ramge From', labelArray2 = [
        'File Layer Attributes',
        'Custom Layer Frame'], numberOfRadioButtons = 2, select = 1, columnWidth3 = (100, 125, 40), onCommand1 = "cmds.intField('StartFrameint',e=1,en=0);cmds.intField('EndFrameint',e=1,en=0);cmds.intField('ByFrameint',e=1,en=0)", onCommand2 = "cmds.intField('StartFrameint',e=1,en=1);cmds.intField('EndFrameint',e=1,en=1);cmds.intField('ByFrameint',e=1,en=1)")
    cmds.rowColumnLayout(numberOfColumns = 6)
    cmds.text(label = '              Start Frame  ')
    cmds.intField('StartFrameint', value = startime, en = 0, width = 50, changeCommand = "view_render.view_parameter('Set_up_attributes','StartFrameint');view_render.view_parameter('diplay','layer_progress');view_render.view_render_data('save')")
    cmds.text(label = 'End Frame')
    cmds.intField('EndFrameint', value = endtime, en = 0, width = 50, changeCommand = "view_render.view_parameter('Set_up_attributes','EndFrameint');view_render.view_parameter('diplay','layer_progress');view_render.view_render_data('save')")
    cmds.text(label = 'By Frame')
    cmds.intField('ByFrameint', value = 1, en = 0, width = 50, changeCommand = "view_render.view_parameter('Set_up_attributes','ByFrameint');view_render.view_parameter('diplay','layer_progress');view_render.view_render_data('save')")
    cmds.setParent('..')
    cmds.radioButtonGrp('single_frame_change', label = 'Set Single Frame', labelArray2 = [
        'NO',
        'Yes'], numberOfRadioButtons = 2, select = 1, columnWidth3 = (100, 125, 40), onCommand1 = "cmds.textField('single_frame',e=1,en=0,text='-');view_render.view_parameter('Set_up_attributes','single_frame_off');view_render.view_parameter('diplay','layer_progress');view_render.view_render_data('save')", onCommand2 = "cmds.textField('single_frame',e=1,en=1)")
    cmds.rowLayout(numberOfColumns = 2, columnWidth2 = (104, 200), adjustableColumn = 2)
    cmds.text(label = '              Single Frame')
    cmds.textField('single_frame', text = '-', en = 0, width = 50, changeCommand = "view_render.view_parameter('Set_up_attributes','single_frame');view_render.view_parameter('diplay','layer_progress');view_render.view_render_data('save')")
    cmds.setParent('..')
    cmds.rowLayout(numberOfColumns = 2, columnWidth2 = (104, 200), adjustableColumn = 2)
    cmds.text('render_camera', label = '        Render Camera')
    cmds.popupMenu(parent = 'render_camera', alt = True, ctl = True)
    cmds.menuItem(label = 'Enable', command = 'view_render.change_render_set("render_camera",cmds.textField("render_camera",en=1,q=1))')
    cmds.textField('render_camera', en = 0, width = 50, changeCommand = "view_render.view_parameter('Set_up_attributes','render_camera');view_render.view_render_data('save')")
    cmds.popupMenu('render_camera_popupMenu', parent = 'render_camera')
    cmds.setParent('..')
    cmds.rowLayout(numberOfColumns = 2, columnWidth2 = (104, 200), adjustableColumn = 2)
    cmds.text(label = '           Output Image')
    cmds.textField('output_image_path', width = 50, changeCommand = 'view_render.change_render_set("output_image","aaa");view_render.view_render_data("save")')
    cmds.setParent('..')
    cmds.rowLayout(numberOfColumns = 4)
    cmds.button(label = 'Open Path Image', command = 'demiiris_tool.openpath(cmds.textField("output_image_path",q=1,text=1)+"/tmp")')
    cmds.button(label = 'Refresh Render', command = "view_render.Refresh_layer();cmds.progressBar('pr_render_layer',edit=1,pr=0);view_render.view_render_data('save')")
    cmds.button(label = 'Start Render', bgc = [
        0.8,
        0.3,
        0.3], command = "view_render.view_render_bath().renderbath(cmds.textScrollList('renderLayer',query=True,selectItem=True),cmds.textScrollList( 'renderLayer', query=True, selectIndexedItem=True),cmds.radioButtonGrp('is_solver_type',q=1,select=1),cmds.intField('Is_Solver',value=1,q=1),cmds.textField('output_image_path',q=1,text=1))")
    cmds.setParent('..')
    cmds.text(label = 'Layer Progress\nNotes: Press "ESC" to interrupt the rendering . . . . .')
    cmds.rowLayout(numberOfColumns = 3, columnWidth3 = (80, 46, 200), adjustableColumn = 3)
    cmds.text(label = 'All Render Layer')
    cmds.text('render_layer_total', label = 'Total:0')
    cmds.progressBar('pr_render_layer', minValue = 0, maxValue = 100, width = 260)
    cmds.setParent('..')
    cmds.columnLayout('View_Render_layer_progress', adjustableColumn = 1)
    cmds.dockControl('View_Render', l = 'View Render', area = 'right', visible = 1, content = view_render_win, allowedArea = [
        'right',
        'left'])
    view_render_data('set')