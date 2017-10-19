//
//  Movie+CoreDataProperties.swift
//  MyMovies
//
//  Created by Priscilla Jofani Oetomo on 10/19/17.
//  Copyright © 2017 grandevox. All rights reserved.
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var movieImageName: String?
    @NSManaged public var movieName: String?
    @NSManaged public var movieDescription: String?

}
