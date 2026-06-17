# Lean Audit Report

## Slug
iter051

## Iteration
051

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: 0 (the `sorry` on `genericFlatness` is honest, not an excuse)
- **notes**:
  - **Line 1949–1964 — stale section docstring for `genericFlatnessAlgebraic`.**
    The `/-! ## Generic flatness, algebraic form …-/` section header says
    "**Surviving residue** (`sorry` this iter): when `M` is finite over the
    finite-type algebra `B` but not module-finite over `A`, the genuine §4
    dévissage is required … the polynomial-ring core is the precise piece
    Mathlib does not yet supply."  However, `genericFlatnessAlgebraic` (lines
    1982–2142) is **axiom-clean**: the dévissage, Noether normalisation (L4),
    and polynomial core (L5) are all proved in preceding sections.  The docstring
    was accurate for an earlier iter and was never updated.  Future readers or
    agents will assume work remains when it does not.  **Severity: major.**
  - **Lines 540, 654 — stale iter-number references.**  Inline comments say
    "iter-018 foundation" and "L4 was closed iter-021."  These are harmless
    historical annotations but accumulate noise over time.  **Severity: minor.**
  - **Line 1358 — `@[reducible] def pullbackModuleAddEquiv`.**  The `@[reducible]`
    attribute makes the Module-structure definition transparent to the elaborator.
    This is deliberate (needed for instance synthesis in the subsequent torsion
    reindex, confirmed by use at line 1689), but `@[reducible]` on anything
    carrying `Module` instances carries a future risk of transparent-def blowups.
    Acceptable here given the nearby `synthInstance.maxHeartbeats` headroom, but
    worth noting.  **Severity: minor.**
  - **`set_option maxHeartbeats` usage (lines 483–485, 1462–1465, 1821–1822, 1966,
    2593):** all five settings have inline comments explaining the elaboration or
    instance-search bottleneck.  The values (400 k – 4 000 k heartbeats) are
    specific to known-heavy steps (stacked `Away` localisation chains, Nagata
    transform assembly).  No unexplained defaults.  **No issue.**
  - **`private` markings:** all private declarations in the `NagataNormalization`
    section (`T1`, `T`, `t1_comp_t1_neg`, `sum_r_mul_ne`, `degreeOf_zero_t`,
    `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`,
    `finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`) are correctly scoped.
    **No issue.**
  - **`erw` usage:** none visible in this file.  **No issue.**
  - **`genericFlatness := sorry` (line 2805):** an honest `sorry` on a load-bearing
    theorem.  The body is preceded by 120 lines of correct, detailed explanation:
    G1 is now axiom-clean (landed this iter), G3 (flat-locality assembly) remains
    open.  The sorry is not evasive, but it is a `sorry` on a substantive claim.
    Per auditor rules → **must-fix-this-iter** (see below).
  - **New decls — genuineness check:**
    - `module_finite_of_ringEquiv_semilinear` (2573–2591): genuine.  Transfers
      finiteness via a ring iso + semilinear additive equiv.  Proof by span
      induction using `he : e (a • x) = σ a • e x`.  Correct, non-trivial,
      Mathlib-absent.
    - `gf_qcoh_finite_sections_of_genSections` (2612–2661): genuine.  49-line
      proof assembling QUOT QC-pullback, `GeneratingSections.map` twice,
      `tildeFinsupp`, `epi_comp'`, and the section comparison semilinear iso.
      Correct.  The `epi_comp' inferInstance σ'.epi` pattern matches the
      known gotcha (epi_comp instance search trap) from memory.
    - `gf_qcoh_fintype_finite_sections` (2674–2682): genuine.  9-line clean
      assembly of G1 cover extraction + base case + locality glue.

