import Foundation

struct ToDoItem {
    
    var title: String
    var done: Bool

    public init(title: String) {
        self.title = title
        self.done = false
    }
    
    public init?(_ pList: [String: Any]?) {
        guard let propertyList = pList,
            let title = propertyList["title"] as? String,
            let done = propertyList["done"] as? Bool
            else { return nil }

        self.title = title
        self.done = done
    }
    
    func toPlist() -> [String: Any]? {
        return ["title": self.title, "done": self.done]
    }
}
