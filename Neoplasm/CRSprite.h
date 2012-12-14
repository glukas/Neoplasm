//
//  CRSprite.h
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRNode.h"

@interface CRSprite : CRNode

- (id)initWithFile:(NSString *)fileName effect:(GLKBaseEffect *)effect;

@end
