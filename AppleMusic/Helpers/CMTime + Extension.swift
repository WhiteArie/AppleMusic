//
//  CMTime + Extension.swift
//  AppleMusic
//
//  Created by White on 10/30/22.
//

import Foundation
import AVKit

extension CMTime{
    func ToDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
    
}
