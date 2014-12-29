(in-package #:sdl2-tutorials)

(defparameter *window* nil)
(defparameter *screen* nil)
(defparameter *surfaces* nil)
(defparameter *current-surface* nil)
(defparameter *quit* nil)

(defun init ()
  "SDL Init function"
  (sdl-init :video)
  (setf *window* (sdl-create-window "Tutorial 04" 0 0 640 480 :shown))
  (format t "Create Window: ~A~%" (sdl-get-error))
  (setf *screen* (sdl-get-window-surface *window*))
  (format t "Get Screen: ~A~%" (sdl-get-error)))

(defun load-surface (file)
  (let ((surface (sdl-load-bmp file)))
    (if (cffi:null-pointer-p surface)
	nil
	surface)))

(defun load-media ()
  "load media"
  (push (load-surface "press.bmp") *surfaces*)
  (format t "Load BMP press: ~A~%" (sdl-get-error))
  (push (load-surface "up.bmp") *surfaces*)
  (format t "Load BMP up: ~A~%" (sdl-get-error))
  (push (load-surface "down.bmp") *surfaces*)
  (format t "Load BMP down: ~A~%" (sdl-get-error))
  (push (load-surface "left.bmp") *surfaces*)
  (format t "Load BMP left: ~A~%" (sdl-get-error))
  (push (load-surface "right.bmp") *surfaces*)
  (format t "Load BMP right: ~A~%" (sdl-get-error)))


(defun cleanup ()
  "close SDL"
  (setf *screen* nil)
  (mapcar #'sdl-free-surface *surfaces*)
  (setf *surfaces* nil)
  (setf *current-surface* nil)
  (sdl-destroy-window *window*)
  (setf *window* nil)
  (setf *current-surface* (last *surfaces*))
  (sdl-quit))

(defun get-keycode (event)
  (let ((key (cffi:foreign-slot-pointer event '(:union sdl-event) 'cl-libsdl2::key)))
    (let ((keycode (cffi:foreign-slot-pointer key '(:struct sdl-keyboard-event) 'cl-libsdl2::keysym)))
      (let ((code (cffi:foreign-slot-value keycode '(:struct sdl-keysym) 'cl-libsdl2::sym)))
	code))))

;(+ (expt 2 30)  (cffi:foreign-enum-value 'sdl-scancode :scancode-up)) 1073741906
;(+ (expt 2 30)  (cffi:foreign-enum-value 'sdl-scancode :scancode-down)) 1073741905
;(+ (expt 2 30)  (cffi:foreign-enum-value 'sdl-scancode :scancode-left)) 1073741904
;(+ (expt 2 30)  (cffi:foreign-enum-value 'sdl-scancode :scancode-right)) 1073741903

;(cffi:foreign-slot-names '(:struct sdl-keyboard-event))
;(cffi:foreign-slot-names '(:struct sdl-keysym))
  
(defun demo-04 ()
  (unwind-protect
       (progn (init)
	      (setf *quit* nil)
	      (load-media)
	      (setf *current-surface* (nth 4  *surfaces*))
	      (cffi:with-foreign-object (event '(:union sdl-event))
		(loop until *quit* 
		   do (loop until (= 0 (sdl-poll-event event))
			 do (let ((type (cffi:foreign-slot-value event '(:union sdl-event) 'type)))
			      (format t "Event type: ~A~%" type)
			      (cond 
				((= 256 type) (setf *quit* t))
				((= 769 type) 
				 (case (get-keycode event)
				   (1073741906 (setf *current-surface* (nth 3 *surfaces*)))
				   (1073741905 (setf *current-surface* (nth 2 *surfaces*)))
				   (1073741904 (setf *current-surface* (nth 1 *surfaces*)))
				   (1073741903 (setf *current-surface* (nth 0 *surfaces*)))
				   (otherwise (setf *current-surface* (nth 4 *surfaces*))))))))
		     (sdl-blit-surface *current-surface* (cffi:null-pointer) *screen* (cffi:null-pointer))
		     (format t "Blit Surface: ~A~%" (sdl-get-error))
		     (sdl-update-window-surface *window*)
		     (sdl-delay 500)
		     (format t "Update Window: ~A~%" (sdl-get-error)))))
    (cleanup)))

