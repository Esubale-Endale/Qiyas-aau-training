import type { Temporal } from "@js-temporal/polyfill";

export interface Student {
  readonly id: string;
  name: string;
  enrollmentDate: Temporal.Instant;
  gpa?: number;
}
