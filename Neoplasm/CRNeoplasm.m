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
@property (nonatomic) BOOL foodDistributionCenterNeedsUpdate;
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


- (CRCell*)newNeighborToCell:(CRCell *)cell atLocation:(GLKVector2)location
{
    CRCell * newCell = [self addNewCellAtPoint:location];
    if (cell) {
        [self newVesselBetweenCell:cell andOtherCell:newCell];
    }
    return newCell;
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
    
        [self addChild:vessel];
    }
}

- (CRCell*)addNewCellAtPoint:(GLKVector2)location
{
    CRCell * cell = [CRCell cellWithEffect:self.effect];
    
    cell.delegate = self.foodDistributionCenter;
    cell.position = location;
    cell.pulsate = YES;
    
    [self addChild:cell];
    [self.cells addObject:cell];
    [self.foodDistributionCenter addCell:cell];
    self.foodDistributionCenterNeedsUpdate = YES;
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


- (void)addFoodSouce:(CRFoodSource*)food toCell:(CRCell *)cell
{
    cell.foodSource = food;
    food.consumer = cell;
    self.foodDistributionCenterNeedsUpdate = YES;
}


- (void)willRemoveChild:(CRNode *)child
{
    if ([child isKindOfClass:[CRCell class]]) {
        [self.cells removeObject:child];
        [self.foodDistributionCenter removeCell:(CRCell*)child];
    }
    self.foodDistributionCenterNeedsUpdate = YES;
}

- (void)update:(float)timeSinceLastUpdate
{
    [super update:timeSinceLastUpdate];
    
    if (self.foodDistributionCenterNeedsUpdate) {
        [self.foodDistributionCenter update];
        self.foodDistributionCenterNeedsUpdate = NO;
    }
}

@end
