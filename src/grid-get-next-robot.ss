(define (get-next-robot point)
  (let* ((lst1 (cons point (adjacento point)))
         (lst0 (randomize lst1))
         (flst (r-calculate-h lst0))
         (lst (map list flst lst0)))
    (set! queue '())
    (enqueue lst)
    
    ;I think this is worthless:
    (let* ((num (random 10))
           (len (length lst0))
           (randpt (list-ref lst0 (random len)))
           (best (front)))
      (cond
       ((= num 0)
        randpt)
       ((< num 4)
        (r-blast (adjacent point))
        point)
       ((< num 5)
        (r-build (adjacent point))
        point)
       (else
        best)))
    ;END worthless
    
    (let* ((inst (r-send-attr-packet))
           (retn (r-act inst 0)))
      retn)))

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

(define (r-act inst numDest)
  (if (not (null? inst))
      (let* ((x (car inst)))
        (cond
         ((eqv? x 'mn)
          (list (car robot) (- (cadr robot) 1))) ;Return coords up from robot
         ((eqv? x 'me)
          (list (+ (car robot) 1) (cadr robot))) ;Return coords right from robot
         ((eqv? x 'ms)
          (list (car robot) (+ (cadr robot) 1))) ;Return coords down from robot
         ((eqv? x 'mw)
          (list (- (car robot) 1) (cadr robot))) ;Return coords left from robot
         ((eqv? x 'dn)
          (begin
            (set! numDest (r-blast (car robot) (- (cadr robot) 1)))
            numDest))
         ((eqv? x 'de)
          (#|move(east)|#))
         ((eqv? x 'ds)
          (#|move(east)|#))
         ((eqv? x 'dw)
          (#|move(east)|#))
         ((eqv? x 'bn)
          (begin
            (r-build (car robot) (- (cadr robot) 1))
            robot)) ;Return current coords
         ((eqv? x 'be)
          (begin
            (r-build (+ (car robot) 1) (cadr robot))
            robot)) ;Return current coords
         ((eqv? x 'bs)
          (begin
            (r-build (car robot) (+ (cadr robot) 1))
            robot)) ;Return current coords
         ((eqv? x 'bw)
          (begin
            (r-build (- (car robot) 1) (cadr robot))
            robot)) ;Return current coords
         ((eqv? x 's)
          robot)) ;Return current coords
        (r-act (cdr inst)))
      ((if (> numDest 0)
           (begin
             (display "Robot did raise on high the Holy Hand Grenade of Antioch and count to ") (display numDest))
           ()))))

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

(define r-calculate-h
  (lambda (lst)
    (map r-h lst)))

(define r-h
  (lambda (point)
    (+ (abs (- (car point) (car goal)))
       (abs (- (cadr point) (cadr goal))))))