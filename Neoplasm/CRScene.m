//
//  CRScene.m
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRScene.h"

@interface CRScene()

@end

@implementation CRScene

- (id)initWithEffect:(GLKBaseEffect *)effect {
    if ((self = [super init])) {
        self.effect = effect;
        self.userInteractionDisabled = NO;
    }
    return self;
}


- (void)setView:(UIView *)view
{
    _view = view;
    if (view) {
        self.contentSize = view.frame.size;
    } else {
        self.contentSize = CGSizeZero;
    }
}

+ (CRScene *)sceneInView:(UIView*)view effect:(GLKBaseEffect *)effect
{
    CRScene * scene = [[self alloc] initWithEffect:effect];
    scene.view = view;
    return scene;
}

- (void)renderWithModelViewMatrix:(GLKMatrix4)modelViewMatrix
{
    glClearColor(self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [super renderWithModelViewMatrix:modelViewMatrix];
}

@end
