# lean-auditor directive — iter-041

Audit the following Lean files as Lean (no strategy bias):

- `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`
- `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

Both received prover work this iteration.

## Focus areas

- **QuotScheme.lean** — 7 new non-private declarations were added near the file tail (lines ~2027–2280):
  `image_basicOpen_of_affine`, `compositeBasicOpenImmersion_image_basicOpen`, `image_basicOpen_eq_inf`,
  `section_localization_hfr_aux`, `section_localization_hfr_basicOpen`, `isLocalizedModule_basicOpen_descent`,
  `isIso_fromTildeΓ_of_isQuasicoherent`. Pay attention to:
  - the multiple `set_option maxHeartbeats` (up to 1600000) blocks — are they justified or masking a fragile proof?
  - `section_localization_hfr_aux` uses an OPAQUE `j` hypothesis as a load-bearing performance device; check
    the wrapper `section_localization_hfr_basicOpen` instantiates it honestly (no hidden defeq abuse).
  - any leftover scaffold / debug markers (a `test_sorry_marker` was used transiently mid-session and should be gone).
  - the 4 pre-existing protected scaffold `sorry`s at lines 126/165/201/228 are out of scope (frozen).
- **FlatBaseChange.lean** — one edit this iter: an in-proof Γ-collapse `simp` stage was added ahead of the
  remaining `sorry` in `base_change_mate_fstar_reindex_legs_conj` (~line 1757/1822). Check the added comment
  block is honest about the open sorry and does not cite a sorry-backed lemma as if proven.

## Output
Per-file checklist + flagged-issues block with severity. Read paths above directly.
