import { LightningElement, api, wire, track } from "lwc";
import getSensorEvents from "@salesforce/apex/SensorController.getSensorEvents";
import updateSensorEvent from "@salesforce/apex/SensorController.updateSensorEvent";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";

const columns = [
  { label: "Event Name", fieldName: "Name" },
  { label: "Modulus Vector Length", fieldName: "Modulus_Vector_Length__c" },
  { label: "X", fieldName: "x__c", type: "number", editable: true },
  { label: "Y", fieldName: "y__c", type: "number", editable: true },
  { label: "Z", fieldName: "z__c", type: "number", editable: true }
];

export default class SensorEvents extends LightningElement {
  @api sensorId;
  @api sensorMaxVectorLength;
  @track events = [];
  columns = columns;
  draftValues = [];

  @wire(getSensorEvents, { sensorId: "$sensorId" })
  wiredEvents({ error, data }) {
    if (data) {
      this.events = data;
    } else if (error) {
      this.events = [];
    }
  }

  handleSave(event) {
    const updatedFields = event.detail.draftValues;

    const promises = updatedFields.map((record) => {
      const fields = Object.assign({}, record);
      return updateSensorEvent({ event: fields });
    });

    Promise.all(promises)
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Sensor Events updated",
            variant: "success"
          })
        );
        this.draftValues = [];
        return refreshApex(this.wiredEvents);
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error updating or refreshing records",
            message: error.body.message,
            variant: "error"
          })
        );
      });
  }
}
