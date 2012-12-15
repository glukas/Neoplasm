//
//  CRNeoplasm.m
//  Neoplasm
//
//  Created by Lukas on 11.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRNeoplasm.h"
#import "CRVessel.h"
#import "CRFoodDistributionCenter.h"

#define DEFAULT_VESSEL_THICKNESS 8
#define SIZE_OF_BOX_FOR_HIT_DETECTION 40

@interface  CRNeoplasm()
@property (nonatomic, strong) NSMutableSet * cells;
@property (nonatomic, strong) CRFoodDistributionCenter * foodDistributionCenter;
@end

@implementation CRNeoplasm

- (CRFoodDistributionCenter *)foodDistributionCenter
{
    if (!_foodDistributionCenter) {
        _foodDistributionCenter = [[CRFoodDistributionCenter alloc] init];
    } return _foodDistributionCenter;
}

- (NSMutableSet*)cells
{
    if (!_cells) {
        _cells = [NSMutableSet set];
    } return _cells;
}

+ (CRNeoplasm*)neoplasmWithEffect:(GLKBaseEffect *)effect initialCellAtPoint:(GLKVector2)location
{
    CRNeoplasm * plasm = [[CRNeoplasm alloc] initWithEffect:effect];
    [plasm addNewCellAtPoint:location];
    
    return plasm;
}


- (void)newNeighborToCell:(CRCell *)cell atLocation:(GLKVector2)location
{
    CRCell * newCell = [self addNewCellAtPoint:location];
    if (cell) {
        [self newVesselBetweenCell:cell andOtherCell:newCell];
    }
}

- (void)newVesselBetweenCell:(CRCell *)cell1 andOtherCell:(CRCell *)cell2
{
    if (cell1 != cell2) {
        CRVessel * vessel = [[CRVessel alloc] initWithEffect:self.effect];
        //float length = GLKVector2Distance(cell.position, location);
        vessel.thickness = DEFAULT_VESSEL_THICKNESS;
        vessel.cell1 = cell1;
        vessel.cell2 = cell2;
        [cell1 addVessel:vessel];
        [cell2 addVessel:vessel];
        vessel.startPoint = cell1.position;
        vessel.endPoint = cell2.position;
    
        [self.children addObject:vessel];
    }
}

- (CRCell*)addNewCellAtPoint:(GLKVector2)location
{
    CRCell * cell = [CRCell cellWithEffect:self.effect];
    
    cell.delegate = self;
    cell.position = location;
    cell.pulsate = YES;
    
    [self.children addObject:cell];
    [self.cells addObject:cell];
    
    return cell;
}

- (CRCell*)cellAtPoint:(GLKVector2)location
{
    float sizeOfPoint = SIZE_OF_BOX_FOR_HIT_DETECTION;
    CGRect locationBox = CGRectMake(location.x-sizeOfPoint/2, location.y-sizeOfPoint/2, sizeOfPoint, sizeOfPoint);
    
    __block CGRect box;
    __block CRCell * result;
    
    //test for collision
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


- (CRFood*)foodForCell:(CRCell *)cell
{
    return [self.foodDistributionCenter foodForCell:cell];
}

- (void)deleteCell:(CRCell *)cell
{
    [cell enumerateVesselsUsingBlock:^(id obj, BOOL *stop) {
        CRVessel * vessel = (CRVessel*)obj;
        //remove vessel from cells connected to the cell
        [[vessel otherCell:cell] removeVessel:vessel];
        
        [self removeChild:vessel];
    }];
    //remove all vessels from the cell
    [cell removeAllVessels];
    //remove cell
    [self removeChild:cell];
    [self.cells removeObject:cell];
    
    //later: update foodDistributionCenter
   
}

- (void)update:(float)timeSinceLastUpdate
{
    [self.foodDistributionCenter update:timeSinceLastUpdate];
    [super update:timeSinceLastUpdate];
}

@end
