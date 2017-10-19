//
//  DetailViewController.swift
//  MyMovies
//
//  Created by Priscilla Jofani Oetomo on 10/19/17.
//  Copyright © 2017 grandevox. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UITextField!
    @IBOutlet weak var movieImageName: UITextField!
    @IBOutlet weak var movieDesc: UITextView!
    
    @IBAction func save (_ sender: Any) {
        Model.sharedInstance.saveMovie(movie_name: movieTitle.text!, movie_description: movieDesc.text, image_name: movieImageName.text!, existing: currentMovie)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func cancel (_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    var currentMovie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentMovie != nil {
            movieImage.image = UIImage(named: (currentMovie?.movieImageName)!)
            movieTitle.text = currentMovie?.movieName
            movieImageName.text = currentMovie?.movieImageName
            movieDesc.text = currentMovie?.movieDescription
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

