const express = require('express');
const pool = require('./db');

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM faculty ORDER BY id ASC');
        res.json(result.rows);
    } catch (error) {
        console.error('Error getting faculties:', error.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.get('/:id', async (req, res) => {
    const facultyId = req.params.id;
    try {
        const facultyResult = await pool.query('SELECT * FROM faculty WHERE id = $1', [facultyId]);
        if (facultyResult.rows.length === 0) {
            res.status(404).json({ error: 'Faculty not found' });
            return;
        }
        const faculty = facultyResult.rows[0];

        const studentsResult = await pool.query(
            'SELECT student.* FROM faculty_student JOIN student ON faculty_student.student_id = student.id WHERE faculty_student.faculty_id = $1',
            [facultyId]
        );
        const attendingStudents = studentsResult.rows;

        res.json({ faculty, attendingStudents });
    } catch (error) {
        console.error('Error getting faculty by ID:', error.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.post('/', async (req, res) => {
    try {
        const { name, description, place, address } = req.body;
        const result = await pool.query(
            'INSERT INTO faculty (name, description, place, address) VALUES ($1, $2, $3, $4) RETURNING *',
            [name, description, place, address]
        );
        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error('Error creating faculty:', error.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.put('/:id', async (req, res) => {
    const facultyId = req.params.id;
    try {
        const { name, description, place, address } = req.body;
        const result = await pool.query(
            'UPDATE faculty SET name = $1, description = $2, place = $3, address = $4 WHERE id = $5 RETURNING *',
            [name, description, place, address, facultyId]
        );
        if (result.rows.length === 0) {
            res.status(404).json({ error: 'Faculty not found' });
        } else {
            res.json(result.rows[0]);
        }
    } catch (error) {
        console.error('Error updating faculty:', error.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.delete('/:id', async (req, res) => {
    const facultyId = req.params.id;
    try {
        const result = await pool.query('DELETE FROM faculty WHERE id = $1 RETURNING *', [facultyId]);
        if (result.rows.length === 0) {
            res.status(404).json({ error: 'Faculty not found' });
        } else {
            res.sendStatus(204);
        }
    } catch (error) {
        console.error('Error deleting faculty:', error.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;