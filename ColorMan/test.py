import os
from collections import OrderedDict
from torch.autograd import Variable
from options.test_options import TestOptions
from data.data_loader import CreateDataLoader
from models.models import create_model
import util.util as util
from util.visualizer import Visualizer
from util import html
import torch

opt = TestOptions().parse(save=False)
opt.nThreads = 1   # test code only supports nThreads = 1
opt.batchSize = 1  # test code only supports batchSize = 1
opt.serial_batches = True  # no shuffle
opt.no_flip = True  # no flip

data_loader = CreateDataLoader(opt)
dataset = data_loader.load_data()
visualizer = Visualizer(opt)
# create website
web_dir = os.path.join(opt.results_dir, opt.name, '%s_%s' % (opt.phase, opt.which_epoch))
webpage = html.HTML(web_dir, 'Experiment = %s, Phase = %s, Epoch = %s' % (opt.name, opt.phase, opt.which_epoch))

# test
if not opt.engine and not opt.onnx:
    model = create_model(opt)
    if opt.data_type == 16:
        model.half()
    '''elif opt.data_type == 8:
        model.type(torch.uint8)#half()'''
            
    if opt.verbose:
        print(model)
else:
    from run_engine import run_trt_engine, run_onnx
    
for i, data in enumerate(dataset):
    if i >= opt.how_many:
        break
    if opt.data_type == 16:
        data['label'] = data['label'].half()
        data['inst']  = data['inst'].half()
    '''elif opt.data_type == 8:
        data['label'] = data['label'].uint8()#uint8()
        data['heat']  = data['heat'].uint8()
        data['PM']  = data['PM'].uint8()
        data['CM']  = data['CM'].uint8()'''
    if opt.export_onnx:
        print ("Exporting to ONNX: ", opt.export_onnx)
        assert opt.export_onnx.endswith("onnx"), "Export model file should end with .onnx"
        torch.onnx.export(model, [data['label'], data['inst']],
                          opt.export_onnx, verbose=True)
        exit(0)
    minibatch = 1 
    if opt.engine:
        generated = run_trt_engine(opt.engine, minibatch, [data['label'], data['inst']])
    elif opt.onnx:
        generated = run_onnx(opt.onnx, opt.data_type, minibatch, [data['label'], data['inst']])
    else:        
        sketch, color, generated = model.inference(data['A'],data['H'], data['inst'], None)#data['image']
        #generated, face, cloth = model.inference(Variable(data['label']),Variable(data['heat']),Variable(data['PM']),Variable(data['CM']),Variable( data['inst']), None)
    #print(face.size())  
    #face = torch.unsqueeze(face,0) 
    #cloth = torch.unsqueeze(cloth,0)
    #hat = torch.unsqueeze(hat,0)
    #jumpsuits = torch.unsqueeze(jumpsuits,0)
    #dress = torch.unsqueeze(dress,0)
    #coat = torch.unsqueeze(coat,0)
    
    visuals = OrderedDict([#('input_label', util.tensor2label(data['label'][0], opt.label_nc)),
                           ('sketch', util.tensor2im(sketch.data[0])),
                           ('color', util.tensor2im(color.data[0])),
                           ('generated', util.tensor2im(generated.data[0]))
])
                           #('hat', util.tensor2im(hat))])
                           #('jumpsuits', util.tensor2im(jumpsuits))])
                           #('dress', util.tensor2im(dress))])
                           #('coat', util.tensor2im(coat))])
                           #('synthesized_image', util.tensor2im(generated.data[0]))])
    img_path = data['path']
    print('process image... %s' % img_path)
    visualizer.save_images(webpage, visuals, img_path)

webpage.save()
