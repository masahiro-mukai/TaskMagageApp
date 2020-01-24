//
//  InputViewController.swift
//  TaskManageApp
//
//  Created by 向正裕 on 2020/01/24.
//  Copyright © 2020 masahiro.mukai. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 内容枠線追加
        self.contentsTextView.layer.borderColor = UIColor.black.cgColor
        self.contentsTextView.layer.borderWidth = 1.0
        self.contentsTextView.layer.cornerRadius = 10
        self.contentsTextView.layer.masksToBounds = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
