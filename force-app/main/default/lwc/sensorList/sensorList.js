import { LightningElement, wire, track } from "lwc";
import getSensors from "@salesforce/apex/SensorController.getSensors";

export default class SensorList extends LightningElement {
  @track sensors = [];
  @track selectedSensor = "";

  @wire(getSensors)
  wiredSensors({ error, data }) {
    if (data) {
      this.sensors = data.map((sensor) => ({
        label: sensor.Name,
        value: sensor.Id
      }));
    } else if (error) {
      this.sensors = [];
    }
  }

  handleChange(event) {
    this.selectedSensor = event.detail.value;
  }

  get sensorOptions() {
    return this.sensors;
  }
}
