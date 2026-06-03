import { Temporal } from "@js-temporal/polyfill";
import type { Student } from "./models/student.model.ts";

const student: Student = {
id: "STU-001",
name: "Hana Tadesse",
enrollmentDate: Temporal.Now.instant(),
gpa:3.14,
};

console.log(student.gpa?.toFixed(2) ?? "Not yet graded");