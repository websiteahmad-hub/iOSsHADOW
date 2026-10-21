#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ShadowMenuOverlay : UIViewController <WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *menuWebView;
@property (nonatomic, strong) UIButton *floatingButton;
@end

@implementation ShadowMenuOverlay

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    // 1. دروستکردنی WKWebView بۆ نیشاندانی دیزاینەکەی HTML لەناو یارییەکەدا
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.menuWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:config];
    self.menuWebView.backgroundColor = [UIColor clearColor];
    self.menuWebView.opaque = NO;
    self.menuWebView.hidden = YES; // سەرەتای کارکردن شاراوە دەبێت
    
    // لێرەدا هەموو دیزاینی HTML و CSSـەکەی خۆت دادەنێین کە ناردووتە:
    NSString *htmlString = @"<!DOCTYPE html><html lang='en' dir='ltr'><head><meta charset='UTF-8'><style>"
                           @"body{margin:0;background:transparent;display:flex;justify-content:center;align-items:center;height:100vh;font-family:-apple-system,sans-serif;color:white;}"
                           @".ios-alert-box{width:330px;background:rgba(30,32,40,0.85);backdrop-filter:blur(35px);-webkit-backdrop-filter:blur(35px);border:1px solid rgba(255,255,255,0.12);border-radius:26px;box-shadow:0 30px 60px rgba(0,0,0,0.7);padding:26px;text-align:center;}"
                           @"h2{font-size:20px;margin:0 0 10px 0;}"
                           @"p{font-size:13.5px;color:#98989f;margin:0 0 20px 0;}"
                           @".ios-feature-item{display:flex;justify-content:space-between;align-items:center;background:rgba(255,255,255,0.05);padding:11px 15px;border-radius:14px;margin-bottom:10px;font-size:14px;}"
                           @".ios-action-btn{width:100%;padding:13px;border-radius:16px;font-size:15px;font-weight:600;border:none;cursor:pointer;margin-top:8px;background-color:#0a84ff;color:white;}"
                           @"</style></head><body>"
                           @"<div class='ios-alert-box'>"
                           @"<h2>iOS SHADOW</h2>"
                           @"<p>System optimization and advanced features work best.</p>"
                           @"<div class='ios-feature-item'><span>Color Player</span><input type='checkbox'></div>"
                           @"<div class='ios-feature-item'><span>No Recoil</span><input type='checkbox' checked></div>"
                           @"<div class='ios-feature-item'><span>Aimbot</span><input type='checkbox'></div>"
                           @"<div class='ios-feature-item'><span>Black Sky</span><input type='checkbox' checked></div>"
                           @"<div class='ios-feature-item'><span>No Grass</span><input type='checkbox'></div>"
                           @"<button class='ios-action-btn' onclick='alert(\"iOS SHADOW Applied!\")'>Turn On in Settings</button>"
                           @"</div></body></html>";
    
    [self.menuWebView loadHTMLString:htmlString baseURL:nil];
    [self.view addSubview:self.menuWebView];
    
    // 2. دروستکردنی دوگمەی مەلەوان (Floating Button) لە گۆشەی شاشەی پۆبجی
    self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingButton.frame = CGRectMake(35, 35, 62, 62);
    self.floatingButton.backgroundColor = [UIColor colorWithRed:0.12 green:0.13 blue:0.16 alpha:0.85];
    self.floatingButton.layer.cornerRadius = 31;
    self.floatingButton.layer.borderWidth = 1.0;
    self.floatingButton.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.15] CGColor];
    [self.floatingButton setTitle:@"⚡" forState:UIControlStateNormal];
    self.floatingButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [self.floatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.floatingButton];
}

- (void)toggleMenu {
    // گۆڕینی دۆخی دەرکەوتنی مێنیوەکە کاتێک دەست لە لۆگۆکە دەدرێت
    self.menuWebView.hidden = !self.menuWebView.hidden;
}

@end

// 3. کاتێک پۆبجی دەکرێتەوە، ئەمە ڕاستەوخۆ دایلیبەکە لە یادگەدا کارا دەکات
__attribute__((constructor)) void initialize_shadow_mod() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootVC = keyWindow.rootViewController;
        
        ShadowMenuOverlay *overlayVC = [[ShadowMenuOverlay alloc] init];
        overlayVC.view.frame = rootVC.view.bounds;
        [rootVC addChildViewController:overlayVC];
        [rootVC.view addSubview:overlayVC.view];
        [overlayVC didMoveToParentViewController:overlayVC];
    });
}
