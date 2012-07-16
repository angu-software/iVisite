#include <NewSoftSerial.h>
#include <SPI.h>
#include <Client.h>
#include <Ethernet.h>
#include <Server.h>
#include <Udp.h>

#define SYSTEM_LOOP_INTERVAL 0
#define DISCONNECT_WAIT 5000

//debugger
#define DEBUG 1
#define RX 3
#define TX 2
NewSoftSerial logger = NewSoftSerial(RX,TX);

// App states
#define STATE_RFID_DISCONNECTED 0
#define STATE_RFID_CONNECT 1
#define STATE_RFID_TAGINV 2
#define STATE_RFID_TAGINV_RESPONSE 3
#define STATE_RFID_TAG_DISCOVERED 4
#define STATE_RFID_DATARESPONSE 5

#define STATE_BT_DISCONNECTED 6
#define STATE_BT_CONNECTDEVICE 7
#define STATE_BT_CONNECTING 8
#define STATE_BT_DISCONNECT 9

#define STATE_SERVER_CONNECT 10
#define STATE_SERVER_SEND_REQUEST 11
#define STATE_SERVER_READ_REQUEST 12
#define STATE_SERVER_CLOSE 13
int state;

// ethernet addresses & mac
byte termMac[] = {
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte termIP[] = {192,168,2,100};
byte rfidIP[] = {192,168,2,239};
byte dataServer[] = {192,168,2,200};

// RFID Reader
#define RFID_COMMAND_WAIT 100
Client terminal_RFID = Client(rfidIP, 10001);

// server
#define SERVER_COMMAND_WAIT 100
#define SERVER_PORT 80
#define TRANSMISSON_END '@'
#define SERVER_GET_COMMAND "GET /iVisite/server/interface/ivisite_test.php?mobileid="
Client terminal_Server = Client(dataServer,SERVER_PORT);

// BT module
#define BT_RESET_PIN 4
#define BT_BAUD 115200
#define BT_COMMAND_WAIT 100
#define BT_DATA_SEND_DELAY 40
boolean btReady = false;

// data reveive buffer
#define LINEBUFFER_SIZE 513
char lineBuffer[LINEBUFFER_SIZE];
unsigned int lineBufferLength = 0;
boolean lineAvailable = false;

// recieve stream switch
#define RFID 0
#define BT 1
#define SERVER 2
int currStream;

// data storage
#define TAGID_LENGTH 17
char tagID[TAGID_LENGTH];

// deviceMac
#define MAC_LEN 18
char deviceMac[MAC_LEN];
int macPartToRead = 1;


void setup(){
  
  //Ethernet
  Ethernet.begin(termMac, termIP);

  // BT
  pinMode(BT_RESET_PIN, OUTPUT);
  Serial.begin(BT_BAUD);
  // reset BT
  digitalWrite(BT_RESET_PIN, HIGH);
  delay(1000);
  digitalWrite(BT_RESET_PIN, LOW);
  
  //logger
  pinMode(RX, INPUT);
  pinMode(TX, OUTPUT);
  logger.begin(BT_BAUD);

  // initial setting
  memset(lineBuffer, 0, LINEBUFFER_SIZE);
  memset(tagID,0,TAGID_LENGTH);
  memset(deviceMac,0,MAC_LEN);

  macPartToRead = 1;

  nextState(STATE_RFID_DISCONNECTED);
}

void loop(){

  // Check if Data is waiting
  lineAvailable = readLine(lineBuffer);

  switch(state){
  case STATE_RFID_DISCONNECTED:
    connectToRFID();
    break;
  case STATE_RFID_CONNECT:
    checkForRFIDReady();
    break;
  case STATE_RFID_TAGINV:
    lookForTags();
    break;
  case STATE_RFID_TAGINV_RESPONSE:
    readTagID();
    break;
  case STATE_RFID_TAG_DISCOVERED:
    getTagData();
    break;
  case STATE_RFID_DATARESPONSE:
    readBTMacAddress();
    break;
  case STATE_BT_DISCONNECTED:
    checkBTReady();    
    break;
  case STATE_BT_CONNECTDEVICE:
    connectBTDevice();
    break;
  case STATE_BT_CONNECTING:
    waitForConnectResponse();  
    break;
  case STATE_SERVER_CONNECT:
    connectToServer();
    break;
  case STATE_SERVER_SEND_REQUEST:
    sendServerRequest();
    break;
  case STATE_SERVER_READ_REQUEST:
    sendServerRequestToBT();
    break;
  case STATE_SERVER_CLOSE:
    disconnectFromServer();
    break;
  case STATE_BT_DISCONNECT:
    disconnectBT();
    break;
  }

  //Log("Current state: ");
  //Log(state);
  //Log("\r\n");

  if (lineAvailable == true) {
    clearBuffer();
  }

  delay(SYSTEM_LOOP_INTERVAL);
}

/***************/
/*  Functions */
/**************/

void checkForRFIDReady(){
  if(lineAvailable && isEqual("OK!",lineBuffer)){
    // get rid of all pending responses of the RFID reader
    clearReaderBuffer();
    nextState(STATE_RFID_TAGINV);
  }
}

void lookForTags(){
  rfidCommand("INV",true);
  nextState(STATE_RFID_TAGINV_RESPONSE);
}

void readTagID(){
  if(lineAvailable){
    if(isEqual("E",lineBuffer)){
      extractTagID(lineBuffer,lineBufferLength);
      Log("Tag ID: ");
      Log(tagID);
      Log("\r\n");
      clearReaderBuffer();
      nextState(STATE_RFID_TAG_DISCOVERED);
    }
    else{
      nextState(STATE_RFID_TAGINV);
    }
  }
}

void getTagData(){
  //write data to tag
  //rfidCommand("REQ 2221",false);
  //rfidCommand(tagID,false);
  //rfidCommand("0134159E7D CRC",true); //first bloc
  //rfidCommand("02268C0000 CRC",true); //second bolc

  // read data from Tag (BT Mac from client)
  rfidCommand("REQ 2220",false);
  rfidCommand(tagID,false);
  if(macPartToRead == 1){
    // read first Part of tagData
    rfidCommand("01 CRC",true);
    memset(deviceMac,0,MAC_LEN);
  }
  else{      
    // read second Part of tagData
    rfidCommand("02 CRC",true);
  }
  nextState(STATE_RFID_DATARESPONSE);
}

void readBTMacAddress(){
  if(lineAvailable && isEqual("00", lineBuffer)){
    //Log(lineBuffer);
    //Log("\r\n");
    int macPos = 0;
    int num = 10;
    if(macPartToRead == 2){
      macPos = 12;
      num = 6;
    }
    for(int pos = 2; pos < num; pos++){
      deviceMac[macPos++] = lineBuffer[pos];
      if((pos+1)%2 == 0){
        deviceMac[macPos++] = ':';
      }
    }
    if(macPartToRead == 2){
      deviceMac[17] = '\0';
      macPartToRead = 1;
      Log("Device Mac: ");
      Log(deviceMac);
      Log("\r\n");
      nextState(STATE_BT_DISCONNECTED);
    }
    else{
      macPartToRead = 2;
      nextState(STATE_RFID_TAG_DISCOVERED);
    }
    clearReaderBuffer();
  }
}

void checkBTReady(){
  // Wait for Ready from BT
  if ((lineAvailable && isEqual("READY.", lineBuffer))) {
    // Switch state to BT ready
    btReady = true;
    
  }
  if(btReady == true){
    clearSerialBuffer();
    nextState(STATE_BT_CONNECTDEVICE);
  }
}

void connectBTDevice(){
  //Serial.print("\r\n");
  btCommand("CALL ",false);
  for(int pos = 0; pos < MAC_LEN-1; pos++){
    btCommand(deviceMac[pos]);
  }
  btCommand(" 11 HID",true);
  nextState(STATE_BT_CONNECTING);
}

void waitForConnectResponse(){
  if (lineAvailable) {
    // The CALL command is emmited after the command is send
    if (isEqual("CALL", lineBuffer)) {
        // Nothing to do here
    }
    else if (isEqual("CONNECT", lineBuffer)) {
        // The devices conected successfully
        delay(3000);
        Log("Bluetooth connected.\r\n");       
        nextState(STATE_SERVER_CONNECT);
    }
    else if (isEqual("NO CARRIER", lineBuffer)) {
        delay(3000);
        Log("Bluetooth not connected. No Carrier.\r\n");
        nextState(STATE_RFID_TAGINV);
    }
  }
}

void connectToServer(){
  if(!terminal_Server.connected()){
    Log("Connect to Server...\r\n");
    if(terminal_Server.connect()){
      nextState(STATE_SERVER_SEND_REQUEST);
    }else{
      Log("Connection to server failed!\r\n");
      nextState(STATE_SERVER_CLOSE);
    }
  }
}

void sendServerRequest(){
  serverCommand(SERVER_GET_COMMAND,false);
  serverCommand(tagID,true);
  nextState(STATE_SERVER_READ_REQUEST);
}

void sendServerRequestToBT(){
  if(lineAvailable){
    for(int pos = 0; pos < lineBufferLength; pos++){
      char input = lineBuffer[pos];
      if(input != TRANSMISSON_END){
        sendCharToBTDevice(input);
      }else{
        delay(1000);
        nextState(STATE_SERVER_CLOSE);
      }
    }
  }
}

void disconnectFromServer(){
  terminal_Server.flush();
  terminal_Server.stop();
  delay(DISCONNECT_WAIT);
  nextState(STATE_BT_DISCONNECT);
}

void disconnectBT(){
  // back to command mode of BT module
  delay(1000);
  for(int i = 0; i < 3; i++){
    btCommand('+');
  }
  delay(2000);
  // kill connection
  btCommand("KILL ",false);
  for(int pos = 0; pos < MAC_LEN-1; pos++){
    btCommand(deviceMac[pos]);
  }
  btCommand("",true);
  delay(DISCONNECT_WAIT);
  nextState(STATE_RFID_TAGINV);
}

void btCommand(char* command, boolean closeCMD){
  Log(command);
  Serial.print(command);
  if(closeCMD == true){
    Log("\r\n");
    Serial.print("\r\n");
    delay(BT_COMMAND_WAIT);
  }
}

void serverCommand(char* command, boolean closeCMD){
  Log(command);
  terminal_Server.print(command);
  if(closeCMD == true){
    Log("\r\n");
    terminal_Server.print("\r\n");
    delay(SERVER_COMMAND_WAIT);
  }
}

void sendCharToBTDevice(char charByte){
  Log(charByte);
  Serial.print(charByte, BYTE);
  delay(BT_DATA_SEND_DELAY);
}

void btCommand(char commandChar){
  Log(commandChar);
  Serial.print(commandChar);
  delay(BT_DATA_SEND_DELAY);
}

void rfidCommand(char* command, boolean closeCMD){
  Log(command);
  terminal_RFID.print(command);
  if(closeCMD == true){
    Log("\r\n");
    terminal_RFID.print("\r");
    delay(RFID_COMMAND_WAIT);
  }
}

void clearBuffer(){
  memset(lineBuffer, 0, LINEBUFFER_SIZE);
  lineBufferLength = 0;
}

void clearReaderBuffer(){
  while(terminal_RFID.available()){
    terminal_RFID.read();
  }
  clearBuffer();
}

void clearSerialBuffer(){
  while(Serial.available()){
    Serial.read();
  }
  clearBuffer();
}

void connectToRFID(){
  if(!terminal_RFID.connected()){
    Log("Connecting to RFID reader...\r\n");
    if(terminal_RFID.connect()){
      Log("Conected!\r\n");
      Log("Initialize reader...\r\n");
      rfidCommand("RST",true);
      delay(1000);
      rfidCommand("MOD 156",true);
      rfidCommand("STT T1 350",true);
      rfidCommand("STT T2 0",true);
      rfidCommand("STT TW 350",true);
      rfidCommand("SRI SS 100",true);
      Log("Initialization done.\r\n");
      nextState(STATE_RFID_CONNECT);
    }
    else{
      Log("Connection faied!\r\n");
      nextState(STATE_RFID_DISCONNECTED);
    }
  }
  delay(1000);
}

void disconnectFromRFID(){
  if(terminal_RFID.connected()){
    Log("Disconnecting from RFID reader...\r\n");
    terminal_RFID.stop();
    nextState(STATE_RFID_DISCONNECTED);
    Log("Disconnected.\r\n");
  }
}

void nextState(int newState){
  state = newState;
  if(state < STATE_BT_DISCONNECTED){
    currStream = RFID;
    //Log("Receiving response from RFID Reader\r\n");
  }
  else if(state < STATE_SERVER_CONNECT){
    currStream = BT;
    //Log("Receiving response from Bluetooth\r\n");
  }else{
    currStream = SERVER;
    //Log("Receiving response from Server\r\n");
  }
}

/**
 * Read all waiting data from the buffer (non blocking)
 * and return true if received data block is complete
 * @param buffer Buffer to write data to
 * @return true if receive was complete
 */
boolean readLine(char* buffer)
{
  int numBytes = 0;
  int inputChar = '\n';

  switch(currStream){
  case RFID:
    numBytes = terminal_RFID.available();
    if(numBytes == 0){
      return false;
    }
    inputChar = terminal_RFID.read();
    break;
  case BT:
    numBytes = Serial.available();
    if(numBytes == 0){
      return false;
    }
    inputChar = Serial.read();
    break;
  case SERVER:
    numBytes = terminal_Server.available();
    if(numBytes == 0){
      return false;
    }
    inputChar = terminal_Server.read();
    break;
  }

  if (numBytes > 0) {
    // Read char        
    // Check if transmission was completed
    if (inputChar == '\r') {
      //Log(buffer);
      //Log("\r\n");
      return true;
    }
    else if(inputChar == '\n'){
      return false;
    }
    else {
      buffer[lineBufferLength] = inputChar;
      lineBufferLength++;
      buffer[lineBufferLength] = '\0';
    }
  }

  return false;
}

/**
 * Check if the two strings are equal
 * @param s1, s2 Strings to compare
 * @return true if the strings are equal, else false
 */
boolean isEqual(char* s1, char* s2) {
  unsigned int position = 0;
  while(s1[position] != '\0') {
    if (s1[position] != s2[position]) {
      return false; 
    }
    else {
      position++;
    }
  }

  return true;
}

void extractTagID(char* buffer, int len){
  for(int pos = 0; pos < len; pos++){
    tagID[pos] = buffer[pos];
  }
}

// logging functions

void Log(char* text){
  if(DEBUG == 1){
    //Serial.print(text);
    logger.print(text);
  }
}

void Log(char ch){
  if(DEBUG == 1){
    //Serial.print(ch);
    logger.print(ch);
  }
}


