Read-only review complete; no files edited.

- `lem:milne-5-10`: faithful and merits `\leanok`. The bound tensor and sheaf-evaluation declarations cover both clauses, with slightly greater generality.
- `lem:milne-5-11`: partial mismatch; does not merit `\leanok`. The declaration proves only the finite-target local Nakayama core, not localization over arbitrary maximal ideals or either sheaf conclusion. Its proof also lacks `\uses{lem:milne-5-8}`.
- `lem:milne-index-determinant`: exact match; existing `\leanok` is justified.

Intentionally leave unbound:

- All seven adjunction helpers from `ade933ac2c`.
- `surjective_iff_surjective_residue` from `1e9ba8973e`.
- The injective intermediate `natCard_quotient_range_eq_natAbs_det` from `363fbbc189`.

Verification: `horizon check MilneLib` passed, 3139 jobs.
