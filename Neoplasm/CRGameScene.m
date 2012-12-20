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
#import "CRWhiteTissue.h"

#define MIN_DURATION_FOR_NODE_CREATION 0.1

float _minScale = 0.08;

@interface  CRGameScene()

@property (nonatomic, strong) CRPulse * pulse;

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer * pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer * pressGesture;

@property (nonatomic, strong) CRNeoplasm * neoplasm; //the player

@property (nonatomic, strong) CRWhiteTissue * whiteTissue; //the enemy

@property (readonly) BOOL userIsCreatingANewCell;
@property (nonatomic) CRCell * activeCell; //(creating a new cell next to it)

@property (nonatomic) float savedStrengthOfActiveCell;

@property (nonatomic, strong) CRVessel * activeVessel; //a vessel node used as visual feedback for node creation

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
    
    scene.whiteTissue = [[CRWhiteTissue alloc] initWithEffect:effect];
    scene.whiteTissue.foodSpawner = [[CRSpawner alloc] init];
    
    [scene.whiteTissue.foodSpawner setBounds:GLKVector4Make(1000, -1000, 1000, -1000)];
    
    [scene.whiteTissue.foodSpawner spawnLocations:30];
    
    scene.neoplasm = [CRNeoplasm neoplasmWithEffect:effect initialCellAtPoint:GLKVector2Make(100, 200)];
    [scene.neoplasm enumerateChildrenUsingBlock:^(CRNode *obj, BOOL *stop) {
        if ([obj isKindOfClass:[CRCell class]]) {
            [(CRCell *)obj setStrength:0.8];
        }
    }];
    [scene addChild:scene.whiteTissue];
    [scene addChild:scene.neoplasm];

    [scene moveToBottom:scene.neoplasm];
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

//lazy instanciation...

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
        [self setGesturesEnabled:NO];
        [self.view removeGestureRecognizer:self.tapGesture];
        [self.view removeGestureRecognizer:self.panGesture];
        [self.view removeGestureRecognizer:self.pinchGesture];
        [self.view removeGestureRecognizer:self.pressGesture];
    } else {
        [self setupGestures];
        [self setGesturesEnabled:YES];
    }
}

- (void)setGesturesEnabled:(BOOL)enabled
{
    self.tapGesture.enabled = enabled;
    self.panGesture.enabled = enabled;
    self.pinchGesture.enabled = enabled;
    self.pressGesture.enabled = enabled;
}

- (void)setupGestures
{
    [self.view addGestureRecognizer:self.tapGesture];
    [self.view addGestureRecognizer:self.panGesture];
    [self.view addGestureRecognizer:self.pinchGesture];
    [self.view addGestureRecognizer:self.pressGesture];
}

//actual handling:



- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //determine if the user wants to pan the view or create a new node
        
        
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
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        GLKVector2 velocitygl = GLKVector2Make(velocity.x, -velocity.y);
        if (GLKVector2Length(velocitygl) > 70) {
            self.positionVelocity = velocitygl;
        }
    }
}



- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    self.activeCell = nil;
}

//press is activated after Min_duration_for_node_creation
- (void)handlePress:(UILongPressGestureRecognizer*)recognizer
{
    //reset position velocity
    self.positionVelocity = GLKVector2Make(0, 0);
    
    //get the location of the touch both in screen and world coordinates
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    GLKVector2 touchInWorldCoordinates = [self toSceneCoordinatesFromMainView:touchLocation];
    CRCell *touchedCell = [self.neoplasm cellAtPoint:touchInWorldCoordinates];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //if the user presses a cell, start creating a new child cell
        if (touchedCell) {
            //indicate creation state to user:
            [self startCreatingFromCell:touchedCell];
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //for the moment, just always assume that the user doesn't want to cancel the operation
        if (self.userIsCreatingANewCell) {

            CRFoodSource * foodSource = [self.whiteTissue foodSourceAtPoint:touchInWorldCoordinates];
            //how much does it cost to create new vessels
            
            float cost = 0;
            
            if (foodSource) {
                //connect to new foodcell and create new node
                cost = [self costOfVesselBetweenPosition:self.activeCell.position andPosition:foodSource.position];
                if (self.savedStrengthOfActiveCell > cost) {
                    CRCell * newCell = [self.neoplasm newNeighborToCell:self.activeCell atLocation:foodSource.position];
                    [self.neoplasm addFoodSouce:foodSource toCell:newCell];
                } 
                
            } else if (touchedCell) {
                //create new vessel
                cost = [self costOfVesselBetweenPosition:self.activeCell.position andPosition:touchedCell.position];
                if (self.savedStrengthOfActiveCell > cost) {
                    [self.neoplasm newVesselBetweenCell:self.activeCell andOtherCell:touchedCell];
                }
                
            } else {
                //just create a new node
                cost = [self costOfVesselBetweenPosition:self.activeCell.position andPosition:touchInWorldCoordinates];
                if (self.savedStrengthOfActiveCell > cost) {
                    [self.neoplasm newNeighborToCell:self.activeCell atLocation:touchInWorldCoordinates];
                }
            }
            
            
            //reset state
            [self endCreatingWithCost:cost];
        }
        
    }
}

