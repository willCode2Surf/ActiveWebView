//
//  ActiveWebView.m
//
//  Copyright (c) 2013, Hector Vergara
//

#import "ActiveWebView.h"

@implementation ActiveWebView

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        self.actions = [NSMutableDictionary new];
    }
    
    return self;
}


//
// Load a file located in internal bundle (aka Project)
// Useful when including static contents
//
- (void) loadFile:(NSString*)fileName directory:(NSString*)directory {
    
    NSString* fullPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:directory];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:fullPath]];
    
    [self loadRequest:request];
}


//
// Load a remote URL
//
- (void) loadURL:(NSURL*)url {
    
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];

    [self loadRequest:request];
}


//
// Assign an web-call with a native method
// Note: Target method must implement (NSArray*) as 1st argument
//
- (void) registerAction:(NSString*)name target:(id)target action:(SEL)action {
    
    NSDictionary* item = @{ @"target": target, 
                            @"action": NSStringFromSelector(action) };

    [self.actions setObject:item forKey:name];
}


//
// Default Trust Delegate: accept all calls from file://
//
- (BOOL) canTrustURL:(NSURL*)url {
    
    if (self.trustDelegate != nil) {
        return [self.trustDelegate canTrustURL:self url:self.request.mainDocumentURL];
    }
    
    return [url.scheme isEqualToString:@"file"];
}


//
// Intercept calls from WebView
// URL format is native://action/{arguments}
//
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request 
                                     navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.scheme isEqualToString:@"native"]) {


        // Abort execution if source is unknown
        if (NO == [self canTrustURL:self.request.mainDocumentURL]) {
            return NO;
        }
        
        
        // Search for registered actions
        NSDictionary* action = [self.actions objectForKey:request.URL.host];
        
        if(action) {
            
            NSArray* arguments = nil;
            
            if(request.URL.path.length > 0) {
                
                // Remove starting slash
                NSString* path = [request.URL.path substringFromIndex:1];
                
                NSData* data = [path dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                arguments = [json objectForKey:@"arguments"];
            }
            
            SEL selector = NSSelectorFromString([action objectForKey:@"action"]);
            id target = [action objectForKey:@"target"];
            
            // Trigger native call
            if ([target respondsToSelector:selector]) {
                [target performSelector:selector withObject:arguments afterDelay:0];
            }
            
        } else {
            NSLog(@"no action found for: %@", request.URL.host);
        }
        
        return NO;
    }

    //Default
    return YES;
}

@end
