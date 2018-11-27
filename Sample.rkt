#lang racket
(require 2htdp/universe)
(require 2htdp/image)
(require lang/posn)
(require (prefix-in gui: racket/gui))

(define HEIGHT 1000)
(define WIDTH 500)
(define x 500)
(define y 240)

(define (funcUp)
  (define i 0)
  (for ([z 20])
    (sleep 0.1)
    (change 1)
    (image 1)
    (cond
      [(= (remainder i 2) 0) (set! x (+ x 10))])
    (set! i (+ i 1))
    (set! y (+ y 10))
    ))

(define (funcDown)
  (define i 0)
  (for ([z 20])
    (sleep 0.1)
    (change 1)
    (image 1)
    (cond
      [(= (remainder i 2) 0) (set! x (+ x 10))])
    (set! i (+ i 1))
    (set! y (- y 10))
    ))
;
;(define (jump)
;  (cond
;    (#t (set! y (- y 10)) (sleep 0.1) (set! y (- y 10)) (set! x (+ x 10)) (sleep 0.1) (set! y (+ y 10)) (set! x (+ x 10)) (sleep 0.1) (set! y (+ y 10)))))
(define the-keyboard (make-hasheq))
(define (key-down! k) (hash-set! the-keyboard k #t))
(define (key-up! k)   (hash-set! the-keyboard k #f))
(define (key-down? k) (hash-ref  the-keyboard k #f))
(define (jump) (funcUp) (funcDown))
(define jumping-up-timer 0)
(define move
  (λ (w key)
    (cond
      
      [(key=? key "a") (set! x (- x 10))]
      [(key=? key "d") (set! x (+ x 10))]
      [(key=? key " ") (cond [(= jumping-up-timer 0) (set! jumping-up-timer 10)])])))


(define background (overlay (line HEIGHT 0 "black") (rectangle HEIGHT WIDTH "solid" "white")))
(define imagelist (list (bitmap icons/b-run.png)))
(define coordinatelist (list (make-posn x (- y 10))))
;;list of coord on tick add new and delete the last one
(define change
  (λ (t)
    (exist)
    (set! coordinatelist (list (make-posn x y)))
    (image 1)))
    

(define image
  (λ (t)
     (place-images imagelist
                   coordinatelist
                  background)))

(define (mouse-button-down?)
  (define-values (pt state)
    (gui:get-current-mouse-state))
  (if (or (memq 'left state)
          (memq 'right state)
          (memq 'middle state))
      #t
      #f))
(mouse-button-down?)

(define (exist)
  (cond
    [(> jumping-up-timer 5) (set! y (- y 10))
                            (set! jumping-up-timer (- jumping-up-timer 1))]
    [(> jumping-up-timer 0) (set! y (+ y 10))
                            (set! jumping-up-timer (- jumping-up-timer 1))]))

(big-bang 1
  (on-key move)
  (on-tick change 0.02)
  (to-draw (λ (t) (image 1))))