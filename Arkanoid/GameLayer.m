
#import "GameLayer.h"
#import "AppDelegate.h"

#import "Ball.h"
#import "Block.h"
#import "Platform.h"

#import "GameConfig.h"
#import "SimpleAudioEngine.h"

#import "Bonus.h"

@implementation GameLayer

@synthesize guiLayer;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	GameLayer *layer = [GameLayer node];
	
	[scene addChild: layer];
    
    GuiLayer *gui = [GuiLayer node];
    [scene addChild: gui];
    
    layer.guiLayer = gui;
    gui.gameLayer = layer;
	
	return scene;
}

- (void) dealloc
{
    [ballsArray release];
    [blocksArray release];
    [bonusesArray release];
    [bulletsArray release];
	[super dealloc];
}

-(id) init
{
	if( (self=[super init]) )
    {
        [[SimpleAudioEngine sharedEngine] preloadEffect: @"shot.wav"];
        
        ballsArray = [[NSMutableArray alloc] init];
        blocksArray = [[NSMutableArray alloc] init];
        bonusesArray = [[NSMutableArray alloc] init];
        bulletsArray = [[NSMutableArray alloc] init];
        
        self.isTouchEnabled = YES;
        
        //bg = [CCSprite spriteWithFile: @"bg.png"];
        //bg.position = ccp(GameCenterX, GameCenterY);
        //bg.opacity = 120;
        //[self addChild: bg];
        
        
        
        portal = [CCSprite spriteWithFile: @"platform.png"];
        portal.position = ccp(GameCenterX, kGameHeight - 30);
        [self addChild: portal];
        
        platform = [Platform create];
        platform.position = ccp(GameCenterX, kPlatformHeight);
        [self addChild: platform];
        
        [self startLevel];
        
    }
    
	return self;
}

- (void) update: (ccTime) dt
{
    if([ballsArray count] == 0)
    {
        lives--;
        
        if(lives <= 0)
        {
            lives = 0;
        }
        
        [guiLayer updateLivesLabel: lives];
        
        ball = [Ball create];
        [ballsArray addObject: ball];
        [self addChild: ball];
        
        [ball setPosition: ccp(platform.position.x, platform.position.y + platform.contentSize.height / 2 + ball.contentSize.height / 2 + 1)];
    }
    
    [self checkPortalCollisionWithBall];
    
    [self checkBulletCollisionWithBlock];
    
    [self removeBullets];
    
    [self checkCollisionsPlatformWithBonus];
    
    [self checkWallCollisionsWithBall];
    
    [self checkCollisionsPlatformWithBall];
    
    [self checkCollisionsBlockwithBall];
    
    for(Ball *currentBall in ballsArray)
    {
        if(currentBall.IsBallRuned)
        {
            [currentBall setPosition: ccp(currentBall.position.x + BallSpeed * currentBall.multiplierX, currentBall.position.y + BallSpeed * currentBall.multiplierY)];
        }
    }
}

- (void) nextLevel
{
    for(Block *curBlock in blocksArray)
    {
        [self removeChild: curBlock cleanup: YES];
    }
    
    [blocksArray removeAllObjects];
    
    [self unPause];
    
    [self turnOffAllBonuses];
    
    currentLevel++;
    
    [self startLevel];
    
}

- (void) pause
{
    self.isTouchEnabled = NO;
    
    for(Bonus *curBonus in bonusesArray)
    {
        [curBonus pauseSchedulerAndActions];
    }
    
    [self pauseSchedulerAndActions];
}

- (void) unPause
{
    self.isTouchEnabled = YES;
    
    for(Bonus *curBonus in bonusesArray)
    {
        [curBonus resumeSchedulerAndActions];
    }
    
    [self resumeSchedulerAndActions];
}

