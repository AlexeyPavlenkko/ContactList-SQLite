//
//  SQLiteDatabase.swift
//  ContactListWithSQLite
//
//  Created by Алексей Павленко on 06.09.2022.
//

import Foundation
import SQLite

class SQLiteDatabase {
    static let shared = SQLiteDatabase()
    var database: Connection?
    
    private init() {
        //Create connection to database
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("contactList").appendingPathExtension("sqlite3")
            database = try Connection(fileURL.path)
        } catch {
            fatalError("Failed to create connection to database. \(error.localizedDescription)")
        }
    }
    
    //Creating Table
    func createTable() {
        SQLiteCommands.createTable()
    }
}
