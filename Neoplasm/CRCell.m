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

@end

@implementation CRCell


+ (CRCell*)cellWithEffect:(GLKBaseEffect *)effect
{
    CRCell * cell = [[super alloc] initWithFile:@"cancer.png" effect:effect];
    
    //cell.strength = 10;
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
    
    //todo: determine surplus/shortage if food (ask parent)
    //...
    
    //todo: set the scale to refrect new size
    //todo: set pulse rate to reflect rate of consumption
    
    //pulse
    self.scale = 0.5+0.5*self.pulse.pulse;
}


@end
