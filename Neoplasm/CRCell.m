//
//  CRCell.m
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRCell.h"
#import "CRPulse.h"

@interface  CRCell()

@property (nonatomic, strong) CRPulse * pulse;

@property (nonatomic, strong) NSMutableSet * neighbors;

@property (nonatomic) float strength;//from 0 to 1

@property (nonatomic, strong) CRFood * consumption;

@end

@implementation CRCell


- (id)initWithEffect:(GLKBaseEffect *)effect
{
    self = [super initWithFile:@"cancer.png" effect:effect];
    if (self) {
        _strength = 0.2;
        _consumption = [CRFood foodWithAmount:9];
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
//stub
- (BOOL)isStarving
{
    return NO;
}




#pragma mark network structure

- (void)addNeighbor:(CRCell*)cell
{
    [self.neighbors addObject:cell];
    
    
}

- (void)removeNeighbor:(CRCell*)cell
{
    [self.neighbors removeObject:cell];
}


- (void)enumerateNeighborsUsingBlock:(void (^)(id obj, BOOL *stop))block
{
    [self.neighbors enumerateObjectsUsingBlock:block];
}

- (void)makeNeighborsPerformSelector:(SEL)selector
{
    [self.neighbors makeObjectsPerformSelector:selector];
}


#pragma mark state

- (void)update:(float)timeSinceLastUpdate
{
    [super update:timeSinceLastUpdate];
    
    if (self.pulsate) {
        [self.pulse update:timeSinceLastUpdate];
    }
    
    
    CRFood * food = [self.delegate foodForCell:self];
    
    //todo: set pulse rate to reflect rate of consumption
    
    //if there is more food than consumption, the strength grows, otherwise it shrinks
    float growth_factor = 0.0005;
    
    self.strength = self.strength+(food.amount-self.consumption.amount)*growth_factor;
    if (self.strength > 1) {
        self.strength = 1;
    } else if (self.strength <= 0) {
        //destroy
    }
    
    //pulse
    
    
    
    self.scale = self.strength/2 + self.strength*self.pulse.pulse;
}


@end
