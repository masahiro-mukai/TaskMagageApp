//
//  InputViewController.swift
//  TaskManageApp
//
//  Created by 向正裕 on 2020/01/24.
//  Copyright © 2020 masahiro.mukai. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var category: UITextField!
    
    let realm = try! Realm()
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 内容枠線追加
        self.contentsTextView.layer.borderColor = UIColor.black.cgColor
        self.contentsTextView.layer.borderWidth = 1.0
        self.contentsTextView.layer.cornerRadius = 10
        self.contentsTextView.layer.masksToBounds = true
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する。
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapGesture)
        
        self.titleTextField.text = self.task.title
        self.contentsTextView.text = self.task.contents
        self.datePicker.date = self.task.date
        self.category.text = self.task.category
    }
    
    // DB更新(遷移する際、画面が非表示になる時に呼ばれるメソッド)
     override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.task.category = self.category.text!
            self.realm.add(self.task, update: .modified)
        }
         
        self.setNotification(task: task)
        super.viewWillDisappear(animated)
     }
     
     // タスクのローカル通知を登録する --- ここから ---
     func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
        if self.task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = self.task.title
        }
        if self.task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = self.task.contents
        }
        if self.task.category == "" {
            content.body += "(カテゴリなし)"
        } else {
            content.body += self.task.category
        }
        
        content.sound = UNNotificationSound.default

        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)

         // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }

        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    } // --- ここまで追加 ---

    @objc func dismissKeyboard() {
        // キーボードを閉じる
        view.endEditing(true)
    }

}
