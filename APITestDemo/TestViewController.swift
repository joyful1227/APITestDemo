//
//  TestViewController.swift
//  APITestDemo
//
//  Created by joyy on 2019/8/20.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    
    
    var data: Data?
    var data2: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        data = """
        {
        "success": {
        "total": 1
        },
        "contents": {
        "quotes": [
        {
        "quote": "The best way to not feel hopeless is to get up and do something. Don’t wait for good things to happen to you. If you go out and make some good things happen, you will fill the world with hope, you will fill yourself with hope.",
        "length": "233",
        "author": "Barack Obama",
        "tags": [          "action",          "hope",          "inspire",          "tod"        ],
        "category": "inspire",
        "date": "2019-08-19",
        "permalink": "https://theysaidso.com/quote/barack-obama-the-best-way-to-not-feel-hopeless-is-to-get-up-and-do-something-don",
        "title": "Inspiring Quote of the day",
        "background": "https://theysaidso.com/img/bgs/man_on_the_mountain.jpg",
        "id": "v1_D_2k_NFsdZUhB2xaiZgeF"
        }
        ],
        "copyright": "2017-19 theysaidso.com"
        }
        }
        """.data(using: .utf8)
        
        data2 = """
{
    "error": {
        "code": 429,
        "message": "Too Many Requests: Rate limit of 10 requests per hour exceeded. Please wait for 52 minutes and 36 seconds."
    }
}

""".data(using: .utf8)
        
        do{
            let results = try JSONDecoder().decode(AllData.self, from: data!)
            print("results.contents = \(results.success)")
            print("results.contents..quotes = \(results.contents?.quotes?[0].quote)")
            print("results.contents..author = \(results.contents?.quotes?[0].author)")
            print("results.contents..tags = \(results.contents?.quotes?[0].tags)")
            for tag in results.contents!.quotes![0].tags! {
                print("tag = \(tag)")
            }
            //print("results.contents..quotes = \()")
        
        } catch {
            print(error)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showAlertController(title: String, message: String) {
        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default) { (okAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alerController.addAction(okAction)
        present(alerController, animated: true, completion: nil)
    }
}
