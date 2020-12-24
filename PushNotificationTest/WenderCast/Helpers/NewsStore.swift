import Foundation

class NewsStore {
  static let shared = NewsStore()

  var items: [NewsItem] = []

  init() {
    loadItemsFromCache()
  }

  func add(item: NewsItem) {
    items.insert(item, at: 0)
    saveItemsToCache()
  }
}


// MARK: Persistance
extension NewsStore {
  func saveItemsToCache() {
    do {
      let data = try JSONEncoder().encode(items)
      try data.write(to: itemsCache)
    } catch {
      print("Error saving news items: \(error)")
    }
  }

  func loadItemsFromCache() {
    do {
      guard FileManager.default.fileExists(atPath: itemsCache.path) else {
        print("No news file exists yet.")
        return
      }
      let data = try Data(contentsOf: itemsCache)
      items = try JSONDecoder().decode([NewsItem].self, from: data)
    } catch {
      print("Error loading news items: \(error)")
    }
  }

  var itemsCache: URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsURL.appendingPathComponent("news.dat")
  }
}
