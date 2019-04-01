unit pSHConvertKW;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  SFileNameKW = 'MySQLDefaultKW.txt';
  SFileNameDT = 'MySQLDefaultDT.txt';
  SFileNameIF = 'MySQLDefaultIF.txt';

  MySqlKW: string = 'ACTION,AFTER,AGAINST,AGGREGATE,ALL,ALTER,ANALYZE,AND,AS,' +
    'ASC,AUTO_INCREMENT,AVG_ROW_LENGTH,BACKUP,BEGIN,BENCHMARK,BETWEEN,BINARY,' +
    'BIT,BOOL,BOTH,BY,CASCADE,CHANGE,CHARACTER,CHECK,CHECKSUM,COLUMN,COLUMNS,' +
    'COMMENT,COMMIT,CONSTRAINT,CREATE,CROSS,DATA,DATABASES,DEC,DEFAULT,' +
    'DELAYED,DELAY_KEY_WRITE,DELETE,DESC,DESCRIBE,DISTINCT,DISTINCTROW,DROP,' +
    'ELSE,ENCLOSED,END,ESCAPE,ESCAPED,EXISTS,EXPLAIN,FIELDS,FILE,FIRST,' +
    'FLOAT4,FLOAT8,FLUSH,FOR,FOREIGN,FROM,FULL,FULLTEXT,FUNCTION,GLOBAL,GRANT,' +
    'GRANTS,GROUP,HAVING,HEAP,HIGH_PRIORITY,HOSTS,IDENTIFIED,IGNORE,' +
    'INDEX,INFILE,INNER,INT1,INT2,INT3,INT4,INT8,INTO,IS,ISAM,JOIN,KEY,' +
    'KEYS,KILL,LEADING,LIKE,LIMIT,LINES,LOAD,LOCAL,LOCK,LOGS,LONG,' +
    'LOW_PRIORITY,MATCH,MAX_ROWS,MIDDLEINT,MIN_ROWS,MODIFY,MYISAM,' +
    'NATURAL,NO,NOT,NULL,OPTIMIZE,OPTION,OPTIONALLY,ON,OPEN,OR,ORDER,OUTER,' +
    'OUTFILE,PACK_KEYS,PARTIAL,PRECISION,PRIMARY,PRIVILEGES,PROCEDURE,' +
    'PROCESS,PROCESSLIST,READ,REFERENCES,REGEXP,RELOAD,RENAME,REPAIR,' +
    'RESTRICT,RESTORE,RETURNS,REVOKE,RLIKE,ROLLBACK,ROW,ROWS,SELECT,SHOW,' +
    'SHUTDOWN,SONAME,SQL_BIG_RESULT,SQL_BIG_SELECTS,SQL_BIG_TABLES,' +
    'SQL_LOG_OFF,SQL_LOG_UPDATE,SQL_LOW_PRIORITY_UPDATES,SQL_SELECT_LIMIT,' +
    'SQL_SMALL_RESULT,SQL_WARNINGS,STARTING,STATUS,STRAIGHT_JOIN,TABLE,' +
    'TABLES,TEMPORARY,TERMINATED,THEN,TO,TRAILING,TRANSACTION,TYPE,UNIQUE,' +
    'UNLOCK,UNSIGNED,UPDATE,USAGE,USE,USING,VALUES,VARBINARY,VARCHAR,' +
    'VARIABLES,VARYING,WHERE,WITH,WRITE,ZEROFILL';

  // types
  MySqlTypes: string = 'TINYINT,SMALLINT,MEDIUMINT,INT,INTEGER,BIGINT,FLOAT,' +
    'DOUBLE,REAL,DECIMAL,NUMERIC,DATE,DATETIME,TIMESTAMP,TIME,YEAR,CHAR,' +
    'NATIONAL,TINYBLOB,TINYTEXT,TEXT,BLOB,MEDIUMBLOB,MEDIUMTEXT,LONGBLOB,' +
    'LONGTEXT,ENUM,SET,STRING';

  // functions
  MySqlFunctions: string = 'ABS,ACOS,ASCII,ADD,ADDDATE,ASIN,ATAN,ATAN2,AVG,' +
    'BIN,BIT_AND,BIT_COUNT,BIT_OR,CASE,CHARACTER_LENGTH,CEILING,' +
    'CONNECTION_ID,CHAR_LENGTH,COALESCE,CONCAT,CONV,COS,COT,COUNT,' +
    'CURDATE,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURTIME,DATABASE,' +
    'DATE_ADD,DATE_FORMAT,DATE_SUB,DAY,DAYNAME,DAYOFMONTH,DAYOFWEEK,' +
    'DAYOFYEAR,DAY_HOUR,DAY_MINUTE,DAY_SECOND,DECODE,DEGREES,ELT,ENCODE,' +
    'ENCRYPT,EXP,EXPORT_SET,FIELD,FIND_IN_SET,FLOOR,FORMAT,FROM_DAYS,' +
    'FROM_UNIXTIME,GET_LOCK,GREATEST,HEX,HOUR,HOUR_MINUTE,HOUR_SECOND,IF,' +
    'IFNULL,IN,INET_NTOA,INET_ATON,INSERT,INSERT_ID,INSTR,INTERVAL,ISNULL,' +
    'LAST_INSERT_ID,LCASE,LEAST,LEFT,LENGTH,LOAD_FILE,LOCATE,LOG,LOG10,LOWER,' +
    'LPAD,LTRIM,MAKE_SET,MASTER_POS_WAIT,MAX,MD5,MID,MIN,MINUTE,' +
    'MINUTE_SECOND,MOD,MONTH,MONTHNAME,NOW,NULLIF,OCT,OCTET_LENGTH,ORD,' +
    'PASSWORD,PERIOD_ADD,PERIOD_DIFF,PI,POSITION,POW,POWER,QUARTER,RADIANS,' +
    'RAND,RELEASE_LOCK,REPEAT,REPLACE,REVERSE,RIGHT,ROUND,RPAD,RTRIM,SECOND,' +
    'SEC_TO_TIME,SESSION_USER,SIGN,SIN,SOUNDEX,SPACE,SQRT,STD,STDDEV,STRCMP,' +
    'SUBDATE,SUBSTRING,SUBSTRING_INDEX,SUM,SYSDATE,SYSTEM_USER,TAN,' +
    'TIME_FORMAT,TIME_TO_SEC,TO_DAYS,TRIM,TRUNCATE,UCASE,UNIX_TIMESTAMP,' +
    'UPPER,USER,VERSION,WEEK,WEEKDAY,WHEN,YEARWEEK,YEAR_MONTH';


