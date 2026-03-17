*&---------------------------------------------------------------------*
*&Report: ZSU_MM_VENDOR_UPLOAD_REPORT
*&Transaction: ZSU_VENDOR_MASTER
*&Functional Cosultant: Devshree kalamkar
*&Technical Consultant: Shreya Sankpal
*&TR: DEVK912309
*&Date: 17.10.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Report ZMM_VENDOR_UPLOAD_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zsu_mm_vendor_upload_report.

type-pools: slis.
tables: lfb1.


types: begin of ty_lfa1,
         lifnr     type lfa1-lifnr,
         ktokk     type lfa1-ktokk,
         kunnr     type lfa1-kunnr,
         adrnr     type lfa1-adrnr,
         name1     type lfa1-name1,
         name2     type lfa1-name2,
         sortl     type lfa1-sortl,
         anred     type lfa1-anred,
         stcd3     type lfa1-stcd3,
         erdat     type lfa1-erdat,
         loevm     type lfa1-loevm,
         j_1kftbus type lfa1-j_1kftbus,
         j_1kftind type lfa1-j_1kftind,
         sperm     type lfa1-sperm,
       end of ty_lfa1,

***********************************************ADDED BY DH 08.09.22
       begin of ty_lfa12,
*         lifnr     TYPE lfa1-lifnr,
         lifnr     type cdhdr-objectid,
         ktokk     type lfa1-ktokk,
         kunnr     type lfa1-kunnr,
         adrnr     type lfa1-adrnr,
         name1     type lfa1-name1,
         name2     type lfa1-name2,
         sortl     type lfa1-sortl,
         anred     type lfa1-anred,
         stcd3     type lfa1-stcd3,
         erdat     type lfa1-erdat,
         loevm     type lfa1-loevm,
         j_1kftbus type lfa1-j_1kftbus,
         j_1kftind type lfa1-j_1kftind,
         sperm     type lfa1-sperm,
       end of ty_lfa12,

       begin of ty_cdhdr,
         objectid type string,
         udate    type cdhdr-udate,
       end of ty_cdhdr,

****************************************************************************

       begin of ty_adrc,
         addrnumber type adrc-addrnumber,
         str_suppl1 type adrc-str_suppl1,
         str_suppl2 type adrc-str_suppl2,
         str_suppl3 type adrc-str_suppl3,
         street     type adrc-street,
         country    type adrc-country,
         house_num1 type adrc-house_num1,
         city1      type adrc-city1,
         city2      type adrc-city2,
         post_code1 type adrc-post_code1,
         region     type adrc-region,
         po_box     type adrc-po_box,
         langu      type adrc-langu,
         tel_number type adrc-tel_number,
         fax_number type adrc-fax_number,
       end of ty_adrc,

       begin of ty_adr6,
         addrnumber type adr6-addrnumber,
         consnumber type adr6-consnumber,
         smtp_addr  type adr6-smtp_addr,
       end of ty_adr6,

       begin of ty_lfbk,
         lifnr type lfbk-lifnr,
         banks type lfbk-banks,
         bankl type lfbk-bankl,
         bankn type lfbk-bankn,
         koinh type lfbk-koinh,
       end of ty_lfbk,

       begin of ty_bnka,
         banks type bnka-banks,
         bankl type bnka-bankl,
         banka type bnka-banka,
         adrnr type bnka-adrnr,
         brnch type bnka-brnch,
         provz type bnka-provz,
         stras type bnka-stras,
         ort01 type bnka-ort01,
         swift type bnka-swift,
       end of ty_bnka,


       begin of ty_lfb1,
         lifnr type lfb1-lifnr,
         bukrs type lfb1-bukrs,
         erdat type lfb1-erdat,
         zuawa type lfb1-zuawa,
         akont type lfb1-akont,
         zterm type lfb1-zterm,
         reprf type lfb1-reprf,

       end of ty_lfb1,

       begin of ty_lfm1,
         lifnr type lfm1-lifnr,
         ekorg type lfm1-ekorg,
         waers type lfm1-waers,
         zterm type lfm1-zterm,
         inco1 type lfm1-inco1,
         inco2 type lfm1-inco2,
         webre type lfm1-webre,
         lebre type lfm1-lebre,
         kzabs type lfm1-kzabs,
         verkf type lfm1-verkf,
         telf1 type lfm1-telf1,
       end of ty_lfm1,

       begin of ty_j_1imovend,
         lifnr     type j_1imovend-lifnr,
         j_1icstno type j_1imovend-j_1icstno,
         j_1ilstno type j_1imovend-j_1ilstno,
         j_1isern  type j_1imovend-j_1isern,
         j_1iexcd  type j_1imovend-j_1iexcd,
         j_1iexrn  type j_1imovend-j_1iexrn,
         j_1iexrg  type j_1imovend-j_1iexrg,
         j_1iexdi  type j_1imovend-j_1iexdi,
         j_1iexco  type j_1imovend-j_1iexco,
         j_1ivtyp  type j_1imovend-j_1ivtyp,
         j_1ipanno type j_1imovend-j_1ipanno,
         j_1issist type j_1imovend-j_1issist,
         ven_class type j_1imovend-ven_class,
       end of ty_j_1imovend,

       begin of ty_lfbw,
         lifnr     type lfbw-lifnr,
         wt_withcd type lfbw-wt_withcd,
         wt_subjct type lfbw-wt_subjct,
       end of ty_lfbw,

       begin of ty_t005u,
         spras type t005u-spras,
         land1 type t005u-land1,
         bland type t005u-bland,
         bezei type t005u-bezei,
       end of ty_t005u,

       begin of ty_tinct,
         spras type tinct-spras,
         inco1 type tinct-inco1,
         bezei type tinct-bezei,
       end of ty_tinct,

       begin of ty_tvzbt,
         spras type tvzbt-spras,
         zterm type tvzbt-zterm,
         vtext type tvzbt-vtext,
       end of ty_tvzbt,

       begin of ty_t059u,
         spras  type t059u-spras,
         land1  type t059u-land1,
         witht  type t059u-witht,
         text40 type t059u-text40,
       end of ty_t059u,


       begin of ty_final,
         lifnr      type lfa1-lifnr,
         bukrs      type lfb1-bukrs,
         ekorg      type lfm1-ekorg,
         ktokk      type lfa1-ktokk,
         anred      type lfa1-anred,
         name1      type lfa1-name1,
         name2      type lfa1-name2,
         sortl      type lfa1-sortl,
         str_suppl1 type adrc-str_suppl1,
         str_suppl2 type adrc-str_suppl2,
         str_suppl3 type adrc-str_suppl3,
         street     type adrc-street,
         house_num1 type adrc-house_num1,
         city2      type adrc-city2,
         post_code1 type adrc-post_code1,
         city1      type adrc-city1,
         country    type adrc-country,
         region     type adrc-region,
         bezei      type t005u-bezei,
         po_box     type adrc-po_box,
         langu      type adrc-langu,
         tel_number type adrc-tel_number,
         fax_number type adrc-fax_number,
         smtp_addr1 type adr6-smtp_addr,                   "ADDED BY SNEHAL RAJALE ON 5 MARCH 2021
         smtp_addr2 type adr6-smtp_addr,                   "ADDED BY SNEHAL RAJALE ON 5 MARCH 2021
         smtp_addr3 type adr6-smtp_addr,                   "ADDED BY SNEHAL RAJALE ON 5 MARCH 2021
         banks      type lfbk-banks,
         bankl      type lfbk-bankl,
         bankn      type lfbk-bankn,
         koinh      type lfbk-koinh,
         banka      type bnka-banka,
         brnch      type bnka-brnch,
         provz      type bnka-provz,
         stras      type bnka-stras,
         ort01      type bnka-ort01,
         swift      type bnka-swift,
         akont      type lfb1-akont,
         zuawa      type lfb1-zuawa,
         zterm1     type lfb1-zterm,
         vtext1     type tvzbt-vtext,
         reprf      type lfb1-reprf,
         waers      type lfm1-waers,
         zterm      type lfm1-zterm,
         vtext      type tvzbt-vtext,
         inco1      type lfm1-inco1,
         inco_text  type tinct-bezei,
         inco2      type lfm1-inco2,
         webre      type lfm1-webre,
         lebre      type lfm1-lebre,
         kzabs      type lfm1-kzabs,
         kunnr      type lfa1-kunnr,
         j_1icstno  type j_1imovend-j_1icstno,
         j_1ilstno  type j_1imovend-j_1ilstno,
         j_1isern   type j_1imovend-j_1isern,
         j_1iexcd   type j_1imovend-j_1iexcd,
         j_1iexrn   type j_1imovend-j_1iexrn,
         j_1iexrg   type j_1imovend-j_1iexrg,
         j_1iexdi   type j_1imovend-j_1iexdi,
         j_1iexco   type j_1imovend-j_1iexco,
         j_1ivtyp   type j_1imovend-j_1ivtyp,
         j_1ipanno  type j_1imovend-j_1ipanno,
         wt_withcd  type lfbw-wt_withcd,
         text40     type t059u-text40,
         wt_subjct  type lfbw-wt_subjct,
         stcd3      type lfa1-stcd3,
         erdat      type lfa1-erdat,
         status     type string,
         loevm      type lfa1-loevm,
         ven_class  type char100,
         verkf      type lfm1-verkf,
         telf1      type lfm1-telf1,
         txt1       type char255,
         txt2       type char255,
         txt3       type char255,
         txt4       type char255,
         txt5       type char255,
         txt6       type char255,
         txt7       type char255,
         txt8       type char255,
         txt9       type char255,
         txt10      type char255,
         txt11      type char255,
         txt12      type char255,
         txt13      type char255,
         txt14      type char255,
         txt15      type char255,
         txt16      type char255,
         txt17      type char255,
         txt18      type char255,
         txt19      type char255,
         txt20      type char255,
         j_1kftbus  type lfa1-j_1kftbus,
         j_1kftind  type lfa1-j_1kftind,
         sperm      type lfa1-sperm,

