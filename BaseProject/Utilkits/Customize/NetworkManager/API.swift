//
//  API.swift
//  Life
//
//  Created by 杨冀凯 on 2019/6/28.
//  Copyright © 2019 yyy. All rights reserved.
//

import Foundation
import Moya

//MARK: - URL列表
public enum API {
    case home(aParameter: String, bParameter: [String: Any])//示例 带参数
    case mine(aParameter: Int?)//示例
    
    case setting//示例：另一个baseurl
    case login(name: String, pwd: String)//登录
}

extension API: TargetType {
    
    //MARK: - 服务器地址(只使用一个地址时可以去掉switch)
    public var baseURL: URL {
        switch self {
        case .home(_, _), .mine:
            return URL(string: "htttp://abaseUrl")!
        case .setting:
            return URL(string: "htttp://bbaseUrl")!
        case .login:
            return URL (string: "https://mobilemall-test.maya1618.com/")!
        }
    }
    
    //MARK: - 配置各个接口路径
    public var path: String {
        switch self {
        case .home(_, _):
            return "path.path"
        case .mine:
            return "path.path"
        case .setting:
            return "path.path"
        case .login:
            return "mobile/login"
        }
    }
    
    //MARK: - 各个接口请求方式
    public var method: Moya.Method {
        switch self {
        case .home(_, _), .mine:
            return .get
        case .setting:
            return .post
        case .login:
            return .post
        }
    }
    
    //MARK: -  请求任务事件（这里附带上参数）
    public var task: Task {
        // 请求参数初始化
        var param:[String:Any] = [:]
        
        switch self {
        case .home(let aParameter, let bParameter):
            param["aParameter"] = aParameter
            param["bParameter"] = bParameter
            // format编码
            return .requestParameters(parameters: param, encoding: URLEncoding.default)//queryString?
            
        case .mine(let aParameter):
            param["aParameter"] = aParameter
            // json编码
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .setting:
            return .requestPlain
        case .login(let name, let pwd)://登录
            param["loginname"] = name
            param["loginpwd"] = pwd
            param["userFlage"] = 1
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
    //MARK: - 请求头
    public var headers: [String : String]? {
        switch self {
        case .login:
            return ["Content-type": "application/json","mobile_login_token":"b5b9943ecff16c26d5121a0942f1ca8b|tiens"]
        default:
            return ["Content-type": "application/json"]
        }
    }
    
    //MARK: -  这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "".utf8Encoded
    }
    
}
