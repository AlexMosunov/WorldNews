//
//  CoreDataManager.swift
//  WorldNews
//
//  Created by Alex Mosunov on 25.01.2022.
//

import UIKit
import CoreData

public class CoreDataManager: NSObject {
    
    // MARK: Properties
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    // MARK: Singleton
    
    public static let shared = CoreDataManager()
    private override init() {
        super.init()
    }
    
    func saveContext() {
        do {
            try context?.save()
        } catch {
            print("error saving context \(error)")
        }
    }
    
    func loadArticles() -> [Article] {
        let favouriteArticles: [Article]?
        let items: NSFetchRequest<Article> = Article.fetchRequest()
        do {
            favouriteArticles = try context?.fetch(items)
            return favouriteArticles ?? []
        } catch {
            print("error fetching data from context \(error)")
            return []
        }
    }
    
    
}
