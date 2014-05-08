;;(load "ga-neural-networks.ss")

(define (get-next-robot point)
    (let* ((inst (r-send-attr-packet point))
           (retn (r-act inst 0 point)))
      retn)

;;  (let* ((lst1 (cons point (adjacento point)))
;;         (lst0 (randomize lst1))
;;         (flst (r-calculate-h lst0))
;;         (lst (map list flst lst0)))
;;    (set! queue '())
;;    (enqueue lst)
;;    (let* ((num (random 10))
;;           (len (length lst0))
;;           (randpt (list-ref lst0 (random len)))
;;           (best (front)))
;;      (cond
;;       ((= num 0)
;;        randpt)
;;       ((< num 4)
;;        (r-blast (adjacent point))
;;        point)
;;       ((< num 5)
;;        (r-build (adjacent point))
;;        point)
;;       (else
;;        best))))
  )

;;Compiles a list of current state attributes and sends them to the neural network
(define (r-send-attr-packet agent)
  (let* ((xR (car agent))
         (yR (cadr agent))
         (all (adjacent agent))
         (free (adjacento agent))
         (aN (get-block-value all free (list (car agent) (- (cadr agent) 1))))
         (aE (get-block-value all free (list (+ (car agent) 1) (cadr agent))))
         (aS (get-block-value all free (list (car agent) (+ (cadr agent) 1))))
         (aW (get-block-value all free (list (- (car agent) 1) (cadr agent))))
         (xG (car goal))
         (yG (cadr goal))
         (packet (list aN aE aS aW xR yR xG yG))
         (inst (nn-decide packet)))
    (display "Robot sends packet: ") (display packet) (newline)
    inst))

(define (get-block-value all free pair)
  (if (look-for pair all)
      (if (look-for pair free)
          0
          10000)
      20000))

(define (look-for pair lst)
  (if (null? lst)
      #f
      (if (equal? pair (car lst))
          #t
          (look-for pair (cdr lst)))))

;;THIS IS TEMPORARY UNTIL THE NEURAL NETWORK FILES CAN USE THE INPUT PACKET TO GENERATE A LIST OF INSTRUCTIONS
;;(define (nn-decide lst)
;;  (if (< (car lst) 10000)
;;      (list 'mn)
;;      (if (< (cadr lst) 10000)
;;          (list 'me)
;;          (if (< (cadddr lst) 10000)
;;              (list 'mw)
;;              (if (< (caddr lst) 10000)
;;                  (list 'ms))))))

;;Takes an instruction list from the neural network and enacts them
(trace-define (r-act inst numDest agent)
  (display "r-act") (newline)
  (if (null? inst)
      (begin
        (if (> numDest 0)
            (begin
              (display "Robot did raise on high the Holy Hand Grenade of Antioch and count to ") (display numDest) (newline)))
        (cond ((< (cadr agent) 0)
               (list (car agent) (+ (cadr agent) 1)))
              ((> (car agent) num-col-row)
               (list (- (car agent) 1) (cadr agent)))
              ((> (cadr agent) num-col-row)
               (list (car agent) (- (cadr agent) 1)))
              ((< (- (car agent) 1) 0)
               (list (+ (car agent) 1) (cadr agent)))
              (else
               agent)))
      (begin
        (display (car agent)) (newline)
      (cond
       ((eqv? (car inst) 'mn)
        (r-act (cdr inst) 0 (list (car agent) (- (cadr agent) 1)))) ;Return coords up from agent
       ((eqv? (car inst) 'me)
        (r-act '() 0 (list (+ (car agent) 1) (cadr agent)))) ;Return coords right from agent
       ((eqv? (car inst) 'ms)
        (r-act '() 0 (list (car agent) (+ (cadr agent) 1)))) ;Return coords down from agent
       ((eqv? (car inst) 'mw)
        (r-act '() 0 (list (- (car agent) 1) (cadr agent)))) ;Return coords left from agent
       ((eqv? (car inst) 'dn)
        (begin
          (display "Destroy North:")(newline)
          (r-blast (list (car agent) (- (cadr agent) 1)))
          (r-act (cdr inst) (+ numDest 1) agent)))
       ((eqv? (car inst) 'de)
        (begin
          (display "Destroy East:")(newline)
          (r-blast (list (+ (car agent) 1) (cadr agent)))
          (r-act (cdr inst) (+ numDest 1) agent)))
       ((eqv? (car inst) 'ds)
        (begin
          (display "Destroy South:")(newline)
          (r-blast (list (car agent) (+ (cadr agent) 1)))
          (r-act (cdr inst) (+ numDest 1) agent)))
       ((eqv? (car inst) 'dw)
        (begin
          (display "Destroy West:")(newline)
          (r-blast (list (- (car agent) 1) (cadr agent)))
          (r-act (cdr inst) (+ numDest 1) agent)))
       ((eqv? (car inst) 'bn)
        (begin
          (r-build (list (car agent) (- (cadr agent) 1)))
          (r-act '() 0 agent))) ;Return current coords
       ((eqv? (car inst) 'be)
        (begin
          (r-build (list (+ (car agent) 1) (cadr agent)))
          (r-act '() 0 agent))) ;Return current coords
       ((eqv? (car inst) 'bs)
        (begin
          (r-build (list (car agent) (+ (cadr agent) 1)))
          (r-act '() 0 agent))) ;Return current coords
       ((eqv? (car inst) 'bw)
        (begin
          (r-build (list (- (car agent) 1) (cadr agent)))
          (r-act '() 0 agent))) ;Return current coords
       ((eqv? (car inst) 's)
        (r-act '() 0 agent)))))) ;Return current coords

;;Destroys all requested neighboring obstacles
(define r-blast
  (lambda (lst)
    (if (not (null? lst))
        (let* ((pt (car lst))
               (x (car pt))
               (y (cadr pt)))
          (cond ((= (get-node grid x y) obstacle)
                 (set-node! grid x y free)
                 (if gui
                     (send canvas make-now-free x y))))
          (r-blast (cdr lst))))))

;;Builds obstacles in all requested neighboring space
(define r-build
  (lambda (lst)
    (if (not (null? lst))
        (let* ((blst (randomize lst))
               (pt (car blst))
               (x (car pt))
               (y (cadr pt)))
          (cond
           ((= (get-node grid x y) free)
            (set-node! grid x y obstacle)
            (if gui
                (send canvas make-obstacle x y)))
           (else
            (r-build (cdr blst))))))))

;;(define r-calculate-h
;;  (lambda (lst)
;;    (map r-h lst)))

;;(define r-h
;;  (lambda (point)
;;    (+ (abs (- (car point) (car goal)))
;;       (abs (- (cadr point) (cadr goal))))))