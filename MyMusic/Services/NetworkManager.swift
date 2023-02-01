//
//  NetworkManager.swift
//  MyMusic
//
//  Created by Дарья Носова on 07.12.2022.
//

import UIKit
import Alamofire

class NetworkService {
    func fetchTracks(searchText: String, completion: @escaping(SearchResponse?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parameters = ["term":"\(searchText)",
                          "limit":"100",
                          "media":"music"]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default , headers: nil).response { (dataResponse) in
            if let error = dataResponse.error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                completion(objects)
            } catch let jsonError {
                print("Failed to decode JSON", jsonError)
                completion(nil)
            }
        }
    }
}
