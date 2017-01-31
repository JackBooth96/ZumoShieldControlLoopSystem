int count = 0;
int G;
int K;

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
    
    delay(4);
    
  }

  AverageG = abs(AverageG/200);
  int Lbias = 0;
  delay(50);


  for (int count = 1; count <=  120; count++)
  {
      
  
      gyro.read();
  
      G5 = G4;
      G4 = G3;
      G3 = G2;
      G2 = G1;
      G1 = (int)gyro.g.z;
      G = ((G1 + G2 + G3 + G4 + G5)/5)+AverageG;
      Serial.println(G);
      K = (G/22);

      motors.setLeftSpeed(1.1827*(100) + K); 
      motors.setRightSpeed(100 - K);
      Serial.println(G);
  
      delay(80);
      
    }


  motors.setLeftSpeed(0); 
  motors.setRightSpeed(0);

  
  
}
