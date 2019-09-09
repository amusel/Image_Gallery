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
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                               action: #selector(editCell(_:)))
        tapGesture.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Table view data source
    let sectionTitles = ["", "Recently Deleted"]
    var galleriesTitles: [[String]] {
        return [GalleriesCollection.sharedInstance.getTitles(section: 0),
                GalleriesCollection.sharedInstance.getTitles(section: 1)]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //no title for first section
        //not title for second section if there are no deleted images
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

        if let galleryCell = cell as? GalleryTableViewCell {
            galleryCell.title = galleriesTitles[indexPath.section][indexPath.row]
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let collection = GalleriesCollection.sharedInstance
        
        if editingStyle == .delete {
            if indexPath.section == 1 {
                collection.deletedGalleries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else if indexPath.section == 0 {
                
                tableView.performBatchUpdates({
                    changeStatus(forGallery: collection.availableGalleries[indexPath.row], with: true)
                    
                    //moveRows() is not used because of terrible animations it gives
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [IndexPath(row: galleriesTitles[1].count-1, section: 1)], with: .left)
                }, completion: { _ in
                    //update collectionView after deletion
                    let index = IndexPath(row: self.galleriesTitles[1].count-1, section: 1)
                    self.performSegue(withIdentifier: "ImageCollection",
                                 sender: tableView.cellForRow(at: index))
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
                    self.changeStatus(forGallery: GalleriesCollection.sharedInstance.deletedGalleries[indexPath.row], with: false)
                    
                    let newIndexPath = IndexPath(row: self.galleriesTitles[0].count-1, section: 0)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.insertRows(at: [newIndexPath], with: .left)
                    
                    //if I remove this reload, then on last restored item strange bug appears
                    //somehow the section title does not disapper till user makes any action
                    tableView.reloadData()
                })
                
            }
            restoreAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            swipeActions = UISwipeActionsConfiguration(actions: [restoreAction])
        }
        
        return swipeActions
    }
    
    //change deleted status for gallery
    private func changeStatus(forGallery gallery: GalleriesCollection.Gallery, with deleted: Bool) {
        let collection = GalleriesCollection.sharedInstance

        if deleted, let index = collection.availableGalleries.firstIndex(of: gallery) {
                collection.deletedGalleries.append(collection.availableGalleries.remove(at: index))
        }
        else if let index = collection.deletedGalleries.firstIndex(of: gallery) {
            collection.availableGalleries.append(collection.deletedGalleries.remove(at: index))
        }
    }
    
    @IBAction func addNewGallery(_ sender: UIBarButtonItem) {
        let newGallery = GalleriesCollection.Gallery(title: "Untitled".madeUnique(withRespectTo: galleriesTitles[0] + galleriesTitles[1]))
        GalleriesCollection.sharedInstance.availableGalleries.append(newGallery)
        tableView.insertRows(at: [IndexPath(row: galleriesTitles[0].count-1, section: 0)], with: .left)
    }
    
    @objc func editCell(_ sender: UITapGestureRecognizer) {
        if let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) {
            if let cell = tableView.cellForRow(at: indexPath) as? GalleryTableViewCell {
                cell.resignationHandler = { [weak self, weak cell] in
                    if indexPath.section == 0 {
                        GalleriesCollection.sharedInstance.availableGalleries[indexPath.row].title = cell!.title
                    }
                    else {
                        GalleriesCollection.sharedInstance.deletedGalleries[indexPath.row].title = cell!.title
                    }
                    
                    self?.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    self?.performSegue(withIdentifier: "ImageCollection", sender: cell)
                }
                
                cell.isEditing = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if indexPath.section == 1 {
                if let navC = segue.destination as? UINavigationController,
                    let imageCollectionView = navC.topViewController as? ImageCollectionViewController {
                    imageCollectionView.gallery = nil
                    imageCollectionView.title = ""
                }
                
                return
            }
            else if indexPath.section == 0 {
                if let navC = segue.destination as? UINavigationController,
                    let imageCollectionView = navC.topViewController as? ImageCollectionViewController {
                    imageCollectionView.gallery = GalleriesCollection.sharedInstance.availableGalleries[indexPath.row]
                    imageCollectionView.title = imageCollectionView.gallery.title
                }
            }
        }
    }
}
