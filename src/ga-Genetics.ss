(define CHROMOLENGTH 99)
;(define TARGETFITNESS 32)
(define MUTATECHANCE 300)
(define population '())

(define genPop!
  (lambda (count)
    (set! population (genPop2 count))))

(define genPop2
  (lambda (count)
    (if (> count 0)
        (append (list (makeRandomChromo)) (genPop2 (- count 1)))
        '())))

(define makeRandomChromo
  (lambda ()
    (makeRandomChromo2 CHROMOLENGTH)))

(define makeRandomChromo2
  (lambda (rem)
    (if (> rem 0)
        (append (makeRandomChromo2 (- rem 1)) (list (random 2)))
        '())))

(define getFitness 
  (lambda (chromo)
    (if (null? chromo)
        0
        (+ (car chromo) (getFitness (cdr chromo))))))

(define expandPop
  (lambda (pop)
    (if (null? pop)
        '()
        (append 
          (expandPop2 (car pop) (getFitness (car pop))) 
          (expandPop (cdr pop))))))

(define expandPop2 
  (lambda (chromo count)
    (if (> count 0)
        (append (list chromo) (expandPop2 chromo (- count 1)))
        '())))

(define getParents
  (lambda ()
    (let* ((
    ))

(define split
  (lambda (p div)
    (list 
      (sub p div < 0)
      (sub p div >= 0))))

(define sub
  (lambda (p div op pos)
    (if (null? p)
        '()
        (if (op pos div)
            (append (list (car p)) (sub (cdr p) div op (+ pos 1)))
            (sub (cdr p) div op (+ pos 1))))))

(define cross
  (lambda (p1 p2)
    (let* ((divide (random CHROMOLENGTH))
           (p1Split (split p1 divide))
           (p2Split (split p2 divide)))
      (list 
        (append (car p1Split) (cadr p2Split))
        (append (cadr p1Split) (car p2Split))))))

(define mutate
  (lambda (base)
    (if (null? base)
        '()
        (append (list (mutate2 (car base))) (mutate (cdr base))))))

(define mutate2
  (lambda (child)
    (if (null? child)
        '()
        (if (= 0 (random MUTATECHANCE))
            (append (list (+ 1 (* -1 (car child)))) (mutate2 (cdr child)))
            (append (list (car child)) (mutate2 (cdr child)))))))

(define breed
  (lambda ()
    (let* ((parents (getParents))
           (parent1 (car parents))
           (parent2 (cadr parents))
           (offspring (cross parent1 parent2))
           (mutants (mutate offspring)))
      mutants)))

(define generation
  (lambda (count)
    (if (= count 0)
        '()
        (append (breed) (generation (- count 2))))))

(define bestFitness
  (lambda ()
    (bestFitness2 
      (list 
        (getFitness (car population))
        (car population))
      (cdr population))))

(define bestFitness2
  (lambda (best pop)
    (if (null? pop)
        best
        (bestFitness2 
          (if (< (car best) (getFitness (car pop)))
              (list (getFitness (car pop)) (car pop))
              best)
          (cdr pop)))))

(define averageFitness
  (lambda ()
    (/ (sumFitness population) (length population))))

(define sumFitness
  (lambda (lst)
    (if (null? lst)
        0
        (+ (getFitness (car lst)) (sumFitness (cdr lst))))))

(define evolve
  (lambda (startingPop)
    (genPop! startingPop)
    (evolve2 0)))

(define evolve2
  (lambda (x)
;    (if (not (= TARGETFITNESS (car (bestFitness))))
        (begin
          (set! population (generation (length population)))
          (display "Best fitness: ") (display (bestFitness)) (newline)
          (display "Average fitness: ") (display (averageFitness)) (newline)
          (evolve2 (+ x 1)))
;        (begin
;          (display "Target fitness reached after ") 
;          (display x) 
;          (display " generations.") 
;          (newline)))))
    ))