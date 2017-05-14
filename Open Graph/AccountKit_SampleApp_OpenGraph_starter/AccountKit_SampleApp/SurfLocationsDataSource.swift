//
//  SurfLocationsDataSource.swift
//  AccountKit_SampleApp
//
//  Created by Josh Svatek on 2017-04-20.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

internal final class SurfLocationsDataSource: NSObject {
    /// The logged-in user's profile
    fileprivate let profile: Profile

    /// The locations being displayed
    fileprivate let locations: [SurfLocation]

    init(profile: Profile, locations: [SurfLocation]) {
        self.profile = profile
        self.locations = locations
        super.init()
    }

    /// Returns `true` if locations array is non-empty
    internal var isLoaded: Bool { return !locations.isEmpty }
}

// MARK: - Table view data source conformance

extension SurfLocationsDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SurfLocationCell else {
            fatalError("Could not dequeue a SurfLocationCell in tableView(_:cellForRowAt:)")
        }

        let location = locations[indexPath.row]
        configure(cell: cell, with: location)

        return cell
    }

    // Helper methods

    fileprivate var reuseIdentifier: String { return "SurfLocationCell" }

    fileprivate func configure(cell: SurfLocationCell, with location: SurfLocation) {
        // Update labels
        cell.nameLabel.text = location.name
        cell.conditionsLabel.attributedText = location.conditionsAttributedString

        // Update image
        guard let image = UIImage(named: location.imageName) else {
            fatalError("Could not load image named \(location.imageName)")
        }
        cell.locationImageView.image = image

        // Update visitor badges
        updateVisitorBadges(cell: cell, visitors: location.visitors)
    }

    private func updateVisitorBadges(cell: SurfLocationCell, visitors: [String]) {
        // Find the people we're following with matching IDs
        let surfers = profile.facebookData?.friends ?? []
        let surferIDs = Set(surfers.map({ $0.identifier }))
        let matchingIDs = surferIDs.intersection(visitors)
        let matchingSurfers = surfers.filter { matchingIDs.contains($0.identifier) }

        // Track how many unmatching surfers are at this location
        let unmatchingCount = visitors.count - matchingSurfers.count

        // Create badges for the ones we matched
        let pictureBadges: [VisitorBadge] = matchingSurfers.map { surfer in
            return VisitorBadge(surfer: surfer)
        }

        let remainderBadges: [VisitorBadge] = (unmatchingCount > 0 || pictureBadges.isEmpty) ? [VisitorBadge(withRemainderCount: unmatchingCount)] : []

        let badges = pictureBadges + remainderBadges

        for badge in badges.reversed() {
            cell.visitorsStackView.addArrangedSubview(badge)
        }
    }
}
