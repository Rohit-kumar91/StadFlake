//
//  MenuTimeViewController.swift
//  Stadtfalke
//
//  Created by Rohit Prajapati on 27/04/19.
//  Copyright © 2019 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class MenuTimeViewController: UIViewController {
    
    
   
    //var menuTimeArray = [JSON]()
   // var menuRefineArray = [JSON]()
    
  @IBOutlet weak var menuTable: UITableView!

    
    var menuData = [JSON]()
    var urlLink: URL!
    var defaultSession: URLSession!
    var downloadTask: URLSessionDownloadTask!
    var insuranceUrl: URL?
    var fileName: String?
    var row = 0

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        defaultSession = Foundation.URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
       
        
        
        
        // Do any additional setup after loading the view.
        
//        for (index, value) in menuTimeArray.enumerated()  {
//
//            if index % 2 == 0 {
//                if value["status"].stringValue == "2" {
//                    let datetime = [
//                        "dayStatus" : "geschlossen",
//                        "timing" : "",
//                        "dayName" : value["week_day"]["name"].stringValue
//                    ]
//                    menuRefineArray.append(JSON(datetime))
//                } else {
//
//                    var str = ""
//                    if value["start_time"].stringValue != "00:00:00" || value["end_time"].stringValue != "00:00:00" {
//                        str += timeFormatter(time: value["start_time"].stringValue) + " - " + timeFormatter(time: value["end_time"].stringValue )
//                    }
//
//                    if menuTimeArray[index + 1]["start_time"].stringValue != "00:00:00" || menuTimeArray[index + 1]["end_time"].stringValue != "00:00:00" {
//                        str +=  "\n" + timeFormatter(time: menuTimeArray[index + 1]["start_time"].stringValue) + " - " + timeFormatter(time: menuTimeArray[index + 1]["end_time"].stringValue )
//                    }
//
//                    if str.isEmpty {
//
//                        let datetime = [
//                            "dayStatus" : "geschlossen",
//                            "timing" : "",
//                            "dayName" : value["week_day"]["name"].stringValue
//                        ]
//
//                        menuRefineArray.append(JSON(datetime))
//                    } else {
//
//                        let datetime = [
//                            "dayStatus" : "",
//                            "timing" : str,
//                            "dayName" : value["week_day"]["name"].stringValue
//                        ]
//
//                        menuRefineArray.append(JSON(datetime))
//
//                    }
//                }
//            }
//        }
        
        
 //       print(menuRefineArray)

 //       menuTable.reloadData()
        
    }
    
    @IBAction func buttonmenu(_ sender: UIButton) {
        row = sender.tag
        showHud()
        startDownloading ()
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return menuRefineArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
//        cell.dayLabel.text = menuRefineArray[indexPath.row]["dayName"].stringValue
//
//        if menuRefineArray[indexPath.row]["timing"].stringValue == "" {
//            cell.timeLabel.text = menuRefineArray[indexPath.row]["dayStatus"].stringValue
//        } else {
//            cell.timeLabel.text = menuRefineArray[indexPath.row]["timing"].stringValue
//        }
//
//
//        return cell
//    }
//
//    func timeFormatter(time: String) -> String {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"
//        let timeInHMS = dateFormatter.date(from: time)
//
//        dateFormatter.dateFormat = "HH:mm"
//        let timeInHM = dateFormatter.string(from: timeInHMS!)
//
//        return timeInHM
//    }

}

extension MenuTimeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        
        let title = menuData[indexPath.row]["title"].stringValue
        cell.menuButton.setTitle(title, for: .normal)
        cell.menuButton.layer.cornerRadius = 4
        cell.menuButton.tag = indexPath.row
        cell.stackView.isHidden = true
        cell.progress.setProgress(0.0, animated: true)
        return cell
    }
}


extension MenuTimeViewController: URLSessionDownloadDelegate,UIDocumentInteractionControllerDelegate {
    
    func startDownloading () {
        
        let indexPath = IndexPath(row: row, section: 0)
        let cell = menuTable.cellForRow(at: indexPath) as! MenuTableViewCell
        
        cell.downloadSpinner.isHidden = false
        print(menuData[0])
        print(menuData[0]["created_at"].stringValue)
        print(menuData[0]["file"].stringValue)
        
        let url = URL(string: menuData[0]["file"].stringValue)!
        downloadTask = defaultSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    // MARK:- URLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let indexPath = IndexPath(row: row, section: 0)
        let cell = menuTable.cellForRow(at: indexPath) as! MenuTableViewCell
        menuTable.reloadRows(at: [indexPath], with: .none)
        cell.stackView.isHidden = false
        print(downloadTask)
        print("File download succesfully")
        cell.downloadSpinner.isHidden = true
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/file.pdf"))
        
        if fileManager.fileExists(atPath: destinationURLForFile.path){
            showFileWithPath(path: destinationURLForFile.path)
            print(destinationURLForFile.path)
        }
        else{
            do {
                try fileManager.moveItem(at: location, to: destinationURLForFile)
                // show file
                showFileWithPath(path: destinationURLForFile.path)
            }catch{
                print("An error occurred while moving file to destination url")
            }
        }
        
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let indexPath = IndexPath(row: row, section: 0)
        let cell = menuTable.cellForRow(at: indexPath) as! MenuTableViewCell
        cell.progress.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        downloadTask = nil
        hideHud()
        let indexPath = IndexPath(row: row, section: 0)
        let cell = menuTable.cellForRow(at: indexPath) as! MenuTableViewCell
        cell.stackView.isHidden = true
        cell.progress.setProgress(0.0, animated: true)

        if (error != nil) {
            print("didCompleteWithError \(error?.localizedDescription ?? "no value")")
        }
        else {
            print("The task finished successfully")
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self
    }
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            viewer.presentPreview(animated: true)
        }
        
    }
}

extension MenuTimeViewController: UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        print(cico)
        print(url)
       
        print(url.lastPathComponent)
        print(url.pathExtension)
        
    }
}





