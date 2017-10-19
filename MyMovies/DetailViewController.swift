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
    let session = URLSession.shared
    
    // Constants for building various url requests to the service
    let BASE_URL: String = "https://api.themoviedb.org/3/"
    let SEARCH_MOVIE: String = "search/movie"
    let MOVIE_DETAILS: String = "movie/"
    let IMAGES_LOCATION = "images"
    let API_KEY:String = "?api_key=3d11a75d03b291bcda5cd72453ca5ca3"
    let ID_LENGTH:Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentMovie != nil {
            movieImage.image = UIImage(named: (currentMovie?.movieImageName)!)
            movieTitle.text = currentMovie?.movieName
            movieImageName.text = currentMovie?.movieImageName
            movieDesc.text = currentMovie?.movieDescription
        }
        
        getMovie()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getMovie() {
        let mTitle:String = self.movieTitle.text!.escapedParameters()
        let findMovieID = BASE_URL + SEARCH_MOVIE + API_KEY + "&" + mTitle
        
        if let url = URL(string: findMovieID) {
            let request = URLRequest(url: url)
            // Initialise the taks for getting the data
            initialiseTaskForGettingData(request, element: "results")
        }
    }
    
    func initialiseTaskForGettingData(_ request: URLRequest, element:String)
    {
        let session = URLSession.shared
        /* 4 - Initialize task for getting data */
        let task = session.dataTask(with: request, completionHandler: {data, response, downloadError in
            // Handler in the case of an error
            if let error = downloadError
            {
                print("\(String(describing: data)) \n data")
                print("\(String(describing: response)) \n response")
                print("\(error)\n error")
            }
            else
            {
                // Create a variable to hold the results once they have been passed through the JSONSerialiser.
                // Why has this variable been declared with an explicit data type of Any
                let parsedResult: Any!
                do
                {
                    // Convert the http response payload to JSON.
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                }
                catch _ as NSError
                {
                    parsedResult = nil
                }
                catch
                {
                    fatalError()
                }
                
                // Log the results to the console, so you can see what is being sent back from the service.
                print(parsedResult)
                
                // Extract an element from the data as an array, if your JSON response returns a dictionary you will need to convert it to an NSDictionary
                // Why must parsedResult be cast to AnyObject if it is already declared as type Any, there is a clue in the syntax :-)
                if let moviesArray = (parsedResult as AnyObject).value(forKey: element) as? NSArray
                {
                    var id:String?
                    for m in moviesArray
                    {
                        let movie = m as! NSDictionary
                        
                        if (movie.value(forKey: "original_title") as! String) == self.movieTitle.text
                        {
                            id = String(describing: movie.value(forKey: "id")!)
                            self.getRandomMovieImage(id!)
                            break
                        }
                    }
                    if id == ""
                    {
                        print("Movie not found")
                    }
                }
            }
        })
        // Execute the task
        task.resume()
    }
    
    func getRandomMovieImage(_ movieId: String)
    {
        // Build the URL as the basis for the request
        let getRandomImage = BASE_URL + MOVIE_DETAILS + movieId + "/images" + API_KEY
        let url = URL(string: getRandomImage)!
        let request = URLRequest(url: url)
        
        // Initialise the task for getting the data
        let task = session.dataTask(with: request, completionHandler: {data, response, downloadError in
            if let error = downloadError
            {
                print(error)
            }
            else
            {
                // Parse the data received from the service
//                var parsingError: NSError? = nil
                let parsedResult: Any!
                do
                {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                }
                catch _ as NSError
                {
//                    parsingError = error
                    parsedResult = nil
                }
                catch
                {
                    fatalError()
                }
                
                // Extract an element from the data as an array, if your JSON response returns a dictionary you will need to convert it to an NSDictionary
                if let photosArray = (parsedResult as AnyObject).value(forKey: "backdrops") as? NSArray
                {
                    // Grab a random image from the array
                    let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
                    
                    // This time, I can convert to an NSDictionary, even though it is illformed the attribute I am after is quoted and so I can access it from the dictionary
                    let imageDictionary = photosArray[randomPhotoIndex] as? NSDictionary
                    
                    // Extract a random image url from the dictionary
                    let imageUrlString = imageDictionary?.value(forKey: "file_path") as? NSString
                    
                    // Build the full url of the image
                    let baseImageUrlString = "https://image.tmdb.org/t/p/original"
                    let fullImageUrlString = baseImageUrlString + (imageUrlString! as String)
                    let imageURL = URL(string: fullImageUrlString)
                    
                    // If the image exists at the url specified set the UIImageView to reference that image
                    if let imageData = try? Data(contentsOf: imageURL!)
                    {
                        DispatchQueue.main.async(execute: {self.movieImage.image = UIImage(data: imageData)})
                    }
                }
            }
        })
        // Execute the task
        task.resume()
    }
}

extension String {
    func escapedParameters() -> String {
        var urlVars = [String]()
        let parameters:[String: AnyObject] = ["query": self as AnyObject]
        
        for (key, value) in parameters {
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        
        return (!urlVars.isEmpty ? "" : "") + urlVars.joined(separator: "&")
    }
}
