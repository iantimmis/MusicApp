//
//  BandsModel.swift
//  MusicApp
//
//  Created by Ian Timmis on 2/16/17.
//  Copyright © 2017 Ian Timmis. All rights reserved.
//

import UIKit
import Firebase
import SQLite

class BandsModel: NSObject {
    
    var bandDetails = [BandDetail]()
    
    /*
    func fetch(complete:@escaping (Void)->Void) throws
    {
        let db = try Connection()
        
        let bands = Table("bands")
        let id = Expression<Int64>("id")
        let bandName = Expression<String>("bandName")
        let bandType = Expression<String>("bandType")
        let bandDescription = Expression<String>("bandDescription")
        let fullImageName = Expression<String>("fullImageName")
        let thumbImageName = Expression<String>("thumbImageName")
        let nextShowDate = Expression<String>("nextShowDate")
        let nextShowTime = Expression<String>("nextShowTime")
        let venue = Expression<String>("venue")
        let showDetails = Expression<String>("showDetails")
        let videoUrl = Expression<String>("videoUrl")
        
        try db.run(bands.create { t in
            t.column(id, primaryKey: true)
            t.column(bandName)
            t.column(bandType)
            t.column(bandDescription)
            t.column(fullImageName)
            t.column(thumbImageName)
            t.column(nextShowDate)
            t.column(nextShowTime)
            t.column(venue)
            t.column(showDetails)
            t.column(videoUrl)
        })
        
        let insert = bands.insert(bandName <- "Nicole Atkins",
                                  bandType <- "Rock",
                                  bandDescription <- "Nicole will knock your socks off.",
                                  fullImageName <- "full-nicole-atkins.png",
                                  thumbImageName <- "thumb-nicole-atkins.png",
                                  nextShowDate <- "Tue 5/1",
                                  nextShowTime <- "8pm",
                                  venue <- "Bowery Ballroom",
                                  showDetails <- "All ages - $35",
                                  videoUrl <- "https://www.youtube.com/embed/Go9k14yrxeQ?rel=0")
        _ = try db.run(insert)

        for band in try db.prepare(bands)
        {
            let bandDetail = BandDetail()
            
            bandDetail.bandName = "\(band[bandName])"
            bandDetail.bandType = "\(band[bandType])"
            bandDetail.bandDescription = "\(band[bandDescription])"
            bandDetail.fullImageName = "\(band[fullImageName])"
            bandDetail.thumbImageName = "\(band[thumbImageName])"
            bandDetail.nextShowDate = "\(band[nextShowDate])"
            bandDetail.nextShowTime = "\(band[nextShowTime])"
            bandDetail.venue = "\(band[venue])"
            bandDetail.showDetails = "\(band[showDetails])"
            bandDetail.videoURL = "\(band[videoUrl])"
            
            self.bandDetails.append(bandDetail)
        }
        
        complete()
    }
    */
    
    func fetch(complete:@escaping (Void)->Void) {
        
        // Get a reference to my firebase url
        let myRootRef = FIRDatabase.database().reference()
        
        // Attach a closure to read the data stored at the URL
        myRootRef.observe(.value, with: {[weak self]
            snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                //print(snapshot.value)
                
                for snap in snapshots {
                    if let array = snap.value as? NSArray {
                        for dict in array {
                            if let object = dict as? Dictionary<String, AnyObject> {
                                let bandDetail = BandDetail()
                                bandDetail.bandName = object["bandName"] as? String
                                bandDetail.bandType = object["bandType"] as? String
                                bandDetail.bandDescription = object["bandDescription"] as? String
                                bandDetail.fullImageName = object["fullImageName"] as? String
                                bandDetail.thumbImageName = object["thumbImageName"] as? String
                                bandDetail.nextShowDate = object["nextShowDate"] as? String
                                bandDetail.nextShowTime = object["nextShowTime"] as? String
                                bandDetail.venue = object["venue"] as? String
                                bandDetail.showDetails = object["showDetails"] as? String
                                bandDetail.videoURL = object["videoURL"] as? String
                                
                                // A little memory management
                                if let strongSelf = self {
                                    strongSelf.bandDetails.append(bandDetail)
                                }
                            }
                        }
                    }
                    complete()
                }
            }
        })
    }
}
