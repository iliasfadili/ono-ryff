(module
  (func $print_i32 (import "ono" "print_i32") (param i32))
  (func $random_i32_under (import "ono" "random_i32_under") (param i32) (result i32))
  (func $sleep (import "ono" "sleep") (param i32))
  (func $print_cell (import "ono" "print_cell") (param i32))
  (func $newline (import "ono" "newline"))
  (func $clear_screen (import "ono" "clear_screen"))

  (global $w i32 (i32.const 10))
  (global $h i32 (i32.const 10))
  (memory 1)

  (func $get_addr (param $i i32) (param $j i32) (result i32) ;; On obtient l'adresse mémoire depuis i et j
    (i32.mul 
      (i32.const 4)
      (i32.add
        (i32.mul
          (global.get $w)
          (local.get $i))
        (local.get $j)))
  )

  (func $initialize_grid ;; Initialisation de la grille
    (local $i i32) (local $j i32)
    (local.set $i (i32.const 0))
    (loop $init_loop_i  ;; Boucle i
      (local.set $j (i32.const 0))
      (loop $init_loop_j  ;; Boucle j
        
        (call $random_i32_under (i32.const 100))
        i32.const 90
        i32.gt_s
        (if (then  ;; Créé une vie si le random (de 0 à 100) est supérieur à 90
          (i32.store
            (call $get_addr (local.get $i) (local.get $j))
            (i32.const 1))
        ) (else
          (i32.store
            (call $get_addr (local.get $i) (local.get $j))
            (i32.const 0))
        ))
  
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (i32.lt_s (local.get $j) (global.get $w))
        br_if $init_loop_j ;; Fin de boucle j
      )
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (i32.lt_s (local.get $i) (global.get $h))
      br_if $init_loop_i ;; Fin de boucle i
    )
  )

  (func $is_alive (param $i i32) (param $j i32) (result i32)  ;; Teste si la case (i,j) est en vie
    (i32.lt_s (local.get $i) (i32.const 0))
    (i32.ge_s (local.get $i) (global.get $h))
    i32.or
    (i32.lt_s (local.get $j) (i32.const 0))
    i32.or
    (i32.ge_s (local.get $j) (global.get $w))
    i32.or
  
    (if (result i32) (then
      i32.const 0
    ) (else
      (call $get_addr (local.get $i) (local.get $j))
      i32.load
      i32.const 1
      i32.eq
    ))
  )

  (func $count_alive_neighbours (param $i i32) (param $j i32) (result i32)  ;; Compte les voisins vivants de (i,j)
    (call $is_alive (i32.sub (local.get $i) (i32.const 1)) (i32.sub (local.get $j) (i32.const 1)))
    (call $is_alive (i32.sub (local.get $i) (i32.const 1)) (local.get $j))
    i32.add
    (call $is_alive (i32.sub (local.get $i) (i32.const 1)) (i32.add (local.get $j) (i32.const 1)))
    i32.add
    (call $is_alive (local.get $i) (i32.sub (local.get $j) (i32.const 1)))
    i32.add
    (call $is_alive (local.get $i) (i32.add (local.get $j) (i32.const 1)))
    i32.add
    (call $is_alive (i32.add (local.get $i) (i32.const 1)) (i32.sub (local.get $j) (i32.const 1)))
    i32.add
    (call $is_alive (i32.add (local.get $i) (i32.const 1)) (local.get $j))
    i32.add
    (call $is_alive (i32.add (local.get $i) (i32.const 1)) (i32.add (local.get $j) (i32.const 1)))
    i32.add
    return
  )

  (func $step  
    (local $i i32) (local $j i32) (local $an i32)
  
    (local.set $i (i32.const 0))  ;; On stocke le nombre de voisins pour chaque couple (i,j)
    (loop $init_loop_i
      (local.set $j (i32.const 0))
      (loop $init_loop_j
        
        (i32.store
          (i32.add
            (call $get_addr (local.get $i) (local.get $j))
            (i32.mul
              (i32.const 5)
              (i32.mul (global.get $h) (global.get $w))))
          (call $count_alive_neighbours (local.get $i) (local.get $j)))
  
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (i32.lt_s (local.get $j) (global.get $w))
        br_if $init_loop_j
      )
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (i32.lt_s (local.get $i) (global.get $h))
      br_if $init_loop_i
    ) ;; -----------------------
  
  
    (local.set $i (i32.const 0))  ;; On actualise la mémoire des vies selon les voisins stockés précédemment
    (loop $init_loop_i
      (local.set $j (i32.const 0))
      (loop $init_loop_j
        
        (local.set $an (i32.load
          (i32.add
            (call $get_addr (local.get $i) (local.get $j))
            (i32.mul
              (i32.const 5)
              (i32.mul (global.get $h) (global.get $w))))))
        (i32.store
          (call $get_addr (local.get $i) (local.get $j))
          (if (result i32)
            (i32.or
              (i32.or
                (i32.eq (local.get $an) (i32.const 2))
                (i32.eq (local.get $an) (i32.const 3)))
              (i32.eq (call $random_i32_under (i32.const 10000)) (i32.const 0)))
            (then (i32.const 1))
            (else (i32.const 0))))
          
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (i32.lt_s (local.get $j) (global.get $w))
        br_if $init_loop_j
      )
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (i32.lt_s (local.get $i) (global.get $h))
      br_if $init_loop_i
    ) ;; -------------------------------------
  )

  (func $print_grid  ;; Affichage
    (local $i i32) (local $j i32)
    (local.set $i (i32.const 0))
    (loop $init_loop_i
      (local.set $j (i32.const 0))
      (loop $init_loop_j
        
        (call $print_cell
          (call $is_alive (local.get $i) (local.get $j)))
  
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (i32.lt_s (local.get $j) (global.get $w))
        br_if $init_loop_j
      )
      call $newline
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (i32.lt_s (local.get $i) (global.get $h))
      br_if $init_loop_i
    )
    call $clear_screen
  )

  (func $loop ;; Boucle du jeu
    call $print_grid
    (call $sleep (i32.const 2))
    call $step
    call $loop
  )

  (func $main
    call $initialize_grid
    call $loop
  )
  (start $main)
)
