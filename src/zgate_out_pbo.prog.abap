*&---------------------------------------------------------------------*
*&  Include           ZGATE_OUT_PBO
*&---------------------------------------------------------------------*

MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'STATUS_01'.
  SET TITLEBAR 'CREATE_ENTRY'.
*
*   CREATE OBJECT go_cont_image
*    EXPORTING
*      container_name              = 'DELVAL_NAME'             " Name of the Screen CustCtrl Name to Link Container To
*      repid                       = sy-repid                " Screen to Which this Container is Linked
*      dynnr                       = sy-dynnr                " Report To Which this Container is Linked
*    EXCEPTIONS
*      cntl_error                  = 1                       " CNTL_ERROR
*      cntl_system_error           = 2                       " CNTL_SYSTEM_ERROR
*      create_error                = 3                       " CREATE_ERROR
*      lifetime_error              = 4                       " LIFETIME_ERROR
*      lifetime_dynpro_dynpro_link = 5                       " LIFETIME_DYNPRO_DYNPRO_LINK
*      OTHERS                      = 6.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.
*
*    IF go_cont_image IS BOUND.
*    CREATE OBJECT picture
*      EXPORTING
*        parent = go_cont_image     " Parent Container
*      EXCEPTIONS
*        error  = 1                 " Errors
*        OTHERS = 2.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.
*
*        CALL FUNCTION 'DP_PUBLISH_WWW_URL'
*      EXPORTING
*        objid                 = objid
*        lifetime              = cndp_lifetime_transaction
*      IMPORTING
*        url                   = url
*      EXCEPTIONS
*        dp_invalid_parameters = 1
*        no_object             = 2
*        dp_error_publish      = 3
*        OTHERS                = 4.
*    IF sy-subrc <> 0.
*    ELSE.
*
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0101  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0101 OUTPUT.
  SET PF-STATUS 'STATUS_02'.
  SET TITLEBAR 'DISPLAY_ENTRY'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0101 INPUT.
    CASE  sy-ucomm.
      WHEN 'BACK_0101'.
      LEAVE TO SCREEN 0.
    WHEN 'CLOSE_0101'.
      LEAVE TO SCREEN 0.
    WHEN 'CANCL_0101'.
      LEAVE TO SCREEN 0.
      ENDCASE.

ENDMODULE.
