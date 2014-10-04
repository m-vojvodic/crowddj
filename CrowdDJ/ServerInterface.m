//
//  ServerInterface.m
//  CrowdDJ
//
//  Created by Marko Vojvodic on 10/4/14.
//  Copyright (c) 2014 Marko Vojvodic. All rights reserved.
//

#import "ServerInterface.h"

@implementation ServerInterface

NSString *const DJErrorDomain = @"DJErrorDomain";
NSString *const DJServerRoot  = @"http://localhost:3000";

typedef NS_ENUM(NSInteger, DJPath) {
    DJPathPostDj,
    DJPathPostTrack,
    
    DJPathGetDj,
    DJPathGetTracks,
    
    DJPathPutTracks,
    
    DJPathDeleteTrack,
    DJPathDeleteDj
};

- (NSString *) pathForDJPath:(DJPath)path {
    switch(path){
        case DJPathPostDj:
        case DJPathGetDj:
        case DJPathDeleteTrack:
        case DJPathDeleteDj:            return @"/api/dj";
            
        case DJPathPostTrack:
        case DJPathGetTracks:
        case DJPathPutTracks:           return @"/api/tracks";
            
        default:                        return nil;
    }
}

- (NSString *) methodForDJPath:(DJPath)path {
    switch(path){
        case DJPathPostDj:
        case DJPathPostTrack:       return @"POST";
            
        case DJPathGetDj:
        case DJPathGetTracks:       return @"GET";
            
        case DJPathPutTracks:       return @"PUT";
            
        case DJPathDeleteTrack:
        case DJPathDeleteDj:        return @"DELETE";
            
        default:                    return nil;
    }
}

#pragma mark - initialization

- (instancetype) init {
    if(self = [super init]) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        _soundcloudClientId = @"d36d7236a3819da854cc2a32cf21b6a8";
        _soundcloudClientSecret = @"a7e8e866389ee155c72bfeecb2a7fa5a";
    }
    
    return self;
}

+ (instancetype) serverInterface
{
    static ServerInterface *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (NSString *) get_djId
{
    return _djId;
}

- (void) set_djId:(NSString *) newDjId
{
    _djId = newDjId;
}

- (NSString *) get_soundcloudClientId
{
    return _soundcloudClientId;
}

- (NSString *) get_soundcloudClientSecret
{
    return _soundcloudClientSecret;
}

#pragma mark - request serialization
- (void) sendRequestForPath:(DJPath)path
                 withParams:(NSDictionary *) params
                    success:(void (^)(NSDictionary *)) success
                    failure:(void (^)(NSError *)) failure
{
    if(!success)
        success = ^(NSDictionary * dict){};
    
    if(!failure)
        failure = ^(NSError * err){};
    
    // create url
    NSURL * url = [[NSURL URLWithString:DJServerRoot] URLByAppendingPathComponent:[self pathForDJPath:path]];
    NSLog(@"URL is: %@", url);
    
    // create method
    NSString * method = [self methodForDJPath:path];
    if(!method)
        failure([NSError errorWithDomain:DJErrorDomain code:DJErrorUnexpectedResponse userInfo:nil]);
    
    // create request
    NSMutableURLRequest * request = [_manager.requestSerializer requestWithMethod:method
                                                                        URLString:[url absoluteString]
                                                                       parameters:params
                                                                            error:nil
                                     ];
    // create operation
    AFHTTPRequestOperation * op =
    [_manager HTTPRequestOperationWithRequest:request
                                      success:^(AFHTTPRequestOperation *operation, id responseObject){
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation , NSError *error){
                                          NSLog(@"Failure in AFHTTPRequestOperation");
                                          failure(error);
                                      }
     ];
    
    // start operation
    [op start];
}

#pragma mark - DJ API endpoints
/*
 POST /api/dj
 body: { dj_id : <> }
 response: { message : success }
 */
- (void) createDjWithDjId:(NSString *) djId
                  success:(void (^)()) success
                  failure:(void (^)(NSError *)) failure
{
    
}

/*
 GET /api/dj
 body: { dj_id : <>, options : { potential dictionary } }
 response: { tracks : tracks }
 */
- (void) retrieveDjWithOptions:(NSDictionary *) options
                       success:(void (^)(NSArray *)) success
                       failure:(void (^)(NSError *)) failure
{
    
}

/*
 DELETE /api/dj
 body: { dj_id : <>, track_id : <> }
 response: { message : success }
 */
- (void) deleteTrackWithTrackId:(NSString *) trackId
                        success:(void (^)()) success
                        failure:(void (^)(NSError *)) failure
{
    
}

/*
 DELETE /api/dj
 body: { dj_id : <> }
 response: { message : success }
 */
- (void) deleteDjOnSuccess:(void (^)()) success
                   failure:(void (^)(NSError *)) failure
{
    
}

#pragma mark - Tracks API endpoint
/*
 POST /api/tracks
 body: { dj_id : <>, url : <> }
 response: { message : success }
 */
- (void) createTrackWithUrl:(NSString *) url
                    success:(void (^)()) success
                    failure:(void (^)(NSError *)) failure
{
    
}

/*
 GET /api/tracks
 body: { dj_id : <> }
 response: { tracks : tracks }
 */
- (void) retrieveTracksOnSuccess:(void (^)(NSArray *)) success
                         failure:(void (^)(NSError *)) failure
{
    
}

/*
 PUT /api/tracks
 body: { dj_id : <>, track_id : <> }
 response: { message : success }
 */
- (void) updateTrackWithTrackId:(NSString *) trackId
                        success:(void (^)()) success
                        failure:(void (^)(NSError *)) failure
{
    
}

@end
