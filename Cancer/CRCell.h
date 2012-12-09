//
//  CRCell.h
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRSprite.h"

@interface CRCell : CRSprite

+ (CRCell*)cellWithEffect:(GLKBaseEffect*)effect;

@property (assign) float strength; //value from 1 to 100; //default is 10

//default is NO
//pulsate?
@property (nonatomic) BOOL pulsate;

@end
