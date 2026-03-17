*&---------------------------------------------------------------------*
*&  Include           ZPP_VEN_REJ_DATA_DECLERATION
*&---------------------------------------------------------------------*

*type pool for alv
TYPE-POOLS : slis.

*Structure for alv layout
DATA : i_layout  TYPE slis_layout_alv.

*Structure deceleration
TYPES: t_qals TYPE qals,
       t_qamb TYPE qamb.

*Structure for vendor name
TYPES : BEGIN OF t_lfa1,
          lifnr TYPE elifn,    "Vendor Account Number
          name1 TYPE name1_gp,  "Name 1
        END OF t_lfa1.

*structure for Document Segment: Material
TYPES : BEGIN OF t_mseg,
          mblnr TYPE mblnr,   "Number of Material Document
          mjahr TYPE mjahr,   "Material Document Year
          lgort TYPE lgort_d, "Storage Location
          menge TYPE menge_d, "Quantity
          xauto TYPE mb_xauto, "Item automatically created
          matnr TYPE matnr,   "Material Number
          AUFNR TYPE AUFNR,   "order number
          zeile TYPE mseg-zeile,
          sgtxt TYPE mseg-sgtxt,
        END OF t_mseg.

*structure for Document Segment: Material with inspection lot
TYPES : BEGIN OF t_mseg2,
          prueflos TYPE  qplos, "Inspection Lot Number
          mblnr    TYPE mblnr,     "Number of Material Document
          lgort    TYPE lgort_d,   "Storage Location
          menge    TYPE menge_d,   "Quantity
          xauto    TYPE mb_xauto,  "Item automatically created
          matnr    TYPE matnr,     "Material Number
          AUFNR TYPE AUFNR,   "order number
        END OF t_mseg2.

TYPES : BEGIN OF ty_mseg,
          mblnr TYPE mseg-mblnr,
          mjahr TYPE mseg-mjahr,
          zeile TYPE mseg-zeile,
          matnr TYPE mseg-matnr,
          lifnr TYPE mseg-lifnr,
          sgtxt TYPE mseg-sgtxt,
        END OF ty_mseg.

*struicture for temp. data of mblnr typ 3
TYPES : BEGIN OF t_temp,
          prueflos TYPE  qplos , "Inspection Lot Number
          mblnr    TYPE  mblnr , "Number of Material Document
        END OF t_temp.

*struicture  for temp. data of mblnr typ 3 and Document Segment: Material
TYPES : BEGIN OF t_temp2,
          prueflos TYPE  qplos, "Inspection Lot Number
          lgort    TYPE lgort_d,   "Storage Location
          menge    TYPE menge_d,   "Quantity
          matnr    TYPE matnr,     "Material Number
        END OF t_temp2.

*structure for material descreption
TYPES : BEGIN OF t_makt,
          matnr TYPE matnr, "Material Number
          maktx TYPE maktx, "Material Description
        END OF t_makt.

*structure for quantity according to storage location
TYPES: BEGIN OF t_lgort,
         prueflos TYPE qplos, "Inspection Lot Number
         menge    TYPE menge_d,   "Quantity
       END OF t_lgort.

*structure for fm output
TYPES : BEGIN OF t_line,
          tdformat(2) TYPE c , "Tag column
          tdline(132) TYPE c , "Text Line
        END OF t_line.

*structure for validation.
TYPES : BEGIN OF t_val,
          prueflos TYPE qplos, "Inspection Lot Number
        END OF t_val.

TYPES : BEGIN OF ty_mard,
        matnr TYPE mard-matnr,
        lgpbe TYPE mard-lgpbe,
        END OF ty_mard.


* structure for final data
TYPES : BEGIN OF t_final,
          prueflos     TYPE qplos,     "Inspection Lot Number
          lifnr        TYPE elifn,     "Vendor Account Number
          name1        TYPE name1_gp,  "Name 1
          matnr        TYPE matnr,     "Material Number
          maktx        TYPE maktx,     "Material Description
          mblnr        TYPE mblnr,     "Number of Material Document
          gueltigab    TYPE qstichtag, "Key Date for Selecting Records or Changing Task Lists
          cpudt        TYPE cpudt,     "Day On Which Accounting Document Was Entered
          losmenge     TYPE qlosmenge, "Received Quantity
          rm01         TYPE menge_d,   "Accepted Quantity
          tpi1         TYPE menge_d,   "Accepted Quantity
          rj01         TYPE menge_d,   "Rejected Quantity
          rwk1         TYPE menge_d,   "Rework Quantity
          scr1         TYPE menge_d,   "Scrap Quantity
          srn1         TYPE menge_d,   "SRN Quantity
          rew          TYPE menge_d,   "rew%
          t_rej        TYPE menge_d,   "Total Rej%
          srn          TYPE lifnr,     "SRN Vendor
          reason(1320) TYPE c,      "Reason
          zseries      TYPE mara-zseries,
          zsize        TYPE mara-zsize,
          brand        TYPE mara-brand,
          moc          TYPE mara-moc,
          type         TYPE mara-type,
          lgpbe        TYPE mard-lgpbe,
          sgtxt        TYPE mseg-sgtxt,

        END OF t_final.

