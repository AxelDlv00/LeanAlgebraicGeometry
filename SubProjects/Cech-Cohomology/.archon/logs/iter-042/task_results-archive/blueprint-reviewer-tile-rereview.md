# Blueprint Review Report

## Slug
tile-rereview

## Iteration
042

## Per-chapter

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **GATE CLEARS** on all four `lem:tile_section_localization` gate conditions (details below).
  - `lem:isIso_fromTildeGamma_of_quasicoherent` has 0 rdeps (explicitly marked dormant Route-A fallback, superseded by Route-B assembly `lem:qcoh_isIso_fromTildeGamma`). No must-fix; the text documents it is dead weight, but cleanup is non-blocking. Flag: **informational** — future writer may remove or keep as commentary.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

---

## Gate decision detail

### 1. `lem:tile_section_localization` — all four conditions met

**(a) No longer claims section comparison is `restrict_obj` definitional.**
The proof opens (lines 4473–4476) with an explicit `% NOTE` marking the naive recipe as UNSOUND, and the narrative (lines 4480–4482) reads: _"The proof is a base-ring descent in five steps; the section comparison it rests on is NOT the definitional equality of Lemma lem:restrict_obj_mathlib (see the proof of Lemma lem:tile_section_comparison)."_ The old unsoundness is gone. ✓

**(b) Base-ring descent step explicit.**
Step 5 (lines 4508–4514) explicitly applies `Lemma~\ref{lem:isLocalizedModule_powers_restrictScalars_of_algebraMap}` with `A = R_g` and the scalar tower `R → R_g`, descending the localisation at powers of `f̄` (over `R_g`) to the localisation at powers of `f` (over `R`). The step is fully detailed, including why `f̄` descends to `f`. ✓

**(c) References both sub-lemmas.**
Step 3 (line 4495) explicitly invokes `lem:tile_image_opens_identities`. Step 4 (line 4498) explicitly invokes `lem:tile_section_comparison`. Both are named in the prose, not just in `\uses{}`. ✓

**(d) Honest `\uses{}` in both statement and proof.**
- Statement `\uses{}` (lines 4457–4460): lists `lem:qcoh_finite_presentation_cover`, `lem:presentation_modulesRestrictBasicOpen`, `lem:section_isLocalizedModule_of_presentation`, `lem:restrict_obj_mathlib`, `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap`, `lem:tile_image_opens_identities`, `lem:tile_section_comparison`. ✓
- Proof `\uses{}` (lines 4470–4472): same set minus `lem:qcoh_finite_presentation_cover` (which is a precondition on the setup, not invoked inside the proof body). ✓
- leandag `unknown_uses: []` — no broken `\uses{}` labels. ✓

**Five-step soundness check:** Steps 1–5 form a logically coherent chain.
- Step 1 pulls the tile presentation from B4 (`lem:presentation_modulesRestrictBasicOpen`).
- Step 2 applies `lem:section_isLocalizedModule_of_presentation` to obtain R_g-module localisation.
- Step 3 identifies the opens via `lem:tile_image_opens_identities`.
- Step 4 bridges global-ring sections via `lem:tile_section_comparison` (genuine natural iso, non-definitional).
- Step 5 descends base ring via `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap`.
The non-circularity is preserved: the tile-level B4 lemma is invoked, never the keystone-at-g itself. ✓

---

### 2. `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap` — well-formed

- **Statement** (lines 4354–4360): clearly states that if `φ : M → N` exhibits N as the A-module localisation at powers of `f_A`, then the same map (viewed R-linearly) exhibits N as the R-module localisation at powers of `f`. This is the correct converse direction of `IsLocalizedModule.of_restrictScalars`. ✓
- **`\lean{}` pin** (line 4353): `AlgebraicGeometry.isLocalizedModule_powers_restrictScalars_of_algebraMap` — confirmed matched in leandag (exists in `QcohTildeSections.lean:662`). ✓
- **Informal proof** (lines 4362–4373): explains all three `IsLocalizedModule` clauses (surjectivity-of-quotients, injectivity-up-to-torsion, unit bijectivity) and carefully handles the unit clause via the scalar-tower identity `f^k · x = f_A^k · x`. The proof is elementary but complete. ✓
- **No `\uses{}`**: acceptable — this block has no blueprint-level deps (it is self-contained elementary algebra). ✓

---

### 3. `lem:tile_image_opens_identities` (Sub-lemma A) — well-formed to-build block

- **Statement** (lines 4383–4393): correctly identifies `ι(Spec R_g) = D(g)` and `ι(D(f̄)) = D(gf) = D(g) ∩ D(f)`. Clear, precise, unambiguous. ✓
- **Proof** (lines 4397–4405): set-theoretic argument, explains both equalities. Notes explicitly "These are equalities of opens, proved set-theoretically; they are not definitional." ✓
- **No `\lean{}` pin**: expected (to-build). The NOTE at line 4378 acknowledges this. ✓
- **`\uses{lem:presentation_modulesRestrictBasicOpen}`**: justified — in the Lean formulation, `ι` is constructed via the presentation machinery (`basicOpenIsoSpecAway g`); the `% NOTE` (lines 4380–4382) makes this Lean-level dep explicit.

---

### 4. `lem:tile_section_comparison` (Sub-lemma B) — well-formed to-build block

- **Statement** (lines 4412–4424): asserts the R_g-linear natural isomorphism `Γ_{R_g}(V, F_(g)) ≅ Γ_R(ι(V), F)` with explicit clarification of which section functor is which. ✓
- **Proof** (lines 4435–4451): clearly explains the two-layer structure (local-ring layer is definitionally equal via `lem:restrict_obj_mathlib`; global-ring layer requires a genuine bridge). The sentence _"This bridge is genuinely non-definitional"_ is explicit. ✓
- **No `\lean{}` pin**: expected (to-build). ✓
- **`\uses{lem:presentation_modulesRestrictBasicOpen, lem:restrict_obj_mathlib, lem:tile_image_opens_identities}`**: all three are live labels with no broken edges (leandag `unknown_uses: []`). ✓

---

### 5. `lem:qcoh_section_equalizer` — undamaged

- `\lean{AlgebraicGeometry.qcoh_section_equalizer, AlgebraicGeometry.res_trans_apply}` (line 4296): the `res_trans_apply` addition is bundled correctly with a `% NOTE` explaining the more-general formulation and why the private helper is DAG-covered here. ✓
- `\leanok` present in both statement and proof blocks. ✓
- Statement and proof prose are intact and mathematically sound. ✓

---

## Dependency & isolation findings

- **Isolated lean_aux node** (`lean:Alg…`, 1 total, 0 blueprint): one uncovered Lean helper has no `\uses{}` out and nothing using it. **keep** (standard lean_aux signal; no blueprint entry required, not a blueprint node).
- **56 unmatched `\lean{}`** entries: all are either `\mathlibok` blocks pointing at Mathlib declarations not scanned in the 461-declaration project tree, or to-build project declarations naming intended targets. Expected pattern, no action required.

---

## Rendering lint

`archon blueprint-doctor --json` output: clean. `malformed_refs: []`, `broken_refs: []`, `orphan_chapters: []`, `covers_problems: []`, `axiom_decls: []`. No rendering findings in any chapter.

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

---

## Overall verdict

`Cohomology_CechHigherDirectImage.tex` is `complete: true`, `correct: true` with no must-fix-this-iter finding on the `lem:tile_section_localization` material; the five-step proof sketch is sound and all four gate conditions are satisfied. Dispatch of a prover at `tile_section_localization` is cleared for this iteration. 3 chapters audited, 0 must-fix findings, 0 unstarted-phase proposals.
