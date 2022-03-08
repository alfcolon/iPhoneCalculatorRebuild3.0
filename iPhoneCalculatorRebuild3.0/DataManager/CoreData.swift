//
//  CoreData.swift
//  iPhoneCalculatorRebuild3.0
//
//  Created by Alfredo Colon on 3/1/22.
//

import CoreData

class CoreData {

    // MARK: - Properties

    var entityName: String = "CalculatorCoreDataEntity"
    var context: NSManagedObjectContext!
    var persistentContainer: NSPersistentContainer

   // MARK: - Init

    required init() {
        self.persistentContainer = NSPersistentContainer(name: "CalculatorCoreDataModel")
    }

    // MARK: - Load

    func waitTillLoaded() {
        let group = DispatchGroup()
        group.enter()
        self.persistentContainer.loadPersistentStores { (test, error) in
            if let error = error {
                fatalError("Could not access persistent reverseParentheticalExpressionContainer with enity \(self.entityName).\nError:\n\(error)")
            }
            self.context = self.persistentContainer.viewContext
            group.leave()
        }
        group.wait()
    }

    // MARK: - Fetch

    func fetch() -> CalculatorCoreDataEntity {
        if self.context == nil {
            self.waitTillLoaded()
        }
        let fetchRequest: NSFetchRequest<CalculatorCoreDataEntity> = NSFetchRequest(entityName: self.entityName)
        
        let result: CalculatorCoreDataEntity = {
            let fetchedResult: [CalculatorCoreDataEntity]? = try? self.context.fetch(fetchRequest)
            
            if fetchedResult == nil || fetchedResult!.isEmpty {
                let startingEntity: CalculatorCoreDataEntity = {
                    let entity = CalculatorCoreDataEntity(context: self.context)
                    entity.model = CalculatorPersistedData()
                    return entity
                }()
                self.save()
                
                return startingEntity
            } else if fetchedResult!.count != 1 {
                fatalError()
            }
            return fetchedResult!.first!
        }()
        return result
    }
    
    func fetchNew() -> [CalculatorCoreDataEntity] {
        if self.context == nil {
            self.waitTillLoaded()
        }
        
        let fetchRequest: NSFetchRequest<CalculatorCoreDataEntity> = NSFetchRequest(entityName: self.entityName)
        
        do {
            let fetchedResult: [CalculatorCoreDataEntity] = try self.context.fetch(fetchRequest)
            return fetchedResult
        } catch {
            fatalError("Fetch error: error.localizedDescription")
        }
        
    }
    
    // MARK: - Persist
    
    func persist(dataModel: CalculatorPersistedData) {
        let entity = self.fetch()
        entity.model = dataModel
        self.save()
    }
    
    // MARK: - Save
    
    func save() {
        do {
            try self.context.save()
        } catch {
            fatalError("Error saving calc arithmetic:\n\(error)")
        }
    }
}
