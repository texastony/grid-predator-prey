(define destroy-threshold 0.5)
(define chromo-m '( '[ '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ]))
(define chromo-d '( '[ '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ]))
(define chromo-b '( '[ '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ]))
(define chromo-n '( '[ '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) '(0 0 0 0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ] '[ '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) '(0 0 0 0 0 0) ]))


(define (nn-set-chromo-m! lst)
  (let* ((decimal-lst (nn-map-binary-to-decimal lst))
         (first-layer-lst (list-head decimal-lst 45))
         
(define (nn-map-binary-to-decimal lst)
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
         
;A list of all layers
;- A list of all neurons on that layer
; - A list of weights for each inputs of the neuron and a threshold weight:
;AND:  [(1.5 1 1)]
;OR:   [(.5 1 1)]
;NOT:  [(-1 -1)]
;XOR:  [(.6 1 -.5)(.6 -.5 1)] [(.4 1 1)]
;XNOR: [(.6 1 -.5)(.6 -.5 1)] [(.4 1 1)] [(-1 -1)]
(define threshold-weights '( [(.6 1 -.5)(.6 -.5 1)] [(.4 1 1)] [(-1 -1) (1 -1)]))

(define (nn lst) ;Run this from console, give it 1 or 2 input values
  (nn-helper lst threshold-weights))

(define (nn-helper lst tw)
  (display lst) ;Print our inputs
  (newline)
  (if (null? tw) ;If there are no layers
      lst ;Return unchanged inputs
      ;else
      (let ((next-level (get-next-level lst (car tw)))) ;Pass all inputs and the first layer thresholds
        (nn-helper next-level (cdr tw))))) ;Pass next level inputs and the remaining layer threshold weights

(define (get-next-level lst twl) ;Receives list of inputs for this layer and this layer's threshold weights
  (if (null? twl) ;If there are no more layers in the threshold list
      '() ;No next-level, done
      ;else
      (cons ;Return a list of:
       (get-node lst (car twl)) ;Pass inputs and the first neuron's thresholds on this layer
       (get-next-level lst (cdr twl))))) ;Recurse with the inputs and the rest of the neurons' thresholds on this layer

(define (get-node lst twn) ;Receives the inputs this neuron's threshold weights
  (let ((threshold (car twn)) ;Gets a threshold for the neuron
        (weights (cdr twn))) ;Get the weights for the neuron
    (g ;Return the output of the neuron
     (+ ;Sum the threshold with the weighted inputs
      (get-activations lst weights) ;Sum the inputs, after multplying them with their weights
      (- threshold))))) ;Make the threshold negavitive

(define (get-activations lst w)
  (if (null? lst)
      0
      (+ 
       (* 
        (car lst) 
        (car w)) 
       (get-activations 
        (cdr lst) (cdr w)))))

(define (sigmoid x)
  (/ 1 (+ 1 (exp (- x)))))
       
(define (nn-decide lst) ;;Called by agent. Returns an instruction list.
  (let* ((action-lst (nn-helper lst chromo-n))
         (action (nn-max-index action-lst)))
    (cond
     ((= action 0)
      (nn-move (nn-helper lst chromo-m)))
     ((= action 1)
      (nn-destroy (nn-helper lst chromo-d)))
     ((= action 2)
      (nn-build (nn-build lst chromo-b)))
     (else
      (list 's)))))

(define (nn-move lst)
  (let* ((action-lst (nn-helper lst chromo-m))
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

(define (nn-destroy lst)
  (nn-destroy-threshold '() (nn-helper lst chromo-d) 0))
    
;;Given a list like (0.4 0.6 0.7 0.4) --> ('de 'ds)
(define (nn-destroy-threshold-helper rtn-lst gvn-lst ind) 
  (if (null? gvn-lst)
      rtn-lst
      (if (> (car gvn-lst) 0.5)
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
  (let* ((action-lst (nn-helper lst chromo-b))
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

(define (nn-max-index lst)
  (nn-max-index-helper lst 0 0 0))

(define (nn-max-index-helper lst current-ind max-ind nn-max)
  (if (null? lst)
     max-ind
      (if (> (car lst) nn-max)
          (nn-max-index-helper (cdr lst) (+ current-ind 1) (+ max-ind 1) (car lst))
          (nn-max-index-helper (cdr lst) (+ current-ind 1) max-ind nn-max))))


      
      

