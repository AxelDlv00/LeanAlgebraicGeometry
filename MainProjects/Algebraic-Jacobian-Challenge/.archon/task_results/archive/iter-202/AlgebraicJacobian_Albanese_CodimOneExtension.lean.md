# AlgebraicJacobian/Albanese/CodimOneExtension.lean

## Summary
- **Declarations added (4, all axiom-clean):**
  - `exists_submersivePresentation_of_isStandardSmoothOfRelativeDimension` (B.a) — `private theorem`
  - `isLocalization_atPrime_stalk_of_affineOpen` (B.b) — public `theorem`
  - `open_eq_top_of_subsingleton` (B.c helper) — `private lemma`
  - `gammaSpecField_ringEquiv` (B.c) — public `noncomputable def`
  All inserted in a new delimited section `§3.B` (after
  `exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`, before
  `isRegularLocalRing_stalk_of_smooth`).
- **Declarations blocked (0 newly attempted-and-failed):** B.d (regular-stalk
  close) NOT added — genuinely gated (see below); not added as a sorried decl
  per the no-sorry invariant.
- **Sorry count:** 3 → 3 (unchanged; L1262/L1459/L1534, the pre-existing
  `isRegularLocalRing_stalk_of_smooth` / `extend_of_codimOneFree_of_smooth` /
  `indeterminacy_pure_codim_one_into_grpScheme` gaps). 0 sorries added.
- **Build:** GREEN (`lean_diagnostic_messages` severity=error → `[]`).
- **HARD BAR (≥2 of B.a/b/c/d axiom-clean):** MET and exceeded — B.a, B.b, B.c
  all axiom-clean (3 of the 4 sub-bridges; B.c landed as 2 declarations).

## B.a — `exists_submersivePresentation_of_isStandardSmoothOfRelativeDimension`
- **Approach:** 1-line re-export of `Algebra.IsStandardSmoothOfRelativeDimension.out`.
  Statement returns `∃ (ix sx : Type), ∃ (_ : Finite sx) (_ : Finite ix),
  ∃ P : Algebra.SubmersivePresentation R S ix sx, P.dimension = n`.
- **API note:** the `.out` field fixes `ix sx : Type` (Type 0); stating with
  `Type*`/`Type u` gives a universe mismatch (`Exists.{2}` vs `Exists.{u+1}`).
  Use `Type` exactly.
- **Result:** RESOLVED — axiom-clean `{propext, Classical.choice, Quot.sound}`.

## B.b — `isLocalization_atPrime_stalk_of_affineOpen`
- **Approach:** re-export of `IsAffineOpen.isLocalization_stalk` with the
  section-stalk algebra instance `TopCat.Presheaf.algebra_section_stalk` set up via
  `letI`. Decouples the Stage-3 `IsLocalization.AtPrime` witness from
  standard-smoothness so it is callable as a standalone substrate fact.
- **Result:** RESOLVED — axiom-clean (verified by `lean_verify`).

## B.c — `open_eq_top_of_subsingleton` + `gammaSpecField_ringEquiv`
- **Approach:**
  - `open_eq_top_of_subsingleton`: a scheme with `[Subsingleton X]` carrier has
    every nonempty open `= ⊤` (`Subsingleton.elim` + `Opens.ext`).
  - `gammaSpecField_ringEquiv`: `Spec (.of kbar)` has subsingleton carrier
    (`PrimeSpectrum.instUnique` for a field, picked up automatically as
    `Subsingleton (Spec (.of kbar))`); `subst` `U = ⊤`, then
    `Scheme.ΓSpecIso (.of kbar) : Γ(Spec (.of kbar), ⊤) ≅ .of kbar` →
    `CategoryTheory.Iso.commRingCatIsoToRingEquiv` gives the `≃+* kbar`.
