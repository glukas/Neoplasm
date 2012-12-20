//
//  CRCell.h
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRSprite.h"
#import "CRFoodSource.h"
#import "CRVessel.h"
#import "CRFood.h"

@class CRCell;
@class CRFoodSource;
@class CRVessel;

@protocol CRCellDelegate <NSObject>
- (CRFood*)foodForCell:(CRCell*)cell;
- (void)foodSourceForCellChanged:(CRCell*)cell;
@end


@interface CRCell : CRSprite

- (id)initWithEffect:(GLKBaseEffect*)effect;

+ (CRCell*)cellWithEffect:(GLKBaseEffect*)effect;

//@property (assign) float strength; //value from 1 to 100; //default is 10

//default is NO
//pulsate?
@property (nonatomic) BOOL pulsate;

@property (readonly) BOOL isStarving;

#pragma mark delegate

@property (nonatomic, weak) id <CRCellDelegate> delegate;

#pragma mark food

//The Food source directly associated with this cell
@property (nonatomic, weak) CRFoodSource * foodSource;

@property (nonatomic)float strength; //value from 0 to 1, if 0, the cell dies

#pragma mark connections to other cells

- (void)addVessel:(CRVessel*) vessel;

- (void)removeVessel:(CRVessel*) vessel;

- (void)removeAllVessels;

//set stop to YES if you want to stop traversal early
- (void)enumerateNeighborsUsingBlock:(void (^)(id obj, BOOL *stop))block;

- (void)enumerateVesselsUsingBlock:(void (^)(id obj, BOOL *stop))block;

@end
