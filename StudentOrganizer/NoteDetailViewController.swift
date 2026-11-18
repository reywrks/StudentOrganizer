//
//  NoteDetailViewController.swift
//  StudentOrganizer
//
//  Screen 6: one note shown full-size, with a Delete button.
//

import UIKit

class NoteDetailViewController: UIViewController {

    // MARK: - Data passed in from NotesViewController
    var note: Note?

    // MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Note"
        addGlassBackground()   // same soft gradient as the other screens (Theme.swift)
        photoImageView.layer.cornerRadius = 12
        photoImageView.clipsToBounds = true

        guard let note = note else { return }
        noteLabel.text = note.text
        dateLabel.text = note.createdAt?.formatted(date: .long, time: .shortened)

        if let data = note.photoData, let image = UIImage(data: data) {
            photoImageView.image = image
            photoImageView.contentMode = .scaleAspectFit
        } else {
            photoImageView.image = UIImage(systemName: "text.alignleft")
            photoImageView.contentMode = .center
            photoImageView.tintColor = .secondaryLabel   // readable on the glass card
        }
    }

    // MARK: - Actions
    @IBAction func deleteTapped(_ sender: UIButton) {
        // Ask first: deleting cannot be undone.
        let alert = UIAlertController(title: "Delete this note?",
                                      message: "This cannot be undone.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            [weak self] _ in
            guard let self = self, let note = self.note else { return }
            CoreDataStack.shared.context.delete(note)
            CoreDataStack.shared.save()
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
}
