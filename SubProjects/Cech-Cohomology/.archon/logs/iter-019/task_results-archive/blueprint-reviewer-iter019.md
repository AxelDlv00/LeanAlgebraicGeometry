# Blueprint Review Report

## Slug
iter019

## Iteration
019

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_acyclic_affine` proof block (line 789):
  `\uses{..., AlgebraicGeometry.CombinatorialCech.depDiff_exact}` — a raw Lean declaration
  name used as a blueprint label. `blueprint-doctor` flags it as a broken ref (`kind: uses`,
  `label: AlgebraicGeometry.CombinatorialCech.depDiff_exact`). `leandag` silently matches it
  to a lean-aux node (so `unknown_uses: []` in the build JSON), but it is not a valid blueprint
  label and must not appear in `\uses{}`.
  **Disposition: wire-up error** — `depDiff_exact` is already part of the parent lemma's own
  `\lean{}` list (line 718) and is consumed implicitly through `lem:section_cech_homology_exact`.
  Fix: remove `AlgebraicGeometry.CombinatorialCech.depDiff_exact` from the proof `\uses{}`
  of `lem:cech_acyclic_affine`. No new blueprint node is required.
  **Blocks Lane 3** (CechAcyclic.lean prover dispatch).

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **MUST-FIX (broken `\uses{}`)** — `lem:cech_acyclic_affine` proof block, line 789: Lean
    name `AlgebraicGeometry.CombinatorialCech.depDiff_exact` appears in `\uses{}` as if it
    were a blueprint label; it is not. Remove it from the proof `\uses{}` list. (The dependency
    is already implied via `lem:section_cech_homology_exact`, which lists `depDiff_exact` among
    its own `\lean{}` helpers.) This is the sole must-fix finding; it blocks Lane 3.
  - **Informational** — `def:cohomology_sheaf_is_sheafify_homology` (line 1781): block uses
    `\begin{lemma}` environment but carries a `def:` label prefix. Harmless cosmetic
    inconsistency; leanblueprint ignores label prefixes for dispatch purposes.

## Lane-gate verdicts (directive focus)

### Lane 1 — `CechBridge.lean` → `lem:cech_complex_hom_identification`
**GATE CLEARS.**
- Statement: isomorphism of cochain complexes
  `Hom(K(𝒰)_•, F) = Č•(𝒰, F)`, natural in `F ∈ PMod`. Clear, well-scoped.
- Proof sketch: free–forgetful adjunction + Yoneda per multi-index; additive degreewise
  isomorphisms interleave with the alternating-sum differentials. Detail is adequate.
- `\uses{def:cech_free_presheaf_complex, def:section_cech_complex}` — both valid labels ✓
- `\lean{}` list (10 helper names): names present in `CechBridge.lean` per grep ✓
- Source: `references/stacks-cohomology.tex` exists on disk ✓; verbatim `SOURCE QUOTE` and
  `SOURCE QUOTE PROOF` present ✓; visible `\textit{Source:}` line ✓

### Lane 2 — `FreePresheafComplex.lean` → `lem:cech_free_complex_quasi_iso` + `def:cover_structure_presheaf`
**GATE CLEARS.**

**`def:cover_structure_presheaf`**
- Has `\leanok`; 11 `\lean{}` helper declarations; clear prose identifying `O_𝒰` as the image
  presheaf of the augmentation; `\uses{def:cech_free_presheaf_complex}` valid ✓
- Source: `references/stacks-cohomology.tex` ✓; verbatim quote ✓; visible source line ✓

**`lem:cech_free_complex_quasi_iso`**
- Statement: augmented complex `⋯ → K(𝒰)₀ → O_𝒰 → 0` is exact; equivalently,
  `K(𝒰)_•` is a projective resolution of `O_𝒰[0]`. Clear.
- Proof sketch: homology computed sectionwise; for each open `W` split index set as
  `I = I₁ ⊔ I₂`; fix `i_fix ∈ I₁`; prepend-homotopy `h(s)_{i₀…} = (i₀ = i_fix) s_{i₁…}`
  is contracting; `evaluation` functor preserves homology (exact). Adequate for a prover.
- `\uses{def:cech_free_presheaf_complex, def:cover_structure_presheaf}` — both valid ✓
- Source: `references/stacks-cohomology.tex` ✓; verbatim quotes ✓; visible source line ✓

### Lane 3 — `CechAcyclic.lean` → `def:qcoh_sections_localized` + `lem:section_cech_homology_exact` + `lem:cech_acyclic_affine`
**GATE BLOCKED** — the broken `\uses{}` in the `lem:cech_acyclic_affine` proof block (see
must-fix above) must be fixed first. All three target declarations are otherwise
well-formulated:

**`def:qcoh_sections_localized`**
- Statement: `F(D(g)) ≅ M_g` as `IsLocalizedModule (Submonoid.powers g)`; restriction map
  is the canonical localisation map. Well-scoped.
- Residual gap (affine equivalence `F ≅ tilde(ΓF)`, Stacks 01I8) is explicitly documented
  with the available Mathlib hooks (`isIso_fromTildeΓ_of_presentation`). No overclaiming.
- Source: `references/stacks-schemes.tex` (Tag 01HV items (4)–(5)) ✓; verbatim quote ✓;
  visible source line ✓

**`lem:section_cech_homology_exact`**
- Statement: complex isomorphism `Č•(𝒰, F) ≅ D•` (localised complex) + equivalence
  `IsZero(homology p) ↔ Function.Exact(d^{p-1}, d^p)`. Well-specified.
- `\lean{}` list (22 helper names including all `AwayComparison.*` and `CechLocalized.*`
  helpers) confirms coverage already built in `CechAcyclic.lean`.
- Source: `references/stacks-coherent.tex` ✓; verbatim quote ✓; visible source line ✓

**`lem:cech_acyclic_affine`**
- Statement: standard-cover section Čech complex `Č•(𝒰, F)` over `Spec R` has
  `H^p = 0` for `p > 0`; correctly restricted to absolute section complex
  (no pushforward `f_*`). Strategy-critic design decision confirmed ✓
- Proof sketch: two-paragraph — (1) reduce to `Function.Exact` via `def:qcoh_sections_localized`
  + `lem:section_cech_homology_exact`; (2) close each node via
  `exact_of_isLocalized_span` + `depDiff_exact` contracting homotopy. Adequate.
- `\uses{def:section_cech_complex, def:standard_affine_cover}` (statement block, line 719) — valid ✓
- **Proof `\uses{}` (line 789): BROKEN** — see must-fix above.
- Source: `references/stacks-coherent.tex` ✓; verbatim quotes ✓; visible source line ✓

**Fast-path option for Lane 3**: after a writer removes `AlgebraicGeometry.CombinatorialCech.depDiff_exact` from the proof `\uses{}` and `lake build` stays green, a scoped re-review of this chapter alone suffices to re-open Lane 3 this iter without burning an iter waiting.

## P5a overclaim check (directive-requested)

`lem:higher_direct_image_presheaf` (lines 1823–1901, re-signed iter-019) does **not**
overclaim. Lines 1869–1879 explicitly state:

> "The identification of the displayed presheaf homology with the absolute cohomology of
> the preimage, `H^k((f_*I^•)(V)) = H^k(f^{-1}(V), G|_{f^{-1}(V)})`, which uses that
> `I^•|_{f^{-1}(V)}` is again injective over `f^{-1}(V)`, **is supplied at point of use**;
> this lemma records the resolution-internal sheafify-of-objectwise-homology form."

The deferred absolute-cohomology bridge is correctly displaced to the downstream consumers
(`lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`). This is
acceptable per the directive; not a finding.

`def:cohomology_sheaf_is_sheafify_homology` (engine block, lines 1781–1821) is correctly
marked Archon-original (NOTE comment, no `% SOURCE:` line, no `\textit{Source:}`) ✓.
`\lean{}` hints (`PresheafOfModules.homologyIsoSheafify`, etc.) verified present in
`HigherDirectImagePresheaf.lean` ✓.

## leandag / blueprint-doctor summary

- `leandag build --json`: `isolated: 0` (no isolated blueprint nodes), `unknown_uses: []`,
  `conflicts: []`. 24 `unmatched_lean` entries — all expected: 9 are `\mathlibok` Mathlib
  declarations; 15 are project targets not yet formalized. No action required on these.
- `archon blueprint-doctor --json`: one `broken_refs` entry (the Lane-3 must-fix above).
  Zero `malformed_refs` (no `undefined-macro`, `math-delim`, `literal-ref`, `bare-label`).
  Zero `orphan_chapters`, `covers_problems`, `axiom_decls`.

## Severity summary

**must-fix-this-iter**:
1. `Cohomology_CechHigherDirectImage.tex` / `lem:cech_acyclic_affine` proof block: broken
   `\uses{}` containing Lean name `AlgebraicGeometry.CombinatorialCech.depDiff_exact`.
   Disposition: **wire-up error** — remove from proof `\uses{}`. Blocks Lane 3 (CechAcyclic).
   Fast path: writer patch → `lake build` green → scoped re-review → Lane 3 unblocked same iter.

**informational**:
1. `Cohomology_CechHigherDirectImage.tex` / `def:cohomology_sheaf_is_sheafify_homology`:
   `\begin{lemma}` environment with `def:` label prefix — cosmetic mismatch, harmless.

**Overall verdict**: Blueprint is substantially complete and correct across all three chapters.
One must-fix broken `\uses{}` in `lem:cech_acyclic_affine` blocks Lane 3 (CechAcyclic);
Lanes 1 and 2 clear the HARD GATE and may be dispatched immediately.
All three lane targets are mathematically well-formulated and adequate for a prover.
No unstarted phases: all four phases have adequate blueprint coverage.
