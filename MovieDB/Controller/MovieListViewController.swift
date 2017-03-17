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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movies"
        
        // Register cell classes
        configureCollectionView()
        
        //start spinner
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.center = view.center
        spinner.startAnimating()
        view.addSubview(spinner)
        
        movieListViewModel = MovieListViewModel(provider: MovieDBProvider)
        movieListViewModel.delegate = self
    }
    
    private func configureCollectionView() {
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.size.width / 2 - 0.5, height: 134)
        
        let nib = UINib(nibName: Constants.reuseIdentifier, bundle: nil)
        self.collectionView!.register(nib, forCellWithReuseIdentifier: Constants.reuseIdentifier)
    }
    
    
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
        return self.movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.movieTitle.text = movie.title
        cell.releaseDate.text = movie.release_date.toString()
        cell.rating.text = movie.vote_average
        if movie.backdrop_path != nil {
            let imageUrl = Constants.backdropImagePath.appending(movie.backdrop_path)
            let placeholder = UIImage.init(color: UIColor.white, size: cell.movieImageView.frame.size)
            cell.movieImageView.kf.setImage(with: URL(string: imageUrl)!, placeholder: placeholder, options: [.transition(.fade(0.5))],  progressBlock: nil, completionHandler: nil)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {
            movieListViewModel.loadMore(movie_sortType)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.detailSegue, sender: self)
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == Constants.detailSegue {
            if let indexPath = collectionView?.indexPathsForSelectedItems?.first {
                let movie = movies[indexPath.row]
                let detailViewModel = MovieDetailViewModel(movie: movie)
                let destination = segue.destination as! MovieDetailViewController
                destination.detailViewModel = detailViewModel
            }
        }
     }
    
    //MARK: didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
