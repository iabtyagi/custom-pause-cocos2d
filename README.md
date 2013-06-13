PauseButton and PauseLayer
--------------------------
The `PauseButton` class along with the `PauseLayer` class can be used to add pause/resume functionality in your cocos2d or kobold2d games.

Key features:
   * Custom pause code instead of CCDirector pause.
   * Slider In/Out on pause/resume.
   * Transparent hue over game when paused.

Introduction
-----------
Generally the recommended pause solution for cocos2d games , i.e. CCDirector pause/resume api is only useful for demo purposes. It pauses everything in the game , so running actions and animations while the game is paused is not possible (which is often required in real games).

PauseButton class does not use CCDirector pause. Rather, it implements its own custom pause functionality. It pauses everything for its parent node and all its children and their children and so on , but the PauseLayer is not paused. This can be used to run any actions or animations even when the game is paused.

It also creates a transparent hue on the game when it is paused. A slider also comes out which can be used to create Resume menu (for example Resume button, exit button etc). When resume button is pressed the slider slides back in hiding and the hue layer is removed after which the game resumes.

Getting Started
---------------
1. Copy all the source files from the 'src' directory of this package to your cocos2d or kobold2d project.
2. Copy all the images from the 'images' directory to the 'Resources' directory of your project.
3. In the `init` method of the layer , to which you want to add the pause button , add the following code:

```objc
PauseButton*  pauseBtn = [PauseButton  node];
[self  addChild:pauseBtn];
```

**Note**: `PauseButton` class will pause the layer to which it is added and all its children and sub-children and so on.
So you should add it to the main layer of your scene.

And thats it, with these three simple steps you will have a pause button in your game , fully functional and with effects like transparent hue and a slider.
The `PauseLayer` class is not puased and it can be used to run actions or animations if required.
The images used for pause button , slider and resume button can be changed easily to suit your needs.
If you change the images, don't forget to change the names accordingly in the `init` method in the `PauseButton.m` file.

**Note**: The layout of buttons, in the package as it is, is for landscape mode (Although it will work perfectly fine in any mode as it is , only the layout will be less appealing).

Home button press or Incoming Call (OPTIONAL)
---------------------------------------------
Game can also be paused when the user presses Home button or an incoming call arrives.
You just have to call the pause method of `pauseBtn` object.

Eg.  In your `AppDelegate` override `applicationWillResignActive` and `applicationDidBecomeActive` methods as follows:
```objc
-(void)applicationWillResignActive:(UIApplication *)application
{
    //Pause only if GameLayer in running.
    CCScene * scene = [[CCDirector  sharedDirector] runningScene];
    id layer = [scene getChildByTag:TAG_MY_GAME];  //set this tag in your GameLayer init method
    if (layer)
    {
        // Game is running...pause it
        [layer myAppResignActive];
    }
    else
    {
        //Some other scene is running...do nothing
    }
    [[CCDirector  sharedDirector] pause];
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [[CCDirector  sharedDirector] resume];
}
```
And in your GameLayer add this method:
```objc
-(void)myAppResignActive
{
    [pauseBtn  pauseButtonTouched:self];
}
```

And now your game will be paused when Home button is pressed or on incoming call in the same way as it pauses on pause button press.
