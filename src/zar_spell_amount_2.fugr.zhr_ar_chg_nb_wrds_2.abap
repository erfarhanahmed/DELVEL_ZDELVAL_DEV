FUNCTION ZHR_AR_CHG_NB_WRDS_2.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(AMT_IN_NUM) LIKE  PC207-BETRG
*"  EXPORTING
*"     REFERENCE(AMT_IN_WORDS) TYPE  C
*"  EXCEPTIONS
*"      DATA_TYPE_MISMATCH
*"--------------------------------------------------------------------
DATA: maxno TYPE p.
  maxno = 10 ** 9.
  IF ( amt_in_num >= maxno ).
    RAISE data_type_mismatch.
  ENDIF.
*data declaration-------------------------------------------------*
  DATA: ten(10),single(6),final(250),dec(20),res TYPE i,rp(7).
  DATA: a1         TYPE i,a2 TYPE i,str(20),d TYPE p,m TYPE i,wrdrep(20).
  DATA: cntr TYPE i,f1 TYPE i,f2 TYPE i,f3 TYPE i,f4 TYPE i,f5 TYPE i.
  DATA: f6 TYPE i,f7 TYPE i,f8 TYPE i,f9 TYPE i.

  d = ( amt_in_num * 100 ) DIV 100.
  res = ( amt_in_num * 100 ) MOD 100.

  f1 = res DIV 10.
  f2 = res MOD 10.
  PERFORM setnum USING f1 f2 CHANGING wrdrep.
  f1 = 0. f2 = 0.
  dec = wrdrep.
  cntr = 1.
*Go in a loop dividing the numbers by 10 and store the
*residues as a digit in f1 .... f9
  WHILE ( d > 0 ).
    m = d MOD 10.
    d = d DIV 10.
    CASE cntr.
      WHEN 1. f1 = m.
      WHEN 2. f2 = m.
      WHEN 3. f3 = m.
      WHEN 4. f4 = m.
      WHEN 5. f5 = m.
      WHEN 6. f6 = m.
      WHEN 7. f7 = m.
      WHEN 8. f8 = m.
      WHEN 9. f9 = m.
    ENDCASE.
    cntr = cntr + 1.
  ENDWHILE.
  cntr = cntr - 1.
