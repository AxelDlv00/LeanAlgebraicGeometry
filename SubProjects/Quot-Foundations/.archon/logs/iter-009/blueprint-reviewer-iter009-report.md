# Blueprint Audit Report — iter009

**Slug:** iter009  
**Scope:** Whole-blueprint audit (six chapters)  
**Tools run:** `leandag build --json`, `leandag show isolated`, `archon blueprint-doctor --json`  
**Focus:** FBC route swap (FlatBaseChange + RegroupHelper), GF effort-break (FlatteningStratification), QUOT-A gate (QuotScheme), GrassmannianCells gate (`def:gr_transition`)

---

## Tool Summary

### `leandag build`

| Metric | Value |
|--------|-------|
| Blueprint nodes | 85 |
| Lean aux nodes | 1 |
| Proved (`\leanok`, no sorry) | 39 |
| Mathlib-OK (`\mathlibok`) | 13 |
| With sorry | 13 |
| Edges | 121 |
| Isolated nodes | 1 |
| `unknown_uses` | **0** — all `\uses{}` edges resolve |
| `conflicts` | **0** |
| `unmatched_lean` | 31 (13 mathlibok, 18 project stubs) |
| Effort done | 48 890 |
| Effort remaining (lower bound) | 60 012 |

### `leandag show isolated`

One isolated node: `lean:Alg…` (type `lean_aux`, no chapter, ∞ effort, 0 deps, 0 impact). This is a Lean-side stub in the `AlgebraicGeometry` namespace with no blueprint counterpart. Zero impact on any blueprint node. **Verdict: informational, no action.**

### `archon blueprint-doctor`

| Check | Result |
|-------|--------|
| Orphan chapters | 0 |
| Broken `\ref` / `\uses` / `\proves` | 0 |
| Malformed refs | 0 |
| `axiom` declarations | 0 |
| `archon:covers` problems | 0 |
| Labels defined | 115 |

**Full green pass.** All six chapters are present and included in `content.tex`.

---

## Chapter-by-Chapter Verdicts

---

### 1. `Cohomology_FlatBaseChange.tex`

```
complete: partial
correct: true
```

**Open obligation.** Exactly one block lacks `\leanok`:

- **`lem:base_change_mate_section_identity`** — the residual FBC-A proof obligation. Lean name `AlgebraicGeometry.base_change_mate_section_identity` is in `unmatched_lean` (not yet in the Lean file). The block carries a full `% LEAN SIGNATURE`, a source quote (Stacks 02KH), and a proof sketch (identify `Γ(θ)` with `lTensor R' η_M`, post-composed with `regroup^{-1}` via generator trace). The proof sketch is mathematically rigorous and formalizable. This is the one prover target for FBC-A next iter.

**FBC route swap audit (iter-009 changes).**

The adjoint-mate tower (`base_change_mate_unit_value`, `…_fstar_reindex`, `…_gstar_transpose`, `…_generator_trace_eq`) is absent. `unknown_uses: []` confirms no orphaned `\uses{}` edges survive from the drop — the swap is surgically clean.

New blocks introduced:

| Label | Status | Notes |
|-------|--------|-------|
| `lem:pullbackSpecIso_mathlib` | `\mathlibok` | OK |
| `lem:cancelBaseChange_mathlib` | `\mathlibok` | OK |
| `lem:isPushout_cancelBaseChange_mathlib` | `\mathlibok` | OK — new anchor for RegroupHelper |
| `lem:pullback_fst_snd_specMap_tensor` | `\leanok` | OK |
| `lem:base_change_mate_domain_read` | `\leanok` | OK |
| `lem:base_change_mate_codomain_read` | `\leanok` | Uses 4 resolved labels — OK |
| `lem:pullbackIsoEquivalenceOfIso` | `\leanok` | OK |
| `lem:pullback_isEquivalence_of_iso` | `\leanok` | OK |
| `lem:base_change_mate_regroupEquiv` | `\leanok` | Uses `lem:base_change_regroup_linearEquiv` + `lem:isPushout_cancelBaseChange_mathlib` — OK |
| `lem:base_change_mate_section_identity` | **NO `\leanok`** | **Residual obligation** |
| `lem:base_change_mate_generator_trace` | `\leanok` | Uses section identity — sorry-bearing as expected |
| `lem:pushforward_base_change_mate_cancelBaseChange` | `\leanok` | OK |
| `lem:affine_base_change_pushforward` | `\leanok` | OK |
| `lem:flat_preserves_equalizer_mathlib` | `\mathlibok` | OK |
| `thm:flat_base_change_pushforward` | `\leanok` | OK |

