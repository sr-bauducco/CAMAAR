import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "container", "template", "question", "optionsContainer", "optionsList" ]

  initialize() {
    this.updateQuestionNumbers()
  }

  connect() {
    console.log("Questions controller connected")
  }

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.content.cloneNode(true)
    this.containerTarget.appendChild(content)
    this.updateQuestionNumbers()
  }

  remove(event) {
    event.preventDefault()
    const question = event.target.closest("[data-questions-target='question']")
    question.remove()
    this.updateQuestionNumbers()
  }

  toggleOptions(event) {
    const select = event.target
    const question = select.closest("[data-questions-target='question']")
    const optionsContainer = question.querySelector("[data-questions-target='optionsContainer']")
    
    if (select.value === "multiple_choice") {
      optionsContainer.classList.remove("hidden")
    } else {
      optionsContainer.classList.add("hidden")
    }
  }

  addOption(event) {
    event.preventDefault()
    const button = event.target.closest("[data-action='questions#addOption']")
    if (!button) return

    const question = button.closest("[data-questions-target='question']")
    if (!question) return

    const optionsContainer = question.querySelector("[data-questions-target='optionsContainer']")
    if (!optionsContainer) return

    // Cria o container da opção
    const optionContainer = document.createElement("div")
    optionContainer.className = "flex items-center space-x-2"
    
    // Cria o input da opção
    const input = document.createElement("input")
    input.type = "text"
    input.name = `form_template[questions][${this.getQuestionIndex(question)}][options][]`
    input.className = "shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border-gray-300 rounded-md"
    
    // Cria o botão de remover
    const removeButton = document.createElement("button")
    removeButton.type = "button"
    removeButton.className = "text-red-600 hover:text-red-900"
    removeButton.dataset.action = "questions#removeOption"
    removeButton.innerHTML = `
      <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
      </svg>
    `
    
    // Adiciona os elementos ao container
    optionContainer.appendChild(input)
    optionContainer.appendChild(removeButton)

    // Encontra ou cria a lista de opções
    let optionsList = optionsContainer.querySelector("[data-questions-target='optionsList']")
    if (!optionsList) {
      optionsList = document.createElement("div")
      optionsList.className = "mt-1 space-y-2"
      optionsList.dataset.questionsTarget = "optionsList"
      optionsContainer.insertBefore(optionsList, button)
    }

    // Adiciona o container da opção à lista
    optionsList.appendChild(optionContainer)
  }

  removeOption(event) {
    event.preventDefault()
    const button = event.target.closest("[data-action='questions#removeOption']")
    if (!button) return
    
    const optionContainer = button.closest(".flex")
    if (optionContainer) {
      optionContainer.remove()
    }
  }

  updateQuestionNumbers() {
    this.questionTargets.forEach((question, index) => {
      const numberSpan = question.querySelector(".rounded-full")
      if (numberSpan) {
        numberSpan.textContent = index + 1
      }
    })
  }

  getQuestionIndex(question) {
    return Array.from(this.questionTargets).indexOf(question)
  }
} 