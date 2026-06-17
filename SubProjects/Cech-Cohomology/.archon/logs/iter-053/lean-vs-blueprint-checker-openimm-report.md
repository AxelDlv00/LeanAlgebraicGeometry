# Lean ↔ Blueprint Check Report

## Slug
openimm

## Iteration
053

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant block: `\label{lem:open_immersion_pushforward_comp}`, lines 7469–7559)

---

## Per-declaration

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_acyclic}` (chapter: `lem:open_immersion_pushforward_comp` part 1)

- **Lean target exists**: yes (line 71)
- **Signature matches**: yes
  - Blueprint: "for all q ≥ 1 and every quasi-coherent H, R^q j_* H = 0"
  - Lean: `(hq : 0 < q) → IsZero (higherDirectImage j q H)` with `[IsOpenImmersion j] [IsAffine U] [X.IsSeparated] (hH : H.IsQuasicoherent)`
  - Match is exact: `0 < q` for "q ≥ 1", `IsZero` for "= 0", quasi-coherence hypothesis present.
- **Proof follows sketch**: partial
  - The Lean applies `IsZero.of_iso` with `higherDirectImage_iso_sheafify_presheafHomology j q (injectiveResolution H)`, correctly following the blueprint's route via `lem:higher_direct_image_presheaf`.
  - The remaining `sorry` (line 87) honestly labels the sheafification-vanishing step as a "RESIDUAL (genuine cohomological gap)". The comment identifies the three sub-steps needed (affine preimage identification, Serre vanishing, locally-zero site). This is an honest partial proof, not a fake body.
  - The reduction IS consistent with the blueprint proof sketch.
- **Notes**:
  - Body is `sorry` after a genuine first reduction step. Must-fix per severity rules.

---

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` (chapter: `lem:open_immersion_pushforward_comp` part 2)

- **Lean target exists**: yes (line 104)
- **Signature matches**: **partial — weakened return type**
  - Blueprint: "for every k ≥ 0, R^k f_*(j_* H) **≅** R^k g_* H" — a canonical (specified) isomorphism.
  - Lean: `Nonempty (higherDirectImage f k ((pushforward j).obj H) ≅ higherDirectImage (j ≫ f) k H)`
  - `Nonempty (A ≅ B)` is strictly weaker than `A ≅ B`. The blueprint says "canonical isomorphism", which in Lean should be a direct `A ≅ B` value (a named, constructible morphism), not mere non-constructive existence. Downstream consumers in `CechHigherDirectImage.lean` will need to extract the iso, and `Nonempty` makes this impossible without `Classical.choice`.
- **Proof follows sketch**: partial
  - The `sorry` (line 128) is annotated with three explicit residuals (j_*-acyclicity, f_*-acyclicity extension, acyclic-resolution comparison), consistent with the blueprint's part (2) argument structure.
  - The structural comment correctly names `pushforwardComp j f` as the `f_* ∘ j_* = (f∘j)_*` transport, matching the blueprint's last equality.
- **Notes**:
  - **Signature mismatch** (Nonempty weakening) + sorry body → two must-fix findings.

---

## Unreferenced declarations (informational)

### `isAffineHom_of_affine_separated` (private, line 63)

- Not `\lean{}`-referenced. This is expected for a private helper.
- The blueprint prose at line 7488 states: "j is an affine morphism (an open immersion of an affine open into a separated scheme)", justifying the helper's existence.
- The Lean proof via `IsAffineHom.of_comp j (terminal.from X)` is a faithful rendering of the separatedness argument (uses `hg : IsSeparated (terminal.from X)` and `hcomp : IsAffineHom (j ≫ terminal.from X)` via `terminal.hom_ext`).
- No issue. Helper should perhaps be promoted to a named lemma in the blueprint if it turns out to be reused (currently single-use).

---

## Red flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.higherDirectImage_openImmersion_acyclic` at line 87: body ends in `sorry` after one genuine reduction step. Blueprint claims a substantive theorem. **must-fix-this-iter**.
- `AlgebraicGeometry.higherDirectImage_openImmersion_comp` at line 128: body is `sorry` throughout (no genuine reduction steps, only structural commentary). Blueprint claims a substantive theorem. **must-fix-this-iter**.

### Signature mismatches

- `AlgebraicGeometry.higherDirectImage_openImmersion_comp` at line 104–108: return type is `Nonempty (A ≅ B)` where the blueprint claims a canonical isomorphism `A ≅ B`. Using `Nonempty` is a deliberate weakening; it cannot produce a specific iso for downstream uses and precludes constructive composition. **must-fix-this-iter**.

