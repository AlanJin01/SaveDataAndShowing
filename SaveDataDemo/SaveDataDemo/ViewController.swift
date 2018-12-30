//
//  ViewController.swift
//  SaveDataDemo
//
//  Created by J K on 2018/12/29.
//  Copyright © 2018 Kims. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    public var names: [String]?
    public var tableView: UITableView!

    var secondView: SecondViewController?
    
    private var edit: Bool! = false
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.     
        
        self.view.backgroundColor = #colorLiteral(red: 1, green: 0.6173290495, blue: 0.452114012, alpha: 1)
        
        let screen = UIScreen.main.bounds
        
        tableView = UITableView(frame: CGRect(x: 0, y: 90, width: screen.size.width - 20, height: screen.size.height))
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = #colorLiteral(red: 0.9851751681, green: 1, blue: 0.9340097336, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 1, green: 0.6173290495, blue: 0.452114012, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        //添加数据按钮
        let btn = UIButton(frame: CGRect(x: screen.size.width - 120, y: 20, width: 100, height: 50))
        btn.setTitle("Add", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btn.setTitleColor(#colorLiteral(red: 0.1911978513, green: 0.5195309165, blue: 1, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(ViewController.addButton), for: .touchUpInside)
        self.view.addSubview(btn)
        
        //编辑按钮
        let editBtn = UIButton(frame: CGRect(x: 30, y: 20, width: 100, height: 50))
        editBtn.setTitle("edit", for: .normal)
        editBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        editBtn.setTitleColor(#colorLiteral(red: 0.1911978513, green: 0.5195309165, blue: 1, alpha: 1), for: .normal)
        editBtn.addTarget(self, action: #selector(ViewController.editButton), for: .touchUpInside)
        self.view.addSubview(editBtn)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        names = secondView?.fetchData()
        tableView.reloadData()
    }
    
    //点击编辑按钮时调用的方法
    @objc func editButton() {
        if edit == false {
            tableView.setEditing(true, animated: true)
            edit = !edit
        }else if edit == true {
            tableView.setEditing(false, animated: true)
            edit = !edit
        }
    }

    //添加数据按钮
    @objc func addButton() {
        self.secondView = SecondViewController()
        self.present(secondView!, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //从数据库中删除数据
            secondView?.deleteFromCoreData(names![indexPath.row])
            
            self.names?.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .right)
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "id"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = names![(indexPath as NSIndexPath).row]
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.textColor = UIColor.white

        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if names != nil {
            return names!.count
        }else {
            return 0
        }
    }

}

