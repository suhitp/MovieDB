//
//  MovieDetailView.swift
//  MovieDB
//
//  Created by Suhit Patil on 17/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailView: UIView {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var detailBackgroundView: UIView!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    let placeholder = UIImage(color: UIColor(white: 0, alpha: 0.5))
    
    func renderDetails(for movie: Movie) {
       
        let isAdult = (movie.adult == true) ? " (A)": ""
        
        titleLabel.text = movie.title.appending(isAdult)
        releaseDate.text = "Releasing on " + movie.release_date.toString()
        
        if let average = movie.vote_average {
            rateLabel.text = "Average Vote: ".appending(String(average))
        }
        
        if let count = movie.vote_count {
            voteCountLabel.text = "Vote Count: ".appending(String(count))
        }
        
        if let popularity = movie.popularity {
            popularityLabel.text = "Popularity: ".appending(String(popularity))
        }
        
        overviewTextView.text = movie.overview
        
        if movie.backdrop_path != nil {
            let backdropImageUrl = Constants.backdropImagePath.appending(movie.backdrop_path)
            backgroundImageView.kf.setImage(
                with: URL(string: backdropImageUrl)!,
                placeholder: placeholder,
                options: [.transition(.fade(0.5))]
            )
        }
        
        if movie.poster_path != nil {
            let posterImageUrl = Constants.posterImagePath.appending(movie.poster_path)
            backgroundImageView.kf.setImage(
                with: URL(string: posterImageUrl),
                placeholder: placeholder,
                options: [.transition(.fade(0.5))]
            )
        }
    }
}
