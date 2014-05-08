(define randomize
  (lambda (lst)
    (let ((size (length lst)))
      (cond 
        ((< size 2) lst)
        (else
          (let ((node-num (random size)))
            (cons (list-ref lst node-num) 
                  (randomize (removex node-num lst)))))))))

(define removex
  (lambda (num lst)
    (if (= num 0)
      (cdr lst)
    ;else
      (cons (car lst) (removex (- num 1) (cdr lst)))))) 

(define get-next-goal0 
  (lambda (point)
      (if (< (+ (abs (- (car robot) (car point))) 
                (abs (- (cadr robot) (cadr point)))) 2)
          point
      ;else
         (get-next-goal point)))) 
            
(define search
  (lambda (grid stop-count)
    (search2 grid 1 stop-count)))

(define search2
  (lambda (grid count stop-count)
    (cond 
      ((equal? robot goal)
        (display "Robot attains the goal: ") (display count) (newline)
       (if gui
        (draw-robot))
       count)
      ((>= count stop-count)
        ;(display "Took too long")
        ;(newline)
        count)
      (else
        (pause pause-num)
        (search-robot grid)
        (if (null? robot)
          (display "Cannot reach the goal")
          (begin
            (pause pause-num)
            (search-goal grid)
            (search2 grid (+ count 1) stop-count)))))))

(define search-robot
  (lambda (grid)
    (let ((next-robot (get-next-robot robot)))
      (if gui
          (send canvas make-now-free (robot-x) (robot-y)))
      (set! robot next-robot)
      (if (and gui (not (null? robot)))
        (draw-robot)))))

(define search-goal
  (lambda (grid)
    (let ((next-goal (get-next-goal0 goal)))
      (if gui
          (send canvas make-now-free (car goal) (cadr goal)))
      (set! goal next-goal)
      (if gui
          (draw-goal)))))
