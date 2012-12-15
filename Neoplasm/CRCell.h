//
//  CRCell.h
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRSprite.h"
#import "CRFood.h"

@class CRCell;

@protocol CRCellDelegate <NSObject>
- (CRFood*)foodForCell:(CRCell*)cell;
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

- (void)addNeighbor:(CRCell*)cell;

- (void)removeNeighbor:(CRCell*)cell;

//set stop to YES if you dont want to stop traversal early
- (void)enumerateNeighborsUsingBlock:(void (^)(id obj, BOOL *stop))block;

- (void)makeNeighborsPerformSelector:(SEL)selector;

@end