- (void)startCreatingFromCell:(CRCell*)cell
{
    touchedCell.pulsate = NO;
    self.activeCell = touchedCell;
    self.savedStrengthOfActiveCell = self.activeCell.strength;
    
    self.activeVessel = [[CRVessel alloc] initWithEffect:self.effect];
    self.activeVessel.startPoint = touchedCell.position;
    self.activeVessel.endPoint = touchedCell.position;
    [self addChild:self.activeVessel];
    [self moveToBottom:self.activeVessel];
}

- (void)endCreatingWithCost:(float)cost
{
    self.activeCell.strength = self.savedStrengthOfActiveCell - cost;
    
    self.activeCell.pulsate = YES;
    self.activeCell = nil;
    
    [self removeChild:self.activeVessel];
    self.activeVessel = nil;
}


- (void)handlePinch:(UIPinchGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        self.scale = self.scale *= gesture.scale;
        if (self.scale < _minScale) {
            self.scale = _minScale;
        } else if (self.scale > 1) {
            self.scale = 1;
        }
        //we want the scale to be relative to the last update
        [gesture setScale:1.0];
    }
}



#pragma mark update

- (void)update:(float)timeSinceLastUpdate
{
    if (self.activeVessel) {
        //if creating a new cell, update position of vessel used for feedback
        CGPoint touchLocation = [self.pressGesture locationInView:self.view];
        GLKVector2 glvector = [self toSceneCoordinatesFromMainView:touchLocation];
        
        //creating vessels costs strength, indicate to user how much strength would be used by creating the new connection
        float currentCost = [self costOfVesselBetweenPosition:self.activeCell.position andPosition:glvector];
        if (currentCost < self.savedStrengthOfActiveCell) {
            self.activeVessel.endPoint = glvector;
            self.activeCell.strength = self.savedStrengthOfActiveCell-currentCost;
        } else {
            //only show the vessel as long as the user could potentially create it
            GLKVector2 direction = GLKVector2Normalize(GLKVector2Subtract(glvector, self.activeVessel.startPoint));
            self.activeVessel.endPoint = GLKVector2Add(self.activeVessel.startPoint, GLKVector2MultiplyScalar(direction, self.activeVessel.length));
        }
    }
    
    [super update:timeSinceLastUpdate];
    
    
    [self.pulse update:timeSinceLastUpdate];
    
    //update color of background
    rgbColor bg;
    bg.b = 0.1;
    bg.r = 0.75+0.15*self.pulse.pulse;
    self.backgroundColor = bg;
    
    //apply friction to velocity of view
    if (GLKVector2Length(self.positionVelocity) > 0.01) {
        self.positionVelocity = GLKVector2MultiplyScalar(self.positionVelocity, powf(2, -10*timeSinceLastUpdate));
    } else {
        self.positionVelocity = GLKVector2Make(0, 0);
    }

}

#pragma mark private helpers

- (float)costOfVesselBetweenPosition:(GLKVector2)position1 andPosition:(GLKVector2)position2
{
    float strength_loss_per_unit_distance = 0.001;
    float distance = GLKVector2Distance(position1, position2);
    //NSLog(@"distance: %f", distance);
    return distance*strength_loss_per_unit_distance;
}

//maybe factor out into CRNode Class or at least CRScene Class

//this method transforms a point in screen coordinates (eg as given by the uiview) into geometry space coordinates ('world coordinates')
//this is useful for determining the location of a touch with respect to objects in the scene
- (GLKVector2)toSceneCoordinatesFromMainView:(CGPoint)point
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
