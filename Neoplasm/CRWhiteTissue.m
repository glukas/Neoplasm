//
//  CRWhiteTissue.m
//  Neoplasm
//
//  Created by Lukas on 14.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRWhiteTissue.h"
#import "CRSpawner.h"

#define SIZE_OF_BOX_FOR_HIT_DETECTION 60

@interface  CRWhiteTissue()

@property (nonatomic, strong) NSMutableSet * cells;

@end



@implementation CRWhiteTissue
@synthesize foodSpawner = _foodSpawner;

- (NSMutableSet*)cells
{
    if (!_cells) {
        _cells = [NSMutableSet set];
    } return _cells;
}

- (id)initWithEffect:(GLKBaseEffect *)effect
{
    self = [super initWithEffect:effect];
    if (self) {
        
    } return self;
}


- (void)update:(float)timeSinceLastUpdate
{
    [super update:timeSinceLastUpdate];
}

- (CRSpawner*)foodSpawner
{
    if (!_foodSpawner) {
        _foodSpawner = [[CRSpawner alloc] init];
        _foodSpawner.delegate = self;
    } return _foodSpawner;
}

- (void)setFoodSpawner:(CRSpawner *)foodSpawner
{
    foodSpawner.delegate = self;
    _foodSpawner = foodSpawner;
}

- (CRFoodSource*)foodSourceAtPoint:(GLKVector2)location
{
    float sizeOfPoint = SIZE_OF_BOX_FOR_HIT_DETECTION;
    CGRect locationBox = CGRectMake(location.x-sizeOfPoint/2, location.y-sizeOfPoint/2, sizeOfPoint, sizeOfPoint);
    
    __block CGRect box;
    __block CRFoodSource * result;
    
    //test for collision
    [self.children enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        CRFoodSource * source = obj;
        box = source.boundingBox;
        
        if (CGRectIntersectsRect(box, locationBox)) {
            *stop = YES;
            result = source;
        }
    }];
    
    return result;
}

- (CRFoodSource*)addNewCellAtPoint:(GLKVector2)location
{
    CRFoodSource * cell = [[CRFoodSource alloc] initWithEffect:self.effect capacity:[[CRFoodSourceCapacity alloc] initWithAmount:40+drand48()*64]];
    
    //cell.delegate = self;
    cell.position = location;
    //cell.pulsate = YES;
    
    [self.children addObject:cell];
    [self.cells addObject:cell];
    
    return cell;
}


- (void)CRSpawner:(CRSpawner *)spawer spawnedObjectAtLocation:(GLKVector2)location
{
    [self addNewCellAtPoint:location];
}

@end