***********************************************************
         objectid   type string,                      "DH 08.09.22
         udate      type char15,    "cdhdr-udate,
***********************************************************

       end of ty_final.

********************************************Structure For Download file************************************
types : begin of itab,
          lifnr      type char15,
          bukrs      type char10,
          ekorg      type char10,
          ktokk      type char10,
          anred      type char15,
          name1      type char50,
          name2      type char50,
          sortl      type char15,
          str_suppl1 type char50,
          str_suppl2 type char50,
          str_suppl3 type char50,
          street     type char70,
          house_num1 type char15,
          city2      type char50,
          post_code1 type char15,
          city1      type char50,
          country    type char10,
          region     type char10,
          bezei      type char20,
          po_box     type char15,
          langu      type char5,
          tel_number type char50,
          fax_number type char50,
          smtp_addr1 type char250,
          smtp_addr2 type char250,
          smtp_addr3 type char250,
          banks      type char10,
          bankl      type char15,
          bankn      type char20,
          koinh      type char100,
          banka      type char100,
          brnch      type char50,
          provz      type char10,
          stras      type char50,
          ort01      type char50,
          swift      type char15,
          akont      type char15,
          zuawa      type char10,
          zterm1     type char10,
          vtext1     type char50,
          reprf      type char10,
          waers      type char10,
          zterm      type char10,
          vtext      type char50,
          inco1      type char10,
          inco_text  type char50,
          inco2      type char50,
          webre      type char10,
          lebre      type char10,
          kzabs      type char10,
          kunnr      type char20,
*          j_1icstno  type char80,
*          j_1ilstno  type char50,
*          j_1isern   type char50,
*          j_1iexcd   type char50,
*          j_1iexrn   type char50,
*          j_1iexrg   type char80,
*          j_1iexdi   type char80,
*          j_1iexco   type char80,
          j_1ivtyp   type char10,
*          j_1ipanno  type char50,
          wt_withcd  type char10,
          text40     type char50,
          wt_subjct  type char10,
          stcd3      type char20,
*          ref        type char15,
          erdat      type char15,
          status     type string,
          loevm      type lfa1-loevm,
          ven_class  type char100,
          verkf      type char50,
          telf1      type char20,
          txt1       type char255,
          txt2       type char255,
          txt3       type char255,
          txt4       type char255,
          txt5       type char255,
          txt6       type char255,
          txt7       type char255,
          txt8       type char255,
          txt9       type char255,
          txt10      type char255,
          txt11      type char255,
          txt12      type char255,
          txt13      type char255,
          txt14      type char255,
          txt15      type char255,
          txt16      type char255,
          txt17      type char255,
          txt18      type char255,
          txt19      type char255,
          txt20      type char255,
          j_1kftbus  type char50,
          j_1kftind  type char50,
          udate      type char18, "cdhdr-udate,      "DH 08.09.22
          sperm      type lfa1-sperm,
          REF      TYPE CHAR15,
          REF_TIME TYPE CHAR20,
        end of itab.

data : lt_final type table of itab,
       ls_final type          itab.
********************************************************************************************************************


data : it_lfa1       type table of ty_lfa1,
       wa_lfa1       type          ty_lfa1,

       it_lfa12      type table of ty_lfa12,
       wa_lfa12      type          ty_lfa12,

       it_lfb1       type table of ty_lfb1,
       wa_lfb1       type          ty_lfb1,

       it_lfm1       type table of ty_lfm1,
       wa_lfm1       type          ty_lfm1,

       it_adrc       type table of ty_adrc,
       wa_adrc       type          ty_adrc,

       it_adr6       type table of ty_adr6,
       wa_adr6       type          ty_adr6,

       it_lfbk       type table of ty_lfbk,
       wa_lfbk       type          ty_lfbk,

       it_lfbw       type table of ty_lfbw,
       wa_lfbw       type          ty_lfbw,

       it_bnka       type table of ty_bnka,
       wa_bnka       type          ty_bnka,

       it_t005u      type table of ty_t005u,
       wa_t005u      type          ty_t005u,

       it_tinct      type table of ty_tinct,
       wa_tinct      type          ty_tinct,

       it_mm_tvzbt   type table of ty_tvzbt,
       wa_mm_tvzbt   type          ty_tvzbt,

       it_fi_tvzbt   type table of ty_tvzbt,
       wa_fi_tvzbt   type          ty_tvzbt,

       it_t059u      type table of ty_t059u,
       wa_t059u      type          ty_t059u,

       it_j_1imovend type table of ty_j_1imovend,
       wa_j_1imovend type          ty_j_1imovend,

       it_final      type table of ty_final,
       wa_final      type          ty_final,

