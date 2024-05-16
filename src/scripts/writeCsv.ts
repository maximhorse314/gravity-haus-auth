import fs from 'fs';
import jsonToCsv from './jsonToCsv';

const writeCsv = (list, fileName) => {
  const csvData = jsonToCsv(list);
  fs.writeFile(fileName, csvData, 'utf8', () => {
    return;
  });
};

export default writeCsv;
