//
//  ContentView.swift
//  ProjectGrowth
//
//  Created by MattHew Phraxayavong on 5/18/20.
//  Copyright © 2020 MattHew Phraxayavong. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var toggled = true
    var buttonDimensions:CGFloat = 50
    var body: some View {
        VStack
            {
            ZStack
                {
            HStack
                {
                    Spacer()
                    Spacer()
                    Button(action: {
                        self.toggled = true
                    }) {
                        Image(systemName: "text.bubble")
                            .font(.system(size: 25))
                            .foregroundColor(!toggled ? Color.white : Color.init(white: 0.8))
                    }
                    Spacer()
            }
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
