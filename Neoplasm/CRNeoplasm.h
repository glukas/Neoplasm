//
//  CRNeoplasm.h
//  Neoplasm
//
//  Created by Lukas on 11.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRRenderedNode.h"
#import "CRCell.h"
#import "CRFoodSource.h"

@interface CRNeoplasm : CRRenderedNode <CRCellDelegate>

+ (CRNeoplasm *)neoplasmWithEffect:(GLKBaseEffect*)effect initialCellAtPoint:(GLKVector2)location;



- (CRCell *)cellAtPoint:(GLKVector2)location;

- (CRCell *)newNeighborToCell:(CRCell*)cell atLocation:(GLKVector2)location;

- (void)newVesselBetweenCell:(CRCell*)cell1 andOtherCell:(CRCell*)cell2;

- (void)addFoodSouce:(CRFoodSource*)food toCell:(CRCell*)cell;

@end