*****************************************************************"DH 08.09.22
       it_cdhdr      type table of ty_cdhdr,
       wa_cdhdr      type          ty_cdhdr,

       lv_lifnr      type cdhdr-objectid,
       lv_lifnr1     type lfa1-lifnr.
****************************************************************

data: it_fcat type slis_t_fieldcat_alv,
      wa_fcat like line of it_fcat.

data: lv_name   type thead-tdname,
      lv_lines  type standard table of tline,
      wa_lines  like tline,
      ls_itmtxt type tline,
      ls_mattxt type tline.

selection-screen: begin of block b1 with frame title text-001.
select-options: s_lifnr for lfb1-lifnr,
                s_bukrs for lfb1-bukrs default 'SU00' no intervals modif id bu ," ADDED BY MD
                s_erdat for lfb1-erdat.
selection-screen: end of block b1.

selection-screen begin of block b2 with frame title text-002 .
parameters p_down as checkbox.
parameters p_folder like rlgrap-filename default  '/Delval/Saudi'."Saudi'."Saudi'. " 'E:/delval/Saudi'.
selection-screen end of block b2.

selection-screen :begin of block b3 with frame title text-003.
selection-screen  comment /1(60) text-004.
selection-screen: end of block b3.


at selection-screen output. " ADDED BY MD
  loop at screen.
    if screen-group1 = 'BU'.
      screen-input = '0'.
      modify screen.
    endif.
  endloop.


start-of-selection.
  perform get_data.
  perform sort_data.
  perform get_fcat.
  perform get_display.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_data .
  select lifnr
         bukrs
         erdat
         zuawa
         akont
         zterm
         reprf from lfb1 into table it_lfb1
         where lifnr in s_lifnr
         and   bukrs in s_bukrs
         and   erdat in s_erdat.

  if  it_lfb1 is not initial.
    select lifnr
           ktokk
           kunnr
           adrnr
           name1
           name2
           sortl
           anred
           stcd3
           erdat
           loevm
           j_1kftbus
           j_1kftind
           sperm
           from lfa1 into table it_lfa1
           for all entries in it_lfb1
           where lifnr = it_lfb1-lifnr.


  endif.

********************************************************ADDED BY DH 08.09.22
  if it_lfa1 is not initial.
    loop at it_lfa1 into wa_lfa1.
      call function 'CONVERSION_EXIT_ALPHA_INPUT'
        exporting
          input  = wa_lfa1-lifnr
        importing
          output = lv_lifnr.

      move-corresponding wa_lfa1 to wa_lfa12.
      wa_lfa12-lifnr = lv_lifnr.
      append wa_lfa12 to it_lfa12.

    endloop.

*    CLEAR: lv_lifnr, wa_lfa1, wa_lfa12.
  endif.

  loop at it_lfa12 into wa_lfa12.
    call function 'CONVERSION_EXIT_ALPHA_INPUT'
      exporting
        input  = wa_lfa12-lifnr
      importing
        output = lv_lifnr1.

    wa_lfa12-lifnr = lv_lifnr1.
    modify it_lfa12 from wa_lfa12.
  endloop.

  if it_lfa12 is not initial.
    select *
         from  cdhdr
         into corresponding fields of table it_cdhdr
         for all entries in it_lfa12
         where objectid = it_lfa12-lifnr.

  endif.

**************************************************END OF ADDITION BY DH

  if it_lfa1 is not initial.



    select addrnumber
           str_suppl1
           str_suppl2
           str_suppl3
           street
           country
           house_num1
           city1
           city2
           post_code1
           region
           po_box
           langu
           tel_number
           fax_number  from adrc into table it_adrc
           for all entries in it_lfa1
           where addrnumber = it_lfa1-adrnr.

    select lifnr
           banks
           bankl
           bankn
           koinh from lfbk into table it_lfbk
           for all entries in it_lfa1
           where lifnr = it_lfa1-lifnr.

    select lifnr
           ekorg
           waers
           zterm
           inco1
           inco2
           webre
           lebre
           kzabs
           verkf
           telf1 from lfm1 into table it_lfm1
           for all entries in it_lfa1
           where lifnr = it_lfa1-lifnr.

    select lifnr
           j_1icstno
           j_1ilstno
           j_1isern
           j_1iexcd
           j_1iexrn
           j_1iexrg
           j_1iexdi
           j_1iexco
           j_1ivtyp
           j_1ipanno
           j_1issist
           ven_class from j_1imovend into table it_j_1imovend
           for all entries in it_lfa1
           where lifnr = it_lfa1-lifnr.

    select lifnr
           wt_withcd
           wt_subjct from lfbw into table it_lfbw
           for all entries in it_lfa1
           where lifnr = it_lfa1-lifnr.


  endif.

  if it_lfbk is not initial .
    select banks
           bankl
           banka
           adrnr
           brnch
           provz
           stras
           ort01
           swift from bnka into table it_bnka
           for all entries in it_lfbk
           where banks = it_lfbk-banks
           and   bankl = it_lfbk-bankl.
  endif.
  if it_adrc is not initial.

    select addrnumber
           consnumber
           smtp_addr  from adr6 into table it_adr6
           for all entries in it_adrc
           where addrnumber = it_adrc-addrnumber.


    select spras
           land1
           bland
           bezei from t005u into table it_t005u
           for all entries in it_adrc
           where spras = it_adrc-langu
           and   land1 = it_adrc-country
           and   bland = it_adrc-region.
  endif.

  if it_lfm1 is not initial .

    select spras
           inco1
           bezei from tinct into table it_tinct
           for all entries in it_lfm1
           where inco1 = it_lfm1-inco1
           and   spras = 'E'.

    select spras
           zterm
           vtext from tvzbt into table it_mm_tvzbt
           for all entries in it_lfm1
           where zterm = it_lfm1-zterm
           and   spras = 'E'.

  endif.

  if it_lfb1 is not initial .
    select spras
           zterm
           vtext from tvzbt into table it_fi_tvzbt
           for all entries in it_lfb1
           where zterm = it_lfb1-zterm
           and   spras = 'E'.

  endif.

  if it_lfbw is not initial .

    select spras
           land1
           witht
           text40 from t059u into table it_t059u
           for all entries in it_lfbw
           where witht = it_lfbw-wt_withcd
           and   spras = 'E'
           and   land1 = 'IN'.

  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form sort_data .
  loop at it_lfa1 into wa_lfa1.
    wa_final-lifnr  = wa_lfa1-lifnr .
    wa_final-ktokk  = wa_lfa1-ktokk .
    wa_final-anred  = wa_lfa1-anred .
    wa_final-name1  = wa_lfa1-name1 .
    wa_final-name2  = wa_lfa1-name2 .
    wa_final-sortl  = wa_lfa1-sortl .
    wa_final-kunnr  = wa_lfa1-kunnr .
    wa_final-stcd3  = wa_lfa1-stcd3 .
    wa_final-erdat  = wa_lfa1-erdat.
    wa_final-loevm  = wa_lfa1-loevm.
    wa_final-j_1kftbus  = wa_lfa1-j_1kftbus.
    wa_final-j_1kftind  = wa_lfa1-j_1kftind.
    wa_final-sperm = wa_lfa1-sperm.

