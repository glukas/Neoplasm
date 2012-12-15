//
//  CRWhiteTissue.h
//  Neoplasm
//
//  Created by Lukas on 14.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRRenderedNode.h"
#import "CRFoodSource.h"
#import "CRSpawner.h"

@interface CRWhiteTissue : CRRenderedNode <CRSpawnerDelegate>



//which spawner should be used to spawn children?
//the tissue automatically sets itself as the delegate and responds to spawns
@property (nonatomic, strong) CRSpawner * foodSpawner;

@end
