#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

NSString *const domainString = @"com.tomaszpoliszuk.keyboardcontroller";

@interface PSListController (KeyboardController)
@end
@interface KeyboardControllerMainSettings : PSListController {
	NSMutableArray *removeSpecifiers;
}
@end

@implementation KeyboardControllerMainSettings
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		if (kCFCoreFoundationVersionNumber < 1665.15) {
			removeSpecifiers = [[NSMutableArray alloc]init];
			for(PSSpecifier* specifier in _specifiers) {
				NSString* key = [specifier propertyForKey:@"key"];
				if(
					[key hasPrefix:@"shouldShowInternationalKey"]
					||
					[key hasPrefix:@"returnKeyStyling"]
					||
					[key hasPrefix:@"trackpadMode"]
					||
					[key hasPrefix:@"oneHandedKeyboard"]
				) {
					[removeSpecifiers addObject:specifier];
				}

			}
			[_specifiers removeObjectsInArray:removeSpecifiers];
		}
	}
	return _specifiers;
}
- (void)resetSettings {
	NSUserDefaults *tweakSettings = [[NSUserDefaults alloc] initWithSuiteName:domainString];
	UIAlertController *resetSettingsAlert = [UIAlertController alertControllerWithTitle:@"Reset Keyboard Controller Settings" message:@"Do you want to reset settings?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		for(NSString* key in [[tweakSettings dictionaryRepresentation] allKeys]) {
			[tweakSettings removeObjectForKey:key];
		}
		[tweakSettings synchronize];
		[self reloadSpecifiers];
	}];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	[resetSettingsAlert addAction:cancel];
	[resetSettingsAlert addAction:confirm];
	[self presentViewController:resetSettingsAlert animated:YES completion:nil];
}
-(void)sourceCode {
	NSURL *sourceCode = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/KeyboardController"];
	[[UIApplication sharedApplication] openURL:sourceCode options:@{} completionHandler:nil];
}
-(void)knownIssues {
	NSURL *knownIssues = [NSURL URLWithString:@"https://github.com/tomaszpoliszuk/KeyboardController/issues"];
	[[UIApplication sharedApplication] openURL:knownIssues options:@{} completionHandler:nil];
}
-(void)TomaszPoliszukAtBigBoss {
	UIApplication *application = [UIApplication sharedApplication];
	NSString *tweakName = @"Keyboard+Controller";
	NSURL *twitterWebsite = [NSURL URLWithString:[@"http://apt.thebigboss.org/developer-packages.php?name=" stringByAppendingString:tweakName]];
	[application openURL:twitterWebsite options:@{} completionHandler:nil];
}
-(void)TomaszPoliszukAtGithub {
	UIApplication *application = [UIApplication sharedApplication];
	NSString *username = @"tomaszpoliszuk";
	NSURL *githubWebsite = [NSURL URLWithString:[@"https://github.com/" stringByAppendingString:username]];
	[application openURL:githubWebsite options:@{} completionHandler:nil];
}
-(void)TomaszPoliszukAtTwitter {
	UIApplication *application = [UIApplication sharedApplication];
	NSString *username = @"tomaszpoliszuk";
	NSURL *twitterWebsite = [NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:username]];
	[application openURL:twitterWebsite options:@{} completionHandler:nil];
}
@end
