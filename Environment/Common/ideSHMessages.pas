unit ideSHMessages;

interface

resourcestring

  SUnderConstruction = 'Sorry,... coming soon' + sLineBreak + 'Under construction';
  SNotSupported = 'This version does not support this feature, sorry';
  SMustBeDescription = 'Description must be containing string "BlazeTop"';

  SLibraryExists = 'Library ''%s'' already registered';
  SLibraryRemoveQuestion = 'Remove library ''%s'' ?';
  SLibraryRemoveWarning = 'Warning: remove library will come into effect after program has been restarted';
  SLibraryCantLoad = 'Can not load library ''%s''';

  SPackageExists = 'Package ''%s'' already registered';
  SPackageRemoveQuestion = 'Remove package ''%s'' ?';
  SPackageRemoveWarning = 'Warning: remove package will come into effect after program has been restarted';
  SPackageCantLoad = 'Can not load package ''%s''';

  SCantFindComponentFactory = 'Can not find Component Factory for registered class %s,' + sLineBreak + 'ClassID: [%s]';
  SInvalidPropValue = '"%s" is invalid property value';
  
implementation

end.
