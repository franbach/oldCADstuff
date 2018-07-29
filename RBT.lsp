;;; Removes all blank texts

(defun C:RBT(/ ht eset eset1 eset2 enlist len ln tcntr)
 (setq eset(ssadd))
 (setq eset1 (ssget "X" (list (cons 0 "MTEXT"))))
 (setq eset2 (ssget "X" (list (cons 0  "TEXT"))))
 (if eset1
   (setq eset eset1)
   (if eset2 (setq eset eset2))
 )
 (if(and eset2 eset1)
    (progn
      (setq eset eset1)
      (setq cntr 0)
      (while (< cntr (sslength eset2))
        (setq eset (ssadd (ssname eset2 cntr) eset))
        (setq cntr(+ cntr 1))
      )
    )
 )
 (if eset
  (progn
   (setq len(sslength eset) ln(- len 1))
   (setq tcntr 0)
   (while(>=(setq len(- len 1))0)
    (setq en(ssname eset len)enlist(entget en))
    (if
      (or
       (= "" (cdr (assoc 1 enlist)))
       (= " " (cdr (assoc 1 enlist)))
      )
      (progn
       (command "erase" en "")
       (setq tcntr(+ tcntr 1))
      )
    )
   )
   (princ (strcat "\n....RBT Complete.  Deleted " (itoa tcntr) " Entities. \n "))
  )
  (princ "\n \n....*ERROR*.. Nothing Selected! \n ")
 )
 (princ)
)
