(define num-col-row 30)
(define size (floor (/ 700 num-col-row)))
(define obstacle-density 0)
(define pause-num 500)
(define step-count 0)
(define gui #t)
(if gui
    (set! pause-num 500))
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
