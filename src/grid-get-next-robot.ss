(define get-next-robot 
  (lambda (point)
    (let* ((lst1 (cons point (adjacento point))) 
           (lst0 (randomize lst1))
           (flst (rcalculate-h lst0))
           (lst (map list flst lst0))) 
      (set! queue '())
      (enqueue lst)
      (let* ((num (random 10))
             (len (length lst0))
             (randpt (list-ref lst0 (random len)))
             (best (front)))
         (cond 
           ((= num 0)
               randpt)
           ((< num 4)
               (rblast (adjacent point))
               point)
           ((< num 5)
               (rbuild (adjacent point))
               point)
           (else
              best))))))

(define rblast
  (lambda (lst)
    (if (not (null? lst))
      (let* ((pt (car lst))
             (x (car pt))
             (y (cadr pt)))
        (cond ((= (get-node grid x y) obstacle)
          (set-node! grid x y free)
          (send canvas make-now-free x y)))
        (rblast (cdr lst))))))

(define rbuild
  (lambda (lst)
    (if (not (null? lst))
      (let* ((blst (randomize lst))
             (pt (car blst))
             (x (car pt))
             (y (cadr pt)))
        (cond 
          ((= (get-node grid x y) free)
            (set-node! grid x y obstacle)
            (send canvas make-obstacle x y))
          (else
            (rbuild (cdr blst))))))))     
            
(define rcalculate-h
  (lambda (lst)
    (map rh lst)))

(define rh
  (lambda (point)
    (+ (abs (- (car point) (car goal)))
       (abs (- (cadr point) (cadr goal))))))

