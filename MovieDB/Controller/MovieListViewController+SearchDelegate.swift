//
//  MovieListViewController+SearchDelegate.swift
//  MovieDB
//
//  Created by Suhit Patil on 18/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit


extension MovieListViewController: UISearchResultsUpdating {
    
    // MARK: Search
    func filterContent(for searchText :String) {
        //searchResults = movies.filter { $0.title.lowercased().hasPrefix(searchText.lowercased()) }
        searchResults = movies.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
        collectionView?.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(for: searchController.searchBar.text!)
    }
}
