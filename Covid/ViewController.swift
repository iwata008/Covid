//
//  ViewController.swift
//  Qiita API
//
//  Created by Machi Iwata on 6/13/21.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var lastUpdated: UILabel!
    @IBOutlet weak var positive: UITextField!
    @IBOutlet weak var deaths: UITextField!
    @IBOutlet weak var severe: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = "https://covid19-japan-web-api.now.sh/api//v1/total"
        getData(from: url)
        
    }
    
    private func getData(from url: String) {
        // The API website for Covid-19
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, reponse, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            // have data
            var results: Total?
            do {
                results = try JSONDecoder().decode(Total.self, from: data)
            } catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = results else {
                return
            }
            
            // Got an idea of substring from this website: https://stackoverflow.com/questions/39677330/how-does-string-substring-work-in-swift
            
            let displayDate = json.date
            let strDisplayDate = String(displayDate)
            
            let displayPositive = json.positive
            let strDisplayPositive = String(displayPositive)
            
            let displayDeaths = json.death
            let strDisplayDeaths = String(displayDeaths)
            
            let displaySevere = json.severe
            let strDisplaySevere = String(displaySevere)
            
            let index = strDisplayDate.index(strDisplayDate.startIndex, offsetBy: 4)
            let year = strDisplayDate[..<index]
            
            //print(year)
            
            let start = strDisplayDate.index(strDisplayDate.startIndex, offsetBy: 4)
            let end = strDisplayDate.index(strDisplayDate.endIndex, offsetBy: -2)
            let range = start..<end

            let month = strDisplayDate[range]
            
           // print(month)
            
            let index2 = strDisplayDate.index(strDisplayDate.endIndex, offsetBy: -2)
            let day = strDisplayDate[index2...]
            
            //print(day)
            
            let displayThis = "\(year)-\(month)-\(day)"
            
            DispatchQueue.main.sync {
            self.lastUpdated.text = displayThis
                self.positive.text = strDisplayPositive
                self.deaths.text = strDisplayDeaths
                self.severe.text = strDisplaySevere
            }
            ///////////// END OF THE CODE FOR "Last Updated" ///////////////////
            
            
            
            //print(displayDate)
            
            print(json.severe)
            print(json.positive)
            print(json.death)
        })
        
        task.resume()
    }

    
    struct Total: Codable {
        let date: Int
        let severe: Int
        let positive: Int
        let death: Int
        
    }
    
}

