//
//  CRFoodSource.h
//  Cancer
//
//  Created by Lukas on 10.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRSprite.h"
#import "CRCell.h"
#import "CRFoodSourceCapacity.h"

@interface CRFoodSource : CRSprite

+ (CRFoodSource *)foodSourceWithCapacity:(CRFoodSourceCapacity *)capacity;

- (void)foodSinceLastUpdate:(float)timeSinceLastUpdate forCell:(CRCell*)cell;

//Which cell is consuming the food source?
//nil if none
@property (nonatomic) CRCell * parasite;

@end