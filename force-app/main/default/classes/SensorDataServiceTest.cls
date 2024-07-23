@isTest
private class SensorDataServiceTest {
  static final String testSensor = 'TestSensor';

  static SensorDataService.SensorRequest makeData() {
    SensorDataService.SensorRequest request = new SensorDataService.SensorRequest();
    request.sensorId = testSensor;
    request.vectors = new List<SensorDataService.Vector>();

    SensorDataService.Vector vector1 = new SensorDataService.Vector();
    vector1.x = 1.2;
    vector1.y = 2.3;
    vector1.z = 3.4;
    request.vectors.add(vector1);

    SensorDataService.Vector vector2 = new SensorDataService.Vector();
    vector2.x = 4.5;
    vector2.y = 5.6;
    vector2.z = 6.7;
    request.vectors.add(vector2);

    return request;
  }

  @isTest
  static void testDoPostWithValidData() {
    SensorDataService.SensorRequest request = SensorDataServiceTest.makeData();
    Test.startTest();
    String response = SensorDataService.doPost(request);
    Test.stopTest();

    Sensor__c sensor = SensorController.getSensorByName(testSensor);

    Assert.areEqual(System.label.Sensor_data_processed_successfully, response);
    Assert.isNotNull(sensor);
    Assert.areEqual(2, SensorController.getSensorEvents(sensor.Id).size());
  }

  @isTest
  static void testDoPostWithNullSensorId() {
    SensorDataService.SensorRequest request = SensorDataServiceTest.makeData();
    request.sensorId = null;

    Test.startTest();
    String response = SensorDataService.doPost(request);
    Test.stopTest();

    Assert.areEqual(System.label.Invalid_request_data, response);
  }

  @isTest
  static void testDoPostWithEmptyVectors() {
    SensorDataService.SensorRequest request = SensorDataServiceTest.makeData();
    request.vectors = new List<SensorDataService.Vector>();

    Test.startTest();
    String response = SensorDataService.doPost(request);
    Test.stopTest();

    Assert.areEqual(System.label.Invalid_request_data, response);
  }
}