****************************************************************ADDED BY DH 08.09.22
    read table it_lfa12 into wa_lfa12 with key lifnr = wa_lfa1-lifnr.

    read table it_cdhdr into wa_cdhdr with key objectid = wa_lfa12-lifnr.
    if sy-subrc = 0.
      wa_final-objectid = wa_cdhdr-objectid.
      wa_final-udate = wa_cdhdr-udate.
    endif.

    call function 'CONVERSION_EXIT_IDATE_OUTPUT'
      exporting
        input  = wa_final-udate
      importing
        output = wa_final-udate.

    concatenate wa_final-udate+0(2) wa_final-udate+2(3) wa_final-udate+5(4)
                   into wa_final-udate separated by '-'.

    if wa_final-udate = '--'.
      replace all occurrences of '--' in wa_final-udate with ' '.
    endif.

***********************************************************************************

    read table it_lfb1 into wa_lfb1 with key lifnr = wa_lfa1-lifnr.
    if  sy-subrc = 0.
      wa_final-bukrs = wa_lfb1-bukrs.
      wa_final-akont = wa_lfb1-akont.
      wa_final-zuawa = wa_lfb1-zuawa.
      wa_final-reprf = wa_lfb1-reprf.
      wa_final-zterm1 = wa_lfb1-zterm.
    endif.

    read table it_adrc into wa_adrc with key addrnumber = wa_lfa1-adrnr.
    if sy-subrc = 0.
      wa_final-str_suppl1   = wa_adrc-str_suppl1 .
      wa_final-str_suppl2   = wa_adrc-str_suppl2 .
      wa_final-str_suppl3   = wa_adrc-str_suppl3 .
      wa_final-street       = wa_adrc-street     .
      wa_final-house_num1   = wa_adrc-house_num1 .
      wa_final-city2        = wa_adrc-city2      .
      wa_final-post_code1   = wa_adrc-post_code1 .
      wa_final-city1        = wa_adrc-city1      .
      wa_final-country      = wa_adrc-country    .
      wa_final-region       = wa_adrc-region     .
      wa_final-po_box       = wa_adrc-po_box     .
      wa_final-langu        = wa_adrc-langu      .
      wa_final-tel_number   = wa_adrc-tel_number .
      wa_final-fax_number   = wa_adrc-fax_number .
    endif.
    read table it_lfbk into wa_lfbk with key lifnr = wa_lfa1-lifnr.
    if sy-subrc = 0.
      wa_final-banks = wa_lfbk-banks.
      wa_final-bankl = wa_lfbk-bankl.
      wa_final-bankn = wa_lfbk-bankn.
      wa_final-koinh = wa_lfbk-koinh.

    endif.
    read table it_lfm1 into wa_lfm1 with key lifnr = wa_lfa1-lifnr.
    if sy-subrc = 0.
      wa_final-ekorg = wa_lfm1-ekorg.
      wa_final-waers = wa_lfm1-waers.
      wa_final-zterm = wa_lfm1-zterm.
      wa_final-inco1 = wa_lfm1-inco1.
      wa_final-inco2 = wa_lfm1-inco2.
      wa_final-webre = wa_lfm1-webre.
      wa_final-lebre = wa_lfm1-lebre.
      wa_final-kzabs = wa_lfm1-kzabs.
      wa_final-verkf = wa_lfm1-verkf.
      wa_final-telf1 = wa_lfm1-telf1.
    endif.

    read table it_j_1imovend into wa_j_1imovend with key lifnr = wa_lfa1-lifnr.
    if sy-subrc = 0.
      wa_final-j_1icstno = wa_j_1imovend-j_1icstno.
      wa_final-j_1ilstno = wa_j_1imovend-j_1ilstno.
      wa_final-j_1isern  = wa_j_1imovend-j_1isern .
      wa_final-j_1iexcd  = wa_j_1imovend-j_1iexcd .
      wa_final-j_1iexrn  = wa_j_1imovend-j_1iexrn .
      wa_final-j_1iexrg  = wa_j_1imovend-j_1iexrg .
      wa_final-j_1iexdi  = wa_j_1imovend-j_1iexdi .
      wa_final-j_1iexco  = wa_j_1imovend-j_1iexco .
      wa_final-j_1ivtyp  = wa_j_1imovend-j_1ivtyp .
      wa_final-j_1ipanno = wa_j_1imovend-j_1ipanno.

      if wa_j_1imovend-j_1issist = '1'.
        wa_final-status = 'Micro'.
      elseif wa_j_1imovend-j_1issist = '2'.
        wa_final-status = 'Small'.
      elseif wa_j_1imovend-j_1issist = '3'.
        wa_final-status = 'Medium'.
      elseif wa_j_1imovend-j_1issist = '4'.
        wa_final-status = 'NA'.
      endif.

      if wa_j_1imovend-ven_class = ' '.
        wa_final-ven_class = 'Registered'.
      elseif wa_j_1imovend-ven_class = '0'.
        wa_final-ven_class = 'Not Registered'.
      elseif wa_j_1imovend-ven_class = '1'.
        wa_final-ven_class = 'Compounding Scheme'.
      endif.


    endif.

    read table it_lfbw into wa_lfbw with key lifnr = wa_lfa1-lifnr.
    if  sy-subrc = 0.
      wa_final-wt_withcd = wa_lfbw-wt_withcd.
      wa_final-wt_subjct = wa_lfbw-wt_subjct.

    endif.

    read table it_bnka into wa_bnka with key banks = wa_lfbk-banks
                                             bankl = wa_lfbk-bankl.
    if sy-subrc = 0.
      wa_final-banka  = wa_bnka-banka.
      wa_final-brnch  = wa_bnka-brnch.
      wa_final-provz  = wa_bnka-provz.
      wa_final-stras  = wa_bnka-stras.
      wa_final-ort01  = wa_bnka-ort01.
      wa_final-swift  = wa_bnka-swift.

    endif.

*    READ TABLE IT_ADR6 INTO WA_ADR6 WITH KEY ADDRNUMBER = WA_ADRC-ADDRNUMBER.
*    IF SY-SUBRC = 0.
*      WA_FINAL-SMTP_ADDR = WA_ADR6-SMTP_ADDR.
*
*    ENDIF.

