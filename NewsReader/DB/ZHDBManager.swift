//
//  ZHDBManager.swift
//  NewsReader
//
//  Created by Harold on 15/8/22.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation

let TableNews = "ZHNews"

class ZHDBManager: NSObject {
    
    // 将内容存储到指定数据库的表中
    /*
    *content：要存储的内容
    *primaryKey：表主键,不能为nil
    *otherFields:表字段名称，不包含主键,统一为TEXT数据类型
    *tableName：表名称
    *dbFile：数据库文件，路径+文件名
    */
    
    class func save(dictContent content:NSDictionary,primaryKey pKey:String,inTable tableName:String,inDBFile dbFile:String) {
        
        let queue = FMDatabaseQueue(path: dbFile)
        queue.inTransaction { (db,roolBack) -> Void in
            
            let values:NSMutableString = NSMutableString()
            let field:NSMutableString = NSMutableString()
            
            //首先加入主键
            values.appendFormat("'%@'", content.objectForKey(pKey) as! String)
            field.appendFormat("%@ TEXT PRIMARY KEY", pKey)
            for (key,cont) in content {
                
                if key as! String == pKey {
                    continue
                }
                values.appendFormat(",'%@'", cont as! String)
                field.appendFormat(",%@ TEXT", key as! String)
            }
            
            let createSqlFmt = "CREATE TABLE IF NOT EXISTS %@ (%@)"
            let createSql = NSString(format: createSqlFmt, tableName,field)
            var result = db.executeUpdate(createSql as String)
            if result {
                let insertSqlFmt = "INSERT OR REPLACE INTO %@ values(%@)"
                result = db.executeUpdate(NSString(format: insertSqlFmt, tableName,values) as String)
            }
            if !result {
                print("\(tableName) 创建或插入数据错误")
            }
        }
        
        queue.close()
    }
    
    // condition格式为：{key:Value}
    class func fetchWithCondition(dictCondiction condition:NSDictionary,forFields fields:NSArray,inTable tableName:String,inDBfile dbFile:String) ->NSArray{
        let contents = NSMutableArray()
        let queue = FMDatabaseQueue(path: dbFile)
        
        queue.inTransaction { (db, rollback) -> Void in
            let sql = NSMutableString()
            sql.appendFormat("SELECT * FROM %@", tableName)
            
            var index = 0
            for (key,cdt) in condition {
                if index == 0 {
                    sql.appendString(" WHERE ")
                }
                else {
                    sql.appendString(" AND ")
                }
                
                if cdt.isKindOfClass(NSString) {
                    sql.appendFormat("%@='%@'", key as! String,cdt as! String)
                }
                
                index++
            }
            let rs = db.executeQuery(sql as String)
            var dictRow:NSMutableDictionary
            if rs != nil{
                while (rs!.next()) {
                    dictRow = NSMutableDictionary()
                    for key in fields {
                        dictRow.setObject((rs?.stringForColumn(key as! String))!, forKey: key as! String)
                    }
                    contents.addObject(dictRow)
                }
            }
           
        }
        queue.close()
        return contents
    }
    
    class func deleteWithCondition(dictCondition:NSDictionary,inTable tableName:String,inDBFile dbFile:String) {
        let queue = FMDatabaseQueue(path: dbFile)
        queue.inTransaction { (db, rollback) -> Void in
            let sql = NSMutableString()
            sql.appendFormat("DELETE FROM %@", tableName)
            
            var index = 0
            for (key,condition) in dictCondition {
                if index == 0 {
                    sql.appendString(" WHERE ")
                }
                else {
                    sql.appendString(" AND ")
                }
                sql.appendFormat("%@='%@'", key as! String,condition as! String)
                index++
            }
            let result = db.executeUpdate(sql as String)
            if !result {
                print("\(tableName) 删除数据错误")
            }
        }
        
        queue.close()
    }
    
    
    //存储和查询NewsInfo
    
    class func saveNews(dictInfo:NSDictionary) {
        
        let dbFile = ZHGlobal.getUserDBFile()
        //存储
        save(dictContent: dictInfo, primaryKey: "columnid", inTable: TableNews, inDBFile: dbFile)
    }
    
    class func fetchNews(columnID:String) -> NSArray? {
        let dbFile = ZHGlobal.getUserDBFile()
        var dict:NSDictionary = ["columnid":columnID]
        let fields:NSArray = ["columnid","json"]
        let contents = fetchWithCondition(dictCondiction: dict, forFields: fields, inTable: TableNews, inDBfile: dbFile)
        if contents.count > 0 {
            dict = contents.objectAtIndex(0) as! NSDictionary
            dict = FxJsonUtility.jsonValueFromString(dict.objectForKey("json") as! String) as! NSDictionary
            return NewsInfo.getArrayFormDictByID(dict, id: columnID)
        }
        return nil
    }
}