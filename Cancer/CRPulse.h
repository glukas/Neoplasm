//
//  CRPulse.h
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//
//  Changes value from 0 to 1 with a defined rate of change

#import <Foundation/Foundation.h>

@interface CRPulse : NSObject

//create a new pulse that pulses with a certain amount of beats per minute
+ (CRPulse *)pulseWithBPM:(NSUInteger)pulse;

@property (readonly) float pulse;

- (void)update:(float)timeSinceLastUpdate;

@end
