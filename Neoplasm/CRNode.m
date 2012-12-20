//
//  CRNode.m
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRNode.h"

@interface  CRNode()
@property (nonatomic, strong) NSMutableArray * nodesToDelete;
@property (nonatomic, strong) NSMutableOrderedSet * children;
@property (nonatomic, strong) NSMutableOrderedSet * parents;
@end

@implementation CRNode

- (NSMutableOrderedSet *)children
{
    if (!_children) {
        _children = [NSMutableOrderedSet orderedSet];
    } return _children;
}

- (NSMutableOrderedSet *)parents
{
    if (!_parents) {
        _parents = [NSMutableOrderedSet orderedSet];
    } return _parents;
}

- (NSMutableArray *)nodesToDelete
{
    if (!_nodesToDelete) {
        _nodesToDelete = [NSMutableArray array];
    } return _nodesToDelete;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.scale = 1.0;
        self.anchorPoint = GLKVector2Make(1.0/2, 1.0/2);
    }
    return self;
}

#pragma mark rendering

- (void)renderWithModelViewMatrix:(GLKMatrix4)modelViewMatrix
{
    GLKMatrix4 childModelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, [self modelMatrix:NO]);
    //render children
    for (CRNode * node in self.children) {
        [node renderWithModelViewMatrix:childModelViewMatrix];
    }
}


- (GLKMatrix4) modelMatrix:(BOOL)renderingSelf
{
    //start with identity
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    
    
    //scale
    modelMatrix = GLKMatrix4Scale(modelMatrix, self.scale, self.scale, 0);

    
    //translate so that position is at bottom left corner
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x/self.scale, self.position.y/self.scale, 0);


    //rotate
    float radians = GLKMathDegreesToRadians(self.rotation);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, radians, 0, 0, 1);
    
    
    //moves the object so that the position is at the center of the content (center = anchor)
    if (renderingSelf) {
        modelMatrix = GLKMatrix4Translate(modelMatrix, -self.anchorPoint.x*self.contentSize.width, -self.anchorPoint.y*self.contentSize.height, 0);
    }
    
    return modelMatrix;
    
}

#pragma mark state change

- (void)update:(float)timeSinceLastUpdate
{
    //perform child removal
    for (CRNode * node in self.nodesToDelete) {
        [self.children removeObject:node];
    }
    [self.nodesToDelete removeAllObjects];
    
    //propate to children
    for (CRNode * node in self.children) {
        [node update:timeSinceLastUpdate];
    }
    
    //apply velocities
    GLKVector2 curMove = GLKVector2MultiplyScalar(self.positionVelocity, timeSinceLastUpdate);
    self.position = GLKVector2Add(self.position, curMove);
    
    float curRotate = self.rotationVelocity * timeSinceLastUpdate;
    self.rotation = self.rotation + curRotate;
    
    float curScale = self.scaleVelocity * timeSinceLastUpdate;
    self.scale = self.scale + curScale;
    
}

#pragma mark properties

- (CGRect)boundingBox
{
    CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    //here we need to transform the bounging box so that the scale is applied and we get a box that is closest possible
    GLKMatrix4 modelMatrix = [self modelMatrix:YES];
    CGAffineTransform transform = CGAffineTransformMake(modelMatrix.m00, modelMatrix.m01, modelMatrix.m10, modelMatrix.m11, modelMatrix.m30, modelMatrix.m31);
    return CGRectApplyAffineTransform(rect, transform);
}


#pragma mark hierarchy

- (void)addChild:(CRNode *)child
{
    if (child) {
        [child.parents addObject:self];
        [self.children addObject:child];
    }
}

- (void)removeChild:(CRNode *)child
{
    if (child) {
        [child prepareForDeletion];
        [self willRemoveChild:child];
        [self.nodesToDelete addObject:child];
        [child.parents removeObject:self];
    }
}

- (void)enumerateChildrenUsingBlock:(void (^)(CRNode*, BOOL *))block
{
    [self.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block((CRNode*)obj, stop);
    }];
}

- (void)enumerateParentsUsingBlock:(void (^)(CRNode *, BOOL *))block
{
    [self.parents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block((CRNode*)obj, stop);
    }];
}

- (void)moveToBottom:(CRNode *)child
{
    NSUInteger index = [self.children indexOfObject:child];
    if (index != NSNotFound) {
        [self.children moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:index] toIndex:0];
    }
}


- (void)moveToTop:(CRNode *)child
{
    NSUInteger index = [self.children indexOfObject:child];
    if (index != NSNotFound) {
        [self.children moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:index] toIndex:self.children.count-1];
    }
}

- (void)willRemoveChild:(CRNode*)child
{
    
}

- (void)prepareForDeletion
{
    
}

#pragma mark private


@end
