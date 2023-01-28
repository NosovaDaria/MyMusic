//
//  UserDefaults.swift
//  Pods
//
//  Created by Дарья Носова on 28.01.2023.
//

import Foundation

extension UserDefaults {
    static var favouriteTrackKey = "favouriteTrackKey"
    
    func  savedTracks() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        
        guard let savedTracks = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data else { return [] }
        
        guard let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] else { return [] }
        return decodedTracks
    }
}
