# Blueprint Review Report

## Slug
iter011

## Iteration
011

## Top-level summaries

### Incomplete parts

- `Cohomology_CechHigherDirectImage.tex` / `lem:injective_cech_acyclic`:
  The proof block references three specific Stacks lemmas as "presheaf-level Čech machinery
  developed as part of the chapter's foundational content" — but **no declarations for that
  content exist anywhere in the blueprint**. The three missing pieces are:
  1. **`lemma-cech-map-into`** (Stacks stacks-cohomology.tex L1138): the complex
     `K(𝒰)_•` of presheaves of `O_X`-modules (built from coproducts of `(j_{i_0…i_p})_{p!} O_U`)
     and the identification `Hom(K(𝒰)_•, F) = Č•(𝒰, F)`.
  2. **`lemma-homology-complex`** (L1199): `K(𝒰)_•` is quasi-isomorphic to
     `O_U[0]` (equivalently, the augmented Čech complex is exact as a complex of presheaves).
  3. **`lemma-cech-cohomology-derived-presheaves`** (L1287): the Čech cohomology
     functors `Ȟ^p(𝒰, -)` are canonically isomorphic (as a δ-functor) to the right-derived
     functors of `Ȟ^0(𝒰, -)` on `PMod(O_X)`. This also uses
     **`lemma-cech-cohomology-delta-functor-presheaves`** (L1066: Čech forms a δ-functor on
     presheaves).
  All four lemmas are present in the local reference `references/stacks-cohomology.tex`.
  The proof note "is developed as part of the chapter's foundational content" is a placeholder
  — it does NOT correspond to any blueprinted declarations.

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:injective_cech_acyclic` (proof block):
  The proof `\uses{def:cech_complex}` is correct as far as it goes, but the argument
  jumps over the K(𝒰)_• infrastructure with only a prose promise of "foundational content."
  A prover receiving this block has no blueprint-declared sub-lemmas to call; the proof is
  NOT formalization-ready as a single block. Needs to be broken into at least 3–4 sub-lemma
  declarations (see Incomplete parts above).

### Dependency & isolation findings

All 28 isolated nodes in the leandag output are type `lean_aux` (Lean helper declarations
with no corresponding blueprint node). None are blueprint-isolated nodes.
Disposition: **keep** for all — these are provably-clean project helpers (0 blueprint-isolated
nodes reported by `leandag stats`).

`unmatched_lean` in leandag (18 nodes): these are the frontier declarations whose Lean
names are either (a) `\mathlibok` Mathlib declarations (7 items, verified below) or
(b) project declarations not yet implemented in `.lean` files (11 items, expected for
unproven frontier nodes). No fix needed — this is the expected state for an active prover phase.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

(All declarations are `\leanok` or `\mathlibok`. All seven `\mathlibok` Lean names verified
against Mathlib via `lean_run_code`. Proof sketches are detailed and formalization-ready.
P4 is closed.)

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: partial
- **correct**: partial
- **notes**:
  - **MUST-FIX — `lem:injective_cech_acyclic` proof not prover-ready**: proof block
    promises sub-lemmas as "chapter foundational content" but they are absent from the
    blueprint. The missing declarations are K(𝒰)_• definition, Hom identification,
    K(𝒰)_• quasi-iso to O_U[0], and the Čech δ-functor on presheaves. All source material
    is in `references/stacks-cohomology.tex` at L1066, L1138, L1199, L1287.
  - **`lem:injective_cech_acyclic` proof `\uses{def:cech_complex}` is missing edges**:
    once the sub-lemma declarations are added, their labels must appear in this proof's
    `\uses{}`. wire-up disposition.
  - **Circularity confirmed fixed** (focus area from directive): `lem:cech_to_cohomology_on_basis`
    proof `\uses{lem:injective_cech_acyclic, lem:ses_cech_h1, lem:cech_acyclic_affine}` —
    NO `lem:affine_serre_vanishing` in the proof block. The dependency graph is acyclic:
    `cech_acyclic_affine` → `cech_to_cohomology_on_basis` → `affine_serre_vanishing`
    (one-directional). The explicit note in the proof at line 994–999 confirms this.
  - **`def:standard_affine_cover` `\mathlibok` faithfulness confirmed**: Lean signature
    `AlgebraicGeometry.Scheme.affineOpenCoverOfSpanRangeEqTop : {R : CommRingCat} → {ι : Type} →
    (s : ι → ↑R) → (hs : Ideal.span (Set.range s) = ⊤) → (Spec R).AffineOpenCover` exactly
    matches the blueprint statement. The spanning-family bundle `(s, hs)` is the correct
    encoding. ✅
  - **`lem:cech_to_cohomology_on_basis` statement↔Lean shape parity**: statement concludes
    `H^p(U, F) = 0` (pure vanishing), while the `\lean{cech_eq_cohomology_of_basis}` name
    suggests an equality/comparison. Mathematically consistent (vanishing IS what the source
    01EO states), but the Lean name could mislead a prover about the return type. Recommend
    the plan agent note this to the prover: the target is a vanishing lemma, not an explicit
    iso `Ȟ^p ≅ H^p`.
  - **All other declarations are correct and complete**: `def:cech_nerve`, `def:cech_complex`,
    `def:cover_arrow`, `def:cover_cech_nerve`, `def:push_pull_obj`, `def:push_pull_map`,
    `lem:push_pull_id`, `lem:push_pull_comp`, `lem:push_pull_unit_mate`,
    `lem:push_pull_transport_cancel`, `def:push_pull_functor`, `def:cech_nerve_cosimplicial`,
    `def:relative_cech_complex_of_nerve`, `lem:cech_acyclic_affine`, `lem:ses_cech_h1`,
    `lem:affine_serre_vanishing`, `lem:cech_to_cohomology_on_basis`,
    `lem:cech_augmented_resolution`, `lem:higher_direct_image_presheaf`,
    `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`,
    `lem:cech_computes_cohomology` — all have adequate proof sketches, correct `\uses{}`
    edges, and well-specified Lean targets.
  - **P3b bridge non-circularity detail**: the `lem:cech_to_cohomology_on_basis` proof
    makes this chain:
    (1) embed F → I (injective); I has vanishing Čech cohomology by `lem:injective_cech_acyclic`;
    (2) the SES F → I → Q gives section-level surjectivity via `lem:ses_cech_h1`;
    (3) Q has vanishing Čech cohomology by induction from the LES;
    (4) the LES of derived functors then kills H^p(U, F) by induction.
    This argument is self-contained and does NOT call `lem:affine_serre_vanishing`.

## Severity summary

**must-fix-this-iter:**

1. `Cohomology_CechHigherDirectImage.tex` / `lem:injective_cech_acyclic`:
   proof block references undeclared presheaf-level sub-lemmas as "chapter foundational
   content". Blueprint is `partial` on both completeness and correctness. **HARD GATE FAILS
   for `CechHigherDirectImage.lean`** — no prover should be dispatched until a blueprint-writer
   adds the missing sub-lemma declarations.

   Recommended writer directive: add declarations for (in dependency order):
   1. `\definition` `\label{def:cech_free_presheaf_complex}` — the K(𝒰)_• complex of free
      presheaves (direct sums of `(j_{i_0…i_p})_{p!} O_U`). Source: stacks-cohomology.tex
      L1138–1170 (`lemma-cech-map-into`).
   2. `\lemma` `\label{lem:cech_complex_hom_identification}` — the isomorphism
      `Hom(K(𝒰)_•, F) = Č•(𝒰, F)` for any presheaf F. Source: stacks-cohomology.tex
      L1138–1170.
   3. `\lemma` `\label{lem:cech_free_complex_quasi_iso}` — K(𝒰)_• is quasi-iso to
      O_U[0]. Source: stacks-cohomology.tex L1199–1284 (`lemma-homology-complex`).
   4. (Optional but cleaner) `\lemma` `\label{lem:cech_cohomology_delta_functor_presheaves}` —
      Čech cohomology forms a δ-functor on PMod(O_X). Source: stacks-cohomology.tex L1066.
   Then update `lem:injective_cech_acyclic` proof `\uses{}` to include all four.

**soon:**

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis` Lean name
  `cech_eq_cohomology_of_basis` implies an equality, but the statement gives vanishing only.
  Add a `% NOTE:` or prose clarification for the prover that the Lean target is a vanishing
  lemma `∀ p > 0, H^p(U, F) = 0` under conditions (1)–(3), not an explicit `Ȟ^p ≅ H^p` iso.

Overall verdict: `Cohomology_CechHigherDirectImage.tex` is `partial` on completeness and
correctness due to `lem:injective_cech_acyclic` referencing undeclared presheaf-level
sub-lemmas; HARD GATE fails for `CechHigherDirectImage.lean` — dispatch blueprint-writer
for those sub-lemmas before any prover is assigned. 0 phases have zero blueprint coverage;
no new chapter proposals required. All other findings (circularity fix, `\mathlibok` faithfulness,
unstarted phases) are clean.
