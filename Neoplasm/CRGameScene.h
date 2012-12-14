//
//  CRGameScene.h
//  Cancer
//
//  Created by Lukas on 09.12.12.
//  Copyright (c) 2012 Lukas Gianinazzi. All rights reserved.
//

#import "CRScene.h"
#import "CRNeoplasm.h"

@interface CRGameScene : CRScene

+ (CRGameScene*)newGameInView:(UIView*)view withEffect:(GLKBaseEffect*)effect;


@end
