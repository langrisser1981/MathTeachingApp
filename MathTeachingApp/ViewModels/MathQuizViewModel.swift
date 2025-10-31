//
//  MathQuizViewModel.swift
//  MathTeachingApp
//
//  Created by langrisser1981
//

import Foundation
import Combine

class MathQuizViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var settings = QuizSettings()
    @Published var problems: [MathProblem] = []
    @Published var currentProblemIndex = 0
    @Published var userAnswers: [UUID: UserAnswer] = [:]
    @Published var showValidation = false
    @Published var quizResults: [QuizResult] = []
    @Published var isQuizCompleted = false
    
    // MARK: - Computed Properties
    var currentProblem: MathProblem? {
        guard currentProblemIndex < problems.count else { return nil }
        return problems[currentProblemIndex]
    }
    
    var currentUserAnswer: UserAnswer? {
        guard let problem = currentProblem else { return nil }
        return userAnswers[problem.id]
    }
    
    var progress: Double {
        guard !problems.isEmpty else { return 0 }
        return Double(currentProblemIndex + 1) / Double(problems.count)
    }
    
    var totalCorrect: Int {
        quizResults.filter { $0.isAllCorrect }.count
    }
    
    var totalIncorrect: Int {
        quizResults.count - totalCorrect
    }
    
    // MARK: - 初始化測驗
    func startQuiz() {
        problems = []
        userAnswers = [:]
        quizResults = []
        currentProblemIndex = 0
        isQuizCompleted = false
        showValidation = false
        
        // 生成題目
        generateProblems()
    }
    
    private func generateProblems() {
        for _ in 0..<settings.numberOfProblems {
            let num1 = Int.random(in: settings.minNumber...settings.maxNumber)
            // 確保減數小於被減數,且結果為正數
            let num2 = Int.random(in: settings.minNumber...min(num1, settings.maxNumber))

            let problem = MathProblem(
                number1: num1,
                number2: num2,
                allowMultipleBlanksPerColumn: settings.allowMultipleBlanksPerColumn
            )
            problems.append(problem)

            // 初始化空的答案
            userAnswers[problem.id] = UserAnswer(
                problemId: problem.id,
                answers: [:]
            )
        }
    }
    
    // MARK: - 答題相關
    func updateAnswer(for blankId: UUID, digit: Int?) {
        guard let problem = currentProblem else { return }
        
        if var answer = userAnswers[problem.id] {
            if let digit = digit {
                answer.answers[blankId] = digit
            } else {
                answer.answers.removeValue(forKey: blankId)
            }
            userAnswers[problem.id] = answer
        }
        
        // 清除驗證狀態
        showValidation = false
    }
    
    func validateCurrentAnswer() -> [UUID: Bool] {
        guard let problem = currentProblem,
              let userAnswer = userAnswers[problem.id] else {
            return [:]
        }
        
        var validationResults: [UUID: Bool] = [:]
        
        for blank in problem.blanks {
            if let userDigit = userAnswer.answers[blank.id] {
                validationResults[blank.id] = (userDigit == blank.correctDigit)
            } else {
                validationResults[blank.id] = false
            }
        }
        
        showValidation = true
        return validationResults
    }
    
    func checkAllBlanksAnswered() -> Bool {
        guard let problem = currentProblem,
              let userAnswer = userAnswers[problem.id] else {
            return false
        }
        
        return userAnswer.answers.count == problem.blanks.count
    }
    
    // MARK: - 導航
    func moveToNextProblem() {
        // 儲存當前結果
        saveCurrentResult()
        
        if currentProblemIndex < problems.count - 1 {
            currentProblemIndex += 1
            showValidation = false
        } else {
            // 測驗完成
            isQuizCompleted = true
        }
    }
    
    func moveToProblem(at index: Int) {
        guard index >= 0 && index < problems.count else { return }
        currentProblemIndex = index
        showValidation = false
    }
    
    private func saveCurrentResult() {
        guard let problem = currentProblem,
              let userAnswer = userAnswers[problem.id] else {
            return
        }
        
        var correctCount = 0
        for blank in problem.blanks {
            if let userDigit = userAnswer.answers[blank.id],
               userDigit == blank.correctDigit {
                correctCount += 1
            }
        }
        
        let result = QuizResult(
            id: UUID(),
            problemId: problem.id,
            userAnswer: userAnswer,
            problem: problem,
            correctCount: correctCount,
            totalBlanks: problem.blanks.count,
            isAllCorrect: correctCount == problem.blanks.count,
            answeredAt: Date()
        )
        
        // 更新或新增結果
        if let index = quizResults.firstIndex(where: { $0.problemId == problem.id }) {
            quizResults[index] = result
        } else {
            quizResults.append(result)
        }
    }
    
    // MARK: - 重置測驗
    func resetQuiz() {
        problems = []
        userAnswers = [:]
        quizResults = []
        currentProblemIndex = 0
        isQuizCompleted = false
        showValidation = false
    }
}
