//
//  ContentView.swift
//  SwiftDataExercise
//
//  Created by Montserrat Gomez on 2023-10-09.
//option cmnd \ para descripcion

import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) var context
	
	@State private var isShowingItemSheet = false
//	@Query(filter: #Predicate<Expense> {$0.value > 1000}, sort: \Expense.date) var expenses: [Expense] //por si queremos la data filtrada
	@Query(sort: \Expense.date) var expenses: [Expense] //hace fetch siempre
	@State private var expenseToEdit: Expense?
	
    var body: some View {
		NavigationStack{
			List {
				ForEach(expenses) { expense in
					ExpenseCell(expense: expense)
						.onTapGesture {
							expenseToEdit = expense //le pasamos el valor del item
						}
				}
				.onDelete{ indexSet in
					for index in indexSet {
						context.delete(expenses[index]) //lo borra del context, donde se guarda y se autosave por default
					} // trae el modo arrastrar para borrar
				}
			}
			.navigationTitle("Expenses")
			.navigationBarTitleDisplayMode(.large)
			.sheet(isPresented: $isShowingItemSheet) {AddExpenseSheet()} //para abrir otra ventana como opcion
			.sheet(item: $expenseToEdit) { expense in //lee el objeto, cuando cambia la varible expenseToEdit, se abre la ventana
				UpdateExpenseSheet(expense: expense)
			}
			.toolbar {
				if !expenses.isEmpty {
			
					ToolbarItemGroup(placement: .topBarLeading){
						EditButton()
					}
					ToolbarItemGroup(placement: .topBarTrailing){
						Button("Add Expense", systemImage: "plus"){
							isShowingItemSheet = true
						}
					}
				}
			}
			.overlay { //pone la vista encima
				if expenses.isEmpty {
					//el nuevo iOS 17 lo trae incluido
					ContentUnavailableView(label: {
						Label("No Expenses", systemImage: "list.bullet.rectangle")
					}, description: {Text("Start adding expenses to see your list")
					}, actions: {
						Button("Add Expense"){isShowingItemSheet = true}
					})
					.offset(y: -60)
				}
			}
		}
    }
}

#Preview {
    ContentView()
}

/// Formulario
struct ExpenseCell: View {
	
	let expense: Expense
	
	var body: some View {
		HStack{
			Text(expense.date, format: .dateTime.month(.abbreviated).day())
			Text(expense.name)
			Spacer()
			Text(expense.value, format: .currency(code: "USD"))
		}
	}
}

/// Agregar un nuevo valor  y guardar la informacion en el context
struct AddExpenseSheet: View {
	
	@Environment(\.modelContext) var context
	@Environment(\.dismiss) private var dismiss //para desaparecer la ventana
	//variables para guardar la informacion
	@State private var name: String = ""
	@State private var date: Date = .now
	@State private var value: Double = 0.0
	
	var body: some View {
		NavigationStack{
			Form {
				TextField("Expense Name", text: $name)
				DatePicker("Date", selection: $date, displayedComponents: .date)
				TextField("Value", value: $value, format: .currency(code: "USD"))
			}
			.navigationTitle("New Expense")
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				ToolbarItemGroup(placement: .topBarLeading){
					Button("Cancel") {dismiss()}
				}
				ToolbarItemGroup(placement: .topBarTrailing){
					Button("Save"){
						let expense = Expense(name: name, date: date, value: value) //se hace el nuevo Objeto
						context.insert(expense) //se guardo en el context y swiftdata tiene autosave
//						try! context.save() // igual se puede guardar manualmente
						dismiss()
					}
				}
			}
		}
	}
}

/// Para actualizar los datos del item
/// Automaticamente se actualiza el context teniendo una variable Bindable
struct UpdateExpenseSheet: View {
	@Environment(\.dismiss) private var dismiss //para desaparecer la ventana
	@Bindable var expense: Expense //cada vez que se actualice la varibale, se actualiza el modelo

	var body: some View {
		NavigationStack{
			Form {
				TextField("Expense Name", text: $expense.name)
				DatePicker("Date", selection: $expense.date, displayedComponents: .date)
				TextField("Value", value: $expense.value, format: .currency(code: "USD"))
			}
			.navigationTitle("Update Expense")
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				ToolbarItemGroup(placement: .topBarTrailing){
					Button("Done") {dismiss()}
				}
				
			}
		}
	}
}


