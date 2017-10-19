//
//  TableViewController.swift
//  MyMovies
//
//  Created by Priscilla Jofani Oetomo on 10/19/17.
//  Copyright © 2017 grandevox. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var model = Model.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Prepare data for display
    // Make sure the latest data is displayed when the view is displayed
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        model.getMoviesFromCoreData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.movieDB.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell!
        let movie = model.getMovie(indexPath)
        
        cell?.textLabel?.text = movie.movieName
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        model.deleteMovie([indexPath.row])
        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get a reference to the Detail View Controller
        let detailsVC: DetailViewController! = segue.destination as! DetailViewController
        
        /*
         identifier is required, if you have more than one segue.
         We have 2 segues, 1 for adding a new item, and 1 for updating an existing one.
         If updating an exsiting one, we need to pass the current movie across so its data can be populated in the view
        */
        
        if segue.identifier == "update" {
            // Send data to the detail view ahead of the segue
            if let selectedRowIndexPath = tableView.indexPathForSelectedRow {
                let movie = self.model.movieDB[selectedRowIndexPath.row]
                detailsVC.currentMovie = movie
            }
        }
    }
}
