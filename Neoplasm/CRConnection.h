//
//  CRConnection.h
//  Neoplasm
//
//  Created by Lukas on 12.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRNode.h"

@interface CRConnection : CRNode

@property (assign) float thickness;

@property (assign) GLKVector2 startPoint;

@property (assign) GLKVector2 endPoint;

@end
