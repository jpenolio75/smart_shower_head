#include <stdio.h>
#include "ds18b20.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"


// Temp Sensors are on GPIO4
#define TEMP_BUS 4


DeviceAddress tempSensors[2];



void app_main(void){
    float cTemp,fTemp;

    ds18b20_init(TEMP_BUS);//initialize ds18b20

    ds18b20_setResolution(tempSensors,2,10);

   
    while (1) {
     
        cTemp = ds18b20_get_temp();
        fTemp = (cTemp*1.8) + 32;
        printf("Temperature: %0.1fC\n", cTemp);
        printf("Temperature: %0.1fF\n", fTemp);
        printf("\n");
        vTaskDelay(3000 / portTICK_PERIOD_MS);//print the temperature every 3 seconds
    }
}