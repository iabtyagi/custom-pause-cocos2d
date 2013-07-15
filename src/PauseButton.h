//
//  PauseButton.h
//  
//
//  Created by Abhinav Tyagi on 16/01/13.
//  Copyright (c) 2013 Abhinav Tyagi. All rights reserved.
//

#import "CCNode.h"
#import "PauseLayer.h"

@interface PauseButton : CCNode
{
    BOOL mePaused;  // boolean to keep track of paused state of game
    PauseLayer* pausedLayer;
    CCSprite* resumeSlider;
}

-(void)pauseButtonTouched:(id)sender;

@end

@interface CCNode (IABPauseButton)
-(void) setPosRelativeToParentPos:(CGPoint)pos;
@end
