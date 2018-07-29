CASE : dialog {
  label = "CASE - Change Case";
  : row { 
     : column {
        : row {
           : column {
               label = "Type of Change";
               : radio_button {
                  label = "All upper case";
                  key = "upcase";
                  value  = "1";
               }
               : radio_button {
                  label = "All lower case";
                  key = "dncase";
                  value = "0";
               } 
               : radio_button {
                  label = "First letter in each word";
                  key = "flcase";
                  value = "0";
               } 
           }
        }
     }    
  }         
  : boxed_row {
      : row {
         :button {
             key = "accept";
             label = "  Okay  ";
             is_default = true;
         }
         :button {
             key = "cancel";
             label = "Cancel";
             is_default = false;
             is_cancel = true;
         }
      }
  } 
}