*Structure for summary of qunatity according to vendor
TYPES : BEGIN OF t_final2,
          lifnr    TYPE elifn,     "Vendor Account Number
          losmenge TYPE qlosmenge, "Received Quantity
          rm01     TYPE menge_d,   "Accepted Quantity
          tpi1     TYPE menge_d,   "Accepted Quantity
          rj01     TYPE menge_d,   "Rejected Quantity
          rwk1     TYPE menge_d,   "Rework Quantity
          scr1     TYPE menge_d,   "Scrap Quantity
          srn1     TYPE menge_d,   "SRN Quantity
          rew      TYPE menge_d,   "rew%
          t_rej    TYPE menge_d,   "Total Rej%
          name1    TYPE name1_gp,  "Name 1
          lgpbe    TYPE mard-lgpbe,
        END OF t_final2.

* Internal table deceleration
DATA : it_qals     TYPE STANDARD TABLE OF t_qals , " Inspection lot record
       it_qamb     TYPE STANDARD TABLE OF t_qamb , " Inspection Lot and Matnr Doc.
       it_lfa1     TYPE STANDARD TABLE OF t_lfa1 , " table to store vendor name.
       it_mseg     TYPE STANDARD TABLE OF t_mseg , " Material
       it_mseg2    TYPE STANDARD TABLE OF t_mseg2 , " Material with inspwction lot
       it_mseg1    TYPE STANDARD TABLE OF t_mseg, "Table to store ref.typ = 3 data of Insp. Lot
       it_qamb1    TYPE STANDARD TABLE OF t_qamb, "contaning all data of mblnr typ = 3
       it_temp2    TYPE STANDARD TABLE OF t_temp2, "Table with data based on inspection lot
       it_mseg3    TYPE STANDARD TABLE OF t_temp2, "Table with total qty. data
       it_makt     TYPE STANDARD TABLE OF t_makt,  "Material Descriptions
       it_makt1    TYPE STANDARD TABLE OF t_makt,
       it_rm01     TYPE STANDARD TABLE OF t_lgort, "Table to store Accepted Quantity
       it_tpi1     TYPE STANDARD TABLE OF t_lgort, "Table to store Accepted Quantity
       it_rj01     TYPE STANDARD TABLE OF t_lgort, "Table to store Rejected Quantity
       it_rwk1     TYPE STANDARD TABLE OF t_lgort, "Table to store Rework Quantity
       it_scr1     TYPE STANDARD TABLE OF t_lgort, "Table to store Scrap Quantity
       it_srn1     TYPE STANDARD TABLE OF t_lgort, "Table to store SRN Quantity
       it_line     TYPE STANDARD TABLE OF t_line, "Table to store read_text data
       it_val      TYPE STANDARD TABLE OF t_val,   "Table for validation
       it_final    TYPE STANDARD TABLE OF t_final, "Final Table
       it_final2   TYPE STANDARD TABLE OF t_final2, "Final table for summary of quantity
       it_fieldcat TYPE slis_t_fieldcat_alv,  "Internal table for fieldcatlog
       it_events   TYPE slis_t_event,        "Internal table for alv events
       it_header   TYPE slis_t_listheader,
       it_mard     TYPE TABLE OF ty_mard,
       lt_mseg     TYPE STANDARD TABLE OF ty_mseg.


