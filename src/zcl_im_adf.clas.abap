class ZCL_IM_ADF definition
  public
  final
  create public .

public section.

  interfaces IF_EX_FI_ITEMS_CH_DATA .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_ADF IMPLEMENTATION.


  METHOD IF_EX_FI_ITEMS_CH_DATA~CHANGE_ITEMS.
    TYPE-POOLS: SLIS.
    CONSTANTS: LC_FBL3N TYPE TCODE VALUE 'FBL3N'.
    DATA : INSTID_AA TYPE SIBFBORIID.

    IF SY-TCODE = LC_FBL3N.
      LOOP AT CT_ITEMS ASSIGNING FIELD-SYMBOL(<FS_ITEMS>).
        IF NOT <FS_ITEMS>-KONTO IS INITIAL .
          CONCATENATE <FS_ITEMS>-BUKRS <FS_ITEMS>-BELNR <FS_ITEMS>-GJAHR INTO INSTID_AA.


            SELECT SINGLE * " RELTYPE
            FROM SRGBTBREL
            WHERE INSTID_A = @INSTID_AA
            INTO @data(SRGBTBREL)."<FS_ITEMS>-RELTYPE.
*          IF NOT <FS_ITEMS>-RELTYPE IS INITIAL.
*            <FS_ITEMS>-ATTACHMENT = '@XX@'.
*          ENDIF.

            if sy-subrc = 0.
*             <FS_ITEMS>-ATTACHMENT = '@XX@'.
           endif.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
