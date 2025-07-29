//
//  SourceEntity+CoreDataProperties.swift
//  ReaderApp
//
//  Created by swaim yadav on 28/07/25.
//
//

import Foundation
import CoreData


extension SourceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SourceEntity> {
        return NSFetchRequest<SourceEntity>(entityName: "SourceEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}

extension SourceEntity : Identifiable {

}
