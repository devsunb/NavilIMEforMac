import Cocoa
import Foundation

class PrintLog {
    static let shared = PrintLog()
    var scrollView: NSScrollView?

    private init() {}

    func Log(log: String) {
        if let scv = self.scrollView {
            scv.documentView?.insertText(log + "\n")
        }
    }
}
