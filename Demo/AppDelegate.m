#import "AppDelegate.h"
#import "MASShortcutView.h"
#import "MASShortcutView+UserDefaults.h"
#import "MASShortcut+UserDefaults.h"

NSString *const kPreferenceKeyShortcut = @"DemoShortcut";
NSString *const kPreferenceKeyShortcutEnabled = @"DemoShortcutEnabled";
NSString *const kPreferenceKeyConstantShortcutEnabled = @"DemoConstantShortcutEnabled";

@implementation AppDelegate {
    __weak id _constantShortcutMonitor;
}

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

    // Activate the shortcut Command-F1 if it was enabled
    [self resetConstantShortcutRegistration];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

#pragma mark - Custom shortcut

- (BOOL)isShortcutEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPreferenceKeyShortcutEnabled];
}

- (void)setShortcutEnabled:(BOOL)enabled
{
    if (self.shortcutEnabled != enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kPreferenceKeyShortcutEnabled];
        [self resetShortcutRegistration];
    }
}

- (void)resetShortcutRegistration
{
    if (self.shortcutEnabled) {
        [MASShortcut registerGlobalShortcutWithUserDefaultsKey:kPreferenceKeyShortcut handler:^{
            [[NSAlert alertWithMessageText:NSLocalizedString(@"Global hotkey has been pressed.", @"Alert message for custom shortcut")
                             defaultButton:NSLocalizedString(@"OK", @"Default button for the alert on custom shortcut")
                           alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
        }];
    }
    else {
        [MASShortcut unregisterGlobalShortcutWithUserDefaultsKey:kPreferenceKeyShortcut];
    }
}

#pragma mark - Constant shortcut

- (BOOL)isConstantShortcutEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPreferenceKeyConstantShortcutEnabled];
}

- (void)setConstantShortcutEnabled:(BOOL)enabled
{
    if (self.constantShortcutEnabled != enabled) {
        [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kPreferenceKeyConstantShortcutEnabled];
        [self resetConstantShortcutRegistration];
    }
}

- (void)resetConstantShortcutRegistration
{
    if (self.constantShortcutEnabled) {
        MASShortcut *shortcut = [MASShortcut shortcutWithKeyCode:kVK_F1 modifierFlags:NSCommandKeyMask];
        _constantShortcutMonitor = [MASShortcut addGlobalHotkeyMonitorWithShortcut:shortcut handler:^{
            [[NSAlert alertWithMessageText:NSLocalizedString(@"⌘F1 has been pressed.", @"Alert message for constant shortcut")
                             defaultButton:NSLocalizedString(@"OK", @"Default button for the alert on constant shortcut")
                           alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
        }];
    }
    else {
        [MASShortcut removeGlobalHotkeyMonitor:_constantShortcutMonitor];
    }
}

@end
