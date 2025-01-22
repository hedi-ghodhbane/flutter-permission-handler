- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"checkPermissionStatus" isEqualToString:call.method]) {
        PermissionGroup permission = [Codec decodePermissionGroupFrom:call.arguments];
        [PermissionManager checkPermissionStatus:permission result:result];
    } else if ([@"checkServiceStatus" isEqualToString:call.method]) {
        PermissionGroup permission = [Codec decodePermissionGroupFrom:call.arguments];
        [PermissionManager checkServiceStatus:permission result:result];
    } else if ([@"requestPermissions" isEqualToString:call.method]) {
        // Removed check for existing request
        _methodResult = result;
        NSArray *permissions = [Codec decodePermissionGroupsFrom:call.arguments];
        
        [_permissionManager
         requestPermissions:permissions
         completion:^(NSDictionary *permissionRequestResults) {
             if (self->_methodResult != nil) {
                 self->_methodResult(permissionRequestResults);
             }
             
             self->_methodResult = nil;
        } errorHandler:^(NSString *errorCode, NSString *errorDescription) {
            self->_methodResult([FlutterError errorWithCode:errorCode message:errorDescription details:nil]);
            self->_methodResult = nil;
        }];
        
    } else if ([@"shouldShowRequestPermissionRationale" isEqualToString:call.method]) {
        result(@false);
    } else if ([@"openAppSettings" isEqualToString:call.method]) {
        [PermissionManager openAppSettings:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}
