(define GA-CHROMOLENGTH 32)
(define GA-TARGETFITNESS 32)
(define GA-MUTATECHANCE 300)
(define ga-population '())

(define ga-genPop!
  (lambda (count)
    (set! ga-population (ga-genPop2 count))))

(define ga-genPop2
  (lambda (count)
    (if (> count 0)
        (append (list (ga-makeRandomChromo)) (ga-genPop2 (- count 1)))
        '())))

(define ga-makeRandomChromo
  (lambda ()
    (let ((chromo (ga-makeRandomChromo2 GA-CHROMOLENGTH)))
      (list (ga-getFitness chromo) chromo))))

(define ga-makeRandomChromo2
  (lambda (rem)
    (if (> rem 0)
        (append (ga-makeRandomChromo2 (- rem 1)) (list (random 2)))
        '())))

(define ga-getFitness
  (lambda (chromo)
    ;(display chromo) (newline)
    (ga-getFitness2 chromo)))

(define ga-getFitness2 
  (lambda (chromo)
    (if (null? chromo)
        0
        (+ (car chromo) (ga-getFitness (cdr chromo))))))

(define ga-expandPop
  (lambda (total vect pop index)
    (if (null? pop)
        (list total vect)
        (begin
          (vector-set! vect index (list (+ total (caar pop)) (cadar pop)))
          (ga-expandPop (+ total (caar pop)) vect (cdr pop) (+ 1 index))))))

(define ga-getParent
  (lambda (target vect index)
    (if (or (<= (vector-length vect) (+ index 1)) (> (car (vector-ref vect (+ index 1))) target))
        (list-ref ga-population index)
        (ga-getParent target vect (+ index 1)))))

(define ga-getParents
  (lambda ()
    (let* ((expanded (ga-expandPop 0 (make-vector (length ga-population)) ga-population 0))
           (total (car expanded))
           (vect (cadr expanded)))
      (list (ga-getParent (random total) vect 0) (ga-getParent (random total) vect 0)))))

(define ga-split
  (lambda (p div)
    (list 
      (ga-sub p div < 0)
      (ga-sub p div >= 0))))

(define ga-sub
  (lambda (p div op pos)
    (if (null? p)
        '()
        (if (op pos div)
            (append (list (car p)) (ga-sub (cdr p) div op (+ pos 1)))
            (ga-sub (cdr p) div op (+ pos 1))))))

(define ga-cross
  (lambda (p1 p2)
    ;(display "CROSS") (newline)
    (let* ((divide (random GA-CHROMOLENGTH))
           (p1Split (ga-split p1 divide))
           (p2Split (ga-split p2 divide)))
      (list 
        (append (car p1Split) (cadr p2Split))
        (append (cadr p1Split) (car p2Split))))))

(define ga-mutate
  (lambda (base)
    ;(display "MUTATE") (newline)
    (if (null? base)
        '()
        (append (list (list 0 (ga-mutate2 (car (cdr (car base)))))) (ga-mutate (cdr base))))))

(define ga-mutate2
  (lambda (child)
;    (display "CHILD: ") (display child) (newline) (newline)
    (if (null? child)
        '()
        (if (= 0 (random GA-MUTATECHANCE))
            (append (list (+ 1 (* -1 (car child)))) (ga-mutate2 (cdr child)))
            (append (list (car child)) (ga-mutate2 (cdr child)))))))

(define ga-breed
  (lambda ()
    (let* ((parents (ga-getParents))
           (parent1 (car parents))
           (parent2 (cadr parents))
           (offspring (ga-cross parent1 parent2))
           (mutants (ga-mutate offspring)))
      ;(display mutants) (newline) (newline)
      mutants)))

(define ga-generation
  (lambda (count)
    (ga-updateFitnesses (ga-generation2 count))))

(define ga-updateFitnesses
  (lambda (lst)
    (display lst)
    (if (null? lst)
        '()
        (append (list (list (ga-getFitness (cadar lst)) (cadar lst))) (ga-updateFitnesses (cdr lst))))))

(define ga-generation2
  (lambda (count)
    (if (= count 0)
        '()
        (append (ga-breed) (ga-generation2 (- count 2))))))

(define ga-bestFitness
  (lambda ()
    (ga-bestFitness2 
      (car ga-population)
      (cdr ga-population))))

(trace-define ga-bestFitness2
  (lambda (best pop)
    (if (null? pop)
        best
        (ga-bestFitness2 
          (if (< (car best) (caar pop))
              (car pop)
              best)
          (cdr pop)))))

(define ga-evolve
  (lambda (startingPop)
    (ga-genPop! startingPop)
    (ga-evolve2 0)))

(define ga-evolve2
  (lambda (x)
;    (if (not (= TARGETFITNESS (car (bestFitness))))
        (begin
          (set! ga-population (ga-generation (length ga-population)))
          (display "Best fitness: ") (display (ga-bestFitness)) (newline)
          (ga-evolve2 (+ x 1)))
;        (begin
;          (display "Target fitness reached after ") 
;          (display x) 
;          (display " generations.") 
;          (newline)))))
    ))