- (void) startLevel
{
    [self genBackground];
    
    score = 0;
    lives = 3;
    
    [guiLayer updateScoreLabel: score];
    [guiLayer updateLivesLabel: lives];
    
    IsGunBonusActive = NO;
    [self unschedule: @selector(shot)];
    
    [self turnOffAllBonuses];
    
    for(CCSprite *curBullet in bulletsArray)
    {
        [self removeChild: curBullet cleanup: YES];
    }
    
    for(Ball *curBall in ballsArray)
    {
        [self removeChild: curBall cleanup: YES];
    }
    
    for(Bonus *curBonus in bonusesArray)
    {
        [self removeChild: curBonus cleanup: YES];
    }
    
    [ballsArray removeAllObjects];
    [bonusesArray removeAllObjects];
    [bulletsArray removeAllObjects];
    
    ball = [Ball create];
    [ballsArray addObject: ball];
    [self addChild: ball];
    
    ball.position = ccp(platform.position.x, platform.position.y + platform.contentSize.height / 2 + ball.contentSize.height / 2 + 1);
    
    NSString *allLevels = [[NSBundle mainBundle] pathForResource: @"levels" ofType: @"plist"];

    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: allLevels];
    
    NSDictionary *dataForCurrentLevel = [dict valueForKey: [NSString stringWithFormat: @"level_%i", currentLevel]];
    
    NSString *coordinats = [dataForCurrentLevel valueForKey: @"coordinats"];
    NSInteger countOfBlocks = [[dataForCurrentLevel valueForKey: @"countBlocks"] integerValue];
    
    NSArray *arrayWithCoordinats = [coordinats componentsSeparatedByString: @","];
    
    for(int i = 0; i < countOfBlocks; i++)
    {
        float posX = [[arrayWithCoordinats objectAtIndex: (i*3)] floatValue];
        float posY = [[arrayWithCoordinats objectAtIndex: ((i*3)+1)] floatValue];
        NSInteger health = [[arrayWithCoordinats objectAtIndex: ((i*3)+2)] integerValue];
        
        Block *block = [Block create];
        block.position = ccp(posX, posY);
        block.health = health;
        [block updateSprite: health];
        [blocksArray addObject: block];
        [self addChild: block];
    }
    
    CCLOG(@"LOADED OK; Balls: %i Blocks: %i", [ballsArray count], [blocksArray count]);
    
    [self unscheduleUpdate];
    [self scheduleUpdate];
}

- (ccColor4F) generateRandomColor
{
    while (true) {
        float requiredBrightness = 192;
        ccColor4B randomColor =
        ccc4(arc4random() % 255,
             arc4random() % 255,
             arc4random() % 255,
             255);
        if (randomColor.r > requiredBrightness ||
            randomColor.g > requiredBrightness ||
            randomColor.b > requiredBrightness) {
            return ccc4FFromccc4B(randomColor);
        }
    }
}

- (void) genBackground
{
    [_background removeFromParentAndCleanup:YES];
    
    ccColor4F bgColor = [self generateRandomColor];
    ccColor4F color2 = [self generateRandomColor];
    //_background = [self spriteWithColor:bgColor textureSize:512];
    int nStripes = ((arc4random() % 8) + 4) * 2;
    _background = [self stripedSpriteWithColor1:bgColor color2:color2 textureSize: 512 stripes:nStripes];
    
    //self.scale = 0.5;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _background.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:_background z:-1];
}

-(CCSprite *)spriteWithColor:(ccColor4F)bgColor textureSize:(float)textureSize {
    
    // 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureSize height:textureSize];
    
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:bgColor.r g:bgColor.g b:bgColor.b a:bgColor.a];
    
    // 3: Draw into the texture
    ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position | kCCVertexAttribFlag_Color );
    
    float gradientAlpha = 0.7;
    CGPoint vertices[4];
    ccColor4F colors[4];
    int nVertices = 0;
    
    vertices[nVertices] = CGPointMake(0, 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0 };
    vertices[nVertices] = CGPointMake(textureSize*CC_CONTENT_SCALE_FACTOR(), 0);
    colors[nVertices++] = (ccColor4F){0, 0, 0, 0};
    vertices[nVertices] = CGPointMake(0, textureSize*CC_CONTENT_SCALE_FACTOR());
    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
    vertices[nVertices] = CGPointMake(textureSize*CC_CONTENT_SCALE_FACTOR(), textureSize*CC_CONTENT_SCALE_FACTOR());
    colors[nVertices++] = (ccColor4F){0, 0, 0, gradientAlpha};
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, colors);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei)nVertices);
    
    CCSprite *noise = [CCSprite spriteWithFile:@"Noise.png"];
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(textureSize/2, textureSize/2);
    [noise visit];
    
    // 4: Call CCRenderTexture:end
    [rt end];
    
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
    
}