- **Result:** RESOLVED — both axiom-clean (`gammaSpecField_ringEquiv` verified by
  `lean_verify`; `open_eq_top_of_subsingleton` confirmed by `#print axioms` in an
  isolated `lean_run_code` run under the file's exact `open` context).
- **Why public:** `isLocalization_atPrime_stalk_of_affineOpen` and
  `gammaSpecField_ringEquiv` are generic Mathlib-shaped facts a future in-file /
  cross-file consumer may want; the rest are `private`.

## B.d — Regular-stalk close (NOT ADDED)
- **Status:** NOT ADDED. Genuinely gated, not a search failure.
- **Why blocked:**
  1. **Step A1 fenced** (SCOPE FENCE): the Matsumura Jacobian-regular-sequence
     witness depends on the iter-202 Lane AB `private`→public promotions of
     `isDomain_of_regularLocal` + `regularLocal_quotient_isRegularLocal_of_notMemSq`
     which are not yet visible cross-file this iter. Per directive, this iter must
     leave Step A1 as the iter-203 obligation.
  2. **Sub-gap (ii.B) open**: even with B.a–B.c in hand, closing
     `IsRegularLocalRing (X.left.presheaf.stalk z)` needs the smooth-algebra
     Krull-dim formula (Stacks 00OE, `ringKrullDim Sₘ = n`), a ~200–300 LOC project
     gap. The closed-point residue-field route
     `finrank_cotangentSpace_of_bijective_algebraMap_residue` (which B.c's
     `Γ = kbar` bridge would feed) is **not applicable to a general codim-1 point
     z** — the residue field of the stalk at a codim-1 point is a
     transcendence-degree-1 extension of `kbar`, not `kbar`, so the bijective
     `algebraMap kbar (ResidueField (stalk z))` hypothesis fails. The body docstring
     already records this at the old L1151–L1166.
- **No-sorry invariant:** the PUSH-BEYOND "L1061 inline-closure skeleton with Step
  A1 as a typed sorry" would require adding a sorried declaration / new sorry in
  the body, which the prover-mode invariant forbids. Deferred to iter-203 when the
  AB promotions land and Step A1 can be attempted as a fully-proved witness.
- **Informal agent:** MOONSHOT_API_KEY is set, but the blocker is structural (a
  fenced lane + a known multi-hundred-LOC Mathlib gap), not a missing-lemma search
  problem — an informal sketch would not change the fence. Not consulted.

## Blueprint markers (for the review/sync agent)
- `lem:smooth_to_regular_local_ring` (`isRegularLocalRing_stalk_of_smooth`)
  remains gated (sorry at L1262); do not `\leanok` its proof.
- The new B.a/B.b/B.c bridges are project-local substrate not separately pinned in
  the blueprint; they live under `\subsec:stage6_iib_substrate_iter200` /
  `\cref{lem:stage6_regular_stalk_assembly}` conceptually. No blueprint pin needed;
  optionally the plan agent may add a one-line note that the Step B bridges landed.

## Why I stopped
- **Real progress:** 4 axiom-clean declarations added (CodimOneExtension.lean,
  new §3.B section ~L959 onward):
  - `exists_submersivePresentation_of_isStandardSmoothOfRelativeDimension`
  - `isLocalization_atPrime_stalk_of_affineOpen`
  - `open_eq_top_of_subsingleton`
  - `gammaSpecField_ringEquiv`
  HARD BAR (≥2 of B.a/b/c/d) exceeded: B.a, B.b, B.c all landed axiom-clean.
- **Partial:** B.d not added — blocked by (i) the fenced Step A1 (iter-203 AB
  promotion dependency) and (ii) the open Stacks-00OE Krull-dim formula sub-gap
  (ii.B), with the closed-point residue route provably inapplicable to general
  codim-1 z. Adding a sorried skeleton would violate the no-sorry invariant.
- **Next step (iter-203):** with the Lane AB promotions visible, build the Step A1
  Matsumura witness `matsumura_isRegular_of_linearIndependent_cotangent` (recipe in
  blueprint `\subsec:stage6_iib_substrate_iter200` L749+), then assemble B.d
  consuming B.a (presentation), B.b (stalk localisation), and the iter-200 capstone
  `ringKrullDim_localization_atMaximal_MvPolynomial`.
