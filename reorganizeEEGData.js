const bci = require("bcijs");
const math = require("mathjs");
const fs = require("fs");

const directory = "original_gtec_data";
const outputDirectory = "raw/";

const reorganize = async (path, fileName) => {
  // Load in original data
  console.log(`Loading the original data file: ${fileName}`);

  let original = await bci.loadCSV(path);

  // Remove the header
  original.shift();

  // Reorganize so every channel is a row (16 channels)
  console.log("Reorganizing the file");
  let reorganized = Array(16)
    .fill()
    .map(() => []);

  original.forEach(row => {
    let channel = row[1];
    let value = row[2];

    reorganized[channel].push(value);
  });

  // Transpose so every channel is column
  reorganized = math.transpose(reorganized);

  // Save the file
  console.log("Saving the reorganized file");

  outputPath = `${outputDirectory}${fileName}`;
  await bci.saveCSV(reorganized, outputPath);
  console.log(reorganized);
  console.log("Done");
};

(async function() {
  // Loop through all the files in the temp directory
  fs.readdir(directory, function(err, files) {
    console.log(files);
    for (f in files) {
      eegFile = `${directory}/${files[f]}`;
      reorganize(eegFile, files[f]);
    }
  });
})().catch(error => console.error(error));
