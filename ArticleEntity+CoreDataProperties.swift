//
//  ArticleEntity+CoreDataProperties.swift
//  ReaderApp
//
//  Created by swaim yadav on 28/07/25.
//
//

import Foundation
import CoreData


extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var content: String?
    @NSManaged public var sourceRelationship: SourceEntity?


}

extension ArticleEntity : Identifiable {

}
