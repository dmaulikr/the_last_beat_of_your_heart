//
//  AppDelegate.h
//  UDP_Test
//
//  Created by Phoenix Perry on 12/24/15.
//  Copyright © 2015 Phoenix Perry. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncUdpSocket.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, GCDAsyncUdpSocketDelegate>
{
    long tag;
    GCDAsyncUdpSocket *udpSocket;
    
    BOOL isRunning;
    
    
}

//sender properties ø
@property (unsafe_unretained) IBOutlet NSWindow *window;
@property IBOutlet NSTextField *addrField;
@property IBOutlet NSTextField *portField;
@property IBOutlet NSTextField *messageField;

@property IBOutlet NSButton *sendButton;
@property IBOutlet NSTextView *logView;

//receiver properties
@property IBOutlet NSTextView *recieverLogView;
@property IBOutlet NSButton *startStopButton;
@property IBOutlet NSTextField *receiverPortField;

//sender events
-(IBAction)send:(id)sender;

//------------------------
//server events
-(IBAction)startStopButtonPressed:(id)sender;

@end

