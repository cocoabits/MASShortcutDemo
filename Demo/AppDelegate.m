#import "AppDelegate.h"
#import "MASShortcutView.h"
#import "MASShortcutView+UserDefaults.h"
#import "MASShortcut+UserDefaults.h"

NSString *const kPreferenceKeyShortcut = @"DemoShortcut";
NSString *const kPreferenceKeyShortcutEnabled = @"DemoShortcutEnabled";

@implementation AppDelegate

@synthesize window = _window;
@synthesize shortcutView = _shortcutView;

#pragma mark -

- (void)awakeFromNib
{
    // Checkbox will enable and disable the shortcut view
    [self.shortcutView bind:@"enabled" toObject:self withKeyPath:@"shortcutEnabled" options:nil];
}

- (void)dealloc
{
    // Cleanup
    [self.shortcutView unbind:@"enabled"];
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Shortcut view will follow and modify user preferences automatically
    self.shortcutView.associatedUserDefaultsKey = kPreferenceKeyShortcut;
    
    // Activate the global keyboard shortcut if it was enabled last time
    [self resetShortcutRegistration];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

#pragma mark -

- (BOOL)isShortcutEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPreferenceKeyShortcutEnabled];
}

- (void)setShortcutEnabled:(BOOL)enabled
{
    if (self.isShortcutEnabled != enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kPreferenceKeyShortcutEnabled];
        [self resetShortcutRegistration];
    }
}

- (void)resetShortcutRegistration
{
    if ([self isShortcutEnabled]) {
        [MASShortcut registerGlobalShortcutWithUserDefaultsKey:kPreferenceKeyShortcut handler:^{
            if ([NSRunningApplication currentApplication].isActive) {
                [[NSApp windows].lastObject zoom:nil];
            }
            else {
                [NSApp requestUserAttention:NSInformationalRequest];
            }
        }];
    }
    else {
        [MASShortcut unregisterGlobalShortcutWithUserDefaultsKey:kPreferenceKeyShortcut];
    }
}

@end
