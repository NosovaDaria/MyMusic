//
//  SearchInteractor.swift
//  MyMusic
//
//  Created by Дарья Носова on 26.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    
    var networkService = NetworkService()
    var presenter: SearchPresentationLogic?
    var service: SearchService?
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }
        
        switch request {
            case .getTracks(let searchTerm):
                print("interactror .getTracks")
                presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
                networkService.fetchTracks(searchText: searchTerm) { [weak self] (searchResponse) in
                    self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchResponse: searchResponse))
                }
        }
    }
    
}
