#lang racket
(require 2htdp/universe)
(require 2htdp/image)
(require lang/posn)
(require (prefix-in gui: racket/gui))

(define HEIGHT 1000)
(define WIDTH 500)
(define x 500)
(define y 240)
(define line_positions_x '())
(define angle 0)

(define move
  (λ (w key)
    (cond
      [(key=? key "w") (set! angle (- angle 1))]
      [(key=? key "s") (set! angle (+ angle 1))]
      [(key=? key "a") (set! x (- x 10))]
      [(key=? key "d") (set! x (+ x 10))])))

(define gun (ellipse 60 20 "solid" "red"))
(define background (overlay (line HEIGHT 0 "black") (rectangle HEIGHT WIDTH "solid" "white")))
(define imagelist (list (overlay gun (bitmap icons/b-run.png))))
(define coordinatelist (list (make-posn x (- y 10))))
;;list of coord on tick add new and delete the last one
(define change
  (λ (t)
    (displayln angle)
    (set! gun (rotate angle gun))
    (set! coordinatelist (list (make-posn x y)))
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