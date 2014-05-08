(define (get-next-robot point)
    (let* ((inst (r-send-attr-packet))
           (retn (r-act inst 0)))
      (display retn))

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
(define (r-send-attr-packet)
  (let* ((xR (car robot))
         (yR (cadr robot)))
    (set! packet '[(get-node grid xR yR-1)
                   (get-node grid xR+1 yR)
                   (get-node grid xR yR+1)
                   (get-node grid xR-1 yR)
                   (xR)
                   (yR)
                   (car goal)
                   (cadr goal)])
    (let ((inst (nn-decide packet)))
      (display "Robot sends packet: ") (display packet) (newline)
      inst)))

;;Takes an instruction list from the neural network and enacts them
(trace-define (r-act inst numDest)
  (if (not (null? inst))
      (let ((x (car inst))
            (retn '()))
        (cond
         ((eqv? x 'mn)
          (set! retn (list (car robot) (- (cadr robot) 1)))) ;Return coords up from robot
         ((eqv? x 'me)
          (set! retn (list (+ (car robot) 1) (cadr robot)))) ;Return coords right from robot
         ((eqv? x 'ms)
          (set! retn (list (car robot) (+ (cadr robot) 1)))) ;Return coords down from robot
         ((eqv? x 'mw)
          (set! retn (list (- (car robot) 1) (cadr robot)))) ;Return coords left from robot
         ((eqv? x 'dn)
          (begin
            (display "Destroy North:")(newline)
            (r-blast (car robot) (- (cadr robot) 1))
            (set! numDest (+ numDest 1))))
         ((eqv? x 'de)
          (begin
            (display "Destroy East:")(newline)
            (r-blast (+ (car robot) 1) (cadr robot))
            (set! numDest (+ numDest 1))))
         ((eqv? x 'ds)
          (begin
            (display "Destroy South:")(newline)
            (r-blast (car robot) (+ (cadr robot) 1))
            (set! numDest (+ numDest 1))))
         ((eqv? x 'dw)
          (begin
            (display "Destroy West:")(newline)
            (r-blast (- (car robot) 1) (cadr robot))
            (set! numDest (+ numDest 1))))
         ((eqv? x 'bn)
          (begin
            (r-build (car robot) (- (cadr robot) 1))
            (set! retn robot))) ;Return current coords
         ((eqv? x 'be)
          (begin
            (r-build (+ (car robot) 1) (cadr robot))
            (set! retn robot))) ;Return current coords
         ((eqv? x 'bs)
          (begin
            (r-build (car robot) (+ (cadr robot) 1))
            (set! retn robot))) ;Return current coords
         ((eqv? x 'bw)
          (begin
            (r-build (- (car robot) 1) (cadr robot))
            (set! retn robot))) ;Return current coords
         ((eqv? x 's)
          (set! retn robot))) ;Return current coords
        (r-act (cdr inst) numDest)
        retn)
      ((if (> numDest 0)
           (begin
             (display "Robot did raise on high the Holy Hand Grenade of Antioch and count to ") (display numDest) (newline)
             robot) ;Return current coords
           '()))))

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
