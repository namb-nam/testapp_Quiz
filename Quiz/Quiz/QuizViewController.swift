//
//  QuizViewController.swift
//  Quiz
//
//  Created by TakahiroNANBU on 2020/08/16.
//  Copyright © 2020 wings. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    var nameText: String = ""
    
    @IBOutlet weak var quizCard: QuizCard!
    let manager: QuizManager = QuizManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.quizCard.style = .initial
        self.loadQuiz()
        let panGestureReconnizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuizCard(_:)))
        self.quizCard.addGestureRecognizer(panGestureReconnizer)
        }
    
    func loadQuiz() {
        // クイズの問題文を表示
        self.quizCard.quizLabel.text = manager.currentQuiz.text
        // クイズの画像を表示
        self.quizCard.quizImageView.image = UIImage(named: manager.currentQuiz.imageName)
    }
    
    func answer() {
        // 移動するCGAffineTransformオブジェクト (1)
        var translationTransform: CGAffineTransform
        // X軸方向の移動距離
        let screenWidth = UIScreen.main.bounds.width
        // Y軸方向の移動距離
        let y = UIScreen.main.bounds.height * 0.2
        
        // 回答によってtranslationTransformの内容を変える (2)
        if self.quizCard.style == .right {
            // ○解答の時は右へ移動
            translationTransform = CGAffineTransform(translationX: screenWidth, y: y)
            self.manager.answerQuiz(answer: true)
        } else {
            // ×解答の時は左へ移動
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: y)
            self.manager.answerQuiz(answer: false)
        }
        
        // クイズのカードをアニメーションさせて移動する（3）
        // 0.1秒遅延させて0.5秒でカードを移動する
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveLinear],
        animations: {
            // クイズのカードのtransformプロパティにtranslationTransformを設定
            self.quizCard.transform = translationTransform
        }, completion: { [unowned self] (finishied) in
            if finishied {
                // 動作確認のため、スコアをコンソールに表示
                //print(self.manager.score)
                self.showNextQuiz()
            }
        })
    }
    
    @objc func dragQuizCard(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            self.transformQuizCard(gesture:sender)
        case .ended:
            self.answer()
        default:
            break
        }
    }
    
    func showNextQuiz() {
        // 次のクイズを取得
        self.manager.nextQuiz()
        // クイズに解答中か解答済みかで処理を分岐
        switch manager.status {
        case .inAnswer:
            // transformプロパティに加えられた変更をリセットし、クイズのカードを元の位置に
            self.quizCard.transform = CGAffineTransform.identity
            // カードの状態を初期状態に
            self.quizCard.style = .initial
            // クイズを表示
            self.loadQuiz()
        case .done:
            // カードを非表示にして結果画面へ遷移
            self.quizCard.isHidden = true
            self.performSegue(withIdentifier: "goToResult", sender: nil)
        }
    }
    
    func transformQuizCard(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.quizCard)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        let translationPercent = translation.x/UIScreen.main.bounds.width/2
        let rotationAngle = CGFloat.pi/3 * translationPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        let transform = translationTransform.concatenating(rotationTransform)
        self.quizCard.transform = transform
        
        if translation.x > 0 {
            self.quizCard.style = .right
        } else {
            self.quizCard.style = .wrong
        }
    }
    
    // 画面遷移時に呼ばれるメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // セグエの遷移先がResultViewControllerの場合
        if let resultViewController: ResultViewController = segue.destination as? ResultViewController {
            // 名前
            resultViewController.nameText = self.nameText
            // クイズのスコア
            resultViewController.score = self.manager.score
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