---

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: 5 flagged (see dedicated section)
- **notes**:
  - **Lines 172–173 — partially stale scaffold NOTE on `glue`.**  The note says
    "the body and the **module-cocycle hypotheses on `g`** are still to be filled."
    However, the C1 hypothesis `_hC1` IS present in the signature (lines 190–191).
    C2 (transitivity cocycle) is deliberately absent per this iter's design.  The
    note is therefore misleading about what hypotheses are missing.  **Severity:
    major (excuse-comment pattern, partially stale).**
  - **`Scheme.Modules.glue := sorry` (line 193):** a `sorry` body on a load-bearing
    primitive.  All three downstream declarations (`universalQuotient`,
    `tautologicalQuotient`, `represents`) depend on it.  The sorry is honest and
    explicitly described; the C1 hypothesis is correctly stated (see below).
    Per auditor rules → **must-fix-this-iter.**
  - **C1-only signature soundness (directive check):**  The `_hC1` argument
    ```lean
    _hC1 : ∀ i, g i i = eqToIso (congrArg (fun φ => (Scheme.Modules.pullback φ).obj (M i))
        (show D.f i i = D.t i i ≫ D.f i i by rw [D.t_id i, Category.id_comp]))
    ```
    correctly encodes the self-identity condition C1 (the `i = i` transition iso is
    the canonical `eqToIso` induced by `D.t_id i : t i i = 𝟙`).  All downstream
    call sites are themselves `sorry`'d, so no caller silently omits C2 data;
    there is no hidden incorrect assumption.  The absence of C2 means the body of
    `glue` cannot be proved until C2 is added to the signature, but this is an
    acknowledged design choice this iter.  **No silent unsoundness now; C2 must be
    added before the body can close.**
  - **Scaffold sorry + NOTE on `universalQuotient` (line 207), `tautologicalQuotient`
    (line 214), `functor` (line 226), `represents` (line 237):** all four have
    `sorry` bodies and "NOTE (scaffold): … to be filled once glue lands" comments.
    These are honest (not hiding bugs), but they are load-bearing declarations with
    `sorry` bodies and "to be filled" comments — the precise excuse-comment pattern.
    **Severity: major** (downstream from `glue`; logically blocked, not sneaking
    anything through).
  - **New decls — genuineness check:**
    - `scalarEnd_one` (56–63): genuine.  Proof: `Equiv.symm_apply_eq` + `ext` +
      `map_one`.  Correct.
    - `scalarEnd_zero` (67–75): genuine.  Proof: `map_zero` + `rfl` for the
      zero-endomorphism application to `1`.  Correct.
    - `chartQuotientMap_ιFree` (103–140): genuine `private` lemma.  Proves the
      I-minor identity condition: the k-th I-indexed basis section maps through
      `chartQuotientMap` to the k-th standard basis section.  The proof correctly
      uses `universalMatrix_submatrix_self`, `scalarEnd_one`/`scalarEnd_zero`, and
      biproduct API.  One `erw` (see below).
    - `chartQuotientMap_epi` (145–158): genuine.  The chart quotient map is split
      epi: the section `freeMap (I-embedding)` is a right inverse, proved by
      checking on generators via `chartQuotientMap_ιFree`.  `IsSplitEpi.mk'` closes
      correctly.
  - **`erw [Sigma.ι_desc_assoc]` (line 121):**  A single `erw` in the private lemma
    `chartQuotientMap_ιFree`, needed because the `biproduct.isoCoproduct_inv`
    rewrite leaves a `Sigma.ι ≫ …` term whose coproduct-vs-biproduct definitional
    gap blocks `rw`.  Fragile but necessary; isolated to a private helper.
    **Severity: minor.**
  - **`set_option maxHeartbeats`:** no non-default settings in GrassmannianQuot.lean.
    The file is short (240 lines) and the proved content is syntactically lightweight.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:2805` — `genericFlatness :=
  sorry`.  Why must-fix: `sorry` on the geometric generic-flatness theorem, a
  load-bearing result.  The G1 prerequisite is now axiom-clean (this iter); the
  remaining blocker is G3 (flat-locality assembly).  The sorry is honest and
  documented, but a substantive claim with a `sorry` body is a must-fix per auditor
  rules.

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:193` — `Scheme.Modules.glue :=
  sorry`.  Why must-fix: `sorry` on the module-descent primitive that all downstream
  constructions (`universalQuotient`, `tautologicalQuotient`, `functor`, `represents`)
  scaffold from.  The C1 hypothesis is correctly stated; C2 (transitivity) must be
  added to the signature before the body can be proved.

