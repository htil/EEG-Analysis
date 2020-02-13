const csv = require("csv-parser");
const fs = require("fs");
let events = [];
let results = [];
let firstSignalTime = null;
const signalFile = "original_gtec_data/p1.csv";
const eventFile = "original_events/p1_events.csv";
const latencyEventFileName = "raw/p1.txt";
let fileString = "latency\ttype\tposition\n";
let type = "HV";
//1542656253328 last events
// 1542655442269

const getDiff = (firstTime, time) => {
  return (time - firstTime) / 1000;
};

const init = () => {
  getLatency(signalFile, eventFile);
};

const getLatency = (signals, events) => {
  fs.createReadStream(signals)
    .pipe(csv())
    .on("data", data => {
      results.push(data);
    })
    .on("end", () => {
      firstSignalTime = parseInt(results[0].time);
      getEventTime(events, firstSignalTime);
    });
};

const getEventTime = (file, firstTime) => {
  fs.createReadStream(file)
    .pipe(csv())
    .on("data", data => {
      time = parseInt(data.time);
      let latency = getDiff(firstTime, time);
      let type = data.type;
      events.push({ latency, type, position: data.value });
    })
    .on("end", () => {
      createFile();
    });
};

const createFile = () => {
  for (event in events) {
    console.log(events[event]);
    let row =
      events[event].latency +
      "\t" +
      events[event].type +
      "\t" +
      events[event].position +
      "\n";
    fileString += row;
  }

  fs.writeFile(latencyEventFileName, fileString, "ascii", res => {
    console.log(res);
  });
};

getLatency(signalFile, eventFile);
