//
//  CRGameScene.m
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRGameScene.h"

@interface  CRGameScene()
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@end

@implementation CRGameScene

- (UITapGestureRecognizer*)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWithGesture:)];
    } return _tapGesture;
}

- (void)tapWithGesture:(UITapGestureRecognizer*)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        
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
        [self newCellAtPoint:[tap locationInView:self.view]];
        /*}*/
        
        
        
    }
}

//create new objects

- (void)newCellAtPoint:(CGPoint)point
{
    GHCell * cell = [GHCell cellWithEffect:self.effect];
    
    cell.scale = 0.5;
    
    cell.position = [self toGLVectorFromMainView:point];
    
    cell.pulsate = YES;
    [self.children addObject:cell];
    [self.cells addObject:cell];
    
}

- (GLKVector2)toGLVectorFromMainView:(CGPoint)point
{
    return GLKVector2Make(point.x*0.97, self.view.frame.size.width-point.y);
}


@end
