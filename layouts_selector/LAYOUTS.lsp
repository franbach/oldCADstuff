;;; program to select a layout from a dialog list box

(defun C:LAYOUTS(/ selectedLayout)

  (setvar "cmdecho" 0)
  
  (defun saveVars()
    (setq selectedLayout(nth (atoi(get_tile "lays")) lays))
  )

  (if (setq lays(layoutlist))
    (progn
      (setq lays(acad_strlsort lays))
      (setq dcl_id (load_dialog "LAYOUTS.dcl"))

      (if (not (new_dialog "LAYOUTS" dcl_id))
        (progn
          (alert "The LAYOUTS.DCL file could not be loaded!")
          (exit)
        )
      )

      (start_list "lays" 3)
      (mapcar 'add_list lays)
      (end_list)

      (action_tile "accept"  "(saveVars)(done_dialog 2)")
      (action_tile "cancel"  "(done_dialog 1)")

      (setq ddiag (start_dialog))

      (unload_dialog dcl_id)

      (if(= ddiag 2)
        (if selectedLayout
          (progn
            (command "layout" "set" selectedLayout)
            (alert (strcat "Current layout is --> " selectedLayout))
          )
        )  
      )
    )
  )
  (setvar "cmdecho" 1)
  (princ)
)