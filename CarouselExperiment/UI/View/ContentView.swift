import Foundation
import SwiftUI

private extension CoordinateSpace {
    static let collectionView: CoordinateSpace = .named("CollectionView")
}

private extension CGFloat {
    static let minimumScaleFraction: CGFloat = 0.85
    static let middleDetectionToleranceDistance: CGFloat = 0.05
}

struct ContentViewExample: View {
    @EnvironmentObject private var carouselLoader: VideoCarouselLoader

    var body: some View {
        videoCarouselViewLoaded(height: 300)
    }

    private func videoCarouselViewLoaded(height: CGFloat) -> some View {
        GeometryReader { geometryProxy in
            CustomCollectionView(selectedItem: self.$carouselLoader.selectedVideo, items: self.carouselLoader.videos, layout: self.carouselLayout) { video in
                    VideoView(
                        item: video,
                        scaleRatio: { self.itemScaleRatio(parentSize: geometryProxy.size, geometryProxy: $0) },
                        opacityRatio: { _ in Double(1.0) },
                        onVideoTap: { self.handleButtonTap(parentSize: geometryProxy.size, geometryProxy: $0, collectionViewItem: $1) }, minimumScaleFraction: .minimumScaleFraction
                    )
            }
        }
        .coordinateSpace(name: CoordinateSpace.collectionView)
        .background(Color.gray)
        .frame(height: height, alignment: .top)
    }

    private func itemScaleRatio(parentSize: CGSize, geometryProxy: GeometryProxy) -> CGFloat {
        let distance = itemDistanceFromCenter(parentSize: parentSize, geometryProxy: geometryProxy)
        guard distance != 0 else { return 1 }

        return factorForWidth(width: geometryProxy.size.width, distance: distance, minimumScale: .minimumScaleFraction)
    }

    private func factorForWidth(width: CGFloat, distance: CGFloat, minimumScale: CGFloat) -> CGFloat {
        let scalingFactor = abs(1 - abs(distance).clamp(to: 0...width) / width)

        return minimumScale + (1 - minimumScale) * scalingFactor
    }

    private func itemDistanceFromCenter(parentSize: CGSize, geometryProxy: GeometryProxy) -> CGFloat {
        // Sometimes, the inner frame has no width and height, we need to abort in this circumstance
        let innerFrame = geometryProxy.frame(in: .collectionView)
        if innerFrame.width == 0 || innerFrame.height == 0 { return 0 }

        let collectionMidX = parentSize.width / 2
        let currentItemMidX = geometryProxy.frame(in: .collectionView).midX

        return collectionMidX - currentItemMidX
    }

    private func handleButtonTap(parentSize: CGSize, geometryProxy: GeometryProxy, collectionViewItem: VideoCarouselItem) {
        if isTappedItemInMiddle(parentSize: parentSize, geometryProxy: geometryProxy, collectionViewItem: collectionViewItem) {
            // TODO: perform action
        } else {
            // Could detect if tile is in the middle
            carouselLoader.select(collectionViewItem)
        }

    }

    private func isTappedItemInMiddle(parentSize: CGSize, geometryProxy: GeometryProxy, collectionViewItem: VideoCarouselItem) -> Bool {
        let absDistance = abs(itemDistanceFromCenter(parentSize: parentSize, geometryProxy: geometryProxy))
        let isInMiddle = absDistance < .middleDetectionToleranceDistance
        return isInMiddle
    }

    private let carouselLayout = UICollectionViewCompositionalLayout { _, environment in
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(environment.traitCollection.horizontalSizeClass == .regular ? 0.2 : 0.33),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }
}