*******ADDED BY SNEHAL RAJALE ON 5 MARCH 2021********
    loop at it_adr6 into wa_adr6 where addrnumber = wa_adrc-addrnumber.
      if wa_adr6-consnumber = '1'.
        wa_final-smtp_addr1 = wa_adr6-smtp_addr.
      elseif wa_adr6-consnumber = '2'.
        wa_final-smtp_addr2 = wa_adr6-smtp_addr.
      elseif wa_adr6-consnumber = '3'.
        wa_final-smtp_addr3 = wa_adr6-smtp_addr.
      endif.

    endloop.

    read table it_t005u into wa_t005u with key spras = wa_adrc-langu
                                               land1 = wa_adrc-country
                                               bland = wa_adrc-region.
    if sy-subrc = 0.
      wa_final-bezei   =  wa_t005u-bezei.

    endif.

    read table it_tinct into wa_tinct with key inco1 = wa_lfm1-inco1
                                               spras = 'E'.
    if sy-subrc = 0.
      wa_final-inco_text  =   wa_tinct-bezei.

    endif.

    read table it_mm_tvzbt into wa_mm_tvzbt with key zterm = wa_lfm1-zterm
                                                     spras = 'E'.

    if sy-subrc = 0.
      wa_final-vtext   = wa_mm_tvzbt-vtext.

    endif.


    read table it_fi_tvzbt into wa_fi_tvzbt with key zterm = wa_lfb1-zterm
                                                     spras = 'E'.

    if sy-subrc = 0.
      wa_final-vtext1   = wa_fi_tvzbt-vtext.

    endif.

    read table it_t059u into wa_t059u with key witht = wa_lfbw-wt_withcd
                                               spras = 'E'
                                               land1 = 'IN'.
    if sy-subrc = 0.
      wa_final-text40    =    wa_t059u-text40.

    endif.

**************************************************Vendor Text ************************************************
    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0001'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt1 wa_lines-tdline into wa_final-txt1 separated by space.
        endif.
      endloop.
      condense wa_final-txt1.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0002'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt2 wa_lines-tdline into wa_final-txt2 separated by space.
        endif.
      endloop.
      condense wa_final-txt2.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0003'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt3 wa_lines-tdline into wa_final-txt3 separated by space.
        endif.
      endloop.
      condense wa_final-txt3.
    endif.

    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0004'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt4 wa_lines-tdline into wa_final-txt4 separated by space.
        endif.
      endloop.
      condense wa_final-txt4.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0005'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt5 wa_lines-tdline into wa_final-txt5 separated by space.
        endif.
      endloop.
      condense wa_final-txt5.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0006'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt6 wa_lines-tdline into wa_final-txt6 separated by space.
        endif.
      endloop.
      condense wa_final-txt6.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0007'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt7 wa_lines-tdline into wa_final-txt7 separated by space.
        endif.
      endloop.
      condense wa_final-txt7.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0008'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt8 wa_lines-tdline into wa_final-txt8 separated by space.
        endif.
      endloop.
      condense wa_final-txt8.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0009'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt9 wa_lines-tdline into wa_final-txt9 separated by space.
        endif.
      endloop.
      condense wa_final-txt9.
    endif.



    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0010'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt10 wa_lines-tdline into wa_final-txt10 separated by space.
        endif.
      endloop.
      condense wa_final-txt10.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0011'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt11 wa_lines-tdline into wa_final-txt11 separated by space.
        endif.
      endloop.
      condense wa_final-txt11.
    endif.

    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0012'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt12 wa_lines-tdline into wa_final-txt12 separated by space.
        endif.
      endloop.
      condense wa_final-txt12.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0013'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt13 wa_lines-tdline into wa_final-txt13 separated by space.
        endif.
      endloop.
      condense wa_final-txt1.
    endif.

    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0014'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt14 wa_lines-tdline into wa_final-txt14 separated by space.
        endif.
      endloop.
      condense wa_final-txt1.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0015'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt15 wa_lines-tdline into wa_final-txt15 separated by space.
        endif.
      endloop.
      condense wa_final-txt1.
    endif.

    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0016'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt16 wa_lines-tdline into wa_final-txt16 separated by space.
        endif.
      endloop.
      condense wa_final-txt1.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0017'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt17 wa_lines-tdline into wa_final-txt17 separated by space.
        endif.
      endloop.
      condense wa_final-txt17.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0018'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt18 wa_lines-tdline into wa_final-txt18 separated by space.
        endif.
      endloop.
      condense wa_final-txt18.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0019'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt19 wa_lines-tdline into wa_final-txt19 separated by space.
        endif.
      endloop.
      condense wa_final-txt1.
    endif.


    clear: lv_lines, ls_mattxt,lv_name.
    refresh lv_lines.
    lv_name = wa_final-lifnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = '0020'
        language                = sy-langu
        name                    = lv_name
        object                  = 'LFA1'
      tables
        lines                   = lv_lines
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.
    if not lv_lines is initial.
      loop at lv_lines into wa_lines.
        if not wa_lines-tdline is initial.
          concatenate wa_final-txt20 wa_lines-tdline into wa_final-txt20 separated by space.
        endif.
      endloop.
      condense wa_final-txt20.
    endif.
***********************************************Dowanload Data*********************************************
    ls_final-lifnr                 =                    wa_final-lifnr    .
    ls_final-ktokk                 =                    wa_final-ktokk .
    ls_final-anred                 =                    wa_final-anred .
    ls_final-name1                 =                    wa_final-name1 .
    ls_final-name2                 =                    wa_final-name2 .
    ls_final-sortl                 =                    wa_final-sortl .
    ls_final-kunnr                 =                    wa_final-kunnr .
    ls_final-bukrs                 =                    wa_final-bukrs.
    ls_final-akont                 =                    wa_final-akont.
    ls_final-zuawa                 =                    wa_final-zuawa.
    ls_final-reprf                 =                    wa_final-reprf.
    ls_final-zterm1                =                    wa_final-zterm1.
    ls_final-str_suppl1            =                    wa_final-str_suppl1.
    ls_final-str_suppl2            =                    wa_final-str_suppl2.
    ls_final-str_suppl3            =                    wa_final-str_suppl3.
    ls_final-street                =                    wa_final-street    .
    ls_final-house_num1            =                    wa_final-house_num1.
    ls_final-city2                 =                    wa_final-city2     .
    ls_final-post_code1            =                    wa_final-post_code1.
    ls_final-city1                 =                    wa_final-city1     .
    ls_final-country               =                    wa_final-country   .
    ls_final-region                =                    wa_final-region    .
    ls_final-po_box                =                    wa_final-po_box    .
    ls_final-langu                 =                    wa_final-langu     .
    ls_final-tel_number            =                    wa_final-tel_number.
    ls_final-fax_number            =                    wa_final-fax_number.
    ls_final-banks                 =                    wa_final-banks.
    ls_final-bankl                 =                    wa_final-bankl.
    ls_final-bankn                 =                    wa_final-bankn.
    ls_final-koinh                 =                    wa_final-koinh.
    ls_final-ekorg                 =                    wa_final-ekorg.
    ls_final-waers                 =                    wa_final-waers.
    ls_final-zterm                 =                    wa_final-zterm.
    ls_final-inco1                 =                    wa_final-inco1.
    ls_final-inco2                 =                    wa_final-inco2.
    ls_final-webre                 =                    wa_final-webre.
    ls_final-lebre                 =                    wa_final-lebre.
    ls_final-kzabs                 =                    wa_final-kzabs.
*    ls_final-j_1icstno             =                    wa_final-j_1icstno.
*    ls_final-j_1ilstno             =                    wa_final-j_1ilstno.
*    ls_final-j_1isern              =                    wa_final-j_1isern .
*    ls_final-j_1iexcd              =                    wa_final-j_1iexcd .
*    ls_final-j_1iexrn              =                    wa_final-j_1iexrn .
*    ls_final-j_1iexrg              =                    wa_final-j_1iexrg .
*    ls_final-j_1iexdi              =                    wa_final-j_1iexdi .
*    ls_final-j_1iexco              =                    wa_final-j_1iexco .
    ls_final-j_1ivtyp              =                    wa_final-j_1ivtyp .
