@RestResource(urlMapping='/SensorData')
global with sharing class SensorDataService {
  global class SensorRequest {
    public String sensorId;
    public List<Vector> vectors;
  }

  global class Vector {
    public Decimal x;
    public Decimal y;
    public Decimal z;
  }

  @HttpPost
  global static String doPost(SensorRequest request) {
    if (
      request.sensorId == null ||
      request.vectors == null ||
      request.vectors.isEmpty()
    ) {
      return System.label.Invalid_request_data;
    }

    String sensorId = request.sensorId;
    List<Vector> vectors = request.vectors;
    Sensor__c sensor = SensorController.getSensorByName(sensorId);
    if (sensor == null) {
      sensor = new Sensor__c(Name = sensorId);
      insert sensor;
    }

    List<Sensor_Event__c> sensorEvents = new List<Sensor_Event__c>();
    for (Vector vector : vectors) {
      sensorEvents.add(
        new Sensor_Event__c(
          Sensor__c = sensor.Id,
          x__c = vector.x,
          y__c = vector.y,
          z__c = vector.z
        )
      );
    }

    if (!sensorEvents.isEmpty()) {
      insert sensorEvents;
    }

    return System.label.Sensor_data_processed_successfully;
  }
}
