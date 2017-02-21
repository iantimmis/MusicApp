//
//  BandsModel.swift
//  MusicApp
//
//  Created by Ian Timmis on 2/16/17.
//  Copyright © 2017 Ian Timmis. All rights reserved.
//

import UIKit
import Firebase

class BandsModel: NSObject {
    
    var bandDetails = [BandDetail]()
    
    func fetch(complete:@escaping (Void)->Void) {
        
        // Get a reference to my firebase url
        let myRootRef = FIRDatabase.database().reference()
        
        // Attach a closure to read the data stored at the URL
        myRootRef.observe(.value, with: {[weak self]
            snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                print(snapshot.value)
                
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
                                bandDetail.videoURL = object["videoUrl"] as? String
                                
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