**`lem:base_change_mate_regroupEquiv` reconstruction.** Uses `Algebra.IsPushout.cancelBaseChange` (natively `R'`-linear — no hand-rolled `map_smul'`). The `\uses{}` arc to `lem:isPushout_cancelBaseChange_mathlib` is valid. Reconstruction is sound.

**`lem:base_change_mate_section_identity` well-formedness.** The `% LEAN SIGNATURE` block is pinned, the statement (`Γ(θ) = lTensor R' η_M`) is unambiguous, the proof sketch (generator trace + `regroup^{-1}`) is constructive and formalizable. **Well-formed prover target.**

**Gate verdict: FBC-A prover NOT READY this iter.** `lem:base_change_mate_section_identity` is the sole remaining obligation; it is well-specified and should be dispatched to the FlatBaseChange prover in iter-010 once the gate holds. FBC-B (H⁰-equalizer globalization) is not yet blueprinted — see unstarted-phase proposals.

**Severity:** must-fix-this-iter (prover dispatch for FBC-A in iter-010 requires this sorry to close).

---

### 2. `Cohomology_RegroupHelper.tex`

```
complete: true
correct: true
```

Single block `lem:base_change_regroup_linearEquiv`:
- `\leanok` in statement and proof
- `\uses{lem:isPushout_cancelBaseChange_mathlib}` — resolves correctly
- Proof uses `Algebra.IsPushout.cancelBaseChange` directly, natively `R'`-linear
- `cancelBaseChange_tmul` generator computation and inverse documented verbatim

**Chapter is clean.** No issues.

---

### 3. `Picard_FlatteningStratification.tex`

```
complete: partial
correct: true
```

**GF effort-break audit (iter-009 changes).**

New decomposition of `lem:gf_torsion_reindex`:

| Label | Status | `\uses{}` | Notes |
|-------|--------|-----------|-------|
| `lem:annihilator_meets_nonZeroDivisors` | `\mathlibok` | — | `Submodule.annihilator_top_inter_nonZeroDivisors` — OK |
| `lem:gf_torsion_annihilator` | NO `\leanok` | `lem:annihilator_meets_nonZeroDivisors` | `% LEAN SIGNATURE` present, proof adequate; annihilator-extraction step |
| `lem:gf_nagata_monic_lastVar` | NO `\leanok` | — | `% LEAN SIGNATURE` present, proof adequate; Nagata change-of-variables step |
| `lem:polynomial_monic_quotient_finite` | `\mathlibok` | — | `Polynomial.Monic.finite_quotient` — OK |
| `lem:gf_mvPolynomial_quotient_finite_monic` | NO `\leanok` | `lem:polynomial_monic_quotient_finite` | `% LEAN SIGNATURE` present, proof adequate; shared elimination engine |
| `lem:gf_torsion_reindex` | NO `\leanok` | `lem:gf_torsion_annihilator`, `lem:gf_nagata_monic_lastVar`, `lem:gf_mvPolynomial_quotient_finite_monic` | Assembly proof correctly joins the three sub-lemmas |

All three new sub-lemmas carry a formalizable `% LEAN SIGNATURE`, an adequate informal proof, and correct `\uses{}` arcs. The assembly in `lem:gf_torsion_reindex` faithfully chains them. **Decomposition is sound.**

**`lem:gf_polynomial_core` rewiring.** `\uses{lem:gf_finite_module, lem:gf_splice_shortExact, lem:gf_torsion_base, lem:gf_splice_shortExact_free_transport, lem:gf_generic_rank_ses, lem:gf_torsion_reindex}` — correctly rewired; all six dependency labels resolve. Proof structure (strong induction on `d` with generalised base domain `A`) is correct and matches the strategy document's explicit warning about the IH needing to vary `A`.

