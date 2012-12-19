//
//  CRFoodDistributionCenter.m
//  Cancer
//
//  Created by Lukas on 10.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRFoodDistributionCenter.h"

@interface CRFoodDistributionCenter()

@property (nonatomic, strong) NSMutableSet * foodSources;
@property (nonatomic, strong) NSMutableDictionary * distribution;
@property (nonatomic, strong) NSMutableSet * cells;
@property (nonatomic, strong) CRFood * totalFood;
@end

@implementation CRFoodDistributionCenter

- (NSMutableSet *)cells
{
    if (!_cells) {
        _cells = [NSMutableSet set];
    } return _cells;
}


- (CRFood *)totalFood
{
    
    if (!_totalFood) {
        _totalFood = [CRFood foodWithAmount:0];
    }
    return _totalFood;
}

- (void)addCell:(CRCell *)cell
{
    //[self.foodSources addObject:source];
    /*if (cell.foodSource) {
        self.totalFood.amount = self.totalFood.amount + [cell.foodSource foodProduced].amount;
    }*/
    [self.cells addObject:cell];
    CRFood * result;
    if (self.cells.count) {
        result = [CRFood foodWithAmount:self.totalFood.amount/self.cells.count];
    }
    NSLog(@"%f", result.amount);
    //[self.distribution setObject:source forKey:source.consumer];
}

- (void)removeCell:(CRCell *)cell
{
    [self.cells removeObject:cell];
    if (cell.foodSource) {
        //self.totalFood.amount = self.totalFood.amount - [cell.foodSource foodProduced].amount;
    }
    //[self.foodSources removeObject:source];
}

- (CRFood *)foodForCell:(CRCell *)cell
{
    //[[self.distribution objectForKey:cell] foodProduced];
    CRFood * result;
    if (self.cells.count) {
        result = [CRFood foodWithAmount:self.totalFood.amount/self.cells.count];
    }
    //NSLog(@"%f", result.amount);
    return result;
}

- (void)foodSourceForCellChanged:(CRCell *)cell
{
    [self update];
}

- (void)update
{
    float totalFood = 0;
    for (CRCell *cell in self.cells) {
        if (cell.foodSource) {
            totalFood += [cell.foodSource foodProduced].amount;
        }
    }
    self.totalFood = [CRFood foodWithAmount:totalFood];
}


@end
