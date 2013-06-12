//
//  PauseLayer.m
//  
//
//  Created by Abhinav Tyagi on 16/01/13.
//  Copyright (c) 2013 Abhinav Tyagi. All rights reserved.
//

#import "PauseLayer.h"

@implementation PauseLayer

-(id)init
{
    //(150, 150, 150, 100) creates a greyish hue.Change these values as requirement.
    if ((self=[super initWithColor:ccc4(150, 150, 150, 100)]))
    {
        //Not adding touch delegate here
        // Touch will be added only when this layer gets added as child.. i.e. in onEnter
        // and removed in onExit
        
    }
    return self;
}


-(void)onEnter
{
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:-3 swallowsTouches:YES];
    
    NSLog(@"Entering pause layer");
}

-(void)onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    NSLog(@"exiting pause layer!!");
    [super onExit];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //We are swallowing all the touches here, so that they dont reach any other element in the game.
    return YES;
}

@end
