//
//  MainSceneKitViewController.m
//  iDemo
//
//  Created by 张元科 on 2019/7/30.
//  Copyright © 2019年 张元科. All rights reserved.
//

#import "MainSceneKitViewController.h"
#import <SceneKit/SceneKit.h>

@interface MainSceneKitViewController ()

@end

@implementation MainSceneKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Wolf_dae" withExtension:@"dae"];
    SCNReferenceNode *customNode = [[SCNReferenceNode alloc] initWithURL:url];
    [customNode load];
    SCNView *skView = [[SCNView alloc] initWithFrame:self.view.bounds];
    SCNScene *scene = [SCNScene scene];
    [scene.rootNode addChildNode:customNode];
    [self.view addSubview:skView];
    skView.scene = scene;

    SCNAction *action = [SCNAction repeatAction:[SCNAction rotateByX:1 y:0 z:0 duration:1] count:100];
    [customNode runAction:action];
     */
//
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Wolf_dae" withExtension:@"dae"];
//    SCNReferenceNode *customNode = [[SCNReferenceNode alloc] initWithURL:url];
//    [customNode load];
    
    // 添加场景
    SCNScene *scene = [SCNScene scene];
    
    SCNView *skView = [[SCNView alloc] initWithFrame:self.view.bounds];
    skView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:skView];
    skView.scene = scene;
    
//    [scene.rootNode addChildNode:customNode];
    
    /*
    
    // 添加相机
    SCNCamera *myCamera = [[SCNCamera alloc] init];
    myCamera.fieldOfView = 60;// 视野
    SCNNode *myCameraNode = [[SCNNode alloc] init];
    myCameraNode.camera = myCamera;
    myCameraNode.position = SCNVector3Make(0, 0, 30);
    
    [scene.rootNode addChildNode:myCameraNode];
    
    //创建胶囊
    SCNCapsule * capsule = [SCNCapsule capsuleWithCapRadius:2.5 height:10];
    SCNNode * capsuleNode = [SCNNode nodeWithGeometry:capsule];
    capsuleNode.position = SCNVector3Make(-0, -0, 0);
//    capsuleNode.rotation = SCNVector4Make(0, 0, 1, 3.14 / 2.0);
    capsuleNode.name = @"myCapsule";
    [scene.rootNode addChildNode:capsuleNode];
    
    // 随着父节点一起旋转
    SCNText *text = [SCNText textWithString:@"Balala" extrusionDepth:1];
    text.font = [UIFont systemFontOfSize:2];
    SCNNode *textNode = [SCNNode nodeWithGeometry:text];
    textNode.position = SCNVector3Make(-5, 6, 0);
    [capsuleNode addChildNode:textNode];
   
 
//    SCNGeometry *geo = [SCNGeometry geometry]
//    SCNBox *box1 = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
//    box1.firstMaterial.diffuse.contents = [UIImage imageNamed:@"1.png"];
//    SCNNode *boxNode1 =[SCNNode node];
//    boxNode1.geometry = box1;
//    [scene.rootNode addChildNode:boxNode1];
//
//    SCNBox *box2 = [SCNBox boxWithWidth:10 height:10 length:10 chamferRadius:0];
//    box2.firstMaterial.diffuse.contents = [UIImage imageNamed:@"2.jpg"];
//    SCNNode *boxNode2 =[SCNNode node];
//    boxNode2.position = SCNVector3Make(0, 10, -20);
//    boxNode2.geometry = box2;
//    [scene.rootNode addChildNode:boxNode2];
    
//    SCNPyramid *pyramid = [SCNPyramid pyramidWithWidth:10 height:10 length:1];
//    pyramid.firstMaterial.diffuse.contents = [UIImage imageNamed:@"2.jpg"];
//    SCNNode *pyramidNode = [SCNNode nodeWithGeometry:pyramid];
//    pyramidNode.position = SCNVector3Make(0, 0, 0);
//    [scene.rootNode addChildNode:pyramidNode];
    
    
    SCNSphere *sphere = [SCNSphere sphereWithRadius:10];
    sphere.firstMaterial.diffuse.contents = [UIImage imageNamed:@"2.jpg"];
    SCNNode *sphereNode =[SCNNode nodeWithGeometry:sphere];
    sphereNode.position = SCNVector3Make(0, 0, 0);
    [scene.rootNode addChildNode:sphereNode];
    
      skView.allowsCameraControl = YES;
    
    */
    
//    SCNVector3
//    SCNGeometrySource *geometrySources =  SCNGeometrySource geometrySourceWithNormals:(nonnull const SCNVector3 *) count:
    
    /*
     https://www.jianshu.com/p/748582cca825
     https://www.jianshu.com/p/b0a05bd87f30
     
    let geometrySources = SCNGeometrySource(vertices: [
                                                       SCNVector3(x:  0.1, y: 0.0, z: -0.1),
                                                       SCNVector3(x:  0.1, y: 0.1, z: -0.1),
                                                       SCNVector3(x: -0.1, y: 0.0, z: -0.1),
                                                       ])
    
    let indices: [UInt8] = [0, 1, 2]
    
    let geometryElement = SCNGeometryElement(indices: indices, primitiveType: .triangles)
    
    let geometry = SCNGeometry(sources: [geometrySources], elements: [geometryElement])
    
    skView.allowsCameraControl = YES;
     */
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