-(CCSprite *)stripedSpriteWithColor1:(ccColor4F)c1 color2:(ccColor4F)c2 textureSize:(float)textureSize  stripes:(int)nStripes {
    
    // 1: Create new CCRenderTexture
    CCRenderTexture *rt = [CCRenderTexture renderTextureWithWidth:textureSize height:textureSize];
    
    // 2: Call CCRenderTexture:begin
    [rt beginWithClear:c1.r g:c1.g b:c1.b a:c1.a];
    
    // 3: Draw into the texture
    
    // Layer 1: Stripes
    ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position | kCCVertexAttribFlag_Color );
    
    CGPoint vertices[nStripes*6];
    int nVertices = 0;
    float x1 = -textureSize;
    float x2;
    float y1 = textureSize;
    float y2 = 0;
    float dx = textureSize / nStripes * 2;
    float stripeWidth = dx/2;
    for (int i=0; i<nStripes; i++) {
        x2 = x1 + textureSize;
        vertices[nVertices++] = ccpMult(CGPointMake(x1, y1), CC_CONTENT_SCALE_FACTOR());
        vertices[nVertices++] = ccpMult(CGPointMake(x1+stripeWidth, y1), CC_CONTENT_SCALE_FACTOR());
        vertices[nVertices++] = ccpMult(CGPointMake(x2, y2), CC_CONTENT_SCALE_FACTOR());
        vertices[nVertices++] = vertices[nVertices-2];
        vertices[nVertices++] = vertices[nVertices-2];
        vertices[nVertices++] = ccpMult(CGPointMake(x2+stripeWidth, y2), CC_CONTENT_SCALE_FACTOR());
        x1 += dx;
    }
    
    ccDrawColor4F(c2.r, c2.g, c2.b, c2.a);
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glDrawArrays(GL_TRIANGLES, 0, (GLsizei)nVertices);
    

    
    // Layer 2: Noise
    CCSprite *noise = [CCSprite spriteWithFile:@"Noise.png"];
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(textureSize/2, textureSize/2);
    [noise visit];
    
    // 4: Call CCRenderTexture:end
    [rt end];
    
    // 5: Create a new Sprite from the texture
    return [CCSprite spriteWithTexture:rt.sprite.texture];
    
}

#pragma mark For fun

- (void) harlemShake: (NSInteger) multX and: (NSInteger) multY
{
    [self runAction:
                [CCSequence actions:
                            [CCMoveTo actionWithDuration: 0.04 position: ccp(-5 * multX, -5 * multY)],
                            [CCMoveTo actionWithDuration: 0.08 position: ccp(5 * multX, 5 * multY)],
                            [CCMoveTo actionWithDuration: 0.04 position: ccp(0, 0)],
      nil]];
}

#pragma mark Touches

