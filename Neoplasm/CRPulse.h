//
//  CRPulse.h
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//
//  Changes value from 0 to 1 with a defined rate of change
//  Update the pulse regularly using update: (for example in a draw loop)

#import <Foundation/Foundation.h>

@interface CRPulse : NSObject

//create a new pulse that pulses with a certain amount of beats per minute
+ (CRPulse *)pulseWithBPM:(NSUInteger)bpm;

@property (readonly) float pulse; //value from 0.0 to 1.0

- (void)update:(float)timeSinceLastUpdate;

@end
