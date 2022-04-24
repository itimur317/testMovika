//
//  CurrentVideoNumber.swift
//  testMovika
//
//  Created by Timur on 24.04.2022.
//

import Foundation

final class CurrentVideoNumber {
    static var shared = CurrentVideoNumber()
    var number: Int = 0
}
