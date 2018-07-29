;;; Match Text

(defun C:MATE(/ ang en enlist oldht len ln)
 (princ "\n \n \nSelect Text to Alter: ")
 (if (setq en (car(entsel)))
  (progn
     (princ "\nSelect Text to Match: ")
     (if (setq en1(car(entsel)))
	(progn
	  (setq enlist(entget en))
	  (setq enlist1(entget en1))
	  (if(and(= "TEXT" (cdr (assoc 0 enlist)))(= "TEXT" (cdr (assoc 0 enlist1))))
	   (progn
	    (setq ang (cdr(assoc 50 enlist1)))
	    (setq enlist(subst(cons 50 ang)(assoc 50 enlist)enlist))(entmod enlist)
	   )
	  )
	)
	(princ "\n....MATE Complete. \n ")
     )
  )
  (princ "\n \n....*ERROR*.. Nothing Selected! \n ")
 )
 (princ)
)