*    ls_final-j_1ipanno             =                    wa_final-j_1ipanno.
    ls_final-wt_withcd             =                    wa_final-wt_withcd.
    ls_final-wt_subjct             =                    wa_final-wt_subjct.
    ls_final-banka                 =                    wa_final-banka.
    ls_final-brnch                 =                    wa_final-brnch.
    ls_final-provz                 =                    wa_final-provz.
    ls_final-stras                 =                     wa_final-stras.
    ls_final-ort01                 =                    wa_final-ort01.
    ls_final-swift                 =                    wa_final-swift.
*    LS_FINAL-SMTP_ADDR             =                    WA_FINAL-SMTP_ADDR.
    ls_final-stcd3                 =                    wa_final-stcd3.
    ls_final-bezei                 =                    wa_t005u-bezei.
    ls_final-inco_text             =                    wa_final-inco_text.
    ls_final-vtext                 =                    wa_final-vtext.
    ls_final-vtext1                =                    wa_final-vtext1.
    ls_final-text40                =                    wa_final-text40.
    ls_final-erdat                 =                    wa_final-erdat.
    ls_final-status                =                    wa_final-status.
    ls_final-loevm                 =                    wa_final-loevm.
    ls_final-ven_class             =                    wa_final-ven_class.
    ls_final-verkf                 =                    wa_final-verkf.
    ls_final-telf1                 =                    wa_final-telf1.
    ls_final-j_1kftbus             =                    wa_final-j_1kftbus.
    ls_final-j_1kftind             =                    wa_final-j_1kftind.

    ls_final-txt1                   =                    wa_final-txt1 .
    ls_final-txt2                   =                    wa_final-txt2 .
    ls_final-txt3                   =                    wa_final-txt3 .
    ls_final-txt4                   =                    wa_final-txt4 .
    ls_final-txt5                   =                    wa_final-txt5 .
    ls_final-txt6                   =                    wa_final-txt6 .
    ls_final-txt7                   =                    wa_final-txt7 .
    ls_final-txt8                   =                    wa_final-txt8 .
    ls_final-txt9                   =                    wa_final-txt9 .
    ls_final-txt10                  =                    wa_final-txt10.
    ls_final-txt11                  =                    wa_final-txt11.
    ls_final-txt12                  =                    wa_final-txt12.
    ls_final-txt13                  =                    wa_final-txt13.
    ls_final-txt14                  =                    wa_final-txt14.
    ls_final-txt15                  =                    wa_final-txt15.
    ls_final-txt16                  =                    wa_final-txt16.
    ls_final-txt17                  =                    wa_final-txt17.
    ls_final-txt18                  =                    wa_final-txt18.
    ls_final-txt19                  =                    wa_final-txt19.
    ls_final-txt20                  =                    wa_final-txt20.
    ls_final-smtp_addr1             =                    wa_final-smtp_addr1.
    ls_final-smtp_addr2             =                    wa_final-smtp_addr2.
    ls_final-smtp_addr3             =                    wa_final-smtp_addr3.
    ls_final-udate                  =                    wa_final-udate.           "ADDED BY DH 08.09.22
    ls_final-sperm                 =                    wa_final-sperm.           "ADDED BY DH 08.09.22




*BREAK PRIMUS.
    call function 'SCP_REPLACE_STRANGE_CHARS'                 "ADDED BY SNEHAL RAJALE ON 02 APRIL 2021 ( REFRESHABLE FILE ISSUE ).
      exporting
        intext  = ls_final-street
      importing
        outtext = ls_final-street.

    replace all occurrences of '.' in ls_final-street with ' '.

    call function 'SCP_REPLACE_STRANGE_CHARS'
      exporting
        intext  = ls_final-str_suppl3
      importing
        outtext = ls_final-str_suppl3.

    replace all occurrences of '.' in ls_final-str_suppl3 with ' '.

    call function 'SCP_REPLACE_STRANGE_CHARS'
      exporting
        intext  = ls_final-str_suppl2
      importing
        outtext = ls_final-str_suppl2.

    replace all occurrences of '.' in ls_final-str_suppl2 with ' '.

    call function 'SCP_REPLACE_STRANGE_CHARS'
      exporting
        intext  = ls_final-str_suppl1
      importing
        outtext = ls_final-str_suppl1.

    replace all occurrences of '.' in ls_final-str_suppl1 with ' '.
*
*    ls_final-ref = sy-datum.
*    call function 'CONVERSION_EXIT_IDATE_OUTPUT'
*      exporting
*        input  = ls_final-ref
*      importing
*        output = ls_final-ref.
*
*
*    concatenate ls_final-ref+0(2) ls_final-ref+2(3) ls_final-ref+5(4)
*                    into ls_final-ref separated by '-'.

    call function 'CONVERSION_EXIT_IDATE_OUTPUT'
      exporting
        input  = ls_final-erdat
      importing
        output = ls_final-erdat.


    concatenate ls_final-erdat+0(2) ls_final-erdat+2(3) ls_final-erdat+5(4)
                    into ls_final-erdat separated by '-'.

******************
*    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*      EXPORTING
*        input  = ls_final-udate
*      IMPORTING
*        output = ls_final-udate.
*
*    CONCATENATE ls_final-udate+0(2) ls_final-udate+2(3) ls_final-udate+5(4)
*                    INTO ls_final-udate SEPARATED BY '-'.

***   *******************

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          INPUT  = SY-DATUM
        IMPORTING
          OUTPUT = ls_final-REF.

      CONCATENATE ls_final-REF+0(2) ls_final-REF+2(3) ls_final-REF+5(4)
                      INTO ls_final-REF SEPARATED BY '-'.


      ls_final-REF_TIME = SY-UZEIT.
      CONCATENATE ls_final-REF_TIME+0(2) ':' ls_final-REF_TIME+2(2)  INTO ls_final-REF_TIME.

    append ls_final to lt_final.
    append wa_final to it_final.
    clear:wa_final,wa_t059u,wa_lfa1,wa_lfb1,wa_lfm1,wa_adrc,wa_adr6,wa_lfbk,wa_lfbw,wa_bnka,wa_t005u,wa_tinct,wa_mm_tvzbt,wa_fi_tvzbt,wa_j_1imovend .
  endloop.