### Excuse-comments
- None. The `-- RESIDUAL ...` comments accurately describe genuine mathematical dependencies, not excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims
- None.

---

## Blueprint adequacy for this file

- **Coverage**: 2/2 public Lean declarations are covered by `\lean{...}` in one combined block (`lem:open_immersion_pushforward_comp`). The private helper `isAffineHom_of_affine_separated` is acceptably unreferenced.
- **Proof-sketch depth**: **under-specified for Lean formalization** — three concrete bridges needed by the prover are unnamed in the chapter:
  1. **Presheaf-homology ↔ absolute-cohomology identification**: `higherDirectImage_iso_sheafify_presheafHomology` gives an iso to `sheafify(V ↦ H^q((j_* I•)(V)))`, not to `sheafify(V ↦ H^q(j⁻¹V, H))`. To apply `affine_serre_vanishing` (which acts on the latter), the prover needs a bridge lemma identifying the two forms. The `lem:higher_direct_image_presheaf` block notes this identification is "supplied at point of use" but does NOT name a Lean lemma. The `lem:open_immersion_pushforward_comp` proof sketch likewise does not name it. The prover is left to build this bridge with no blueprint pointer.
  2. **Serre-vanishing transport to general affine opens**: `affine_serre_vanishing` in `AffineSerreVanishing.lean` (line 521) lives on `Spec R` (the standard affine), not on a general affine scheme. To apply it to `j⁻¹(V) ≅ Spec Γ(j⁻¹V)` one needs a `Spec`-transport. The blueprint says "for affine V the preimage j⁻¹(V) is affine, on which the Serre vanishing kills H^q" without naming the transport step.
  3. **Locally-zero sheafification site lemma**: the blueprint says "since affine opens form a basis, the presheaf homology is locally zero and its sheafification vanishes" — but does not name the site lemma (`isZero_presheafToSheaf_obj_of_isLocallyBijective` or similar) that formalizes this step. The Lean doc-comment (lines 60–62) names `isZero_presheafToSheaf_obj_of_isLocallyBijective` as an import from `CechHigherDirectImage.lean`, but the blueprint does not name it.
- **Hint precision**: **loose** — both `\lean{}` hints in `lem:open_immersion_pushforward_comp` correctly name the Lean declarations, but the `\uses{}` list (`lem:affine_serre_vanishing, lem:higher_direct_image_presheaf`) understates the bridges needed to actually connect those lemmas. The chain from the Lean form of `higherDirectImage_iso_sheafify_presheafHomology` to the Lean form of `affine_serre_vanishing` requires three intermediate steps not captured in the blueprint.
- **Generality**: matches need — the statements in both blueprint and Lean cover the required generality.
- **Recommended chapter-side actions**:
  - Add a `\lean{...}` pointer in the `lem:open_immersion_pushforward_comp` proof sketch for the presheaf-homology identification lemma (whatever `HigherDirectImagePresheaf.lean` eventually names it).
  - Add a note or sublemma for the Serre-vanishing transport step: either a reference to the `Spec Γ` iso transport or promote `isAffineHom_of_affine_separated` to a named `\lean{...}` block with the transport wrapped in.
  - Name the locally-zero site lemma (`isZero_presheafToSheaf_obj_of_isLocallyBijective`) explicitly in the part (1) proof sketch so the prover can find it.

---

## Severity summary

| Finding | Location | Severity |
|---|---|---|
| `sorry` body, substantive claim | `higherDirectImage_openImmersion_acyclic` line 87 | **must-fix-this-iter** |
| `sorry` body, substantive claim | `higherDirectImage_openImmersion_comp` line 128 | **must-fix-this-iter** |
| `Nonempty (A ≅ B)` instead of canonical `A ≅ B` | `higherDirectImage_openImmersion_comp` line 108 | **must-fix-this-iter** |
| Blueprint under-specified: 3 bridges unnamed in proof sketch | `lem:open_immersion_pushforward_comp` (lines 7511–7559) | **must-fix-this-iter** |
| `isAffineHom_of_affine_separated` unreferenced (private helper) | private, line 63 | minor (consider promoting if reused) |

**Overall verdict**: Both public theorems have sorry bodies (must-fix), and `higherDirectImage_openImmersion_comp` additionally weakens the return type to `Nonempty`; the blueprint proof sketch, while mathematically sound, leaves three concrete Lean bridges unnamed — making it insufficient to close either sorry without additional blueprint detail.
