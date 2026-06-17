# AlgebraicJacobian/RiemannRoch/OcOfD.lean

**Lane K (NEW FILE) — iter-183 file-skeleton dispatch.**

## Outcome

**SUCCESS — file-skeleton landed.** Created
`AlgebraicJacobian/RiemannRoch/OcOfD.lean` (~220 LOC) with the 4
pinned declarations from chapter `RiemannRoch_OcOfD.tex`, all as
typed sorries (Tier-3 honest sorry per iter-181 vocabulary).

Compile: clean (`lake env lean AlgebraicJacobian/RiemannRoch/OcOfD.lean`
returns only the 4 expected `declaration uses 'sorry'` warnings, no
errors, no new axioms).

## Declarations landed (all typed sorries)

1. **`AlgebraicGeometry.Scheme.WeilDivisor.sheafOf`** (L127) —
   `noncomputable def sheafOf (_D : C.left.WeilDivisor) :
    Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar)`.
   Matches the existing typed-sorry def at `RRFormula.lean:168` verbatim,
   modulo the namespace location. Lane H is responsible for the
   re-export / migration when it imports OcOfD.lean into RRFormula.lean
   (per Lane K directive coordination clause).

2. **`AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_zero`** (L150) —
   `lemma sheafOf_zero : sheafOf (0 : C.left.WeilDivisor) = Scheme.toModuleKSheaf C`.

3. **`AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_singlePoint`** (L171) —
   `lemma sheafOf_singlePoint (P : C.left) (hP : IsClosed ({P} : Set C.left))
        (hPcoh : Order.coheight P = 1) :
        sheafOf (ofClosedPoint P hP) = lineBundleAtClosedPoint P hP hPcoh`.

4. **`AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_ses_single_add`** (L214) —
   the SES `0 → 𝒪_C(D) → 𝒪_C(D + [P]) → k(P) → 0`. Existential over a
   `CategoryTheory.ShortComplex` of the `ModuleCat kbar`-valued sheaves,
   with conjuncts: `S.ShortExact`, `S.X₁ = sheafOf D`,
   `S.X₂ = sheafOf (Finsupp.single P 1 + D)`, and
   `Nonempty (S.X₃ ≅ skyscraperSheaf P.point (ModuleCat.of kbar kbar))`
   (decidability supplied by file-level `open scoped Classical`).

   Argument `D` carries the underlying `Finsupp` type rather than
   `Scheme.WeilDivisor`: matches the pattern of
   `Scheme.eulerCharacteristic_sheafOf_single_add` in `RRFormula.lean`,
   so Lane H's induction step elaborates cleanly.

## Imports

`Mathlib`, `AlgebraicJacobian.Genus` (for `Scheme.toModuleKSheaf`),
`AlgebraicJacobian.RiemannRoch.WeilDivisor` (for `WeilDivisor`,
`PrimeDivisor`, `ofClosedPoint`),
`AlgebraicJacobian.RiemannRoch.OCofP` (for `lineBundleAtClosedPoint`).

## Coordination notes for downstream lanes / planner

- **Lane H (`RRFormula.lean`)**: needs to import `OcOfD` and retire the
  duplicate `Scheme.WeilDivisor.sheafOf` typed-sorry at `RRFormula.lean:168`.
  Currently the two files compile in isolation (neither imports the other);
  the duplicate becomes a name-collision only when Lane H wires the import.
  Lane H's iter-183 directive already plans for this ("Retire the
  `sheafOf` typed sorry at L168 by re-exporting `OcOfD.sheafOf`").

- **`AlgebraicJacobian.lean` master index**: this file is NOT yet listed
  in `AlgebraicJacobian.lean` (the project's import root). Per task
  rules I cannot edit other `.lean` files; the planner / Lane H should
  add `import AlgebraicJacobian.RiemannRoch.OcOfD` either to the index
  directly or transitively via Lane H's RRFormula import. Until then,
  `lake build` (default target = `AlgebraicJacobian`) will not visit
  this file — individual compile (`lake env lean
  AlgebraicJacobian/RiemannRoch/OcOfD.lean`) succeeds.

- **`sheafOf_ses_single_add` X₃ identification**: I bundled
  `Nonempty (S.X₃ ≅ skyscraperSheaf P.point (ModuleCat.of kbar kbar))`
  inside the existential so Lane H can extract the skyscraper structure
  via `obtain`. This deliberately uses `≅` (Sheaf iso) rather than `=`,
  since `=` between Sheaf objects of `ModuleCat kbar` would be a stronger
  claim than necessary; the χ-additivity argument only needs the iso
  (it transports `χ` since `χ` is iso-invariant).

## Blueprint marker readiness

All four declarations are formalized with their intended substantive
signatures matching the chapter's `\lean{...}` pins. The
deterministic `sync_leanok` phase will add `\leanok` to each
`\begin{definition}` / `\begin{lemma}` statement block (since the
declarations exist with at least a `sorry`). The `\leanok` on the
`\begin{proof}` blocks remains absent for now (bodies are sorries —
iter-184+ work per the chapter's §"Sheaf-property correctness" recipe).

## Tier disclosure summary

All 4 declarations are **Tier-3 honest typed sorry**: the body is a
substantive mathematical construction (Hartshorne subsheaf-of-`K_C`
recipe per chapter §"Sheaf-property correctness") whose closure is
iter-184+ work; the types encode genuine claims about the invertible
sheaf, its specialisations, and its SES additivity.

## File-level sorry count

4 sorries introduced (one per declaration), 0 axioms.

## Next-step suggestions for iter-184

- **`sheafOf` body** (iter-184+): the per-open `Submodule kbar K(C)` cut
  out by the order conditions, bundled as a presheaf functor via the
  identity-on-`K(C)` restriction; sheaf property via gluing-by-stalks
  (~200-300 LOC per chapter §"Sheaf-property correctness").
- **`sheafOf_zero` body** (iter-184+, gated on `sheafOf` body): unfolding
  reduces to the standard "non-negative-order = regular" identification
  of the structure sheaf on an integral scheme.
- **`sheafOf_singlePoint` body** (iter-184+, gated on both `sheafOf` and
  `lineBundleAtClosedPoint` bodies): unfolding both sides reduces to the
  same per-open carrier set (via `lineBundleAtClosedPoint_globalSections_iff`
  of `OCofP.lean`).
- **`sheafOf_ses_single_add` body** (iter-184+, gated on `sheafOf` body):
  Hartshorne IV.1.3 ideal-sheaf SES tensored with `𝒪_C(D + [P])`.
