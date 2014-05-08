(define num-col-row 6)
(define size (floor (/ 700 num-col-row)))
(define obstacle-density 0)
(define pause-num 0)
(define step-count 0)
(define gui #f)
(define print #f)
(if print
    (begin
      (display "nn-chromo-m: ") (display nn-chromo-m) (newline)
      (display "nn-chromo-d: ") (display nn-chromo-d) (newline)
      (display "nn-chromo-b: ") (display nn-chromo-b) (newline)
      (display "nn-chromo-n: ") (display nn-chromo-n) (newline)
      ))
(if gui
    (set! pause-num 5000))
(if gui
    (begin
      (load "grid-class.ss")
      (load "grid-draw.ss")))
(load "grid-make.ss")
(load "grid-priority-queue.ss")

(define grid0 (make-grid num-col-row))
(if gui
    (begin
      (draw-obstacles grid0)))
(define grid (convert-grid grid0))
(load "grid-new.ss")
(load "grid-get-next-goal.ss")
(load "grid-get-next-robot.ss")
(load "grid-chase.ss")

(set-goal grid)
(set-start grid)
(set-node! grid (car goal) (cadr goal) free)

(if gui
    (begin
      (draw-start)
      (draw-goal)
      (draw-robot)
      (show canvas)))
