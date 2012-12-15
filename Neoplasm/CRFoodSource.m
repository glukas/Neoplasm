//
//  CRFoodSource.m
//  Cancer
//
//  Created by Lukas on 10.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRFoodSource.h"

@implementation CRFoodSource

- (id)initWithEffect:(GLKBaseEffect *)effect capacity:(CRFoodSourceCapacity *)capacity
{
    self = [super initWithFile:@"white_cell_100.png" effect:effect];
    if (self) {
        
        
        
    } return self;
}


- (CRFood*)foodProduced
{
    CRFood * produced;
    if (self.consumer) {
        
    }
    return produced;
}


@end
