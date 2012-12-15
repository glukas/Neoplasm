//
//  CRFoodDistributionCenter.m
//  Cancer
//
//  Created by Lukas on 10.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRFoodDistributionCenter.h"

@interface CRFoodDistributionCenter()
@property (nonatomic) float time;
@end

@implementation CRFoodDistributionCenter



- (void)update:(float)timeSinceLastUpdate
{
    self.time += timeSinceLastUpdate;
}

- (void)addFoodSource:(CRFoodSource *)source
{
    
}

- (CRFood *)foodForCell:(CRCell *)cell
{
    return [CRFood foodWithAmount:10];
}


@end
