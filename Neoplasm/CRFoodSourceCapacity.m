//
//  CRFoodSourceCapacity.m
//  Cancer
//
//  Created by Lukas on 10.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRFoodSourceCapacity.h"

@implementation CRFoodSourceCapacity

- (id)initWithAmount:(float)amount
{
    self = [super initWithAmount:amount];
    if (self) {
        _initialCapacity = [CRFood foodWithAmount:amount];
    } return self;
}

@end