- (void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate: self priority: 0 swallowsTouches: YES];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    
    if(location.x > (320 - platform.contentSize.width / 2))
    {
        location.x = 320 - platform.contentSize.width / 2;
    }
    
    if(location.x < platform.contentSize.width / 2)
    {
        location.x = platform.contentSize.width / 2;
    }
    
    for (Ball *curBall in ballsArray)
    {
        if(!curBall.IsBallRuned)
        {
            [curBall runAction: [CCMoveTo actionWithDuration: 0.1 position: ccp(location.x + curBall.differenceX, curBall.position.y)]];
        }
    }
    
    [platform runAction: [CCMoveTo actionWithDuration: 0.1 position: ccp(location.x, platform.position.y)]];
    
    return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    
    if(location.x > (320 - platform.contentSize.width / 2))
    {
        location.x = 320 - platform.contentSize.width / 2;
    }
    
    if(location.x < platform.contentSize.width / 2)
    {
        location.x = platform.contentSize.width / 2;
    }
    
    [platform setPosition: ccp(location.x, platform.position.y)];
    
    for (Ball *curBall in ballsArray)
    {
        if(!curBall.IsBallRuned)
        {
            [curBall setPosition: ccp(location.x + curBall.differenceX, curBall.position.y)];
        }
    }
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    for (Ball *curBall in ballsArray)
    {
        if(!curBall.IsBallRuned)
        {
            curBall.IsBallRuned = YES;
            //IsCatchBonusActive = NO;
        }
    }
}

#pragma mark Collisions

- (void) checkCollisionsPlatformWithBall
{
    for(Ball *currentBall in ballsArray)
    {
        float differenceX = fabs(currentBall.position.x - platform.position.x);
        float differenceWidth = fabs(currentBall.contentSize.width / 2 + platform.contentSize.width / 2);
        
        float differenceY = fabs(currentBall.position.y - platform.position.y);
        float differenceHeight = fabs(currentBall.contentSize.height / 2 + platform.contentSize.height / 2);
        
        BOOL isVerticalCollision = differenceY < differenceHeight;
        BOOL isHorisontalCollision = differenceX < differenceWidth;
        
        BOOL isBallCollisiedLeftBorder = (platform.position.x - currentBall.position.x > platform.contentSize.width / 2) &&
                                          currentBall.multiplierX > 0;
        BOOL isBallCollisiedRightBorder = (currentBall.position.x - platform.position.x > platform.contentSize.width / 2) &&
                                           currentBall.multiplierX < 0;
        
        BOOL isContactWithLeftPartOfPlatform = platform.position.x - currentBall.position.x >= 0;
        
        if (isVerticalCollision && isHorisontalCollision)
        {
            if(currentBall.multiplierY < 0)
            {
                currentBall.multiplierY *= -1;
            }
            
            if(currentBall.multiplierX > 0) // если мяч летит слева
            {
                if(isContactWithLeftPartOfPlatform)
                {
                    CCLOG(@"contact LEFT from LEFT");
                    if(currentBall.multiplierX > 0.4)
                    {
                        currentBall.multiplierX -= 0.2;
                        currentBall.multiplierY += 0.2;
                    }
                }
                else
                {
                    CCLOG(@"contact RIGHT from LEFT");
                    if(currentBall.multiplierX < 1.8)
                    {
                        currentBall.multiplierX += 0.2;
                        currentBall.multiplierY -= 0.2;
                    }
                }
            }
            else // если мяч летит справа
            {
                if(isContactWithLeftPartOfPlatform)
                {
                    CCLOG(@"contact LEFT from RIGHT");
                    if(currentBall.multiplierX > -1.8)
                    {
                        currentBall.multiplierX -= 0.2;
                        currentBall.multiplierY -= 0.2;
                    }
                }
                else
                {
                    CCLOG(@"contact RIGHT from RIGHT");
                    if(currentBall.multiplierX < -0.4)
                    {
                        currentBall.multiplierX += 0.2;
                        currentBall.multiplierY += 0.2;
                    }
                }
            }
            
            if(isBallCollisiedRightBorder || isBallCollisiedLeftBorder)
            {
                currentBall.multiplierX *= -1;
            }
            
            
            
            if(IsCatchBonusActive)
            {
                currentBall.differenceX = currentBall.position.x - platform.position.x;
                [currentBall setPosition: ccp(currentBall.position.x, currentBall.position.y + 2)];
                currentBall.IsBallRuned = NO;
            }
            
            [self harlemShake: 0 and: currentBall.multiplierY];
            
            CCLOG(@"X: %f Y: %f", currentBall.multiplierX, currentBall.multiplierY);
            
            //[[SimpleAudioEngine sharedEngine] playEffect: @"shot.wav"];
        }
    }
}

