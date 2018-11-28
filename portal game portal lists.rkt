#lang racket
(require 2htdp/universe)
(require 2htdp/image)
(require lang/posn)
(require (prefix-in gui: racket/gui))

(define HEIGHT 1000)
(define WIDTH 500)
(define x 500)
(define y 200)
(define portal-blue-x '())
(define portal-blue-y '())
(define portal-orange-x '())
(define portal-orange-y '())
(define line_positions_x '())
(define falling 0)

(define base_positions_x (for/list ([i (in-range 250 750)]) i))
(define base_positions_y '(240))

(define wall_positions_x '(240))
(define wall_positions_y (for/list ([i (in-range 240 340)]) i))

(define (binary-search lst elem)
  (define mid (floor (/ (length lst) 2)))
  (define midelem (list-ref lst mid))
  
  (if (null? lst)
     #f
     (cond
       ((and (= (length lst) 1) (not (equal? (first lst) elem))) #f)
       ((= midelem elem) #t)
       ((> midelem elem) (binary-search (take lst mid) elem))
       ((< midelem elem) (binary-search (drop lst mid) elem))
       (else #f)
     )
   )
)

(define (double-binary-search-bases)
  (cond
    [(and (binary-search base_positions_x x) (binary-search base_positions_y y)) #t]
    [#t #f]))

(define (double-binary-search-walls type)
  (cond
    [(and (binary-search wall_positions_x (type x 10)) (binary-search wall_positions_y y)) #t]
    [#t #f]))

(define angle 0)

(define bullet (circle 5 "solid" "blue"))
(define firestate 0)
(define bullet-blue-x 1000)
(define bullet-blue-y 1000)
(define bullet-orange-x 1000)
(define bullet-orange-y 1000)

(define move
  (λ (w key)
    (cond
      [(key=? key "w") (set! angle (- angle 1))]
      [(key=? key "s") (set! angle (+ angle 1))]
      [(key=? key " ") (set! bullet-blue-x x) (set! bullet-blue-y y) (if (= firestate 0) (set! firestate 1) (set! firestate 0))]
      [#t
      (cond
        [(= falling 0) 
         (cond
           [(and (equal? (double-binary-search-walls +) #f) (key=? key "d")) (set! x (+ x 10))]
           [(and (equal? (double-binary-search-walls -) #f) (key=? key "a")) (set! x (- x 10))])
         ]
        )
      ]
      )
    )
  )

(define gun (ellipse 30 8 "solid" "red"))
(define background (place-images (list (line 500 0 "black") (line 0 100 "black"))
  (list (make-posn 500 250) (make-posn 750 200))
  (rectangle HEIGHT WIDTH "solid" "white")))
(define imagelist (list (overlay gun (bitmap icons/b-run.png))))
(define coordinatelist (list (make-posn x (- y 10))))
;;list of coord on tick add new and delete the last one
(define change
  (λ (t)
   
    (set! imagelist (list (overlay (rotate angle gun) (bitmap icons/b-run.png)) bullet))
    (cond
      [(equal? (double-binary-search-bases) #f) (set! y (+ y 1)) (set! falling 1)]
      [#t (set! falling 0)]
      )
    (set! coordinatelist (list (make-posn x y) (make-posn bullet-blue-x bullet-blue-y)))
    (set! bullet-blue-x (+ bullet-blue-x 5))
    (set! bullet-blue-y (+ bullet-blue-y (* (* (tan (/ (* pi angle) 180)) 5) -1)))
    (cond
      [(and (binary-search base_positions_x  bullet-blue-x)
            (binary-search base_positions_y  bullet-blue-y))
       (set! portal-blue-x (for/list ([i (in-range (- (remainder bullet-blue-x 10) 25) (+ (remainder (inexact->exact bullet-blue-x) 10) 25))]) i))
       (set! portal-blue-y (list (remainder (inexact->exact bullet-blue-y) 10)))
       (set! bullet-blue-x 1000)
       (set! bullet-blue-y 1000)
       ]
      [(and (binary-search wall_positions_x  (inexact->exact bullet-blue-x))
            (binary-search wall_positions_y  (inexact->exact bullet-blue-y)))
       (set! portal-blue-x (list (remainder (inexact->exact bullet-blue-x) 10)))
       (set! portal-blue-y (for/list ([i (in-range (- (remainder bullet-blue-y 10) 25) (+ (remainder (inexact->exact bullet-blue-y) 10) 25))]) i))
       (set! bullet-blue-x 1000)
       (set! bullet-blue-y 1000)
      ]
      )
    (displayln portal-blue-x)
    (image 1)))
    

(define image
  (λ (t)
     (place-images imagelist
                   coordinatelist
                  background)))

(big-bang 1
  (on-key move)
  (on-tick change 0.02)
  (to-draw (λ (t) (image 1))))