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
(define xspeed (/ (- (/ HEIGHT 2) x) 100))
(define yspeed (/ (- (/ WIDTH 2) y) 100))
(define xacceleration 1.025)
(define yacceleration 1.025)

(define coordinatelist (list (make-posn x y)))
(define spawndelay 200)
(define randomspawn 0)

(define change
  (λ (t)
    (set! x (+ x xspeed))
    (set! xspeed (* xspeed xacceleration))
    (set! y (+ y yspeed))
<<<<<<< HEAD
    (set! yspeed (* yspeed yacceleration))
    (if (= randomspawn 0) (set! coordinatelist (list (make-posn x y)))
        [cond [(and (> 250 x) (> 250 y)) (set! x (random 50 175))(set! y (random 325 450))(set! xspeed (/ (- 250 x) 100))(set! yspeed (/ (- 250 y) 100))(set! randomspawn 0)]
              [(and (< 250 x) (> 250 y)) (set! x (random 50 175))(set! y (random 50 175))(set! xspeed (/ (- 250 x) 100))(set! yspeed (/ (- 250 y) 100))(set! randomspawn 0)]
              [(and (< 250 x) (< 250 y)) (set! x (random 325 450))(set! y (random 50 175))(set! xspeed (/ (- 250 x) 100))(set! yspeed (/ (- 250 y) 100))(set! randomspawn 0)]
              [(and (> 250 x) (< 250 y)) (set! x (random 325 450))(set! y (random 325 450))(set! xspeed (/ (- 250 x) 100))(set! yspeed (/ (- 250 y) 100))(set! randomspawn 0)]]
        )
    (if [or (and (and (> y 255) (< y 290)) (and (< 255 x) (> 290 x)))
            (and (and (< 210 y) (> 245 y)) (and (< 255 x) (> 290 x)))
            (and (and (> y 255) (< y 290)) (and (> x 210) (< x 245)))
            (and (and (< 210 y) (> 245 y)) (and (> x 210) (< x 245)))]
        [cond [(and (> 250 x) (> 250 y)) (set! x (random 50 175))(set! y (random 325 450))(set! xspeed (/ (- 250 x) 100))(set! yspeed (/ (- 250 y) 100))(set! randomspawn 0)]
              [(and (< 250 x) (> 250 y)) (set! x (random 50 175))(set! y (random 50 175))(set! xspeed (/ (- 250 x) 100))(set! yspeed (/ (- 250 y) 100))(set! randomspawn 0)]
              [(and (< 250 x) (< 250 y)) (set! x (random 325 450))(set! y (random 50 175))(set! xspeed (/ (- 250 x) 100))(set! yspeed (/ (- 250 y) 100))(set! randomspawn 0)]
              [(and (> 250 x) (< 250 y)) (set! x (random 325 450))(set! y (random 325 450))(set! xspeed (/ (- 250 x) 100))(set! yspeed (/ (- 250 y) 100))(set! randomspawn 0)]] (set! spawndelay (- spawndelay 1)))
    (image 1)))

=======
    (set! yspeed (+ yspeed yacceleration))
    (if (= randomspawn 0) (set! coordinatelist (list (make-posn x y))) (change_helper))
    (if (and (> x 225) (< x 235)) (change_helper2) (set! spawndelay (- spawndelay 1)))
    (image 1)))

(define (change_helper)
  (set! randomspawn 0)
  (set! x (+ x (random 250 350)))
  (set! y (+ y (random 50 100)))
  (set! xspeed (/ (- 250 x) 100))
  (set! yspeed (/ (- 250 y) 100)))

(define (change_helper2)
  (set! x xstart)
  (set! y ystart)
  (set! randomspawn 1))

>>>>>>> 3a046085b7069765177db0c896129822a1ad8a2e
(define image
  (λ (t)
     (place-images imagelist
                   coordinatelist
                  background)))

(big-bang 1
  (on-tick change 0.01)
  (to-draw (λ (t) (image 1))))