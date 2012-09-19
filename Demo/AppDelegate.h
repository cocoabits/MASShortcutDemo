@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, assign) IBOutlet NSWindow *window;
@property (nonatomic, getter = isShortcutEnabled) BOOL shortcutEnabled;
@property (nonatomic, getter = isConstantShortcutEnabled) BOOL constantShortcutEnabled;

@end
