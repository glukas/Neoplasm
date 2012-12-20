//
//  CRFoodFlow.h
//  Cancer
//
//  Created by Lukas on 10.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//
//  For a given food source, can determine which cells receive which share of the food source


#import <Foundation/Foundation.h>
#import "CRFoodSource.h"
#import "CRCell.h"

@interface CRFoodFlow : NSObject


+ (CRFoodFlow*)foodFlow;


@property (nonatomic, strong) CRFoodSource * foodSource;


- (float)shareOfTotalFoodForCell:(CRCell*)cell;

@end