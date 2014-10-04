//
//  ServerInterface.h
//  CrowdDJ
//
//  Created by Marko Vojvodic on 10/4/14.
//  Copyright (c) 2014 Marko Vojvodic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

extern NSString *const DJErrorDomain;

typedef NS_ENUM(NSInteger, DJError) {
    DJBadAuthError,
    DJErrorInvalidArgument,
    DJErrorInvalidURL,
    DJErrorUnexpectedResponse,
};

@interface ServerInterface : NSObject
{
    NSString * _djId;
    NSString * _soundcloudClientId;
    NSString * _soundcloudClientSecret;
    
    AFHTTPRequestOperationManager * _manager;
}

+ (instancetype) serverInterface;

- (NSString *) get_djId;
- (void) set_djId:(NSString *) newDjId;
- (NSString *) get_soundcloudClientId;
- (NSString *) get_soundcloudClientSecret;

#pragma mark - DJ API endpoints
/*
 POST /api/dj
 body: { dj_id : <> }
 response: { message : success }
 */
- (void) createDjWithDjId:(NSString *) djId
                  success:(void (^)()) success
                  failure:(void (^)(NSError *)) failure;

/*
 GET /api/dj
 body: { dj_id : <>, options : { potential dictionary } }
 response: { tracks : tracks }
 */
- (void) retrieveDjWithOptions:(NSDictionary *) options
                       success:(void (^)(NSArray *)) success
                       failure:(void (^)(NSError *)) failure;

/*
 DELETE /api/dj
 body: { dj_id : <>, track_id : <> }
 response: { message : success }
 */
- (void) deleteTrackWithTrackId:(NSString *) trackId
                        success:(void (^)()) success
                        failure:(void (^)(NSError *)) failure;

/*
 DELETE /api/dj
 body: { dj_id : <> }
 response: { message : success }
 */
- (void) deleteDjOnSuccess:(void (^)()) success
                   failure:(void (^)(NSError *)) failure;

#pragma mark - Tracks API endpoint
/*
 POST /api/tracks
 body: { dj_id : <>, url : <> }
 response: { message : success }
 */
- (void) createTrackWithUrl:(NSString *) url
                    success:(void (^)()) success
                    failure:(void (^)(NSError *)) failure;

/*
 GET /api/tracks
 body: { dj_id : <> }
 response: { tracks : tracks }
 */
- (void) retrieveTracksOnSuccess:(void (^)(NSArray *)) success
                         failure:(void (^)(NSError *)) failure;

/*
 PUT /api/tracks
 body: { dj_id : <>, track_id : <> }
 response: { message : success }
 */
- (void) updateTrackWithTrackId:(NSString *) trackId
                        success:(void (^)()) success
                        failure:(void (^)(NSError *)) failure;


@end
