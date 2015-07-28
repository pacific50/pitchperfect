//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by David Kim on 6/23/15.
//  Copyright (c) 2015 David Kim. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    init(fromRecorderURL: NSURL, fromRecorderTitle: String){
        filePathUrl = fromRecorderURL
        title = fromRecorderTitle
    }
}
