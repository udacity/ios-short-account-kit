//
//  FollowFriendsViewController.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-05-03.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

internal final class FollowFriendsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var profile: Profile? {
        didSet {
            if isViewLoaded { tableView.reloadData() }
        }
    }

    @IBAction func done(sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
}



extension FollowFriendsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile?.data?.friends?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let surfer = profile?.data?.friends?[indexPath.row] else {
            fatalError()
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            fatalError()
        }

        cell.configure(with: surfer)

        return cell
    }
}


extension FollowFriendsViewController: UITableViewDelegate {

}


