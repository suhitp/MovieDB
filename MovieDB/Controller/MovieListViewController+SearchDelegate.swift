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
    
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // user did type something, check our datasource for text that looks the same
        if searchText.characters.count > 0 {
            // search and reload data source
            searchActive = true
            filterContent(for: searchText)
            collectionView?.reloadData()
        } else {
            searchActive = false
            collectionView?.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        collectionView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    
        if (searchBar.text?.characters.count)! > 0 {
            searchActive = true
            searchBar.showsCancelButton = true
        } else {
            searchActive = false
            searchBar.showsCancelButton = false
        }
    }*/

}
