# Blueprint Review Report

## Slug
iter017

## Iteration
017

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:

  **Gate focus — Ab reconciliation (Lane 3: CechBridge.lean)**

  `def:section_cech_complex`: states explicitly "cochain complex of *abelian groups*", citing
  Stacks Cohomology L879–910 SOURCE QUOTE which says "This is an abelian group." ✓

  `lem:cech_complex_hom_identification`: statement reads "isomorphism of cochain complexes of
  *abelian groups*" (line 970). `\lean{freeYonedaHomAddEquiv}` is named as the additive
  equivalence, and the proof explicitly promotes the per-multi-index bijection to an
  isomorphism of abelian groups via the additive structure. All three (statement, proof,
  `freeYonedaHomAddEquiv`) agree on abelian groups. Internally consistent. ✓

  **Gate focus — `def:cover_structure_presheaf` (Lane 2: FreePresheafComplex.lean)**

  `% SOURCE: [Stacks Project], Cohomology, Lemma \texttt{lemma-homology-complex} (read from
  references/stacks-cohomology.tex, L1200--1204)` — `references/stacks-cohomology.tex` exists
  on disk (retrieved 2026-06-05, 14535 lines, verified). Lines 1200–1204 fall within the
  `lemma-homology-complex` block (L1142–1284 range per `stacks-cohomology.md`). ✓

  SOURCE QUOTE: `"Let $X$ be a ringed space. Let $\mathcal{U} : U = \bigcup_{i \in I} U_i$
  be an open covering. Let $\mathcal{O}_\mathcal{U} \subset \mathcal{O}_X$ be the image
  presheaf of the map $\bigoplus j_{p!}\mathcal{O}_{U_i} \to \mathcal{O}_X$."` — verbatim
  from source, original Stacks notation (not rewritten). ✓

  Visible `\textit{Source:}` line present and matches `% SOURCE:` pointer. ✓

  Augmentation map precision: defined as image presheaf of
  `\coprod_i free(y U_i) → PresheafOfModules.unit(X.ringCatSheaf.obj)` with concrete
  sectionwise description `O_U(W) = O_X(W)` iff `W ⊂ U_i`, else `0`. Lean name
  `AlgebraicGeometry.coverStructurePresheaf` is specific. Adequate to formalize. ✓

  **Gate focus — L1 categorical→module bridge (Lane 1: CechAcyclic.lean)**

  The three-part decomposition in `lem:cech_acyclic_affine` proof is mathematically sound
  and adequately specified:

  *(1) Section identification*: names Mathlib's `AlgebraicGeometry.Modules.Tilde`,
  `IsLocalizedModule(Submonoid.powers g)`, `isUnit_algebraMap_end_basicOpen`, and Stacks
  Tag 01HV item (4) (verbatim SOURCE QUOTE present at lines 705–712). The chain
  `quasicoherence of F → F = M̃ → Γ(D(g), M̃) = M_g` is spelled out. ✓

  *(2) Differential identification*: names the three interface hypotheses for the
  `depDiff` dependent port — `hu` (unit: `c ∘ δ₀ = id`), `hsh` (shift: `c ∘ δ_{k+1} = δ_k ∘ c`),
  `hcomm` (coface commutation) — and identifies `c` as the prepend-i_fix transport
  (`depTransport`). Concrete enough for the prover to discharge. ✓

  *(3) Homology ↔ exactness*: route through `exact_of_isLocalized_span` + `depDiff_exact`
  is named explicitly. The reduction to the spanning localisations `Away(s_r)` and the
  one-localisation-at-a-time argument are described. ✓

  The note that the extra-degeneracy packaging is a documented dead end and that the
  `depHomotopy`/`depDiff` route is used instead is well-placed and accurate.

  **Other observations (informational)**

  - 19 helper Lean names bundled into `lem:cech_acyclic_affine`'s `\lean{...}` list —
    consistent with the iter-016 combinatorial ports already in `CechAcyclic.lean`. ✓
  - `[Finite I]` + coproduct-notation prose in `def:cech_free_presheaf_complex` (lines
    877–881) correctly clarifies that `⊕ = ∐` for finite index sets. ✓
  - `% archon:covers ... CechBridge.lean` line present at line 7 of chapter. ✓
  - `lem:cech_free_complex_quasi_iso` proof (line 1183) cross-references the
    `CombinatorialCech.*` prepend homotopy — informational bridge note, correct. ✓

## Dependency & isolation findings (from leandag)

`leandag build --json`:
- `unknown_uses`: **none** — all `\uses{}` edges point at valid labels.
- `isolated blueprint nodes`: **0** — DAG is fully connected.
- `conflicts`: **none**.
- 23 `unmatched_lean` entries — all expected: 9 are `\mathlibok`-tagged Mathlib
  declarations (not in project Lean files by design); the remaining 14 are pending project
  declarations in the three active prover lanes (CechBridge, FreePresheafComplex,
  PresheafCech, plus downstream P5a/P5b). None represent blueprint errors.

`archon blueprint-doctor --json`:
- `broken_refs`: **none**.
- `malformed_refs`: **none** (no undefined-macro, no math-delim, no literal-ref, no bare-label).
- `orphan_chapters`: **none**.
- `covers_problems`: **none**.
- `axiom_decls`: **none**.

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

**Overall verdict**: All three chapters are `complete: true`, `correct: true` with no
must-fix findings; the Ab reconciliation is internally consistent, `def:cover_structure_presheaf`
carries a valid verbatim citation to an existing local reference file, the L1 three-part bridge
is mathematically sound and adequate to guide a prover, and the DAG has zero broken edges
and zero isolated nodes. All three prover lanes (CechAcyclic.lean, FreePresheafComplex.lean,
CechBridge.lean) clear the HARD GATE and may be dispatched this iter. 3 chapters audited,
0 findings, 0 unstarted-phase proposals.
