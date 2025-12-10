//
//  MyDatabase.swift
//  hocTap
//
//  Created by  User on 09.12.2025.
//


import UIKit
import os.log

class MyDatabase {
    ///////////////////
    // MARK: Cac thuoc tinh cua CSDL
    ///////////////////
    //1. Ten CSDL
    let DB_NAME = "myDatabase.sqlite"
    //2. Duong dan den CSDL
    let DB_PATH:String
    //3. Doi tuong CSDL
    let db:FMDatabase?
    

    ///////////////////
    // MARK: Cac bang du lieu cua CSDL
    //////////////////
//    //1. Bang du lieu meals
//    let MEAL_TABLE_NAME = "meals"
//    let MEAL_ID = "_id"
//    let MEAL_NAME = "name"
//    let MEAL_IMAGE = "image"
//    let MEAL_RATING = "rating"
    
    ///////////////////
    // MARK: Cac primitives cua SCDL
    ///////////////////
    //1. Constructor
    init() {
        // Khoi gan gia tri cho DB_PATH
        //1. Lay ve tat ca cac thu muc co the co
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        //2. Khoi gan DB_PATH
        DB_PATH = directories[0] + "/" + DB_NAME
        //3. Khoi tao doi tuong CSDL
        db = FMDatabase(path: DB_PATH)
        if db != nil {
            os_log("Khoi tao CSDL thanh cong")
        }
        else {
            os_log("Khong the khoi tao CSDL!")
        }
    }
    // 2.Mo CSDL
    private func openDatabase () -> Bool {
        var ok = false
        if let db = db {
            if db.open() {
                ok = true
                os_log("Mo CSDL thanh cong")
            }
            else {
                os_log("Khong the mo CSDL")
            }
        }
        return ok
    }
    // 3.Dong CSDL
    private func closeDatabase () {
        if let db = db {
            db.close()
        }
    }
    // 4.Tao cac bang du lieu
    private func createTables(sql:String, tableName:String) -> Bool {
        var ok = false
        if openDatabase() {
            //Thuc hien tao bang du lieu thong qua doi tuong db
            if !db!.tableExists(tableName) {
                if db!.executeStatements(sql) {
                    os_log("tao bang \(tableName) thanh cong")
                    ok = true
                }
                else {
                    os_log("Khong the tao bang \(tableName)!")
                }
            }
            else {
                ok = true
            }
        }
        return ok
    }
    
    ////////////////////
    // MARK: Cac APIs cua CSDL
    ////////////////////
        
   
}

