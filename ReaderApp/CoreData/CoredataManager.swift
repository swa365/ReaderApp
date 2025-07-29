//  CoredataManager.swift
//  ReaderApp
//  Created by swaim yadav on 28/07/25.

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveArticles(_ articles: [Article]) {
      
        for article in articles {
            let articleEntity = ArticleEntity(context: context)
            articleEntity.author = article.author
            articleEntity.title = article.title
            articleEntity.descriptions = article.description
            articleEntity.url = article.url
            articleEntity.urlToImage = article.urlToImage
            articleEntity.publishedAt = article.publishedAt
            articleEntity.content = article.content

            let sourceEntity = SourceEntity(context: context)
            sourceEntity.id = article.source.id
            sourceEntity.name = article.source.name
            articleEntity.sourceRelationship = sourceEntity
        }

        do {
            try context.save()
        } catch {
            print("Failed to save articles:", error)
        }
    }

    func fetchArticles() -> [Article] {
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        do {
            let results = try context.fetch(request)
            return results.map { entity in
                Article(
                    source: Source(id: entity.sourceRelationship?.id, name: entity.sourceRelationship?.name ?? ""),
                    author: entity.author,
                    title: entity.title,
                    description: entity.descriptions,
                    url: entity.url,
                    urlToImage: entity.urlToImage,
                    publishedAt: entity.publishedAt,
                    content: entity.content
                 )
            
            }
           
            
        } catch {
            print("Failed to fetch articles:", error)
            return []
        }
    }

    func clearArticles() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ArticleEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to clear CoreData:", error)
        }
    }
}
