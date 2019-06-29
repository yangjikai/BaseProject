//
//  String+Extension.swift
//  Life
//
//  Created by tiens on 2019/6/13.
//  Copyright © 2019 yyy. All rights reserved.
//

extension String {
    //转码: urlHostAllowed转义的字符有 "#%/<>?@\^`\{\|\}
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    // 字符串转data:utf8
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
    
    
}
