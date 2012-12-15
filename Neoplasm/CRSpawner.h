//
//  CRSpawner.h
//  Neoplasm
//
//  Created by Lukas on 14.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class CRSpawner;

@protocol CRSpawnerDelegate <NSObject>

- (void)CRSpawner:(CRSpawner*)spawer spawnedObjectAtLocation:(GLKVector2)location;

@end

@interface CRSpawner : NSObject

//spawn an object at a location inside the bounds
- (void)spawnLocation;

- (void)spawnLocations:(int)count;

//components 1, 2, 3, 4 mean: max(x), min(x), max(y), min(y)
@property (nonatomic) GLKVector4 bounds;

//the delegate gets notified whenever an object is spawned
@property (nonatomic, weak) id <CRSpawnerDelegate> delegate;

@end
