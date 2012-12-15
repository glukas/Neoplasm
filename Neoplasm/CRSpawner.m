//
//  CRSpawner.m
//  Neoplasm
//
//  Created by Lukas on 14.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRSpawner.h"
#import <Security/Security.h>

@implementation CRSpawner


- (id)init
{
    self = [super init];
    if (self) {
        //get a seed from the 'true' random generator
        uint8_t rseed;
        size_t size = sizeof(rseed);
        SecRandomCopyBytes(kSecRandomDefault, size, &rseed);
        srand48(rseed);
    } return self;
}

- (void)spawnLocation
{
    float x = self.bounds.y+drand48()*(abs(self.bounds.x)+abs(self.bounds.y));
    float y = self.bounds.w+drand48()*(abs(self.bounds.z)+abs(self.bounds.w));
    [self.delegate CRSpawner:self spawnedObjectAtLocation:GLKVector2Make(x, y)];
    
}

- (void)spawnLocations:(int)count
{
    for (int i = 0; i < count; i=i+1) {
        [self spawnLocation];
    }
}

@end
