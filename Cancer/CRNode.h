//
//  CRNode.h
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface CRNode : NSObject

//subclassing notes: remember to call super
- (void)update:(float)timeSinceLastUpdate;

//subclassing notes: remember to call super
//you should not call this method on your children. This is done for you!
- (void)renderWithModelViewMatrix:(GLKMatrix4)modelViewMatrix;

//the transformation matrix applied
//if the node should be rendered itself, call with rendering self
//if the matrix is propagated to the children node, call with NO rendering self
- (GLKMatrix4) modelMatrix:(BOOL)renderingSelf;


//modify the hierarchy
- (void)addChild:(CRNode *)child;

@property (nonatomic, strong) NSMutableArray * children;


//geometric properties of the node

@property (assign) CGSize contentSize;

@property (readonly) CGRect boundingBox;

@property (assign) GLKVector2 position;

@property (assign) GLKVector2 positionVelocity;

@property (assign) float scale;

@property (assign) float scaleVelocity;

@property (assign) float rotation;

@property (assign) float rotationVelocity;


//gestures: this should be more sophisticated
- (void)handleTap:(CGPoint)touchLocation;


@end
