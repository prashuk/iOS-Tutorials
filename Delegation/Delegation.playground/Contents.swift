import UIKit

protocol RatingPickerDelegate {
    func preferredRatingSymbol(picker: RatingPicker) -> UIImage?
    func didSelectRating(picker: RatingPicker, rating: Int)
    func didCancel(picker: RatingPicker)
}

class RatingPicker {
    var delegate: RatingPickerDelegate?
    
    init(withDelegate delegate: RatingPickerDelegate?) {
        self.delegate = delegate
    }
 
    func setup() {
        let preferredRatingSymbol = delegate?.preferredRatingSymbol(picker: self)
        
        // Set up the picker with the preferred rating symbol if it was specified
    }
    
    func selectRating(selectedRating: Int) {
        delegate?.didSelectRating(picker: self, rating: selectedRating)
        // Other logic related to selecting a rating
    }
    
    func cancel() {
        delegate?.didCancel(picker: self)
        // Other logic related to canceling
    }
}

class RatingPickerHandler: RatingPickerDelegate {
    func preferredRatingSymbol(picker: RatingPicker) -> UIImage? {
        <#code#>
    }
    
    func didSelectRating(picker: RatingPicker, rating: Int) {
        <#code#>
    }
    
    func didCancel(picker: RatingPicker) {
        <#code#>
    }
}
