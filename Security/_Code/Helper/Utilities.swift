//
//  Utilities.swift
//  Security
//
//  Created by Mike Lepore on 6/11/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import Foundation

struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}
