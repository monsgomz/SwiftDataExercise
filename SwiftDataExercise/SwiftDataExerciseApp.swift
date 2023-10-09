//
//  SwiftDataExerciseApp.swift
//  SwiftDataExercise
//
//  Created by Montserrat Gomez on 2023-10-09.
// El model se comparte con toda la aplicacion
//

import SwiftUI
import SwiftData

@main
struct SwiftDataExerciseApp: App {
	
	//para configurar a mas detalle el container
	let conatiner: ModelContainer = {
		let schema = Schema([Expense.self])
		let container = try! ModelContainer(for: schema, configurations: [])
		return container
	}()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.modelContainer(conatiner) //se inyecta aqui el container para toda la app
//		.modelContainer(for: Expense.self) //nuestro esquema, si hay mas se pone un arreglo
    }
}
