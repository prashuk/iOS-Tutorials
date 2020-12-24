import Foundation

class PodcastStore {
  static let sharedStore = PodcastStore()

  var items: [PodcastItem] = []

  init() {
    loadItemsFromCache()
  }

  func refreshItems(_ completion: @escaping (_ didLoadNewItems: Bool) -> Void) {
    PodcastFeedLoader.loadFeed { [weak self] items in
      guard let self = self else {
        completion(false)
        return
      }
      let didLoadNewItems = items.count > self.items.count
      self.items = items
      self.saveItemsToCache()
      completion(didLoadNewItems)
    }
  }
}

// MARK: Persistance
extension PodcastStore {
  func saveItemsToCache() {
    do {
      let data = try JSONEncoder().encode(items)
      try data.write(to: itemsCache)
    } catch {
      print("Error saving podcast items: \(error)")
    }
  }

  func loadItemsFromCache() {
    do {
      guard FileManager.default.fileExists(atPath: itemsCache.path) else {
        print("No podcast file exists yet.")
        return
      }
      let data = try Data(contentsOf: itemsCache)
      items = try JSONDecoder().decode([PodcastItem].self, from: data)
    } catch {
      print("Error loading podcast items: \(error)")
    }
  }

  var itemsCache: URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsURL.appendingPathComponent("podcasts.dat")
  }
}
