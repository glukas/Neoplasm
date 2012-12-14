//
//  CRRenderedNode.h
//  Neoplasm
//
//  Created by Lukas on 14.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRNode.h"

@interface CRRenderedNode : CRNode

- (id)initWithEffect:(GLKBaseEffect*)effect;

@property (strong) GLKBaseEffect * effect;

@end