**Induction motive.** The proof of `lem:gf_polynomial_core` explicitly documents that `A` must be reverted into the motive (`Nat.strong_induction_on d`, with `A` and its instances as explicit binders), and that the IH is applied at `A_g` (not `A`) in the reindex step. This is the load-bearing point identified in STRATEGY.md and `analogies/gf-generic-rank-ses.md`. The blueprint is correct here.

**Supporting helpers.**
- `lem:gf_flat_finite` and `lem:gf_free_moduleFinite` are matched by leandag (not in `unmatched_lean`) — they exist in the Lean file. Both use `\uses{lem:gf_finite_module}` which is unproved, so they are sorry-bearing. That is expected.

**Gate verdict: GF-alg prover NOT READY this iter.** The full chain `lem:gf_torsion_annihilator` → `lem:gf_nagata_monic_lastVar` → `lem:gf_mvPolynomial_quotient_finite_monic` → `lem:gf_torsion_reindex` → `lem:gf_polynomial_core` → `thm:generic_flatness_algebraic` must be proved bottom-up. Blueprint is ready; prover dispatch should target the sub-lemmas in order.

**Severity:** soon (GF-alg prover gate holds for iter-010).

---

### 4. `Picard_QuotScheme.tex`

```
complete: partial
correct: true
```

**Annihilator sub-build status.**

The QUOT-A prover lane gate depends on the predicate chain: `lem:qcoh_section_localization_basicOpen` → `def:modules_annihilator` → `def:schematic_support` → `def:has_proper_support`.

| Label | Status | Blocker |
|-------|--------|---------|
| `lem:isLocalization_basicOpen_mathlib` | `\mathlibok` | — OK |
| `lem:qcoh_section_localization_basicOpen` | NO `\leanok`; in `unmatched_lean` | **NOT FORMALLY CLOSED** — inline NOTE confirms: "not yet formally closed"; the `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` name exists but leandag cannot match it (declaration absent from Lean file or name mismatch) |
| `def:modules_annihilator` | NO `\leanok` | Blocked by above; `\uses{lem:annihilator_localization_eq_map, lem:qcoh_section_localization_basicOpen}` |
| `def:schematic_support` | NO `\leanok` | Blocked by `def:modules_annihilator` |
| `def:has_proper_support` | NO `\leanok` | Blocked by `def:schematic_support` |

**`lem:qcoh_section_localization_basicOpen` is the must-fix for QUOT-A.** The declaration name `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen` is plausible (consistent with Mathlib naming for `SheafOfModules`), but the proof strategy (QCoh → `IsLocalizedModule` bridge on `basicOpen`) needs to be fully worked out and a `% LEAN SIGNATURE` + proof sketch written before the prover can proceed.

**Hilbert-polynomial chain.**

| Label | Status | Notes |
|-------|--------|-------|
| `def:sectionGradedRing` | NO `\leanok` | Blocked — tensor/monoidal infrastructure absent in pinned Mathlib |
| `def:sectionGradedModule` | NO `\leanok` | Blocked |
| `lem:sectionGradedModule_fg` | NO `\leanok` | Needs `def:sectionGradedRing` |
| `lem:gradedHilbertSerre_rational` | NO `\leanok` | Mathlib-ABSENT; no `% LEAN SIGNATURE` yet; project obligation |
| `thm:hilbertPoly_of_sectionModule` | NO `\leanok` | Depends on rationality lemma |
| `lem:hilbertPoly_exists_mathlib` | `\mathlibok` | OK — extraction half only |
| `def:hilbert_polynomial` | `\leanok` | OK (backed by `thm:hilbertPoly_of_sectionModule` which is sorry-bearing) |

**SNAP-S2 opportunity.** `lem:gradedHilbertSerre_rational` imports only Mathlib + the graded encoding. Per STRATEGY.md, S2 is "authorable now". However, no `% LEAN SIGNATURE` is present yet. This must be added before a prover can be dispatched — see unstarted-phase proposals.

**Grassmannian-related blocks.**

`def:quot_functor` (`\leanok`), `def:grassmannian_scheme` (`\leanok`), `def:is_locally_free_of_rank` (`\leanok`), `thm:grassmannian_representable` (`\leanok`) are formalized (sorry-bearing). `thm:grassmannian_representable` cross-depends on GrassmannianCells blocks (`def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper`); those are in the GrassmannianCells chapter and currently unproved.

