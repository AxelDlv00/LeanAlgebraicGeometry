Both files are complete and I'm blocked on the shared build lock. Let me report the state now, since the kernel verification is the one thing I cannot claim.

**Files created**

- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyAffGlueZarKit.lean` (646 lines)
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyAffGlueZar.lean` (299 lines)

Both are sorry-free and placeholder-free (`grep -c sorry` = 0 on each). I did not touch `AlgebraicJacobian.lean` or any other file, and did not commit.

**The target theorem, as written**

```lean
theorem DivFamZarAff.exists_glue_of_away_compat
    {ι : Type u} [Finite ι] (g : ι → R) (S : ι → Type u)
    [∀ i, CommRing (S i)] [∀ i, Algebra k (S i)] [∀ i, Algebra R (S i)]
    [∀ i, IsScalarTower k R (S i)] [∀ i, IsLocalization.Away (g i) (S i)]
    (T : ι → ι → Type u) [ …the same instance pack as the model… ]
    (hg : Ideal.span (Set.range g) = ⊤)
    (F : ∀ i, DivFamZarAff C (S i) n)
    (hcompat : ∀ i j,
      DivFamZarAff.mapAlg (T i j) n (F i) = DivFamZarAff.mapAlg (T i j) n (F j)) :
    ∃ F₀ : DivFamZarAff C R n, ∀ i, DivFamZarAff.mapAlg (S i) n F₀ = F i
```
under `variable {k} [Field k] {C : Over (Spec (.of k))} [IsProper C.hom] {R} [CommRing R] [Algebra k R] {n : ℕ}` — no `π`, exactly as you specified.

**Verification status: NOT measured.** I cannot claim `lake env lean` exited 0. The machine is running 220-240 concurrent `lean` processes from the sibling lanes; a bare two-import probe file consumed 16 minutes of wall time for 16 seconds of CPU and never finished, and the mkdir mutex is currently held by another process running the same check with a 400 s timeout that will almost certainly expire before elaboration completes. Watchers are armed on the output; no diagnostics have been produced yet, by the LSP either (`lean_diagnostic_messages` timed out at 300 s on the import cone, twice).

**One thing you should know, because it changed the design**

The model does not port as a pure substitution. `awayGluedEquations` and `divEq_pullback_awayGluedEquations` are declared over `E : ∀ i, CertifiedDivisorFamily C (S i) π n`, but their bodies read only `.eqns` and `.eqns.cover` — `.adaptation` and `.certified` never occur, and `π` occurs zero times. A widened class provably cannot supply chart-typed certified input (that failure is the content of R2), so the assembly had to be **restated at bare `LocalEquations`** before either could be instantiated. That restatement is the bulk of the Kit file: `awayGluedEquationsLoc`, `divEq_pullback_awayGluedEquationsLoc`, `germ_awayTransportLoc_mem_nonZeroDivisors`, `exists_res_awayTransportLoc_eq_unit_mul` — proofs transcribed, statements weakened at the input.

That forced a judgement call worth flagging. The chart-typed `AwayCompatDivEq` gets its pullback-regularity from the certificate; a bare system has none, so the witnesses must travel with the hypothesis. I named the side-condition (`Scheme.LocalEquations.PullRegular`) and bound the witnesses **existentially**, not universally. The `∀ hi hj, DivEq …` spelling would be satisfied by every family whatsoever the moment one `PullRegular` happened to be uninhabited — a vacuous obligation wearing the shape of a compatibility. The keystone discharges the `∃` with the certificate's own `AffAdaptation.germ_pullbackEqn_mem_nonZeroDivisors`, which is exactly the witness inside `mapAlg.eqns = adaptation.pulledEquations`, so the witness transports `hbp`/`hbq` should match definitionally.

I also had to add `CertifiedDivisorFamilyAff.isLocallyCertifiedAff` and `.toZarAff` — the widened counterpart of `CertifiedDivisorFamily.isLocallyCertified` was absent from the tree, and without it a widened certified family names no class in `DivFamZarAff`, so the gluing core could not state what its input restricts to.

The remaining risk is concentrated in three places I would check first when the compiler is reachable: the `hcompatFine` witness match just described, the `Units`/`unitsAppLE` bookkeeping at the end of `exists_res_awayTransportLoc_eq_unit_mul` (transcribed but retyped against `(E i)` instead of `(E i).eqns`), and instance resolution for `DivFamZarAff.eq_of_away_eq` at the `ULift`-indexed fine cover.
