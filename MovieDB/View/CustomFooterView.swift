//
//  CustomFooterView.swift
//  MovieDB
//
//  Created by Suhit Patil on 20/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit

class CustomFooterView: UICollectionReusableView {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spinner.hidesWhenStopped = true
        spinner.color = .white
    }
    
}
