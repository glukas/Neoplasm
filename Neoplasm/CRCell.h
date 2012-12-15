//
//  CRCell.h
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRSprite.h"
#import "CRFood.h"
#import "CRVessel.h"

@class CRCell;
@class CRVessel;

@protocol CRCellDelegate <NSObject>
- (CRFood*)foodForCell:(CRCell*)cell;

//prompts the delegate to delete this cell
- (void)deleteCell:(CRCell*)cell;

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

#pragma mark connections to other cells

- (void)addVessel:(CRVessel*) vessel;

- (void)removeVessel:(CRVessel*) vessel;

- (void)removeAllVessels;

//set stop to YES if you dont want to stop traversal early
- (void)enumerateNeighborsUsingBlock:(void (^)(id obj, BOOL *stop))block;

- (void)enumerateVesselsUsingBlock:(void (^)(id obj, BOOL *stop))block;
@end
