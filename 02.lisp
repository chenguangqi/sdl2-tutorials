(in-package #:sdl2-tutorials)

(defparameter *window* nil)
(defparameter *screen* nil)
(defparameter *hello-surface* nil)

(defun init ()
  "SDL Init function"
  (sdl-init :video)
  (setf *window* (sdl-create-window "Tutorial 02" 0 0 640 480 :shown))
  (format t "Create Window: ~A~%" (sdl-get-error))
  (setf *screen* (sdl-get-window-surface *window*))
  (format t "Get Screen: ~A~%" (sdl-get-error)))

(defun load-media ()
  "load media"
  (setf *hello-surface* (sdl-load-bmp "hello_world.bmp"))
  (format t "Load BMP: ~A~%" (sdl-get-error)))
      

(defun cleanup ()
  "close SDL"
  (setf *screen* nil)
  (sdl-free-surface *hello-surface*)
  (setf *hello-surface* nil)
  (sdl-destroy-window *window*)
  (setf *window* nil)
  (sdl-quit))

(defun demo-02 ()
  (unwind-protect
       (progn (init)
	      (load-media)
	      (sdl-blit-surface *hello-surface* (cffi:null-pointer) *screen* (cffi:null-pointer))
	      (sdl-update-window-surface *window*)
	      (sdl-delay 3000))
    (cleanup)))