---

## Major

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:1949–1964` — stale section
  docstring claiming `genericFlatnessAlgebraic` has a "Surviving residue (`sorry` this
  iter)".  The proof body at lines 1982–2142 is axiom-clean.  Misleads readers and
  agents into believing work remains when it does not.

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:172–173` — scaffold NOTE on `glue`
  says "module-cocycle hypotheses on `g` are still to be filled" but C1 IS present in
  the signature.  Stale/misleading about what is actually missing (C2 only).

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:205–237` — scaffold sorry + "NOTE
  (scaffold): … to be filled" excuse-comment pattern on `universalQuotient` (207),
  `tautologicalQuotient` (214), `functor` (226), `represents` (237).  All four are
  load-bearing declarations with `sorry` bodies; all are logically blocked on `glue`.

---

## Minor

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:540,654` — stale
  iter-number references ("iter-018 foundation", "L4 was closed iter-021") in inline
  comments.  Harmless but accumulate noise.

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:1358` — `@[reducible] def
  pullbackModuleAddEquiv`.  Deliberate design choice (needed for instance synthesis in
  the torsion reindex), but carries future risk of transparent-def elaboration blowup
  if the definition grows.  Currently acceptable with the nearby heartbeat headroom.

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:121` — `erw [Sigma.ι_desc_assoc]`
  in the private helper `chartQuotientMap_ιFree`.  One use, well-isolated, necessary
  due to biproduct/coproduct definitional gap.

---

## Excuse-comments (called out separately)

These documents the project (partially) lying to itself — either by claiming code is
incomplete when it is done, or by tagging incomplete code with "to be filled later"
disclaimers on load-bearing declarations:

- `FlatteningStratification.lean:1949–1964`: "**Surviving residue** (`sorry` this
  iter)" — attached to the `genericFlatnessAlgebraic` section heading, whose proof is
  axiom-clean.  Direction of lie: correct code labelled as sorry'd.  Severity:
  **major**.

- `GrassmannianQuot.lean:172–173`: "NOTE (scaffold): the body and the module-cocycle
  hypotheses on `g` are still to be filled" — attached to `Scheme.Modules.glue`
  (load-bearing).  C1 hypothesis IS present; only C2 absent.  Severity: **major**.

- `GrassmannianQuot.lean:205`: "NOTE (scaffold): rides on `Scheme.Modules.glue`; body
  to be filled once `glue` lands." — attached to `universalQuotient` (sorry'd,
  downstream of `glue`).  Severity: **major**.

- `GrassmannianQuot.lean:212–213`: same pattern on `tautologicalQuotient`.  Severity:
  **major**.

- `GrassmannianQuot.lean:224–226`: same pattern on `functor`.  Severity: **major**.

- `GrassmannianQuot.lean:232–234`: same pattern on `represents`.  Severity: **major**.

---

## Severity summary

- **must-fix-this-iter**: 2 — block downstream work until addressed: `genericFlatness`
  (G3 gap) and `Scheme.Modules.glue` (C2 + full cocycle proof).
- **major**: 7 — (1 stale docstring in FlatteningStratification; 1 stale NOTE + 5
  scaffold excuse-comments in GrassmannianQuot).
- **minor**: 3 — (2 stale iter refs; 1 `@[reducible]`; 1 `erw`).
- **excuse-comments**: 6 — counted above; 2 also counted under must-fix (via their
  sorry bodies), 4 counted under major.

**Overall verdict:** The two files are in good shape for iter-051 — the new declarations
(`module_finite_of_ringEquiv_semilinear`, `gf_qcoh_finite_sections_of_genSections`,
`gf_qcoh_fintype_finite_sections`, `scalarEnd_one/zero`, `chartQuotientMap_ιFree/epi`)
are all genuine, correctly proved, and axiom-clean — but `genericFlatness` and
`Scheme.Modules.glue` carry honest-but-blocking `sorry` bodies on load-bearing claims
that require addressing before the respective arcs can close.
