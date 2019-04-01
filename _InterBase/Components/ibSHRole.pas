unit ibSHRole;

interface

uses
  SysUtils, Classes,
  SHDesignIntf,
  ibSHDesignIntf, ibSHDBObject;

type
  TibBTRole = class(TibBTDBObject, IibSHRole)
  published
    property OwnerName;
  end;

implementation

uses
  ibSHConsts, ibSHSQLs;

{ TibBTRole }

end.

