<?php

require_once '../../models/SupervisorAttendance.php';
require_once '../../controllers/Controller.php';

class SupervisorAttendanceController extends Controller
{

    public static function getAll()
    {
        try {
            $records = SupervisorAttendance::getAll(self::$dbconnection);
            if (!$records) {
                self::sendResponse(404, ['error' => 'No supervisor attendance records found']);
            } else {
                self::sendResponse(200, $records);
            }
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function getBySupervisorAndDate(int $supervisor_id, string $date)
    {
        try {
            $record = SupervisorAttendance::get(self::$dbconnection, $supervisor_id, $date);
            if (!$record) {
                self::sendResponse(404, ['error' => 'No attendance record found']);
            } else {
                self::sendResponse(200, $record);
            }
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function save()
    {
        $data = self::getRequestBody();
        if (!$data) return;

        try {
            $record = SupervisorAttendance::create(self::$dbconnection, $data);
            self::sendResponse(201, $record);
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function getBySupervisorId(int $supervisor_id)
    {
        try {
            $records = SupervisorAttendance::getBySupervisorId(self::$dbconnection, $supervisor_id);
            if (empty($records)) {
                self::sendResponse(404, ['error' => 'No attendance records for this supervisor']);
            } else {
                self::sendResponse(200, $records);
            }
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }

    public static function getByDate(string $attendance_date)
    {
        try {
            $records = SupervisorAttendance::getByDate(self::$dbconnection, $attendance_date);
            if (empty($records)) {
                self::sendResponse(404, ['error' => 'No attendance records on this date']);
            } else {
                self::sendResponse(200, $records);
            }
        } catch (\Exception $e) {
            self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
        }
    }


    public static function update(int ...$id) {
    if (count($id) < 2) {
        self::sendResponse(400, ['error' => 'Missing supervisor_id or attendance_date']);
        return;
    }

    $supervisor_id = $id[0];
    $attendance_date = $id[1];

    $data = self::getRequestBody();
    if (!$data) return;

    try {
        $record = SupervisorAttendance::get(self::$dbconnection, $supervisor_id, $attendance_date);
        if (!$record) {
            self::sendResponse(404, ['error' => 'Attendance record not found']);
            return;
        }

        foreach ($data as $key => $value) {
            if (property_exists($record, $key)) {
                $record->$key = $value;
            }
        }

        if ($record->update(self::$dbconnection)) {
            self::sendResponse(200, $record);
        } else {
            self::sendResponse(500, ['error' => 'Update failed']);
        }
    } catch (\Exception $e) {
        self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
    }
}

public static function delete(int ...$id) {
    if (count($id) < 2) {
        self::sendResponse(400, ['error' => 'Missing supervisor_id or attendance_date']);
        return;
    }

    $supervisor_id = $id[0];
    $attendance_date = $id[1];

    try {
        $record = SupervisorAttendance::get(self::$dbconnection, $supervisor_id, $attendance_date);
        if (!$record) {
            self::sendResponse(404, ['error' => 'Attendance record not found']);
            return;
        }
        if ($record->delete(self::$dbconnection)) {
            self::sendResponse(200, ['message' => 'Record deleted']);
        } else {
            self::sendResponse(500, ['error' => 'Delete failed']);
        }
    } catch (\Exception $e) {
        self::sendResponse(500, ['error' => 'Server error: ' . $e->getMessage()]);
    }
}
}