//
//  UserProfileViewController.swift
//  G04_MockProject_Cinema
//
//  Created by THANH on 6/5/17.
//  Copyright © 2017 HCMUTE. All rights reserved.
//

import UIKit
import Firebase
//import MBProgressHUD

class UserInfoViewController: UIViewController {
    
    
    @IBOutlet weak var txtFullName: LoginTextField!
    
    @IBOutlet weak var txtEmail: LoginTextField!
    
    @IBOutlet weak var txtAddress: LoginTextField!
    @IBOutlet weak var txtPhone: LoginTextField!
    
    @IBOutlet weak var txtBalance: LoginTextField!
    
    var mDatabase: DatabaseReference!
    var loadingNotification: MBProgressHUD!
    var userToMove: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mDatabase = Database.database().reference()
        
        //load user info
        //show progress
        self.showProgress()
        if let uid = Auth.auth().currentUser?.uid {
            mDatabase.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                self.hideProgress()
                if let user = snapshot.value as? [String: AnyObject] {
                    let fullName = user["fullName"] as? String ?? ""
                    let email = user["email"] as? String ?? ""
                    let address = user["address"] as? String ?? ""
                    let phone = user["phone"] as? String ?? ""
                    let balance = String(user["balance"] as? Double ?? 0)
                    
                    self.txtFullName.text! = fullName
                    self.txtEmail.text! = email
                    self.txtAddress.text! = address
                    self.txtPhone.text! = phone
                    self.txtBalance.text! = balance
                    
                    self.userToMove = User.init(fullName: fullName, email: email, address: address, balance: Double(balance)!, password: user["password"] as? String ?? "" , phone: phone, uid: uid)
                    
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    //event click change pass
    
    @IBAction func btnChangePass_Act(_ sender: Any) {
        let srcChangePass = self.storyboard?.instantiateViewController(withIdentifier: "changePassId") as! ChangePassViewController
        srcChangePass.user = userToMove
        self.present(srcChangePass, animated: true)
    }
    
    func showProgress() {
        loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Đang tải..."
    }
    
    func hideProgress() {
        loadingNotification.hide(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnHome_Act(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
