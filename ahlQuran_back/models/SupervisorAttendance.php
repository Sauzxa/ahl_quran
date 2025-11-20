<?php
require_once '../../db.php';

class SupervisorAttendance
{

    protected static $tableName = 'supervisor_attendance';

    public $supervisor_id;
    public $attendance_date;
    public $attendance_status;
    public $check_in_time;
    public $check_out_time;

    public function __construct(array $data = [])
    {
        foreach ($data as $key => $value) {
            if (property_exists($this, $key)) {
                $this->$key = $value;
            }
        }
    }

    // Create new attendance record
    public static function create(DB $db, array $data): self
    {
        $conn = $db->getConnection();

        $columns = array_keys($data);
        $placeholders = array_fill(0, count($columns), '?');

        // Determine types
        $types = '';
        foreach ($columns as $col) {
            if ($col === 'supervisor_id') {
                $types .= 'i';
            } else {
                $types .= 's'; // strings for dates, status, times
            }
        }

        $sql = "INSERT INTO " . self::$tableName . " (" . implode(', ', $columns) . ") VALUES (" . implode(', ', $placeholders) . ")";
        $stmt = $conn->prepare($sql);
        if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);

        $stmt->bind_param($types, ...array_values($data));
        $stmt->execute();

        return new self($data);
    }

    // Get one record by composite key
    public static function get(DB $db, int $supervisor_id, string $attendance_date): ?self
    {
        $conn = $db->getConnection();
        $sql = "SELECT * FROM " . self::$tableName . " WHERE supervisor_id = ? AND attendance_date = ?";
        $stmt = $conn->prepare($sql);
        if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);

        $stmt->bind_param('is', $supervisor_id, $attendance_date);
        $stmt->execute();

        $result = $stmt->get_result();
        $row = $result->fetch_assoc();

        return $row ? new self($row) : null;
    }

    // Get all records
    public static function getAll(DB $db): array
    {
        $conn = $db->getConnection();
        $sql = "SELECT * FROM " . self::$tableName;
        $stmt = $conn->prepare($sql);
        if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);

        $stmt->execute();
        $result = $stmt->get_result();

        $records = [];
        while ($row = $result->fetch_assoc()) {
            $records[] = new self($row);
        }
        return $records;
    }
    // Get all records for a specific supervisor_id
    public static function getBySupervisorId(DB $db, int $supervisor_id): array
    {
        $conn = $db->getConnection();
        $sql = "SELECT * FROM " . self::$tableName . " WHERE supervisor_id = ?";
        $stmt = $conn->prepare($sql);
        if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
        $stmt->bind_param('i', $supervisor_id);
        $stmt->execute();
        $result = $stmt->get_result();

        $records = [];
        while ($row = $result->fetch_assoc()) {
            $records[] = new self($row);
        }
        return $records;
    }

    // Get all records for a specific attendance_date
    public static function getByDate(DB $db, string $attendance_date): array
    {
        $conn = $db->getConnection();
        $sql = "SELECT * FROM " . self::$tableName . " WHERE attendance_date = ?";
        $stmt = $conn->prepare($sql);
        if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
        $stmt->bind_param('s', $attendance_date);
        $stmt->execute();
        $result = $stmt->get_result();

        $records = [];
        while ($row = $result->fetch_assoc()) {
            $records[] = new self($row);
        }
        return $records;
    }

    // Update record by composite key
    public function update(DB $db): bool
    {
        $conn = $db->getConnection();

        $fields = get_object_vars($this);

        $supervisor_id = $fields['supervisor_id'];
        $attendance_date = $fields['attendance_date'];

        // Remove PK fields from update set
        unset($fields['supervisor_id'], $fields['attendance_date']);

        $sets = [];
        $types = '';
        $values = [];

        foreach ($fields as $key => $value) {
            $sets[] = "$key = ?";
            if ($key === 'supervisor_id') {
                $types .= 'i';
            } else {
                $types .= 's';
            }
            $values[] = $value;
        }

        $types .= 'i'; // for supervisor_id in WHERE
        $types .= 's'; // for attendance_date in WHERE
        $values[] = $supervisor_id;
        $values[] = $attendance_date;

        $sql = "UPDATE " . self::$tableName . " SET " . implode(', ', $sets) . " WHERE supervisor_id = ? AND attendance_date = ?";
        $stmt = $conn->prepare($sql);
        if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);

        $stmt->bind_param($types, ...$values);
        return $stmt->execute();
    }

    // Delete record by composite key
    public function delete(DB $db): bool
    {
        $conn = $db->getConnection();

        $supervisor_id = $this->supervisor_id;
        $attendance_date = $this->attendance_date;

        $sql = "DELETE FROM " . self::$tableName . " WHERE supervisor_id = ? AND attendance_date = ?";
        $stmt = $conn->prepare($sql);
        if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);

        $stmt->bind_param('is', $supervisor_id, $attendance_date);
        return $stmt->execute();
    }
}
