(define block-status
  (lambda (block)
    (get-node grid (car block) (cadr block))))

(define block-set!
  (lambda (block value)
    (set-node! grid (car block) (cadr block) value)))

(define adjacent
  (lambda (block)
    (let ((x (car block))
          (y (cadr block)))
      (append 
        (if (< y 1) '() (list (list x (- y 1))))
        (if (< x 1) '() (list (list (- x 1) y)))
        (if (>= y (- num-col-row 1)) '() (list (list x (+ y 1))))
        (if (>= x (- num-col-row 1)) '() (list (list (+ x 1) y)))))))

(define stepo
  (lambda (b c)
    (let ((b-status (block-status b))
          (c-status (block-status c))
          (x-diff (abs (- (car b) (car c))))
          (y-diff (abs (- (cadr b) (cadr c)))))
      (if (or (= b-status obstacle) 
              (= c-status obstacle) 
              (not (= (+ x-diff y-diff) 1)))
          #f
      ;else
          c))))

(define stepv
  (lambda (b c)
    (let ((b-status (block-status b))
          (c-status (block-status c))
          (x-diff (abs (- (car b) (car c))))
          (y-diff (abs (- (cadr b) (cadr c)))))
      (if (or (= b-status obstacle)
              (= c-status obstacle)
              (> c-status free)
              (not (= (+ x-diff y-diff) 1)))
          #f
      ;else
          c))))

(define step
  (lambda (b c)
    (let ((c-status (block-status c)))
      (if (= c-status obstacle)
          #f
      ;else
          c))))

(define adjacentv
  (lambda (block)
    (let* ((adj-lst0 (adjacent block))
           (adj-lst1 (map (lambda (z) (stepv block z)) adj-lst0)))
      (remove-f adj-lst1))))

(define adjacento
  (lambda (block)
    (let* ((adj-lst0 (adjacent block))
           (adj-lst1 (map (lambda (z) (stepo block z)) adj-lst0)))
      (remove-f adj-lst1))))

(define remove-f
  (lambda (lst)
    (if (null? lst)
        '()
    ;else
        (let ((b (car lst)))
          (if b 
              (cons b (remove-f (cdr lst)))
          ;else
              (remove-f (cdr lst)))))))