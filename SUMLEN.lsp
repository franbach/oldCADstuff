;;; Lisp to sum Total lengths of objects. 

(defun C:SUMLEN()

  (setvar "cmdecho" 0)

  (defun getArc(en)
    (command "lengthen" en "")
    (getvar "perimeter")
  )

  (defun getLine(en)
    (setq enlist(entget en))
    (distance (cdr(assoc 10 enlist)) (cdr(assoc 11 enlist)))
  )

  (defun getPoly(en)
    (command "area" "Object" en)
    (getvar "perimeter")
  )  

  (if(setq eset(ssget))
    (progn
      (setq totalLen 0)
      (setq cntr 0)

      (while(< cntr (sslength eset))
        (setq en(ssname eset cntr))
        (setq enlist(entget en))
        (setq enType(cdr(assoc 0 enlist)))

        (cond
          ((= enType "ARC"       )(setq len(getArc en)))
          ((= enType "CIRCLE"    )(setq len(getPoly en)))
          ((= enType "ELLIPSE"   )(setq len(getPoly en)))
          ((= enType "LINE"      )(setq len(getLine en)))
          ((= enType "LWPOLYLINE")(setq len(getPoly en)))
          ((= enType "POLYLINE"  )(setq len(getPoly en)))
          ((= enType "SPLINE"    )(setq len(getPoly en)))
          (T (setq len 0.0))
        )

        (while(< (strlen enType) 12)(setq enType(strcat enType " ")))

        (princ "\n Found ")
        (princ enType)
        (princ " with a length of: ")
        (princ (rtos len))

        (setq totalLen(+ totalLen len))
         
        (setq cntr (+ cntr 1))
      )
    )
  )
  (setvar "cmdecho" 1) 
  (alert (strcat "\n Found " (itoa cntr) " entitie(s) with a Total Length of " (rtos totalLen)))
  (princ)
)