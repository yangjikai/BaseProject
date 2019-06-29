//
//  NetWorkManager.swift
//  Life
//
//  Created by 杨冀凯 on 2019/6/28.
//  Copyright © 2019 yyy. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import HandyJSON

//public let timedOut: Int = NSURLErrorTimedOut
//public let netWrong: Int = NSURLErrorNotConnectedToInternet
public let timedOut: String = "The request timed out."
public let netWrong: String = "The Internet connection appears to be offline."



/**
 JSONEncoding、URLEncoding简单解释:
 1、JSONEncoding.default 是放在HttpBody内的，   比如post请求
 2、URLEncoding.default 在GET中是拼接地址的，    比如get请求
 3、URLEncoding(destination: .methodDependent) 是自定义的URLEncoding，methodDependent的值如果是在GET 、HEAD 、DELETE中就是拼接地址的。其他方法方式是放在httpBody内的。
 4、URLEncoding(destination: .httpbody)是放在httpbody内的
 */

/// 开启log
private var openLog: Bool = true
/// 超时时长
private var requestTimeOut: Double = 5
///请求结束的回调
typealias finishedCallback = ((_ result: Any?, _ errorCode: Int?, _ success: Bool) -> (Void))

//MARK: - 网络请求的基本设置
private let yEndpointClosure = { (target: API) -> Endpoint in
    ///这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug https://github.com/Moya/Moya/issues/1198
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    
    /**
    ///附加参数
    let additionalParameters = ["token":"888888"]
    let defaultEncoding = URLEncoding.default
    switch target.task {
        ///在你需要添加的请求方式中做修改就行，不用的case 可以删掉。。
    case .requestPlain:
        task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
    case .requestParameters(var parameters, let encoding):
        additionalParameters.forEach { parameters[$0.key] = $0.value }
        task = .requestParameters(parameters: parameters, encoding: encoding)
    default:
        break
    }
    */
    
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    return endpoint
    
    /**
    //可单独设置超时时间
    switch target {
    default:
        return endpoint
    }
     */
}

//MARK: -  网络请求的设置
private let yRequestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        if openLog {
            print("请求地址: \(String(format: "%@", request.url! as CVarArg))\n请求参数: \(String(data:request.httpBody ?? Data(), encoding: String.Encoding.utf8) ?? "")\n请求方式: \(request.httpMethod ?? "获取失败")\n\n")
        }
        
        //设置请求时长
        request.timeoutInterval = requestTimeOut
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
        
    }
}

//MARK: - 配置Manager
private let yManager = { () -> Manager in
    let configuration = URLSessionConfiguration.default
    //Alamofire.SessionManager.defaultHTTPHeaders
    configuration.httpAdditionalHeaders = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
    
    var manager = Alamofire.SessionManager(configuration: configuration)
    manager.startRequestsImmediately = false
    return manager
}


//MARK: - 初始化方法，创建网络请求对象
private let Provider = MoyaProvider<API>(endpointClosure: yEndpointClosure, requestClosure: yRequestClosure, manager: yManager(), plugins: [])


//MARK: - 网络连接错误的回调、连接失败
func NetWorkRequest(_ target: API, completion: @escaping finishedCallback) {
    //先判断网络是否有链接
    if !isNetworkConnect{
        //可以回调baseVC展示网络失败的页面
        currentViewController().view.makeToast("网络连接失败，请稍后重试")
        completion(nil, nil, false)
        return
    }
    /**
    //这里单独定制显示的loading图、刷新
    switch target {
    default:
        currentViewController().view.makeToastActivity(.center)
    }
    */
    currentViewController().view.makeToastActivity(.center)
    
    Provider.request(target) { (result) in
        //隐藏loading
        currentViewController().view.hideToastActivity()
        
        /*
        //也可以在这停止刷新，仅适用于文案统一的app
        switch target {
        case .home(_,_):
            break
        default:
            break
        }
        */
        
        switch result {
        case let .success(response):
            do {
                //过滤200-299的状态码
                let response = try response.filterSuccessfulStatusCodes()
                let data = try response.mapJSON()
                if openLog {
                    print("响应地址: \(String(describing: response.request?.url))\n响应参数: \(String(data:response.request?.httpBody ?? Data(), encoding: String.Encoding.utf8) ?? "")\n响应方式: \(response.request?.httpMethod ?? "获取失败")\n状态码: \(response.statusCode)\n响应结果: \(data)")
                }
                completion(data, response.statusCode, true)
            }
            catch {
                //响应状态码
                let statusCode: Int = response.statusCode
                
                if openLog {
                    print("响应地址: \(String(describing: response.request?.url))\n响应参数: \(String(data:response.request?.httpBody ?? Data(), encoding: String.Encoding.utf8) ?? "")\n响应方式: \(response.request?.httpMethod ?? "获取失败")\n状态码: \(statusCode)\n响应结果: 无")
                }
                
                switch statusCode {
                case 401:
                    currentViewController().view.makeToast("401、没有权限、密码错误、跟后台沟通确认")
                    completion(nil, 401, false)
                    
                case 404:
                    currentViewController().view.makeToast("404、资源不存在、跟后台沟通确认")
                    completion(nil, 404, false)
                    
                case 500:
                    currentViewController().view.makeToast("500、服务器错误、跟后台沟通确认")
                    completion(nil, 500, false)
                    
                case 503:
                    currentViewController().view.makeToast("503、服务不可用、跟后台沟通确认")
                    completion(nil, 503, false)
                    
                default:
                    currentViewController().view.makeToast("网络连接失败，请稍后重试")
                    completion(nil, statusCode, false)
                }
            }
            
        case let .failure(error):
            //错误语句
            //状态码不知道为啥获取总不对
            let errorStr: String = error.localizedDescription
            print(errorStr)
            if openLog {
                print("响应地址: \(String(describing: error.response?.request?.url))\n响应参数: \(String(data:error.response?.request?.httpBody ?? Data(), encoding: String.Encoding.utf8) ?? "")\n响应方式: \(error.response?.request?.httpMethod ?? "获取失败")\n状态码: \(error.errorCode)\n响应结果: \(error.localizedDescription)")
            }
            
            switch errorStr {
                case timedOut:
                    currentViewController().view.makeToast("网络连接超时，请稍后重试")
                    completion(error.localizedDescription, error.errorCode, false)

                case netWrong:
                    currentViewController().view.makeToast("网络连接失败，请稍后重试")
                    completion(error.localizedDescription, error.errorCode, false)

                default:
                    currentViewController().view.makeToast("网络连接失败，请稍后重试")
                    completion(error.localizedDescription, error.errorCode, false)

            }
        }
    }
}


/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用get方法是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
var isNetworkConnect: Bool {
    get{
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true //无返回就默认网络已连接
    }
}