* Work area deceleration
DATA : wa_qals     TYPE t_qals , " Inspection lot record
       wa_qamb     TYPE t_qamb , " Inspection Lot and Matnr Doc
       wa_lfa1     TYPE t_lfa1,  "Workarea for vendor name
       wa_mseg     TYPE t_mseg , " Material
       wa_mseg2    TYPE t_mseg2 , " Material
       wa_mseg1    TYPE t_mseg,
       wa_qamb1    TYPE t_qamb,
       wa_temp2    TYPE t_temp2,
       wa_mseg3    TYPE t_temp2,
       wa_makt     TYPE t_makt, "Material Descriptions
       wa_makt1    TYPE makt,
       wa_rm01     TYPE t_lgort,
       wa_tpi1     TYPE t_lgort,
       wa_rj01     TYPE t_lgort,
       wa_rwk1     TYPE t_lgort,
       wa_scr1     TYPE t_lgort,
       wa_srn1     TYPE t_lgort,
       wa_line     TYPE t_line,
       wa_final    TYPE t_final, "Final Table
       wa_final2   TYPE t_final2,
       wa_fieldcat TYPE slis_fieldcat_alv, "Workarea for fieldcatlog
       wa_event    TYPE slis_alv_event,   "Workarea for alv events
       wa_header   TYPE slis_listheader,
       wa_mard     TYPE ty_mard,
       ls_mseg     TYPE ty_mseg.

* deceleration of variables
DATA : lv_qty      TYPE mseg-menge, "variable to store qty.
       lv_date     TYPE qamb-cpudt, "variable to store inspection date.
       lv_clint    LIKE sy-mandt,   "Client
       lv_id       LIKE thead-tdid, "Text ID of text to be read
       lv_lang     LIKE thead-tdspras, "Language
       lv_name     LIKE thead-tdname, "Name of text to be read
       lv_object   LIKE thead-tdobject, "Object of text to be read
       lv_a(132)   TYPE c,           "local variable to store text
       lv_b(132)   TYPE c,           "local variable to store text
       lv_d(132)   TYPE c,           "local variable to store text
       lv_e(132)   TYPE c,           "local variable to store text
       lv_l(132)   TYPE c,           "local variable to store text
       lv_g(132)   TYPE c,           "local variable to store text
       lv_h(132)   TYPE c,           "local variable to store text
       lv_i(132)   TYPE c,           "local variable to store text
       lv_j(132)   TYPE c,           "local variable to store text
       lv_k(132)   TYPE c,           "local variable to store text
       lv_f(1320)  TYPE c,           "local variable to store concatenated text
       date_low    TYPE string ,     "Veriable to store starting date in desierd format
       date_high   TYPE string,    "Veriable to store end date in desierd format
       lv_losmenge TYPE qlosmenge, "variable to store Received Quantity
       lv_rm01     TYPE menge_d,   "variable to store Accepted Quantity
       lv_tpi1     TYPE menge_d,   "variable to store Accepted Quantity
       lv_rj01     TYPE menge_d,   "variable to store Rejected Quantity
       lv_rwk1     TYPE menge_d,   "variable to store Rework Quantity
       lv_scr1     TYPE menge_d,   "variable to store Scrap Quantity
       lv_srn1     TYPE menge_d,   "variable to store SRN Quantity
       lv_rew      TYPE menge_d,   "variable to store rew%
       lv_t_rej    TYPE menge_d.   "variable to store Total Rej%


*local variables with default values
lv_clint = sy-mandt. "Client
lv_lang = 'EN'.      "Language
lv_id = 'QAVE'.      "Text ID of text to be read
lv_object = 'QPRUEFLOS'. "Object of text to be read

*select options  deceleration
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001 .
SELECT-OPTIONS : s_date FOR wa_qals-gueltigab OBLIGATORY , " Date for Selecting Records
                 s_vendor FOR wa_qals-lifnr.               " Vendor Account Number
PARAMETERS p_art TYPE qals-art.
SELECTION-SCREEN END OF BLOCK b1.
*Checkbox on selection screen
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS : summary AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b2.
*&---------------------------------------------------------------------*
*&      Form  SCREEN_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM screen_validation .

  IF s_vendor IS INITIAL.
    SELECT prueflos FROM qals INTO TABLE it_val
                       WHERE gueltigab IN s_date
                       AND art = '01'
*                       AND herkunft = '01'
                       AND lifnr IS NOT NULL.

  ELSE.
    SELECT prueflos FROM qals INTO TABLE it_val
                     WHERE gueltigab IN s_date
                     AND art = '01'
*                     AND herkunft = '01'
                     AND lifnr IN s_vendor.
  ENDIF.
  IF  sy-subrc <> 0 .
    MESSAGE 'Data not found' TYPE 'E'.
  ENDIF.
ENDFORM.                    " SCREEN_VALIDATION
