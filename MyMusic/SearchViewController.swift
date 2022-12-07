//
//  SearchViewController.swift
//  MyMusic
//
//  Created by Дарья Носова on 03.05.2022.
//

import Alamofire
import UIKit

struct TrackModel {
    var trackName: String
    var artistName: String
}

class SearchViewController: UITableViewController {
    
    private var timer: Timer?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var tracks = [Track]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupSearchBar()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = UIImage(named: "image")
        return cell
    }

    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            let url = "https://itunes.apple.com/search"
            let parameters = ["term":"\(searchText)",
                              "limit":"10"]
            AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default , headers: nil).response { (dataResponse) in
                if let error = dataResponse.error {
                    print("Error received requesting data: \(error.localizedDescription)")
                    return
                }
                
                guard let data = dataResponse.data else { return }
                
                let decoder = JSONDecoder()
                do {
                    let objects = try decoder.decode(SearchResponse.self, from: data)
                    print("objects: ", objects)
                    self.tracks = objects.results
                    self.tableView.reloadData()
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            }
    
        })
    }
}