- (void) checkCollisionsPlatformWithBonus
{
    NSMutableArray *bonusToRemove = [[NSMutableArray alloc] init];
    
    for(Bonus *curBonus in bonusesArray)
    {
        if((fabs(curBonus.position.y - platform.position.y) < fabs(curBonus.contentSize.height / 2 + platform.contentSize.height / 2)) &&
           (fabs(curBonus.position.x - platform.position.x) < fabs(curBonus.contentSize.width / 2 + platform.contentSize.width / 2)))
        {
            [bonusToRemove addObject: curBonus];
            [self applyBonus: curBonus.type];
        }
    }
    
    for(Bonus *curBonusToRemove in bonusToRemove)
    {
        [self removeChild: curBonusToRemove cleanup: YES];
        [bonusesArray removeObject: curBonusToRemove];
    }
    
    [bonusToRemove release];
}

- (void) checkWallCollisionsWithBall
{
    NSMutableArray *ballsToRemove = [[NSMutableArray alloc] init];
    
    for(Ball *currentBall in ballsArray)
    {
        if(currentBall.position.x >= (kGameWidth - currentBall.contentSize.width / 2))
        {
            if(currentBall.multiplierX > 0)
            {
                currentBall.multiplierX *= -1;
            }
            
            [self harlemShake: currentBall.multiplierX and: 0];
            //[[SimpleAudioEngine sharedEngine] playEffect: @"shot.wav"];
        }
        if(currentBall.position.x < (0 + currentBall.contentSize.width / 2))
        {
            if(currentBall.multiplierX < 0)
            {
                currentBall.multiplierX *= -1;
            }
            
            [self harlemShake: currentBall.multiplierX and: 0];
            //[[SimpleAudioEngine sharedEngine] playEffect: @"shot.wav"];
        }
        
        if(currentBall.position.y >= (kGameHeight - 30 - currentBall.contentSize.height / 2))
        {
            if(currentBall.multiplierY > 0)
            {
                currentBall.multiplierY *= -1;
            }
            
            [self harlemShake: 0 and: currentBall.multiplierY];
            //[[SimpleAudioEngine sharedEngine] playEffect: @"shot.wav"];
        }
        if(currentBall.position.y < 0)
        {
            if([ballsArray count] == 1)
            {
                lives--;
                
                if(lives <= 0)
                {
                    lives = 0;
                }
                
                [guiLayer updateLivesLabel: lives];
                
                currentBall.multiplierY = 1;
                currentBall.multiplierX = 1;
                currentBall.IsBallRuned = NO;
                
                [currentBall setPosition: ccp(platform.position.x, platform.position.y + platform.contentSize.height / 2 + currentBall.contentSize.height / 2 + 1)];
            }
            else
            {
                [ballsToRemove addObject: currentBall];
            }
        }
    }
    
    for (Ball *curBallToRemove in ballsToRemove)
    {
        [self removeChild: curBallToRemove cleanup: YES];
        [ballsArray removeObject: curBallToRemove];
    }
    
    [ballsToRemove release];
}

