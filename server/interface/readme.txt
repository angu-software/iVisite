Webservices
Es wurden mittels nuSOAP(=>libs) und mdb2(=>PEAR) implementiert.

config.php:
Enth�lt die Zugriffsparameter auf die DB mittels dsn

ivisite_data.php:
Definition der Webservices

ivisite_data_parser.php:
Transformation der Daten aus der DB zu Datenprotokoll

ivisite_test.php:
Testanwendung zur �berpr�fung der Ergebnisse der Webservices

(mdb2_test.php:
Testanwendung zur �berpr�fung des Datenzugriffs mittels mdb2)


Verwendung

Im Prinzip gibt es nur eine Funktion "getAllData" die als Parameter eine arzt_id erwartet.
Damit werden folglich alle Daten f�r den Arzt geladen:
	Arztinformation
	Seine Patienten und deren Informationen
	Behandlungsinformationen der Patienten
	
	
URL f�r Webservice:
http://mk.base23.de/ivisite/server/interface/ivisite_data.php

URL f�rs Testen des Webservice:

http://mk.base23.de/ivisite/server/interface/ivisite_test.php?arzt_id=1&debug=1

Parameter:
arzt_id = Datenbank Id des Arztes
debug = 1 falls die Daten nicht als Ascii Werte sichtbar gemacht werden sollten und zus�tzliche Informationen anzeigen.

