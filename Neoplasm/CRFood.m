//
//  CRFood.m
//  Neoplasm
//
//  Created by Lukas on 14.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRFood.h"

@implementation CRFood

+ (CRFood*)foodWithAmount:(float)amount
{
    CRFood * food = [[CRFood alloc] init];
    food.amount = amount;
    return food;
}

@end
