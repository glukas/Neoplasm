//
//  CRNeoplasm.h
//  Neoplasm
//
//  Created by Lukas on 11.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRNode.h"
#import "CRCell.h"

@interface CRNeoplasm : CRNode

+ (CRNeoplasm *)neoplasmWithEffect:(GLKBaseEffect*)effect initialCellAtPoint:(GLKVector2)location;



- (CRCell *)cellAtPoint:(GLKVector2)location;

- (void)newNeighborToCell:(CRCell*)cell atLoaction:(GLKVector2)location;

@end