**Gate verdict: QUOT-A prover BLOCKED.** Must-fix: `lem:qcoh_section_localization_basicOpen` needs a complete proof strategy + `% LEAN SIGNATURE`. The rest of the predicate chain follows once this is closed. QUOT-A dispatch cannot proceed until the bridge lemma is formally specified.

**Severity:** must-fix-this-iter (blocks the prover lane designated by the directive).

---

### 5. `Picard_GrassmannianCells.tex`

```
complete: true
correct: true
```

All blocks carry proof sketches with verbatim source quotes from Nitsure §1, `% LEAN SIGNATURE` blocks, and correctly wired `\uses{}` edges:

| Label | Status | Notes |
|-------|--------|-------|
| `def:gr_affine_chart` | `\leanok` | OK |
| `def:gr_transition` | NO `\leanok` | **Gating label this iter** — signature pinned, proof (explicit matrix formula for the transition map on the affine big cell) is complete and formalizable |
| `lem:gr_cocycle` | NO `\leanok` | `\uses{def:gr_transition, def:gr_affine_chart}` — proof adequate |
| `def:gr_glued_scheme` | NO `\leanok` | `\uses{def:gr_affine_chart, def:gr_transition, lem:gr_cocycle}` — well-specified |
| `lem:gr_separated` | NO `\leanok` | `\uses{def:gr_glued_scheme, def:gr_transition}` — proof adequate (diagonal check on transition maps) |
| `lem:gr_proper` | NO `\leanok` | `\uses{def:gr_glued_scheme, lem:gr_separated}` — proof adequate (valuative criterion for DVRs) |

`unknown_uses: []` confirms all `\uses{}` edges in this chapter resolve.

**Gate verdict: GrassmannianCells prover GREEN.** Chapter is complete and correct. `def:gr_transition` can be dispatched to the GrassmannianCells prover this iter. Bottom-up order: `def:gr_transition` → `lem:gr_cocycle` → `def:gr_glued_scheme` → `lem:gr_separated` + `lem:gr_proper` (parallel).

**Severity:** informational (no issues).

---

### 6. `Picard_RelativeSpec.tex`

```
complete: true
correct: partial
```

- `thm:relative_spec_univ` (`\leanok`) is encoded as `IsAffineHom`, not `RepresentableBy` — weaker than the prose statement. This is a known strategic open question (STRATEGY.md §Open strategic questions).
- `thm:relative_spec_affine_base` (`\leanok`) encoded as `IsAffine`, not a canonical iso.
- These weaker encodings do not block any current-iter prover lane. The gap matters only for `QUOT-repr` which is many iters out.

**Severity:** soon (track the RelativeSpec strengthening question as a prerequisite for GR-repr; no action required this iter).

---

## Cross-Chapter Dependency Issues

### `thm:grassmannian_representable` ↔ GrassmannianCells cross-chapter dependency

`thm:grassmannian_representable` in `Picard_QuotScheme.tex` uses `def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper` from `Picard_GrassmannianCells.tex`. Once GrassmannianCells blocks are proved, `thm:grassmannian_representable`'s sorry count will drop. This is correct and expected — no structural issue.

### FBC → RegroupHelper one-way dependency

`lem:base_change_mate_regroupEquiv` (FlatBaseChange) uses `lem:base_change_regroup_linearEquiv` (RegroupHelper). RegroupHelper is already `\leanok`. The dependency direction is correct and non-circular.

---

## `unmatched_lean` Classification

**13 mathlibok entries (expected — no project Lean file obligation):**
`lem:pullbackSpecIso_mathlib`, `lem:cancelBaseChange_mathlib`, `lem:isPushout_cancelBaseChange_mathlib`, `lem:flat_preserves_equalizer_mathlib`, `lem:fp_free_descent`, `lem:noeth_prime_filtration`, `lem:noether_normalization_fg`, `lem:annihilator_meets_nonZeroDivisors`, `lem:polynomial_monic_quotient_finite`, `lem:hilbertPoly_exists_mathlib`, `lem:isLocalization_basicOpen_mathlib`, `lem:isProper_mathlib`, `lem:functor_is_representable_mathlib`

**18 project stubs (no Lean declaration yet):**

