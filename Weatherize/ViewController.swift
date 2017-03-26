//
//  ViewController.swift
//  Weatherize
//
//  Created by Adrien Maranville on 3/25/17.
//  Copyright © 2017 Adrien Maranville. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var txtBoxCity: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblTemp: UILabel!
    @IBAction func btnSubmitPressed(_ sender: Any) {
        if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=" + txtBoxCity.text!.replacingOccurrences(of: " ", with: "-") + "&APPID=f2d38f5559fad0b8ba0aa05e743cbe9f&lang=en-US") {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
            } else {
                if let urlContent = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        print(jsonResult)
                        print(jsonResult["name"]!!)
                        
                        if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String {
                            
                            DispatchQueue.main.sync(execute: {
                                self.lblResult.text = description
                            })
                        }
                        
                        if let temp = ((jsonResult["main"] as? NSDictionary)?["temp"] as? Double ){
                            
                            DispatchQueue.main.sync(execute: {
                                
                                self.lblTemp.text = String(format: "%.2f",(( temp - 273.15) * 9/5) + 32) + "°F"
                            })
                        }
                        
                        
                    } catch {
                        print("failed processing JSON")
                    }
                }
            }
        }
        task.resume()
        } else {
            lblResult.text = "No weather found"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

