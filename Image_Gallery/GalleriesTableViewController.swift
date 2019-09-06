//
//  GalleriesTableViewController.swift
//  Image_Gallery
//
//  Created by Artem Musel on 9/6/19.
//  Copyright © 2019 Artem Musel. All rights reserved.
//

import UIKit

class GalleriesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    var galleriesTitles = [["1", "2", "3", "4", "5"], []]
    let sectionTitles = ["", "Recently Deleted"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 && galleriesTitles[1].count == 0 {
            return ""
        }
        else {
            return sectionTitles[section]
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return galleriesTitles[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)

        cell.textLabel?.text = galleriesTitles[indexPath.section][indexPath.row]

        return cell
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 1 {
                galleriesTitles[indexPath.section].remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else if indexPath.section == 0 {
                tableView.performBatchUpdates({
                    galleriesTitles[1].append(galleriesTitles[indexPath.section].remove(at: indexPath.row))
                    
                    //moveRows() is not used because of terrible animations it gives
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [IndexPath(row: galleriesTitles[1].count-1, section: 1)], with: .left)
                })
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var swipeActions = UISwipeActionsConfiguration()
        
        if indexPath.section == 1 {
            let restoreAction = UIContextualAction(style: .normal, title: "Restore") { (contextualAction, view, boolValue) in
                boolValue(true)
                tableView.performBatchUpdates({
                    self.galleriesTitles[0].append(self.galleriesTitles[indexPath.section].remove(at: indexPath.row))
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [IndexPath(row: self.galleriesTitles[0].count-1, section: 0)], with: .left)
                    
                    //if I remove this reload, then on last restored item strange bug appears
                    //somehow the section title does not disapper till user makes any action
                    tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .automatic)
                })
            }
            restoreAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            swipeActions = UISwipeActionsConfiguration(actions: [restoreAction])
        }
        
        return swipeActions
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 1 {
                print ("no")
                return
            }
            else if indexPath.section == 0 {
                //TODO
                print ("yes")
            }
        }
    }
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}
