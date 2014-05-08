;;(cd "/Users/tonyknapp/git/grid-predator-prey/src")

(define nn-destroy-threshold 0.5)
(define nn-chromo-m '( '[ '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ]))
(define nn-chromo-d '( '[ '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ]))
(define nn-chromo-b '( '[ '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ]))
(define nn-chromo-n '( '[ '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ]))


(define (nn-set-chromo-m! lst) ;; Called by GA, sets weights for Movement Network
  (let* ((decimal-lst (nn-map-binary-to-decimal lst))
         (first-layer-lst (list-head decimal-lst 45))
         (second-layer-lst (list-head (list-tail decimal-lst 45) 30))
         (third-layer-lst (list-tail decimal-lst 75)))
    (set! nn-chromo-m (list
                    (nn-split-list first-layer-lst 9)
                    (nn-split-list second-layer-lst 6)
                    (nn-split-list third-layer-lst 6)))))

(define (nn-set-chromo-d! lst) ;; Called by GA, sets weights for Destroy Network
  (let* ((decimal-lst (nn-map-binary-to-decimal lst))
         (first-layer-lst (list-head decimal-lst 45))
         (second-layer-lst (list-head (list-tail decimal-lst 45) 30))
         (third-layer-lst (list-tail decimal-lst 75)))
    (set! nn-chromo-d (list
                    (nn-split-list first-layer-lst 9)
                    (nn-split-list second-layer-lst 6)
                    (nn-split-list third-layer-lst 6)))))

(define (nn-set-chromo-n! lst) ;; Called by GA, sets weights for Nucleus Network
  (let* ((decimal-lst (nn-map-binary-to-decimal lst))
         (first-layer-lst (list-head decimal-lst 45))
         (second-layer-lst (list-head (list-tail decimal-lst 45) 30))
         (third-layer-lst (list-tail decimal-lst 75)))
    (set! nn-chromo-n (list
                    (nn-split-list first-layer-lst 9)
                    (nn-split-list second-layer-lst 6)
                    (nn-split-list third-layer-lst 6)))))

(define (nn-set-chromo-b! lst) ;; Called by GA, sets weights for Build Network
  (let* ((decimal-lst (nn-map-binary-to-decimal lst))
         (first-layer-lst (list-head decimal-lst 45))
         (second-layer-lst (list-head (list-tail decimal-lst 45) 30))
         (third-layer-lst (list-tail decimal-lst 75)))
;;    (display (length first-layer-lst)) (newline)
;;    (display (length second-layer-lst)) (newline)
;;    (display (length third-layer-lst)) (newline)
    (set! nn-chromo-b (list
                    (nn-split-list first-layer-lst 9)
                    (nn-split-list second-layer-lst 6)
                    (nn-split-list third-layer-lst 6)))))

(define (nn-map-binary-to-decimal lst) ;; Convert a 5 bit binary number to a value between -16 to 15
  (map
   (lambda (x)
     (nn-convert-gene-to-weight x))
   lst))

(define (nn-convert-gene-to-weight lst)
  (nn-convert-gene-to-weight-helper lst 0 0))

(define (nn-convert-gene-to-weight-helper lst ind tot)
   (if (null? lst)
       (- tot 15)
       (nn-convert-gene-to-weight-helper (cdr lst) (+ 1 ind) (+ tot (* (car lst) (expt 2 ind))))))
                                   
(trace-define (nn-split-list lst num) ; (nn-split-list '(1 2 3 1 2 3) 3)
  (nn-split-list-helper lst '() num)) 

(trace-define (nn-split-list-helper lst-gvn lst-rtn ind-gvn)
  (if (null? lst-gvn)
      lst-rtn
      (nn-split-list-helper (list-tail lst-gvn ind-gvn) (append lst-rtn (list (list-head lst-gvn ind-gvn))) ind-gvn)))


(define (nn-decide lst) ;;Called by agent. Returns an instruction list.
  (let* ((action-lst (nn-helper lst nn-chromo-n))
         (action (nn-max-index action-lst)))
    (cond
     ((= action 0)
      (nn-move (nn-helper lst nn-chromo-m)))
     ((= action 1)
      (nn-destroy (nn-helper lst nn-chromo-d)))
     ((= action 2)
      (nn-build (nn-build lst nn-chromo-b)))
     (else
      (list 's)))))

(define (nn-max-index lst)
  (nn-max-index-helper lst 0 0 0))

(define (nn-max-index-helper lst current-ind max-ind nn-max)
  (if (null? lst)
     max-ind
      (if (> (car lst) nn-max)
          (nn-max-index-helper (cdr lst) (+ current-ind 1) (+ max-ind 1) (car lst))
          (nn-max-index-helper (cdr lst) (+ current-ind 1) max-ind nn-max))))

(define (nn-move lst) ;; Called by nn-decide, returns a list of a movement
  (let* ((action-lst (nn-helper lst nn-chromo-m))
         (action (nn-max-index action-lst)))
    (cond
     ((= action 0)
      (list 'mn))
     ((= action 1)
      (list 'me))
     ((= action 2)
      (list 'ms))
     (else
      (list 'mw)))))

(define (nn-destroy lst) ;; Called by nn-decide, returns a list of destroy commands
  (nn-destroy-threshold-helper '() (nn-helper lst nn-chromo-d) 0))
    
(define (nn-destroy-threshold-helper rtn-lst gvn-lst ind) ;; Called by nn-destroy, determines if outputs are indicitive of destruction or not.
  (if (null? gvn-lst)    ;; Given a list like (0.4 0.6 0.7 0.4) --> ('de 'ds)
      rtn-lst
      (if (> (car gvn-lst) nn-destroy-threshold)
          (cond
           ((= ind 0)
            (nn-destroy-threshold-helper (append rtn-lst '('dn)) (cdr gvn-lst) (+ 1 ind)))
           ((= ind 1)                      
            (nn-destroy-threshold-helper (append rtn-lst '('de)) (cdr gvn-lst) (+ 1 ind)))
           ((= ind 2)                      
            (nn-destroy-threshold-helper (append rtn-lst '('ds)) (cdr gvn-lst) (+ 1 ind)))
           ((= ind 3)                     
            (nn-destroy-threshold-helper (append rtn-lst '('dw)) (cdr gvn-lst) (+ 1 ind))))
          (cond
           ((= ind 0)
            (nn-destroy-threshold-helper rtn-lst (cdr gvn-lst) (+ 1 ind)))
           ((= ind 1)
            (nn-destroy-threshold-helper rtn-lst (cdr gvn-lst) (+ 1 ind)))
           ((= ind 2)                            
            (nn-destroy-threshold-helper rtn-lst (cdr gvn-lst) (+ 1 ind)))
           ((= ind 3)                            
            (nn-destroy-threshold-helper rtn-lst (cdr gvn-lst) (+ 1 ind)))))))
    
(define (nn-build lst)
  (let* ((action-lst (nn-helper lst nn-chromo-b))
         (action (nn-max-index action-lst)))
    (cond
     ((= action 0)
      (list 'bn))
     ((= action 1)
      (list 'be))
     ((= action 2)
      (list 'bs))
     (else
      (list 'bw)))))

#|=============== Begin Parker Code ================== |#

(define (nn-helper lst tw)
  (display lst) ;Print our inputs
  (newline)
  (if (null? tw) ;If there are no layers
      lst ;Return unchanged inputs
      ;else
      (let ((next-level (get-next-level lst (car tw)))) ;Pass all inputs and the first layer thresholds
        (nn-helper next-level (cdr tw))))) ;Pass next level inputs and the remaining layer threshold weights

(define (nn-get-next-level lst twl) ;Receives list of inputs for this layer and this layer's threshold weights
  (if (null? twl) ;If there are no more layers in the threshold list
      '() ;No next-level, done
      ;else
      (cons ;Return a list of:
       (get-node lst (car twl)) ;Pass inputs and the first neuron's thresholds on this layer
       (get-next-level lst (cdr twl))))) ;Recurse with the inputs and the rest of the neurons' thresholds on this layer

(define (nn-get-node lst twn) ;Receives the inputs this neuron's threshold weights
  (let ((threshold (car twn)) ;Gets a threshold for the neuron
        (weights (cdr twn))) ;Get the weights for the neuron
    (g ;Return the output of the neuron
     (+ ;Sum the threshold with the weighted inputs
      (get-activations lst weights) ;Sum the inputs, after multplying them with their weights
      (- threshold))))) ;Make the threshold negavitive

(define (nn-get-activations lst w)
  (if (null? lst) 
      0
      (+ 
       (* 
        (car lst) 
        (car w)) 
       (get-activations 
        (cdr lst) (cdr w)))))

(define (nn-sigmoid x)
  (/ 1 (+ 1 (exp (- x)))))
