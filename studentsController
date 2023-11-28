const express = require('express');
const pool = require('./db');

const router = express.Router();

async function getStudentById(studentId) {
    const studentResult = await pool.query('SELECT * FROM student WHERE id = $1', [studentId]);
    return studentResult.rows.length > 0 ? studentResult.rows[0] : null;
}

async function getAttendedFaculties(studentId) {
    const facultiesResult = await pool.query(
        'SELECT faculty.* FROM faculty_student JOIN faculty ON faculty_student.faculty_id = faculty.id WHERE faculty_student.student_id = $1 ORDER BY id ASC',
        [studentId]
    );
    return facultiesResult.rows;
}

async function insertStudentIntoDatabase(studentData) {
    const studentResult = await pool.query(
        'INSERT INTO student (first_name, last_name, address, place, postal_code, date_of_birth, active) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
        Object.values(studentData)
    );
    return studentResult.rows[0];
}

async function insertStudentFaculties(studentId, facultyIds) {
    const facultyStudentValues = facultyIds.map(facultyId => [facultyId, studentId]);
    await pool.query(
        'INSERT INTO faculty_student (faculty_id, student_id) VALUES ' +
        facultyStudentValues.map((_, index) => `($${index * 2 + 1}, $${index * 2 + 2})`).join(', '),
        facultyStudentValues.flat()
    );
}

async function deleteStudentFaculties(studentId) {
    await pool.query('DELETE FROM faculty_student WHERE student_id = $1', [studentId]);
}

router.get('/', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM student ORDER BY id ASC');
        res.json(result.rows);
    } catch (error) {
        console.error('Error getting students:', error.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.get('/:id', async (req, res) => {
    const studentId = req.params.id;

    try {
        const student = await getStudentById(studentId);
        if (!student) {
            res.status(404).json({ error: 'Student not found' });
            return;
        }

        const attendedFaculties = await getAttendedFaculties(studentId);

        res.json({ student, attendedFaculties });
    } catch (error) {
        console.error('Error getting student by ID:', error.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.post('/', async (req, res) => {
    const { first_name, last_name, address, place, postal_code, date_of_birth, active, faculties } = req.body;

    try {
        if (faculties && faculties.length > 0) {
            const facultyCheckResult = await pool.query(
                'SELECT id FROM faculty WHERE id = ANY($1::int[])',
                [faculties]
            );
            const existingFacultyIds = facultyCheckResult.rows.map(row => row.id);
            const nonExistingFacultyIds = faculties.filter(id => !existingFacultyIds.includes(id));
            if (nonExistingFacultyIds.length > 0) {
                return res.status(400).json({ error: `Faculty IDs not found: ${nonExistingFacultyIds.join(', ')}` });
            }
            await insertStudentFaculties(student.id, faculties);
        }
        const studentData = { first_name, last_name, address, place, postal_code, date_of_birth, active };
        const student = await insertStudentIntoDatabase(studentData);
        res.json(student);
    } catch (error) {
        console.error('Error creating student:', error.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.put('/:id', async (req, res) => {
    const studentId = req.params.id;
    const { first_name, last_name, address, place, postal_code, date_of_birth, active, faculties } = req.body;

    try {
        if (faculties && faculties.length > 0) {
            const facultyCheckResult = await pool.query(
                'SELECT id FROM faculty WHERE id = ANY($1::int[])',
                [faculties]
            );
            const existingFacultyIds = facultyCheckResult.rows.map(row => row.id);
            const nonExistingFacultyIds = faculties.filter(id => !existingFacultyIds.includes(id));
            if (nonExistingFacultyIds.length > 0) {
                return res.status(400).json({ error: `Faculty IDs not found: ${nonExistingFacultyIds.join(', ')}` });
            }

            const currentFacultiesResult = await pool.query(
                'SELECT faculty_id FROM faculty_student WHERE student_id = $1',
                [studentId]
            );
            const currentFacultyIds = currentFacultiesResult.rows.map(row => row.faculty_id);
            const facultiesToRemove = currentFacultyIds.filter(id => !faculties.includes(id));
            const facultiesToAdd = faculties.filter(id => !currentFacultyIds.includes(id));
            if (facultiesToRemove.length > 0) {
                await pool.query(
                    'DELETE FROM faculty_student WHERE student_id = $1 AND faculty_id = ANY($2::int[])',
                    [studentId, facultiesToRemove]
                );
            }

            if (facultiesToAdd.length > 0) {
                await insertStudentFaculties(studentId, facultiesToAdd);
            }
        } else {
            await deleteStudentFaculties(studentId);
        }

        const result = await pool.query(
            'UPDATE student SET first_name = $1, last_name = $2, address = $3, place = $4, postal_code = $5, date_of_birth = $6, active = $7 WHERE id = $8 RETURNING *',
            [first_name, last_name, address, place, postal_code, date_of_birth, active, studentId]
        );
        if (result.rows.length === 0) {
            res.status(404).json({ error: 'Student not found' });
        }
        res.json(result.rows[0]);
    } catch (error) {
        console.error('Error updating student:', error.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.delete('/:id', async (req, res) => {
    const studentId = req.params.id;
    try {
        const result = await pool.query('DELETE FROM student WHERE id = $1 RETURNING *', [studentId]);
        if (result.rows.length === 0) {
            res.status(404).json({ error: 'Student not found' });
        }
        res.sendStatus(204);
    } catch (error) {
        console.error('Error deleting student:', error.message);
        res.status(500).json({ error: 'Internal server error' });
    }
});

module.exports = router;