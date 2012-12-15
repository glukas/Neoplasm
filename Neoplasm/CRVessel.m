//
//  CRVessel.m
//  Neoplasm
//
//  Created by Lukas on 12.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRVessel.h"
#import "CRGeometry.h"

@interface  CRVessel()

@property (assign) ColoredQuad vertices;

@end


@implementation CRVessel

@synthesize vertices = _vertices;


/*
- (void)dealloc
{
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
}*/

- (void)setThickness:(float)thickness
{
    _thickness = thickness;
    [self recalculateVertices];
}

- (void)setStartPoint:(GLKVector2)startPoint
{
    _startPoint = startPoint;
    [self recalculateVertices];
}

- (void)setEndPoint:(GLKVector2)endPoint
{
    _endPoint = endPoint;
    [self recalculateVertices];
}



- (void)recalculateVertices
{
    
    //we get the direction between the start and endpoint
    GLKVector2 difference_vec = GLKVector2Subtract(self.endPoint, self.startPoint);
    //this is the vector that's orthogonal to the direction of the vessel
    GLKVector2 normal_vec = GLKVector2Normalize(GLKVector2Make(-difference_vec.y, difference_vec.x));
    
    //Now we add the normal_vec to the start and end points to get the desired coordinates
    GLKVector2 p1 = GLKVector2Add(self.startPoint, GLKVector2MultiplyScalar(normal_vec, 0.5*self.thickness));
    GLKVector2 p2 = GLKVector2Add(self.startPoint, GLKVector2MultiplyScalar(normal_vec, -0.5*self.thickness));
    GLKVector2 p3 = GLKVector2Add(self.endPoint, GLKVector2MultiplyScalar(normal_vec, 0.5*self.thickness));
    GLKVector2 p4 = GLKVector2Add(self.endPoint, GLKVector2MultiplyScalar(normal_vec, -0.5*self.thickness));
    
    
    ColoredQuad newVertices;
    
    newVertices.bl.spaceCoordinate = CGPointMake(p1.x, p1.y);
    newVertices.br.spaceCoordinate = CGPointMake(p2.x, p2.y);
    newVertices.tl.spaceCoordinate = CGPointMake(p3.x, p3.y);
    newVertices.tr.spaceCoordinate = CGPointMake(p4.x, p4.y);
    
    self.vertices = newVertices;
    
}



- (void)renderWithModelViewMatrix:(GLKMatrix4)modelViewMatrix
{
    [super renderWithModelViewMatrix:modelViewMatrix];
    
    self.effect.texture2d0.enabled = NO;
    self.effect.transform.modelviewMatrix = GLKMatrix4Multiply(modelViewMatrix, [self modelMatrix:YES]);
    [self.effect prepareToDraw];
    
    
    //location in memory
    long offset = (long)&_vertices;
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    
    //basically pass the property to gl
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(ColoredVertex), (void *) (offset + offsetof(ColoredVertex, spaceCoordinate)));
    glVertexAttribPointer(GLKVertexAttribColor, 2, GL_FLOAT, GL_FALSE, sizeof(ColoredVertex), (void *) (offset + offsetof(ColoredVertex, Color)));
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
}

@end
