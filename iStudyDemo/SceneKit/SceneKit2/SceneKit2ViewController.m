//
//  SceneKit2ViewController.m
//  iDemo
//
//  Created by 张元科 on 2019/7/31.
//  Copyright © 2019 张元科. All rights reserved.
//

#import "SceneKit2ViewController.h"
#import <SceneKit/SceneKit.h>

@interface SceneKit2ViewController ()

@end

@implementation SceneKit2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self test_box2];
    
}

- (void)test_box2 {
    // 添加场景
    SCNScene *scene = [SCNScene scene];
    
    SCNView *skView = [[SCNView alloc] initWithFrame:self.view.bounds];
    skView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:skView];
    skView.scene = scene;
    
    // 添加相机
    SCNCamera *myCamera = [[SCNCamera alloc] init];
    myCamera.fieldOfView = 90;// 视野
    SCNNode *myCameraNode = [[SCNNode alloc] init];
    myCameraNode.camera = myCamera;
    myCameraNode.position = SCNVector3Make(0, 0, 0.1);
    
    [scene.rootNode addChildNode:myCameraNode];
    
    
    skView.allowsCameraControl = YES;
    
    // 注意长方体每个面的位置：@[front,right,back,left,top,bottom];
    SCNMaterial *front = [SCNMaterial new];
    front.diffuse.contents= @"front.png";
    front.doubleSided = YES;
    SCNMaterial *top = [SCNMaterial new];
    top.diffuse.contents= @"top.png";
    top.doubleSided = YES;
    SCNMaterial *bottom = [SCNMaterial new];
    bottom.diffuse.contents= @"bottom.png";
    bottom.doubleSided = YES;
    SCNMaterial *right = [SCNMaterial new];
    right.diffuse.contents= @"right.png";
    right.doubleSided = YES;
    SCNMaterial *left = [SCNMaterial new];
    left.diffuse.contents= @"left.png";
    left.doubleSided = YES;
    SCNMaterial *back = [SCNMaterial new];
    back.diffuse.contents= @"back.png";
    back.doubleSided = YES;
    
    SCNBox *box2 = [SCNBox boxWithWidth:20 height:20 length:20 chamferRadius:0];
    //    box2.firstMaterial.diffuse.contents = [UIImage imageNamed:@"2.jpg"];
    box2.materials = @[front,right,back,left,top,bottom];
    SCNNode *boxNode2 =[SCNNode node];
    boxNode2.position = SCNVector3Make(0, 0, 0);
    boxNode2.geometry = box2;
    [scene.rootNode addChildNode:boxNode2];
    
}


- (void)test_box {
    // 添加场景
    SCNScene *scene = [SCNScene scene];
    
    SCNView *skView = [[SCNView alloc] initWithFrame:self.view.bounds];
    skView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:skView];
    skView.scene = scene;
    
    // 添加相机
    SCNCamera *myCamera = [[SCNCamera alloc] init];
    myCamera.fieldOfView = 60;// 视野
    SCNNode *myCameraNode = [[SCNNode alloc] init];
    myCameraNode.camera = myCamera;
    myCameraNode.position = SCNVector3Make(0, 0, 30);
    
    [scene.rootNode addChildNode:myCameraNode];
    
    
    skView.allowsCameraControl = YES;
    
    // 注意长方体每个面的位置：@[front,right,back,left,top,bottom];
    SCNMaterial *front = [SCNMaterial new];
    front.diffuse.contents= @"front.png";
    SCNMaterial *top = [SCNMaterial new];
    top.diffuse.contents= @"top.png";
    SCNMaterial *bottom = [SCNMaterial new];
    bottom.diffuse.contents= @"bottom.png";
    SCNMaterial *right = [SCNMaterial new];
    right.diffuse.contents= @"right.png";
    SCNMaterial *left = [SCNMaterial new];
    left.diffuse.contents= @"left.png";
    SCNMaterial *back = [SCNMaterial new];
    back.diffuse.contents= @"back.png";
    
    
    SCNBox *box2 = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
//    box2.firstMaterial.diffuse.contents = [UIImage imageNamed:@"2.jpg"];
    box2.materials = @[front,right,back,left,top,bottom];
    SCNNode *boxNode2 =[SCNNode node];
    boxNode2.position = SCNVector3Make(0, 0, 0);
    boxNode2.geometry = box2;
    [scene.rootNode addChildNode:boxNode2];
    
}

- (void)test_sphere {
    // 添加场景
    SCNScene *scene = [SCNScene scene];
    
    SCNView *skView = [[SCNView alloc] initWithFrame:self.view.bounds];
    skView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:skView];
    skView.scene = scene;
    
    // 添加相机
    SCNCamera *myCamera = [[SCNCamera alloc] init];
    myCamera.fieldOfView = 60;// 视野
    SCNNode *myCameraNode = [[SCNNode alloc] init];
    myCameraNode.camera = myCamera;
    myCameraNode.position = SCNVector3Make(0, 0, 30);
    
    [scene.rootNode addChildNode:myCameraNode];
    
    
    SCNSphere *sphere = [SCNSphere sphereWithRadius:10];
    sphere.firstMaterial.diffuse.contents = [UIImage imageNamed:@"timg.jpeg"];
    SCNNode *sphereNode =[SCNNode nodeWithGeometry:sphere];
    sphereNode.position = SCNVector3Make(0, 0, 0);
    [scene.rootNode addChildNode:sphereNode];
    
    skView.allowsCameraControl = YES;

}

@end
