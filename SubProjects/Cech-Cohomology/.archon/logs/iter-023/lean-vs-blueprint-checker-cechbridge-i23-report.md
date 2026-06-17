# Lean ↔ Blueprint Check Report

## Slug
cechbridge-i23

## Iteration
023

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechBridge.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechComplex_hom_identification}` (chapter: `lem:cech_complex_hom_identification`)
- **Lean target exists**: yes (line 263)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.PresheafOfModules) : homCechComplex 𝒰 F ≅ sectionCechComplex (coverOpen 𝒰) F`; matches the blueprint's `Hom(K(𝒰)_•, F) ≅ Č•(𝒰, F)`.
- **Proof follows sketch**: yes — built via `alternatingCofaceMapComplex.mapIso` of `homCechSectionCosimplicialIso`, exactly the cosimplicial-natural-iso assembly path the blueprint prescribes.
- **Axioms**: `propext`, `Classical.choice`, `Quot.sound` — standard foundational axioms only.
- **notes**: All sub-declarations listed under this `\lean{...}` block (`homCechCosimplicial`, `homCechComplex`, `homCechSectionIsoApp`, `pi_mapIso_hom_eq` (private), `homCechSectionIsoApp_hom_π` (private), `freeYonedaHomAddEquiv_naturality` (private), `homCechSectionCosimplicialIso`) are present in the file and faithful.

### `\lean{AlgebraicGeometry.homCechComplexMapOpIso}` (chapter: `lem:cech_complex_op_identification`)
- **Lean target exists**: yes (line 338)
- **Signature matches**: yes — identifies `homCechComplex 𝒰 F` with `(preadditiveYoneda.obj F).mapHomologicalComplex (ComplexShape.up ℕ)).obj (HomologicalComplex.op (cechFreePresheafComplex 𝒰))`.
- **Proof follows sketch**: yes — `isoOfComponents` with identity components and `homCechComplex_d_eq` driving the differential squares.
- **Axioms**: standard only (transitively same as `cechComplex_hom_identification`).
- **notes**: Sub-declarations `homCechCosimplicial_δ` (private) and `homCechComplex_d_eq` (private) present and faithful.

### `\lean{AlgebraicGeometry.sectionCechComplexMapOpIso}` (chapter: `lem:section_cech_complex_mapop_iso`)
- **Lean target exists**: yes (line 360)
- **Signature matches**: yes — exactly `homCechComplexMapOpIso⁻¹ ≪≫ cechComplex_hom_identification`.
- **Proof follows sketch**: yes — one-line composition, matches blueprint.
- **notes**: `\leanok` present in blueprint block (line 2491). Clean.

### `\lean{AlgebraicGeometry.preadditiveYoneda_obj_preservesFiniteColimits_of_injective}` / `\lean{AlgebraicGeometry.quasiIso_map_preadditiveYoneda_of_injective}` (chapter: `lem:hom_into_injective_exact`)
- **Lean target exists**: yes (lines 398, 418)
- **Signature matches**: yes — `instance` for `PreservesFiniteColimits` for injective `I`, and `lemma` carrying `QuasiIso φ ⟹ QuasiIso (mapped-opposite-quasi-iso)`.
- **Proof follows sketch**: yes — uses `Injective.injective_iff_preservesEpimorphisms_preadditiveYoneda_obj` + `Functor.preservesFiniteColimits_iff_forall_exact_map_and_epi`, matches the blueprint's proof sketch.
- **notes**: General abelian-category context `C`, matches blueprint's generality.

### `\lean{AlgebraicGeometry.ses_cech_h1}` (chapter: `lem:ses_cech_h1`)
- **Lean target exists**: **no** — correctly absent. The name appears only in comments (lines 59, 431, 455, 481) but there is no `theorem ses_cech_h1` or `lemma ses_cech_h1` declaration in the file.
- **Signature matches**: N/A — not present.
- **Proof follows sketch**: N/A — not present.
- **notes**: Confirmed absent, not faked. The module header explicitly labels it `(planned)` and the remaining residual is pure sheaf theory (local-surjectivity + Grothendieck-topology gluing). No placeholder body.

### `\lean{AlgebraicGeometry.injective_cech_acyclic}` (chapter: `lem:injective_cech_acyclic`)
- **Lean target exists**: **no** — correctly absent (gated on Lane-1 `cechFreeComplex_quasiIso`). Module header labels it `(planned, gated on Lane-1)`.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: Confirmed absent, not faked. The assembly scaffolding (`sectionCechComplexMapOpIso`, `quasiIso_map_preadditiveYoneda_of_injective`) is fully in place.

