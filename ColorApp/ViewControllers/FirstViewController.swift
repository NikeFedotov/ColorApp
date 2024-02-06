//
//  FirstViewController.swift
//  ColorApp
//
//  Created by Никита on 06.02.2024.
//

import UIKit

final class FirstViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondVC = segue.destination as? SecondViewController else { return }
        secondVC.delegate = self
        secondVC.color = view.backgroundColor
    }

}

extension FirstViewController: SecondViewControllerDelegate {
    func changeColor(_ color: UIColor) {
        view.backgroundColor = color
    }
    
    
}
