#define userSettingsFile @"/var/mobile/Library/Preferences/com.tomaszpoliszuk.keyboardcontroller.plist"
#define packageName "com.tomaszpoliszuk.keyboardcontroller"

NSMutableDictionary *tweakSettings;

static bool enableTweak;

static int uiStyle;

static long long defaultKeyboard;
static long long asciiCapableKeyboard;
static long long numbersAndPunctuationKeyboard;
static long long urlKeyboard;
static long long numberPadKeyboard;
static long long phonePadKeyboard;
static long long namePhonePadKeyboard;
static long long emailAddressKeyboard;
static long long decimalPadKeyboard;
static long long twitterKeyboard;
static long long webSearchKeyboard;
static long long asciiCapableNumberPadKeyboard;
static long long alphabetKeyboard;

static long long returnKeyTypeDefault;
static long long returnKeyTypeGo;
static long long returnKeyTypeGoogle;
static long long returnKeyTypeJoin;
static long long returnKeyTypeNext;
static long long returnKeyTypeRoute;
static long long returnKeyTypeSearch;
static long long returnKeyTypeSend;
static long long returnKeyTypeYahoo;
static long long returnKeyTypeDone;
static long long returnKeyTypeEmergencyCall;
static long long returnKeyTypeContinue;

static long long keyboardDismissMode;

static int trackpadMode;

static int returnKeyStyling;

static int dictationButton;

static int shouldShowInternationalKey;

static int selectingSkinToneForEmoji;

static int oneHandedKeyboard;

static int useBlueThemingForKey;

void SettingsChanged() {
	CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR(packageName), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if(keyList) {
		tweakSettings = (NSMutableDictionary *)CFBridgingRelease(
			CFPreferencesCopyMultiple(
				keyList,
				CFSTR(packageName),
				kCFPreferencesCurrentUser,
				kCFPreferencesAnyHost
			)
		);
		CFRelease(keyList);
	} else {
		tweakSettings = nil;
	}
	if (!tweakSettings) {
		tweakSettings = [NSMutableDictionary dictionaryWithContentsOfFile:userSettingsFile];
	}

	enableTweak = [([tweakSettings objectForKey:@"enableTweak"] ?: @(YES)) boolValue];

	uiStyle = [([tweakSettings valueForKey:@"uiStyle"] ?: @(999)) integerValue];

	defaultKeyboard = [([tweakSettings valueForKey:@"defaultKeyboard"] ?: @(0)) integerValue];
	asciiCapableKeyboard = [([tweakSettings valueForKey:@"asciiCapableKeyboard"] ?: @(1)) integerValue];
	numbersAndPunctuationKeyboard = [([tweakSettings valueForKey:@"numbersAndPunctuationKeyboard"] ?: @(2)) integerValue];
	urlKeyboard = [([tweakSettings valueForKey:@"urlKeyboard"] ?: @(3)) integerValue];
	numberPadKeyboard = [([tweakSettings valueForKey:@"numberPadKeyboard"] ?: @(4)) integerValue];
	phonePadKeyboard = [([tweakSettings valueForKey:@"phonePadKeyboard"] ?: @(5)) integerValue];
	namePhonePadKeyboard = [([tweakSettings valueForKey:@"namePhonePadKeyboard"] ?: @(6)) integerValue];
	emailAddressKeyboard = [([tweakSettings valueForKey:@"emailAddressKeyboard"] ?: @(7)) integerValue];
	decimalPadKeyboard = [([tweakSettings valueForKey:@"decimalPadKeyboard"] ?: @(8)) integerValue];
	twitterKeyboard = [([tweakSettings valueForKey:@"twitterKeyboard"] ?: @(9)) integerValue];
	webSearchKeyboard = [([tweakSettings valueForKey:@"webSearchKeyboard"] ?: @(10)) integerValue];
	asciiCapableNumberPadKeyboard = [([tweakSettings valueForKey:@"asciiCapableNumberPadKeyboard"] ?: @(11)) integerValue];
	alphabetKeyboard = [([tweakSettings valueForKey:@"alphabetKeyboard"] ?: @(12)) integerValue];

	returnKeyTypeDefault = [([tweakSettings valueForKey:@"returnKeyTypeDefault"] ?: @(0)) integerValue];
	returnKeyTypeGo = [([tweakSettings valueForKey:@"returnKeyTypeGo"] ?: @(1)) integerValue];
	returnKeyTypeGoogle = [([tweakSettings valueForKey:@"returnKeyTypeGoogle"] ?: @(2)) integerValue];
	returnKeyTypeJoin = [([tweakSettings valueForKey:@"returnKeyTypeJoin"] ?: @(3)) integerValue];
	returnKeyTypeNext = [([tweakSettings valueForKey:@"returnKeyTypeNext"] ?: @(4)) integerValue];
	returnKeyTypeRoute = [([tweakSettings valueForKey:@"returnKeyTypeRoute"] ?: @(5)) integerValue];
	returnKeyTypeSearch = [([tweakSettings valueForKey:@"returnKeyTypeSearch"] ?: @(6)) integerValue];
	returnKeyTypeSend = [([tweakSettings valueForKey:@"returnKeyTypeSend"] ?: @(7)) integerValue];
	returnKeyTypeYahoo = [([tweakSettings valueForKey:@"returnKeyTypeYahoo"] ?: @(8)) integerValue];
	returnKeyTypeDone = [([tweakSettings valueForKey:@"returnKeyTypeDone"] ?: @(9)) integerValue];
	returnKeyTypeEmergencyCall = [([tweakSettings valueForKey:@"returnKeyTypeEmergencyCall"] ?: @(10)) integerValue];
	returnKeyTypeContinue = [([tweakSettings valueForKey:@"returnKeyTypeContinue"] ?: @(11)) integerValue];

	keyboardDismissMode = [([tweakSettings valueForKey:@"keyboardDismissMode"] ?: @(999)) integerValue];

	trackpadMode = [([tweakSettings valueForKey:@"trackpadMode"] ?: @(999)) integerValue];

	returnKeyStyling = [([tweakSettings valueForKey:@"returnKeyStyling"] ?: @(999)) integerValue];

	dictationButton = [([tweakSettings objectForKey:@"dictationButton"] ?: @(999)) integerValue];

	shouldShowInternationalKey = [([tweakSettings objectForKey:@"shouldShowInternationalKey"] ?: @(999)) integerValue];

	selectingSkinToneForEmoji = [([tweakSettings objectForKey:@"selectingSkinToneForEmoji"] ?: @(999)) integerValue];

	oneHandedKeyboard = [([tweakSettings valueForKey:@"oneHandedKeyboard"] ?: @(999)) integerValue];

	useBlueThemingForKey = [([tweakSettings objectForKey:@"useBlueThemingForKey"] ?: @(999)) integerValue];
}

