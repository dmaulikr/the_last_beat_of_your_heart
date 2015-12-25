//
//  AppDelegate.m
//  UDP_Test
//
//  Created by Phoenix Perry on 12/24/15.
//  Copyright © 2015 Phoenix Perry. All rights reserved.
//

#import "AppDelegate.h"
#import "GCDAsyncUdpSocket.h"

#define FORMAT(format, ...)[NSString stringWithFormat:(format), ##_VA_ARGS__]

@interface AppDelegate ()
@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Insert code here to initialize your application
    
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error = nil;
    
    if(![udpSocket bindToPort:0 error:&error])
    {
        NSString* str=(@"Error binding: %@", error);
        [_logView insertText:str];
        return;
    }
    if(![udpSocket beginReceiving:&error]){
        [_logView insertText:(@"Error receiving: %@", error)];
        return;
    }
    [_logView insertText:(@"Ready")];
}
-(void)scrollToBottom{
    NSScrollView *scrollView = [_logView enclosingScrollView];
    NSPoint newScrollOrigin;
    
    if([[scrollView documentView] isFlipped])
        newScrollOrigin = NSMakePoint(0.0F, NSMaxY([[scrollView documentView] frame]));
    else
        newScrollOrigin= NSMakePoint(0.0F, 0.0F); 
}

-(void)logError:(NSString*)msg{
    NSString *paragraph = [NSString stringWithFormat:@"%@\n",msg];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [attributes setObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
    
    NSAttributedString *as = [[NSAttributedString alloc]initWithString:paragraph attributes:attributes];
    
    [[_logView textStorage]appendAttributedString:as];
    [self scrollToBottom];
}
-(void)logMessage:(NSString *)msg{
    NSString *paragraph = [NSString stringWithFormat:@"%@\n", msg];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    NSAttributedString *as = [[NSAttributedString alloc]initWithString:paragraph attributes:attributes];
    [[_logView textStorage]appendAttributedString:as];
    [self scrollToBottom];
}

-(IBAction) send:(id)sender{
    NSString *host = [_addrField stringValue];
    if([host length]==0)
    {
        [self logError:@"Address Required"];
        return;
    }
    int port = [_portField intValue];
    if(port <=0 || port > 65535)
    {
        [self logError:@"Valid port required"];
        return;
    }
    NSString *msg = [_messageField stringValue];
    if([msg length]==0)
    {
        [self logError:@"Mesaage required"];
        return;
    }
   
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    NSString *temp = [NSString stringWithFormat:@"SENT (%i): %@", (int)tag, msg];
    [self logError:temp];
    
    tag++;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    // You could add checks here
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(msg); 
    if(msg)
    {
        NSString *temp =[NSString stringWithFormat:@"RECV: %@",msg];
        [self logMessage:temp];
    }
    else
    {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        NSString *temp =[NSString stringWithFormat:@"RECV: Unknown message from: %@:%hu",msg];
        [self logMessage:temp];
    }
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

GCDAsyncUdpSocket *udpSocket ; // create this first part as a global variable

@end
