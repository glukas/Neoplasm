//
//  CRScene.h
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//
//  Restrictions: Scenes are assumed to fill the whole screen.
//  The basic usage pattern is:
//  1) Setup a GLKView and a GLKViewController
//  2) Create a Scene with the GLKView as view
//  3) Usually, you enable user interaction
//  3) While using the scene, call its update and render methods
//  4) When you stop using the scene, set userInteractionDisabled to YES
//  5) When you stop using the scene, set it's view property to nil

#import "CRNode.h"

typedef struct {
    float r;
    float g;
    float b;
} rgbColor;

@interface CRScene : CRNode

- (id)initWithEffect:(GLKBaseEffect *)effect;

+ (CRScene *)sceneInView:(UIView *)view effect:(GLKBaseEffect *)effect;

@property (nonatomic) rgbColor backgroundColor;

@property (strong) GLKBaseEffect * effect;

//The scene needs the view to know the bounds, etc.
//If you do not set the view, the scene might not work properly
@property (nonatomic, strong) UIView * view;

//default is yes
@property (nonatomic) BOOL userInteractionDisabled;

@end