---

## New declarations this iter (lean_aux — no blueprint block)

### `AlgebraicGeometry.sectionCech_objD_exact_of_isZero_homology` (line 456)
- **Type**: `theorem`; no `\lean{...}` blueprint annotation (lean_aux helper).
- **Statement**:
  ```
  {ι : Type u} (U : ι → Opens X) (F : X.PresheafOfModules) (q : ℕ)
  (h : IsZero ((sectionCechComplex U F).homology (q + 1))) :
  Function.Exact
    (ConcreteCategory.hom (AlternatingCofaceMapComplex.objD (sectionCechCosimplicial U F) q))
    (ConcreteCategory.hom (AlternatingCofaceMapComplex.objD (sectionCechCosimplicial U F) (q + 1)))
  ```
- **Statement faithful**: yes — pure homological algebra, the "extraction direction" converse of `sectionCech_isZero_homology_of_objD_exact` from CechAcyclic. Uses `exactAt_iff_isZero_homology` / `exactAt_iff'` / `ShortComplex.ab_exact_iff_function_exact`, the exact chain described in the blueprint's proof of `lem:section_cech_homology_exact`.
- **Axioms**: `[]` (none beyond Lean 4 kernel built-ins). Completely axiom-clean.
- **Role**: Provides the group-exact sequence that `sectionCech_one_coboundary_of_isZero_homology` consumes.

### `AlgebraicGeometry.sectionCech_one_coboundary_of_isZero_homology` (line 495)
- **Type**: `theorem`; no `\lean{...}` blueprint annotation (lean_aux helper).
- **Statement**:
  ```
  {ι : Type u} (U : ι → Opens X) (F : X.PresheafOfModules)
  (h : IsZero ((sectionCechComplex U F).homology 1))
  (c : ∀ σ : Fin 2 → ι, F.presheaf.obj (Opposite.op (⨅ k, U (σ k))))
  (hcoc : ∀ σ : Fin 3 → ι, ∑ i : Fin 3, (-1 : ℤ) ^ (i : ℕ) •
      ConcreteCategory.hom (sectionCechFaceRestr U F σ i)
        (c (σ ∘ (SimplexCategory.δ i).toOrderHom)) = 0) :
  ∃ t : ∀ σ : Fin 1 → ι, F.presheaf.obj (Opposite.op (⨅ k, U (σ k))),
    ∀ σ : Fin 2 → ι, c σ = ∑ i : Fin 2, (-1 : ℤ) ^ (i : ℕ) •
        ConcreteCategory.hom (sectionCechFaceRestr U F σ i)
          (t (σ ∘ (SimplexCategory.δ i).toOrderHom))
  ```
- **Statement faithful**: yes — precisely captures "Ȟ¹(𝒰, F) = 0 ⟹ every 1-cocycle is a coboundary", in the section coordinates of `sectionCechCosimplicial`. This is the `\uses{def:cech_complex}` Čech-algebra core of `lem:ses_cech_h1` isolated as a self-contained statement, exactly as the module docstring claims.
- **Axioms**: `propext`, `Classical.choice`, `Quot.sound` — standard Lean 4/Mathlib foundational axioms only. Effectively axiom-clean (no project-local axioms).
- **Proof correctness**: Proof uses `sectionCech_objD_exact_of_isZero_homology` (q=0), `sectionCechProductEquiv`, `sectionCech_objD_apply` — the same bridge machinery described in the blueprint's bridge discussion. The proof is complete and correct.
- **Relationship to `lem:ses_cech_h1`**: This is the Čech-algebra layer of `ses_cech_h1`. The remaining layer (local-surjectivity + sheaf gluing) is not yet formalized.

---

## Red flags

None.

- No `:= sorry` in the file.
- No excuse-comments (`-- TODO replace`, `-- temporary`, `-- placeholder`, `-- wrong but`).
- No project-local `axiom` declarations.
- No weakened-wrong definitions.

---

## Unreferenced declarations (informational)

| Declaration | Nature |
|---|---|
| `sectionCech_objD_exact_of_isZero_homology` | lean_aux helper for `ses_cech_h1`; substantive enough to note below (see Blueprint adequacy) |
| `sectionCech_one_coboundary_of_isZero_homology` | lean_aux core of `ses_cech_h1`; should be added to the blueprint's `\lean{...}` or `\uses{}` list |

