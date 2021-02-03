//
//  ChatViewController.swift
//  ChatApp_Firebase_Sumple
//
//  Created by Masato Takamura on 2021/02/02.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        messageTextField.delegate = self
        
        navigationItem.hidesBackButton = true
        title = C.appName
        
        tableView.register(UINib(nibName: C.cellNibName, bundle: nil), forCellReuseIdentifier: C.cellIdentifier)
        
        loadMessage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotificationForTextField()
    }
    
    func loadMessage(){
        //リアルタイムにデータを更新して取得
        db.collection(C.FireStore.collectionName).order(by: C.FireStore.dateField).addSnapshotListener { [self] (querySnapShot, error) in
            messages = []
            if let e = error {
                print("There was an issue retrieving data from firestore. \(e)")
            }else{
                if let snapShotDocuments = querySnapShot?.documents {
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        if let messageSender = data[C.FireStore.senderField] as? String, let messageBody = data[C.FireStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                tableView.reloadData()
                                //メッセージが追加されるたびに下までスクロールしたい
                                let indexPath = IndexPath(row: messages.count - 1, section: 0)
                                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func sendMessagePressed(_ sender: UIButton) {
        
        //データの追加
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(C.FireStore.collectionName).addDocument(data: [
                C.FireStore.senderField: messageSender,
                C.FireStore.bodyField: messageBody,
                C.FireStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("Error adding document: \(e)")
                }else{
                    print("Successfully saved data.")
                    DispatchQueue.main.async { [self] in
                        messageTextField.text = ""
                    }
                }
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: C.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = message.body
        //メッセージがログインユーザーからのとき
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
            cell.messageLabel.textColor = .white
        }
        //メッセージが他の送信者からのとき
        else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            cell.messageLabel.textColor = .black
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    
}


//MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func tapGR(_ sender: UITapGestureRecognizer) {
        if messageTextField.isFirstResponder {
            messageTextField.resignFirstResponder()
        }
    }
    
    func setupNotificationForTextField(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        //keyboardの情報はuserInfoの中にある
        if let userInfo = notification.userInfo {
            //iPhoneに合わせたキーボードのサイズ
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
                self.view.frame.origin.y = -keyboardSize.size.height
            }, completion: nil)

        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame.origin.y = 0
        }, completion: nil)
    }
    
    
}
