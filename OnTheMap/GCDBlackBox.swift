//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Sam Thomas on 3/27/16.
//  Copyright © 2016 STDESIGN. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}