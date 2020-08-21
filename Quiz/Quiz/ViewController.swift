//
//  ViewController.swift
//  Quiz
//
//  Created by TakahiroNANBU on 2020/08/16.
//  Copyright © 2020 wings. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let q = Quiz(text: "質問文", correctAnswer: true, imageName: "neko")
//        print(q.text)
//        print(q.correctAnswer)
//        print(q.imageName)

        // インスタンス作成
        let quizManager = QuizManager()
        // 最初のクイズの問題文を確認
        print(quizManager.currentQuiz.text)
        // クイズに○回答する
        quizManager.answerQuiz(answer: true)
        // スコアを確認する
        print(quizManager.score)
        // 次のクイズを取得
        quizManager.nextQuiz()
        // 次のクイズの問題文を確認
        print(quizManager.currentQuiz.text)
    }
    
    override func prepare(for segue: UIStoryboardSegue ,sender: Any?) {
        if let quizViewController =
            segue.destination as? QuizViewController {
            if let text = self.nameTextField.text {
                 quizViewController.nameText = text
            }
        }
    }
    
    @IBAction func pressButton(_ sender: Any) {
    }
    

}

