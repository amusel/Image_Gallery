//
//  GalleriesModel.swift
//  Image_Gallery
//
//  Created by Artem Musel on 9/6/19.
//  Copyright © 2019 Artem Musel. All rights reserved.
//

import Foundation

class GalleriesCollection {
    static let sharedInstance = GalleriesCollection()
    private init(){}
    
    var galleries = [Gallery]()
    var deletedGalleries = [Gallery]()
    
    struct Gallery {
        var title = String()
        var images: [URL: Double] = [:]
        
        init(title: String) {
            self.title = title
        }
    }
    
    func getTitles(forGalleryCollection collection: [Gallery]) -> [String] {
        var titles = [String]()
        for gallery in collection {
            titles.append(gallery.title)
        }
        
        return titles
    }
}

