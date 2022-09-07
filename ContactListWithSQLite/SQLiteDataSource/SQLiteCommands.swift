//
//  SQLiteCommands.swift
//  ContactListWithSQLite
//
//  Created by Алексей Павленко on 06.09.2022.
//

import Foundation
import SQLite

class SQLiteCommands {
    
    static var table = Table("contacts")
    
    //Expressions
    static let id = Expression<Int>("id")
    static let firstName = Expression<String>("firstName")
    static let lastName = Expression<String>("lastName")
    static let phoneNumber = Expression<String>("phoneNumber")
    static let photo = Expression<Data>("photo")

    //Creating Table
    static func createTable() {
        guard let database = SQLiteDatabase.shared.database else { fatalError("Datastore connection error") }
        
        do {
            //ifNotExists: true - will NOT create a table if it already exists
            try database.run(table.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(firstName)
                table.column(lastName)
                table.column(phoneNumber, unique: true)
                table.column(photo)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    //Inserting Row
    static func insertRow(with contact: Contact) -> Bool {
        guard let database = SQLiteDatabase.shared.database else {
            print("Datastore connection error")
            return false
        }
        
        do {
            try database.run(table.insert(firstName <- contact.firstName, lastName <- contact.lastName, phoneNumber <- contact.phoneNumber, photo <- contact.photo))
            return true
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Insert row failed: \(message), in \(String(describing: statement))")
            return false
        } catch {
            print("Insert row failed: \(error)")
            return false
        }
    }
    
    //Updating Row
    static func updateRow(with contact: Contact) -> Bool {
        guard let database = SQLiteDatabase.shared.database else {
            print("Datastore connection error")
            return false
        }
        
        //Extracts the appropriate contact from the table according to the id
        let contactTable = table.filter(id == contact.id).limit(1)
        
        do {
            //Update the contact
            if try database.run(contactTable.update(firstName <- contact.firstName, lastName <- contact.lastName, phoneNumber <- contact.phoneNumber, photo <- contact.photo)) > 0 {
                print("Updated contact")
                return true
            } else {
                print("Could not update contact: contact not found")
                return false
            }
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Update row failed: \(message), in \(String(describing: statement))")
            return false
        } catch {
            print("Update row failed: \(error)")
            return false
        }
    }
    
    //Delete Row
    static func deleteContact(contact: Contact) {
        guard let database = SQLiteDatabase.shared.database else {
            print("Datastore connection error")
            return
        }
        
        let contactId = contact.id
        
        do {
            let contactTable = table.filter(id == contactId).limit(1)
            try database.run(contactTable.delete())
        } catch {
            print("Delete row error: \(error)")
        }
    }
    
    //Present Rows
    static func presentRows() -> [Contact]? {
        guard let database = SQLiteDatabase.shared.database else {
            print("Datastore connection error")
            return nil
        }
        
        //Contact Array
        var contactArray = [Contact]()
        
        //Sorting data in descending order by ID
        table = table.order(id.desc)
        
        do {
            for contact in try database.prepare(table) {
                let idV = contact[id]
                let firstNameV = contact[firstName]
                let lastNameV = contact[lastName]
                let phoneNumberV = contact[phoneNumber]
                let photoV = contact[photo]
                
                //Create contact
                let retrievedContact = Contact(id: idV, firstName: firstNameV, lastName: lastNameV, phoneNumber: phoneNumberV, photo: photoV)
                
                //Add contact to array
                contactArray.append(retrievedContact)
                print("id \(contact[id]), firstName: \(contact[firstName]), lastName: \(contact[lastName]), phoneNumber: \(contact[phoneNumber]), photoData: \(contact[photo])")
            }
        } catch {
            print("Present row erros: \(error)")
        }
        
        return contactArray
    }
}
