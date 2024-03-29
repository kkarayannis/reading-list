import SwiftUI

import ImageLoader

/// View that displays information about a book.
struct BookInfoView: View {
    private let viewModel: BookInfoViewModel
    @State private var bookInfo: BookInfo?
    
    init(viewModel: BookInfoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if let bookInfo {
                ScrollView {
                    BookInfoContentView(bookInfo: bookInfo, imageLoader: viewModel.imageLoader)
                        .padding()
                }
            } else {
                EmptyView()
            }
        }
        .onReceive(viewModel.bookInfoPublisher) {
            bookInfo = $0
        }
    }
}

private struct BookInfoContentView: View {
    let bookInfo: BookInfo
    let imageLoader: ImageLoading
    
    var body: some View {
        VStack {
            CoverView(viewModel: coverViewModel)
                .frame(height: 300)
            Text(bookInfo.title)
                .font(.title)
            if let subtitle = bookInfo.subtitle {
                Text(subtitle)
                    .font(.title3)
            }
        }.padding([.bottom])
        VStack(alignment: .leading, spacing: 10) {
            Text("Subjects: \(bookInfo.subjects.localizedJoined())") // TODO: localize
                .font(.caption)
            if let people = bookInfo.subjectPeople?.localizedJoined() {
                Text("People: \(people)")
                    .font(.caption)
            }
            if let places = bookInfo.subjectPlaces?.localizedJoined() {
                Text("Places: \(places)")
                    .font(.caption)
            }
            if let description = bookInfo.description {
                Text(description)
            }
        }
    }
    
    private var coverViewModel: CoverViewModel {
        let coverURL = CoverImageURL.url(for: bookInfo.covers.first, size: .m)
        return CoverViewModel(url: coverURL, imageLoader: imageLoader)
    }
}

#Preview {
    let viewModel = BookInfoViewModel(id: "id", bookInfoLoader: BookInfoLoader.fake, imageLoader: ImageLoader.fake, title: "Actually, My Name is J")
    let bookInfo = BookInfo(
        subjects: ["Comedy", "Romantic"],
        title: "Actually, My Name is J",
        covers: [],
        subjectPeople: ["Jack", "John", "Jill"],
        subjectPlaces: ["Beverly Hills"],
        description: "A funny story that no one will forget.",
        subtitle: "A NYT Best Seller"
    )
    viewModel.__setBookInfo(bookInfo)
    return BookInfoView(viewModel: viewModel)
}
