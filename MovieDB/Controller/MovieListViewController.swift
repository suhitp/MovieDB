//
//  MovieListViewController.swift
//  MovieDB
//
//  Created by Suhit Patil on 16/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit
import Kingfisher


class MovieListViewController: UICollectionViewController, MovieDataProtocol {
    
    var movieListViewModel: MovieListViewModel! = nil
    var movies = [Movie]()
   
    var spinner: UIActivityIndicatorView! = nil
    
    var movie_sortType: MovieDB = .popular
    var sortOrderStatus = false
    
    var searchController: UISearchController!
    
    var searchResults = [Movie]()
    var searchActive: Bool {
        get {
            return self.searchController.isActive && self.searchController.searchBar.text != ""
        }
    }
    
    
    //MARK: ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movies"
        
        // Register cell classes
        configureCollectionView()
        
        //configure SearchBar
        configureSearchController()
        
        //start spinner
        spinner = UIActivityIndicatorView(style: .gray)
        spinner.center = view.center
        spinner.startAnimating()
        view.addSubview(spinner)
        
        //init MovieListViewModel and set delegate
        movieListViewModel = MovieListViewModel(provider: MovieDBProvider)
        movieListViewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    //MARK: configureCollectionView
    
    private func configureCollectionView() {
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.size.width / 2 - 0.5, height: 134)
        layout.sectionInset = UIEdgeInsets.init(top: 44, left: 0, bottom: 0, right: 0)
        
        let nib = UINib(nibName: Constants.reuseIdentifier, bundle: nil)
        collectionView!.register(nib, forCellWithReuseIdentifier: Constants.reuseIdentifier)
        
        let footerNib = UINib(nibName: Constants.customFooterView, bundle: nil)
        collectionView?.register(footerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Constants.footerIdentifier)
    }
    
    //MARK: configureSearchController
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search your favourite movie..."
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barStyle = .black
        definesPresentationContext = true
        collectionView?.addSubview(searchController.searchBar)
    }
    
    //MARK: SortMovies Method
    
    @IBAction func sortMovies(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Sort movies by", message: "", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Popular", style: .default , handler:{ _ in
            self.handleSortAction(by: .popular)
        }))
        
        alertController.addAction(UIAlertAction(title: "Top rated", style: .default , handler:{ (UIAlertAction)in
           self.handleSortAction(by: .top)
        }))
        
        alertController.addAction(UIAlertAction(title: "Release Date", style: .default , handler:{ (UIAlertAction)in
            self.handleSortAction(by: .releaseDate)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{ _ in }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Private Method
    
    private func handleSortAction(by type: MovieDB) {
        
        guard movie_sortType != type else {
            return
        }
        sortOrderStatus = true
        spinner.startAnimating()
        movie_sortType = type
        movieListViewModel.sort(by: type)
    }
    
    
    //mark: MovieDataProtocol
    
    func didReceiveDataWith(_ movies: [Movie]) {
        
        if sortOrderStatus == true {
            self.movies.removeAll()
        }
        
        if movies.count > 20 {
            collectionView?.performBatchUpdates({
                let count = movies.count
                self.movies += movies
                var indexpaths = [IndexPath]()
                for index in count..<movies.count {
                    indexpaths.append(IndexPath(item: index, section: 0))
                }
                self.collectionView?.insertItems(at: indexpaths)
            }, completion: { (_) in
                self.sortOrderStatus = false
                //self.movieListViewModel.loadingState = .none
            })
        } else {
            self.movies += movies
            spinner.stopAnimating()
            collectionView?.reloadData()
            sortOrderStatus = false
            //movieListViewModel.loadingState = .none
        }
    }
    
    
    func didReceiveDataWith(_ error: Error) {
        spinner.stopAnimating()
        print(error.localizedDescription)
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchActive {
            return searchResults.count
        } else {
            return movies.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! MovieCell
        
        let movie = currentMovie(at: indexPath)
        cell.configure(withData: movie)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if !searchActive {
            if indexPath.row == movies.count - 1 {
                movieListViewModel.loadingState = .loading
                movieListViewModel.loadMore(movie_sortType)
            } else {
                movieListViewModel.loadingState = .none
            }
        }
    }
    
    //MARK: Footer
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if movieListViewModel.loadingState == .none {
            return CGSize.zero
        }
        return CGSize(width: view.frame.size.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.footerIdentifier, for: indexPath) as! CustomFooterView
            footerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            footerView.spinner.startAnimating()
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    //MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        performSegue(withIdentifier: Constants.detailSegue, sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == Constants.detailSegue {
            if let indexPath = collectionView?.indexPathsForSelectedItems?.first {
                let movie = currentMovie(at: indexPath)
                let detailViewModel = MovieDetailViewModel(movie: movie)
                let destination = segue.destination as! MovieDetailViewController
                destination.detailViewModel = detailViewModel
            }
        }
    }
    
    //MARK: Returns movie at indexPath
    
    private func currentMovie(at indexPath: IndexPath) -> Movie {
        if searchActive {
            return searchResults[indexPath.row]
        } else {
            return movies[indexPath.row]
        }
    }
    
    //MARK: didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
