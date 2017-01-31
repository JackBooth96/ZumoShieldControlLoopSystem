int count = 0;
int G;
int vel1;
int vel2;
int G1 = 0;
int G2 = 0;
int G3 = 0;
int G4 = 0;
int G5 = 0;
int AverageG = 0;
float test = 0;
int turnoff = 0;

#include <Wire.h>
#include <L3G.h>
#include <LSM303.h>
#include <ZumoMotors.h>
#include <Pushbutton.h>

#define Button_PIN 12
#define LED_PIN  13


L3G gyro;
ZumoMotors motors;
Pushbutton button(ZUMO_BUTTON);
LSM303 compass;

void setup() {
  pinMode(LED_PIN, OUTPUT);
  pinMode(Button_PIN, OUTPUT);
  
  Serial.begin(9600);
  Wire.begin();
  
  compass.init();
  compass.enableDefault();
  
  compass.m_min = (LSM303::vector<int16_t>){-2124, -8606, -22336};
  compass.m_max = (LSM303::vector<int16_t>){+2666, -3025, -15634};

  if (!gyro.init())
  {
    Serial.println("Failed to autodetect gyro type!");
    while (1);
  }

  gyro.enableDefault();
}

void loop() {
  
  button.waitForButton();
  delay(1000);
  
  for (int count = 1; count <= 200; count++)
  {
    
    gyro.read();
    AverageG = AverageG + (int)gyro.g.z;
    
    delay(8);
    
  }

  AverageG = abs(AverageG/200);
  int Lbias = 15;
  delay(50);
  float velocity = 100;
  float ratio = 1.1827;

  for (int count = 1; count <= 100; count++)
  {
      
  
      gyro.read();
  
      G5 = G4;
      G4 = G3;
      G3 = G2;
      G2 = G1;
      G1 = (int)gyro.g.z;
      G = ((G1 + G2 + G3 + G4 + G5)/5)+AverageG;
      Serial.println(G);
      motors.setLeftSpeed(ratio * velocity); 
      motors.setRightSpeed(velocity);
      Serial.println(G);
  
      delay(20);
      
   }
  motors.setLeftSpeed(0); 
  motors.setRightSpeed(0);


  
  
}