- (void) checkCollisionsBlockwithBall
{
    NSMutableArray *blockForRemove = [[NSMutableArray alloc] init];
    
    for(Ball *curBall in ballsArray)
    {
        for(Block *curBlock in blocksArray)
        {
            if((fabs(curBall.position.y - curBlock.position.y) <= fabs(curBall.contentSize.height / 2 + curBlock.contentSize.height / 2)) &&
               (fabs(curBall.position.x - curBlock.position.x) <= fabs(curBall.contentSize.width / 2 + curBlock.contentSize.width / 2)))
            {
                if(fabs(curBall.position.x - curBlock.position.x) < (curBlock.contentSize.width/2 + curBall.contentSize.width/2 - 3))
                { 
                    curBall.multiplierY *= -1;
                }
                if(fabs(curBall.position.y - curBlock.position.y) < (curBlock.contentSize.height/2 + curBall.contentSize.height/2 - 3))
                {
                    curBall.multiplierX *= -1;
                     
                }
                
                [self harlemShake: 0 and: curBall.multiplierY];
                
                curBlock.health -= 1;
                
                if(curBlock.health > 0)
                {
                    [curBlock updateSprite: curBlock.health];
                }
                
                if(curBlock.health <= 0)
                {
                    [blockForRemove addObject: curBlock];
                    
                    NSInteger randNumForBonus = arc4random() % 10;
                    
                    if(randNumForBonus % 3 == 0 && randNumForBonus != 0)
                    {
                        Bonus *bonus = [Bonus create];
                        bonus.position = curBlock.position;
                        [self addChild: bonus];
                        
                        [bonusesArray addObject: bonus];
                        [self moveBonus: bonus];
                    }
                }
                
                [guiLayer updateScoreLabel: score += 5];
                
                //[[SimpleAudioEngine sharedEngine] playEffect: @"shot.wav"];
                
                
            }
        }
    }
    
    for(Block *curBlockForRemove in blockForRemove)
    {
        [self removeChild: curBlockForRemove cleanup: YES];
        
        [blocksArray removeObject: curBlockForRemove];
    }
    
    if([blocksArray count] == 0)
    {
        IsPortalActive = YES;
    }
    
    [blockForRemove release];
 
}

- (void) checkPortalCollisionWithBall
{
    if([blocksArray count] == 0)
    {
        for(Ball *curBall in ballsArray)
        {
            if((fabs(curBall.position.y - portal.position.y) < fabs(curBall.contentSize.height / 2 + portal.contentSize.height / 2)) &&
               (fabs(curBall.position.x - portal.position.x) < fabs(curBall.contentSize.width / 2 + portal.contentSize.width / 2)))
            {
                if(IsPortalActive)
                {
                    //IsPortalActive = NO;
                }
            }
        }
        
        if(!IsPortalActive)
        {
            [self nextLevel];
        }
    }
}


- (void) checkBulletCollisionWithBlock
{
    NSMutableArray *bulletsToRemove = [[NSMutableArray alloc] init];
    NSMutableArray *blocksToRemove = [[NSMutableArray alloc] init];
    
    for(CCSprite *curBullet in bulletsArray)
    {
        for(Block *curBlock in blocksArray)
        {
            if((fabs(curBullet.position.y - curBlock.position.y) <= fabs(curBullet.contentSize.height / 2 + curBlock.contentSize.height / 2)) &&
               (fabs(curBullet.position.x - curBlock.position.x) <= fabs(curBullet.contentSize.width / 2 + curBlock.contentSize.width / 2)))
            {
                [bulletsToRemove addObject: curBullet];
                
                curBlock.health -= 1;
                
                [curBlock updateSprite: curBlock.health];
                
                if(curBlock.health == 0)
                {
                    [blocksToRemove addObject: curBlock];
                }
            }
        }
    }
    
    for(CCSprite *curBulletToRemove in bulletsToRemove)
    {
        [self removeChild: curBulletToRemove cleanup: YES];
        [bulletsArray removeObject: curBulletToRemove];
    }
    
    for(Block *curBlockToRemove in blocksToRemove)
    {
        [self removeChild: curBlockToRemove cleanup: YES];
        [blocksArray removeObject: curBlockToRemove];
    }
    
    [bulletsToRemove release];
    [blocksToRemove release];
}

- (void) removeBullets
{
    NSMutableArray *bulletsToRemove = [[NSMutableArray alloc] init];
    
    for(CCSprite *curBullet in bulletsArray)
    {
        if(curBullet.position.y > kGameHeight + 10)
        {
            [bulletsToRemove addObject: curBullet];
        }
    }
    
    for(CCSprite *curBulletToRemove in bulletsToRemove)
    {
        [self removeChild: curBulletToRemove cleanup: YES];
        [bulletsArray removeObject: curBulletToRemove];
    }
    
    [bulletsToRemove release];
}

