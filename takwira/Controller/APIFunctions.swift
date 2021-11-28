//
//  APIFunctions.swift
//  takwira
//
//  Created by Nizar on 21/11/2021.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class APIFunctions {
    static let shareInstance = APIFunctions()
    let url: String = "192.168.1.7";
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
            
          print(String(data: data, encoding: .utf8)!)
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
    
    
}
