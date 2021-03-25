//
//  UserDefaultsHelper.swift
//  MovieTV
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import Foundation


class UserDefaultsHelper {
    static var shared: UserDefaultsHelper {
        return UserDefaultsHelper()
    }
    
    enum UserType: String {
        case guest = "GUEST_USER", normal = "NROMAL_USER"
    }
    
    @UserDefaultValue(key: "request_token")
    var requestToken: String?
    
    @UserDefaultValue(key: "session_id")
    var sessionID: String?
    
    @UserDefaultValue(key: "user_type")
    var userType: String?
    
    @UserDefaultValue(key: "guest_session_id")
    var guestSessionID: String?
    
    @UserDefaultValue(key: "search_lottie_animation_name")
    var searchLottieAnimationName: String?
    
    @UserDefaultValue(key: "adult_movie_key")
    var isAdultMovieInclude: Bool?
    
    @UserDefaultValue(key: "avatar_animation_name")
    var avatarName: String?
    
    @UserDefaultValue(key: "user_name")
    var userName: String?
    
    var mappedUserType: UserType? { UserType(rawValue: userType ?? "") }
}

@propertyWrapper struct UserDefaultValue<T> {
    let key: String
    var userDefault: UserDefaults = UserDefaults.standard
    
    var wrappedValue: T? {
        get {
            return userDefault.value(forKey: key) as? T
        }
        
        set {
            userDefault.setValue(newValue, forKey: key)
        }
    }
}
