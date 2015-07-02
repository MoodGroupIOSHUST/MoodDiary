//
//  ChangeUserPicViewController.m
//  inteLook
//
//  Created by Sunc on 15-3-4.
//  Copyright (c) 2015年 whtysf. All rights reserved.
//

#import "ChangeUserPicViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SDImageCache.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"



@interface ChangeUserPicViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>

@property (nonatomic, strong) UIImageView *portraitImageView;

@end

@implementation ChangeUserPicViewController

@synthesize oldUserImg;

- (void)viewDidLoad
{
    self.title = @"修改头像";
    [super viewDidLoad];
    userInfo = [NSUserDefaults objectUserForKey:USER_STOKRN_KEY];
    [self.view addSubview:self.portraitImageView];
//    [self loadPortrait];
    [self initChangeBt];
    
}

- (void)saveuserpic:(UIImage *)myImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userpic"];   // 保存文件的名称
    [UIImagePNGRepresentation(myImage)writeToFile: filePath  atomically:YES];

}

//- (void)loadPortrait {
//
//    
//    if (userInfo.userpicname == nil) {
//        //默认头像
//        self.portraitImageView.image = [UIImage imageNamed:@"头像"];
//    }
//    else
//    {
//
//
//        [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"头像"]];
//
//    }
//
//}

-(void)updateNewsPic {
    self.portraitImageView.image = picImage;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view addSubview:changeBt];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [changeBt removeFromSuperview];
}

-(void)initChangeBt
{
     changeBt = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-self.portraitImageView.frame.size.width)/2, SCREEN_HEIGHT/2+ self.portraitImageView.frame.size.height*2/3, self.portraitImageView.frame.size.width, 40)];
    [changeBt setTitle:@"修改头像" forState:UIControlStateNormal];
    [changeBt setBackgroundImage:[UIImage imageNamed:@"green_bg"] forState:UIControlStateNormal];
    [changeBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeBt addTarget:self action:@selector(changeBtClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)changeBtClicked:(id)sender
{
    if (picImage == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择图像" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;

    }
    NSData *data = [[NSData alloc]init];
    
    if (UIImagePNGRepresentation(picImage) == nil) {
        
        data = UIImageJPEGRepresentation(picImage, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(picImage);
    }
   
//    NSString *filewholename=[NSString stringWithFormat:@"%@.png",@"userPic"];
    
    //test
        
//    [self.view showProgress:YES text:@"上传图像中..."];
//    [AppWebService submitFile:data FileName:filewholename success:^(id result) {
//        [self.view showProgress:NO];
//        
//        NSString* returnCode=[NSString stringWithFormat:@"%@",[result objectForKey:@"returncode"]];
//        if  ([returnCode isEqualToString:@"0"]) {
//            self.portraitImageView.image = picImage;
//            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"头像上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        
//    } failed:^(NSError *error) {
//        [self.view showProgress:NO];
//        NSString* errorStr=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
//        if ([errorStr isEqualToString:@"登录超时"]) {
//            
//            [NSUserDefaults setBool:NO forKey:IS_LOGIN];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录超时,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil,nil];
//            alert.tag=400;
//            [alert show];
//        }else
//        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errorStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil,nil];
//            [alert show];
//            
//        }
//        
//    }];
   
}



-(NSString *)removeLastStr:(NSString *)picname
{
    NSString * fileName;//文件名
    NSRange range = [picname rangeOfString:@"." options:NSBackwardsSearch];
    if (range.length>0)
    {
        fileName=[picname substringToIndex:NSMaxRange(range)];
    }
    return fileName;
}

-(void)changeuserpicname:(NSString *)userpicname
{
    
}


- (void)editPortrait {
        if (IS_IOS_7) {
            
            UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
            UIAlertAction* ok=[UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                [self useCamera];
            }];
            UIAlertAction* ok1=[UIAlertAction actionWithTitle:@"从相册中选取" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                [self userPhotoLibrary];
            }];
            UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
            
            [alertVc addAction:ok];
            [alertVc addAction:ok1];
            [alertVc addAction:no];
            [self presentViewController:alertVc animated:YES completion:nil];    }else
    {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self.view];
    
    }
  
}

-(void)useCamera
{
    // 拍照
    
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
    
    
}
-(void)userPhotoLibrary
{
    // 从相册中选取
    
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
    
    
    
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //这里得到的就是剪裁后的头像editedImage
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
    
    //
    picImage = editedImage;
    [self updateNewsPic];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==400) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_TO_CONTROLLER object:nil];
    }
    
}


- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        [self useCamera];
    } else if (buttonIndex == 1) {
        // 从相册中选取
        [self userPhotoLibrary];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        CGFloat w = 200.0f; CGFloat h = w;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = (self.view.frame.size.height - h) / 2;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
        _portraitImageView.layer.shadowRadius = 2.0;
        _portraitImageView.layer.borderColor = [UIColor colorWithRed:52/255.0 green:184/255.0 blue:111/255.0 alpha:1.0].CGColor;
        _portraitImageView.layer.borderWidth = 2.0f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
