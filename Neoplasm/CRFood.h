//
//  CRFood.h
//  Neoplasm
//
//  Created by Lukas on 14.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRFood : NSObject

+ (CRFood*)foodWithAmount:(float)amount;

@property (nonatomic) float amount;

@end
