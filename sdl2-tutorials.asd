;;;; sdl2-tutorials.asd

(asdf:defsystem #:sdl2-tutorials
  :description "Describe sdl2-tutorials here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:cl-libsdl2)
  :serial t
  :components ((:file "package")
               (:file "02")))

