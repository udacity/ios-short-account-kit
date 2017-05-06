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
            resetFollowing()
            if isViewLoaded {
                tableView.reloadData()
            }
        }
    }

    @IBAction func done(sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    var followingSurferIdentifiers: Set<String> = []

    func resetFollowing() {
        followingSurferIdentifiers = []
    }
}



extension FollowFriendsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    var numberOfRows: Int {
        return profile?.facebookData?.friends.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let surfer = profile?.facebookData?.friends[indexPath.row] else {
            fatalError()
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
            fatalError()
        }

        cell.delegate = self
        cell.configure(with: surfer)
        cell.setFollowButtonState(isFollowedByUser: followingSurferIdentifiers.contains(surfer.identifier))

        return cell
    }
}


extension FollowFriendsViewController: FriendCellDelegate {
    // Ultimately we'd want to push these changes back to the data model, but
    // don't have a persisted data layer in this example project
    func friendCell(_ cell: FriendCell, didTapFollowWithIdentifier identifier: String) {
        if followingSurferIdentifiers.contains(identifier) {
            followingSurferIdentifiers.remove(identifier)
        } else {
            followingSurferIdentifiers.insert(identifier)
        }
        tableView.reloadData()
    }
}


