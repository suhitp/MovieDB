//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Suhit Patil on 17/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieDetailView: MovieDetailView!
    
    var detailViewModel: MovieDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = detailViewModel.movie.title
        movieDetailView.renderDetails(for: detailViewModel.movie)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
