;;; write an area text from an enclosed area

(defun C:GA()

  (setvar "cmdecho" 0)

  (princ "\n Starting Number is ")(princ (getvar "useri1"))
  (princ ".   To change this, reset the system variable USERI1")

  (setq pt(getpoint "\n Select Interior of Area : "))

  (command "-bhatch" "Advanced" "Island" "No" "Nearest" "" pt "")

  (if(setq en(entlast))
    (progn
      (setq enlist(entget en))

      (setq plist(list (cons 0 "LWPOLYLINE") (cons 100 "AcDbEntity") (cons 100 "AcDbPolyline")))

      (setq newList(list) flag 0 cntr 0)

      (while(< cntr (length enlist))
        (setq a(nth cntr enlist))
        (if (= (car a) 10)(setq flag(+ flag 1)))
        
        (if (> flag 1)
          (if(= (car a) 10)
            (progn
              (setq tmp(list (cons 0 "VERTEX") a))
              (while(and (< cntr (length enlist))(/= (car (nth (+ cntr 1) enlist)) 10))
                (setq cntr(+ cntr 1))

                (setq b(nth cntr enlist))

                (if(or (= (car b) 42)(= (car b) 50))
                  (setq tmp(append tmp (list b)))
                )
              )
              (setq newList(append newList (list tmp)))
            )
          )
        )
        (setq cntr(+ cntr 1))
      )

      (setq lastPt(car newList))

      (setq newList(reverse(cdr(reverse newList))))

      (entdel en)

      (entmake 
        (list 
          (cons 0 "POLYLINE")
          (cons 66 1)
        )
      )

      (foreach a newList
        (entmake a )
      )

      (entmake lastPt)

      (entmake (list (cons 0 "SEQEND")))    

      (setq en(entlast))

      (command "area" "Object" en)

      (setq myArea(getvar "area"))    

      (setq myPerim(getvar "perimeter"))

      (setq myNum(getvar "useri1"))

      (if(= myNum 0)(setq myNum 1))

      (setvar "useri1" (+ myNum 1))

      (setq myNum(itoa myNum))

      (setq tht(getvar "textsize"))

      (setq csty(getvar "textstyle"))

      (if(= 0 (cdr(assoc 40(tblsearch "style" csty))))
        (progn
          (command "text" "Justify" "Center" Pt tht 0 myNum)
          (command "text" "Justify" "Center" (polar Pt (* pi 1.5) (* tht 1.5)) tht 0 (strcat "AREA=" (rtos myArea 2 4)))
          (command "text" "Justify" "Center" (polar Pt (* pi 1.5) (* 2.0(* tht 1.5))) tht 0 (strcat "PERIMETER=" (rtos myPerim)))
        )
        (progn
          (command "text" "Justify" "Center" Pt 0 myNum)
          (command "text" "Justify" "Center" (polar Pt (* pi 1.5) (* tht 1.5)) 0 (strcat "AREA=" (rtos myArea 2 4)))
          (command "text" "Justify" "Center" (polar Pt (* pi 1.5) (* 2.0(* tht 1.5))) 0 (strcat "PERIMETER=" (rtos myPerim)))
        )
      )
      (entdel en)
    )
    (alert "Hatch pattern could not be created.  Make sure the area is enclosed.")
  )
  (setvar "cmdecho" 1)
  (princ)
)


