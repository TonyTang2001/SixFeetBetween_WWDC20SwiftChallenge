//
//  IconView.swift
//  WWDC20PlaygroundTest
//
//  Created by Tony Tang on 5/17/20.
//  Copyright © 2020 TonyTang. All rights reserved.
//

import SwiftUI

struct FactoryView: View {
    var body: some View {
        Image(uiImage: UIImage(named: "factory1")!)
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color(UIColor.label))
    }
}

struct LabView: View {
    var body: some View {
        Image(uiImage: UIImage(named: "research")!)
        .resizable()
        .renderingMode(.template)
        .foregroundColor(Color(UIColor.label))
    }
}
