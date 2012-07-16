#include <BTDevConnection.h>

#define DEVELOPER_IN 12
#define DEVELOPER_OUT 13

#define LED 5

// Development bluetooth module connection
BTDevConnection connection(productiveSetup, DEVELOPER_IN, DEVELOPER_OUT);

#define BT_SPEED 115200
#define BLUETOOTH_RESET 7
// iPod BT address 34:15:9E:7D:26:8C
// Mac BT address 60:33:4b:0b:27:df


void setup(){

  //pinMode(BLUETOOTH_RESET, OUTPUT);
  
  Serial.begin(BT_SPEED);

/*
  //Sending Reset to BT
  digitalWrite(BLUETOOTH_RESET, HIGH);
  delay(1000);
  digitalWrite(BLUETOOTH_RESET, LOW);
  
  */
  
}


boolean isConnected = false;

void loop(){
  /*
  if(connection.isDebugging() == false
      && isConnected == false){
    Serial.print("\r\n CALL 34:15:9E:7D:26:8C 11 HID \r\n");
    delay(5000);
    isConnected= true;
  }
  
  if(isConnected == true){
    Serial.print("\r\nhallo\r\n");
  }
  
  delay(1000);
  */
  
  Serial.print("1");
}

void productiveSetup() {
  /*
  connection.sendLine("SET BT PAGEMODE 3 2000 1");
  connection.sendLine("SET BT NAME MyConnection");
  connection.sendLine("SET BT ROLE 0 f 7d00");
  connection.sendLine("SET CONTROL ECHO 0");
  connection.sendLine("SET BT AUTH * 12345");
  connection.sendLine("SET CONTROL ESCAPE - 00 1");
  connection.sendLine("SET CONTROL BAUD 115200,8n1");
  */
}
