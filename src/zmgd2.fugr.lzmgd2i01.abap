*----------------------------------------------------------------------*
***INCLUDE LZMGD2I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  MODIFY_DATA  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_data INPUT.

DATA : LV_BOM TYPE MARA-BOM.

                  LV_BOM = MARA-BOM.

                  CALL FUNCTION 'MARA_GET_SUB'
                   IMPORTING
                     WMARA         = MARA
                     XMARA         = *MARA
                     YMARA         = LMARA
                            .

MARA-BOM = LV_BOM.

                     CALL FUNCTION 'MARA_SET_SUB'
                       EXPORTING
                         wmara         = MARA
                               .





ENDMODULE.
