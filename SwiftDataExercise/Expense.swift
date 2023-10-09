//
//  Expense.swift
//  SwiftDataExercise
//
//  Created by Montserrat Gomez on 2023-10-09.
//

import Foundation
import SwiftData

//es una macro
//se crean shemas que son las tablas que van a estar relacionadas como en BD
@Model
class Expense {
	
	var name: String
	var date: Date
	var value: Double
	
	init(name: String, date: Date, value: Double) {
		self.name = name
		self.date = date
		self.value = value
	}
}
