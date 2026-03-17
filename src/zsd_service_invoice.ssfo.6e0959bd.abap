DATA:   lt_nast           TYPE STANDARD TABLE OF NAST,
        ls_nast           TYPE NAST.

  G_TOTALCOPIES = is_nast-repid.

  SELECT * FROM NAST INTO TABLE lt_nast WHERE
    KAPPL = is_nast-kappl AND
    KSCHL = is_nast-kschl AND
    OBJKY = is_nast-objky AND
    VSTAT = 1.

  LOOP AT lt_nast INTO ls_nast.

    G_TOTALCOPIES = G_TOTALCOPIES + ls_nast-anzal.
  ENDLOOP.

  SHIFT G_TOTALCOPIES LEFT DELETING LEADING '0'.

