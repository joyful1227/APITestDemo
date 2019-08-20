//
//  SecondViewController.swift
//  APITestDemo
//
//  Created by Joy on 2019/8/19.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit
import Alamofire

class SecondViewController: UIViewController {

    
    @IBOutlet weak var userIMGImageView: UIImageView!
    @IBOutlet weak var userAccountTopLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cameraButton: UIButton!
    
    let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    var userObject: User?
    var image: UIImage?
    
    var urlString: String?
    var urlCategory: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         view.addSubview(activityIndicatorView)
        
         cameraButton.isHidden = false
         photoImageView.isHidden = false
         if let userObject = userObject {
             userIMGImageView.image = userObject.userIMG
             userAccountTopLabel.text = userObject.userAccount
             urlCategory = userObject.category
             urlString = "https://quotes.rest/qod.json?category=\(urlCategory!)"
            
            activityIndicatorView.center = view.center
            activityIndicatorView.startAnimating()
             Alamofire.request(urlString ?? "").responseJSON { (response) in
                if response.result.isSuccess {
//                    print("Got data")
//                    print(response.value ?? "")

                    
                    guard let data = response.data else {return}
                    
                    do{
                        let results = try JSONDecoder().decode(AllData.self, from: data)
                        
                        var quoteText = ""
                        var authorText = ""
                        var tagsText = ""
                        var resultText = ""
                        quoteText = results.contents?.quotes?[0].quote ?? ""
                        authorText = results.contents?.quotes?[0].author ?? ""
                        if !results.contents!.quotes![0].tags!.isEmpty {
                          for tag in results.contents!.quotes![0].tags! {
                              tagsText = tagsText + "#\(tag)"
                          }
                        }
                        resultText = "\(quoteText)\n\(authorText)\n\n\(tagsText)"
                        self.textView.text = resultText
//                        print("results.contents = \(results.contents)")
//                        print("results.contents..quotes = \(results.contents?.quotes?[0].quote)")
//                        print("results.contents..author = \(results.contents?.quotes?[0].author)")
//                        print("results.contents..tags = \(results.contents?.quotes?[0].tags)")
//
                       
                        self.activityIndicatorView.removeFromSuperview()
                    } catch {
                        print(error)
                        self.activityIndicatorView.removeFromSuperview()
                        //self.showAlertController(title: "ohoh發生錯誤", message: "請稍後再試")
                    }
                    

                }else {
                    //self.showAlertController(title: "串接錯誤", message: "請稍後再試")
                    self.activityIndicatorView.removeFromSuperview()
                    print("Couldn't get data,\(String(describing: response.result.error))")
                }
                
            }
         }
        userIMGImageView.clipsToBounds = true
        userIMGImageView.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        
        
        
    }
    

    
    @IBAction func clickCameraButton(_ sender: Any) {
        let alertController = UIAlertController(title: "新增照片從", message: nil, preferredStyle: .actionSheet)
        
        let options = ["相機", "照片"]
        for option in options {
            let action = UIAlertAction(title: option, style: .default) { (action) in
                //print(action.title!)
                
                switch (action.title) {
                case "相機":
                    self.showCamera()
                case "照片":
                    self.showAlbum()
                default:
                    print("select on action sheet fail")
                }
            }
            alertController.addAction(action)
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            //..
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func clickSave(_ sender: UIBarButtonItem) {
        if let uiimage = takeScreenshot() {
            UIImageWriteToSavedPhotosAlbum(uiimage, nil, nil, nil)
        }
        
    }
    
    func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    

}
//照片控制
extension SecondViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true // 可對照片作編輯
            //cameraPicker.sourceType = .camera
            present(cameraPicker, animated: true, completion: nil)
        }else {
            print("沒有相機鏡頭...") // 用alertView.show
        }
    }
    
    
    func showAlbum() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let albumPicker = UIImagePickerController()
            albumPicker.delegate = self
            //albumPicker.sourceType = .photoLibrary
            present(albumPicker, animated: true, completion: nil)
        }else {
            print("使用相簿...") // 用alertView.show
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[.originalImage] as? UIImage {
            image = photo
            photoImageView.image = photo
            photoImageView.isHidden = false
            cameraButton.isHidden = true
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
extension SecondViewController {
    
    func showAlertController(title: String, message: String) {
        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default) { (okAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alerController.addAction(okAction)
        present(alerController, animated: true, completion: nil)
    }
}
