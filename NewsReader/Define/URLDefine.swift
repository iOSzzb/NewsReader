//
//  URLDefine.swift
//  NewsReader
//
//  Created by Harold on 15/8/6.
//  Copyright © 2015年 GetStarted. All rights reserved.
//

let BaseHost = "http://192.168.1.104"
let BasePort = ":80"

let BaseServer = BaseHost + BasePort
let BaseURLPath = "/NewsReader/"
let BaseURL = "\(BaseServer)\(BaseURLPath)"

let LoginURL  =  "\(BaseURL)login.json"
let AdvertURL = "\(BaseURL)/advert.json?width=%ld&height=%ld"
let ColumnURL =  "\(BaseURL)column.json"
let NewsURLFmt = "\(BaseURL)news_%@.json"
let NewsURL = "http://c.m.163.com/nc/article/headline/T1348647853363/0-30.html"
let DetailURLFmt = "http://c.m.163.com/nc/article/%@/full.html"


let HtmlBody = "{{body}}"
let HtmlTitle = "{{title}}"
let HtmlSource = "{{source}}"
let HtmlPTime = "{{ptime}}"
let HtmlDigest = "{{digest}}"
let HtmlSourceURL = "{{source_url}}"
let HtmlEc = "{{ec}}"
let HtmlImage = "<p><img src='%@' style='margin:auto 0; width:100%%;' />"