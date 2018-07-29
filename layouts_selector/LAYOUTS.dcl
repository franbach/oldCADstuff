LAYOUTS : dialog {
        label = "Select Layout to make Current";
        : column {
          : row {
            : boxed_column {
              : list_box {
                key = "lays";
                label = "Layouts:";
                multiple_select = false;
                width = 40;
              }
            }   
          }
          : row {
            : boxed_row {
              : button {
                key = "accept";
                label = "  Okay  ";
                is_default = true;
              }
              : button {
                key = "cancel";
                label = "  Cancel  ";
                is_default = false;
                is_cancel = true;
              }
            }
          }
        }    
}
