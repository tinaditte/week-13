//
//  ViewController.swift
//  MediaCapture
//
//  Created by Tina Thomsen on 27/03/2020.
//  Copyright © 2020 Tina Thomsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	//protocols^ UINavig

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var imageView: UIImageView!
	var imagePicker = UIImagePickerController() //Handles the task of fetching an image from IOS
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imagePicker.delegate = self //assign the object from this class to handle image picking return. Self reference the object
		config()
	}
	
	//Buttons
	
	@IBAction func videoBtnPressed(_ sender: UIButton) {
		imagePicker.mediaTypes = ["public.movie"] //launches video in camera app
		imagePicker.videoQuality = .typeMedium
		launchCamera()
	}
	
	@IBAction func photosBtnPressed(_ sender: UIButton) {
		imagePicker.sourceType = .photoLibrary //Type of task = camera or photoalbum
		imagePicker.allowsEditing = true //should user be able to zoom in before getting image
		present(imagePicker, animated: true, completion: nil)
	}
	
	@IBAction func cameraPhotoBtnPressed(_ sender: UIButton) {
		launchCamera()
	}
	
	@IBAction func submitBtnPressed(_ sender: Any) {
		let text = textField.text!
		let title = NSAttributedString(string: text, attributes: [.font:UIFont(name: "Georgia", size: 50)!, .foregroundColor: UIColor.white])
		let size = imageView.image!.size
		let render = UIGraphicsImageRenderer(size: size)
		imageView.image = render.image{ _ in
			imageView.image!.draw(at: .zero)
			title.draw(at: CGPoint(x:30, y:size.height - 150))
		}
	}
	
	@IBAction func savepict(_ sender: Any) {
		print("Saved")
		UIImageWriteToSavedPhotosAlbum(imageView.image!,nil, nil, nil)
	}
	
	
	//Functions
	
	fileprivate func launchCamera() {
		imagePicker.sourceType = .camera
		imagePicker.showsCameraControls = true
		imagePicker.allowsEditing = true
		present(imagePicker, animated: true, completion: nil)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		//either image or video
		//1. I its a video:
		if let url = info[.mediaURL] as? URL { //only true if a video is there
			if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path){
				UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
			}
		}else{
			let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
			imageView.image = image
		}
		picker.dismiss(animated: true, completion: nil)
	}
	
	func config() {
		imageView.image = UIImage()
	}
	
	//Register touch
	var startPoint = CGFloat(0)
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print("touches began")
		if let  p = touches.first?.location(in: view){
			startPoint = p.x
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let p = touches.first?.location(in: view){
			let diff = p.x - startPoint // calculates the difference btw first touch and current touch position
			//get the difference of your finger movement
			imageView.transform = CGAffineTransform(translationX: diff, y:0)
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		//when user lets go of screen
	}
	@IBAction func resizeImage(_ sender: UIPinchGestureRecognizer) {
		imageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
	}
	
}

