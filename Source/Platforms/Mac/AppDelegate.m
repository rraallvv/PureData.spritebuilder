#import "AppDelegate.h"

#import "PdAudioUnit.h"
#import "PdBase.h"
#import "AudioHelpers.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet CCGLView *glView;
@property (strong, nonatomic) PdAudioUnit *pdAudioUnit;
@end

static NSString *const kPatchName = @"test.pd";

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    CCDirectorMac *director = (CCDirectorMac*) [CCDirector sharedDirector];

    // enable FPS and SPF
    // [director setDisplayStats:YES];

    // Set a default window size
    CGSize defaultWindowSize = CGSizeMake(480.0f, 320.0f);
    [self.window setFrame:CGRectMake(0.0f, 0.0f, defaultWindowSize.width, defaultWindowSize.height) display:true animate:false];
    [self.glView setFrame:self.window.frame];

    // connect the OpenGL view with the director
    [director setView:self.glView];

    // 'Effects' don't work correctly when autoscale is turned on.
    // Use kCCDirectorResize_NoScale if you don't want auto-scaling.
    //[director setResizeMode:kCCDirectorResize_NoScale];

    // Enable "moving" mouse event. Default no.
    [self.window setAcceptsMouseMovedEvents:NO];

    // Center main window
    [self.window center];

    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    [[CCPackageManager sharedManager] loadPackages];

    [director runWithScene:[CCBReader loadAsScene:@"MainScene"]];

	// PURE DATA INITIALIZATION -----------------------------------------------

	self.pdAudioUnit = [[PdAudioUnit alloc] init];
	[self.pdAudioUnit configureWithSampleRate:44100 numberChannels:2 inputEnabled:NO];
	[self.pdAudioUnit print];
	//[self.pdAudioUnit ]

	void *handle = [PdBase openFile:kPatchName path:[[NSBundle mainBundle] resourcePath]];
	if( handle ) {
		AU_LOG(@"patch successfully opened %@.", kPatchName);
	} else {
		AU_LOG(@"error: patch failed to open %@.", kPatchName);
	}

	self.pdAudioUnit.active = YES;
	AU_LOG(@"PdAudioUnit audio active: %@", (self.pdAudioUnit.isActive ? @"YES" : @"NO" ) );
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [[CCPackageManager sharedManager] savePackages];
}

@end
