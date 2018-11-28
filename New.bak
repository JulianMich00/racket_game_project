#lang racket
(require 2htdp/universe)
(require 2htdp/image)
(require lang/posn)
(require (prefix-in gui: racket/gui))

(define HEIGHT 500)
(define WIDTH 500)

(define flower (circle 50 "solid" "red"))
(define background (overlay flower (rectangle HEIGHT WIDTH "solid" "white")))

(define xstart (random 10 100))
(define ystart (random 10 100))

(struct bug (x y type colour) #:mutable)

(define firstbug (bug xstart ystart 1 "blue"))

(define imagelist (list (circle 10 "solid" "blue")))

(define x (bug-x firstbug))
(define y (bug-y firstbug))
(define xspeed (/ (- 250 x) 100))
(define yspeed (/ (- 250 y) 100))
(define xacceleration 0.025)
(define yacceleration 0.025)

(define coordinatelist (list (make-posn x y)))
(define spawndelay 200)
(define randomspawn 0)

(define change
  (λ (t)
    (set! x (+ x xspeed))
    (set! xspeed (+ xspeed xacceleration))
    (set! y (+ y yspeed))
    (set! yspeed (+ yspeed yacceleration))
    (if (= randomspawn 0) (set! coordinatelist (list (make-posn x y))) (cond (#t (set! randomspawn 0)(set! x (+ x (random 250 350)))(set! y (+ y (random 50 100)))(set! xspeed (/ (- 250 x) 100))(set! yspeed (/ (- 250 y) 100)))))
    (if (and (> x 225) (< x 235)) (cond (#t (set! x xstart) (set! y ystart) (set! randomspawn 1))) (set! spawndelay (- spawndelay 1)))
    (image 1)))

(define move
  (λ (w key)
    (cond
      
      [(key=? key "a") (set! x (- x 10))]
      [(key=? key "d") (set! x (+ x 10))])))

(define image
  (λ (t)
     (place-images imagelist
                   coordinatelist
                  background)))

(big-bang 1
  (on-key move)
  (on-tick change 0.01)
  (to-draw (λ (t) (image 1))))