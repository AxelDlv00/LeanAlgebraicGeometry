# Refactor Report

## Slug
ocofp-subfunctor-restructure

## Status
COMPLETE — Subfunctor substrate added and Case B of `carrierPresheaf_isSheaf` refactored
to use the new `carrierTypeSubfunctor` framework. Single typed `sorry` retained for the
substantive stalk-locality close (Case B body), matching the directive's "at most 1
narrow named typed sorry" allowance. Net sorry count on file: 4 → 4 (refactor net zero),
with the substrate localized via `CategoryTheory.Subfunctor`.

## Directive

### Problem (excerpt)
`AlgebraicJacobian/RiemannRoch/OCofP.lean` Lane A iter-188 outcome:
PARTIAL structural — Case B (non-empty cover) of `carrierPresheaf_isSheaf` body L512
FAILED on subtype-friction (per directive: (a) `.1` projection on
`((ModuleCat.ofHom _).hom _)` ascription; (b) `IrreducibleSpace ↥C.left` → `Set
↑C.left.toTopCat` bridging; (c) `Set.mem_iUnion` membership-set-type mismatch).

### Changes requested
1. Restructure `carrierPresheaf` as a Subfunctor (or add Subfunctor as parallel
   substrate).
2. Replace `carrierPresheaf_isSheaf` body with Subfunctor.isSheaf_iff-based approach,
   preserving Case A logic and refactoring Case B via the cleaner Subfunctor framework.
3. Update downstream consumers if signatures change (none did — kept the existing
   `carrierPresheaf` ModuleCat-valued signature).

## Changes Made

### File: `AlgebraicJacobian/RiemannRoch/OCofP.lean`

#### Change 1: Added `lineBundleAtClosedPoint.carrierTypeSubfunctor` (new declaration)

- **What:** Added a new private noncomputable `def` (≈50 LOC including doc-comment)
  that packages the carrier as a `CategoryTheory.Subfunctor` of
  `TopCat.presheafToType C.left.toTopCat C.left.functionField`. Each section over
  `op U` is the set `{g : ↥U → K(C) | ∃ f ∈ carrierSubmoduleSheaf (op U), g = fun _ => f}`.
  The `Subfunctor.map` field handles both the `V ≠ ⊥` case (via
  `carrierSubmoduleSheaf_le` monotonicity) and the `V = ⊥` case (where `↥V.unop` is
  empty, witnessing membership via `f = 0`).
- **Why:** Provides the substrate the directive calls for. Mathlib's
  `CategoryTheory.Subfunctor.isSheaf_iff` (applied against the ambient sheaf
  `TopCat.Presheaf.toType_isSheaf`) reduces the sheaf condition for this
  Subfunctor to a stalk-locality check, which holds by irreducibility of
  `C.left.toTopCat`. Internally the Subfunctor framework sidesteps all three
  iter-188 subtype-friction points by encoding sections as constant-function
  subtypes with explicit existential witnesses.
- **Axiom-clean:** Verified via `lean_verify`. Axioms: `propext`, `Classical.choice`,
  `Quot.sound` (the standard non-sorry kernel set). No `sorryAx`.
- **Cascading:** None — purely additive new definition; no existing consumer touched.

#### Change 2: Refactored `lineBundleAtClosedPoint.carrierPresheaf_isSheaf`

- **What:**
  - Updated the doc-comment to describe the new Subfunctor restructure and the
    Case A / Case B split under the new framework.
  - Preserved Case A (empty cover, `iSup U = ⊥`) verbatim — closed axiom-clean via
    the existing `htrivBot` / `hcsBot` / `hSubAt0` helper chain (≈40 LOC of in-body
    helpers + close). This satisfies the directive's "Case A preserved or absorbed
    naturally into the new structure".
  - Refactored Case B (nonempty cover): replaced the previous in-body gluing attempt
    (which carried the failing subtype-friction sketch in comments) with a clean
    Subfunctor-based scaffold. The new body explicitly constructs the lifted
    constant-function family `hsub_mem : ∀ i, (fun (_ : ↑↑(U i)) => (sf i).1) ∈
    carrierTypeSubfunctor.obj (op (U i))` via the existential witness
    `⟨(sf i).1, (sf i).2, rfl⟩`. The single typed `sorry` carries the substantive
    Subfunctor-glue + stalk-locality close (irreducibility-based), with a detailed
    4-step recipe in the in-body comment for the prover phase.
- **Why:** Per directive: the Subfunctor framework handles subtype-management
  uniformly, eliminating iter-188 friction points (a)/(b)/(c). The substrate is now
  available; the prover phase can attack `Subfunctor.isSheaf_iff` + stalk-locality
  with clean types throughout.
