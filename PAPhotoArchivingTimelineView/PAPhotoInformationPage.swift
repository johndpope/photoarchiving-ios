//
//  PAPhotoInformationPage.swift
//  PAPhotoArchivingTimelineView
//
//  Created by Tony Forsythe on 3/28/17.
//  Copyright © 2017 Tony Forsythe. All rights reserved.
//

import Foundation
import Eureka
import Kingfisher
import Spring

class PAPhotoInformationViewControllerv2 : FormViewController {
    
    static let STORYBOARD_ID = "PAPhotoInformationViewControllerv2StoryboardID"
    
    var currentRepository : PARepository?
    var currentPhotograph : PAPhotograph? {
        didSet {
            self.setupValues()
        }
    }
    
    var didSetImage = false
    var isEditingForm = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setup()
    }
    
    
    
    
    
    /*
        SETUP FUNCTIONS
    */
    func setupValues() {
        guard let photo = self.currentPhotograph else { return }
        
        let values : [String : Any] = [
            Keys.Photograph.title : photo.title,
            Keys.Photograph.description : photo.longDescription,
            Keys.Photograph.dateTaken : photo.dateTaken ?? Date(),
            Keys.Photograph.dateTakenConf : Double(photo.dateTakenConf).PAPercentString
        ] as [String : Any]
        
        self.form.setValues(values)
        
    }
    private func _setup() {
        
        _setupForm()
        
        
        
        
        
    }
    
    private func _setupForm() {
        
        //  Constants
        
        
        
        
        //  Setup the first section that contains the image view header
        form +++ Section() { section in
            var header = HeaderFooterView<PAPhotoInformationHeaderView>(.class)
            header.height = {PAPhotoInformationHeaderView.VIEW_HEIGHT}
            
            header.onSetupView = { view , _ in
                
                view.delegate = self
                
                if let photo = self.currentPhotograph {
                    
                    let image_url = URL.init(string: photo.mainImageURL)
                    
                    view.mainImageView.kf.setImage(    with: image_url,
                                                        placeholder: nil,
                                                        options: nil,
                                                        progressBlock: nil,
                                                        completionHandler: { image, error, cacheType, imageURL in
                                                            
                    })
                    self.didSetImage = true
                    
                }
            }
            
            section.header = header
        }
        
        form +++ Section( "Basic Information" )
            <<< TextRow() {
                $0.title = "Title"
                $0.placeholder = "Placeholder"
                $0.disabled = true
                $0.tag = Keys.Photograph.title
            }
            <<< TextAreaRow() {
                
                $0.title = "Description"
                $0.placeholder = "Enter a description"
                $0.tag = Keys.Photograph.description
                $0.disabled = true
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 10.0)
                
            }
                .cellUpdate { [ weak self ] (cell, row) in
                    
                    if let editing = self?.isEditingForm {
                        
                        if editing {
                            row.placeholder = "Enter a description"
                        }
                        else {
                        }
                    }
                    
        }
        
        form +++ Section( "Date Taken" )
            <<< DateInlineRow() {
                
                $0.title = "Date Taken"
                $0.maximumDate = Date()
                $0.minimumDate = PADateManager.sharedInstance.getDateFromYearInt(year: 1500)
                $0.tag = Keys.Photograph.dateTaken
                $0.disabled = true
            }
            <<< TextRow() {
                $0.title = "Confidence"
                $0.tag = Keys.Photograph.dateTakenConf
                $0.disabled = true
            }
        
        form +++ Section( "Story Information" )
            <<< ButtonRow() {
                $0.title = "Add New Story"
            }
            .onCellSelection { [ weak self ] (cell, row) in
                
                let add_new_story_vc = UIStoryboard.PAMainStoryboard.instantiateViewController(withIdentifier: PANewRecordingViewController.STORYBOARD_ID) as! PANewRecordingViewController
                
                add_new_story_vc.photoInformation = self?.currentPhotograph
                
                self?.present(add_new_story_vc, animated: true, completion: nil)
            }
            .cellUpdate { cell, row in
                
                cell.textLabel?.textColor = Color.green
            }
        
            <<< ButtonRow() {
                $0.title = "View Stories"
            }
            .onCellSelection { [ weak self ] ( cell,row ) in
                
                let view_stories_vc = UIStoryboard.PAMainStoryboard.instantiateViewController(withIdentifier: PAStoriesViewController.STORYBOARD_ID) as! PAStoriesViewController
                
                view_stories_vc.currentPhotograph = self?.currentPhotograph
                
                self?.present(view_stories_vc, animated: true, completion: nil)
            }
        
        
        form +++ Section()
            <<< ButtonRow() {
                $0.title = "Submit"
                $0.hidden = true
                
            }
            .onCellSelection { [ weak self ] ( cell, row ) in
                
                print("You chose to submit it!")
            }
            .cellUpdate { cell, row in
                
                cell.textLabel?.textColor = Color.PASuccessColor
            }
            
            <<< ButtonRow() {
                $0.title = "Exit"
                
            }
            .cellUpdate { cell, row in
                cell.textLabel?.textColor = Color.PADangerColor
                
                
            }
            .onCellSelection { [ weak self ] ( cell, row ) in
                print("Exiting")
                self?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        
        
        
        self.setupValues()
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
}


extension PAPhotoInformationViewControllerv2 : PAPhotoInformationHeaderDelegate {
    
    func PAPhotoInformationHeaderDidTap() {
        print( "you tapped me!" )
    }
}
