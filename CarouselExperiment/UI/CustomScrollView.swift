import Foundation
import SwiftUI
import SDWebImageSwiftUI

// A UIKit ScrollView in UIViewRepresentable form
struct CustomScrollView<Content: View>: UIViewRepresentable {
    let offset: CGPoint
    let onOffsetChanged: (CGPoint) -> Void
    let content: () -> Content

    init(offset: CGPoint, onOffsetChanged: @escaping (CGPoint) -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.offset = offset
        self.onOffsetChanged = onOffsetChanged
        self.content = content
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator

        let contentController = UIHostingController(rootView: content())
        scrollView.addSubview(contentController.view)
        contentController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])

        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        guard offset != scrollView.contentOffset else { return }
        scrollView.setContentOffset(offset, animated: true)
    }

    func makeCoordinator() -> ScrollViewCoordinator {
        ScrollViewCoordinator(onOffsetChanged: onOffsetChanged)
    }
}

final class ScrollViewCoordinator: NSObject, UIScrollViewDelegate {
    let onOffsetChanged: (CGPoint) -> Void

    init(onOffsetChanged: @escaping (CGPoint) -> Void) {
        self.onOffsetChanged = onOffsetChanged
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onOffsetChanged(scrollView.contentOffset)
    }
}


struct CustomScrollView_Previews: PreviewProvider {
    struct StateWrapper: View {
        @State var offset: CGPoint = .zero

        var body: some View {
            VStack(alignment: .leading) {
                Text("Current Offset: \(offset.debugDescription)")
                CustomScrollView(offset: offset, onOffsetChanged: { self.offset = $0 }) {
                    HStack {
                        ForEach(0..<100) { index in
                            ImageManagerWrapper(imageManager: ImageManager(url: .random(id: index)))
                        }

                    }
                    .padding(.horizontal)
                }
                Button(action: { self.offset = .init(x: 5408, y: 0) }) {
                    HStack {
                        Spacer()
                        Text("Scroll To 50")
                        Spacer()
                    }
                    .frame(height: 60)
                    .background(Color.blue)
                    .foregroundColor(.white)
                }
            }
        }
    }

    struct ImageManagerWrapper: View {
        @ObservedObject var imageManager: ImageManager

        var body: some View {
            GeometryReader { geo in
                Group {
                    if self.imageManager.image != nil {
                        Image(uiImage: self.imageManager.image!)
                            .clipped()
                    } else {
                        Rectangle().fill(Color.gray)
                    }
                }
                .onTapGesture {
                    print("Global center: \(geo.frame(in: .global).midX) x \(geo.frame(in: .global).midY)")
                    print("Custom center: \(geo.frame(in: .named("Custom")).midX) x \(geo.frame(in: .named("Custom")).midY)")
                    print("Local center: \(geo.frame(in: .local).midX) x \(geo.frame(in: .local).midY)")
                }
                .onAppear {
                    let screenBounds = UIScreen.main.bounds
                    let frame = geo.frame(in: .global)
                    let intersects = screenBounds.intersects(frame)
                    print("frame: \(frame) screen: \(screenBounds) intersects: \(intersects)")
                    if intersects {
                        self.imageManager.load()
                    }
                }
                .onDisappear {
                    self.imageManager.cancel()
                }
            }.frame(width: 200, height: 200)
        }
    }

    static var previews: some View {
        StateWrapper()
    }
}

extension URL {
    static func random(id: Int) -> URL { URL(string: "https://loremflickr.com/320/240?random=\(id*50)")! }
}

