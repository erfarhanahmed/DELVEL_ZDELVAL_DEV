TYPES : tb_stpox TYPE TABLE OF stpox,
        tb_CSCMAT TYPE TABLE OF CSCMAT,
        BEGIN OF t_hdmat,
          matnr TYPE matnr,
          werks TYPE werks_d,
          zeinr	TYPE dzeinr, "Drawing number)
          maktx TYPE maktx,
          zeivr TYPE mara-zeivr,
          MTART TYPE MARA-MTART,
        END OF t_hdmat.
TYPES:
  BEGIN OF t_stpo,
    matnr TYPE stpo-idnrk,
    idnrk TYPE stpo-idnrk,
    menge TYPE stpo-menge,
    REKRS type stpo-REKRS,
  END OF t_stpo,
  tt_stpo TYPE STANDARD TABLE OF t_stpo.


  TYPES : BEGIN OF ty_text,
          lv_lines TYPE CHAR100,
          END OF ty_text.










