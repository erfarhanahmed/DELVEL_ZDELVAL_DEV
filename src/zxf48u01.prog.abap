*&---------------------------------------------------------------------*
*&  Include           ZXF48U01
*&---------------------------------------------------------------------*

 data :wa_bkpf type bkpf.
  if SY-TCODE = 'FB01' or SY-TCODE = 'F-02'.
*     break primusabap.
    READ TABLE DOC_HEAD_TAB into wa_bkpf INDEX 1.
    if wa_bkpf-budat gt sy-datum.
      MESSAGE 'Posting date should not be later than the system date.' TYPE 'E'.
    endif.
    if wa_bkpf-budat lt wa_bkpf-bldat.
     MESSAGE 'Back dated Posting date is not allowed.' TYPE 'E'.
    endif.
  endif.