procedure TForm1.Button1Click(Sender: TObject);
var
  S: TStringList;
begin
  S := TStringList.Create;
  try
    S.CommaText := MySqlKW;
    S.SaveToFile(ExtractFilePath(Application.ExeName) + SFileNameKW);
    S.Clear;
    S.CommaText := MySqlTypes;
    S.SaveToFile(ExtractFilePath(Application.ExeName) + SFileNameDT);
    S.Clear;
    S.CommaText := MySqlFunctions;
    S.SaveToFile(ExtractFilePath(Application.ExeName) + SFileNameIF);
  finally
    S.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
const
  s1='Firebird15KW.txt';
  s2='Firebird1KW.txt';
  s3='Interbase5KW.txt';
  s4='Interbase6KW.txt';
  s5='Interbase7KW.txt';
  s6='MySQLDefaultKW.txt';
  s7='SybaseDefault.txt';
var
  S: TStringList;
  procedure ReMakeFile(AFileName: string);
  var
    I: Integer;
  begin
    S.LoadFromFile(AFileName);
    for I := 0 to S.Count - 1 do
    begin
      if Pos(#9, S[I]) > 0 then
        S[I] := StringReplace(S[I], #9, '=', [])
      else
        S[I] := S[I] + '=';
    end;
    S.SaveToFile(AFileName);
  end;
begin
  try
    S := TStringList.Create;
    ReMakeFile(s1);
    ReMakeFile(s2);
    ReMakeFile(s3);
    ReMakeFile(s4);
    ReMakeFile(s5);
    ReMakeFile(s6);
    ReMakeFile(s7);
  finally
    S.Free;
  end;

end;

procedure TForm1.Button3Click(Sender: TObject);
var
  NamesList, CodeList: TStringList;
  ResultList: TStringList;
  I: Integer;
begin
  NamesList := TStringList.Create;
  CodeList := TStringList.Create;
  ResultList := TStringList.Create;
  try
    NamesList.LoadFromFile('c:\777\template_names.txt');
    CodeList.LoadFromFile('c:\777\templates.txt');
    for I := 0 to NamesList.Count - 1 do
    begin
      ResultList.Add(Format('[%s | BlazeTop keyboard template]',[NamesList[I]]));
      ResultList.Add(AnsiReplaceText(CodeList[I], '@', #13#10));
      ResultList.Add('');
    end;
    ResultList.SaveToFile('c:\777\InterBaseKeyboardTemplates.txt');
  finally
    NamesList.Free;
    CodeList.Free;
    ResultList.Free;
  end;
end;

end.
