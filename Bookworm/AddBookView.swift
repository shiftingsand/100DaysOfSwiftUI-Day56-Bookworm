//
//  AddBookView.swift
//  Bookworm
//
//  Created by Chris Wu on 5/28/20.
//  Copyright © 2020 Chris Wu. All rights reserved.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var showNoGenreAlert : Bool = false
    var genreMissing : Bool {
        if genre.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return true
        } else {
            return false
        }
    }
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id:\.self) { genny in
                            Text("\(genny)")
                        }
                    }
                }
                
                Section {
                    RatingView(rating: $rating)                    
                    TextField("Write a review", text: $review)
                }
                
                Section {
                    Button("Save") {
                        // day 56 - challenge 1
                        if self.genreMissing == true {
                            self.showNoGenreAlert = true
                        } else {
                            let newBook = Book(context: self.moc)
                            newBook.title = self.title
                            newBook.author = self.author
                            newBook.rating = Int16(self.rating)
                            newBook.genre = self.genre
                            newBook.review = self.review
                            newBook.date = Date()
                            
                            if self.moc.hasChanges {
                                try? self.moc.save()
                            }
                            
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .navigationBarTitle("Add book")
                // day 56 - challenge 1
            .alert(isPresented: $showNoGenreAlert) {
                Alert(title: Text("Hold up!"), message: Text("You must enter a genre before you can save this book."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