- (void) moveBonus: (Bonus *) curBonus
{
    if(curBonus.position.y < 0)
    {
        [self removeChild: curBonus cleanup: YES];
        [bonusesArray removeObject: curBonus];
    }
    
    [curBonus runAction: [CCSequence actions: [CCMoveTo actionWithDuration: 0.7 position: ccp(curBonus.position.x, curBonus.position.y - 100)], [CCCallBlock actionWithBlock: ^(id sender){[self moveBonus: curBonus];}], nil]];
}

- (void) applyBonus: (NSInteger) bonusType
{
    if(bonusType == 0)
    {
        if(!IsPlatformIsFat)
        {
            IsPlatformIsFat = YES;
            [platform doDoubleWidth];
            [self schedule: @selector(returnNormalPlatform) interval: 15];
        }
        
    }
    if(bonusType == 1)
    {
        for(Ball *curBall in ballsArray)
        {
            newBall = [Ball create];
            newBall.position = curBall.position;
            newBall.multiplierX = curBall.multiplierX * -1;
            newBall.multiplierY = curBall.multiplierY;
            newBall.IsBallRuned = YES;
            
        }
        
        [self addChild: newBall];
        [ballsArray addObject: newBall];
    }
    if(bonusType == 2)
    {
        if(!IsGunBonusActive)
        {
            IsGunBonusActive = YES;
            [platform activateGuns];
            [self schedule: @selector(removeGuns) interval: 10];
            [self schedule: @selector(shot) interval: 0.3];
            [self shot];
        }
    }
    if(bonusType == 3)
    {
        if(!IsSlowBallSpeed)
        {
            IsSlowBallSpeed = YES;
            BallSpeed /= 2;
            [self schedule: @selector(accelerateBall) interval: 15];
        }
    }
    if(bonusType == 4)
    {
        if(!IsCatchBonusActive)
        {
            IsCatchBonusActive = YES;
            [self schedule: @selector(turnOffCatchBonus) interval: 15];
        }
    }
    if(bonusType == 5)
    {
        lives++;
        [guiLayer updateLivesLabel: lives];
    }
}

- (void) removeGuns
{
    [self unschedule: @selector(shot)];
    IsGunBonusActive = NO;
    [platform removeGuns];
    [self unschedule: @selector(removeGuns)];
}

- (void) returnNormalPlatform
{
    [platform doUsuallyWidth];
    IsPlatformIsFat = NO;
    [self unschedule: @selector(returnNormalPlatform)];
}

- (void) accelerateBall
{
    IsSlowBallSpeed = NO;
    BallSpeed *= 2;
    [self unschedule: @selector(accelerateBall)];
}

- (void) turnOffCatchBonus
{
    IsCatchBonusActive = NO;
    [self unschedule: @selector(turnOffCatchBonus)];
    
    for(Ball *curBall in ballsArray)
    {
        curBall.differenceX = 0;
    }
}

- (void) turnOffAllBonuses
{
    [self turnOffCatchBonus];
    [self accelerateBall];
    [self returnNormalPlatform];
    [self removeGuns];
    
    BallSpeed = 3;
}

- (void) shot
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"shot.wav"];
    
    CCSprite *bulletSprite = [CCSprite spriteWithFile: @"bullet.png"];
    bulletSprite.position = ccp(platform.position.x - platform.contentSize.width / 2 + 3, platform.position.y + 20);
    [bulletsArray addObject: bulletSprite];
    [self addChild: bulletSprite];
    
    CCSprite *bulletSprite2 = [CCSprite spriteWithFile: @"bullet.png"];
    bulletSprite2.position = ccp(platform.position.x + platform.contentSize.width / 2 - 3, platform.position.y + 20);
    [bulletsArray addObject: bulletSprite2];
    [self addChild: bulletSprite2];
    
    [bulletSprite runAction: [CCMoveTo actionWithDuration: 1.0 position: ccp(bulletSprite.position.x, 500)]];
    [bulletSprite2 runAction: [CCMoveTo actionWithDuration: 1.0 position: ccp(bulletSprite2.position.x, 500)]];
}

@end
