//
//  RatingView.swift
//  Bookworm
//
//  Created by Chris Wu on 5/28/20.
//  Copyright © 2020 Chris Wu. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating : Int
    var label = ""
    var maximumRating = 5
    var offImage : Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRating + 1) { nummy in
                self.image2(for: nummy)
                    .foregroundColor(nummy > self.rating ? self.offColor : self.onColor)
                    .onTapGesture {
                        self.rating = nummy
                }
                .accessibility(label: Text("\(1 == nummy ? "1 star" : "\(nummy) stars")"))
                .accessibility(removeTraits: .isImage)
                .accessibility(addTraits: nummy > self.rating ? .isButton : [.isButton, .isSelected])
            }
        }
    }
    
    func image2(for number : Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
