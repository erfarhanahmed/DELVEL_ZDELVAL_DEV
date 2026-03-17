*&---------------------------------------------------------------------*
*& REPORT  ZSD_PACKINGLIST_DRVR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  ZSAUDI_PACKINGLIST.
TABLES: VEKP.
DATA: GT_VEKP LIKE VEKP OCCURS 0 WITH HEADER LINE.

*----------------------------------------------------------------------*
*      PRINT OF A DELIVERY NOTE BY SAPSCRIPT SMART FORMS               *
*----------------------------------------------------------------------*
*REPORT RLE_DELNOTE.

* DECLARATION OF DATA
INCLUDE RLE_DELNOTE_DATA_DECLARE.
* DEFINITION OF FORMS
INCLUDE RLE_DELNOTE_FORMS.
INCLUDE RLE_PRINT_FORMS.

*---------------------------------------------------------------------*
*       FORM ENTRY
*---------------------------------------------------------------------*
FORM ENTRY USING RETURN_CODE US_SCREEN.

  DATA: LF_RETCODE TYPE SY-SUBRC.
  XSCREEN = US_SCREEN.
  PERFORM PROCESSING USING    US_SCREEN
                     CHANGING LF_RETCODE.
  IF LF_RETCODE NE 0.
    RETURN_CODE = 1.
  ELSE.
    RETURN_CODE = 0.
  ENDIF.

ENDFORM.                    "ENTRY
*---------------------------------------------------------------------*
*       FORM PROCESSING                                               *
*---------------------------------------------------------------------*
FORM PROCESSING USING    PROC_SCREEN
                CHANGING CF_RETCODE.

  DATA: LS_PRINT_DATA_TO_READ TYPE LEDLV_PRINT_DATA_TO_READ.
  DATA: LS_DLV_DELNOTE        TYPE LEDLV_DELNOTE.
  DATA: LF_FM_NAME            TYPE RS38L_FNAM.
  DATA: LS_CONTROL_PARAM      TYPE SSFCTRLOP.
  DATA: LS_COMPOSER_PARAM     TYPE SSFCOMPOP.
  DATA: LS_RECIPIENT          TYPE SWOTOBJID.
  DATA: LS_SENDER             TYPE SWOTOBJID.
  DATA: LF_FORMNAME           TYPE TDSFNAME.
  DATA: LS_ADDR_KEY           LIKE ADDR_KEY.

* SMARTFORM FROM CUSTOMIZING TABLE TNAPR
  LF_FORMNAME = TNAPR-SFORM.

* DETERMINE PRINT DATA
  PERFORM SET_PRINT_DATA_TO_READ USING    LF_FORMNAME
                                 CHANGING LS_PRINT_DATA_TO_READ
                                 CF_RETCODE.

  IF CF_RETCODE = 0.
* SELECT PRINT DATA
    PERFORM GET_DATA USING    LS_PRINT_DATA_TO_READ
                     CHANGING LS_ADDR_KEY
                              LS_DLV_DELNOTE
                              CF_RETCODE.
  ENDIF.

  IF CF_RETCODE = 0.
    PERFORM SET_PRINT_PARAM USING    LS_ADDR_KEY
                            CHANGING LS_CONTROL_PARAM
                                     LS_COMPOSER_PARAM
                                     LS_RECIPIENT
                                     LS_SENDER
                                     CF_RETCODE.
  ENDIF.

  IF CF_RETCODE = 0.
* DETERMINE SMARTFORM FUNCTION MODULE FOR DELIVERY NOTE
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
         EXPORTING  FORMNAME           = LF_FORMNAME
*                 VARIANT            = ' '
*                 DIRECT_CALL        = ' '
         IMPORTING  FM_NAME            = LF_FM_NAME
         EXCEPTIONS NO_FORM            = 1
                    NO_FUNCTION_MODULE = 2
                    OTHERS             = 3.
    IF SY-SUBRC <> 0.
*   ERROR HANDLING
      CF_RETCODE = SY-SUBRC.
      PERFORM PROTOCOL_UPDATE.
    ENDIF.
  ENDIF.

  SELECT * FROM VEKP INTO TABLE GT_VEKP
                       WHERE VPOBJKEY = LS_DLV_DELNOTE-HD_GEN-DELIV_NUMB.

  IF CF_RETCODE = 0.
*   CALL SMARTFORM DELIVERY NOTE

*    CALL FUNCTION LF_FM_NAME
*      EXPORTING
*   ARCHIVE_INDEX        = TOA_DARA
*                  ARCHIVE_PARAMETERS   = ARC_PARAMS
*                  CONTROL_PARAMETERS   = LS_CONTROL_PARAM
**                 MAIL_APPL_OBJ        =
*                  MAIL_RECIPIENT       = LS_RECIPIENT
*                  MAIL_SENDER          = LS_SENDER
*                  OUTPUT_OPTIONS       = LS_COMPOSER_PARAM
*                  USER_SETTINGS        = ' '
*                 I_VBELN               =  LS_DLV_DELNOTE-HD_GEN-DELIV_NUMB.
*                    NAST              = NAST
**     IMPORTING
**       DOCUMENT_OUTPUT_INFO       =
**       JOB_OUTPUT_INFO            =
**       JOB_OUTPUT_OPTIONS         =
**     EXCEPTIONS
**       FORMATTING_ERROR           = 1
**       INTERNAL_ERROR             = 2
**       SEND_ERROR                 = 3
**       USER_CANCELED              = 4
**       OTHERS                     = 5
*              .
*    IF SY-SUBRC <> 0.
*** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
***         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
**    ENDIF.
*

    CALL FUNCTION LF_FM_NAME
         EXPORTING
                  ARCHIVE_INDEX        = TOA_DARA
                  ARCHIVE_PARAMETERS   = ARC_PARAMS
                  CONTROL_PARAMETERS   = LS_CONTROL_PARAM
*                 MAIL_APPL_OBJ        =
                  MAIL_RECIPIENT       = LS_RECIPIENT
                  MAIL_SENDER          = LS_SENDER
                  OUTPUT_OPTIONS       = LS_COMPOSER_PARAM
                  USER_SETTINGS        = ' '
                  IS_DLV_DELNOTE       = LS_DLV_DELNOTE
                  IS_NAST              = NAST
          TABLES
                     GT_VEKP            = GT_VEKP

       EXCEPTIONS FORMATTING_ERROR     = 1
                  INTERNAL_ERROR       = 2
                  SEND_ERROR           = 3
                  USER_CANCELED        = 4
                  OTHERS               = 5.
    IF SY-SUBRC <> 0.
*   ERROR HANDLING
      CF_RETCODE = SY-SUBRC.
      PERFORM PROTOCOL_UPDATE.
*     GET SMARTFORM PROTOCOLL AND STORE IT IN THE NAST PROTOCOLL
      PERFORM ADD_SMFRM_PROT.                  "INS_HP_335958
    ENDIF.
  ENDIF.




* GET SMARTFORM PROTOCOLL AND STORE IT IN THE NAST PROTOCOLL
* PERFORM ADD_SMFRM_PROT.                       DEL_HP_335958

ENDFORM.                    "PROCESSING
