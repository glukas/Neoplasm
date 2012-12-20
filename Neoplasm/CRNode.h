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
//does nothing if child is nil
- (void)addChild:(CRNode *)child;

//does nothing if child is nil
- (void)removeChild:(CRNode *)child;

- (void)moveToTop:(CRNode*)child;

- (void)moveToBottom:(CRNode*)child;

- (void)enumerateChildrenUsingBlock:(void (^)(CRNode * obj, BOOL *stop))block;

- (void)enumerateParentsUsingBlock:(void (^)(CRNode * obj, BOOL *stop))block;

//this method gets called immediately before removeChild: gets called
//you should abandon any references to the child if it is removed and you don't need it anymore
- (void)willRemoveChild:(CRNode*)child;


//this method gets called before the node gets removed from the view hierarchy
- (void)prepareForDeletion;

//geometric properties of the node

@property (assign) CGSize contentSize;

@property (readonly) CGRect boundingBox;

@property (assign) GLKVector2 position;

@property (assign) GLKVector2 positionVelocity;

@property (assign) float scale;

@property (assign) float scaleVelocity;

@property (assign) float rotation;

@property (assign) float rotationVelocity;

@property (assign) GLKVector2 anchorPoint; //values from 0.0 to 1.0 specifying whith respect to shich part of the node scaling should be performed and position assigned

@end
