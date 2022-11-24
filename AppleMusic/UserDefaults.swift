//
//  UserDefaults.swift
//  AppleMusic
//
//  Created by White on 11/20/22.
//

import Foundation


extension UserDefaults
{
    static let favouriteTrackKey = "favouriteTrackKey"
    
    func SavedTracks() -> [SearchViewModel.Cell]{
        let defaults = UserDefaults.standard
        
        guard let savedTracks = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data else {return []}
        
        guard let decodedTrack = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] else {return []}
        return decodedTrack
    }
}
