//
//  ApiManager.swift
//  RxSwiftMVVMDemo
//
//  Created by Bhavnish on 31/05/22.
//  Copyright © 2021 Bhavnish Mac. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift


class ApiManager: NSObject {
    var parameters = Parameters()
    var headers = HTTPHeaders()
    var method: HTTPMethod!
    var url = String()
    var encoding: ParameterEncoding! = JSONEncoding.default
    var multipartBody = [MultipartFormData]()
    var multipartData: MulitPartParam?
    init<T: TargetType>(targetData: T) {
        super.init()
        targetData.data.forEach { parameters.updateValue($0.value, forKey: $0.key)}
        targetData.headers.forEach({self.headers.add(name: $0.key, value: $0.value)})
        self.url = ApisURL.baseURl + targetData.service
        if !targetData.isJSONRequest {
            encoding = URLEncoding.default
        }
        self.method = targetData.method
        self.multipartData = targetData.multipartBody
        Logger.sharedInstance.logMessage(message: "method:-\(self.method.rawValue)\n URL: \(ApisURL.baseURl + targetData.service)\nparameters: \(self.parameters)\n Headers: \(headers)", .info)
    }
    
    func executeQuery<T>(completion: @escaping (_ model: T) -> Void, error errorCallBack: ((String?) -> Void)? = nil) where T: Codable {
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseData(completionHandler: { response in
            self.handleResponse(response: response, completion: completion, error: errorCallBack)
        })
    }
    func errorHandler(data: Data) -> String? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let response = json
            return response?["message"] as? String ?? ""
        } catch {
            Logger.sharedInstance.logMessage(message: String(data: data, encoding: .utf8) ?? "nothing received")
        }
        return "Invalid Error"
    }
    func requestMultiPartURL<T>(completion: @escaping (_ model: T) -> Void, error errorCallBack: ((String?) -> Void)? = nil) where T: Codable {
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in self.parameters {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                    print("[\(temp): \(key)]")
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                    print("[\(temp): \(key)]")
                }

                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            /// Make Compression
            if self.multipartData?.mimeType == .image {
                if let imgArr = self.multipartData?.imgArr {
                    for imgSafe in imgArr {
                        let random = Int.random(in: 0..<Int.random(in: 0..<1000000000))
                        let data = imgSafe.jpegData(compressionQuality: 0.3) ?? Data()
                        multiPart.append(data, withName: "image", fileName: "swift_file\(random).jpeg", mimeType: self.multipartData?.mimeType?.rawValue)
                    }
                }
            } else if self.multipartData?.mimeType == .pdfFile  {
                do {
                    guard let fileURl = self.multipartData?.docFile else { return }
                    let data = try Data.init(contentsOf: fileURl)
                    multiPart.append(data, withName: "files", fileName: self.multipartData?.fileName ?? "", mimeType: self.multipartData?.mimeType?.rawValue)
                } catch {
                    Logger.sharedInstance.logMessage(message: "MulipartData failed to upload")
                }
            } else if self.multipartData?.mimeType == .videoFile  {
                do {
                    guard let fileURl = self.multipartData?.docFile else { return }
                    let data = try Data.init(contentsOf: fileURl)
                    multiPart.append(data, withName: "video", fileName: self.multipartData?.fileName ?? "", mimeType: nil)
                } catch {
                    Logger.sharedInstance.logMessage(message: "MulipartData failed to upload")
                }
            }
            
        }, to: url, usingThreshold: UInt64.init(),
        method: self.method,
        headers: headers)
        .uploadProgress(queue: .main, closure: { progress in
            // Current upload progress of file
            Logger.sharedInstance.logMessage(message: "Upload Progress: \(progress.fractionCompleted)")
        }).responseData(completionHandler: { response in
            self.handleResponse(response: response, completion: completion, error: errorCallBack)
        })
    }
    func handleResponse<T>(response: AFDataResponse<Data>, completion: @escaping (_ model: T) -> Void, error errorCallBack: ((String?) -> Void)? = nil) where T: Codable {
        Logger.sharedInstance.logMessage(message: "response status code:-\(response.response?.statusCode ?? 0)\n response status message: \(response.data?.html2String ?? "")", .info)
        switch response.result {
        case .success(let res):
            if let code = response.response?.statusCode {
                switch code {
                case 200...299:
                    do {
                        completion(try JSONDecoder().decode(T.self, from: res))
                    } catch let error {
                        print(error)
                        Logger.sharedInstance.logMessage(message: error.localizedDescription)
#if DEBUG
                        errorCallBack?((self.errorHandler(data: response.data ?? Data()) ?? "")
                                       + "\n Status code: \(code)"
                                       + "\n \(error.localizedDescription)")
#else
//                        errorCallBack?("\(error.)")
#endif
                        
                    }
                case 403, 401:
                    let msg = self.errorHandler(data: response.data ?? Data()) ?? ""
                    // do here
                case 400, 404, 409, 500, 502, 503, 504, 522, 422:
                    let msg = self.errorHandler(data: response.data ?? Data()) ?? ""
                  #if DEBUG
                    errorCallBack?(msg + "\n Status code: \(code)")
                   #else
                    errorCallBack?(msg)
                #endif
                default:
                    // let error = NSError(domain: response.debugDescription, code: code, userInfo: response.response?.allHeaderFields as? [String: Any])
                    errorCallBack?("\(code): That's an error")
                }
            }
        case .failure(let error):
            errorCallBack!(error.localizedDescription)
        }
    }
    
    // MARK: - Logout
    func logoutAction() {
        standard.setValue(false, forKey: "isUserLogin")
        standard.setValue(false, forKey: "isSkipLogin")
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        loginToken = ""
    }
  
}

protocol TargetType {
    /// data for body or url encoding
    var data: [String: Any] { get }
    /// required header
    var headers: [String: String] { get }
    /// endpoint url
    var service: String { get }
    /// method of api
    var method: HTTPMethod { get }
    /// do false if required url encoding
    var isJSONRequest: Bool { get }
    /// multipartData
    var multipartBody: MulitPartParam? { get }
}
struct MulitPartParam {
    var imgArr: [UIImage]?
    var fileName: String?
    var docFile: URL?
    var mimeType: MimeType?
    init(imgArr: [UIImage]?, fileName: String?, docFile: URL?, mimeType: MimeType?) {
        self.imgArr = imgArr
        self.fileName = fileName
        self.docFile = docFile
        self.mimeType = mimeType
    }
}
enum MimeType: String {
    case image = "image/jpeg"
    case pdfFile = "file/pdf"
    case videoFile = "video/mp4"
    case other
}
var currentMimeType: MimeType = .image
enum UploadFileType {
    case documents
    case medicalFiles
}
var currentUploadFileType: UploadFileType = .documents
