//
//  ViewController.swift
//  APITestDemo
//
//  Created by Joy on 2019/8/17.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    enum  Category: Int {
        case inspire
        case life
        case love
        case funny
    }
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var suggestion1: UILabel!
    @IBOutlet weak var suggestion2: UILabel!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var segmentButton: UISegmentedControl!
    
    var image: UIImage? //接使用者選取的照片
    var userObject: User?
    var currentSegment: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image = nil
        textfield.text = ""
        userObject = nil
        goButton.layer.cornerRadius = 10
        
        currentSegment = "inspire"
        
        //鍵盤
        let tapScrollView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tapScrollView)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        suggestion1.text = ""
        suggestion2.text = ""
        
    }

    @IBAction func clickButton(_ sender: UIButton) {
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
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        suggestion1.text = ""
        suggestion2.text = ""
        
        var isValid = true
        let intextfield = textfield.text == nil ? "" : textfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if intextfield.isEmpty {
            suggestion1.text = "請填寫帳號名稱"
            isValid = false
        }
        
        if image == nil {
            suggestion2.text = "請上傳大頭貼"
            isValid = false
        }
        
        if isValid == true {
            userObject = User(userAccount: intextfield, userIMG: image!, category: currentSegment )
           
            return true
        }else{
            return false
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! SecondViewController
        controller.userObject = userObject
        
    }
    
    
    @IBAction func clickSegmented(_ sender: UISegmentedControl) {
        
        switch Category(rawValue: sender.selectedSegmentIndex)! {
        case .inspire:
            currentSegment = "inspire"
        case .life:
            currentSegment = "life"
        case .love:
            currentSegment = "love"
        case .funny:
            currentSegment = "funny"
        }
    }
    
    
}
//照片控制
extension ViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {

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
            photoButton.setImage(photo, for: .normal)
            photoButton.setTitle("", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
extension ViewController: UITextFieldDelegate {
    
    
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //要求他響應我們的Responder
        return true
    }
}
