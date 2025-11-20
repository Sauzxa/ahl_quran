<?php 
    require_once '../../db.php';
    


    class StudentLectureAchievements {

		/**
		 * The name of the table in the database
		 */
		protected static $tableName = 'student_lecture_achievements';

		/** @var mixed $lecture_id */
		public $lecture_id;

		/** @var mixed $student_id */
		public $student_id;

		/** @var mixed $achievement_type */
		public $achievement_type;

		/** @var mixed $lecture_date */
		public $lecture_date;

		/** @var mixed $from_surah */
		public $from_surah;

		/** @var mixed $from_ayah */
		public $from_ayah;

		/** @var mixed $to_surah */
		public $to_surah;

		/** @var mixed $to_ayah */
		public $to_ayah;

		/** @var mixed $teacher_note */
		public $teacher_note;

		public function __construct(array $data = []) {
		    foreach ($data as $key => $value) {
		        if (property_exists($this, $key)) {
		            $this->$key = $value;
		        }
		    }
		}

		/** Insert a new record and return the new object. */
		public static function create(DB $db, array $data): self {
		    $conn = $db->getConnection();
		    $columns = array_keys($data);
		    $placeholders = array_fill(0, count($columns), '?');
		    $types = str_repeat('s', count($data));
		    $sql = "INSERT INTO " . self::$tableName .
		           " (" . implode(', ', $columns) . ") VALUES (" . implode(', ', $placeholders) . ")";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param($types, ...array_values($data));
		    $stmt->execute();
		    $data['student_lecture_achievements_id'] = $conn->insert_id;
		    return new self($data);
		}

		/** Find a record by primary key. */
		public static function get(DB $db, int $lecture_id , int $student_id ): ?self {
		    $conn = $db->getConnection();
		    $sql = "SELECT * FROM " . self::$tableName . " WHERE lecture_id = ? AND student_id = ?";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param('ii', $lecture_id, $student_id);
		    $stmt->execute();
		    $result = $stmt->get_result();
		    $row = $result->fetch_assoc();
		    return $row ? new self($row) : null;
		}

		/** Show all data. */
		public static function getAll(DB $db): array {
		    $conn = $db->getConnection();
		    $sql = "SELECT * FROM " . self::$tableName;
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->execute();
		    $result = $stmt->get_result();
		    $objects = [];
		    while ($row = $result->fetch_assoc()) {
		        $objects[] = new self($row);
		    }
		    return $objects;
		}

		/** Update this record in the database. */
		public function update(DB $db): bool {
		    $conn = $db->getConnection();
		    $fields = get_object_vars($this);
		    $lecture_id = $fields['lecture_id'];
		    unset($fields['lecture_id']);
			$student_id = $fields['student_id'];
		    unset($fields['student_id']);
		    $sets = array_map(fn($k) => "$k = ?", array_keys($fields));
		    $types = str_repeat('s', count($fields)) . 'i';
		    $values = array_values($fields);
		    $values[] = $lecture_id;
		    $values[] = $student_id;

		    $sql = "UPDATE " . self::$tableName .
		           " SET " . implode(', ', $sets) . " WHERE lecture_id = ? AND student_id = ?";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param($types, ...$values);
		    return $stmt->execute();
		}

		/** Delete this record from the database. */
		public function delete(DB $db): bool {
		    $conn = $db->getConnection();
		    $sql = "DELETE FROM " . self::$tableName . " WHERE lecture_id = ? AND student_id = ?";
		    $stmt = $conn->prepare($sql);
		    if (!$stmt) throw new \RuntimeException("Prepare failed: " . $conn->error);
		    $stmt->bind_param('ii',  $this->lecture_id, $this->student_id);
		    return $stmt->execute();
		}

}

