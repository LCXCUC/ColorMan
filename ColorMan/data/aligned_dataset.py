import os.path
from data.base_dataset import BaseDataset, get_params, get_transform, normalize
from data.image_folder import make_dataset
from PIL import Image
import torchvision.transforms.functional as F
import torch
import numpy as np
import math
import cv2
import random

class AlignedDataset(BaseDataset):
    def initialize(self, opt):
        self.opt = opt
        self.root = opt.dataroot    

        ### input A (label maps)
        dir_A = '_A' if self.opt.label_nc == 0 else '_label'
        self.dir_A = os.path.join(opt.dataroot, opt.phase + dir_A)
        self.A_paths = sorted(make_dataset(self.dir_A))
        #print(self.A_paths)
        ### input H (heat maps)
        dir_H = '_H' if self.opt.label_nc == 0 else '_heatmaps'
        self.dir_H = os.path.join(opt.dataroot, opt.phase + dir_H)
        self.H_paths = sorted(make_dataset(self.dir_H))

        ### input B (real images)
        if opt.isTrain or opt.use_encoded_image:
            dir_B = '_B' if self.opt.label_nc == 0 else '_img'
            self.dir_B = os.path.join(opt.dataroot, opt.phase + dir_B)  
            self.B_paths = sorted(make_dataset(self.dir_B))

        

        ### instance maps
        if not opt.no_instance:
            self.dir_inst = os.path.join(opt.dataroot, opt.phase + '_inst')
            self.inst_paths = sorted(make_dataset(self.dir_inst))

        ### load precomputed instance-wise encoded features
        if opt.load_features:                              
            self.dir_feat = os.path.join(opt.dataroot, opt.phase + '_feat')
            print('----------- loading features from %s ----------' % self.dir_feat)
            self.feat_paths = sorted(make_dataset(self.dir_feat))

        self.dataset_size = len(self.A_paths) 
      
    def __getitem__(self, index):        
        ### input A (label maps)
        A_path = self.A_paths[index]              
        A = Image.open(A_path).convert('RGB')
        A = A.resize((512, 512), Image.BICUBIC)  
        a=float(np.random.random_integers(-1,1))/float(10)  
        #A = F.adjust_hue(A, a)
        #A = F.adjust_saturation(A,2)
        #w, h = COLOR.size
        #w2 = int(w/3)
        #A = COLOR.crop([0,0,w2,h])    
        params = get_params(self.opt, A.size)
        if self.opt.label_nc == 0:
            transform_A = get_transform(self.opt, params)
            A_tensor = transform_A(A)
        else:
            transform_A = get_transform(self.opt, params, method=Image.NEAREST, normalize=False)
            A_tensor = transform_A(A) * 255.0

        ### input H (heat images)
        H_path = self.H_paths[index]   
        H = Image.open(H_path).convert('RGB')
        #H = COLOR.crop([w2,0,w2,h])
        #H = F.adjust_hue(H, a)
        #H = F.adjust_saturation(H,2)
        #H = F.adjust_brightness(H, -0.2)
        transform_H = get_transform(self.opt, params) 
        H_tensor = transform_H(H)
         
        

        B_tensor = inst_tensor = feat_tensor = 0
        

        ### input B (real images)
        if self.opt.isTrain or self.opt.use_encoded_image:

            B_path = self.B_paths[index]   
            B = Image.open(B_path).convert('RGB')
            #B = COLOR.crop([w2*2,0,w2,h])
            B = F.adjust_hue(B, a)
            transform_B = get_transform(self.opt, params)      
            B_tensor = transform_B(B)

            

        
        
            

        ### if using instance maps        
        if not self.opt.no_instance:
            inst_path = self.inst_paths[index]
            inst = Image.open(inst_path)
            inst_tensor = transform_A(inst)

            if self.opt.load_features:
                feat_path = self.feat_paths[index]            
                feat = Image.open(feat_path).convert('RGB')
                norm = normalize()
                feat_tensor = norm(transform_A(feat))                            

        input_dict = {'A': A_tensor, 'inst': inst_tensor, 'image': B_tensor, 'H': H_tensor, 
                      'feat': feat_tensor, 'path': A_path}#

        return input_dict

    def __len__(self):
        return len(self.A_paths) // self.opt.batchSize * self.opt.batchSize

    def name(self):
        return 'AlignedDataset'
