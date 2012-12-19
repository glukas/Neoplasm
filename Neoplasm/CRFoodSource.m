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
@property (nonatomic) float depletionRate;
@end

@implementation CRFoodSource



- (id)initWithEffect:(GLKBaseEffect *)effect capacity:(CRFoodSourceCapacity *)capacity
{
    self = [super initWithFile:@"white_cell_100.png" effect:effect];
    if (self) {
        
        _capacity = capacity;
        _pulse = [CRPulse pulseWithBPM:20];
        _depletionRate = 4;
    } return self;
}


- (CRFood*)foodProduced
{
    CRFood * produced;
    if (self.capacity.amount > self.depletionRate) {
        produced = [CRFood foodWithAmount:self.depletionRate];
    } else {
        produced = [CRFood foodWithAmount:self.capacity.amount];
    }
    return produced;
}

- (void)deplete:(float)time
{
    if (self.capacity.amount > (time*self.depletionRate)) {
        self.capacity.amount = self.capacity.amount-time*self.depletionRate;
    } else if (self.capacity.amount > 0) {
        self.capacity.amount = 0;
        [self enumerateParentsUsingBlock:^(CRNode *obj, BOOL *stop) {
            [obj removeChild:self];
        }];
        NSLog(@"%@ depleted", self);
    }
}


- (void)update:(float)timeSinceLastUpdate
{
    [super update:timeSinceLastUpdate];
    [self.pulse update:timeSinceLastUpdate];
    if (self.consumer) {
        [self deplete:timeSinceLastUpdate];
    }
    self.scale = 0.001+self.capacity.amount * 0.0015 * (0.93+self.pulse.pulse);
}

@end
