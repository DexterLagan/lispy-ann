
;;; headers

; Load genann wrapper
(load "genann.lsp")

; This example is to illustrate how to use GENANN.
; It is NOT an example of good machine learning techniques.

(define iris-data "example/iris.data")
(define class-names '("Iris-setosa" "Iris-versicolor" "Iris-virginica")

(define LIBC (lookup ostype '(("Windows" "msvcrt.dll")
	                        ("OSX" "libc.dylib")
					("Linux" "libc.so"))))

(import LIBC "fopen")
(import LIBC "fclose")
(import LIBC "fseek")
(import LIBC "fgets")

;;; defs

(define (load_data) (

  ; Load the iris data-set.

;  (setq in (fopen iris-data "r"))
;  (when (nil? in)
;      (println (format "Couldn't open file: %s\n" iris_data))
;      (exit 1))


  ; Load the iris data-set.
  (set 'in-file (open "afile.dat" "read"))

  (define samples 0)

  ; Loop through the data to get a count.
  (while (read-line in-file)
         samples++) 
  

  (seek in-file 0)










  ; Loop through the data to get a count.
  
;;; main

(println "GENANN example 4")
(println "Load a saved ANN to solve the XOR function.")

(setq saved (fopen save-name "r"))

(when (nil? saved)
      (println (format "Couldn't open file: %s\n" save_name))
      (exit 1))

(setq ann (genann:read-ann saved))

(fclose saved)

(when (nil? ann)
	(println (format "Error loading ANN from file: %s." save_name))
	(exit 1))

; Input data for the XOR function.
(define input  '((0 0) (0 1) (1 0) (1 1)))

; Run the network and see what it predicts.
(println "Output for " (input 0 0) ", " (input 0 1) " is " (format "%1.f" (get-float (genann:run ann (pack "lf lf" (input 0))))))
(println "Output for " (input 1 0) ", " (input 1 1) " is " (format "%1.f" (get-float (genann:run ann (pack "lf lf" (input 1))))))
(println "Output for " (input 2 0) ", " (input 2 1) " is " (format "%1.f" (get-float (genann:run ann (pack "lf lf" (input 2))))))
(println "Output for " (input 3 0) ", " (input 3 1) " is " (format "%1.f" (get-float (genann:run ann (pack "lf lf" (input 3))))))

; Free memory
(genann:free ann)

(exit 0)
