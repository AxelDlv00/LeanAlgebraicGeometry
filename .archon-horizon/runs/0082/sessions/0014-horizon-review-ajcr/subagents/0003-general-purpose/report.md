The reviewer isn't reachable from this session, so I'll surface the reply in my report instead.

## Addendum — U-1 revised to OVER-PRICED (peer evidence checked, chain does not hold)

`work-reviewer` sent evidence that `fiberWeilDivisor`'s support avoids the second pinned chart and asked whether that settles the U-1 probe. Its three lemmas are real — `fiberWeilDivisor_coeffAt_of_mem_chart₁`, `…chart₀`, `fiberWeilDivisor_nonneg` (all in `AlgebraicJacobian/RiemannRoch/FLVFiberToolkit.lean:311/319/303`), and `fiberWeilDivisor` at `:292`. I did not re-derive them; I checked the chain to `univSeed`. It fails at both joints, and a third fact then settles the probe.

**(a) The relevant `d` is not the window divisor.** `AlgebraicGeometry.ThetaGeneratorSeed` (`Picard/DivSchemeFamily.lean:74`) has **no divisor field** — only `side`, `h`, `mem_basicOpen`, `sec`, `sec_mem`. The window divisor enters `univSeed` only as the exponent `a := windowM_choice pi hpi g` and inside the ambient `DivCarveChartRing` / `divUniversalSeedK`. The `d` the straddling no-go quantifies over is `ThetaGeneratorSeed.localEquations` (`Picard/DivSchemeFamily.lean:349`), whose `eqn z := relThetaResSide a (D.side z) (D.piece_le z) (D.sec z)` — the side component of a *chosen generator* from `divUniversalSeedK`, further cut by an `exists_pointwiseAnnCutter` choice. Its `supportLocus` is that non-unit locus (`Picard/SupportTube.lean:131`), on a **pointed** cover with one member per point. "Misses V₁" is not preserved because the two statements are about different objects.

**(b) Different spelling, bridged only halfway.** `fiberTwoCover_V₀/V₁` are `rfl` onto `fiberChart₀/₁` (`Cohomology/RigidEngine4Relative.lean`, the two simp lemmas after `def fiberTwoCover:75`). But the no-go uses `(relCover C R (fiberTwoCover pi)).V₀`, and `relCover C R D := D.pullbackProd R` (`Cohomology/RelativeTwoCover.lean:128`) — a base change to `relCurve C R`. So a `fiberWeilDivisor` argument would need a pullback-of-support step. Not a blocker for the verdict, but it is not free.

**(c) The probe is answerable from one definition, and the antecedent fails.** `univSeed.side` is `pointwiseSide` (`Picard/DivSchemeSeedUnivPointwise.lean:88`), threaded unchanged through `productCutter` (`side := D.side`, `Picard/DivSchemeRedesignSeedUnivProduct.lean:47`):

```lean
noncomputable def pointwiseSide (z : relCurve C RZ) : Bool :=
  (exists_mem_relPinnedChart (C := C) (π := π) z).choose
```

with `exists_mem_relPinnedChart : ∃ b, z ∈ relPinnedChart C R π b` (`Picard/DivSchemeSeedUnivGen.lean:63`, from `relCover_sup`). The side at each point is chosen *to contain that point*. So a straddling witness `x ∉ V₀` forces `side x = true` and `y ∉ V₁` forces `side y = false` — consistent, not contradictory. What `forall_not_isCertified_of_straddling` (`Picard/DivisorFamilyAffStrict.lean:127`) additionally requires is `IsPreconnected d.supportLocus`, and for this pointed-cover `d` over a nonreduced carve ring nothing establishes it.

**Revised verdict: OVER-PRICED, not REAL.** The prescription asks for a support-vs-charts comparison that is the wrong shape by the source file's own argument and cannot be run against `fiberWeilDivisor` at all. The cheaper sufficient item is the connectivity clause `IsPreconnected (univSeed …).localEquations.supportLocus` — refuting that removes the no-go's applicability to `univSeed` without any support-locus computation.

One caution worth flagging to whoever relays this: "misses V₁, therefore does not straddle" is true of `fiberWeilDivisor` and says nothing about the seed's `localEquations`. Publishing it would put a false discount on this leaf.

No files were edited or committed; my scratch probes are deleted. `SendMessage` to `work-reviewer` failed (agent not reachable from this session), so the reply above needs relaying.
