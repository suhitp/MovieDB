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
    
    var searchBar: UISearchBar!
    var searchResults = [Movie]()
    
    var searchActive: Bool {
        get {
            return self.searchController.isActive && self.searchController.searchBar.text != ""
        }
    }
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movies"
        
        // Register cell classes
        configureCollectionView()
        
        //configure SearchBar
        configureSearchController()
        
        //start spinner
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
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
    
    private func configureCollectionView() {
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.size.width / 2 - 0.5, height: 134)
        layout.sectionInset = UIEdgeInsetsMake(44, 0, 0, 0)
        
        let nib = UINib(nibName: Constants.reuseIdentifier, bundle: nil)
        collectionView!.register(nib, forCellWithReuseIdentifier: Constants.reuseIdentifier)
    }
    
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
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ _ in }))
        
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
        
        self.movies += movies
        spinner.stopAnimating()
        collectionView?.reloadData()
        sortOrderStatus = false
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
    
        cell.movieTitle.text = movie.title
        cell.releaseDate.text = movie.release_date.toString()
        
        if let average = movie.vote_average {
            cell.rating.text = String(average)
        }
        
        if movie.backdrop_path != nil {
            let imageUrl = Constants.backdropImagePath.appending(movie.backdrop_path)
            let placeholder = UIImage.init(color: UIColor(white: 0, alpha: 0.5), size: cell.movieImageView.frame.size)
            cell.movieImageView.kf.setImage(with: URL(string: imageUrl)!, placeholder: placeholder, options: [.transition(.fade(0.5))],  progressBlock: nil, completionHandler: nil)
        } else {
            cell.movieImageView.image = UIImage(color: UIColor(white: 0, alpha: 0.5))
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if !searchActive {
            if indexPath.row == movies.count - 1 {
                movieListViewModel.loadMore(movie_sortType)
            }
        }
    }
    
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
