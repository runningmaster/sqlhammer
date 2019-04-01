unit SHEvents;

interface

const
{ ---------------------------------------------------------------------------- }

  //
  //  !!!   D  E  P  R  E  C  A  T  E  D   !!!
  //

{ BASE EVENTS }
  SHE_BASE_EVENT                    = $0400 + 100; { WM_USER }
{ IDE EVENTS }
  SHE_MAIN_EVENT                    = SHE_BASE_EVENT + 1000;

  SHE_OPTIONS_CHANGED               = SHE_MAIN_EVENT + 1;
  SHE_OPTIONS_DEFAULTS_RESTORED     = SHE_MAIN_EVENT + 2;

  SHE_REFRESH_OBJECT_INSPECTOR      = SHE_MAIN_EVENT + 5;

implementation

end.
