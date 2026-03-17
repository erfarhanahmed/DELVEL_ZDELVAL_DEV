*BREAK KANKIT.

    data:      objname       type          tdobname.
*BREAK KANKIT.

*  OBJNAME = WA_ITEM-MATNR.

*  IF LANG IS INITIAL.
*    LANG = 'E'.
*  ENDIF.
refresh : text_lines1 , text_lines1[] ,
          text_lines2 , text_lines2[] .

clear : objname .

objname = wa_gr_item-matnr.

* BREAK fujiabap.
"""""""""""""""""""Added by Pranit 24.07.2024

 select single stlnr from mast into @data(wa_mast) where matnr = @wa_gr_item-matnr.

   objname = wa_gr_item-matnr.
   if objname is NOT initial.
  call function 'READ_TEXT'
    exporting
*     CLIENT                        = SY-MANDT
      id                            = 'GRUN'
      language                      = SY-LANGU
      name                          = objname
      object                        = 'MATERIAL'
    tables
      lines                         = text_lines1
   exceptions
     id                            = 1
     language                      = 2
     name                          = 3
     not_found                     = 4
     object                        = 5
     reference_check               = 6
     wrong_access_to_archive       = 7
     others                        = 8.

  call function 'READ_TEXT'
    exporting
*     CLIENT                        = SY-MANDT
      id                            = 'GRUN'
      language                      = 'S'
      name                          = objname
      object                        = 'MATERIAL'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = text_lines2
   exceptions
     id                            = 1
     language                      = 2
     name                          = 3
     not_found                     = 4
     object                        = 5
     reference_check               = 6
     wrong_access_to_archive       = 7
     others                        = 8
     .
    ENDIF.
*    BREAK primusabap.

    SELECT SINGLE a~IDNRK
          INTO @DATA(gS_main)
          FROM STPO AS A
          JOIN MAST AS B ON B~stlnr EQ A~stlnr
          WHERE B~matnr = @wa_gr_item-matnr.

    SELECT SINGLE MTART FROM mara INTO @data(gS_main_n)
       WHERE matnr = @gS_main.

      IF gS_main IS NOT INITIAL.
if gS_main_n eq 'ROH'.
  objname = gS_main.
  call function 'READ_TEXT'
    exporting
*     CLIENT                         = SY-MANDT
      id                            = 'GRUN'
      language                      = 'S'
      name                          = objname
      object                        = 'MATERIAL'
    tables
      lines                         = text_lines2
   exceptions
     id                            = 1
     language                      = 2
     name                          = 3
     not_found                     = 4
     object                        = 5
     reference_check               = 6
     wrong_access_to_archive       = 7
     others                        = 8.
ENDIF.
  ENDIF.
       SELECT SINGLE a~IDNRK
          INTO @DATA(gS_main1)
          FROM STPO AS A
          JOIN MAST AS B ON B~stlnr EQ A~stlnr
          WHERE B~matnr = @gS_main.

           SELECT SINGLE MTART FROM mara INTO @data(gS_main1_n)
       WHERE matnr = @gS_main1.

         if gS_main1_n eq 'ROH'.
         objname = gS_main1.
  call function 'READ_TEXT'
    exporting
*     CLIENT                         = SY-MANDT
      id                            = 'GRUN'
      language                      = 'S'
      name                          = objname
      object                        = 'MATERIAL'
    tables
      lines                         = text_lines2
   exceptions
     id                            = 1
     language                      = 2
     name                          = 3
     not_found                     = 4
     object                        = 5
     reference_check               = 6
     wrong_access_to_archive       = 7
     others                        = 8.
  ENDIF.

   SELECT SINGLE a~IDNRK
          INTO @DATA(gS_main2)
          FROM STPO AS A
         INNER JOIN MAST AS B ON B~stlnr EQ A~stlnr
          WHERE B~matnr = @gS_main1.

     SELECT SINGLE MTART FROM mara INTO @data(gS_main2_n)
       WHERE matnr = @gs_main2.

         if gS_main2_n eq 'ROH'.
  objname = gS_main2.
   call function 'READ_TEXT'
    exporting
*     CLIENT                        = SY-MANDT
      id                            = 'GRUN'
      language                      = 'S'
      name                          = objname
      object                        = 'MATERIAL'
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = text_lines2
   exceptions
     id                            = 1
     language                      = 2
     name                          = 3
     not_found                     = 4
     object                        = 5
     reference_check               = 6
     wrong_access_to_archive       = 7
     others  .
  ENDIF.
