//
//  CRRenderedNode.m
//  Neoplasm
//
//  Created by Lukas on 14.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRRenderedNode.h"

@implementation CRRenderedNode

- (id)initWithEffect:(GLKBaseEffect *)effect {
    if ((self = [super init])) {
        
        self.effect = effect;
    } return self;
}

@end
