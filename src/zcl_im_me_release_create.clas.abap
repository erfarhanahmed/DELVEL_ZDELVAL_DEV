class ZCL_IM_ME_RELEASE_CREATE definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ME_RELEASE_CREATE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_ME_RELEASE_CREATE IMPLEMENTATION.


  method IF_EX_ME_RELEASE_CREATE~AFTER_CREATION.
*    BREAK-POINT .
  endmethod.


  method IF_EX_ME_RELEASE_CREATE~BEFORE_CREATION.
  endmethod.
ENDCLASS.
