//
//  BaseOperation.swift
//  NewsReader
//
//  Created by Harold on 15/8/6.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

import Foundation
import UIKit
@objc protocol ZHOperationDelegate{
    func opSuccess(data:AnyObject)
    func opFail(errorMessage:NSString)
    optional func opSuccessEx(data:AnyObject,opInfo:NSDictionary)
    optional func opFailEx(errorMessage:String,opInfo:NSDictionary)
    optional func opSuccessMatch(data:NSData)
    optional func upLoadSucess()
}

class ZHOperation:NSObject,NSURLConnectionDataDelegate{
    var _delegate:ZHOperationDelegate
    var _connection:NSURLConnection?
    var _receiveData:NSMutableData?
    var _statusCode:NSInteger?
    var _totalLength:Int64
    var _opInfo:NSDictionary
    
    init(initwithdelegate delegate:ZHOperationDelegate,opInfo:NSDictionary){
        _opInfo = opInfo
        _delegate = delegate
        _totalLength = 0
    }
    
    func cancelOp(){
        if _connection != nil{
            print("_conection canceled")
            _connection?.cancel()
        }else{
            _connection = nil
        }
    }
    
    func timeOutInterval() -> NSTimeInterval{
        return ZhRequestTimeOut
    }
    
    func urlRequest() -> NSMutableURLRequest{
        let urlString:String = _opInfo.objectForKey("url") as! String
        let body = _opInfo.objectForKey("body")
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        print(urlString)
        if body != nil {
            request.HTTPMethod = HTTPPOST
            if body?.isKindOfClass(NSString) == true  {
                request.HTTPBody = body?.dataUsingEncoding(NSUTF8StringEncoding)
                print(body)
            }else{
               request.HTTPBody = body as? NSData
            }
        }else{
            request.HTTPMethod = HTTPGET
        }
        request.timeoutInterval = self.timeOutInterval()
        
        return request
    }
    
    func executeOp() {
        self._connection = NSURLConnection(request: self.urlRequest(), delegate: self)
    }
    
    func parseData(data:NSData){
        if data.length <= 0 {
            self.parseSuccess(NSDictionary(), jsonstring: NSString())
            return
        }
        
        let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        let dict:NSMutableDictionary = FxJsonUtility.jsonValueFromString(jsonString) as! NSMutableDictionary
        let result = dict.objectForKey(NetResult) as! NSString
        if result.isEqualToString(NetOK) {
            self.parseSuccess(dict, jsonstring: jsonString)
        }else{
            self.parseFail(dict)
        }
        _receiveData = nil
    }
    
    func parseSuccess(dict:NSDictionary,jsonstring:NSString){
        _delegate.opSuccess(dict)
    }
    
    func parseProgress(receiveLength:Int){
        
    }
    
    func parseFail(dict:AnyObject){
        if dict.isKindOfClass(NSString) {
            _delegate.opFail(dict as! NSString)
            return
        }
        if dict.objectForKey(NetResult)?.isEqualToString(NetInvalidateToken) == true {
            print(NetInvalidateToken)
        }
        _delegate.opFail(dict.objectForKey(NetMessage) as! NSString)
    }
    
    //MARK:NSURLConnectionDataDelegate methods
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        let _response = response as? NSHTTPURLResponse
        _statusCode = _response?.statusCode
        _receiveData = NSMutableData();
        if _statusCode == 200 || _statusCode == 206 {
            _totalLength = response.expectedContentLength
        }
        print(_statusCode)
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        print(data.length)
        _receiveData?.appendData(data)
//        self.parseProgress((_receiveData?.length)!)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        print(NSString(data: _receiveData!, encoding: NSUTF8StringEncoding) )
        if (_statusCode == 200 || _statusCode == 204 || _statusCode == 206) {
            self.parseData(_receiveData!)
        }else{
            var errorMessage = NSString(data: _receiveData!, encoding: NSUTF8StringEncoding)
            
            if errorMessage?.length <= 0 {
                errorMessage = NSString(format: "ResponseCode:%d", _statusCode!)
            }
            self.parseFail(errorMessage!)
        }
        _connection = nil
        _receiveData = nil
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.parseFail(error.localizedDescription)
        
        _connection = nil
        _receiveData = nil
    }
    
    
    
}
