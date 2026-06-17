# Lean Audit Report

## Slug
iter022

## Iteration
022

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechAcyclic.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **Line 110** — `CechAcyclic.affine` has an honest `sorry`. Documented clearly in both the module docstring and the in-proof comment block (lines 80–109). The comment block is not an excuse-comment; it accurately lists what remains (L1 categorical bridge) without falsely claiming the proof is complete. No issue.
  - **Lines 1–27 (module docstring)** — Stale: describes the file as containing the single declaration `CechAcyclic.affine` with a `sorry` proof, referencing only `lem:cech_acyclic_affine`. The file now also proves `AwayComparison.*`, `CechLocalized.*`, `SectionCechModule.*`, `sectionCech_affine_vanishing`, and the full `SectionCechTilde` section — none of which are mentioned in the header. The header needs updating to reflect that substantial proved content now lives alongside the still-sorry `CechAcyclic.affine`.
  - **Line 97** — "it is now available as `CombinatorialCech.*`... the iter-011 prover was blocked on" — historical iteration reference in a proof-comment will rot. Minor staleness.
  - **Lines 1350 / 1472 (`set_option maxHeartbeats 800000 / 1000000`)** — Both raises in `section SectionCechTilde`. The comments accurately explain the cause: `IsLocalizedModule.ext` applied to terms involving `modulesSpecToSheaf` section types is defeq-intensive; `phi_naturality` feeds through the same types via `restr_bridge`. The `clear_value g` / opaque-`g` workaround in `phiL_naturality` (lines 1379–1392) is sound: `hg` captures the only property used (`tilde.toOpen_res` compatibility), `clear_value` prevents WHNF of the concrete restriction during `IsLocalizedModule.ext` without hiding any information from the proof. The axiom-clean certification confirms correctness. The raises are legitimate and well-documented. No 2000000 heartbeat raise is present (the directive anticipated one; it was not needed).
  - **Lines 1587–1605** — `sectionCech_homology_exact` and `sectionCech_affine_vanishing` are both `theorem`-level declarations with identical type signatures; the second delegates to the first by `:= sectionCech_homology_exact M s hs p hp`. One of these is redundant. Both are axiom-clean and the duplication causes no correctness harm, but the unexported intermediate (`sectionCech_homology_exact`) should be `private` or the two should be merged.
  - **Lines 1069–1072 (`spanIdx`)** — The comment "kept opaque so the spanning-element rewrite...": the word "opaque" here refers to *structural opacity of the term rewriter*, not the `opaque` Lean keyword. `spanIdx` is `private noncomputable def`, not `opaque`. The comment is slightly imprecise in terminology but the construct is correct — a `noncomputable def` whose definition is not syntactically visible at the call site prevents the rewrite engine from expanding `s (spanIdx s ρ)` prematurely, and `spanIdx_spec` carries the only needed fact. This is an acceptable pattern.
  - **`classical` at lines 1084, 1273, 1306** — All three are appropriate: line 1084 for `Finset`-spanning induction in `dDiff_exact`, lines 1273/1306 for `Finset.induction` and `Finset.sum_congr` over `Fin`-indexed types. No misuse.

---