| Label | Chapter | Priority |
|-------|---------|----------|
| `lem:base_change_mate_section_identity` | FlatBaseChange | **must-fix** (FBC-A gate iter-010) |
| `lem:gf_torsion_annihilator` | FlatteningStratification | soon |
| `lem:gf_nagata_monic_lastVar` | FlatteningStratification | soon |
| `lem:gf_mvPolynomial_quotient_finite_monic` | FlatteningStratification | soon |
| `def:sectionGradedRing` | QuotScheme | blocked (Mathlib infra) |
| `def:sectionGradedModule` | QuotScheme | blocked |
| `lem:sectionGradedModule_fg` | QuotScheme | blocked |
| `lem:gradedHilbertSerre_rational` | QuotScheme | soon (authorable, needs `% LEAN SIGNATURE`) |
| `thm:hilbertPoly_of_sectionModule` | QuotScheme | blocked on rationality |
| `def:modules_annihilator` | QuotScheme | **must-fix** (blocked on bridge) |
| `lem:qcoh_section_localization_basicOpen` | QuotScheme | **must-fix** (QUOT-A gate) |
| `def:schematic_support` | QuotScheme | blocked on annihilator |
| `def:has_proper_support` | QuotScheme | blocked on schematic support |
| `def:gr_transition` | GrassmannianCells | **prover target this iter** |
| `lem:gr_cocycle` | GrassmannianCells | prover target |
| `def:gr_glued_scheme` | GrassmannianCells | prover target |
| `lem:gr_separated` | GrassmannianCells | prover target |
| `lem:gr_proper` | GrassmannianCells | prover target |

---

## Prover-Gate Summary

| Lane | Chapter | Gate | Verdict | Blocker |
|------|---------|------|---------|---------|
| FBC-A | FlatBaseChange | `lem:base_change_mate_section_identity` | **NOT READY** (iter-009); ready for iter-010 dispatch | One sorry remaining |
| GF-alg | FlatteningStratification | `thm:generic_flatness_algebraic` | **NOT READY** | Sub-lemma chain unproved |
| QUOT-A | QuotScheme | predicate chain | **BLOCKED** | `lem:qcoh_section_localization_basicOpen` not formally specified |
| GrassmannianCells | GrassmannianCells | `def:gr_transition` | **GREEN** | None — dispatch this iter |

---

## Severity Classification

### Must-fix-this-iter

1. **`lem:qcoh_section_localization_basicOpen` proof strategy missing.**  
   The QCoh→`IsLocalizedModule` bridge for `basicOpen` has a Lean name but no `% LEAN SIGNATURE` and no closed proof strategy. Without this, `def:modules_annihilator` and the entire QUOT-A predicate chain cannot be dispatched. A blueprint-writer pass should produce:
   - A `% LEAN SIGNATURE` block for `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen`
   - A proof sketch using `lem:isLocalization_basicOpen_mathlib` + quasicoherence datum to construct the `IsLocalizedModule` instance
   - `\uses{lem:isLocalization_basicOpen_mathlib}` arc confirmed

   This is the blocker for the QUOT-A lane designated as a prover target this iter.

### Soon

2. **FBC-B not yet blueprinted.**  
   The H⁰-as-equalizer globalization step (FBC-B) has no chapter section or block. The flat-equalizer Mathlib half is identified (`Module.Flat.ker_lTensor_eq`, `tensorEqLocusEquiv` / `lem:flat_preserves_equalizer_mathlib` already present), but the H⁰-as-equalizer packaging and the finite-affine-cover argument are absent. Blueprint-writer pass needed before FBC-B prover can be dispatched (iter-011 target per STRATEGY.md).

3. **`lem:gradedHilbertSerre_rational` needs `% LEAN SIGNATURE`.**  
   STRATEGY.md explicitly calls SNAP-S2 "authorable now" since it imports only Mathlib + the graded encoding. The rationality bridge must have a `% LEAN SIGNATURE` block before a prover can proceed. No proof sketch is currently present.

4. **RelativeSpec `thm:relative_spec_univ` gap.**  
   Encoded as `IsAffineHom` not `RepresentableBy`. This is a strategic open question deferred until QUOT-repr. Track explicitly; no action required this iter but must be resolved before GR-repr.

### Informational

5. **Isolated lean_aux node.**  
   `lean:Alg…` — one lean_aux stub with no blueprint counterpart, 0 impact. Benign; likely a notation or helper. No action required.

