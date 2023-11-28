require('dotenv').config();
const express = require('express');
const facultiesController = require('./facultiesController');
const studentsController = require('./studentsController');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use('/faculties', facultiesController);
app.use('/students', studentsController);

app.listen(PORT, () => console.log(`App available on http://localhost:${PORT}`));