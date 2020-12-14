import Foundation

class Download {
  
  /// the URL of the file to download. This also acts as a unique identifier for a Download
  let url: String
  /// wheter the download is ongoing or paused
  var isDownloading = false
  /// the fractional progress of the download; a float between 0.0 and 1.0
  var progress: Float = 0.0
  /// the URLSessionDownloadTask that downloads the file
  var downloadTask: URLSessionDownloadTask?
  /// stores the Data produces when you pause a download task. If the host server supports it, you can use this to resume a paused download in the future
  var resumeData: Data?
  
  init(url: String) {
    self.url = url
  }
}
