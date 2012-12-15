//
//  CRFood.m
//  Neoplasm
//
//  Created by Lukas on 14.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRFood.h"

@implementation CRFood


- (id)initWithAmount:(float)amount
{
    self = [super init];
    if (self) {
        self.amount = amount;
    } return self;
}

+ (CRFood*)foodWithAmount:(float)amount
{
    CRFood * food = [[CRFood alloc] initWithAmount:amount];
    return food;
}

@end
