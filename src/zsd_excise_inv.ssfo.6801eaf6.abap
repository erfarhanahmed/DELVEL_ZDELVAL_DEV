CLEAR : OBJNAME, V_TEXT.
CONCATENATE sy-mandt VBRP_VBELN INTO OBJNAME.

PERFORM get_text USING OBJNAME
                    'J1II'
                    'Z001'
                    'E'
              CHANGING V_TEXT.
CONDENSE V_TEXT.
IF v_text is INITIAL.
  V_TEXT = '.'.
ENDIF.
