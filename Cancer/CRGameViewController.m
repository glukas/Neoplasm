//
//  CRGameViewController.m
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//


#import "CRGameViewController.h"
#import "CRGameScene.h"

#define DEFAULT_Z_RANGE 512

@interface CRGameViewController()
@property (nonatomic, strong) EAGLContext * context;
@property (nonatomic, strong) GLKBaseEffect * effect;
@property (nonatomic, strong) CRScene * scene;

@end


@implementation CRGameViewController
@synthesize context;
@synthesize scene;
@synthesize effect;


- (void)setupGestures
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

//Whilst it would be more efficient to only perform state changes during the update method, for simplicity gestures are propagates immediately
- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = CGPointMake(touchLocation.x, 320 - touchLocation.y);
    
    [self.scene handleTap:touchLocation];
    
}

#pragma mark lifecycle

//setup view
- (void)viewDidLoad
{
    [super viewDidLoad];
    //The context is needed for drawing
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        [[[NSException alloc] initWithName:@"GLContextFail" reason:@"The device might not support Open GL ES 2" userInfo:nil] raise];
    }
    
    [EAGLContext setCurrentContext:self.context];
    
    //The GLKView makes using GL easier
    //We make sure it's set up properly
    if (![self.view isKindOfClass:[GLKView class]]) {
        self.view = [[GLKView alloc] initWithFrame:self.view.frame context:self.context];
    }
    GLKView * view = (GLKView *)self.view;
    //The view should delegate drawing
    view.delegate = self;
    view.context = self.context;
    
    //The 'effect' dictates how the geometry is rendered.
    //It mimicks a lot of the behaviour of opengl es 1
    self.effect = [[GLKBaseEffect alloc] init];
    
    //how should the scene be projected onto 2d space?
    //since its 2d atm, project without perspective: orthogonal
    //Note that objects outside the z-range will not be rendered
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.frame.size.height, 0, self.view.frame.size.width, -DEFAULT_Z_RANGE, DEFAULT_Z_RANGE);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    //we need to respond to user actions
    [self setupGestures];
    
    //The scene manages the game logic 
    self.scene = [[CRGameScene alloc] initWithEffect:self.effect];
    self.scene.backgroundColor = [UIColor redColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - GLKViewDelegate

//render scene
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    [self.scene renderWithModelViewMatrix:GLKMatrix4Identity];
}

#pragma mark GLKViewController


//apply state changes to the current scene
//note that a GLKViewController can be paused, so that this method doesn't get called
- (void)update {
    
    [self.scene update:self.timeSinceLastUpdate];
}


@end