/* [Text] */
txtString="Test1234";
txtSize=10;
txtFont="Noto Sans"; //font
txtStyle="regular"; //["regular","bold","italic"]
txtDir="ltr"; //["ltr":"left to right","rtl":"right to left"]
txtLang="en"; //["en","ar","ch"]
txtScript="latin"; //["latin","arabic","hani"]

//txtFontStyle = search(txtFont,"style") ? txtFont : str(txtFont,":style=",txtStyle);

text(txtString,txtSize,str(txtFont,":style=",txtStyle),txtDir,txtLang,txtScript);

