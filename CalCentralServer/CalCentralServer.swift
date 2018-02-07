//
//  CalCentralServer.swift
//  CalCentralServer
//
//  Created by Chris Zielinski on 9/13/17.
//  Copyright © 2018 iOS DeCal. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://iosdecal.com/LICENSE.txt
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//===----------------------------------------------------------------------===//
//
//  Simple mock server to simulate a fake endpoint with real data validation.
//
//===----------------------------------------------------------------------===//

import Foundation

private func generateError(withMessage msg: String) -> (Bool, String, String?) {
    return (true, "", "Server error: \(msg)")
}

public func post(encodedParameters base64Params: String) -> (Bool, String, String?) {
    guard let params = Data(base64Encoded: base64Params) else {
        return generateError(withMessage: "Could not decode encodedParameters from base64 to ascii.")
    }
    
    do {
        let decoded = try JSONSerialization.jsonObject(with: params, options: [])
        
        guard let parameters = decoded as? [String : Any?] else {
            return generateError(withMessage: "Could not cast encodedParameters to a dictionary.")
        }
        
        guard let permissionCode = parameters["permission_code"] else {
            return generateError(withMessage: "encodedParameters does not have a 'permission_code' key or it's value is nil.")
        }
        
        if permissionCode is String {
            return (false, "Success: You are now enrolled in the iOS DeCal!", nil)
        }
    } catch {
        return generateError(withMessage: "Could not decode encodedParameters to JSON object: \(error.localizedDescription)")
    }
    
    return (true, "Error: This class requires instructor consent. You will need to obtain a permission code to add this class.", nil)
}
