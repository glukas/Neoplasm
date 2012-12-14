//
//  CRNeoplasm.h
//  Neoplasm
//
//  Created by Lukas on 11.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRRenderedNode.h"
#import "CRCell.h"

@interface CRNeoplasm : CRRenderedNode <CRCellDelegate>

+ (CRNeoplasm *)neoplasmWithEffect:(GLKBaseEffect*)effect initialCellAtPoint:(GLKVector2)location;



- (CRCell *)cellAtPoint:(GLKVector2)location;

- (void)newNeighborToCell:(CRCell*)cell atLoaction:(GLKVector2)location;

- (void)newVesselBetweenCell:(CRCell*)cell1 andOtherCell:(CRCell*)cell2;

@end
