//
//  CRVessel.h
//  Neoplasm
//
//  Created by Lukas on 12.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRRenderedNode.h"

@interface CRVessel : CRRenderedNode

@property (nonatomic) float thickness;

@property (nonatomic) GLKVector2 startPoint;

@property (nonatomic) GLKVector2 endPoint;

@end
