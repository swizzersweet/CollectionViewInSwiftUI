//
//  CustomCollectionView.swift
//  CarouselExperiment
//
//  Created by Jonathan Menard on 2020-11-23.
//  Copyright © 2020 Jonathan Menard. All rights reserved.
//

import SwiftUI

// Provides access to UIScrollView in SwiftUI via UIViewRepresentable
struct CustomCollectionView<Section: Hashable, Item: Hashable, Content: View>: UIViewControllerRepresentable {
    typealias UIViewControllerType = CollectionViewController<Section, Item, Content>
    typealias DataType = [Section: [Item]]

    let selectedItem: Binding<Item?>
    let data: DataType
    let layout: UICollectionViewCompositionalLayout
    let content: (Item) -> Content

    init(
        selectedItem: Binding<Item?>,
        data: [Section: [Item]],
        layout: UICollectionViewCompositionalLayout,
        @ViewBuilder content: @escaping (Item) -> Content) {
        self.selectedItem = selectedItem
        self.data = data
        self.layout = layout
        self.content = content
    }

    func makeUIViewController(context: Context) -> UIViewControllerType {
        UIViewControllerType(data: data, layout: layout, content: content)
    }

    func updateUIViewController(_ viewController: UIViewControllerType, context: Context) {
        viewController.apply(data) {
            viewController.scroll(to: self.selectedItem.wrappedValue)
        }
    }
}

extension CustomCollectionView where Section == String {
    init(
        selectedItem: Binding<Item?>,
        items: [Item],
        layout: UICollectionViewCompositionalLayout,
        @ViewBuilder content: @escaping (Item) -> Content) {
        self.selectedItem = selectedItem
        self.data = ["SingleSection": items]
        self.layout = layout
        self.content = content
    }
}

final class CollectionViewController<Section: Hashable, Item: Hashable, Content: View>: UIViewController {
    typealias DataType = CustomCollectionView<Section, Item, Content>.DataType

    private let data: DataType
    private let layout: UICollectionViewLayout
    private let content: (Item) -> Content

    init(data: DataType, layout: UICollectionViewLayout, content: @escaping (Item) -> Content) {
        self.data = data
        self.layout = layout
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { [unowned self] collectionView, indexPath, item in

        let cell: ContentCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: self.content(item))
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: ContentCell.reuseIdentifier)
        collectionView.alwaysBounceVertical = false
        collectionView.backgroundColor = .clear
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.pin(of: view)
        apply(data)
    }

    func apply(_ data: DataType, dataApplied: (() -> Void)? = nil) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Array(data.keys))
        data.forEach { section, items in
            snapshot.appendItems(items, toSection: section)
        }
        dataSource.apply(snapshot) {
            dataApplied?()
        }
    }

    func scroll(to item: Item?) {
        guard let item = item else { return }
        guard let indexPath = dataSource.indexPath(for: item) else { return }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

private final class ContentCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ContentCell.self)

    private var hostingController: UIHostingController<AnyView>?

    func configure<Content: View>(with content: Content) {
        hostingController?.view.removeFromSuperview()
        let newController = UIHostingController(rootView: AnyView(content))
        contentView.addSubview(newController.view)
        contentView.backgroundColor = .clear
        newController.view.backgroundColor = .clear
        newController.view.pin(of: contentView)
        hostingController = newController
    }
}
