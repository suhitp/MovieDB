//
//  MovieCell.swift
//  MovieDB
//
//  Created by Suhit Patil on 16/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    lazy var placeholder: UIImage? = {
        return UIImage(color: .black, size: movieImageView.frame.size)
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rating.layer.cornerRadius = 2
        rating.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        movieImageView.image = nil
        super.prepareForReuse()
    }
    
    func configure(withData movie: Movie) {
        movieTitle.text = movie.title
        releaseDate.text = movie.release_date.toString()
        
        if let average = movie.vote_average {
            rating.text = String(average)
        }
        
        if movie.backdrop_path != nil {
            let imageUrl = Constants.backdropImagePath.appending(movie.backdrop_path)
            movieImageView.kf.setImage(
                with: URL(string: imageUrl),
                placeholder: placeholder,
                options: [.transition(.fade(0.5))]
            )
        } else {
            movieImageView.image = UIImage(color: UIColor(white: 0, alpha: 0.5))
        }
    }

}
