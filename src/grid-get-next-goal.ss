(define get-next-goal 
  (lambda (point)
    (let* ((lst1 (cons point (adjacento point)))
           (lst0 (randomize lst1))
           (flst (gcalculate-h-goal lst0))
           (lst (map list flst lst0))) 
      (set! queue '())
      (enqueue lst)
      (set! queue (reverse queue))
      (let ((num (random 10))
            (len (length lst0))
            (best (front)))
         (cond 
           ((= num 0)
               (list-ref lst0 (random len))) 
           ((< num 2)
               (gblast (adjacent point))
               point)
           ((< num 5)
               (gbuild (adjacent point))
               point)
           (else
               best))))))
 
(define gblast
  (lambda (lst)
    (if (not (null? lst))
      (let* ((pt (car lst))
             (x (car pt))
             (y (cadr pt)))
        (cond ((= (get-node grid x y) obstacle)
          (set-node! grid x y free)
          (send canvas make-now-free x y)))
        (gblast (cdr lst))))))

(define gbuild
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
            (gbuild (cdr blst))))))))


(define gcalculate-h-goal
  (lambda (lst)
    (map gh-goal lst)))

(define gh-goal
  (lambda (point)
    (+ (abs (- (car point) (car robot)))
       (abs (- (cadr point) (cadr robot))))))   

