//
//  MatchAPI.swift
//  takwira
//
//  Created by Nizar on 25/12/2021.
//

import Foundation
import Alamofire
import UIKit.UIImage

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class MatchAPI {
    static let shareInstance = MatchAPI()
    let url: String = HOST;
    
    
    func addStade(name: String, capacity: Int, price: Float, location: String, phone: String, datetime: String) -> String{
        var status: String?
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "name="+name+"&capacity="+String(capacity)+"&price="+String(price)+"&location="+location+"&phone="+phone+"&DateTime="+datetime
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: url+"/api/stades/")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            status = String(data: data, encoding: .utf8)!
          //print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        return status!
    }
    
    func stadeImage(id: String,photo: UIImage, completion: @escaping (_ error: Error?, _ success: Bool)->Void) {
        let link = url+"/api/stades/"+id
        
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
    
    func autojoinmatch(teamcapacity: Int, stadeId: String, userId: String) {
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "teamCapacity="+String(teamcapacity)+"&stadeId="+stadeId+"&userId="+userId
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: url+"/api/match/")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
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
    
    func getStades() -> Array<StadeModel>{
        var matches = [StadeModel]()

        var semaphore = DispatchSemaphore (value: 0)

        let parameters = ""
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: url+"/api/stades/")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            do {
                matches = try JSONDecoder().decode(Array<StadeModel>.self, from: data)
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
    
    
   
    func findmatchwithstadeid(stadeid: String)-> MatchModel {
        var semaphore = DispatchSemaphore (value: 0)
        var match = MatchModel()
        let parameters = ""
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: url+"/api/match/"+stadeid)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            do {
                match = try JSONDecoder().decode(MatchModel.self, from: data)
                //print(user._id)
                
            } catch let err {
                print(err)
            }
          //print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        return match
    }
    
    
    func canceljointeamA(userid: String, matchid: String) {
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "userId="+userid+"&team=teamA"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: url+"/api/match/"+matchid)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "PATCH"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    
    
    func jointeamA(userid: String, matchid: String) {
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "userId="+userid+"&team=teamA"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: url+"/api/match/"+matchid)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "PUT"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    
    
    func jointeamB(userid: String, matchid: String) {
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "userId="+userid+"&team=teamB"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: url+"/api/match/"+matchid)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "PUT"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    
    func canceljointeamB(userid: String, matchid: String) {
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "userId="+userid+"&team=teamB"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: url+"/api/match/"+matchid)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "PATCH"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    
    
    
    func getallmatches() -> Array<MatchModel> {
        var matches = [MatchModel]()

        var semaphore = DispatchSemaphore (value: 0)

        let parameters = ""
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: url+"/api/match/")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            do {
                matches = try JSONDecoder().decode(Array<MatchModel>.self, from: data)
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
    
    
    func getstadebyid(stadeid: String) -> StadeModel {
        
        var semaphore = DispatchSemaphore (value: 0)
        var stade = StadeModel()
        let parameters = ""
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: url+"/api/stades/"+stadeid)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            do {
                stade = try JSONDecoder().decode(StadeModel.self, from: data)
                //print(user._id)
                
            } catch let err {
                print(err)
            }
          //print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        return stade
    }
    
}
