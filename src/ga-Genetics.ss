(load "ga-neural-networks.ss")

(define ga-population '()) ;; Holds the last generation
(define ga-fitness-array '()) ;; Holds the each member of the last generation with paired with their fitness
(define ga-counter 0) ;; Keeps track of what generation we are on
(define ga-updateFrequency 1) ;; Determines how often to print last generation statistics
(define ga-population-size 0) ;; Dictates how big the ga-population should be
(define ga-stochastic-array '()) ;; Holds the last generation paired with 
(define ga-target-fitness 501) ;; The best possible fitness
(define ga-stopper 1000000000) ;; A limit on how many generations to use

;; Called at program start, takes first generation and begins evolution
(define (ga-run populationsize)
  (set! ga-population-size populationsize)
  (ga-first-gen 99 ga-population-size)
  ;(ga-update-generation  ga-population)
  ;(ga-evolve #t))
  )

;; Creates the first generation of chromosome strings
(define (ga-first-gen chrom-len i)
  (if (> i 0)
      (begin
        (let ((b (ga-gen-chrom '() chrom-len))
              (d (ga-gen-chrom '() chrom-len))
              (n (ga-gen-chrom '() chrom-len))
              (m (ga-gen-chrom '() chrom-len)))
          (set! ga-population (append ga-population (list b d n m))))
        (ga-first-gen chrom-len (- i 1)))
      ga-population))

;; Creates a single, random chromosome string
(define (ga-gen-chrom lst chrom-len)
  (if (< (length lst) chrom-len)
      (ga-gen-chrom (append lst (list (list (random 2) (random 2) (random 2) (random 2) (random 2)))) chrom-len)
      lst))

;; Evolves the ga-population by one generation until desired outcome achieved
(define (ga-evolve continue)
  (let* ((temp ga-fitness-array)
               (best (car (ga-get-best temp 0 '())))
               (fitness (ga-calculate-fitness best 0))
               (total (ga-stochastic-calc ga-fitness-array 0))
               (average-fit (quotient total ga-population-size)))
  (if (eqv? (remainder ga-counter ga-updateFrequency) -1)
      (begin
        (display "On the ") (display ga-counter) (display " generation. ") (newline)
        (display "  The best individual is: ") (display best) (display ". With a fitness of ") (display fitness) (newline)
        (display "  The average fitness is ") (display average-fit) (display ".") (newline)))
  (if continue
      (begin
        (ga-update-generation  ga-population)
        (ga-evolve (ga-check-fitness ga-fitness-array)))
      (begin
        (display "Target chromosome achieved: ") (display best) (display " on the ") (display ga-counter) (display " Generation.") (newline)
        (display "  The average fitness is ") (display average-fit) (display ".") (newline)))))

;; Checks ga-population fitnesses to desired outcome fitness
(define (ga-check-fitness lst)
  (if (< ga-counter -1)
      #f
      (if (null? lst)
          #t
          (if (= (car (car lst)) ga-target-fitness)
              #f
              (ga-check-fitness (cdr lst))))))

;; Recurses through two chromosomes; return true if a match, otherwise false
(define (ga-match-chrom lst1 lst2)
  (if (not (null? lst1))
      (if (= (car lst1) (car lst2))
          (ga-match-chrom (cdr lst1) (cdr lst2))
          #f)
      #t))

;; Updates ga-fitness-array for current ga-population
(define (ga-population-fitness ga-population)
  (set! ga-fitness-array
        (map
         (lambda (x)
           (list (ga-calculate-fitness x 0) x))
         ga-population)))

;; Calculates fitness of a chromosome
(define (ga-calculate-fitness child fitness)
  ;(load "grid-main.ss")
  (set! gui #f)
  ;(search grid 500))
  (random 500))

;; Breeds a new generation from the current ga-population
(define (ga-update-generation  lst)
  (set! ga-counter (+ ga-counter 1))
  (set! ga-fitness-array '())
  (ga-population-fitness lst)
  (set! ga-population '())
  (let ((temp ga-fitness-array))
    (set! ga-stochastic-array '())
    (let* ((total (ga-stochastic-calc temp 0)))
      (ga-breed 0 total))))

;; Creates all children
(define (ga-breed count total)
  (if (< count ga-population-size)
      (let* ((father-int (+ (random total) 1))
             (mother-int (+ (random total) 1))
             (father (ga-get-chromo father-int ga-stochastic-array))
             (mother (ga-get-chromo mother-int ga-stochastic-array))
             (child (ga-cross mother father))
             (child (ga-mutation child)))
        (set! ga-population (append ga-population (list child)))
        ;(display count) (display " ") (display total) (newline)
        (ga-breed (+ count 1) total))))

;; Searches the fitness probabilty ranges for the parent
(define (ga-get-chromo int array)
  (let ((firstLot (car (car array)))
        (secondLot (car (cadr array))))
    (if (or (= int firstLot) (< int firstLot))
        (cadr (car array))
        (begin
          (if (and (>= secondLot int) (> int firstLot))
              (cadr (cadr array))
              (ga-get-chromo int (cdr array)))))))

(define (ga-cross mother father)
  (if (null? mother)
      '()
      (append (list (ga-crossover (car mother) (car father))) (ga-cross (cdr mother) (cdr father)))))

;; Creates a child by crossing two parents together
(define (ga-crossover mother father)
  (let
      ((distance (random (length mother)))
       (side (random 2))) ;side will either be 1 or 0)
    (if (> side 0) ;if side is 1
        (append (list-head mother distance) (list-tail father distance))
        (append (list-head father distance) (list-tail mother distance)))))

;; May mutate a chromosome, possibly more than once
(define (ga-mutation lst)
  (map
   (lambda (x)
     (if (list? x)
         (ga-mutation x)
         (if (eqv? (random 300) 0)
             (ga-flip x)
             x)))
   lst))

;; Flips a 1 to 0 or a 0 to 1
(define (ga-flip int)
  (if (> int 0)
      0
      1))

;; Creates the fitness probabilty ranges array
(define (ga-stochastic-calc lst total)
  (if (not (null? lst))
      (begin
;        (display "LST: ")(display (car lst))(newline)
        (let* ((fitness (car (car lst)))
               (chrom (cdr (car lst)))
               (lst (cdr lst))
               (new-total (+ fitness total)))
          (set! ga-stochastic-array
                (append ga-stochastic-array
                        (list (list new-total (car chrom)))))
          (ga-stochastic-calc lst new-total)))
      total))

;; Finds the best chromosome
(define (ga-get-best lst int best)
  (if (null? lst)
      best
      (if (> int (car (car lst)))
          (ga-get-best (cdr lst) int best)
          (ga-get-best (cdr lst) (car (car lst)) (cdr (car lst))))))

;(ga-run 32 100 10)
;;(ga-run Size-of-Chromosome Size-of-ga-population frequency-of-information)


;;(cd "/Users/tonyknapp/git/genetic-scheming/src")
;;(load "genetics.ss")