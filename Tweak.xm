// Thank you andrewwiik

%group Widget
%hook UILabel
- (void)setTextColor:(UIColor *)textColor {
    %orig([UIColor whiteColor]);
}
- (UIColor *)textColor {
    return [UIColor whiteColor]; //%orig;

}
- (void)setColor:(UIColor *)color {
    %orig([UIColor whiteColor]);
}
%end

%hook CALayer
- (void)setCompositingFilter:(NSString *)filter {
}
- (void)setContentsMultiplyColor:(CGColorRef)contentsMultiplyColor {
    if(contentsMultiplyColor == [UIColor blackColor].CGColor) %orig([UIColor whiteColor].CGColor);
    else %orig;
}
-(CGColor *)contentsMultiplyColor{
    if(%orig == [UIColor blackColor].CGColor) return [UIColor whiteColor].CGColor;
    else return %orig;
}

%end
%end

%ctor{
    BOOL shouldLoadWidgetHooks = NO;
    %init;
    
    if ([(NSDictionary *)[NSBundle mainBundle].infoDictionary valueForKey:@"NSExtension"]) {
        if ([[(NSDictionary *)[NSBundle mainBundle].infoDictionary valueForKey:@"NSExtension"] valueForKey:@"NSExtensionPointIdentifier"]) {
            if ([[[(NSDictionary *)[NSBundle mainBundle].infoDictionary valueForKey:@"NSExtension"] valueForKey:@"NSExtensionPointIdentifier"] isEqualToString:[NSString stringWithFormat:@"com.apple.widget-extension"]]) {
                shouldLoadWidgetHooks = YES;
            }
        }
    }
    if (shouldLoadWidgetHooks) {
        %init(Widget);
    }
}
