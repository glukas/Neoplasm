//
//  CRCell.m
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRCell.h"
#import "CRPulse.h"

#define CR_CELL_MIN_SCALE 0.15

@interface  CRCell()

@property (nonatomic, strong) CRPulse * pulse;

@property (nonatomic, strong) NSMutableSet * vessels;

@property (nonatomic, strong) CRFood * consumption;

@end

@implementation CRCell

- (NSMutableSet*)vessels
{
    if (!_vessels) {
        _vessels = [NSMutableSet set];
    } return _vessels;
}

- (void)setFoodSource:(CRFoodSource *)foodSource
{
    if (foodSource != _foodSource) {
        _foodSource = foodSource;
        [self.delegate foodSourceForCellChanged:self];
    }
}

- (id)initWithEffect:(GLKBaseEffect *)effect
{
    self = [super initWithFile:@"cancer.png" effect:effect];
    if (self) {
        _strength = 0.1;
        _consumption = [CRFood foodWithAmount:1];
    } return self;
    
}

+ (CRCell*)cellWithEffect:(GLKBaseEffect *)effect
{
    CRCell * cell = [[self alloc] initWithEffect:effect];

    return cell;
}



- (void)setPulsate:(BOOL)pulsate
{
    _pulsate = pulsate;
    if (pulsate) {
        if (!self.pulse) {
            
            //todo: this value should be calculated
            self.pulse = [CRPulse pulseWithBPM:30];
        }
    }
}


#pragma mark food

- (BOOL)isStarving
{
    return [self.delegate foodForCell:self].amount < self.consumption.amount;
}




#pragma mark network structure

- (void)addVessel:(CRVessel *)vessel
{
    if (vessel.cell1 == self || vessel.cell2 == self) {
        [self.vessels addObject:vessel];
    }
    NSLog(@"%@", self.vessels);
}

- (void)removeVessel:(CRVessel *)vessel
{
    [self.vessels removeObject:vessel];
}

- (void)removeAllVessels
{
    [self.vessels removeAllObjects];
}

- (void)enumerateVesselsUsingBlock:(void (^)(id obj, BOOL *stop))block
{
    [self.vessels enumerateObjectsUsingBlock:block];
}

- (void)enumerateNeighborsUsingBlock:(void (^)(id obj, BOOL *stop))block
{
    
    [self.vessels enumerateObjectsUsingBlock:^(id obj, BOOL *stop2) {
        
        block([(CRVessel*)obj otherCell:self], stop2);
        
    }];
}



#pragma mark CRNode

- (void)update:(float)timeSinceLastUpdate
{
    [super update:timeSinceLastUpdate];
    
    if (self.pulsate) {
        [self.pulse update:timeSinceLastUpdate];
    }
    
    
    CRFood * food = [self.delegate foodForCell:self];
    
    //todo: set pulse rate to reflect rate of consumption
    
    //if there is more food than consumption, the strength grows, otherwise it shrinks
    float growth_factor;
    if (food.amount > self.consumption.amount) {
        growth_factor = 0.01;
    } else {
        growth_factor = 0.05;
    }
        
    self.strength = self.strength+timeSinceLastUpdate*(food.amount-self.consumption.amount)*growth_factor;
    if (self.strength > 1) {
        self.strength = 1;
    }
    if (self.strength <= 0) {
        [self enumerateParentsUsingBlock:^(CRNode *obj, BOOL *stop) {
            [obj removeChild:self];
        }];
    } else {
        self.scale = CR_CELL_MIN_SCALE+(1-CR_CELL_MIN_SCALE)*(self.strength + self.strength*self.pulse.pulse)/2;
    }
    
}




- (void)prepareForDeletion
{
    [self enumerateVesselsUsingBlock:^(id obj, BOOL *stop) {
        CRVessel * vessel = (CRVessel*)obj;
        //remove vessel from cells connected to the cell
        [[vessel otherCell:self] removeVessel:vessel];
        
        [vessel enumerateParentsUsingBlock:^(CRNode *obj, BOOL *stop) {
            [obj removeChild:vessel];
        }];
    }];
    //remove all vessels from the cell
    [self removeAllVessels];
}


@end
