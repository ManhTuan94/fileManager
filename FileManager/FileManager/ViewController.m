//
//  ViewController.m
//  FileManager
//
//  Created by TOM on 5/13/13.
//  Copyright (c) 2013 TOM. All rights reserved.
//

#import "ViewController.h"
#include <asl.h>
@interface ViewController ()
{
    NSString *textsDir;
    NSString *tempDir;
    NSString* copyDir;
    NSFileManager *fileManager;
    NSString* logs;
}
@property(strong,nonatomic) UITextView* log;
@end

@implementation ViewController
@synthesize log;
-(void) writeLog:(NSString*)logTexts{
    [logTexts writeToFile:logs atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fileManager = [[NSFileManager alloc] init];
    
	tempDir = NSTemporaryDirectory();
    textsDir = [tempDir stringByAppendingPathComponent:@"textsDir"];
    copyDir = [tempDir stringByAppendingPathComponent:@"copyDir"];
    logs = [tempDir stringByAppendingPathComponent:@"logs.txt"];

    NSError *error = nil;
    
    if([fileManager fileExistsAtPath:textsDir]){
        if ([fileManager removeItemAtPath:textsDir error:&error]){
            NSLog(@"Removed path %@", textsDir);
        }
    }
    if([fileManager fileExistsAtPath:copyDir]){
        if ([fileManager removeItemAtPath:copyDir error:&error]){
            NSLog(@"Removed path %@", copyDir);
        }
    }
    log = [[UITextView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height-300)];
    log.editable = NO;
    log.textColor = [UIColor whiteColor];
    log.backgroundColor = [UIColor blackColor];
   
    [self.view addSubview:log];

    log.text = [[NSString alloc] initWithContentsOfFile:logs encoding:NSUTF8StringEncoding error:nil];
    
    CGPoint bottomOffset = CGPointMake(0, log.contentSize.height - log.bounds.size.height);
    [log setContentOffset:bottomOffset animated:YES];
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateLogs) userInfo:nil repeats:YES];
}
//-(void)updateLogs{
//    log.text = [[NSString alloc] initWithContentsOfFile:logs encoding:NSUTF8StringEncoding error:nil];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}
- (IBAction)createFolder:(id)sender {
    
    NSError *error = nil;
    NSArray *checks= [fileManager contentsOfDirectoryAtPath:tempDir
                                                      error:&error];
    if(checks.count==0){
        NSError* error = nil;
        if ([fileManager createDirectoryAtPath:textsDir
               withIntermediateDirectories:YES attributes:nil
                                     error:&error]){
            NSLog(@"Successfully created textsDir folder");
        } else {
            NSLog(@"Failed to create the folder. Error = %@", error);
        }
        
        if ([fileManager createDirectoryAtPath:copyDir
                   withIntermediateDirectories:YES attributes:nil
                                         error:&error]){
            NSLog(@"Successfully created copyDir folder");
        } else {
            NSLog(@"Failed to create the folder. Error = %@", error);
        }

    }
    if (checks.count>0) {
        [self check:textsDir];
        [self check:copyDir];
    }
}
-(void) check:(NSString*)path{
    NSError* error = nil;
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"%@ folder doesn't exit",path);
    }else{
        if ([fileManager createDirectoryAtPath:path
                   withIntermediateDirectories:YES attributes:nil
                                         error:&error]){
            NSLog(@"Successfully created %@ folder",path);
        } else {
            NSLog(@"Failed to create %@ folder. Error = %@",path , error);
        }

    }

}
- (IBAction)createFiles:(id)sender {
        [self createFilesInFolder:textsDir];
   }
- (void) createFilesInFolder:(NSString *)paramPath{
    if([fileManager fileExistsAtPath:textsDir]){
    for (int counter = 0; counter < 5; counter++){
        NSString* files = [textsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.txt",counter+1]];
        if(![fileManager fileExistsAtPath:files]){
            if([fileManager createFileAtPath:files contents:nil attributes:nil]){
                NSLog(@"Created %i.txt",counter+1);
            }else{
                NSLog(@"%i.txt doesn't exit",counter+1);
            }
        }else{
            NSLog(@"%i.txt doesn't exit",counter+1);
        }

    }
    }else{
        NSLog(@"Not found %@",textsDir);
    }
}
- (IBAction)enumeratingFiles:(id)sender {
    NSError *error = nil;
    if([fileManager fileExistsAtPath:textsDir]){
        NSArray *bundleContents = [fileManager contentsOfDirectoryAtPath:textsDir
                                                                   error:&error];
        if (bundleContents.count > 0 && error == nil){
        NSLog(@"All files of the textsDir folder = %@", bundleContents); }
        if (bundleContents.count == 0 && error == nil){
        NSLog(@"This is empty folder");
        }
    }else{
        NSLog(@"Not found %@ ",textsDir);
    }
}

- (IBAction)copyFile:(id)sender {
    NSError *error = nil;
    if([fileManager fileExistsAtPath:textsDir]){
        NSArray *bundleContents = [fileManager contentsOfDirectoryAtPath:textsDir
                                                                   error:&error];
        if (bundleContents.count > 0 && error == nil){
            for (int i=0; i<bundleContents.count; i++) {
                NSString* fileTextsDir = [textsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bundleContents[i]]];
                NSString* fileCopyDir = [copyDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bundleContents[i]]];
                if([fileManager copyItemAtPath:fileTextsDir toPath:fileCopyDir error:&error]){
                    NSLog(@"Successfully copied %@ from textsDir to copyDir",fileTextsDir);
                }else{
                    NSLog(@"%@ doesn't exit",fileTextsDir);
                }
            }
        }else{
            NSLog(@"%@",error);
        }
        
        if (bundleContents.count == 0 && error == nil){
            NSLog(@"%@ is empty folder",textsDir);
        }
    }else{
        NSLog(@"Not found %@ ",textsDir);
    }
    
}

- (IBAction)deleteFile:(id)sender {
    NSError *error = nil;
    if([fileManager fileExistsAtPath:textsDir]){
        NSArray *bundleContents = [fileManager contentsOfDirectoryAtPath:textsDir
                                                                   error:&error];
        if (bundleContents.count > 0 && error == nil){
            for (int i=0; i<bundleContents.count; i++) {
                NSString* files = [textsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",bundleContents[i]]];
                if([fileManager removeItemAtPath:files error:&error]){
                    NSLog(@"Deleted %@",files);
                }
            }
        }else{
            NSLog(@"%@",error);
        }
           
        if (bundleContents.count == 0 && error == nil){
            NSLog(@"%@ is empty folder",textsDir);
        }
    }else{
        NSLog(@"Not found %@ ",textsDir);
    }

}


- (IBAction)deleteFolder:(id)sender {
    NSError* error = nil;
    if([fileManager fileExistsAtPath:textsDir]){
        if ([fileManager removeItemAtPath:textsDir error:&error]){
            NSLog(@"Deleted path %@", textsDir);
        }
    }else{
        NSLog(@"Not found %@",textsDir);
    }
    if([fileManager fileExistsAtPath:copyDir]){
        if ([fileManager removeItemAtPath:copyDir error:&error]){
            NSLog(@"Deleted path %@", copyDir);
        }
    }else{
        NSLog(@"Not found %@",copyDir);
    }

}
- (IBAction)crash:(id)sender {
    NSArray* array = [[NSArray alloc] initWithObjects:@"123", nil];
    NSNumber* num = array[1];
    NSLog(@"%@",num);
}

@end
