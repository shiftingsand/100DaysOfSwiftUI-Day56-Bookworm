//
//  DetailView.swift
//  Bookworm
//
//  Created by Chris Wu on 5/29/20.
//  Copyright © 2020 Chris Wu. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    let book : Book
    // day 56 - challenge 3
    var formattedDate : String {
        if let date = book.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return "\(formatter.string(from: date))"
        } else {
            return "Unknown date"
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geo.size.width)
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown authtor")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(self.book.review ?? "No review")
                    .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                
                // day 56 - challenge 3
                HStack {
                    Text("Added: ")
                    Text(self.formattedDate)
                }.padding(.top)
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Uknown book"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {self.showingDeleteAlert.toggle()}) {
            Image(systemName: "trash")
        })
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                self.deleteBook()
                }, secondaryButton: .cancel())
        }
    }
    
    func deleteBook() {
        moc.delete(book)
        
        if self.moc.hasChanges {
            try? self.moc.save()
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) // fetch data on main queue
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "title"
        book.author = "author"
        book.genre = "fantasy"
        book.rating = 4
        book.review = "It was a book."
        book.date = Date()
        return NavigationView {
            DetailView(book: book)
        }
    }
}
