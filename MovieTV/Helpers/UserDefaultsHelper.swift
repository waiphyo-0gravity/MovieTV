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
    
    @UserDefaultValue(key: "api_key")
    var apiKey: String?
    
    @UserDefaultValue(key: "request_token")
    var requestToken: String?
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
