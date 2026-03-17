"Name: \PR:SAPLFI_ITEMS\FO:USER_COMMAND\SE:BEGIN\EI
ENHANCEMENT 0 ZATTACH_FBL3N.

IF RS_SELFIELD-SEL_TAB_FIELD = 'IT_POS-ATTACHMENT'.
 DATA : INSTID_AA TYPE SIBFBORIID.
 DATA : IS_OBJECT1 TYPE ZBORIDENT,
        STRING TYPE STRING VALUE 'BSEG'.

 READ TABLE it_items INDEX rs_selfield-tabindex.

 CONCATENATE IT_ITEMS-BUKRS IT_ITEMS-BELNR IT_ITEMS-GJAHR INTO INSTID_AA.

 IS_OBJECT1-OBJKEY = INSTID_AA.
 IS_OBJECT1-OBJTYPE = STRING.

 CALL FUNCTION 'GOS_EXECUTE_SERVICE'
   EXPORTING
     IP_SERVICE                 = 'VIEW_ATTA'
     IS_OBJECT                  = IS_OBJECT1
     IP_NO_COMMIT               = 'X'
     IP_POPUP                   = 'X'
     IP_RWMOD                   = 'D'
*    IT_SERVICE_SELECTION       =
*    IP_VSI_PROFILE             =
*  IMPORTING
*    EP_EVENT                   =
*    EP_STATUS                  =
*    EP_ICON                    =
*    EP_MESSAGE                 =
*  EXCEPTIONS
*    EXECUTION_FAILED           = 1
*    OTHERS                     = 2
           .
 IF SY-SUBRC <> 0.
* Implement suitable error handling here
 ENDIF.

EXIT.
ENDIF.


ENDENHANCEMENT.
