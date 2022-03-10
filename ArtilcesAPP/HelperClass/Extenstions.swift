//
//  Extenstions.swift
//  ArtilcesAPP
//
//  Created by Binil V on 09/03/22.
//

import UIKit

extension UIViewController {
  
  // Global Alert
  // Define Your number of buttons, styles and completion
  public func openAlert(title: String,
                        message: String,
                        alertStyle:UIAlertController.Style,
                        actionTitles:[String],
                        actionStyles:[UIAlertAction.Style],
                        actions: [((UIAlertAction) -> Void)]){
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
    for(index, indexTitle) in actionTitles.enumerated(){
      let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
      alertController.addAction(action)
    }
    self.present(alertController, animated: true)
  }
}

extension String {
  //
  // to support localization
  func localized() -> String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
  }
}