*Going in loop and sending pair of digits to function setnum to get
*the standing value of digits in words
  WHILE ( cntr > 0 ).

    IF ( cntr <= 2 ).
      PERFORM setnum USING f2 f1 CHANGING wrdrep.
      IF  f3 <> 0 AND wrdrep <> ''.
        CONCATENATE final'و' wrdrep   INTO final SEPARATED BY ' '.
      ELSEIF  f4 <> 0 AND wrdrep <> ''.
        CONCATENATE final'و' wrdrep   INTO final SEPARATED BY ' '.
      ELSEIF f3 ='' AND f1 <> 0 AND ( f4 <> 0 OR f5 <> 0 OR f6 <> 0 ) .
        CONCATENATE final 'و' wrdrep   INTO final SEPARATED BY ' '.
      ELSEIF f2 ='' .
        CONCATENATE final wrdrep   INTO final SEPARATED BY ' '.
      ELSEIF f3 IS NOT INITIAL.
        CONCATENATE final wrdrep   INTO final SEPARATED BY ' و '.
      ELSE.
        CONCATENATE final wrdrep   INTO final SEPARATED BY ' '.
      ENDIF.
    ELSEIF ( cntr = 3 ).
      IF ( f3 <> 0 ).
        PERFORM setnum USING 0 f3 CHANGING wrdrep.
        IF wrdrep = 'واحد' AND f4 <> ''.
          wrdrep = ' '.
          CONCATENATE  wrdrep final 'و' 'مائة' INTO final SEPARATED BY '  '.
        ELSEIF wrdrep = 'واحد' AND f4 = 0 AND f5 <> ''.
          wrdrep = ' '.
          CONCATENATE  wrdrep final 'و' 'مائة' INTO final SEPARATED BY '  '.

        ELSEIF wrdrep = 'واحد' AND f6 <> '' .
          wrdrep = ' '.
          CONCATENATE final 'و' 'مائة'   INTO final SEPARATED BY ' '.
        ELSEIF wrdrep = 'واحد'.
          wrdrep = ' '.
          CONCATENATE 'مائة' wrdrep final  INTO final SEPARATED BY ' '.

        ELSEIF wrdrep = 'إثنان' AND f4 <> ''.
          wrdrep = ' '.
          CONCATENATE wrdrep final 'و' 'مِائَتَان'  INTO final SEPARATED BY ' '.
        ELSEIF wrdrep = 'إثنان' AND f4 = 0 AND f5 <> ''.
          wrdrep = ' '.
          CONCATENATE wrdrep final 'و' 'مِائَتَان'  INTO final SEPARATED BY ' '.
        ELSEIF wrdrep = 'إثنان' AND f6 <> '' .
          wrdrep = ' '.
          CONCATENATE final 'و' 'مِائَتَان'  INTO final SEPARATED BY ' '.
        ELSEIF wrdrep = 'إثنان'.
          wrdrep = ' '.
          CONCATENATE 'مِائَتَان' wrdrep final   INTO final SEPARATED BY ' '.
        ELSEIF f4 <> ''.
          CONCATENATE final 'و' wrdrep 'مائة'   INTO final SEPARATED BY ' '.
        ELSEIF f5 <> ''.
          CONCATENATE final 'و' wrdrep 'مائة'    INTO final SEPARATED BY ' '.
        ELSEIF f6 <> ''.
          CONCATENATE final 'و' wrdrep 'مائة'    INTO final SEPARATED BY ' '.
        ELSE.
          CONCATENATE final  wrdrep 'مائة'   INTO final SEPARATED BY ' '.
        ENDIF.
      ENDIF.

    ELSEIF ( cntr <= 5 ).
      IF ( f5 <> 0 ) OR ( f4 <> 0 ).
        PERFORM setnum USING f5 f4 CHANGING wrdrep.
        IF wrdrep = 'واحد' AND f6 <> 0 . " a verifier demain
          wrdrep = ' '.
          CONCATENATE final 'و' 'ألف'   INTO final SEPARATED BY ' '.
        ELSEIF wrdrep = 'واحد'.
          wrdrep = ' '.
          CONCATENATE 'ألف' wrdrep final  INTO final SEPARATED BY ' '.

        ELSEIF wrdrep = 'إثنان' AND f6 <> 0 AND f5 = 0. " a verifier demain
          wrdrep = ' '.
          CONCATENATE final 'و' wrdrep 'ألف'    INTO final SEPARATED BY ' '.

        ELSEIF wrdrep = 'إثنان'.
          wrdrep = ' '.
          CONCATENATE 'ألفين' wrdrep final   INTO final SEPARATED BY ' '.
        ELSEIF f5 = 0 AND  f4 <> 0 .
          CONCATENATE wrdrep  'ألاف'  final   INTO final SEPARATED BY ''.
*          CONCATENATE wrdrep  'ألف' final   INTO final SEPARATED BY ''.
        ELSEIF f5 = 1 AND  f4 = 0 .
          CONCATENATE wrdrep  'ألاف'  final   INTO final SEPARATED BY ''.
        ELSE.
