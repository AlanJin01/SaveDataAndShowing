//
//  SecondViewController.swift
//  SaveDataDemo
//
//  Created by J K on 2018/12/29.
//  Copyright © 2018 Kims. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITextFieldDelegate {

    weak var viewControl: ViewController?
    
    private var textField: UITextField!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 1, green: 0.6422509587, blue: 0.7232809123, alpha: 1)
        // Do any additional setup after loading the view.
        
        let screen = UIScreen.main.bounds
        
        //输入框
        textField = UITextField(frame: CGRect(x: 30, y: 100, width: self.view.bounds.width - 100, height: 50))
        textField.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 50)
        textField.placeholder = "input username"
        textField.isSecureTextEntry = false
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.keyboardAppearance = .light
        textField.keyboardType = .default
        textField.borderStyle = .roundedRect
        textField.delegate = self
        self.view.addSubview(textField)
        
        //确定按钮同时保存
        let btn = UIButton(frame: CGRect(x: 30, y: 100, width: 100, height: 50))
        btn.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 70)
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.4280448963, blue: 0.2502456348, alpha: 1)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 16.0
        btn.setTitle("Save", for: .normal)
        btn.addTarget(self, action: #selector(SecondViewController.saveButton), for: .touchUpInside)
        self.view.addSubview(btn)
        
        //返回按钮
        let backBtn = UIButton(frame: CGRect(x: screen.size.width - 120, y: 20, width: 100, height: 50))
        backBtn.setTitleColor(#colorLiteral(red: 0.1911978513, green: 0.5195309165, blue: 1, alpha: 1), for: .normal)
        backBtn.setTitle("Back", for: .normal)
        backBtn.addTarget(self, action: #selector(SecondViewController.backButton), for: .touchUpInside)
        self.view.addSubview(backBtn)
    }
    
    //删除数据
    func deleteFromCoreData(_ name: String) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: manageContext)
        
        let request = NSFetchRequest<User>(entityName: "User")
        request.fetchOffset = 0
        request.fetchLimit = 20
        request.entity = entity
        request.predicate = NSPredicate(format: "userName='\(name)'", argumentArray: nil)
        do {
            let results = try manageContext.fetch(request)
            for user in results as! [User] {
                manageContext.delete(user)
            }
            try manageContext.save()
        }catch {
            print("删除数据失败")
        }
    }
    
    //返回保存的数据
    func fetchData() -> [String]{
        var n = [String]()
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: manageContext)
        
        let request = NSFetchRequest<User>(entityName: "User")
        request.fetchOffset = 0
        request.fetchLimit = 20
        request.entity = entity
        request.predicate = nil
        do {
            let results = try manageContext.fetch(request)
            for user: User in results as! [User] {
                n.append(user.userName!)
            }
        }catch {
            print("读取数据失败")
        }
        return n
    }
    
    //保存数据到CoreData
    func coreDataFunction() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: manageContext) as! User
        newUser.userName = textField.text
        do {
            try manageContext.save()
            print("保存成功")
        }catch {
            print("保存数据出错")
        }
    }
    
    //返回主界面
    @objc func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //点击后执行的方法
    @objc func saveButton() {
        if textField.hasText {
            coreDataFunction()
            
            let fetch = fetchData()
            viewControl?.names = fetch       
        }
    }
    
    //收回键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