endform.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_fcat .
  perform fcat using : '1'  'LIFNR '          'IT_FINAL'  'Number of Vendor'           '18' ,
                       '2'  'BUKRS '          'IT_FINAL'  'Company Code'               '18',
                       '3'  'EKORG '          'IT_FINAL'  'Pur.Org'                    '18' ,
                       '4'  'KTOKK '          'IT_FINAL'  'Ven.ac.group'               '18' ,
                       '5'  'ANRED '          'IT_FINAL'  'Title'                      '10' ,
                       '6'  'NAME1 '          'IT_FINAL'  'Name 1'                     '30' ,
                       '7'  'NAME2 '          'IT_FINAL'  'Name 2'                     '30' ,
                       '8'  'SORTL '          'IT_FINAL'  'Sort field'                 '10' ,
                       '9'  'STR_SUPPL1'      'IT_FINAL'  'Street 1'                   '30' ,
                       '10'  'STR_SUPPL2'     'IT_FINAL'  'Street 2'                   '30' ,
                       '11'  'STR_SUPPL3'     'IT_FINAL'  'Street 4'                   '30' ,
                       '12'  'STREET    '     'IT_FINAL'  'Street'                     '30' ,
                       '13'  'HOUSE_NUM1'     'IT_FINAL'  'House NO'                   '10' ,
                       '14'  'CITY2     '     'IT_FINAL'  'District'                   '18' ,
                       '15'  'POST_CODE1'     'IT_FINAL'  'City postal code'           '18' ,
                       '16'  'CITY1   '       'IT_FINAL'  'City'                       '18' ,
                       '17'  'COUNTRY '       'IT_FINAL'  'Country Key'                '18' ,
                       '18'  'REGION  '       'IT_FINAL'  'Region'                     '18' ,
                       '19'  'BEZEI  '        'IT_FINAL'  'Reg.Desc'                   '18' ,
                       '20'  'PO_BOX  '       'IT_FINAL'  'PO Box'                     '10' ,
                       '21'  'LANGU     '     'IT_FINAL'  'Language'                   '10' ,
                       '22'  'TEL_NUMBER'     'IT_FINAL'  'Telephone NO'               '10' ,
                       '23'  'FAX_NUMBER'     'IT_FINAL'  'Fax no'                     '10' ,
                       '24'  'SMTP_ADDR1'     'IT_FINAL'  'E-Mail 1'                   '18' ,
                       '25'  'SMTP_ADDR2'     'IT_FINAL'  'E-Mail 2'                   '18' ,
                       '26'  'SMTP_ADDR3'     'IT_FINAL'  'E-Mail 3'                   '18' ,

                       '27'  'BANKS     '     'IT_FINAL'  'Bank '                      '18' ,
                       '28'  'BANKL     '     'IT_FINAL'  'Bank Keys'                  '18' ,
                       '29'  'BANKN'          'IT_FINAL'  'Bank A/C.No'                '18' ,
                       '30'  'KOINH'          'IT_FINAL'  'A/C Holder Name'            '18' ,
                       '31'  'BANKA'          'IT_FINAL'  'Name of bank'               '18' ,
                       '32'  'BRNCH'          'IT_FINAL'  'Bank Branch'                '18' ,
                       '33'  'PROVZ'          'IT_FINAL'  'Region'                     '18' ,
                       '34'  'STRAS'          'IT_FINAL'  'House Number'               '18' ,
                       '35'  'ORT01'          'IT_FINAL'  'City'                       '18' ,
                       '36'  'SWIFT'          'IT_FINAL'  'International Payment'      '18' ,
                       '37'  'AKONT '         'IT_FINAL'  'Recon.AC Gen.Ledger'        '18' ,
                       '38'  'ZUAWA '         'IT_FINAL'  'Assig. No'                  '18' ,
                       '39'  'ZTERM1'         'IT_FINAL'  'FI Terms of Payment'        '18' ,
                       '40'  'VTEXT1'         'IT_FINAL'  'Desc.Terms of Payment'      '30' ,
                       '41'  'REPRF '         'IT_FINAL'  'Invoices Flag'              '18' ,
                       '42'  'WAERS '         'IT_FINAL'  'Pur.order Curren'           '18' ,
                       '43'  'ZTERM'          'IT_FINAL'  'MM Terms of Payment'        '18' ,
                       '44'  'VTEXT'          'IT_FINAL'  'Desc.Terms of Payment'        '30' ,
                       '45'  'INCO1'          'IT_FINAL'  'Incoterms1'                 '18' ,
                       '46'  'INCO_TEXT'      'IT_FINAL'  'INCO1 TEXT'                 '20' ,
                       '47'  'INCO2'          'IT_FINAL'  'Incoterms2'                 '18' ,
                       '48'  'WEBRE'          'IT_FINAL'  'GR-Based Inv'               '18' ,
                       '49'  'LEBRE'          'IT_FINAL'  'Service-Based Inv'          '18' ,
                       '50'  'KZABS'          'IT_FINAL'  'Ackn.Req'                   '18' ,
                       '51'  'KUNNR'          'IT_FINAL'  'Customer No'                '18' ,
*                       '52'  'J_1ICSTNO'      'IT_FINAL'  'Central Sales Tax No'       '18' ,
*                       '53'  'J_1ILSTNO'      'IT_FINAL'  'Local Sales Tax No'         '18' ,
*                       '54'  'J_1ISERN '      'IT_FINAL'  'Serv.Tax Regi No'           '18' ,
*                       '55'  'J_1IEXCD '      'IT_FINAL'  'ECC No'                     '18' ,
*                       '56'  'J_1IEXRN '      'IT_FINAL'  'Excise Regi.No'             '18' ,
*                       '57'  'J_1IEXRG '      'IT_FINAL'  'Excise Range'               '18' ,
*                       '58'  'J_1IEXDI '      'IT_FINAL'  'Excise Divi'                '18' ,
*                       '59'  'J_1IEXCO '      'IT_FINAL'  'Excise Commis.rate'         '18' ,
                       '60'  'J_1IVTYP '      'IT_FINAL'  'Type of Vendor'             '18' ,
*                       '61'  'J_1IPANNO'      'IT_FINAL'  'PAN No'                     '18' ,
                       '62'  'WT_WITHCD'      'IT_FINAL'  'Withholding tax code'       '18' ,
                       '63'  'TEXT40'         'IT_FINAL'  'Desc.WitH.tax code'         '20' ,
                       '64'  'WT_SUBJCT'      'IT_FINAL'  'withholding tax indi'       '18' ,
                       '65'  'STCD3'          'IT_FINAL'  'Vat.Reg.Code'                   '18' ,
                       '66'  'ERDAT'          'IT_FINAL'  'Creation Date'              '18' ,
                       '67'  'STATUS'         'IT_FINAL'  'MSME Status'                '18' ,
                       '68'  'LOEVM'          'IT_FINAL'  'Deletion Ind.'              '18' ,
                       '69'  'VEN_CLASS'      'IT_FINAL'  'GST Class'                  '18' ,
                       '70'  'VERKF'          'IT_FINAL'  'Sales Person'               '18' ,
                       '71'  'TELF1'          'IT_FINAL'  'Sale person Telephone'      '18' ,

                       '72'  'TXT1'           'IT_FINAL'  'Scope of Approval'                      '30' ,
                       '73'  'TXT2'           'IT_FINAL'  'QMS/Other Certificate Due Dt'           '30' ,
                       '74'  'TXT3'           'IT_FINAL'  'HT Fur 1 Annual Survey Due Dt'          '30' ,
                       '75'  'TXT4'           'IT_FINAL'  'HT Fur 2 Annual Survey Due Dt'          '30' ,
                       '76'  'TXT5'           'IT_FINAL'  'HT Fur 3 Annual Survey Due Dt'          '30' ,
                       '77'  'TXT6'           'IT_FINAL'  'HT Fur 4 Annual Survey Due Dt'          '30' ,
                       '78'  'TXT7'           'IT_FINAL'  'HT Fur 5 Annual Survey Due Dt'          '30' ,
                       '79'  'TXT8'           'IT_FINAL'  'HT Fur 1 Qtr TC-Calbtn Due Dt'          '30' ,
                       '80'  'TXT9'           'IT_FINAL'  'HT Fur 2 Qtr TC-Calbtn Due Dt'          '30' ,
                       '81'  'TXT10'          'IT_FINAL'  'HT Fur 3 Qtr TC-Calbtn Due Dt'          '30' ,
                       '82'  'TXT11'          'IT_FINAL'  'HT Fur 4 Qtr TC-Calbtn Due Dt'          '30' ,
                       '83'  'TXT12'          'IT_FINAL'  'HT Fur 5 Qtr TC-Calbtn Due Dt'          '30' ,
                       '84'  'TXT13'          'IT_FINAL'  'HT Fur 1 Qtr TR-Calbtn Due Dt'          '30' ,
                       '85'  'TXT14'          'IT_FINAL'  'HT Fur 2 Qtr TR-Calbtn Due Dt'          '30' ,
                       '86'  'TXT15'          'IT_FINAL'  'HT Fur 3 Qtr TR-Calbtn Due Dt'          '30' ,
                       '87'  'TXT16'          'IT_FINAL'  'HT Fur 4 Qtr TR-Calbtn Due Dt'          '30' ,
                       '88'  'TXT17'          'IT_FINAL'  'HT Fur 5 Qtr TR-Calbtn Due Dt'          '30' ,
                       '89'  'TXT18'          'IT_FINAL'  'Initial Evaluation dt'                  '30' ,
                       '90'  'TXT19'          'IT_FINAL'  'Last Evaluation Dt'                     '30' ,
                       '91'  'TXT20'          'IT_FINAL'  'Re-Evaluation Dt'                       '30' ,
                       '92'  'J_1KFTBUS'      'IT_FINAL'  'Critical Status'                        '20' ,
                       '93'  'J_1KFTIND'      'IT_FINAL'  'Type of supply'                         '20' ,
                       '94'  'UDATE'          'IT_FINAL'  'Last Updated Date'                      '18',    "DH 08.09.22
                       '95'  'SPERM'          'IT_FINAL'  'Blocked Indicator'                      '18'. "DH 08.09.22


