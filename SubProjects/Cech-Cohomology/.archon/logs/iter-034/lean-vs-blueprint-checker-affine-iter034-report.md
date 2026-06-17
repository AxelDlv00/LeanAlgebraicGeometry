# Lean ↔ Blueprint Check Report

## Slug
affine-iter034

## Iteration
034

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (§ "The affine instantiation (Tag 02KG)", roughly lines 3299–3743)

---

## Per-declaration

### `\lean{AlgebraicGeometry.toSheaf_preservesFiniteColimits}` (chapter: `lem:toSheaf_preservesFiniteColimits`)

- **Lean target exists**: yes — line 114
- **Signature matches**: yes. Blueprint: "forgetful functor `toSheaf R` preserves finite colimits." Lean: `PreservesFiniteColimits (SheafOfModules.toSheaf.{v'} R)`. Direct match.
- **Proof follows sketch**: partial. Blueprint describes a "retract" argument in three sub-clauses (counit iso → toSheaf is retract of composite → retract of preserving = preserving). Lean instead uses `isColimitOfPreserves` twice and `preservesColimit_of_iso_diagram` to transfer the colimit structure diagram-by-diagram. Mathematically equivalent: Step 1 (composite `L ⋙ toSheaf` preserves finite colimits via `sheafificationCompToSheaf`) and Step 2 (descent via `F ≅ (F ⋙ forget) ⋙ L` using the counit iso) are both present; only the closing step uses a different Lean API. No mathematical content is missing.
- **Axioms** (via `lean_verify`): `propext, Classical.choice, Quot.sound` — standard. Axiom-clean.
- **notes**: `\leanok` marker is **absent** from both the statement and proof blocks in the blueprint chapter. The declaration is new this iteration and axiom-clean; this is a sync_leanok artifact (markers should be added on the next sync_leanok run). No `sorry` present.

---

### `\lean{AlgebraicGeometry.toSheaf_preservesEpimorphisms}` (chapter: `lem:to_sheaf_preserves_epi`)

- **Lean target exists**: yes — line 146
- **Signature matches**: yes. Blueprint: "forgetful functor preserves epimorphisms." Lean: `.PreservesEpimorphisms` instance. Direct match.
- **Proof follows sketch**: yes. Blueprint: "(1) toSheaf preserves finite colimits, hence preserves WalkingSpan colimits; (2) a functor preserving pushouts preserves epimorphisms." Lean: `(toSheaf_preservesFiniteColimits R).preservesFiniteColimits WalkingSpan` followed by `preservesEpimorphisms_of_preservesColimitsOfShape`. One-to-one match.
- **Axioms** (via `lean_verify`): `propext, Classical.choice, Quot.sound` — axiom-clean.
- **notes**: `\leanok` marker **absent** from both statement and proof blocks — same sync_leanok artifact as above.

---

### `\lean{AlgebraicGeometry.affine_surj_of_vanishing}` (chapter: `lem:affine_surj_of_vanishing`)

- **Lean target exists**: yes — line 228
- **Signature matches**: yes. Blueprint: surjectivity of `S₂(Df) → S₃(Df)` for a SES whose left term has vanishing standard-cover Čech cohomology. Lean: `Function.Surjective (ConcreteCategory.hom (presheaf-map S.g at Df))` under hypothesis `∀ n g q, 0 < q → IsZero (cechCohomology (fun i => D(g i.down)) X₁ q)`. Match.
- **Proof follows sketch**: yes. Steps 1–3 are all present and correspond exactly: (1) epi → `toSheaf_preservesEpimorphisms` → abelian-sheaf epi → `isLocallySurjective_iff_epi'` → local surjectivity; (2) `standard_cover_cofinal` to refine the local cover to a standard family `D(gᵢ)`; (3) `ses_cech_h1` to glue. Blueprint and Lean align step-by-step.
- **Axioms**: axiom-clean.
- **notes**: `\leanok` correctly present on both statement block (line 3417) and proof block (line 3449). Blueprint prose says `V ∈ B` (a distinguished open); Lean uses a specific `f : R` with `V = D(f)`. The `hvanish` hypothesis in Lean is over `ULift (Fin n)`-indexed families — this is consistent with `Cov` in `affineCoverSystem`.

---

### `\lean{AlgebraicGeometry.affineCoverSystem}` (chapter: `def:affine_cover_system`)

- **Lean target exists**: yes — line 361, `noncomputable def affineCoverSystem`
- **Signature matches**: **partial** — see "Red flags" below.
- **Proof follows sketch**: yes. The three proof fields are discharged exactly as the blueprint states: `faces_mem` ← `affine_faces_mem`; `surj_of_vanishing` ← `affine_surj_of_vanishing`; `injective_acyclic` ← `injective_cech_acyclicFam` (family-form, cover-agnostic, consistent with the `\uses{}` pointing to `lem:injective_cech_acyclic`).
- **Axioms**: axiom-clean.
- **notes**: `\leanok` correctly present on the statement block (line 3716). The `injective_acyclic` field is discharged by `injective_cech_acyclicFam` (the Lane-A cover-agnostic version from iter-031), not by `affine_injective_acyclic` (which needs a spanning hypothesis). Blueprint's `\uses{}` lists `lem:injective_cech_acyclic` directly, which is consistent with the Lean's choice; the NOTE comment in the blueprint chapter correctly documents this. No mismatch here.

---

## Red flags

### Cov scope mismatch — blueprint prose vs. Lean definition

**Classification: major**

The blueprint definition `def:affine_cover_system` (line 3735–3737) describes `Cov` as:

> "the standard open covers (finite coverings of a distinguished open by distinguished opens)"

