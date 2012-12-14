//
//  CRNeoplasm.m
//  Neoplasm
//
//  Created by Lukas on 11.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRNeoplasm.h"
#import "CRVessel.h"

@interface  CRNeoplasm()
@property (nonatomic, strong) GLKBaseEffect * effect;
@property (nonatomic, strong) NSMutableSet * cells;
@end

@implementation CRNeoplasm

- (NSMutableSet*)cells
{
    if (!_cells) {
        _cells = [NSMutableSet set];
    } return _cells;
}

+ (CRNeoplasm*)neoplasmWithEffect:(GLKBaseEffect *)effect initialCellAtPoint:(GLKVector2)location
{
    CRNeoplasm * plasm = [[CRNeoplasm alloc] init];
    plasm.effect = effect;
    [plasm addNewCellAtPoint:location];
    
    return plasm;
}


- (void)newNeighborToCell:(CRCell *)cell atLoaction:(GLKVector2)location
{
    [self addNewCellAtPoint:location];
    CRVessel * vessel = [[CRVessel alloc] initWithEffect:self.effect];
    
    vessel.thickness = 30;
    vessel.startPoint = cell.position;
    vessel.endPoint = location;
    
    [self.children addObject:vessel];
    
}


- (void)addNewCellAtPoint:(GLKVector2)location
{
    CRCell * cell = [CRCell cellWithEffect:self.effect];
        
    cell.position = location;
    cell.pulsate = YES;
    
    [self.children addObject:cell];
    [self.cells addObject:cell];
    
    
}

- (CRCell*)cellAtPoint:(GLKVector2)location
{
    float sizeOfPoint = 20;
    CGRect locationBox = CGRectMake(location.x-sizeOfPoint, location.y-sizeOfPoint, sizeOfPoint, sizeOfPoint);
    
    __block CGRect box;
    __block CRCell * result;
    
    
    for (CRCell * cell in self.cells) {
        box = cell.boundingBox;
        
        if (CGRectIntersectsRect(box, locationBox)) {
            //*stop = YES;
            result = cell;
        }
    }
    
    [self.cells enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {

    }];
    
    return result;
}

@end
