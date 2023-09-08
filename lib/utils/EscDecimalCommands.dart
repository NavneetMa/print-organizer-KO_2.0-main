class EscDecimalCommands {

  ///86 => Shift V => symbol is V ; 49 => One Digit : symbol is 1 => It means full cut the paper
  static const List<int> paperCutCommand = [29, 86, 49]; // This combination is used for paper cutting
  static const List<int> newLineCommand = [13, 10, 12]; //
  static const List<int> startPrinter = [27, 64, 27, 116, 50, 10];
  static const List<int> printOneLine = [27, 33, 48, 27, 116, 16]; // 33 and 48 at are font and text size
  static const List<int> cutPaper = [10, 10, 10, 10, 10, 29, 86, 49];

  ///This commands tells that treat the data as command
  static const int startCmd = 27; //Escape -> ESC : symbol is [

  /// This command tells the printer that do not treat further data as command
  static const int dataLineEscape = 16; //Data Line Escape -> DLE : symbol is P
  /// One line end command
  static const List<int> oneLineEnd = [27, 116, 16];

  ///Separators
  static const int fileSeparator = 28; //File Separator -> FS : symbol is => \
  static const int groupSeparator = 29; //Group Separator -> GS : symbol is ]
  static const int recordSeparator = 30; //Record Separator -> RS : symbol is => ^

  ///Feed commands
  static const int carriageReturn = 13; //Carriage Return -> CR : symbol is => M
  static const int lineFeed = 10; //Line Feed -> LF : symbol is => J
  static const int formFeed = 12; //Form Feed -> FF : symbol is => L

  /// Select character code table
  static const int charCodeTable = 116; //Character code table -> T : symbol is => t

  ///Select character font
  static const int charFont = 77; //Select charecter font -> Shift M : symbol is M

  ///Numbers
  static const int one = 48;
  static const int two = 49;
  static const int three = 50;

  static const int endOfText = 3; //End Of Text -> ETX : symbol is C

  ///Wild characters
  static const int asterisk = 42;
  static const int atIntializePrinter = 64; //Initialize printer //Clears the data in the print buffer and resets the printer modes to the modes that were in effect when the power was turned on

  static const List<int> imageHeader = [27, 64, 10, 29, 118, 48, 3]; //Image header

  // This is the command to check for json data in the print data. If this sequnce is found then there is json data in the print
  static const List<int> kassaJSONStart = [29, 86, 49, 27, 64, 15, 27, 116, 16];

  // 13 -> Carriage return means to return to the beginning of the current line without advancing downward. The name comes from a printer's carriage, as monitors were rare when the name was coined. This is commonly escaped as "\r", abbreviated CR, and has ASCII value 13 or 0xD.

  // 10 -> Linefeed means to advance downward to the next line; however, it has been repurposed and renamed. Used as "newline", it terminates lines (commonly confused with separating lines). This is commonly escaped as "\n", abbreviated LF or NL, and has ASCII value 10 or 0xA. CRLF (but not CRNL) is used for the pair "\r\n".

  // 12 -> Form feed means advance downward to the next "page". It was commonly used as page separators, but now is also used as section separators. Text editors can use this character when you "insert a page break". This is commonly escaped as "\f", abbreviated FF, and has ASCII value 12 or 0xC.
}
