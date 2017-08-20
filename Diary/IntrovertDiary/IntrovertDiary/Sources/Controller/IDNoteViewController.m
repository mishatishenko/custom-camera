//
//  IDNoteViewController.m
//  IntrovertDiary
//
//  Created by Www Www on 8/20/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

#import "IDNoteViewController.h"
#import "IDNote.h"
#import "IDNoteStorage.h"
#import "NSDateAdditions.h"
#import <Photos/Photos.h>

@interface IDNoteViewController () <UIImagePickerControllerDelegate,
			UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) IBOutlet UIButton *changePictureButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;

@property (nonatomic) BOOL editMode;

@property (nonatomic, strong) IDNote *note;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *image;

@end

@implementation IDNoteViewController

+ (UINavigationController *)noteControllerWithNote:(IDNote *)note;
{
	UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"Main"
				bundle:[NSBundle mainBundle]]
				instantiateViewControllerWithIdentifier:@"noteEditNavigationController"];
	IDNoteViewController *controller = (IDNoteViewController *)
				navigationController.topViewController;
	controller.note = note;
	
	return navigationController;
}

+ (UINavigationController *)createNoteController
{
	UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"Main"
				bundle:[NSBundle mainBundle]]
				instantiateViewControllerWithIdentifier:@"noteEditNavigationController"];
	IDNoteViewController *controller = (IDNoteViewController *)
				navigationController.topViewController;
	controller.note = [IDNote new];
	controller.editMode = YES;
	
	return navigationController;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"cToday", @"");
	
	self.imageWidthConstraint.constant =
				CGRectGetWidth(self.navigationController.view.frame) - 32;
	
	self.imageView.image = self.note.picture;
	self.image = self.note.picture;
	
	self.dateLabel.text = [self.note.creationDate localizableDate];
	self.text = self.note.text;
	
	self.noteTextView.text = nil != self.note.text ? self.note.text :
				NSLocalizedString(@"cTellAboutYourDay", @"");
	
	[self turnEditMode:self.editMode];
	
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	cancelButton.backgroundColor = [UIColor clearColor];
	[cancelButton setImage:[UIImage imageNamed:@"close"]
				forState:UIControlStateNormal];
	[cancelButton sizeToFit];
	[cancelButton addTarget:self action:@selector(cancelEditing)
				forControlEvents:UIControlEventTouchUpInside];
	cancelButton.exclusiveTouch = YES;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
				initWithCustomView:cancelButton];
	
	UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	deleteButton.backgroundColor = [UIColor clearColor];
	[deleteButton setImage:[UIImage imageNamed:@"delete"]
				forState:UIControlStateNormal];
	[deleteButton sizeToFit];
	[deleteButton addTarget:self action:@selector(showDeleteNoteConfirmation)
				forControlEvents:UIControlEventTouchUpInside];
	deleteButton.exclusiveTouch = YES;
	
	UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
	shareButton.backgroundColor = [UIColor clearColor];
	[shareButton setImage:[UIImage imageNamed:@"share"]
				forState:UIControlStateNormal];
	[shareButton sizeToFit];
	[shareButton addTarget:self action:@selector(shareNote)
				forControlEvents:UIControlEventTouchUpInside];
	shareButton.exclusiveTouch = YES;
	
	self.toolbarItems = @[[[UIBarButtonItem alloc] initWithCustomView:deleteButton],
				[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
				UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
				[[UIBarButtonItem alloc] initWithCustomView:shareButton]];
}

- (void)turnEditMode:(BOOL)enableEditMode
{
	self.editMode = enableEditMode;
	
	self.changePictureButton.userInteractionEnabled = enableEditMode;
	self.changePictureButton.hidden = !enableEditMode && nil != self.image;
	self.noteTextView.userInteractionEnabled = enableEditMode;
	
	[self.navigationController setToolbarHidden:enableEditMode animated:YES];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = [UIColor clearColor];
	[button setImage:[UIImage imageNamed:enableEditMode ? @"done" : @"edit"]
				forState:UIControlStateNormal];
	[button sizeToFit];
	[button addTarget:self action:enableEditMode ? @selector(doneEditing) :
				@selector(enableEditMode)
				forControlEvents:UIControlEventTouchUpInside];
	button.exclusiveTouch = YES;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
				initWithCustomView:button];
}

- (void)cancelEditing
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneEditing
{
	[self turnEditMode:NO];
	
	BOOL noteIsEdited = NO;
	if (![self.image isEqual:self.note.picture])
	{
		noteIsEdited = YES;
		self.note.picture = self.image;
	}
	if (![self.note.text isEqualToString:self.text])
	{
		noteIsEdited = YES;
		self.note.text = self.text;
	}
	
	if (noteIsEdited)
	{
		[[IDNoteStorage sharedStorage] saveNote:self.note];
	}
}

- (void)enableEditMode
{
	[self turnEditMode:YES];
}

- (void)showDeleteNoteConfirmation
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:
				NSLocalizedString(@"cAttention", @"") message:
				NSLocalizedString(@"cDeleteConfirmation", @"")
				preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:
				NSLocalizedString(@"cCancel", @"") style:UIAlertActionStyleDefault
				handler:nil]];
	
	[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cOk", @"")
				style:UIAlertActionStyleDefault handler:
	^(UIAlertAction * _Nonnull action)
	{
		[self deleteNote];
	}]];
	
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteNote
{
	[[IDNoteStorage sharedStorage] removeNote:self.note];
}

- (void)shareNote
{

}

- (IBAction)changePicture:(UIButton *)sender
{
	[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
	{
		if (status == PHAuthorizationStatusAuthorized)
		{
			UIImagePickerController *picker = [UIImagePickerController new];
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			picker.delegate = self;
			[self presentViewController:picker animated:YES completion:nil];
		}
		else
		{
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:
						NSLocalizedString(@"cError", @"") message:
						NSLocalizedString(@"cNoAccessToPhotos", @"")
						preferredStyle:UIAlertControllerStyleAlert];
			
			[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"cOk", @"")
						style:UIAlertActionStyleDefault handler:nil]];
			
			[self presentViewController:alert animated:YES completion:nil];
		}
	}];
}

#pragma mark - UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker
			didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
	if (nil != info[UIImagePickerControllerOriginalImage])
	{
		self.image = info[UIImagePickerControllerOriginalImage];
		self.imageView.image = self.image;
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
