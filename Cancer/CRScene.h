//
//  CRScene.h
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRNode.h"

@interface CRScene : CRNode

- (id)initWithEffect:(GLKBaseEffect *)effect;

+ (CRScene *)sceneInView:(UIView *)view effect:(GLKBaseEffect *)effect;

@property (nonatomic, strong) UIColor * backgroundColor;

//The scene needs the view to know the bounds, etc.
//If you do not set the view, the scene might not work properly
@property (nonatomic, strong) UIView * view;

@end
