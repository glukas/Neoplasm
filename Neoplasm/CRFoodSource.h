//
//  CRFoodSource.h
//  Cancer
//
//  Created by Lukas on 10.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRSprite.h"
#import "CRFoodSourceCapacity.h"
#import "CRCell.h"

@class CRCell;
@class CRFoodSource;


@interface CRFoodSource : CRSprite

- (id)initWithEffect:(GLKBaseEffect*)effect capacity:(CRFoodSourceCapacity*)capacity;

//the food produced per second
- (CRFood*)foodProduced;

-//Which cell is consuming the food source?
-//nil if none
@property (nonatomic, weak) CRCell * consumer;

@end
