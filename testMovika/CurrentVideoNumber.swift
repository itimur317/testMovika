//
//  CurrentVideoNumber.swift
//  testMovika
//
//  Created by Timur on 24.04.2022.
//

import Foundation

// В этом классе свойство curveNumber ответственно за номер кривой с ссылки на гугл диске
final class CurrentInformation {
    static var shared = CurrentInformation()
    var curveNumber: Int = Int.random(in: 1...14)
    var videoNumber: Int = 1
    var paused: Bool = true
}
