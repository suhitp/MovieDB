//
//  MovieListViewController.swift
//  MovieDB
//
//  Created by Suhit Patil on 16/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MovieCell"

class MovieListViewController: UICollectionViewController, MovieDataProtocol {
    
    var movieListViewModel: MovieListViewModel! = nil
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        configureCollectionView()
        
        movieListViewModel = MovieListViewModel(provider: MovieDBProvider)
    }
    
    private func configureCollectionView() {
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        self.collectionView!.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    //mark: MovieDataProtocol
    
    func didReceiveDataWith(movies: [Movie]) {
        self.movies += movies
        collectionView?.reloadData()
    }
    
    
    func didReceiveDataWith(error: NSError) {
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
        return cell
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }

}