### AlgebraicJacobian/Cohomology/FreePresheafComplex.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **Lines 10–31 (module docstring)** — Claims the file "owns" two declarations: `cechFreePresheafComplex` (built, axiom-clean) and `cechFreeComplex_quasiIso` (NOT present anywhere in the file). The honest explanation appears only in the trailing comment (lines 961–992), not in the module header. The file header gives the impression of a complete two-declaration file when one of the two named items is absent. This is a significant documentation overstatement.
  - **Lines 961–992 (trailing comment on `cechFreeEvalEngineIso`)** — This is an honest "not built" note. The text is explicit: "This is an all-or-nothing `def`, so it is NOT pinned with a `sorry` here." No `sorry`, no `opaque`, no disguised axiom/placeholder is present. The comment accurately describes the remaining differential comm-square step and the complete route to `cechFreeComplex_quasiIso`. This is the correct way to document a missing declaration.
  - **Lines 447–553 (`FreeCechEngine` namespace)** — Duplicates `CombinatorialCech` from `CechAcyclic.lean` (same `combDifferential`, `combHomotopy`, `combHomotopy_spec`, `combDifferential_comp`, `combDifferential_exact` proofs, identical structure). The comment at line 438 explains why: "`CombinatorialCech` declarations are `private` there, hence unavailable here." This is a necessary duplication given the current visibility choice, but it creates maintenance debt — if the combinatorial core changes, both copies must be updated in sync. The duplication is documented but not resolved.
  - **Line 756 (`by classical` in `cechFreeEvalDropZeros`)** — The `classical` is used to form a `dite` (decidable-if-then-else) on `V ≤ coverInterOpen 𝒰 σ` in the `hom` component of the iso. Both branches of `hom_inv_id` are handled with `dif_pos`/`dif_neg`; the `dif_neg` case correctly uses `(freeYonedaEval_isZero_of_not_le h).eq_zero_of_src _` to produce a `0` morphism out of a zero object. This is sound.
  - **`cechEngineComplex`, `cechEngineD_comp`, `cechEnginePrepend_spec`, `cechEngineD_exact`** (lines 879–959) — All four declarations are clean. `cechEngineComplex` is assembled from `ChainComplex.of` using the proved `d²=0` lemma, not hand-rolled. `cechEnginePrepend_spec` is the coproduct-level homotopy identity and its proof reuses `FreeCechEngine.cons_comp_succAbove_succ` and `FreeCechEngine.combSign_flip` correctly (no duplication there, only `FreeCechEngine.combDifferential_exact` logic is re-derived inline). `cechEngineD_exact` derives exactness via `ModuleCat.hom_*` unpacking of the homotopy identity; the chain is correct.
  - **`cechFreeEvalEngine_X` (lines 784–796)** — Object-level iso is assembled as a composite of `cechFreeEval_X ≪≫ cechFreeEvalDropZeros ≪≫ (Sigma.whiskerEquiv ...).symm`. The `(survivingEquiv 𝒰 V p τ).2` in the last component correctly feeds the subset proof to `freeYonedaEval_iso_of_le`. This is the "object half of the engine iso" and is correctly documented as such; the differential match is the explicitly acknowledged missing piece.

---

## Must-fix-this-iter

None. No `sorry` on load-bearing proved claims, no wrong definitions, no disguised axioms, no excuse-comments admitting incorrect code.

---

## Major

- `FreePresheafComplex.lean:10–31` — Module-level docstring lists `cechFreeComplex_quasiIso` as a declaration the file "owns" without noting it is absent. A reader of the file header will expect to find `cechFreeComplex_quasiIso` defined here; it is not. The honest explanation is deferred to the trailing comment at line 961. The header should either remove the claim or add a clear "(not yet built)" qualifier.

---

## Minor

- `CechAcyclic.lean:1–27` — Module docstring describes the file as if it contains only `CechAcyclic.affine` (with `sorry`). It now also contains `AwayComparison`, `CechLocalized`, `SectionCechModule`, `SectionCechBridge`, `SectionCechTilde`, and the proved `sectionCech_affine_vanishing`. The header is out of date and should be updated.

- `CechAcyclic.lean:97` — Historical "iter-011" reference inside the `CechAcyclic.affine` proof comment. Not harmful, will rot as iteration advances.

- `CechAcyclic.lean:1587–1605` — `sectionCech_homology_exact` and `sectionCech_affine_vanishing` are identical theorems; the second is a one-line alias for the first. The intermediate proof (`sectionCech_homology_exact`) should be `private` or the two collapsed.

- `CechAcyclic.lean:1350/1472` — Performance fragility: heartbeat raises of 2× and 2.5× default for two lemmas. No correctness issue (axiom-clean), but if `tilde`/`modulesSpecToSheaf` APIs change, these lemmas are at risk of new timeouts. The `clear_value g` workaround is sound and documented; flagged for awareness only.

- `FreePresheafComplex.lean:447–553` — `FreeCechEngine` duplicates `CombinatorialCech` from `CechAcyclic.lean`. Cause is `private` visibility of the latter; fix would be to make the shared combinatorial core non-private (possibly move to a shared file). Not a correctness issue, but a maintenance burden.

---

## Excuse-comments (always called out separately)

None found. All comments about missing or incomplete content are honest architectural notes, not admissions of wrong code.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (FreePresheafComplex.lean module docstring overstates file completeness)
- **minor**: 5 (stale headers, duplicate theorems/code, performance fragility, historical reference)
- **excuse-comments**: 0

**Overall verdict**: Both files are axiom-clean, contain no wrong definitions or disguised `sorry`s, and the new `SectionCechTilde` proofs and engine-complex declarations are sound; the sole notable issue is that the `FreePresheafComplex.lean` file header claims ownership of `cechFreeComplex_quasiIso` which is not yet built.
