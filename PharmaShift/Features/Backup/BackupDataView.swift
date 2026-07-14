import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct PharmaShiftExportDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json, .commaSeparatedText, .plainText] }
    var data: Data

    init(data: Data) { self.data = data }
    init(configuration: ReadConfiguration) throws { data = configuration.file.regularFileContents ?? Data() }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper { FileWrapper(regularFileWithContents: data) }
}

private enum BackupExportKind: String, Identifiable {
    case lightweight
    case complete
    case csv
    case report

    var id: String { rawValue }
    var filename: String {
        let day = Date.now.formatted(.iso8601.year().month().day())
        return switch self {
        case .lightweight: "Renlyst-Lightweight-\(day).json"
        case .complete: "Renlyst-Complete-\(day).json"
        case .csv: "Renlyst-Drug-Library-\(day).csv"
        case .report: "Renlyst-Training-Report-\(day).txt"
        }
    }
    var contentType: UTType {
        switch self { case .lightweight, .complete: .json; case .csv: .commaSeparatedText; case .report: .plainText }
    }
}

private struct BackupImportPreview: Identifiable {
    let id = UUID()
    let backup: PharmaShiftBackup
}

struct BackupDataView: View {
    @Environment(\.modelContext) private var context
    @State private var isWorking = false
    @State private var exportKind: BackupExportKind = .lightweight
    @State private var exportDocument: PharmaShiftExportDocument?
    @State private var showsExporter = false
    @State private var showsImporter = false
    @State private var importPreview: BackupImportPreview?
    @State private var message: String?
    @State private var errorMessage: String?
    @AppStorage("backup.lastExportAt") private var lastExportAt: Double = 0
    @AppStorage("backup.lastExportKind") private var lastExportKind = ""
    @AppStorage("backup.lastRestoreAt") private var lastRestoreAt: Double = 0

