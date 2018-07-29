;;; routine to change texts.

(defun getNext(a / cnt ch x)

  (setq cnt 1)

  (while(<= cnt (strlen a))
    (setq ch(substr a cnt 1))
    (if(= ch " ")
      (progn
        (setq x(substr a 1 (- cnt 1)))
        (setq a(substr a (+ cnt 1)))
        (setq cnt 5000)
      )
    )
    (setq cnt(+ cnt 1))
  )  
  (list x a)
)


(defun capWord(a)
  (setq b(strcase(substr a 1 1)))
  (setq c(strcase(substr a 2) T))
  (strcat b c)
)


(defun GetMtxt(enl / extx)
  
  (setq extx "")
  (if(assoc 3 enl)
    (foreach a enl
      (if(= 3 (car a))
        (setq extx(strcat extx(cdr a)))
      )
    )
  )

  (setq extx(strcat extx (cdr(assoc 1 enl))))
  (if(= (substr extx 1 4) "\\A1;")
    (setq extx(substr extx 5))
  )
  extx
)


(defun saveVars()
   (setq upCase(atoi(get_tile "upcase")))
   (setq dnCase(atoi(get_tile "dncase")))
   (setq flCase(atoi(get_tile "flcase")))
)

;;; main program

(defun C:CASE()
 
 (setvar "cmdecho" 0)

 (setq oldOsmode(getvar "osmode"))

 (setvar "osmode" 0)
 
 (setq dcl_id (load_dialog "CASE.dcl"))

 (if (not (new_dialog "CASE" dcl_id) ) (exit))
 
 (action_tile "cancel" "(setq ddiag 1)(done_dialog)")
 (action_tile "accept" "(setq ddiag 2)(saveVars)(done_dialog)") 
 
 (start_dialog)
 
 (if (= ddiag 1)
   (princ "\n \n ...CASE Cancelled. \n ")
 )

 
 (if (= ddiag 2)
   (progn    
     (if(setq eset(ssget))
       (progn   
         (setq cntr 0)
         (while(< cntr (sslength eset))
           (setq en(ssname eset cntr))          
           (setq enlist(entget en))          
           (if(= "TEXT" (cdr(assoc 0 enlist)))            
             (setq lin(cdr(assoc 1 enlist)))
           )
           (if(= "MTEXT" (cdr(assoc 0 enlist)))
             (progn
               (setq lin(GetMtxt enlist))
               (princ "\nLin=")(princ lin)         
               (setq newList(list))
               (foreach a enlist
                 (if(and (/= (car a) 1)(/= (car a) 3))
                   (setq newList(append newList (list a)))
                 )
               )
               (setq newList(append newList (list (cons 1 lin))))
               (setq enlist newList)
             )
           )
           
           (if(= upCase 1)
             (setq lin(strcase lin))
           )
           
           (if(= dnCase 1)
             (setq lin(strcase lin T))
           ) 

           (if(= flCase 1)
             (progn
               (setq wordList(list))
               (while (car (setq data(getNext lin))) 
                 (setq wordList(append wordList (list (capWord(car data)))))
                 (setq lin(cadr data))
               )

               (setq wordList(append wordList (list (capWord(cadr data)))))
               (setq lin(car wordList))
               (setq cnt 1)
               (while(< cnt (length wordList))
                 (setq a(nth cnt wordList))
                 (setq lin(strcat lin " " a))
                 (setq cnt(+ cnt 1)) 
               )
             )
           )

           (if lin
             (progn
               (setq enlist(subst (cons 1 lin) (assoc 1 enlist) enlist))
               (entmod enlist)
               (entupd en)
             )
           )
           (setq cntr(+ cntr 1))
         )
       )
     )
   )
 )
 
 (unload_dialog dcl_id)
 (setvar "cmdecho" 1)
 (princ)

)