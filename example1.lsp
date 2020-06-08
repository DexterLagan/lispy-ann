; Load genann wrapper
(load "genann.lsp")

;;; main

(println "GENANN example 1.")
(println "Train a small ANN to the XOR function using backpropagation.")

; Input and expected out data for the XOR function.
(define input  '((0 0) (0 1) (1 0) (1 1)))
(define output '(0 1 1 0))

; initialize random number generator
(seed (time-of-day))

; Initialize a new neural network with 2 inputs, 1 hidden layer of 2 neurons and 1 output.
(set 'ann (genann:init 2 1 2 1))

; Train on the four labeled data points many times.
(for (i 0 3000)
   (genann:train ann (pack "lf lf" (input 0)) (pack "lf" (output 0)) 3)
   (genann:train ann (pack "lf lf" (input 1)) (pack "lf" (output 1)) 3)
   (genann:train ann (pack "lf lf" (input 2)) (pack "lf" (output 2)) 3)
   (genann:train ann (pack "lf lf" (input 3)) (pack "lf" (output 3)) 3))

; Run the network and see what it predicts.
(println "Output for " (input 0 0) ", " (input 0 1) " is " (format "%1.f" (get-float (genann:run ann (pack "lf lf" (input 0))))))
(println "Output for " (input 1 0) ", " (input 1 1) " is " (format "%1.f" (get-float (genann:run ann (pack "lf lf" (input 1))))))
(println "Output for " (input 2 0) ", " (input 2 1) " is " (format "%1.f" (get-float (genann:run ann (pack "lf lf" (input 2))))))
(println "Output for " (input 3 0) ", " (input 3 1) " is " (format "%1.f" (get-float (genann:run ann (pack "lf lf" (input 3))))))

; Free memory
(genann:free ann)

(exit)
