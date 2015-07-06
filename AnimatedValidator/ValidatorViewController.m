//
//  ValidatorViewController.m
//  AnimatedValidator
//
//  Created by Al Tyus on 5/12/14.
//  Copyright (c) 2014 al-tyus.com. All rights reserved.
//

#import "ValidatorViewController.h"
#import "Constants.h"

@interface ValidatorViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailConfirmTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitButtonTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmEmailHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmEmailWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPasswordWidthConstraint;

@end

@implementation ValidatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.submitButton.layer.cornerRadius = 8;
    
    self.submitButton.accessibilityLabel = SUBMITBUTTON;
    self.emailTextField.accessibilityLabel = EMAILTEXTFIELD;
    self.emailConfirmTextField.accessibilityLabel = EMAILCONFIRMTEXTFIELD;
    self.phoneTextField.accessibilityLabel = PHONETEXTFIELD;
    self.passwordTextField.accessibilityLabel = PASSWORDTEXTFIELD;
    self.passwordConfirmTextField.accessibilityLabel = PASSWORDCONFIRMTEXTFIELD;
    
    self.emailTextField.delegate = self;
    self.emailConfirmTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.passwordConfirmTextField.delegate = self;
}

- (IBAction)emailTextFieldChanged:(id)sender
{
    if ([self checkValidEmail:self.emailTextField]) {
        self.emailConfirmTextField.text = @"";
        self.emailConfirmTextField.enabled = YES;
        self.phoneTextField.enabled = NO;
        self.passwordTextField.enabled = NO;
        self.passwordConfirmTextField.enabled = NO;
    } else {
        self.emailConfirmTextField.enabled = NO;
    }
}

- (IBAction)confirmEmailExtFieldChanged:(id)sender
{
    if ([self.emailConfirmTextField.text isEqualToString:self.emailTextField.text]) {
        self.phoneTextField.enabled = YES;
        self.passwordTextField.enabled = NO;
        self.passwordConfirmTextField.enabled = NO;
    } else {
        self.phoneTextField.enabled = NO;
    }
}

- (IBAction)phoneTextFieldChanged:(id)sender
{
    if ([self checkValidPhoneNumber:self.phoneTextField]) {
        self.passwordTextField.enabled = YES;
        self.passwordConfirmTextField.enabled = NO;
    } else {
        self.passwordTextField.enabled = NO;
    }
}

- (IBAction)passwordTextFieldChanged:(id)sender
{
    if (self.passwordTextField.text.length >= 6) {
        self.passwordConfirmTextField.text = @"";
        self.passwordConfirmTextField.enabled = YES;
    } else {
        self.passwordConfirmTextField.enabled = NO;
    }
}

- (IBAction)confirmPasswordTextFieldChanged:(id)sender
{
    if ([self.passwordConfirmTextField.text isEqualToString:self.passwordTextField.text]) {
        self.submitButton.userInteractionEnabled = YES;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self textFieldShouldReturn:textField]) {
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.placeholder isEqualToString:@"email"]) {
        if ([self checkValidEmail:textField]) {
            [self.emailConfirmTextField becomeFirstResponder];
            
            return YES;
        } else {
            [self pulseAnimationWithTextField:textField
                             HeightConstraint:self.emailHeightConstraint
                              widthConstraint:self.emailWidthConstraint];
        }
    } else if ([textField.placeholder isEqualToString:@"confirm email"]) {
        if ([textField.text isEqualToString:self.emailTextField.text]) {
            [self.phoneTextField becomeFirstResponder];
            
            return YES;
        } else {
            [self pulseAnimationWithTextField:textField
                             HeightConstraint:self.confirmEmailHeightConstraint
                              widthConstraint:self.confirmEmailWidthConstraint];
        }
    } else if ([textField.placeholder isEqualToString:@"phone"]) {
        if ([self checkValidPhoneNumber:textField]) {

            [self.passwordTextField becomeFirstResponder];
            
            return YES;
        } else {
            [self pulseAnimationWithTextField:textField
                             HeightConstraint:self.phoneHeightConstraint
                              widthConstraint:self.phoneWidthConstraint];
        }
    } else if ([textField.placeholder isEqualToString:@"password"]) {
        if (textField.text.length >= 6) {
            [self.passwordConfirmTextField becomeFirstResponder];
            
            return YES;
        } else {
            [self pulseAnimationWithTextField:textField
                             HeightConstraint:self.passwordHeightConstraint
                              widthConstraint:self.passwordWidthConstraint];
        }
    } else if ([textField.placeholder isEqualToString:@"confirm password"]) {
        if ([textField.text isEqualToString:self.passwordTextField.text]) {
            
            // bring in the submit button
            
            [UIView animateWithDuration:0.6
                                  delay:0
                 usingSpringWithDamping:0.75
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.submitButtonTopConstraint.constant = 209;
                                 [self.view layoutIfNeeded];
                             }
                             completion:nil];
            
            [textField resignFirstResponder];
            
            return YES;
        } else {
            [self pulseAnimationWithTextField:textField
                             HeightConstraint:self.confirmPasswordHeightConstraint
                              widthConstraint:self.confirmPasswordWidthConstraint];
        }
    }
    
    return NO;
}

- (void)pulseAnimationWithTextField:(UITextField *)textField
                   HeightConstraint:(NSLayoutConstraint *)heightConstraint
                    widthConstraint:(NSLayoutConstraint *)widthConstraint
{
    [UIView animateKeyframesWithDuration:0.4
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionBeginFromCurrentState
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    textField.backgroundColor = [UIColor redColor];
                                                                    widthConstraint.constant = 5;
                                                                    heightConstraint.constant = 32;
                                                                    [self.view layoutIfNeeded];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    textField.backgroundColor = [UIColor whiteColor];
                                                                    widthConstraint.constant = 0;
                                                                    heightConstraint.constant = 30;
                                                                    [self.view layoutIfNeeded];
                                                                }];
                              }
                              completion:nil];
}

- (BOOL)checkValidPhoneNumber:(UITextField *)textField
{
    if (textField.text.length > 6) {
        NSString *firstChar = [textField.text substringToIndex:1];
        NSLog(@"first character: %@", firstChar);
        
        if ([firstChar isEqualToString:@"+"]) {
            NSString *remainingString = [textField.text substringFromIndex:1];
            NSLog(@"remaining string: %@", remainingString);
            
            return [self isValidNumber:remainingString];
        } else {
            return [self isValidNumber:textField.text];
        }
    }
    
    return NO;
}

- (BOOL)isValidNumber:(NSString *)phoneNumber
{
    NSCharacterSet *nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange nonNumbersRange = [phoneNumber rangeOfCharacterFromSet:nonNumbers];
    if (phoneNumber.length >= 7 && nonNumbersRange.location == NSNotFound) {
        NSLog(@"Valid phone number");
        return YES;
    }
    
    return NO;
}

- (BOOL)checkValidEmail:(UITextField *)textField
{
    if (textField.text.length > 0)
    {
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if ([emailTest evaluateWithObject:textField.text] == YES)
        {
            NSLog(@"Valid email");
            return YES;
        }
    }
    return NO;
}


@end