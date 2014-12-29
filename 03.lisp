(in-package #:sdl2-tutorials)

(defparameter *window* nil)
(defparameter *screen* nil)
(defparameter *x-surface* nil)
(defparameter *quit* nil)

(defun init ()
  "SDL Init function"
  (sdl-init :video)
  (setf *window* (sdl-create-window "Tutorial 03" 0 0 640 480 :shown))
  (format t "Create Window: ~A~%" (sdl-get-error))
  (setf *screen* (sdl-get-window-surface *window*))
  (format t "Get Screen: ~A~%" (sdl-get-error)))

(defun load-media ()
  "load media"
  (setf *x-surface* (sdl-load-bmp "x.bmp"))
  (format t "Load BMP: ~A~%" (sdl-get-error)))
      

(defun cleanup ()
  "close SDL"
  (setf *screen* nil)
  (sdl-free-surface *x-surface*)
  (setf *x-surface* nil)
  (sdl-destroy-window *window*)
  (setf *window* nil)
  (sdl-quit))

(defun demo-03 ()
  (unwind-protect
       (progn (init)
	      (load-media)
	      (cffi:with-foreign-object (event '(:union sdl-event))
		(loop until *quit* 
		   do (loop until (= 0 (sdl-poll-event event))
			 do (let ((type (cffi:foreign-slot-value event '(:union sdl-event) 'type)))
			      (format t "Event type: ~A~%" type)
			      (if (= 256 type)
				  (setf *quit* t))))
		     (sdl-blit-surface *x-surface* (cffi:null-pointer) *screen* (cffi:null-pointer))
		     (format t "Blit Surface: ~A~%" (sdl-get-error))
		     (sdl-update-window-surface *window*)
		     (format t "Update Window: ~A~%" (sdl-get-error)))
	      (cleanup)))))