*          CONCATENATE wrdrep  'ألاف'  final   INTO final SEPARATED BY ''.
          CONCATENATE wrdrep  'ألف'  final   INTO final SEPARATED BY ''.

        ENDIF.
      ENDIF.
      IF ( cntr = 4 ).
        cntr = 5.
      ENDIF.
    ELSEIF ( cntr < 7 ).
      IF  ( f6 <> 0 ).
        PERFORM setnum USING 0 f6 CHANGING wrdrep.
        IF wrdrep = 'واحد' AND f4 = 0 AND f5 = 0 AND f6 <> 0.
          wrdrep = 'ألف'.
          CONCATENATE  final 'مائة' wrdrep  INTO final SEPARATED BY '  '.

        ELSEIF wrdrep = 'واحد' AND ( f5 <> 0 OR f4 <> 0 ).
          wrdrep = ' '.
          CONCATENATE  final 'مائة'  INTO final SEPARATED BY '  '.


        ELSEIF wrdrep = 'إثنان' AND f4 = 0 AND f5 = 0 AND f6 <> 0.
          wrdrep = 'ألف'.
          CONCATENATE  final 'مِائَتَان' wrdrep  INTO final SEPARATED BY ' '.

        ELSEIF wrdrep = 'إثنان' AND ( f5 <> 0 OR f4 <> 0 ).
          wrdrep = ' '.
          CONCATENATE  final 'مِائَتَان'  INTO final SEPARATED BY ' '.
        ELSEIF f6 <> 0 AND f4 = 0 AND f5 = 0.
          CONCATENATE final wrdrep  'مائة' 'ألف'  INTO final SEPARATED BY ' '.
        ELSE.
          CONCATENATE final wrdrep  'مائة'   INTO final SEPARATED BY ' '.
        ENDIF.
      ELSE.
        PERFORM setnum USING f5 f4 CHANGING wrdrep.
        CONCATENATE final 'و' wrdrep 'ألف'  INTO final SEPARATED BY ' ' .
      ENDIF.

      IF  f6 <> 0  AND ( f5 <> 0 OR f4 <> 0 ) .
        PERFORM setnum USING f5 f4 CHANGING wrdrep.
        CONCATENATE final 'و' wrdrep 'ألف'  INTO final SEPARATED BY ' ' .
      ENDIF.
    ELSEIF ( cntr <= 9 ).

      IF ( f9 <> 0 ) .
        PERFORM setnum USING 0 f9 CHANGING wrdrep.
        IF wrdrep = 'واحد'.
          wrdrep = ''.
          CONCATENATE  'مائة' final  INTO final SEPARATED BY '  '.
        ELSEIF wrdrep = 'إثنان' .
          wrdrep = ' '.
          CONCATENATE  'مِائَتَان' final INTO final SEPARATED BY ' '.
        ELSE.
          CONCATENATE wrdrep  'مائة'  INTO final SEPARATED BY ' '.


        ENDIF.

        PERFORM setnum USING f8 f7 CHANGING wrdrep.
        CONCATENATE final 'و' wrdrep 'مليون' INTO final SEPARATED BY ' ' .

*      ELSEIF cntr = 8  .        "( f9  = 0 ) .
*        PERFORM setnum USING f8 f7 CHANGING wrdrep.
*        CONCATENATE wrdrep 'مليون' INTO final SEPARATED BY ' ' .
*
      ELSEIF ( cntr <= 8 ).          "( f9  = 0 ) .

        PERFORM setnum USING f8 f7 CHANGING wrdrep.

*          CONCATENATE final 'و' wrdrep 'مليون' INTO final SEPARATED BY ' ' .

        CONCATENATE final wrdrep 'مليون' INTO final SEPARATED BY ' ' .


      ENDIF.
    ENDIF.



    IF ( cntr = 6 ).
      cntr = 3.
    ELSEIF ( cntr = 7 ).
      cntr = cntr - 1.
    ELSEIF ( cntr = 9 ).
      cntr = 6.

    ELSE.
      cntr = cntr - 2.
    ENDIF.
  ENDWHILE.
*Output the final
  IF ( final = 'واحد' ) OR ( final = 'إثنان' ) .
    rp = 'دولار'(003).
  ELSEIF ( final = 'ثلاثة' ) OR ( final = 'أربعة' ) OR ( final = 'خمسة' )
    OR ( final = 'ستة' ) OR ( final = 'سبعة' ) OR ( final = 'ثمانية' ) OR ( final = 'تسعة' ).
