#include <NewSoftSerial.h>

#define RX 2
#define TX 3
#define BLUETOOTH_RESET 4

// Program state
#define STATE_START 0
#define STATE_BLUETOOTH_READY 1
#define STATE_BLUETOOTH_DISCONNECTED 2
#define STATE_BLUETOOTH_CALLED 3
#define STATE_BLUETOOTH_CONNECTED 4

#define LOOP_DELAY 1000

NewSoftSerial logger = NewSoftSerial(RX,TX);
int state = 0;

#define BLUETOOTH_SPEED 115200
#define LINEBUFFER_SIZE 255
#define BLUETOOTH_COMMAND_DELAY 50
char lineBuffer[LINEBUFFER_SIZE];
unsigned int lineBufferLength = 0;
boolean lineAvailable = false;

char* device = "34:15:9e:7d:26:8c"; // iPod LE17
//char* device = "c4:c2:03:dc:a7:9d"; //iPad Fashion

void setup(){
  
  pinMode(RX, INPUT);
  pinMode(TX, OUTPUT);
  pinMode(BLUETOOTH_RESET, OUTPUT);
  logger.begin(BLUETOOTH_SPEED);
   
  // Reset buffer
  memset(lineBuffer, 0, LINEBUFFER_SIZE);
  pinMode(BLUETOOTH_RESET, OUTPUT);
  
  // Open COM to BT module
  Serial.begin(BLUETOOTH_SPEED);
  
  //Sending Reset to BT
  digitalWrite(BLUETOOTH_RESET, HIGH);
  delay(1000);
  digitalWrite(BLUETOOTH_RESET, LOW);
   
  state = STATE_START;
}

void loop(){
  
   // Check if Bluetooth data is waiting
    lineAvailable = readLine(lineBuffer);
    
    switch (state) {
        case STATE_START: {
            startBT();
            break;
        }
        case STATE_BLUETOOTH_READY: {
            disconnectBT();
            break;
        }
        case STATE_BLUETOOTH_DISCONNECTED: {
            connectBT();
            break;
        }
        case STATE_BLUETOOTH_CALLED: {
            callBT();
            break;
        }
        case STATE_BLUETOOTH_CONNECTED: {
            sendData();
            break;
        }
        default:
            break;
    }
    
    if (lineAvailable == true) {
        memset(lineBuffer, 0, LINEBUFFER_SIZE);
        lineBufferLength = 0;
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
    if (Serial.available() > 0) {
        // Read char
        int inputChar = Serial.read();
        
        // Check if transmission was completed
        if (inputChar == '\r') {
            debug(buffer);
            return true;
        }else if(inputChar == '\n'){
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
 * Read a line of data with blocking
 * @param buffer Buffer to write data to
 */
unsigned int readLineBlocking(char* buffer) {
    unsigned int position = 0;
    while (Serial.available() > 0) {
        // Read char
        int inputChar = Serial.read();
        
        // Check if transmission was completed
        if (inputChar == '\r' || inputChar == '\n') {
            debug(buffer);
            return position;
        }
        else {
            buffer[position] = inputChar;
            position++;
            buffer[position] = '\0';
        }
    }
    
    return position;
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

/**
 * Waiting loop to check if BT has come up
 */
void startBT() {
    if (lineAvailable && isEqual("READY", lineBuffer)) {
        // Switch state to BT ready
        state = STATE_BLUETOOTH_READY;
    }
}

/**
 * Send disconnect to BT device to unbind from any 
 * prior connected device
 */
void disconnectBT() {  
    // Iterate through all available macs
    Serial.print("\r\n"); 
    Serial.print("KILL ");
    Serial.print(device);
    Serial.print("\r\n");
        
    // Wait for command
    delay(BLUETOOTH_COMMAND_DELAY);
  
    // Answer is not interesting for us
    // Switching to disconnected state
    state = STATE_BLUETOOTH_DISCONNECTED;
}

/*
 * Connect the BT device to one of the allowed mac adressed
 */
void connectBT() {
    
    Serial.print("\r\n"); 
    Serial.print("CALL ");
    Serial.print(device);
    Serial.print(" 11 HID\r\n");
        
    // Wait for command
    delay(BLUETOOTH_COMMAND_DELAY);
    
    state = STATE_BLUETOOTH_CALLED;
}

/**
 * Check if the called device was connected successfully
 */
void callBT() {
    if (!lineAvailable || lineBufferLength == 0) {
        return;
    }
    debug(lineBuffer);
    // The CALL command is emmited after the command is send
    if (isEqual("CALL", lineBuffer)) {
        // Nothing to do here
        return;
    }
    else if (isEqual("CONNECT", lineBuffer)) {
        // The devices conected successfully
        state = STATE_BLUETOOTH_CONNECTED;
    }
    else if (isEqual("NO CARRIER", lineBuffer)) {
        state = STATE_BLUETOOTH_DISCONNECTED;
    }
}

// PROTOCOL:
// a - sensor 1 "+" 
// b - sensor 2 "+" 
// c - sensor 1 "-"
// d - sensor 2 "-"
void sendData() {
  printToBT("Hallo iPod\r\n", 12);
  //state = STATE_BLUETOOTH_READY;
}

void printToBT(char* data, int len){
  for(int i = 0; i < len; i++){
    Serial.print(data[i]);
    delay(BLUETOOTH_COMMAND_DELAY);
  }
}

void debug(char* msg){
  logger.println(msg);
  delay(500);
}



