//
//  GalleriesModel.swift
//  Image_Gallery
//
//  Created by Artem Musel on 9/6/19.
//  Copyright © 2019 Artem Musel. All rights reserved.
//

import Foundation

//singleton class with data represented by deleted and available galleries
class GalleriesCollection {
    static let sharedInstance = GalleriesCollection()
    private init() {
        //remove all of this to delete initial gallery
        availableGalleries.append(GalleriesCollection.Gallery(title: "Kitties"))
        availableGalleries[0].images.append(GalleriesCollection.GalleryItem(url: URL(string: "https://images2.minutemediacdn.com/image/upload/c_crop,h_1193,w_2121,x_0,y_64/f_auto,q_auto,w_1100/v1565279671/shape/mentalfloss/578211-gettyimages-542930526.jpg"),
                                                                            aspect: 1.7797619047619047))
        availableGalleries[0].images.append(GalleriesCollection.GalleryItem(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQxEbNeln6ZvYF6h-JKAV9JMjmA1S-k8S-pWxkQ3ilZPhO6-b8n"),
                                                                            aspect: 1.5081967213114753))
        availableGalleries[0].images.append(GalleriesCollection.GalleryItem(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSSnRxjl1HnZ96tJTL1zBFk1PieLxuPjpxvUNqJki5W6TAM_fAs"),
                                                                            aspect: 1.5027322404371584))
        availableGalleries[0].images.append(GalleriesCollection.GalleryItem(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS9gwPQ9p_S--y_UBtFAmzjbE6xM-zl6Bhx63uGEpn6G93MkGjQ"),
                                                                            aspect: 1.0))
        availableGalleries[0].images.append(GalleriesCollection.GalleryItem(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRHEb3wxBKOokIBjjPTKBN2LMqYYSgVWcENT-mdFQ_WJcik8zC0"),
                                                                            aspect: 1.425531914893617))
        availableGalleries[0].images.append(GalleriesCollection.GalleryItem(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT4Rlf9Vk6EYDOgdZx38n9ntyxAkTIh4xIpu_yiC94oEznW5XLq"),
                                                                            aspect: 1.9135802469135803))
    }
    
    var deletedGalleries = [Gallery]()
    var availableGalleries = [Gallery]()
    
    func getTitles(section: Int) -> [String] {
        var titles = [String]()
        let collection = section == 1 ? deletedGalleries : availableGalleries
        
        for gallery in collection {
            titles.append(gallery.title)
        }
        
        return titles
    }
    
    //gallery is basicly an array of [url,images] with title
    struct Gallery: Equatable {
        let identifier: String = UUID().uuidString
        var title = String()
        var images: [GalleryItem] = []
        
        init(title: String = "") {
            self.title = title
        }
        
        static func == (lhs: Gallery, rhs: Gallery) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }
    
    //image with url
    struct GalleryItem: Equatable {
        var url: URL!
        var aspect: Double = 1
    }
}

