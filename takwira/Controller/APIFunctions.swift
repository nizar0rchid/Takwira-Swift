//
//  APIFunctions.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import Foundation
import Alamofire
import UIKit.UIImage
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class APIFunctions {
    static let shareInstance = APIFunctions()
    let url: String = "192.168.1.9";
    
    
    func checkinternet() -> Int {
        var status: Int = 0
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = ""
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://"+url+":3000/api/")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            status = (response as! HTTPURLResponse).statusCode
          
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        return status
    }
    
    
    
    
    
    
    ///// REGISTER
    func Register(user : userModel) -> Int{
        
        var status: Int = 0;
        var semaphore = DispatchSemaphore (value: 0)

        let param1 = "firstName="+user.firstName!+"&lastName="+user.lastName!+"&email="+user.email!
        let param2 = "&password="+user.password!+"&age="+String(user.age!)
        let param3 = "&phone="+user.phone!+"&location="+user.location!+"&role="+user.role!
        let parameters = param1+param2+param3
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://"+url+":3000/api/users")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
          guard let data = data else {
            
            print(String(describing: error))
            semaphore.signal()
            return
          }
            status = (response as! HTTPURLResponse).statusCode
            
          //print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return status
    }
    
    
    ////// Login
    func login(email: String , password: String) -> userModel {
        
        var user = userModel()
        
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "email="+email+"&password="+password
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://"+url+":3000/api/login/")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            do {
                user = try JSONDecoder().decode(userModel.self, from: data)
                
                
            } catch let err {
                print(err)
            }
            
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }
        

        task.resume()
        semaphore.wait()
        return user
    }
    
    //// update profile
    func updateProfile(_id : String, firstname: String, lastname: String, email: String, age: Int, phone: String, location: String, password: String, role : String) {
        var semaphore = DispatchSemaphore (value: 0)
        
        let param1 = "firstName="+firstname+"&lastName="+lastname+"&email="+email
        let param2 = "&password="+password+"&age="+String(age)
        let param3 = "&phone="+phone+"&location="+location+"&role="+role
        let parameters = param1+param2+param3
        
        
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://"+url+":3000/api/users/"+_id)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "PUT"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
 
    ///// get live matches
    func liveMatches() -> Array<liveMatchModel> {
        var matches = [liveMatchModel]()
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = ""
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://"+url+":3000/api/live/")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            do {
                matches = try JSONDecoder().decode(Array<liveMatchModel>.self, from: data)
                //print(matches)
                
                
            } catch let err {
                print(err)
            }
          //print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        return matches
    }
    
    
    func finduserbyid(id : String) -> userModel {
        var semaphore = DispatchSemaphore (value: 0)
        var user = userModel()
        let parameters = ""
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://"+url+":3000/api/users/"+id)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            
            do {
                user = try JSONDecoder().decode(userModel.self, from: data)
                //print(user._id)
                
            } catch let err {
                print(err)
            }
            
          
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        return user
    }
    
    
    
    func findbyemail(email : String) -> userModel {
        
        var semaphore = DispatchSemaphore (value: 0)
        var user = userModel()
        let parameters = ""
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://"+url+":3000/api/find/"+email)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            do {
                user = try JSONDecoder().decode(userModel.self, from: data)
                //print(user._id)
                
            } catch let err {
                print(err)
            }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        return user
    }
    
    
    
    func image(id: String,photo: UIImage, completion: @escaping (_ error: Error?, _ success: Bool)->Void ){
        
        let link="http://"+url+":3000/api/users/"+id
        
        AF.upload(multipartFormData: { (form: MultipartFormData) in
            
            if let data = photo.jpegData(compressionQuality: 0.5) {
                form.append(data, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
            
            
        }, to: link, usingThreshold: MultipartFormData.encodingMemoryThreshold, method: .put, headers: nil)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseData { response in
            switch response.result {
            case .success:
                print("Success")
                completion(nil,true)
            case let .failure(error):
                completion(nil,false)
                print(error)
            }
        }
    }
    
    
   
        
        
    



}
        
        
    



