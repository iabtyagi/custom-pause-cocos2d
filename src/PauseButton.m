//
//  PauseButton.m
//  
//
//  Created by Abhinav Tyagi on 16/01/13.
//  Copyright (c) 2013 Abhinav Tyagi. All rights reserved.
//

#import "PauseButton.h"
#define TAG_RESUME_BUTTON  33

@implementation PauseButton
-(id)init
{
    if ((self = [super init]))
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCMenuItemImage* pauseBtn = [CCMenuItemImage itemWithNormalImage:@"pausedemobtn.png" selectedImage:@"pausedemobtn.png" target:self selector:@selector(pauseButtonTouched:)];
        
        CCMenu* menu = [CCMenu menuWithItems:pauseBtn, nil];
        menu.position = ccp(screenSize.width * 0.9f, screenSize.height * 0.9f);
        [self addChild:menu];
        mePaused = false;
        
        pausedLayer = [PauseLayer node];  //A layer to create a hue on game and swallow all touches
                                        //but we will add it as child only when game is paused
                                        //and remove on resume.
        
        resumeSlider = [CCSprite spriteWithFile:@"resume_bg.png"];
        [self addChild:resumeSlider z:10];
        resumeSlider.position = ccp((screenSize.width + [resumeSlider texture].contentSize.width / 2) , screenSize.height/2);
        
        CCMenuItemImage* resumeBtn = [CCMenuItemImage itemWithNormalImage:@"resume_button.png" selectedImage:@"resume_button.png" target:self selector:@selector(pauseButtonTouched:)];
        resumeBtn.tag = TAG_RESUME_BUTTON;
        CCMenu* resMenu = [CCMenu menuWithItems:resumeBtn, nil];
        
        [resumeSlider addChild:resMenu];
        [resMenu setPosRelativeToParentPos:ccp(-70.0f,65.0f)];
    }
    return self;
}

//This function is called whenever pause button is touched
//or can be called from outside (for example from AppDelegate's applicationWillResignActive)
//We do Pause or Resume in this function depending on the state of game.
//Single function is used for both the operations so that same behaviour is achieved even if
//we remvove the resume button. i.e. pause/resume are both done by the pause button itself.
-(void)pauseButtonTouched:(id)sender
{
    NSLog(@"Pause/unpause called!!!");
    CCNode* node = [self parent];
    
    BOOL fromButton = NO;   //Boolean to check whether the function is called from the resume button or
                            //from somewhere else(for example AppDelegate's applicationWillResignActive)
    
    if ([sender isKindOfClass:[CCMenuItemImage class]])
    {
        CCMenuItemImage* senderBtn = (CCMenuItemImage*)sender;
        fromButton = (TAG_RESUME_BUTTON == senderBtn.tag);
    }
    
    //Resume shud be done only from resume-button press..
    //If not done so and applicationWillResignActive also calls this function, then it will unpause
    //the game if its already paused(For eg. when Home button pressed while game is paused).
    if(mePaused)
    {
        if (fromButton)
        {
            mePaused = false;
            
            CGSize screenSize = [[CCDirector sharedDirector] winSize];
            CGPoint hiddenPos = ccp((screenSize.width + [resumeSlider texture].contentSize.width / 2) , screenSize.height/2);
            
            CCMoveTo *moveSliderOut = [CCMoveTo actionWithDuration:0.15f position:hiddenPos];
            
            CCCallFunc* func1 = [CCCallFunc actionWithTarget:self selector:@selector(funcRemoveLayer)];
            
            CCCallFunc* func2 = [CCCallFunc actionWithTarget:self selector:@selector(funcResumeGame)];
            
            CCSequence* seq = [CCSequence actions:moveSliderOut,func1,func2, nil];
            
                                //resume after all actions are over.
                                //and since puasebtn and its children are not
                                //not paused,there's no problem.
            
            [resumeSlider runAction:seq];
        }
        else
        {
            //From applicationWillResignActive while game paused...nothing to do.
            NSLog(@"Not from ResumeButton while game paused.Not resuming.");
        }
    }
    else
    {
        [self pauseSchedulerAndActionsRecursive:node];
        mePaused = true;
        
        //Adding pause layer that will create transparent hue on the game
        //and swallow all the touches.
        //To achieve this add the layer with z-order higher than other game elements.
        [self addChild:pausedLayer z:5];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint resumePos = ccp(screenSize.width, screenSize.height/2);
        
        CCMoveTo *moveSliderIn = [CCMoveTo actionWithDuration:0.15f position:resumePos];
        
        [resumeSlider runAction:moveSliderIn];
    }
}

-(void)funcRemoveLayer
{
    [self removeChild:pausedLayer cleanup:NO];
}

-(void)funcResumeGame
{
    CCNode* node = [self parent];
    [self resumeSchedulerAndActionsRecursive:node];
}


//These functions will pause/resume the game.
//Notice that we are not using the CCDirector pause/resume api as it stops everything in the game.
//Here only the game is paused but the puase layer and pause button are not, so we can still
//run actions or animations on it , if need be.
- (void)pauseSchedulerAndActionsRecursive:(CCNode *)node
{
    //NSLog(@"node: %@",node);
    if (node != self)  //actions have to run for pauselayer sprites.skipping PauseButton & its children
    {
        [node pauseSchedulerAndActions];
        for (CCNode *child in [node children])
        {
            [self pauseSchedulerAndActionsRecursive:child];
        }
    }
}

- (void)resumeSchedulerAndActionsRecursive:(CCNode *)node
{
    if (node != self) 
    {
        [node resumeSchedulerAndActions];
        for (CCNode *child in [node children])
        {
            [self resumeSchedulerAndActionsRecursive:child];
        }
    }
}
@end

@implementation CCNode (IABPauseButton)
-(void) setPosRelativeToParentPos:(CGPoint)pos
{
    CGPoint parentAP = _parent.anchorPoint;
    CGSize parentCS = _parent.contentSize;
    self.position = ccp(parentCS.width * parentAP.x + pos.x,
						parentCS.height * parentAP.y + pos.y);
}
@end
