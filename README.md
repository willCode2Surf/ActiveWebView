# ActiveWebView

UIWebView bridge for JavaScript => Objective-C communication

## Usage

### In Objective-C

```
- (void) viewDidLoad {
	ActiveWebView *webView = [[ActiveWebView alloc] initWithFrame:self.view.frame];
	...
	...

	[webView registerAction:@"showAlert" target:self action:@selector(showAlert:)];
}

- (void) showAlert:(NSArray*)args {
	
	NSString* title = [args objectAtIndex:0];
	NSString* description = [args objectAtIndex:1];

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
    													message:description
    												   delegate:self 
    									      cancelButtonTitle:@"OK" 
    									      otherButtonTitles:nil, nil];
    
    [alertView show];

}
```


### In Javascript:

```
ActiveWebView.call('showAlert', ['My Title', 'This is a description'])
```
