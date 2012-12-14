//
//  CRFoodDistributionCenter.h
//  Cancer
//
//  Created by Lukas on 10.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//
//  The food distribution center manages all delivery of food through the network
//  A neoplasm registers to the food distribution center when it finds new food
//  It can query how much food cells have received since the last update

#import <Foundation/Foundation.h>
#import "CRFoodSource.h"

@interface CRFoodDistributionCenter : NSObject

- (void)update:(float)timeSinceLastUpdate;

- (void)addFoodSource:(CRFoodSource*)source;

- (CRFoodSourceCapacity*)foodForCellSinceLastUpdate:(CRCell*)cell;

@end
