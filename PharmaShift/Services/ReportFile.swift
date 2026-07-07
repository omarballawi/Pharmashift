import CoreTransferable
import Foundation
import UniformTypeIdentifiers

struct ReportFile: Transferable {
    let text: String

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .utf8PlainText) { report in
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("PharmaShift-Training-Report.txt")
            try report.text.write(to: url, atomically: true, encoding: .utf8)
            return SentTransferredFile(url)
        }
    }
}
