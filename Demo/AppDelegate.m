#import "AppDelegate.h"
#import "MASShortcut+Monitoring.h"

NSString *const kPreferenceKeyConstantShortcutEnabled = @"DemoConstantShortcutEnabled";

@implementation AppDelegate {
    id _constantShortcutMonitor1;
    id _constantShortcutMonitor2;
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Activate the shortcuts if they were enabled
    [self resetConstantShortcutRegistration];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
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
        MASShortcut *shortcut1 = [MASShortcut shortcutWithKeyCode:kVK_F1 modifierFlags:NSCommandKeyMask];
        _constantShortcutMonitor1 = [MASShortcut addGlobalHotkeyMonitorWithShortcut:shortcut1 handler:^{
            [[NSAlert alertWithMessageText:NSLocalizedString(@"⌘F1 has been pressed.", @"Alert message for constant shortcut")
                             defaultButton:NSLocalizedString(@"OK", @"Default button for the alert on constant shortcut")
                           alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
        }];
        MASShortcut *shortcut2 = [MASShortcut shortcutWithKeyCode:kVK_F2 modifierFlags:NSCommandKeyMask];
        _constantShortcutMonitor2 = [MASShortcut addGlobalHotkeyMonitorWithShortcut:shortcut2 handler:^{
            [[NSAlert alertWithMessageText:NSLocalizedString(@"⌘F2 has been pressed.", @"Alert message for constant shortcut")
                             defaultButton:NSLocalizedString(@"OK", @"Default button for the alert on constant shortcut")
                           alternateButton:nil otherButton:nil informativeTextWithFormat:@""] runModal];
        }];
    }
    else {
        [MASShortcut removeGlobalHotkeyMonitor:_constantShortcutMonitor1], _constantShortcutMonitor1 = nil;
        [MASShortcut removeGlobalHotkeyMonitor:_constantShortcutMonitor2], _constantShortcutMonitor2 = nil;
    }
}

@end
