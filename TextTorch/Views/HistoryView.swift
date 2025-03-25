import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TextRecord.createdAt, order: .reverse) private var records: [TextRecord]
    @State private var showingAddSheet = false
    @State private var recordToEdit: TextRecord?
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(records.prefix(20)) { record in
                        NavigationLink(destination: PlayView(record: record)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(record.content.prefix(15) + (record.content.count > 15 ? "..." : ""))
                                    .font(.headline)
                                Text(record.createdAt.formatted())
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                modelContext.delete(record)
                            } label: {
                                Label("删除", systemImage: "trash")
                            }
                            
                            Button {
                                recordToEdit = record
                            } label: {
                                Label("编辑", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showingAddSheet = true }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("历史记录")
            .sheet(isPresented: $showingAddSheet) {
                EditView()
            }
            .sheet(item: $recordToEdit) { record in
                EditView(record: record)
            }
        }
    }
} 