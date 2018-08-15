import 'package:final_parola/events/date_time.dart';
import 'package:flutter/material.dart';

class EventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        elevation: 0.0,
        title: Text("Create Event"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidate: true,
          child: EventForm(),
        ),
      ),
    );
  }
}

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

//TODO: Finalize the UI for creating Events
//Implement BLoC pattern for this. this is a horrible code.
class _EventFormState extends State<EventForm> {
  int currentStep = 0;
  static TextEditingController eventName,
      eventDescription,
      eventDate,
      eventTime,
      beaconUUID,
      major,
      minor;
  List<Step> steps = [
    Step(
      state: StepState.editing,
      isActive: true,
      title: Text("Event Name"),
      subtitle: Text("Enter your Event Name"),
      content: TextFormField(
        initialValue: "",
        controller: eventName,
        decoration: InputDecoration(
          labelText: "Event Name",
        ),
        maxLength: 60,
      ),
    ),
    Step(
      state: StepState.editing,
      isActive: true,
      title: Text(""),
      subtitle: Text(""),
      content: TextFormField(
        initialValue: "",
        controller: eventDescription,
        decoration: InputDecoration(
          icon: Icon(Icons.text_fields),
          labelText: "Event Description",
        ),
        maxLength: 60,
      ),
    ),
    Step(
      state: StepState.editing,
      isActive: true,
      title: Text(""),
      subtitle: Text(""),
      content: TextFormField(
        initialValue: "",
        controller: eventDate,
        decoration: InputDecoration(
          labelText: "Event Date",
        ),
        maxLength: 60,
      ),
    ),
    Step(
        state: StepState.editing,
        isActive: true,
        title: Text("Event Location"),
        subtitle: Text(""),
        content: Text("")),
    Step(
      state: StepState.editing,
      isActive: true,
      title: Text(""),
      subtitle: Text(""),
      content: Column(children: [
        TextFormField(
          initialValue: "",
          controller: beaconUUID,
          decoration: InputDecoration(
            labelText: "Beacon UUID",
          ),
          maxLength: 60,
        ),
        TextFormField(
          initialValue: "",
          controller: minor,
          decoration: InputDecoration(
            labelText: "Minor",
          ),
          maxLength: 60,
        ),
        TextFormField(
          initialValue: "",
          controller: major,
          decoration: InputDecoration(
            labelText: "Major",
          ),
          maxLength: 60,
        ),
      ]),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stepper(
        steps: steps,
        currentStep: currentStep,
        onStepTapped: (step) {
          setState(() {
            currentStep = step;
          });
        },
        onStepCancel: () {
          setState(() {
            currentStep > 0 ? currentStep -= 1 : currentStep = 0;
          });
        },
        onStepContinue: () {
          setState(() {
            currentStep < steps.length - 1 ? currentStep += 1 : currentStep = 0;
          });
        },
      ),
    );
  }
}
