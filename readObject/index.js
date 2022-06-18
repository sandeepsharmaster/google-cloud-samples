

'use strict';

const functions = require('@google-cloud/functions-framework');
const escapeHtml = require('escape-html');
  
exports.helloGCS = (file, context) => {
  console.log(`  Function Start : `);

  console.log(`  Event: ${context.eventId}`);
  console.log(`  Event Type: ${context.eventType}`);
  console.log(`  Bucket: ${file.bucket}`);
  console.log(`  File: ${file.name}`);
  console.log(`  Metageneration: ${file.metageneration}`);
  console.log(`  Created: ${file.timeCreated}`);
  console.log(`  Updated: ${file.updated}`);
  console.log(`  Data: ${file.data}`);
  console.log(`  Object: ${file.Object}`);
  console.log(`  Body: ${file.body}`);
  console.log(`  String: ${file.toString}`);

 // const storage = new Storage();
 // my_obj = storage.bucket(`${file.bucket}`).file(`${file.name}`).download();
 // console.log(my_obj);

  console.log(`  Function End : `);
};

