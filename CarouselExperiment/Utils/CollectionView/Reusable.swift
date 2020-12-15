//
//  Reusable.swift
//  CarouselExperiment
//
//  Created by Jonathan Menard on 2020-12-08.
//  Copyright © 2020 Jonathan Menard. All rights reserved.
//

import Foundation

import UIKit

/// Conforming to Reusable gives the conforming object access to a reuseIdentifier.
/// This is typically used for reusable views such as `UITableViewCell` or `UICollectionViewCell`
public protocol Reusable { }
public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable { }
extension UITableViewHeaderFooterView: Reusable { }
public extension UITableView {
    /// Dequeues a `UITableViewCell` by using it's `Reusable` reuseIdentifier.
    ///
    /// Example usage (where `SomeTableViewCell` is a `UITableViewCell` subclass)
    ///
    ///     let cell: SomeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    ///
    /// - Parameter indexPath: The index path of the cell
    /// - Returns: A strongly typed cell
    func dequeueReusableCell<C: UITableViewCell>(for indexPath: IndexPath) -> C {
        guard let cell = dequeueReusableCell(withIdentifier: C.reuseIdentifier, for: indexPath) as? C else {
            preconditionFailure("Unable to dequeue cell with reuse identifier: \(C.reuseIdentifier)")
        }
        return cell
    }

    /// Dequeues a `UITableViewHeaderFooterView` by using it's `Reusable` reuseIdentifier.
    ///
    /// Example usage (where `SomeHeaderFooterView` is a `UITableViewHeaderFooterView` subclass)
    ///
    ///     let headerFooterView: SomeHeaderFooterView = tableView.dequeueReusableHeaderFooterView()
    ///
    /// - Returns: A strongly typed reusable view
    func dequeueReusableHeaderFooterView<V: UITableViewHeaderFooterView>() -> V {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: V.reuseIdentifier) as? V else {
            preconditionFailure("Unable to dequeue header/footer view with reuse identifier: \(V.reuseIdentifier)")
        }
        return headerFooterView
    }
}

extension UICollectionReusableView: Reusable { }
public extension UICollectionView {
    /// Dequeues a `UICollectionViewCell` by using it's `Reusable` reuseIdentifier.
    ///
    /// Example usage (where `SomeCollectionViewCell` is a `UICollectionViewCell` subclass)
    ///
    ///     let cell: SomeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
    ///
    /// - Parameter indexPath: The index path of the cell
    /// - Returns: A strongly typed cell
    func dequeueReusableCell<C: UICollectionViewCell>(for indexPath: IndexPath) -> C {
        guard let cell = dequeueReusableCell(withReuseIdentifier: C.reuseIdentifier, for: indexPath) as? C else {
            preconditionFailure("Unable to dequeue cell with reuse identifier: \(C.reuseIdentifier)")
        }
        return cell
    }

    /// Dequeues a `UICollectionReusableView` by using it's `Reusable` reuseIdentifier.
    ///
    /// Example usage (where `SomeCollectionReusableView` is a `UICollectionReusableView` subclass)
    ///
    ///     let view: SomeCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
    ///
    /// - Parameters:
    ///   - kind: The reusable view kind
    ///   - indexPath: The index path of the reusable view
    /// - Returns: A strongly typed reusable view
    func dequeueReusableSupplementaryView<V: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> V {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: V.reuseIdentifier, for: indexPath) as? V else {
            preconditionFailure("Unable to dequeue cell with reuse identifier: \(V.reuseIdentifier)")
        }
        return cell
    }
}
