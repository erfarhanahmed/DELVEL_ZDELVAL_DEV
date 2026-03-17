  PROCESS BEFORE OUTPUT.


    MODULE status_0200.

    LOOP AT it_data INTO it_data WITH CONTROL tab CURSOR
       tab-current_line.

    ENDLOOP.

  PROCESS AFTER INPUT.

    CHAIN.
      FIELD zsub_remark-zdiscount MODULE zdiscount.
    ENDCHAIN.

    LOOP AT it_data  .
      MODULE read_text.
    ENDLOOP.

    MODULE user_command_0200.
