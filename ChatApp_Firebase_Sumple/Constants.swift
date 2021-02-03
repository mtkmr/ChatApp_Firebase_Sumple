//
//  Constants.swift
//  ChatApp_Firebase_Sumple
//
//  Created by Masato Takamura on 2021/02/03.
//

import Foundation

struct C {
    static let appName = "SimpleChat"
    static let cellIdentifier = "MessageCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LogInToChat"
    
    struct FireStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