Private helpers (`pi_mapIso_hom_eq`, `homCechSectionIsoApp_hom_π`, `freeYonedaHomAddEquiv_naturality`, `homCechCosimplicial_δ`, `homCechComplex_d_eq`) — all referenced in the corresponding `\lean{...}` blocks of the blueprint; none are orphaned.

---

## Blueprint adequacy for this file

- **Coverage**: 14/16 public declarations have a corresponding `\lean{...}` block in the chapter. The 2 unreferenced declarations (`sectionCech_objD_exact_of_isZero_homology`, `sectionCech_one_coboundary_of_isZero_homology`) are lean_aux helpers; `sectionCech_one_coboundary_of_isZero_homology` is substantive enough to warrant a blueprint reference.

- **Proof-sketch depth**: **under-specified** for two residual steps in `lem:ses_cech_h1`. The blueprint proof sketch (lines 2723–2745) is correct and complete at the informal level. The coboundary extraction step is now formalized (`sectionCech_one_coboundary_of_isZero_homology`). However, the remaining two sheaf-theoretic steps have no Lean API guidance:
  - *Local surjectivity extraction*: "surjectivity of G → H is a local condition" — the blueprint does not name the Mathlib lemma providing local lifts `s_i ∈ G(U_i)` from the short-exact-sequence hypothesis and the cover; `Sheaf.surjective_of_surjective_on_opens` or equivalent would be needed.
  - *Grothendieck topology gluing*: "by the sheaf condition they glue" — the blueprint does not name the Mathlib gluing API (`Sheaf.isSheaf_iff_isSheafOfCoverPreservingGrothendieckTopology`, `Presheaf.IsSheaf.glue`, or similar) that a prover would need.

- **Hint precision**: **loose** for the remaining `lem:ses_cech_h1` steps. The `\lean{AlgebraicGeometry.ses_cech_h1}` hint names the target correctly, but `\uses{def:cech_complex}` does not reference the new sub-lemmas `sectionCech_one_coboundary_of_isZero_homology` and `sectionCech_objD_exact_of_isZero_homology` that implement the coboundary core.

- **Generality**: matches need for all formalized declarations.

- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. **(major)** Add `\lean{AlgebraicGeometry.sectionCech_one_coboundary_of_isZero_homology, AlgebraicGeometry.sectionCech_objD_exact_of_isZero_homology}` either as a new lean_aux paragraph immediately before `lem:ses_cech_h1` or within its proof block, and add them to the `\uses{}` or a new `\lean{...}` annotation — so the next prover knows these exist and can import them.
  2. **(major)** Expand the proof of `lem:ses_cech_h1` with Lean API hints for the two remaining sheaf-theoretic steps: (a) local-surjectivity extraction (name the relevant Mathlib lemma for local lifts from a SES of sheaves), and (b) Grothendieck-topology gluing (name the Mathlib sheaf-gluing API). The prose is correct but too thin to guide a prover to the right Mathlib calls without substantial search.

---

## Severity summary

| Finding | Severity |
|---|---|
| `ses_cech_h1` absent on Lean side | ✓ CORRECT — not a defect |
| `injective_cech_acyclic` absent on Lean side | ✓ CORRECT — gated on Lane-1 |
| Two new declarations axiom-clean, faithful, correct | ✓ PASS |
| No sorries, no excuse-comments, no project axioms | ✓ PASS |
| `sectionCech_one_coboundary_of_isZero_homology` not in any `\lean{...}` block | **major** — missing reference for a substantive lean_aux helper that is the Čech core of `ses_cech_h1`; a blueprint-writing subagent should add it |
| `lem:ses_cech_h1` proof sketch missing Lean API for local-surjectivity + sheaf-gluing steps | **major** — under-specified for the remaining formalization; a blueprint-writing subagent should expand these two steps with Mathlib API hints |
| `sectionCech_objD_exact_of_isZero_homology` not in any `\lean{...}` block | **minor** — smaller helper, but worth a blueprint mention |

**Overall verdict**: CechBridge.lean iter-023 is clean and faithful — 2 new axiom-free lean_aux theorems correctly implement the Čech-algebra core of `ses_cech_h1` without faking `ses_cech_h1` itself; the two **major** findings are blueprint-side only (missing `\lean{...}` reference for the coboundary core helper, and under-specified API guidance for the remaining sheaf-theoretic steps).
