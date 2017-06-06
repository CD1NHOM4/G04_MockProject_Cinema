//
//  ChangePasssViewController.swift
//  G04_MockProject_Cinema
//
//  Created by THANH on 6/5/17.
//  Copyright © 2017 HCMUTE. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD


class ChangePassViewController: UIViewController {
    
    @IBOutlet weak var txtfOldPass: UITextField!
    @IBOutlet weak var txtfNewPass: UITextField!
    @IBOutlet weak var txtfConfirmPass: UITextField!
    
    var user: User! = nil
    var loadingNotification: MBProgressHUD! = nil
    var mDatabase: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mDatabase = Database.database().reference()
        
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        observerKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnBack_Act(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnChangePass_Act(_ sender: Any) {
        let currentPass: String = txtfOldPass.text!
        let newPass: String = txtfNewPass.text!
        let confirmPass: String = txtfConfirmPass.text!
        
        if (currentPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
            showAlertDialog(message: "Bạn cần điền đầy đủ thông tin")
        }
        else {
            var result: Bool = true;
            //Kiểm Tra độ dài
            if (currentPass.characters.count < 6 || newPass.characters.count < 6 || confirmPass.characters.count < 6){
                result = false;
                showAlertDialog(message: "Mật khẩu phải có ít nhất 6 kí tự");
                return;
            }
            //Kiểm tra Pass hiện tại có đúng
            if (user.password != currentPass) {
                result = false
                showAlertDialog(message: "Mật khẩu không hợp lệ");
                return ;
            }
            
            if (newPass != confirmPass) {
                result = false;
                showAlertDialog(message: "Mật khẩu không trùng khớp");
                return ;
            }
            
            if (result) {
                self.showProgress()
                //Thay đổi Pass
                Auth.auth().currentUser?.updatePassword(to: newPass) { (error) in
                    self.hideProgress()
                    if error == nil {
                        //Cập nhật Pass mới
                        let dataUpdatePass = ["password": newPass];
                        self.mDatabase.child("users").child(self.getUid()).updateChildValues(dataUpdatePass)
                        //Hiện Cảnh Báo
                        let alertView = UIAlertController(title: "Thông Báo", message: "Đổi mật khẩu thành công", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertView.addAction(action)
                        self.present(alertView, animated: true, completion: nil)
                        
                    }
                    else {
                        self.showAlertDialog(message: "Đổi mật khẩu thất bại")
                    }
                }
            }
        }
        
    }
    
    //Hàm lấy ID của User
    func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!;
    }
    //Hiện cảnh báo
    func showAlertDialog(message: String) {
        let alertView = UIAlertController(title: "Thông Báo", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    //Hiện Progress nếu đang trong quá trình xử lí
    func showProgress() {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Đang tải..."
    }
    //Ẩn Progress
    func hideProgress() {
        loadingNotification.hide(animated: true)
    }
    
    //MARK: - Show, Hide Keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtfOldPass.resignFirstResponder()
        txtfConfirmPass.resignFirstResponder()
        txtfNewPass.resignFirstResponder()
        return true
    }
    //
    fileprivate func observerKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(LogInViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(LogInViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    //Ẩn Bàn Phím
    func DismissKeyboard(){
        view.endEditing(true)
    }
    //Hiện bàn phím khi click vào TextField
    func keyboardWillShow(sender: NSNotification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -160, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    //Ẩn Bàn phím
    func keyboardWillHide(sender: NSNotification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
}
