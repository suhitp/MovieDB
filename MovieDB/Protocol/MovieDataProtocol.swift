//
//  MovieDataProtocol.swift
//  MovieDB
//
//  Created by Suhit Patil on 16/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit

protocol MovieDataProtocol: class {
    
    func didReceiveDataWith(movies: [Movie])
    func didReceiveDataWith(error: NSError)
}
