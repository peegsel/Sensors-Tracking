import { LightningElement, wire, track } from "lwc";
import getSensors from "@salesforce/apex/SensorController.getSensors";

export default class SensorList extends LightningElement {
  @track sensors = [];
  @track selectedSensor = "";
  @track selectedSensorMaxVectorLength;

  @wire(getSensors)
  wiredSensors({ error, data }) {
    if (data) {
      this.sensors = data.map((sensor) => ({
        label: sensor.Name,
        value: sensor.Id,
        maxVectorLength: sensor.Max_Vectors_Length__c
      }));
    } else if (error) {
      this.sensors = [];
    }
  }

  handleChange(event) {
    const selectedOption = this.sensors.find(
      (sensor) => sensor.value === event.detail.value
    );
    this.selectedSensor = selectedOption.value;
    this.selectedSensorMaxVectorLength = selectedOption.maxVectorLength;
  }

  get sensorOptions() {
    return this.sensors.map((sensor) => ({
      label: sensor.label,
      value: sensor.value
    }));
  }
}
