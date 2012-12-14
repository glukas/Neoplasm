//
//  CRPulse.m
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRPulse.h"

@interface  CRPulse()

@property float pulseDeltaPerSecond;

@property (nonatomic) float pulseState;
@property (nonatomic) BOOL isIncreasing;
@end

@implementation CRPulse


+ (CRPulse*)pulseWithBPM:(NSUInteger)bpm
{
    CRPulse * p = [[super alloc] init];
    p.pulseDeltaPerSecond = (2.0*bpm)/60.0;
    //NSLog(@"%f %d", p.pulseDeltaPerSecond, bpm);
    return p;
}

- (float)pulse
{
    return _pulseState;
}

- (void)update:(float)timeSinceLastUpdate
{
    if (self.isIncreasing) {
        self.pulseState = self.pulseState + timeSinceLastUpdate*self.pulseDeltaPerSecond;
    } else {
        self.pulseState = self.pulseState - timeSinceLastUpdate*self.pulseDeltaPerSecond;
    }
    if (self.pulseState <= 0) {
        self.pulseState = 0;
        self.isIncreasing = YES;
    } else if (self.pulseState >= 1) {
        self.pulseState = 1;
        self.isIncreasing = NO;
    }
}

@end
