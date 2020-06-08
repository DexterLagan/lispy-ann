; Load genann wrapper
(load "genann.lsp")

;;; main

(println "GENANN example 2.")
(println "Train a small ANN to the XOR function using random search.")

(constant 'FLOAT-LENGTH 8)

; Input and expected out data for the XOR function.
(define input  '((0 0) (0 1) (1 0) (1 1)))
(define output '(0 1 1 0))

; Initialize a new neural network with 2 inputs, 1 hidden layer of 2 neurons and 1 output.
(setq ann (genann:init 2 1 2 1))

(setq err 0)
(setq last-err 1000)
(setq counter 0)

; initialize random number generator
(seed (time-of-day))

(do-while (> err 0.01)

  (inc counter)
  (if (= (mod counter 1000) 0) ; randomize ANN every 1000 iteration.
    ; We're stuck, start over.
    (genann:randomize-ann ann))

  ; Unpack the ann into a struct
  (setq ann-contents       (unpack genann:network ann))
  (setq genann:inputs        		  (ann-contents 0))
  (setq genann:hidden_layers 		  (ann-contents 1))
  (setq genann:hidden_neurons		  (ann-contents 2))
  (setq genann:outputs           	  (ann-contents 3))
  (setq genann:activation_hidden_func (ann-contents 4))
  (setq genann:activation_output_func (ann-contents 5)) 
  (setq genann:total_weights 		  (ann-contents 6))   
  (setq genann:total_neurons		  (ann-contents 7))
  (setq genann:weight-ptr		  (ann-contents 8))
  (setq genann:output-ptr		  (ann-contents 9))
  (setq genann:delta-ptr		  (ann-contents 10))

  ; make a backup copy of the ANN for later retrieval in case our error increases.
  (setq backup-network (genann:copy-ann ann))

  ; Take a random guess at the ANN weights.
  (for (i 0 (- genann:total_weights 1)) ; step 1 by default
    (letn (src-addr    	(+ genann:weight-ptr (* i FLOAT-LENGTH))
           existing  	(get-float src-addr)
	     rand-num     (sub (div (rand genann:RAND_MAX) genann:RAND_MAX) 0.5) ; <==> (random -0.5 1.0)
	     new-value    (add existing rand-num)
	     packed-value (pack "lf" new-value))
      (cpymem packed-value src-addr FLOAT-LENGTH))) ; using the 64 bits double size = 8 bytes

  ; See how we did
  (setq err 0)
  (for (input-num 0 3)
  	(letn (input-pair (input input-num)
		 packed  (pack "lf lf" input-pair)
         	 result  (get-float (genann:run ann packed))
	   	 delta   (sub result (output input-num))
	   	 powered (pow delta 2.0)
       	 added   (add err powered))
	   (setq err added)))

  ; Keep these weights if they're an improvement.
  (if (< err last-err) 				; if error is lower than previous,
      (begin (genann:free backup-network) ; clear backup
             (setq last-err err))
      (begin (genann:free ann)		; else, clear current ann
		 (setq ann backup-network))))

(println "Finished in " counter " loop(s).")

; Run the network and see what it predicts.
(println "Output for " (input 0 0) ", " (input 0 1) " is " (format "%1.f" (get-float (genann:run ann (pack "lf lf" (input 0))))))
(println "Output for " (input 1 0) ", " (input 1 1) " is " (format "%1.f" (get-float (genann:run ann (pack "lf lf" (input 1))))))
(println "Output for " (input 2 0) ", " (input 2 1) " is " (format "%1.f" (get-float (genann:run ann (pack "lf lf" (input 2))))))
(println "Output for " (input 3 0) ", " (input 3 1) " is " (format "%1.f" (get-float (genann:run ann (pack "lf lf" (input 3))))))

; Free memory
(genann:free ann)
(genann:free backup-network)

(exit)

; EOF