//
//  LoginViewController.swift
//  G04_MockProject_Cinema
//
//  Created by THANH on 6/5/17.
//  Copyright © 2017 HCMUTE. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtfEmailSignIn: LoginTextField!
    @IBOutlet weak var txtfPassSignIn: LoginTextField!
    var loadingNotification: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.DismissKeyboard))
        view.addGestureRecognizer(dismiss)
        observerKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Hiện Progresss đang tải
    func showProgress() {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = " Đang tải..."
    }
    //Ẩn Progress
    func hideProgress() {
        loadingNotification.hide(animated: true)
    }
    //Xử lí sự kiện khi nhấn btnLogin
    @IBAction func btnLogin_Act(_ sender: Any) {
        let email: String = txtEmailSignIn.text!
        let password: String = txtPassSignIn.text!
        
        if (email.isEmpty || password.isEmpty) {
            showAlertDialog(message: "Hãy điền đầy đủ thông tin");
        }
        else {
            if !(Validate.isValidEmail(testStr: email)) {
                self.showAlertDialog(message: "Sai định dạng Email")
            }
            else {
                
                //Hiện progress
                self.showProgress()
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    
                    //Ẩn progress
                    self.hideProgress()
                    if (error == nil) {
                        let srcUserInfo = self.storyboard?.instantiateViewController(withIdentifier: "userInfoId") as! UserInfoViewController
                        self.present(srcUserInfo, animated: true)
                    }
                    else {
                        self.showAlertDialog(message: "Đăng nhập không thành công")
                    }
                }
            }
        }
    }
    
    //Hiện hộp thoại cảnh báo
    func showAlertDialog(message: String) {
        let alertView = UIAlertController(title: "Thông Báo", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    //Xử lí nút đóng btnClose
    @IBAction func btnClose_Act(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Show, Hide Keyboard
    //Focus, quay lại textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtEmailSignIn.isEditing {
            txtPassSignIn.becomeFirstResponder()
        } else {
            txtPassSignIn.resignFirstResponder()
        }
        return true
    }
    
    fileprivate func observerKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(SignInViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(SignInViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    //DismissKeyboard
    func DismissKeyboard(){
        view.endEditing(true)
    }
    //Hiện Keyboard
    func keyboardWillShow(sender: NSNotification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -70, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    //Ẩn Keyboard
    func keyboardWillHide(sender: NSNotification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
}
