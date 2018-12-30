//
//  User+CoreDataProperties.swift
//  SaveDataDemo
//
//  Created by J K on 2018/12/29.
//  Copyright © 2018 Kims. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userName: String?

}
