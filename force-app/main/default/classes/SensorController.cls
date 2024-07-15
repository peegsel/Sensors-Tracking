public with sharing class SensorController {
  @AuraEnabled(cacheable=true)
  public static List<Sensor__c> getSensors() {
    return [SELECT Id, Name FROM Sensor__c];
  }

  @AuraEnabled(cacheable=true)
  public static List<Sensor_Event__c> getSensorEvents(Id sensorId) {
    return [
      SELECT Id, Name, x__c, y__c, z__c, Modules_Vector_Length__c
      FROM Sensor_Event__c
      WHERE Sensor__c = :sensorId
    ];
  }

  @AuraEnabled
  public static void updateSensorEvent(Sensor_Event__c event) {
    update event;
  }

  public static Sensor__c getSensorByName(String sensorId) {
    List<Sensor__c> sensors = [
      SELECT Id, Name
      FROM Sensor__c
      WHERE Name = :sensorId
      LIMIT 1
    ];
    return sensors.isEmpty() ? null : sensors[0];
  }
}
