//
//  ActiveWebView.m
//
//  Copyright (c) 2013, Hector Vergara
//

@protocol ActiveWebTrustDelegate;



@interface ActiveWebView : UIWebView <UIWebViewDelegate>

@property (nonatomic, retain) NSMutableDictionary* actions;
@property (nonatomic, assign) id <ActiveWebTrustDelegate> trustDelegate;

- (void) registerAction:(NSString*)name target:(id)target action:(SEL)action;
- (void) loadFile:(NSString*)fileName directory:(NSString*)directory;
- (void) loadURL:(NSURL*)url;

@end



@protocol ActiveWebTrustDelegate
- (BOOL) canTrustURL:(ActiveWebView*)webView url:(NSURL*)url;
@end
