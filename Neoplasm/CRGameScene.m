//
//  CRGameScene.m
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRGameScene.h"
#import "CRCell.h"
#import "CRPulse.h"

#define MIN_DURATION_FOR_NODE_CREATION 0.25

float _minScale = 0.1;

@interface  CRGameScene()

@property (nonatomic, strong) CRPulse * pulse;

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer * pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer * pressGesture;

@property (nonatomic, strong) CRNeoplasm * neoplasm;

@property (readonly) BOOL userIsCreatingANewCell;
@property (nonatomic) CRCell * activeCell; //(creating a new cell next to it)
@end

@implementation CRGameScene

float _scaleForNextUpdate;

- (CRPulse *)pulse
{
    if (!_pulse) {
        _pulse = [CRPulse pulseWithBPM:10];
    } return _pulse;
}

+ (CRGameScene*)newGameInView:(UIView *)view withEffect:(GLKBaseEffect *)effect
{
    CRGameScene * scene = [[self alloc] initWithEffect:effect];
    scene.view = view;
    
    scene.neoplasm = [CRNeoplasm neoplasmWithEffect:effect initialCellAtPoint:GLKVector2Make(100, 200)];
    [scene.children addObject:scene.neoplasm];
    return scene;
}

- (BOOL)userIsCreatingANewCell
{
    return !!self.activeCell;
}


#pragma mark creation of children

- (void)setView:(UIView *)view
{
    [super setView:view];
    if (view) {
        if (!self.userInteractionDisabled) {
            [self setupGestures];
        }
    } else {
        [self setUserInteractionDisabled:YES];
    }
}

#pragma mark gestures

- (UITapGestureRecognizer*)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    } return _tapGesture;
}


- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    } return _panGesture;
}


- (UIPinchGestureRecognizer*)pinchGesture
{
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    } return _pinchGesture;
}

- (UILongPressGestureRecognizer*)pressGesture
{
    if (!_pressGesture) {
        _pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
        _pressGesture.minimumPressDuration = MIN_DURATION_FOR_NODE_CREATION;
    } return _pressGesture;
}

- (void)setUserInteractionDisabled:(BOOL)userInteractionDisabled
{
    [super setUserInteractionDisabled:userInteractionDisabled];
    
    if (userInteractionDisabled) {
        [self.tapGesture removeTarget:self action:@selector(handleTap:)];
        [self.panGesture removeTarget:self action:@selector(panGesture:)];
        [self.pinchGesture removeTarget:self action:@selector(handlePinch:)];
        [self.pressGesture removeTarget:self action:@selector(handlePress:)];
        [self.view removeGestureRecognizer:self.tapGesture];
        [self.view removeGestureRecognizer:self.panGesture];
        [self.view removeGestureRecognizer:self.pinchGesture];
        [self.view removeGestureRecognizer:self.pressGesture];
    } else {
        [self setupGestures];
    }
}

- (void)setupGestures
{
    [self.view addGestureRecognizer:self.tapGesture];
    [self.view addGestureRecognizer:self.panGesture];
    [self.view addGestureRecognizer:self.pinchGesture];
    [self.view addGestureRecognizer:self.pressGesture];
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //determine if the user wants to pan the view or create a new node
        //CGPoint velocity = [recognizer velocityInView:recognizer.view];
        
        //if (sqrt(powf(velocity.x, 2) + powf(velocity.y, 2)) < ) {
        //    self.userIsCreatingANewCell = YES;
        //}
        
        self.positionVelocity = GLKVector2Make(0, 0);
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        
        //CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        //touchLocation = CGPointMake(touchLocation.x, recognizer.view.frame.size.width - touchLocation.y);
        
        if (!self.userIsCreatingANewCell) {
            CGPoint translation = [recognizer translationInView:recognizer.view];
            //translation = CGPointMake(translation.x, - translation.y);
        
            [self.panGesture setTranslation:CGPointZero inView:self.view];
        
            self.position = GLKVector2Make(self.position.x+translation.x, self.position.y-translation.y);
        
        }
        //NSLog(@"add %f %f so that %f, %f", translation.x, translation.y, self.position.x, self.position.y);
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //

        self.activeCell = nil;
        
        //self.positionVelocity = GLKVector2Make(velocity.x, -velocity.y);
    }
}



- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    
        if (GLKVector2Length(self.positionVelocity) > 1) {
            self.positionVelocity = GLKVector2Make(0, 0);
        } else {
            //CGPoint touchLocation = [recognizer locationInView:recognizer.view];

            //GLKVector2 glvector = [self toGLVectorFromMainView:touchLocation];
            
            //[self newCellAtPoint:glvector];
        }
    

    
    
    //if (tap.state == UIGestureRecognizerStateEnded) {
    //GLKVector2 location = [self toGLVectorFromMainView:[tap locationInView:self.view]];
        
        
        /* 
         GHCell * intersectingCell;
         for (GHCell * cell in self.cells) {
         if (CGRectIntersectsRect(cell.boundingBox, CGRectMake(location.x-10, location.y-10, 20, 20))) {
         intersectingCell = cell;
         }
         }
         if (intersectingCell) {
         intersectingCell.pulsate = NO;
         } else {*/
        
        /*}*/
        
        
        
    //}
}

- (void)handlePress:(UILongPressGestureRecognizer*)recognizer
{
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    
    GLKVector2 glvector = [self toGLVectorFromMainView:touchLocation];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CRCell * cell = [self.neoplasm cellAtPoint:glvector];
        if (cell) {
            cell.pulsate = NO;
            self.activeCell = cell;
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.userIsCreatingANewCell) {

            [self.neoplasm newNeighborToCell:self.activeCell atLoaction:glvector];
            self.activeCell.pulsate = YES;
            self.activeCell = nil;
        }
        
    }
}
- (void)handlePinch:(UIPinchGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        self.scale = self.scale *= gesture.scale;
        [gesture setScale:1.0];
    }
}

#pragma mark update

- (void)update:(float)timeSinceLastUpdate
{
    [super update:timeSinceLastUpdate];
    
    //update color of background
    [self.pulse update:timeSinceLastUpdate];
    rgbColor bg;
    bg.b = 0.1;
    bg.r = 0.75+0.15*self.pulse.pulse;
    self.backgroundColor = bg;
    
    //apply friction to velocity of view
    if (GLKVector2Length(self.positionVelocity) > 0.01) {
        self.positionVelocity = GLKVector2MultiplyScalar(self.positionVelocity, 0.9);
    } else {
        self.positionVelocity = GLKVector2Make(0, 0);
    }

}



//maybe factor out into CRNode Class or at least CRScene Class

//this method transforms a point in screen coordinates (eg as given by the uiview) into geometry space coordinates ('world coordinates')
//this is useful for determining the location of a touch with respect to objects in the scene
- (GLKVector2)toGLVectorFromMainView:(CGPoint)point
{

    GLKVector4 gl4vector =  GLKVector4Make(point.x, self.view.frame.size.width - point.y, 0, 1);
    
    //bool invertible;
    //gl4vector = GLKMatrix4MultiplyVector4(GLKMatrix4Invert( [self modelMatrix:NO], &invertible), gl4vector);
    GLKMatrix4 transform = GLKMatrix4Identity;
    
    
    transform = GLKMatrix4Scale(transform, 1.0/self.scale, 1.0/self.scale, 0);
    
    transform = GLKMatrix4Translate(transform, -self.position.x, -self.position.y, 0);
    
    
    gl4vector = GLKMatrix4MultiplyVector4(transform, gl4vector);
    
    
    //NSLog(@"invertible: %d", invertible);
    
    return GLKVector2Make(gl4vector.x, gl4vector.y);
}


@end
