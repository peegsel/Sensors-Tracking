@isTest
public with sharing class SensorControllerTest {
  static final String testSensorName1 = 'testSensor1';
  static final String testSensorName2 = 'testSensor2';
  static final String testX = 'testSensor3';

  @TestSetup
  static void setupTestData() {
    List<Sensor__c> sensors = new List<Sensor__c>{
      new Sensor__c(Name = testSensorName1),
      new Sensor__c(Name = testSensorName2)
    };
    insert sensors;

    List<Sensor_Event__c> events = new List<Sensor_Event__c>{
      new Sensor_Event__c(
        Sensor__c = sensors[0].Id,
        x__c = 5.6,
        y__c = 34,
        z__c = 4.3
      ),
      new Sensor_Event__c(Sensor__c = sensors[1].Id)
    };
    insert events;
  }

  @isTest
  static void testGetSensors() {
    Test.startTest();
    List<Sensor__c> sensors = SensorController.getSensors();
    Test.stopTest();

    Assert.areNotEqual(null, sensors, 'Sensors should not be null');
    Assert.areEqual(2, sensors.size(), 'There should be 2 sensors');
    Assert.areEqual(
      testSensorName1,
      sensors[0].Name,
      'The name of the first sensor should be testSensor1'
    );
    Assert.areEqual(
      testSensorName2,
      sensors[1].Name,
      'The name of the second sensor should be testSensor2'
    );
  }

  @isTest
  static void testUpdateSensorEvent() {
    List<Sensor_Event__c> events = [
      SELECT Id, x__c, y__c, z__c
      FROM Sensor_Event__c
    ];

    Sensor_Event__c eventToUpdate = events[0];
    eventToUpdate.x__c = 1;

    Test.startTest();
    SensorController.updateSensorEvent(eventToUpdate);
    Test.stopTest();

    Sensor_Event__c updatedEvent = [
      SELECT Id, x__c, y__c, z__c
      FROM Sensor_Event__c
      WHERE Id = :eventToUpdate.Id
    ];
    Assert.areEqual(
      1,
      updatedEvent.x__c,
      'The name of the second sensor should be updated to testSensor3'
    );
  }
}