The Lean definition of `Cov` is:
```lean
Cov := { c : CovDatum (Spec R) | ∃ (n : ℕ) (g : Fin n → R),
    c = ⟨ULift.{u} (Fin n), fun i => PrimeSpectrum.basicOpen (g i.down)⟩ }
```

This is **all finite families of distinguished opens** — no covering condition is required. A `c ∈ Cov` need not cover any particular open. The covering condition is established on-the-fly inside `affine_surj_of_vanishing` (via `standard_cover_cofinal`), not encoded in `Cov`.

**Why this is a mismatch, not just different phrasing:** With the Lean's broader `Cov`, `HasVanishingHigherCech (affineCoverSystem R) F` requires vanishing over every finite basic-open family (not just covering ones). This is a stronger demand than the blueprint's "standard open covers" would imply. The demand is satisfiable for quasi-coherent sheaves (because sections over `D(g₁ ⋯ gₙ)` equal the localized module, which is exact), so the broader `Cov` is mathematically sound. However, a reader of the blueprint would believe `Cov` requires a covering condition that the Lean code does not enforce.

**Recommended writer action:** Update the blueprint prose to:
- State that `Cov` consists of **all finite families of distinguished opens**, indexed by `ULift (Fin n)`, without a covering condition.
- Add a NOTE explaining that the covering condition is established inside `surj_of_vanishing`'s proof (via `standard_cover_cofinal`), not carried by membership in `Cov`.

The prover flagged this in the directive; confirming it is a real prose-level mismatch requiring a blueprint-writer fix. It does not block the Lean, but it does misrepresent the structure.

---

### Missing `\leanok` markers

**Classification: minor** (sync_leanok artifact)

Both `lem:toSheaf_preservesFiniteColimits` (lines 3510–3565) and `lem:to_sheaf_preserves_epi` (lines 3567–3585) have no `\leanok` on their statement or proof blocks. `lean_verify` confirms both are axiom-clean. These are new declarations this iteration; the markers should be added by the next sync_leanok run. No action required from the blueprint writer or prover.

---

## Unreferenced declarations (informational)

All declarations in `AffineSerreVanishing.lean` have corresponding `\lean{...}` references in the blueprint chapter:

| Lean declaration | Blueprint label |
|---|---|
| `affine_faces_mem` | `lem:affine_faces_mem` |
| `coverOpen_affineOpenCoverOfSpan` | `lem:cover_datum_bridge` |
| `affine_injective_acyclic` | `lem:affine_injective_acyclic` |
| `standard_cover_cofinal` | `lem:standard_cover_cofinal` |
| `toSheaf_preservesFiniteColimits` | `lem:toSheaf_preservesFiniteColimits` |
| `toSheaf_preservesEpimorphisms` | `lem:to_sheaf_preserves_epi` |
| `affine_surj_of_vanishing` | `lem:affine_surj_of_vanishing` |
| `affineCoverSystem` | `def:affine_cover_system` |

Coverage: 8/8. No unreferenced substantive declarations.

---

## Blueprint adequacy for this file

- **Coverage**: 8/8 Lean declarations have a corresponding `\lean{...}` block. 0 unreferenced substantive declarations.
- **Proof-sketch depth**: adequate. All three steps of `affine_surj_of_vanishing` are spelled out precisely enough to guide formalization; the `toSheaf_preservesFiniteColimits` two-step sketch is complete; the one-liner `toSheaf_preservesEpimorphisms` needs no elaboration. The `affineCoverSystem` fields are discharged by named sub-lemmas.
- **Hint precision**: precise. Each `\lean{...}` tag names the correct fully-qualified declaration and the correct Mathlib predicate.
- **Generality**: matches need, with one caveat: the `Cov` description is narrower in the blueprint prose than in the Lean code (see "Red flags"). The Lean is more general; the blueprint should be updated to match, not the other way around.
- **Recommended chapter-side actions**:
  1. **[major]** Update `def:affine_cover_system` prose to describe `Cov` as "all finite families of basic opens" (no covering condition), and add a NOTE that the covering condition is enforced inside `surj_of_vanishing`.
  2. **[minor]** Wait for sync_leanok to add `\leanok` to `lem:toSheaf_preservesFiniteColimits` (statement + proof) and `lem:to_sheaf_preserves_epi` (statement + proof) — no manual writer action needed.
  3. **[minor]** `lem:toSheaf_preservesFiniteColimits` proof sketch describes a "retract" argument, but the Lean uses `isColimitOfPreserves` + `preservesColimit_of_iso_diagram`. The mathematical content is the same. If a future reader might be confused, the blueprint writer could add an alternative description along the lines of "equivalently, for each finite diagram F, transfer the colimit cocone via F ≅ (F ⋙ forget) ⋙ L using `preservesColimit_of_iso_diagram`". Low priority.

---

## Severity summary

- **must-fix-this-iter**: none. No placeholder bodies, no sorry, no axiom additions, no wrong signatures, no excuse-comments, no vacuous definitions.
- **major**: `def:affine_cover_system` prose description of `Cov` is narrower than the Lean code (says "finite coverings of a distinguished open"; Lean has "all finite families of basic opens" with no covering condition). Blueprint writer should update prose before this definition is referenced in downstream exposition.
- **minor**: missing `\leanok` on `lem:toSheaf_preservesFiniteColimits` and `lem:to_sheaf_preserves_epi` (sync_leanok artifact; both axiom-clean); proof sketch for `toSheaf_preservesFiniteColimits` uses different (equivalent) mechanization than the "retract" argument in the blueprint.

**Overall verdict:** All four declarations are axiom-clean, correctly signed, and faithfully formalize their blueprint counterparts; the sole writer action needed is updating the `Cov` prose in `def:affine_cover_system` — 8 declarations checked, 0 must-fix red flags.