*    rp = 'الحلال'(003). "      rp = 'دولارات'(003).
    rp = 'هلالة'(003). "      rp = 'دولارات'(003).  """"" NC
  ELSE.
*    rp = 'الحلال'(001).  "     rp = 'دولار'(001). dollar
    rp = 'هلالة'(001).  "     rp = 'دولار'(001). dollar  """""""""" NC
  ENDIF
.
  IF ( final = '' ) AND ( dec = '' ).
    final = 'صفر'.
  ELSEIF ( final = '' ).
    CONCATENATE dec 'سنت'(002)   INTO final SEPARATED BY ' ' .
  ELSEIF ( dec = '' ).

*    CONCATENATE 'الريال السعودي'  final rp 'فقط' INTO final SEPARATED BY ' ' .
    CONCATENATE  final 'الريال السعودي'  'فقط' INTO final SEPARATED BY ' ' .
  ELSE.
*    CONCATENATE  'الريال السعودي' final  ' و ' dec rp 'فقط' INTO final SEPARATED BY ' ' .
    CONCATENATE final 'الريال السعودي'   ' و ' dec rp 'فقط' INTO final SEPARATED BY ' ' .
  ENDIF.

  amt_in_words = final.

ENDFUNCTION.

*&---------------------------------------------------------------------*
*&      Form  SETNUM
*&---------------------------------------------------------------------*
*       converts a number into words                                   *
*----------------------------------------------------------------------*
*  -->  a1,a2     two digits for 2nd and 1st place
*  <--  str       outpur in words
*----------------------------------------------------------------------*
DATA: ten(10),single(6),str(20).
*
FORM setnum USING a1 a2 CHANGING str.
  ten = ''.single = ''.
  IF ( a1 = 1 ).

    CASE a2.
      WHEN 0.
        ten = 'عشرة'.
      WHEN 1.
        ten = 'احد عشر'.
      WHEN 2.
        ten = 'اثنا عشر'.
      WHEN 3.
        ten = 'ثلاثة عشر'.
      WHEN 4.
        ten = 'اربعة عشر'.
      WHEN 5.
        ten = 'خمسة عشر'.
      WHEN 6.
        ten = 'ستة عشر'.
      WHEN 7.
        ten = 'سبعة عشر'.
      WHEN 8.
        ten = 'ثمانية عشر'.
      WHEN 9.
        ten = 'تسعة عشر'.
    ENDCASE.
  ELSE.

    CASE a2.
      WHEN 1.
        single = 'واحد'.
      WHEN 2.
        single = 'إثنان'.
      WHEN 3.
        single = 'ثلاثة'.
      WHEN 4.
        single = 'أربعة'.
      WHEN 5.
        single = 'خمسة'.
      WHEN 6.
        single = 'ستة'.
      WHEN 7.
        single = 'سبعة'.
      WHEN 8.
        single = 'ثمانية'.
      WHEN 9.
        single = 'تسعة'.
    ENDCASE.
    CASE a1.
      WHEN 2.
        ten = 'عشرون'.
      WHEN 3.
        ten = 'ثلاثون'.
      WHEN 4.
        ten = 'أربعون'.
      WHEN 5.
        ten = 'خمسون'.
      WHEN 6.
        ten = 'ستون'.
      WHEN 7.
        ten = 'سبعون'.
      WHEN 8.
        ten = 'ثمانون'.
      WHEN 9.
        ten = 'تسعون'.
    ENDCASE.

  ENDIF.
  IF ( single <> '' ) AND ( ten <> '' ).
    CONCATENATE single ten  INTO str SEPARATED BY ' و '.
  ELSEIF single = ''.
    str = ten.
  ELSE.
    str = single.
  ENDIF.

ENDFORM.                               " SETNUM



*ENDFUNCTION.