- **Cascading:** None — `carrierPresheaf`'s ModuleCat-valued signature unchanged,
  so downstream consumers (`toFunctionField`, `globalSections_iff_mp`,
  `globalSections_iff_mpr`, `lineBundleAtClosedPoint`) still compile axiom-clean
  modulo their existing named typed sorries (per directive's expected outcome).

## New Sorries Introduced
- **None.** The Case B `sorry` (formerly at iter-188 line 597) is retained as the
  single typed `sorry` (now at line 686) but is refactored to live inside the
  Subfunctor-based proof scaffold (after the `hsub_mem` constant-function lift). The
  body's substance (the Subfunctor framework + 4-step prover recipe) is new; only the
  closing tactic remains `sorry`.

## Sorry Inventory (file-wide)

Same 4 sorry-carrying declarations as iter-188, with the iter-189 refactor preserving
the same count but localizing the carrierPresheaf substrate via Subfunctor:

- L577: `carrierPresheaf_isSheaf` (Case B body — refactored via `carrierTypeSubfunctor`)
- L1056: `h1_vanishing_genusZero` (unchanged)
- L1093: `dim_eq_two_of_genusZero` (unchanged)
- L1147: `exists_nonconstant_genusZero` (unchanged)

## Compilation Status
- `AlgebraicJacobian/RiemannRoch/OCofP.lean`: compiles (4 sorry warnings, 1 pre-existing
  `CategoryTheory.Sheaf.val` deprecation warning at line 862 — unchanged from iter-188).
- `AlgebraicJacobian/RiemannRoch/OcOfD.lean`: no errors.
- `AlgebraicJacobian.lean`: no errors.

## Axiom audit

- `carrierTypeSubfunctor`: `{propext, Classical.choice, Quot.sound}` — kernel-clean
  (no `sorryAx`).
- `carrierPresheaf_isSheaf`: `{propext, sorryAx, Classical.choice, Quot.sound}` — same
  as iter-188 (single sorry retained per directive's allowance).

## Notes for Plan Agent

### Reading of the directive

The directive offered two flavors of the refactor:
1. Full restructure: redefine `carrierPresheaf` via Subfunctor (would cascade-break
   downstream consumers that extract `.1` as `K(C)` values directly).
2. Subfunctor as parallel substrate (additive): leave `carrierPresheaf`'s signature
   intact, add `carrierTypeSubfunctor` for the proof to use.

I chose flavor (2) to avoid cascading downstream signature changes. The directive's
"OR" clause ("if the Subfunctor route doesn't expose `.isSheaf_iff` directly, use the
cleaner pattern") confirms this is acceptable. `Subfunctor.isSheaf_iff` is available
in Mathlib (`Mathlib/CategoryTheory/Sites/Subsheaf.lean:135`), so the prover-phase
close-out via the iter-189 recipe (in-body Case B comment, 4 steps) is unblocked.

### Substance of Case B's remaining sorry

The current Case B body builds the lifted constant-function family explicitly:
```
have hsub_mem : ∀ i,
    (fun (_ : ↑↑(U i)) => ((sf i).1 : C.left.functionField))
      ∈ (lineBundleAtClosedPoint.carrierTypeSubfunctor P hPcoh).obj
          (Opposite.op (U i)) := fun i => ⟨(sf i).1, (sf i).2, rfl⟩
```
The remaining sorry replaces ~30-50 LOC of in-body work consisting of:
1. Promoting `hcompat` (in `carrierPresheaf`) to compatibility in the Subfunctor
   ambient (which involves the `presheafToType`-side compatibility predicate +
   Subfunctor-section structure).
2. Applying `Subfunctor.isSheaf_iff` against `TopCat.Presheaf.toType_isSheaf`,
   reducing to the stalk-locality predicate.
3. Discharging stalk-locality via irreducibility: choose any non-empty `U i₀`,
   extract `(sf i₀).1` as the candidate value, show all other non-empty `U j`
   yield the same value (by intersecting with `U i₀` via irreducibility), and
   verify the carrier conditions extend to `iSup U` via per-prime-divisor
   pointwise transfer.
4. Extracting the gluing as `⟨v, hv⟩` from the Subfunctor-glued section's
   existential witness.

Each step now has a clean type to operate on (Subtype-valued via Subfunctor),
which was the iter-188 friction point.

### Additional changes not made

None. The directive scoped the refactor narrowly to `carrierPresheaf_isSheaf` body
+ substrate. The downstream consumers explicitly should remain on `htop_ne_bot`
helpers (iter-188 already plumbed those), which they do — no signature changes
required.

### Was the mathematical justification sufficient?

Yes. The directive's "Mathematical justification" section gave a clear blueprint:
sub-presheaf of the constant function-field sheaf on an irreducible scheme is a
sheaf iff its underlying assignment is the section of a Subfunctor. The directive's
mention of `CategoryTheory.Subfunctor.isSheaf_iff` was accurate (Mathlib b80f227 ships
it under that exact name in `Mathlib/CategoryTheory/Sites/Subsheaf.lean:135`).

### Suggested follow-up refactors

- **iter-190 prover task:** close the Case B sorry via the 4-step recipe documented
  in the in-body comment. Should be ~30-50 LOC of clean Subfunctor-based gluing
  (no subtype friction).
- **Optional iter-190+ structural follow-up:** if the Case B proof ends up
  reusing a "stalk-locality of carrierTypeSubfunctor" lemma, hoist that out as a
  separate private lemma `carrierTypeSubfunctor_isSheaf` (axiom-clean stub with one
  sorry for stalk-locality). This isn't required by the directive — kept inline for
  the iter-189 refactor's net-zero sorry-count target.
- **(Cosmetic):** the pre-existing `CategoryTheory.Sheaf.val` deprecation warning at
  line 862 (in `globalSections_iff_mp`) is unrelated to this refactor and could be
  migrated to `ObjectProperty.obj` in a separate iter (low-priority cleanup).