static void receivedNotification(
	CFNotificationCenterRef center,
	void *observer,
	CFStringRef name,
	const void *object,
	CFDictionaryRef userInfo
) {
	SettingsChanged();
}


@interface UIView (KeyboardController)
-(id)_viewControllerForAncestor;
@end

%hook UITextInputTraits
- (long long)keyboardAppearance {
	long long origValue = %orig;
	if ( enableTweak && uiStyle != 999 ) {
		return uiStyle;
	} else {
		return origValue;
	}
}
- (long long)keyboardType {
	long long origValue = %orig;
	if ( origValue == 0 && enableTweak ) {
		return defaultKeyboard;
	} else if ( origValue == 1 && enableTweak ) {
		return asciiCapableKeyboard;
	} else if ( origValue == 2 && enableTweak ) {
		return numbersAndPunctuationKeyboard;
	} else if ( origValue == 3 && enableTweak ) {
		return urlKeyboard;
	} else if ( origValue == 4 && enableTweak ) {
		return numberPadKeyboard;
	} else if ( origValue == 5 && enableTweak ) {
		return phonePadKeyboard;
	} else if ( origValue == 6 && enableTweak ) {
		return namePhonePadKeyboard;
	} else if ( origValue == 7 && enableTweak ) {
		return emailAddressKeyboard;
	} else if ( origValue == 8 && enableTweak ) {
		return decimalPadKeyboard;
	} else if ( origValue == 9 && enableTweak ) {
		return twitterKeyboard;
	} else if ( origValue == 10 && enableTweak ) {
		return webSearchKeyboard;
	} else if ( origValue == 11 && enableTweak ) {
		return asciiCapableNumberPadKeyboard;
	} else if ( origValue == 12 && enableTweak ) {
		return alphabetKeyboard;
	} else {
		return origValue;
	}
}
- (long long)returnKeyType {
	long long origValue = %orig;
	if ( origValue == 0 && enableTweak ) {
		return returnKeyTypeDefault;
	} else if ( origValue == 1 && enableTweak ) {
		return returnKeyTypeGo;
	} else if ( origValue == 2 && enableTweak ) {
		return returnKeyTypeGoogle;
	} else if ( origValue == 3 && enableTweak ) {
		return returnKeyTypeJoin;
	} else if ( origValue == 4 && enableTweak ) {
		return returnKeyTypeNext;
	} else if ( origValue == 5 && enableTweak ) {
		return returnKeyTypeRoute;
	} else if ( origValue == 6 && enableTweak ) {
		return returnKeyTypeSearch;
	} else if ( origValue == 7 && enableTweak ) {
		return returnKeyTypeSend;
	} else if ( origValue == 8 && enableTweak ) {
		return returnKeyTypeYahoo;
	} else if ( origValue == 9 && enableTweak ) {
		return returnKeyTypeDone;
	} else if ( origValue == 10 && enableTweak ) {
		return returnKeyTypeEmergencyCall;
	} else if ( origValue == 11 && enableTweak ) {
		return returnKeyTypeContinue;
	} else {
		return origValue;
	}
}
- (int)forceDisableDictation {
	int origValue = %orig;
	if ( enableTweak && dictationButton != 999 ) {
		return !dictationButton;
	} else {
		return origValue;
	}
}
- (int)forceEnableDictation {
	int origValue = %orig;
	if ( enableTweak && dictationButton != 999 ) {
		return dictationButton;
	} else {
		return origValue;
	}
}
- (int)suppressReturnKeyStyling {
	int origValue = %orig;
	if ( enableTweak && returnKeyStyling != 999 ) {
		return !returnKeyStyling;
	} else {
		return origValue;
	}
}
%end

