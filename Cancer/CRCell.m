//
//  CRCell.m
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRCell.h"

@implementation CRCell

+ (CRCell*)cellWithEffect:(GLKBaseEffect *)effect
{
    CRCell * cell = [[super alloc] initWithFile:@"cancer.png" effect:effect];
    
    cell.strength = 10;
    
    return cell;
}



@end
