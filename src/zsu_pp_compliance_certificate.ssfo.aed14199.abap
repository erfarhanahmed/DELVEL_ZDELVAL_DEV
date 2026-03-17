
if wa_final-r_ball is NOT INITIAL or wa_final-r_tmbv is NOT INITIAL.
if wa_final-ztest_std = '1'.
  if wa_final-zsu_series = '1'.
    gv_data = '120 Sec.'.
    gv_data1 = '120 Sec.'.
      ELSEIF wa_final-zsu_series = '2'.
        gv_data = '300 Sec.'.
        gv_data1 = '300 Sec.'.
        ELSEIF wa_final-zsu_series = '3'.
          gv_data = '900 Sec.'.
          gv_data1 = '900 Sec.'.
          ELSEIF wa_final-zsu_series = '4'.
          gv_data = '600 Sec.'.
          gv_data1 = '1800 Sec.'.
    endif.
    ELSEIF wa_final-ztest_std = '2' or wa_final-ztest_std = '3' or wa_final-ztest_std = '4'..
      if wa_final-zsu_series = '5'.
       gv_data = '15 Sec.'.
       gv_data1 = '15 Sec.'.
      ELSEIF wa_final-zsu_series = '6'.
        gv_data = '60 Sec.'.
        gv_data1 = '60 Sec.'.
        ELSEIF wa_final-zsu_series = '7'.
          gv_data = '120 Sec.'.
          gv_data1 = '120 Sec.'.
          ELSEIF wa_final-zsu_series = '8'.
          gv_data = '120 Sec.'.
          gv_data1 = '300 Sec.'.
           ELSEIF wa_final-zsu_series = '9'.
          gv_data = '240 Sec.'.
          gv_data1 = '600 Sec.'.
    endif.
  endif.
endif.

if wa_final-r_bfv is NOT INITIAL or wa_final-r_doto is NOT INITIAL.
  if wa_final-ztest_std = '3'.
    if wa_final-zsu_series = '5'.
       gv_data = '15 Sec.'.
       gv_data1 = '15 Sec.'.
      ELSEIF wa_final-zsu_series = '6'.
        gv_data = '60 Sec.'.
        gv_data1 = '60 Sec.'.
        ELSEIF wa_final-zsu_series = '7'.
          gv_data = '120 Sec.'.
          gv_data1 = '120 Sec.'.
          ELSEIF wa_final-zsu_series = '8'.
          gv_data = '120 Sec.'.
          gv_data1 = '300 Sec.'.
           ELSEIF wa_final-zsu_series = '9'.
          gv_data = '240 Sec.'.
          gv_data1 = '600 Sec.'.
    endif.
    ELSEIF wa_final-ztest_std = '4' or wa_final-ztest_std = '2' .
       if wa_final-zsu_series = '5'.
       gv_data = '15 Sec.'.
       gv_data1 = '15 Sec.'.
      ELSEIF wa_final-zsu_series = '6'.
        gv_data = '60 Sec.'.
        gv_data1 = '60 Sec.'.
        ELSEIF wa_final-zsu_series = '7'.
          gv_data = '120 Sec.'.
          gv_data1 = '120 Sec.'.
          ELSEIF wa_final-zsu_series = '8'.
          gv_data = '120 Sec.'.
          gv_data1 = '300 Sec.'.
           ELSEIF wa_final-zsu_series = '9'.
          gv_data = '240 Sec.'.
          gv_data1 = '600 Sec.'.
     endif.
    endif.
ENDIF.



















