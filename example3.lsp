
; Load genann wrapper
(load "genann.lsp")

(define save-name "example/xor.ann")

(define LIBC (lookup ostype '(("Windows" "msvcrt.dll")
	                        ("OSX" "libc.dylib")
					("Linux" "libc.so"))))

(import LIBC "fopen")
(import LIBC "fclose")

;;; main

(println "GENANN example 3")
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
