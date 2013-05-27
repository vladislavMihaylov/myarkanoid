
// Common

#define kGameWidth                      320
#define kGameHeight                     480

// SelectLevelLayer

#define kCountItemsInTheLevelsMenu      15
#define kCountOfColumnsInTheLevelsMenu  3
#define kMultiplierForSelectLevelPosY   1.0033333
#define kPosForBackBtn                  ccp(55, 45)

// GameLayer

#define pauseMenuTag                    1

#define kCountParametersOfBlock         3
#define kCountParametersOfEnemy         10

#define kIsLevelType                    0
#define kIsEnemyType                    1

// Other

#define kPlatformHeight                 80   

#define kLevelsURL                      @"https://www.dropbox.com/s/syxv3p2c15d3pzt/levelsDBoxSwap.plist"

extern float BallSpeed;

extern NSInteger currentLevel;

extern float GameCenterX;
extern float GameCenterY;

extern BOOL IsSlowBallSpeed;
extern BOOL IsPlatformIsFat;
extern BOOL IsCatchBonusActive;
extern BOOL IsGunBonusActive;
extern BOOL IsPortalActive;