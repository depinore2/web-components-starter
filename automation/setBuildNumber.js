// run this script prior to deployment.

const fs = require('fs');

const fileName = process.argv[2];
const buildNumber = process.argv[3];

fs.readFile(fileName, 'utf8', function(err, data) {
    fs.writeFile(
        fileName, 
        data.replace(/--buildNumber--/gi, buildNumber), 
        { encoding: 'utf8' },
        err => null
    );
});