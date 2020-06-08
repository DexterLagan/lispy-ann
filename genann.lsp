; genann.lsp
;
(context 'genann)
(println "GENANN for newLISP by Dexter Santucci v1.0. July 2018 - dexterlagan@gmail.com")

(setq is-64-bit (= 0x100 (& 0x100 (sys-info -1))))
(setq has-ffi (= 1024 (& 1024 (sys-info -1)))) 

(if has-ffi
    (println "FFI detected and fully supported. Initializing library...")
    (println "Warning: this library may require newLISP to be compiled with FFI."))

;;; constants

(define RAND_MAX 32767)

;;; structures

; Define a genann structure
; IMPORTANT NOTE: all pointers shall be described at 'void*'
(struct 'network "int"     ; number of inputs
                 "int"     ; number of hidden_layers
                 "int"     ; number of hidden_neurons
                 "int"     ; number of outputs
                 "void*"   ; activation_hidden_func
                 "void*"   ; activation_output_func
                 "int"     ; total_weights
                 "int"     ; total_neurons
                 "void*"  ; weight - pointer to array of weights (array size: total_weights)
                 "void*"  ; pointer to array of input/output (array size: total_neurons)
                 "void*") ; pointer to array of delta of each hidden and output neuron
                           ; (array size: total_neurons - inputs)

;;; public functions

; Creates and returns a new ann.
; genann *genann_init(int inputs, int hidden_layers, int hidden, int outputs)
(setq init (import "genann.dll" "genann_init" "void*" "int" "int" "int" "int"))

; Creates ANN from file saved with genann_write.
; genann *genann_read(FILE *in)
(setq read-ann (import "genann.dll" "genann_read" "void*" "void*"))

; Sets weights randomly. Called by init.
; void genann_randomize(genann *ann)
(setq randomize-ann (import "genann.dll" "genann_randomize" "void" "void*"))

; Returns a new copy of ann.
; genann *genann_copy(genann const *ann)
(setq copy-ann (import "genann.dll" "genann_copy" "void*" "void*"))

; Frees the memory used by an ann.
; void genann_free(genann *ann)
(setq free (import "genann.dll" "genann_free" "void" "void*"))

; Runs the feedforward algorithm to calculate the ann's output.
; double const *genann_run(genann const *ann, double const *inputs)
(setq run (import "genann.dll" "genann_run" "void*" "void*" "void*"))

; Does a single backprop update.
; void genann_train(genann const *ann, double const *inputs,
;                   double const *desired_outputs, double learning_rate)
(setq train (import "genann.dll" "genann_train" "void" "void*" "void*" "void*" "double"))

; Saves the ann.
; void genann_write(genann const *ann, FILE *out)
(setq write-ann (import "genann.dll" "genann_write" "void" "void*" "void*"))

;;; internal functions

; void genann_init_sigmoid_lookup(const genann *ann)
(setq init_sigmoid_lookup (import "genann.dll" "genann_init_sigmoid_lookup" "void" "void*"))

; double genann_act_sigmoid(const genann *ann, double a)
(setq act_sigmoid (import "genann.dll" "genann_act_sigmoid" "double" "void*" "double"))

; double genann_act_sigmoid_cached(const genann *ann, double a)
(setq act_sigmoid_cached (import "genann.dll" "genann_act_sigmoid_cached" "double" "void*" "double"))

; double genann_act_threshold(const genann *ann, double a)
(setq act_threshold (import "genann.dll" "genann_act_threshold" "double" "void*" "double"))

; double genann_act_linear(const genann *ann, double a)
(setq act_linear (import "genann.dll" "genann_act_linear" "double" "void*" "double"))

(println "Library initialized successfully.")

; EOF
