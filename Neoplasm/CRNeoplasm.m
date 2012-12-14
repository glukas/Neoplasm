//
//  CRNeoplasm.m
//  Neoplasm
//
//  Created by Lukas on 11.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRNeoplasm.h"
#import "CRVessel.h"

#define DEFAULT_VESSEL_THICKNESS 30
#define SIZE_OF_BOX_FOR_HIT_DETECTION 35

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
    CRCell * newCell = [self addNewCellAtPoint:location];
    
    [self newVesselBetweenCell:cell andOtherCell:newCell];
    
}

- (void)newVesselBetweenCell:(CRCell *)cell1 andOtherCell:(CRCell *)cell2
{
    if (cell1 != cell2) {
        CRVessel * vessel = [[CRVessel alloc] initWithEffect:self.effect];
        //float length = GLKVector2Distance(cell.position, location);
        vessel.thickness = DEFAULT_VESSEL_THICKNESS;
        vessel.startPoint = cell1.position;
        vessel.endPoint = cell2.position;
    
        [self.children addObject:vessel];
    }
}

- (CRCell*)addNewCellAtPoint:(GLKVector2)location
{
    CRCell * cell = [CRCell cellWithEffect:self.effect];
        
    cell.position = location;
    cell.pulsate = YES;
    
    [self.children addObject:cell];
    [self.cells addObject:cell];
    
    return cell;
}

- (CRCell*)cellAtPoint:(GLKVector2)location
{
    float sizeOfPoint = SIZE_OF_BOX_FOR_HIT_DETECTION;
    CGRect locationBox = CGRectMake(location.x-sizeOfPoint, location.y-sizeOfPoint, sizeOfPoint, sizeOfPoint);
    
    __block CGRect box;
    __block CRCell * result;
    
    /*
    for (CRCell * cell in self.cells) {
        
    }*/
    
    [self.cells enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        CRCell * cell = obj;
        box = cell.boundingBox;
        
        if (CGRectIntersectsRect(box, locationBox)) {
            *stop = YES;
            result = cell;
        }
    }];
    
    return result;
}

@end