**
*                     '96'  'REF'            'IT_FINAL'  'Refresh Date'               '18' ,
*                     '97'  'REF_TIME'            'IT_FINAL'  'Refresh TIME'               '18' .
endform.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1013   text
*      -->P_1014   text
*      -->P_1015   text
*      -->P_1016   text
*      -->P_1017   text
*----------------------------------------------------------------------*
form fcat  using    value(p1)
                    value(p2)
                    value(p3)
                    value(p4)
                    value(p5).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  append wa_fcat to it_fcat.
  clear wa_fcat.

endform.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_display .
  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      it_fieldcat        = it_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
      i_default          = 'X'
      i_save             = 'X'
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    tables
      t_outtab           = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.

  if p_down = 'X'.
    perform download.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form download .
  type-pools truxs.
  data: it_csv type truxs_t_text_data,
        wa_csv type line of truxs_t_text_data,
        hd_csv type line of truxs_t_text_data.

*  DATA: lv_folder(150).
  data: lv_file(30).
  data: lv_fullfile type string,
*        lv_dat(10),
        lv_dat(18),
        lv_tim(4).
  data: lv_msg(80).
*BREAK primus.
  call function 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    tables
      i_tab_sap_data       = lt_final
    changing
      i_tab_converted_data = it_csv
    exceptions
      conversion_failed    = 1
      others               = 2.
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.

  perform cvs_header using hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZSU_VENDOR_MASTER.TXT'.

*  concatenate p_folder '\' lv_file
  concatenate p_folder '/' lv_file
    into lv_fullfile.
*BREAK primus.
  write: / 'ZSU_VENDOR_MASTER started on', sy-datum, 'at', sy-uzeit.
  open dataset lv_fullfile
    for output in text mode encoding default.  "NON-UNICODE.
  if sy-subrc = 0.
DATA lv_string_2063 TYPE string.
DATA lv_crlf_2063 TYPE string.
lv_crlf_2063 = cl_abap_char_utilities=>cr_lf.
lv_string_2063 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_2063 lv_crlf_2063 wa_csv INTO lv_string_2063.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_2063 TO lv_fullfile.
    concatenate 'File' lv_fullfile 'downloaded' into lv_msg separated by space.
    message lv_msg type 'S'.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
form cvs_header  using    pd_csv.
  data: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  concatenate 'Number of Vendor'
              'Company Code'
              'Pur.Org'
              'Ven.ac.group'
              'Title'
              'Name 1'
              'Name 2'
              'Sort field'
              'Street 1'
              'Street 2'
              'Street 4'
              'Street'
              'House NO'
              'District'
              'City postal code'
              'City'
              'Country Key'
              'Region'
              'Reg.Desc'
              'PO Box'
              'Language'
              'Telephone NO'
              'Fax no'
              'E-Mail 1'
              'E-Mail 2'
              'E-Mail 3'
              'Bank '
              'Bank Keys'
              'Bank A/C.No'
              'A/C Holder Name'
              'Name of bank'
              'Bank Branch'
              'Region'
              'House Number'
              'City'
              'International Payment'
              'Recon.AC Gen.Ledger'
              'Assig. No'
              'FI Terms of Payment'
              'Desc.Terms of Payment'
              'Invoices Flag'
              'Pur.order Curren'
              'MM Terms of Payment'
              'Desc.Terms of Payment'
              'Incoterms1'
              'INCO1 TEXT'
              'Incoterms2'
              'GR-Based Inv'
              'Service-Based Inv'
              'Ackn.Req'
              'Customer No'
              'Type of Vendor'
              'Withholding tax code'
              'Desc.WitH.tax code'
              'Withholding Tax Indi'
              'Vat.Reg.Code'
              'Creation Date'
              'MSME Status'
              'Deletion Ind.'
              'GST Class'
              'Sales Person'
              'Sale person Telephone'
              'Scope of Approval'
              'QMS/Other Certificate Due Dt'
              'HT Fur 1 Annual Survey Due Dt'
              'HT Fur 2 Annual Survey Due Dt'
              'HT Fur 3 Annual Survey Due Dt'
              'HT Fur 4 Annual Survey Due Dt'
              'HT Fur 5 Annual Survey Due Dt'
              'HT Fur 1 Qtr TC-Calbtn Due Dt'
              'HT Fur 2 Qtr TC-Calbtn Due Dt'
              'HT Fur 3 Qtr TC-Calbtn Due Dt'
              'HT Fur 4 Qtr TC-Calbtn Due Dt'
              'HT Fur 5 Qtr TC-Calbtn Due Dt'
              'HT Fur 1 Qtr TR-Calbtn Due Dt'
              'HT Fur 2 Qtr TR-Calbtn Due Dt'
              'HT Fur 3 Qtr TR-Calbtn Due Dt'
              'HT Fur 4 Qtr TR-Calbtn Due Dt'
              'HT Fur 5 Qtr TR-Calbtn Due Dt'
              'Initial Evaluation dt'
              'Last Evaluation Dt'
              'Re-Evaluation Dt'
              'Critical Status'
              'Type of supply'
              'Last updated Date'
              'Blocked Indicator'
              'Refresh Date'
              'Refresh Time'
              into pd_csv
              separated by l_field_seperator.
endform.
