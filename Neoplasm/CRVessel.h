//
//  CRVessel.h
//  Neoplasm
//
//  Created by Lukas on 12.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRRenderedNode.h"
#import "CRCell.h"

@class CRCell;

@interface CRVessel : CRRenderedNode

@property (nonatomic) float thickness;

@property (nonatomic) GLKVector2 startPoint;

@property (nonatomic) GLKVector2 endPoint;

@property (nonatomic, weak) CRCell * cell1;
@property (nonatomic, weak) CRCell * cell2;

//return the cell not equal to 'cell', nil if there is no other cell or 'cell' is not assigned to this vessel
- (CRCell*)otherCell:(CRCell*)cell;

@end