6. **13 mathlibok `unmatched_lean` entries.**  
   All expected — they reference Mathlib declarations not present in project Lean files. The count (13) matches `mathlib_ok: 13` in the DAG summary. No action.

7. **GF sub-lemma Lean names.**  
   `lem:gf_torsion_annihilator` / `lem:gf_nagata_monic_lastVar` / `lem:gf_mvPolynomial_quotient_finite_monic` are in `unmatched_lean` because no Lean declaration exists yet. This is expected for iter-009 blueprint-writer output; prover will create them bottom-up in iter-010.

---

## Unstarted-Phase Proposals

### Proposal 1: SNAP-S2 blueprint pass (authorable this iter)

**Phase:** SNAP → `lem:gradedHilbertSerre_rational`  
**Status in STRATEGY.md:** NEXT (S2) — "authorable now"  
**What is needed:**
- `% LEAN SIGNATURE` for `AlgebraicGeometry.gradedModule_hilbertSeries_rational` (classical, inductive on degree-1 generators of the graded module)
- Proof sketch: Noetherian induction on f.g. graded modules; base case = graded field; inductive step uses the SES `0 → gM(-1) → gM → gM/gM(-1) → 0` and the rationality of the Poincaré series
- No dependencies outside Mathlib + graded module definitions
- This unblocks SNAP-S3 (`thm:hilbertPoly_of_sectionModule`) once `def:sectionGradedRing`/`Module` are available

**Recommended action:** dispatch a blueprint-writer pass for SNAP-S2 this iter in parallel with the GrassmannianCells prover. The rationality argument is classical and self-contained.

### Proposal 2: FBC-B blueprint section stub

**Phase:** FBC-B — H⁰-as-equalizer globalization  
**Status in STRATEGY.md:** NEXT (follows FBC-A)  
**What is needed (pre-prover):**
- A new `\section{Globalization via the H⁰-equalizer}` in `Cohomology_FlatBaseChange.tex`
- Blocks: `lem:flat_base_change_H0_equalizer_affine` (H⁰ = equalizer on a finite affine cover, sheaf condition, Čech degree 0); `thm:flat_base_change_pushforward_global` (globalization from affine lemma)
- The flat-equalizer Mathlib half is already anchored (`lem:flat_preserves_equalizer_mathlib` = `LinearMap.tensorEqLocusEquiv`)
- The finite-affine-cover sheaf-condition packaging is the novel project work

**Recommended action:** After `lem:base_change_mate_section_identity` gets `\leanok` in iter-010, blueprint-writer should add the FBC-B section so the globalisation prover can be dispatched in iter-011.

### Proposal 3: QUOT predicate sub-build (`lem:qcoh_section_localization_basicOpen`)

**Phase:** QUOT-defs — predicate sub-builds (P1, P2)  
**Status in STRATEGY.md:** ACTIVE  
**What is needed (as must-fix, not merely a proposal):**  
See must-fix item 1 above. The QCoh bridge is the key unlock for the entire QUOT-A predicate chain.

---

## Summary Verdict

| Chapter | complete | correct | Gate |
|---------|----------|---------|------|
| Cohomology_FlatBaseChange | partial | true | FBC-A: NOT READY (one sorry); ready for iter-010 |
| Cohomology_RegroupHelper | **true** | **true** | — (supporting chapter, closed) |
| Picard_FlatteningStratification | partial | true | GF-alg: NOT READY (sub-lemma chain unproved) |
| Picard_QuotScheme | partial | true | QUOT-A: **BLOCKED** (QCoh bridge missing) |
| Picard_GrassmannianCells | **true** | **true** | GrassmannianCells: **GREEN** — dispatch this iter |
| Picard_RelativeSpec | true | partial | — (no current lane; strategic gap noted) |

The `leandag` and `blueprint-doctor` passes are both clean (0 unknown_uses, 0 broken refs, 0 orphans, 0 axioms). The FBC route swap dropped the adjoint-mate tower without leaving orphaned edges. The GF effort-break decomposition is sound. The sole blocking item for a new prover lane this iter is the QCoh bridge (`lem:qcoh_section_localization_basicOpen`); the GrassmannianCells chapter is ready for immediate prover dispatch.
