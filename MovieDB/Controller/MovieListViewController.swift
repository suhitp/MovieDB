//
//  MovieListViewController.swift
//  MovieDB
//
//  Created by Suhit Patil on 16/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "MovieCell"

class MovieListViewController: UICollectionViewController, MovieDataProtocol {
    
    var movieListViewModel: MovieListViewModel! = nil
    var movies = [Movie]()
    let baseImageUrl = "https://image.tmdb.org/t/p/w500"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        configureCollectionView()
        
        movieListViewModel = MovieListViewModel(provider: MovieDBProvider)
        movieListViewModel.delegate = self
    }
    
    private func configureCollectionView() {
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: view.frame.size.width / 2 - 0.5, height: 134)
        
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        self.collectionView!.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func loadMovieData() {
        self.movieListViewModel.getMovies(of: .popular)
    }
    //mark: MovieDataProtocol
    
    func didReceiveDataWith(_ movies: [Movie]) {
        self.movies += movies
        collectionView?.reloadData()
    }
    
    
    func didReceiveDataWith(_ error: NSError) {
        print(error.localizedDescription)
    }
    
    //MARK: didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        cell.movieTitle.text = movie.title
        cell.releaseDate.text = movie.release_date
        cell.rating.text = movie.vote_average
        let imageUrl = baseImageUrl.appending(movie.backdrop_path)
        cell.movieImageView.kf.setImage(with: URL(string: imageUrl)!, placeholder: nil, options: [.transition(.fade(0.5))],  progressBlock: nil, completionHandler: nil)
        return cell
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }

}
