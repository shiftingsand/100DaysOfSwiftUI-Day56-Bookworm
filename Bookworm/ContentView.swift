//
//  ContentView.swift
//  Bookworm
//
//  Created by Chris Wu on 5/27/20.
//  Copyright © 2020 Chris Wu. All rights reserved.
//

import SwiftUI

// day 56 - challenge 2
struct ShowBook : View {
    var book : Book
    var body: some View {
        Text(book.title ?? "Unknown Title")
            .foregroundColor(1 == book.rating ? Color.red : .primary)
            .font(.headline)
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>

    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books, id:\.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                        
                        VStack(alignment: .leading) {
                            // day 56 - challenge 2
                            ShowBook(book: book)
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            .onDelete(perform: deleteBooks)
            }
            .navigationBarTitle("Bookworm")
                .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                    self.showingAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    func deleteBooks(at offsets : IndexSet) {
        for offset in offsets {
            let book = books[offset]
            
            moc.delete(book)
            
            try? moc.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
