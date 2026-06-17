# Lean Audit Report

## Slug
iter025

## Iteration
025

## Scope
- files audited: 1 (per directive — `CechBridge.lean` only)
- files skipped (per directive): N/A (focused scope)

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/CechBridge.lean`

- **outdated comments**: 3 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (inconsistent heartbeat documentation)
- **excuse-comments**: none
- **notes**:
  - **Line 273** — Section header comment reads "`lem:injective_cech_acyclic`, gated on Lane-1's `cechFreeComplex_quasiIso`".  `injective_cech_acyclic` is now fully proved (lines 872–909); the "gated on Lane-1" label is stale.
  - **Lines 77–119** — Large "Planner strategy" comment block sitting between the module docstring and the first declaration.  The block prescribes a three-step approach ending with "`HomologicalComplex.Hom.isoOfComponents`"; the actual implementation at line 269 uses `(AlgebraicTopology.alternatingCofaceMapComplex Ab).mapIso` of a cosimplicial natural isomorphism — a different architectural route that does not use `isoOfComponents` at all.  The Key API bullet listing `HomologicalComplex.Hom.isoOfComponents` as the assembly combinator is factually wrong about the shipped code and will mislead a reader trying to understand or re-derive the proof.
  - **Line 357** — `sectionCechComplexMapOpIso` docstring says "once Lane 1 provides `QuasiIso (cechFreeComplexAug 𝒰)`".  `cechFreeComplex_quasiIso` is already imported and used at line 876; the future-tense is stale.
  - **Line 637** — `set_option maxHeartbeats 1600000 in` precedes `ses_cech_h1` with no explanatory inline comment.  Contrast: the analogous `set_option maxHeartbeats 2000000 in` at line 851 is immediately followed by `-- The op-transport assembly elaborates several nested functor-on-homological-complex coercions whose defeq checks exceed the default heartbeat budget.`  Inconsistent documentation of heartbeat exceptions; the reason for the `ses_cech_h1` bump is undocumented.
  - **Lines 851–853** — `set_option maxHeartbeats 2000000 in` on `injective_cech_acyclic` IS accompanied by a clear, accurate inline comment.  The 10× default bump is plausible given the nested `opFunctor` / `mapHomologicalComplex` / `complexShape.down.symm` coercion stack; no masking concern.
  - **Docstring bullets (lines 54, 60)** — Both `injective_cech_acyclic` and `ses_cech_h1` are now labelled "**proved**".  The only remaining "(planned)" entry (line 65) refers to `cech_eq_cohomology_of_basis` / `affine_serre_vanishing`, which are absent from the file — accurate.
  - **Axiom check** (via `lean_verify`): both `AlgebraicGeometry.injective_cech_acyclic` and `AlgebraicGeometry.ses_cech_h1` rely solely on `propext`, `Classical.choice`, `Quot.sound` — standard Lean 4 / Mathlib foundations.  No project-specific axioms, no `sorry`.
  - **No errors** (compiler diagnostics clean).
  - **No sorry / admit** anywhere in the file.
  - **No dead code** — every `private` helper (`restr_trans`, `restr_inj_of_eq`, `restr_op_unique`, `restr_g'_transport`, `fι_sectionCechFaceRestr`, `coverConst_iInf`, `coverPair_iInf`, `pair_comp_δ0`, `pair_comp_δ1`, `pi_mapIso_hom_eq`, `homCechSectionIsoApp_hom_π`, `freeYonedaHomAddEquiv_naturality`, `homCechCosimplicial_δ`, `homCechComplex_d_eq`) is consumed by at least one downstream declaration.

---

## Must-fix-this-iter

None.

---

## Major

- `CechBridge.lean:77–119` — Planner strategy comment prescribes `HomologicalComplex.Hom.isoOfComponents` as the assembly combinator; actual implementation uses `alternatingCofaceMapComplex.mapIso` of a cosimplicial natural isomorphism (line 269).  The Key API bullet explicitly listing `isoOfComponents` is factually wrong about the shipped proof and will mislead any reader cross-checking or modifying the code.  Should be removed or replaced with a post-hoc description of the cosimplicial route actually taken.

- `CechBridge.lean:273` — Section header still reads "`lem:injective_cech_acyclic`, gated on Lane-1's `cechFreeComplex_quasiIso`".  The theorem is proved and `cechFreeComplex_quasiIso` is live.  A reader scanning section headers for blocked work will be misled.

- `CechBridge.lean:357` — `sectionCechComplexMapOpIso` docstring reads "once Lane 1 provides `QuasiIso (cechFreeComplexAug 𝒰)`".  Lane 1 has landed; future-tense is stale.

---

## Minor

- `CechBridge.lean:637` — `set_option maxHeartbeats 1600000 in` on `ses_cech_h1` has no accompanying comment explaining why the default budget is insufficient for this proof, unlike the analogous bump at line 851 which has a clear justification.  Low-risk but inconsistent; future editors cannot easily assess whether the 8× budget is a permanent need or a temporary workaround.

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3 — stale planning notes and stale "gated" wording in comments/docstrings
- **minor**: 1 — undocumented heartbeat exception on `ses_cech_h1`
- **excuse-comments**: 0

Overall verdict: File is proof-correct and axiom-clean; the only issues are three stale comments (a superseded planning block, a "gated" label on a now-proved theorem, and a future-tense docstring sentence) plus one undocumented heartbeat bump — none of these affect correctness or block downstream work.
