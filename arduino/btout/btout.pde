#include <SoftwareSerial.h>

#define RX 2
#define TX 3

SoftwareSerial nss = SoftwareSerial(RX,TX);

void setup(){
  pinMode(RX, INPUT);
  pinMode(TX, OUTPUT);
  
  Serial.begin(115200);
  nss.begin(9600);
}


void loop(){
  Serial.println("hallo");
  nss.println("hallo");
  delay(300);
}
