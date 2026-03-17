*----------------------------------------------------------------------*
***INCLUDE LZMGD1O03.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  ZBOI_DATA  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE zboi_data OUTPUT.
*  BREAK-POINT.
  DATA : name  TYPE vrm_id,
         list  TYPE vrm_values,
         value LIKE LINE OF list.
  IF sy-tcode = 'MM01'   .  """Added by MA ON 05.04.2024 BOUGHT OUT ITEM.
    IF mara-zboi IS INITIAL.

      name = 'MARA-ZBOI'.

      value-key = 'Y'.value-text = ''.
      APPEND value TO list.

      CALL FUNCTION 'VRM_SET_VALUES'
        EXPORTING
          id     = name
          values = list.

      mara-zboi  = ' '.
    ENDIF.
  ELSEIF  sy-tcode = 'MM02'.
    IF mara-zboi IS INITIAL.
      name = 'MARA-ZBOI'.

      value-key = 'Y'.value-text = ''.
      APPEND value TO list.


      CALL FUNCTION 'VRM_SET_VALUES'
        EXPORTING
          id     = name
          values = list.
       mara-zboi  = ' '.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ZITEM_CLASS_DATA  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE zitem_class_data OUTPUT.

*IF SY-TCODE EQ 'MM01' AND SY-TCODE EQ 'MM02'.
*
*
*ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ZITEM_CLASS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*MODULE zitem_class OUTPUT.
**  BREAK PRIMUSABAP.
*
*IF SY-TCODE EQ 'MM01' AND SY-TCODE EQ 'MM02'.
*SELECT SINGLE ZITEM_CLASS FROM ZITEM_CLASS2 INTO @Data(wa_clASS) WHERE ZITEM_CLASS = @MARA-zitem_class.
*
*  IF wa_clASS IS INITIAL.
*    MESSAGE |Please Enter valid data| TYPE 'E'.
*  ENDIF.
*
*ENDIF.
*ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ZITEM_CLASS  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE zitem_class INPUT.
*  BREAK PRIMUSABAP.

IF SY-TCODE EQ 'MM01' OR SY-TCODE EQ 'MM02'.
*SELECT SINGLE ZITEM_CLASS FROM ZITEM_CLASS2 INTO @Data(wa_clASS) WHERE ZITEM_CLASS = @MARA-zitem_class.
SELECT SINGLE ZITEM_CLASS FROM ZITEM_CLASS21 INTO @Data(wa_clASS) WHERE ZITEM_CLASS = @MARA-zitem_class.

  IF wa_clASS NE MARA-zitem_class.
    MESSAGE |Please Enter valid data| TYPE 'E'.
  ENDIF.
 ENDIF.
ENDMODULE.
