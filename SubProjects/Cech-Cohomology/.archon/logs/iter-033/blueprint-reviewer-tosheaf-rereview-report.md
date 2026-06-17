# Blueprint Review Report

## Slug
tosheaf-rereview

## Iteration
033

## Scope
Fast-path scoped re-review of `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`,
Gate-1 toSheaf chain only.

---

## Per-chapter (scoped)

### `lem:toSheaf_preservesFiniteColimits` (L3507–3562) — CLEARS

**complete**: true
**correct**: true
**notes**:
- `\uses{lem:sheafificationCompToSheaf_mathlib, lem:mod_pmod_adjunction}` present on both statement
  (L3510) and proof (L3519) blocks. ✓
- Step 1 (composite L ∘ toSheaf R preserves finite colimits via the square iso): logically sound.
  `toPresheaf R₀` preserves finite colimits (objectwise); `sheafify_Ab` is a left adjoint (preserves
  all colimits); their composite is iso to L ∘ toSheaf R by `lem:sheafificationCompToSheaf_mathlib`. ✓
- Step 2 three-clause descent: (i) counit is a natural iso (from `lem:mod_pmod_adjunction`), (ii) iso
  `toSheaf R ≅ ι ∘ (L ∘ toSheaf R)` by whiskering, (iii) retract concludes. ✓
- **Minor imprecision in (iii)** — "Applying this with F = toSheaf R and G = L ∘ toSheaf R" mixes
  domains: G = L ∘ toSheaf R (diagrammatic) has domain `PreMod`, while F = toSheaf R has domain
  `Mod(R)`. The technically correct formulation uses G′ = ι ∘ (L ∘ toSheaf R) : Mod(R) → Sh(Ab)
  (as used in (ii)), and then shows the comparison map for F is iso by factoring through G′ and
  applying Step 1 to the ι-image of each finite diagram. The underlying argument is correct (all
  ingredients named); a prover can reconstruct the precise formalization. **Soon-level finding only**
  — does not block the prover lane.

### `lem:to_sheaf_preserves_epi` (L3564–3583) — clean ✓

**complete**: true
**correct**: true

`\uses{lem:toSheaf_preservesFiniteColimits, lem:preservesEpi_of_preservesColimitsOfShape_mathlib}` on
both statement and proof. One-step proof (finite colimits → WalkingSpan colimits → epi preservation).
No issues.

### `lem:affine_surj_of_vanishing` (L3415–3473) — clean ✓

**complete**: true
**correct**: true

`\uses` list correct; three-step proof (local surjectivity via `lem:to_sheaf_preserves_epi` →
refinement to standard cover → apply `lem:ses_cech_h1`) sound and detailed. No issues.

### `def:affine_cover_system` (L3711–3738) — clean ✓

**complete**: true
**correct**: true

Three proof-fields all wired to their respective lemmas
(`lem:affine_faces_mem`, `lem:affine_surj_of_vanishing`, `lem:injective_cech_acyclic`). No issues.

---

## Dependency check

`leandag build --json` reports **0 unknown_uses** across the whole blueprint. All `\uses{}` edges in
the toSheaf chain resolve cleanly.

Relevant label existence confirmed:
- `lem:mod_pmod_adjunction` defined at L2549 (`\mathlibok`, Lean: `PresheafOfModules.sheafificationAdjunction`) ✓
- `lem:sheafificationCompToSheaf_mathlib` defined at L3476 (`\mathlibok`, Lean: `PresheafOfModules.sheafificationCompToSheaf`) ✓
- `lem:preservesEpi_of_preservesColimitsOfShape_mathlib` defined at L3495 (`\mathlibok`) ✓

---

## Severity summary

**Severity summary: HARD GATE CLEARS — no must-fix findings.**

One soon-level finding:
- `lem:toSheaf_preservesFiniteColimits` / Step 2(iii): G's domain is stated as `PreMod` (from Step 1)
  but the retract principle requires G : Mod(R) → Sh(Ab). The correct formulation uses G′ = ι ∘ G
  (diagrammatic), which is naturally iso to toSheaf R via (ii). Suggest a writer note for future
  cleanup; does not block formalization since all ingredients are named.

---

## Overall verdict

Gate 1 (`AffineSerreVanishing.lean`) **CLEARS**. `lem:toSheaf_preservesFiniteColimits` is
`complete: true` + `correct: true` with no must-fix; the chain
(`lem:to_sheaf_preserves_epi` → `lem:affine_surj_of_vanishing` → `def:affine_cover_system`) is
clean. The prover lane on `AffineSerreVanishing.lean` is cleared to dispatch this iter.
