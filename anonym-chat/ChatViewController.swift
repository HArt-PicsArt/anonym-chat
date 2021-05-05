//
//  ChatViewController.swift
//  anonym-chat
//
//  Created by Artur Hakobyan on 05.05.21.
//

import UIKit
import Firebase

private let cellIdentifier = "MessageCell"
class ChatViewController: UIViewController {

    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    private var messages: [String] = []
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        messageTable.dataSource = self
        messageTable.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        ref = Database.database().reference().child("messages")

        ref.observe(.value) { [weak self] snapshot in
            guard let self = self, let valueDict = snapshot.value as? [String: String] else { return }
            self.messages = Array(valueDict.values)
            self.messageTable.reloadData()
        }
    }

    @IBAction func sendAction() {
        guard let message = messageTextView.text, !message.isEmpty else { return }
        messageTextView.text = ""
        messageTextView.resignFirstResponder()
        ref.childByAutoId().setValue(message)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = messages[indexPath.row]
        return cell
    }
}
