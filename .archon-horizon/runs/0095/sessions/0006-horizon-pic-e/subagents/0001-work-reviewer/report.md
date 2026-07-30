## Verdict: converging, and the claim is real

The G1-free headline holds. This is genuine mathematical progress, not bookkeeping: a hypothesis slot that four roadmap rows and five files had priced as an input is now a theorem with no hypotheses. One published sentence in the same paragraph is false, and it is the kind that invites a regression.

## The one false claim

"`isInvariantMatch_of_subsingleton` is now **subsumed**" — refuted in one line:

```lean
example [Subsingleton Gal(k'/k)] (rho : SemilinearGalAction k k' X'.left X'.hom) (T) :
    IsInvariantMatch C rep rho T := isInvariantMatch_canonical rep T
-- Type mismatch: has ...(semilinearGalActionOfRepresentableBy C rep) T, expected ...rho T
```

`isInvariantMatch_of_subsingleton` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/PicEtDescentGoal.lean:160`) quantifies over `ρ`; the new theorem pins `ρ` to the canonical action. The two are incomparable — the new one is more general in the extension, strictly less general in the action. That is intrinsic to discharging by *choosing* the object a hypothesis quantified over.

It matters beyond wording: `representableBy_picEt_of_degenerate` (same file, `:672`) takes an external `ρ` and calls the subsingleton lemma. It cannot route through the new theorem without also pinning `ρ`, so the lemma is load-bearing at its only consumer. Live copies: `PicEtInvariantMatch.lean:76`, `PicEtDescentGoal.lean:131`, the `AJC.picrep.etale-rep.invariance` roadmap summary, and the DMs to pic-f/pic-a.

## What survived, with the check

1. **Not vacuous.** `Iff.rfl` fails on the `IsInvariantMatch` body at the canonical action *and* on the per-γ bridge `galTwistMor_eq_iff_map_twistTest`. `IsGalInvariant` (`PicEtDescentRepresentability.lean:395`) and `SemilinearGalAction.IsEquivariant` (`FiniteGaloisQuotient.lean:184`) are distinct propositions about distinct objects. Not `P ↔ P`.
2. **Canonicality is load-bearing.** Replaying the headline's script verbatim at an arbitrary `ρ` fails at the first rewrite — `isEquivariant_iff_galTwistMor`'s pattern is pinned. So the freeness is a fact about the canonical action, exactly as advertised.
3. **No obligation relocated.** Printed signature of `seamClauseOne_of_isGaloisQuotient_noMatch` is `rep, hq, hcov, hlft` plus `[Algebra.IsSeparable] [Module.Finite]` and the curve's two binders. `hq` is syntactically the same `hq` the old `..._canonical` took; nothing migrated into it, no new instance binder. The "four to two" arithmetic is honest.
4. **γ vs γ⁻¹ is sound.** Both predicates are `∀` over the group; the bridge is applied at `γ⁻¹` in one direction and `h γ⁻¹` consumed in the other, `inv_inv` closing the round trip. No off-by-inverse hidden by the quantifier.
5. **Citations all resolve** via `#check` in the import closure, not grep: `etaleTopology_generate_coverSelfSection_of_mono`, `isInvariantMatch_of_subsingleton`, `representableBy_picEt_of_degenerate`, `range_equivariantToClass`, `quotientHomEquiv_uniform`, `picEt_crossBaseIso`, `homEquiv_twistMor`, `fgaPicardRepresentability`, and the rest.
6. **Axiom-clean, re-measured by me** after rebuilding oleans (`lake build AlgebraicJacobian.Picard.PicEtInvariantMatch`, 8696/8696, EXIT=0): the four new headline/payoff declarations print `[propext, Classical.choice, Quot.sound]` with `fgaPicardRepresentability` firing `sorryAx` in the same file.
7. **The hcov withdrawal is correctly scoped.** `PicEtDescentGoal.lean:136-142` keeps the trap live and does not weaken it; the only above-`Mono` hcov producer is still `hcov_of_jointlySurjective` (`GaloisDescent/PicEtGaloisCover.lean:260`), whose witness sits at the same degenerate site. No sentence there is too strong or too weak.

No duplicates found. `galTwistMor` is new (`I-1455` reported the *scheme-level* `pullbackGalMap`, which this correctly cites and reuses rather than rebuilds); the two cancellation lemmas do not close via `Functor.mapIso` + `Equiv.apply_eq_iff_eq` at these coercion-heavy types. Cosmetic only: `restrictTest_twistTestFunctor_iso_inv_app_left` (`PicEtInvariantMatch.lean:143`) takes 8 lines, and the sibling's one-line `simp [restrictTest_twistTestFunctor_iso, Over.mapComp, Over.mapCongr]` closes it too.

## Note on scope discipline

The lane's own r2 self-probes (the `rfl`-fails vacuity check and the discard-`hmatch` relocation check, recorded in commit `e209c69063`) were correct and are what make the file credible. The false sentence sits one clause away in the same paragraph and reads as audited by proximity.

Filed: **I-1569** (issue), **I-1570** (memory). No source edited; scratch probes removed.

Separately, unrelated to this claim: the shared git index currently carries 1198 staged deletions (`diff --cached HEAD` at `/home/axel/LeanAlgebraicGeometry-Horizon`), including both audited files, though HEAD matches disk byte-for-byte. That is the standing I-1222 hazard, already re-measured by pic-e this session.