    var body: some View {
        List {
            Section {
                Label("Backups are created locally and never uploaded by Renlyst.", systemImage: "lock.shield.fill")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            if lastExportAt > 0 || lastRestoreAt > 0 {
                Section("Local history") {
                    if lastExportAt > 0 { LabeledContent("Last export", value: "\(lastExportKind) • \(Date(timeIntervalSince1970: lastExportAt).formatted(date: .abbreviated, time: .shortened))") }
                    if lastRestoreAt > 0 { LabeledContent("Last restore", value: Date(timeIntervalSince1970: lastRestoreAt).formatted(date: .abbreviated, time: .shortened)) }
                }
            }
            Section("Backup") {
                actionRow("Lightweight JSON", subtitle: "All records without images", icon: "doc.text") { prepareExport(.lightweight) }
                    .accessibilityIdentifier("backup.export.lightweight")
                actionRow("Complete JSON", subtitle: "All records with compressed card images", icon: "externaldrive.fill") { prepareExport(.complete) }
                    .accessibilityIdentifier("backup.export.complete")
            }
            Section("Export") {
                actionRow("Drug library CSV", subtitle: "UTF-8 spreadsheet data", icon: "tablecells") { prepareExport(.csv) }
                    .accessibilityIdentifier("backup.export.csv")
                actionRow("Training report", subtitle: "UTF-8 text with Arabic preserved", icon: "doc.plaintext") { prepareExport(.report) }
                    .accessibilityIdentifier("backup.export.report")
            }
            Section("Restore") {
                Button { showsImporter = true } label: {
                    Label("Import backup", systemImage: "square.and.arrow.down")
                }
                .accessibilityIdentifier("backup.import")
                Text("The file is decoded and validated before any saved data changes. Merge by UUID is the default; replacement requires confirmation.")
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Backup & Data")
        .accessibilityIdentifier("backup.screen")
        .disabled(isWorking)
        .overlay { if isWorking { ProgressView("Preparing…").padding().background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14)) } }
        .fileExporter(isPresented: $showsExporter, document: exportDocument, contentType: exportKind.contentType, defaultFilename: exportKind.filename) { result in
            switch result {
            case .success: lastExportAt = Date.now.timeIntervalSince1970; lastExportKind = exportKind.rawValue.capitalized
            case .failure(let error): errorMessage = error.localizedDescription
            }
        }
        .fileImporter(isPresented: $showsImporter, allowedContentTypes: [.json]) { result in handleImport(result) }
        .sheet(item: $importPreview) { preview in
            NavigationStack {
                BackupImportPreviewView(backup: preview.backup) { summary in
                    message = "Restored \(summary.counts.total) records by \(summary.mode == .merge ? "merging UUIDs" : "replacing existing data")."
                    lastRestoreAt = Date.now.timeIntervalSince1970
                }
            }
        }
        .alert("Backup & Data", isPresented: Binding(get: { message != nil }, set: { if !$0 { message = nil } })) {
            Button("OK") { message = nil }
        } message: { Text(message ?? "") }
        .alert("Could not complete operation", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK") { errorMessage = nil }
        } message: { Text(errorMessage ?? "") }
    }

    private func actionRow(_ title: String, subtitle: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon).frame(width: 28).foregroundStyle(.tint)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).foregroundStyle(.primary)
                    Text(subtitle).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "square.and.arrow.up").foregroundStyle(.secondary)
            }
        }
    }

    private func prepareExport(_ kind: BackupExportKind) {
        isWorking = true
        exportKind = kind
        do {
            let data: Data
            switch kind {
            case .lightweight:
                data = try BackupService.encode(BackupService.makeBackup(context: context, includesImages: false))
            case .complete:
                data = try BackupService.encode(BackupService.makeBackup(context: context, includesImages: true))
            case .csv:
                data = try BackupService.drugCSV(context: context)
            case .report:
                data = try BackupService.trainingReportText(context: context)
            }
            exportDocument = PharmaShiftExportDocument(data: data)
            showsExporter = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isWorking = false
    }

    private func handleImport(_ result: Result<URL, Error>) {
        do {
            let url = try result.get()
            let accessed = url.startAccessingSecurityScopedResource()
            defer { if accessed { url.stopAccessingSecurityScopedResource() } }
            let data = try Data(contentsOf: url, options: [.mappedIfSafe])
            importPreview = BackupImportPreview(backup: try BackupService.decode(data))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct BackupImportPreviewView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    let backup: PharmaShiftBackup
    let onRestore: (BackupRestoreSummary) -> Void
    @State private var asksToReplace = false
    @State private var isRestoring = false
    @State private var errorMessage: String?

    var body: some View {
        List {
            Section("Validated backup") {
                LabeledContent("Schema version", value: "\(backup.schemaVersion)")
                LabeledContent("Exported", value: backup.exportedAt.formatted(date: .abbreviated, time: .shortened))
                LabeledContent("Images", value: backup.includesImages ? "Included" : "Not included")
                LabeledContent("Total records", value: "\(backup.counts.total)")
            }
            Section("Record counts") {
                countRow("Drugs", backup.counts.drugs)
                countRow("Reviews", backup.counts.reviews)
                countRow("Shifts", backup.counts.shifts)
                countRow("Encounters", backup.counts.encounters)
                countRow("Reports", backup.counts.reports)
                countRow("Learning profiles", backup.counts.learningProfiles)
                countRow("Daily activity", backup.counts.dailyActivities)
            }
            Section {
                Button { restore(.merge) } label: { Label("Merge by UUID", systemImage: "arrow.triangle.merge") }
                    .buttonStyle(.borderedProminent).frame(maxWidth: .infinity)
                Button(role: .destructive) { asksToReplace = true } label: { Label("Replace all data", systemImage: "trash") }
                    .frame(maxWidth: .infinity)
            } footer: {
                Text("Merge is idempotent and preserves local images when this backup excludes them. Replace removes current records before restoring this snapshot.")
            }
        }
        .navigationTitle("Restore Preview")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        .disabled(isRestoring)
        .overlay { if isRestoring { ProgressView("Restoring…") } }
        .confirmationDialog("Replace all current Renlyst data?", isPresented: $asksToReplace, titleVisibility: .visible) {
            Button("Replace all data", role: .destructive) { restore(.replace) }
            Button("Cancel", role: .cancel) {}
        } message: { Text("This cannot be undone unless you have another backup.") }
        .alert("Restore failed", isPresented: Binding(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK") { errorMessage = nil }
        } message: { Text(errorMessage ?? "") }
    }

    private func countRow(_ title: String, _ count: Int) -> some View { LabeledContent(title, value: "\(count)") }

    private func restore(_ mode: BackupRestoreMode) {
        isRestoring = true
        do {
            let summary = try BackupService.restore(backup, mode: mode, context: context)
            onRestore(summary)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            isRestoring = false
        }
    }
}
