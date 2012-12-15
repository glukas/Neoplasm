//
//  CRFoodSource.m
//  Cancer
//
//  Created by Lukas on 10.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRFoodSource.h"
#import "CRPulse.h"

@interface CRFoodSource()
@property (nonatomic, strong) CRFoodSourceCapacity * capacity;
@property (nonatomic, strong) CRPulse * pulse;
@end

@implementation CRFoodSource



- (id)initWithEffect:(GLKBaseEffect *)effect capacity:(CRFoodSourceCapacity *)capacity
{
    self = [super initWithFile:@"white_cell_100.png" effect:effect];
    if (self) {
        
        _capacity = capacity;
        _pulse = [CRPulse pulseWithBPM:20];
    } return self;
}


- (CRFood*)foodProduced
{
    CRFood * produced;
    if (self.consumer) {
        
    }
    return produced;
}


- (void)update:(float)timeSinceLastUpdate
{
    [super update:timeSinceLastUpdate];
    [self.pulse update:timeSinceLastUpdate];
    self.scale = self.capacity.amount * 0.0025 * (1 + self.pulse.pulse);
}

@end
