# document_scanning

This Flutter app allows users to capture images from their device's camera or gallery, edit them using basic editing tools, and export them as a PDFs. It uses Flutter for the frontend, and various Flutter packages like GetX, Image Picker, Image Editor Plus, and PDF for handling functionality such as image capturing, editing, and PDF creation.

Features-
Capture Image: Users can capture an image using the device's camera.

Select from Gallery: Users can select an image from the device's gallery.

Edit Image: Users can edit the captured image with simple tools such as crop, rotate, etc., using the ImageEditorPlus package.

Export as PDF: Users can export the edited image as a PDF and view the created PDF directly from the app.

Theme Support: The app supports both light and dark themes, with an option to toggle between them.

State Management: The app uses GetX for state management and navigation.

Dependencies-
This project uses the following Flutter packages:

GetX: For state management and navigation.
get

Image Picker: For capturing images from the camera or picking from the gallery.
image_picker

Image Editor Plus: For providing simple image editing tools like crop, rotate, etc.
image_editor_plus

PDF Widgets: To convert images into PDF documents.
pdf

Path Provider: To access the device's file system for storing PDFs.
path_provider

Open File: To open the generated PDF files directly from the app.
open_file


