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
    
    DJPathPutTrack,
    
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
        case DJPathPutTrack:           return @"/api/tracks";
            
        default:                        return nil;
    }
}

- (NSString *) methodForDJPath:(DJPath)path {
    switch(path){
        case DJPathPostDj:
        case DJPathPostTrack:       return @"POST";
            
        case DJPathGetDj:
        case DJPathGetTracks:       return @"GET";
            
        case DJPathPutTrack:       return @"PUT";
            
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
                    success:(void (^)(NSDictionary * dict)) success
                    failure:(void (^)(NSError * err)) failure
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
        failure([NSError errorWithDomain:DJErrorDomain
                                    code:DJErrorUnexpectedResponse
                                userInfo:nil]);
    
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
                                          if(!_.isDictionary(responseObject)){
                                              NSLog(@"Failure in AFHTTPRequestOperation responseObject");
                                              failure([NSError errorWithDomain:DJErrorDomain
                                                                          code:DJErrorUnexpectedResponse
                                                                      userInfo:nil]);
                                          }
                                          else{
                                              NSLog(@"Success in AFHTTPRequestOperation");
                                              success(responseObject);
                                          }
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
                  failure:(void (^)(NSError * err)) failure
{
    if(!djId)
        djId = @"";
    
    if(!success)
        success = ^(){};
    
    if(!failure)
        failure = ^(NSError * err){};
    
    NSDictionary * params = @{
                              @"dj_id" : djId
                              };
    
    [self sendRequestForPath:DJPathPostDj
                  withParams:params
                     success:^(NSDictionary * dict){
                         id message = [dict objectForKey:@"message"];
                         
                         if(message){
                             _djId = djId;
                             success();
                         }
                         else
                             failure([NSError errorWithDomain:DJErrorDomain
                                                         code:DJErrorUnexpectedResponse
                                                     userInfo:nil]);
                     }
                     failure:failure
     ];
}

/*
 GET /api/dj
 body: { dj_id : <>, options : { potential dictionary } }
 response: { tracks : tracks }
 */
- (void) retrieveDjWithOptions:(NSDictionary *) options
                       success:(void (^)(NSArray * tracks)) success
                       failure:(void (^)(NSError * err)) failure
{
    if(!options)
        options = ^(NSDictionary * dict){};
    
    if(!success)
        success = ^(NSArray * arr){};
    
    if(!failure)
        failure = ^(NSError * err){};
    
    NSDictionary * params = @{
                              @"dj_id":_djId,
                              @"options":options
                              };

    [self sendRequestForPath:DJPathGetDj
                  withParams:params
                     success:^(NSDictionary * dict){
                         if(!_.isDictionary(dict)){
                             NSLog(@"%@", dict);
                             failure([NSError errorWithDomain:DJErrorDomain
                                                         code:DJErrorUnexpectedResponse
                                                     userInfo:nil]);
                         }
                         else{
                             NSArray * tracks = [dict objectForKey:@"tracks"];
                             success(tracks);
                         }
                     }
                     failure:failure
     ];
}

/*
 DELETE /api/dj
 body: { dj_id : <>, track_id : <> }
 response: { message : success }
 */
- (void) deleteTrackWithTrackId:(NSString *) trackId
                        success:(void (^)()) success
                        failure:(void (^)(NSError * err)) failure
{
    if(!trackId)
        trackId = @"";
    
    if(!success)
        success = ^(){};
    
    if(!failure)
        failure = ^(NSError * err){};
    
    NSDictionary * params = @{
                              @"dj_id":_djId,
                              @"track_id":trackId
                              };
    
    [self sendRequestForPath:DJPathDeleteTrack
                  withParams:params
                     success:^(NSDictionary * dict){
                         id message = [dict objectForKey:@"message"];
                         
                         if(message)
                             success();
                         else
                             failure([NSError errorWithDomain:DJErrorDomain
                                                         code:DJErrorUnexpectedResponse
                                                     userInfo:nil]);
                     }
                     failure:failure
     ];
}

/*
 DELETE /api/dj
 body: { dj_id : <> }
 response: { message : success }
 */
- (void) deleteDjOnSuccess:(void (^)()) success
                   failure:(void (^)(NSError * err)) failure
{
    if(!success)
        success = ^(){};
    
    if(!failure)
        failure = ^(NSError * err){};
    
    NSDictionary * params = @{
                              @"dj_id":_djId
                              };
    
    [self sendRequestForPath:DJPathDeleteDj
                  withParams:params
                     success:^(NSDictionary * dict){
                         id message = [dict objectForKey:@"message"];
                         
                         if(message)
                             success();
                         else
                             failure([NSError errorWithDomain:DJErrorDomain
                                                         code:DJErrorUnexpectedResponse
                                                     userInfo:nil]);
                     }
                     failure:failure
     ];
}

#pragma mark - Tracks API endpoint
/*
 POST /api/tracks
 body: { dj_id : <>, track : {} }
 response: { message : success }
 */
- (void) createTrackWithTrack:(NSDictionary *) track
                      success:(void (^)()) success
                      failure:(void (^)(NSError * err)) failure
{
    if(!track)
        track = @{};
    
    if(!success)
        success = ^(){};
    
    if(!failure)
        failure = ^(NSError * err){};
    
    NSDictionary * params = @{
                              @"dj_id":_djId,
                              @"track":track
                              };
    
    [self sendRequestForPath:DJPathPostTrack
                  withParams:params
                     success:^(NSDictionary * dict){
                         id message = [dict objectForKey:@"message"];
                         
                         if(message)
                             success();
                         else
                             failure([NSError errorWithDomain:DJErrorDomain
                                                         code:DJErrorUnexpectedResponse
                                                     userInfo:nil]);
                     }
                     failure:failure
     ];
}

/*
 GET /api/tracks
 body: { dj_id : <> }
 response: { tracks : tracks }
 */
- (void) retrieveTracksOnSuccess:(void (^)(NSArray * tracks)) success
                         failure:(void (^)(NSError * err)) failure
{
    if(!success)
        success = ^(NSArray * arr){};
    
    if(!failure)
        failure = ^(NSError * err){};
    
    NSDictionary * params = @{
                              @"dj_id":_djId
                              };
    
    [self sendRequestForPath:DJPathGetTracks
                  withParams:params
                     success:^(NSDictionary * dict){
                         if(!_.isDictionary(dict)){
                             NSLog(@"%@", dict);
                             failure([NSError errorWithDomain:DJErrorDomain
                                                         code:DJErrorUnexpectedResponse
                                                     userInfo:nil]);
                         }
                         else{
                             NSArray * tracks = [dict objectForKey:@"tracks"];
                             success(tracks);
                         }
                     }
                     failure:failure
     ];
}

/*
 PUT /api/tracks
 body: { dj_id : <>, track_id : <> }
 response: { message : success }
 */
- (void) updateTrackWithTrackId:(NSString *) trackId
                        success:(void (^)()) success
                        failure:(void (^)(NSError * err)) failure
{
    if(!trackId)
        trackId = @"";
    
    if(!success)
        success = ^(){};
    
    if(!failure)
        failure = ^(NSError * err){};
    
    NSDictionary * params = @{
                              @"dj_id":_djId,
                              @"track_id":trackId
                              };
    
    [self sendRequestForPath:DJPathPutTrack
                  withParams:params
                     success:^(NSDictionary * dict){
                         id message = [dict objectForKey:@"message"];
                         
                         if(message)
                             success();
                         else
                             failure([NSError errorWithDomain:DJErrorDomain
                                                         code:DJErrorUnexpectedResponse
                                                     userInfo:nil]);
                     }
                     failure:failure
     ];
}

@end
