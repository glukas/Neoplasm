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
#import "CRFood.h"
#import "CRCell.h"

@interface CRFoodDistributionCenter : NSObject

- (void)addCell:(CRCell*)cell;

- (void)removeCell:(CRCell*)cell;

//food per second for this cell
- (CRFood*)foodForCell:(CRCell*)cell;

@end
