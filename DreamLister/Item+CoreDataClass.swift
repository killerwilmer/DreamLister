//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Wilmer Arteaga on 3/02/17.
//  Copyright © 2017 killerwilmer. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
}
