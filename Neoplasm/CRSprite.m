//
//  CRSprite.m
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRSprite.h"
#import "CRGeometry.h"

@interface CRSprite()

//the effect provides simple rendering similar to opengl es 1
@property (nonatomic, strong) GLKBaseEffect * effect;
@property (assign) TexturedQuad quad;
@property (nonatomic, strong) GLKTextureInfo * textureInfo;

@end

@implementation CRSprite

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect {
    if ((self = [super init])) {
        
        self.effect = effect;
        
        //load the texture from bottom left, so that it matches opengls coordinate system
        NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:YES],
                                  GLKTextureLoaderOriginBottomLeft,
                                  nil];
        
        NSError * error;
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        //the texture loader can handle a lot of different data types
        self.textureInfo = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
        if (self.textureInfo == nil) {
            NSLog(@"Error loading file: %@", [error localizedDescription]);
            return nil;
        }
        
        self.contentSize = CGSizeMake(self.textureInfo.width, self.textureInfo.height);
        
        TexturedQuad newQuad;
        newQuad.bl.spaceCoordinate = CGPointMake(0, 0);
        newQuad.br.spaceCoordinate = CGPointMake(self.textureInfo.width, 0);
        newQuad.tl.spaceCoordinate = CGPointMake(0, self.textureInfo.height);
        newQuad.tr.spaceCoordinate = CGPointMake(self.textureInfo.width, self.textureInfo.height);
        
        newQuad.bl.textureCoordinate = CGPointMake(0, 0);
        newQuad.br.textureCoordinate = CGPointMake(1, 0);
        newQuad.tl.textureCoordinate = CGPointMake(0, 1);
        newQuad.tr.textureCoordinate = CGPointMake(1, 1);
        self.quad = newQuad;
        
    }
    return self;
}

- (void)renderWithModelViewMatrix:(GLKMatrix4)modelViewMatrix
{
    //always call super!
    [super renderWithModelViewMatrix:modelViewMatrix];
    
    //configure effect
    self.effect.texture2d0.enabled = YES;
    self.effect.texture2d0.name = self.textureInfo.name;
    
    self.effect.transform.modelviewMatrix = GLKMatrix4Multiply(modelViewMatrix, [self modelMatrix:YES]);
    
    [self.effect prepareToDraw];
    
    //pass geometry to gl (warning: plain old c!)
    
    //location in memory
    long offset = (long)&_quad;
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glDisableVertexAttribArray(GLKVertexAttribColor);
    
    //basically pass the quad property to gl
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, spaceCoordinate)));
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void *) (offset + offsetof(TexturedVertex, textureCoordinate)));
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
}

@end