%hook UIScrollView
- (long long)keyboardDismissMode {
	long long origValue = %orig;
	if ( enableTweak && keyboardDismissMode != 999 ) {
		if (
			![[self _viewControllerForAncestor] isKindOfClass:%c(UICompatibilityInputViewController)]
			&&
			![[self _viewControllerForAncestor] isKindOfClass:%c(UICandidateViewController)]
		) {
			return keyboardDismissMode;
		}
	}
	return origValue;
}
%end

%hook _UIKeyboardTextSelectionInteraction
- (int)forceTouchGestureRecognizerShouldBegin:(id)arg1 {
	int origValue = %orig;
	if ( enableTweak && trackpadMode == 404 ) {
		return NO;
	} else if ( enableTweak && trackpadMode == 505 ) {
		return NO;
	} else if ( enableTweak && trackpadMode == 1 ) {
		return YES;
	}
	return origValue;
}
- (int)gestureRecognizerShouldBegin:(id)arg1 {
	int origValue = %orig;
	if ( enableTweak && trackpadMode == 404 ) {
		return NO;
	} else if ( enableTweak && trackpadMode == 505 ) {
		return YES;
	} else if ( enableTweak && trackpadMode == 1 ) {
		return YES;
	}
	return origValue;
}
%end

%hook UIKeyboardImpl
- (int)shouldShowInternationalKey {
	int origValue = %orig;
	if ( enableTweak && shouldShowInternationalKey != 999 ) {
		return shouldShowInternationalKey;
	} else {
		return origValue;
	}
}
%end

%hook UIKeyboardEmojiCollectionInputView
- (int)skinToneWasUsedForEmoji:(id)arg1 {
	int origValue = %orig;
	if ( enableTweak && selectingSkinToneForEmoji != 999 ) {
		return selectingSkinToneForEmoji;
	} else {
		return origValue;
	}
}
%end

%hook UIKeyboardEmojiPreferences
- (int)hasDisplayedSkinToneHelp {
	int origValue = %orig;
	if ( enableTweak && selectingSkinToneForEmoji != 999 ) {
		return selectingSkinToneForEmoji;
	} else {
		return origValue;
	}
}
%end

%hook UIKeyboardLayoutStar
- (long long)currentHandBias {
	long long origValue = %orig;
	if ( enableTweak && oneHandedKeyboard != 999 ) {
		return oneHandedKeyboard;
	} else {
		return origValue;
	}
}
- (void)_setBiasEscapeButtonVisible:(int)arg1 {
	if ( enableTweak && oneHandedKeyboard != 999 ) {
		%orig(0);
	} else {
		%orig;
	}
}
%end

%hook UIInputSwitcherView
- (int)_isHandBiasSwitchVisible {
	int origValue = %orig;
	if ( enableTweak && oneHandedKeyboard != 999 ) {
		return 0;
	} else {
		return origValue;
	}
}
%end

%hook UIKBRenderFactory
- (int)useBlueThemingForKey:(id)arg1 {
	int origValue = %orig;
	if ( enableTweak && useBlueThemingForKey != 999 ) {
		return useBlueThemingForKey;
	} else {
		return origValue;
	}
}
%end

%ctor {
	if ( [ [ [ [NSProcessInfo processInfo] arguments] objectAtIndex:0] containsString:@"SpringBoard.app" ]
	||
	[ [ [ [NSProcessInfo processInfo] arguments] objectAtIndex:0] containsString:@"/Application" ] ) {
		SettingsChanged();
		CFNotificationCenterAddObserver(
			CFNotificationCenterGetDarwinNotifyCenter(),
			NULL,
			receivedNotification,
			CFSTR("com.tomaszpoliszuk.keyboardcontroller.settingschanged"),
			NULL,
			CFNotificationSuspensionBehaviorDeliverImmediately
		);
		%init;
	}
}
