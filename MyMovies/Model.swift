//
//  Model.swift
//  MyMovies
//
//  Created by Priscilla Jofani Oetomo on 10/19/17.
//  Copyright © 2017 grandevox. All rights reserved.
//

import CoreData
import UIKit

class Model {
    static let sharedInstance = Model()
    
    private init() {
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    // Get a reference to your App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Hold a reference to the managed context
    let managedContext: NSManagedObjectContext
    
    // Create a collection of objects to store in the database
    var movieDB = [Movie]()
    
    func getMovie (_ indexPath: IndexPath) -> Movie {
        return movieDB[indexPath.row] 
    }
    
    // MARK: - CRUD
    
    func updateDatabase() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deleteMovie (_ indexPath: IndexPath) {
        let movie = movieDB[indexPath.item]
        movieDB.remove(at: indexPath.item)
        managedContext.delete(movie)
        updateDatabase()
    }
    
    func getMoviesFromCoreData() {
        do {
            let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Movie")
            let results = try managedContext.fetch(fetchRequest)
            movieDB = results as! [Movie]
        } catch  let error as NSError {
            print ("Could not fetch \(error). \(error.userInfo)")
        }
    }
    
    func saveMovie(movie_name: String, movie_description: String, image_name: String, existing: Movie?) {
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
        
        // If existing is not nil then update existing movie
        if let _ = existing {
            existing!.movieName = movie_name
            existing!.movieImageName = image_name
            existing!.movieDescription = movie_description
        }
        
        // Create a new movie object and update it with the data passed in from the View Controller 
        else {
            // Create new Movie
            let movie = Movie(entity: entity, insertInto: managedContext)
            
            movie.setValue(movie_name, forKey: "movieName")
            movie.setValue(movie_description, forKey: "movieDescription")
            movie.setValue(image_name, forKey: "movieImageName")
            movieDB.append(movie)
        }
        
        updateDatabase()
    }
}
