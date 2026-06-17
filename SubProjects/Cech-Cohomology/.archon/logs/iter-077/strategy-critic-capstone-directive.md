# Strategy critique — Route-A capstone

Read (verbatim): `.archon/STRATEGY.md`; `references/summary.md`; the chapter titles + one-line
topic of each `blueprint/src/chapters/*.tex` (skim headers only).

Project goal: prove `AlgebraicGeometry.cech_computes_higherDirectImage` — for `f : X⟶S`
separated quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover,
`Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` under
`[HasInjectiveResolutions X.Modules]`. Zero inline sorry in the cone, kernel-only axioms.

The project is at its CAPSTONE: every ingredient is proved/ready; the sole remaining work is the
P5b Route-A assembly (now ACTIVE in STRATEGY). Two questions for you:

1. Is Route A's assembly mathematically sound as decomposed in the P5b row — apply the P4 acyclic-
   resolution lemma with `G = f_*`, `K = cechComplexOnX` (the un-augmented Čech complex over X),
   resolution data from `cechAugmented_exact`, termwise acyclicity from `cechTerm_pushforward_acyclic`,
   then identify `(f_*).mapHC(cechComplexOnX) ≅ CechComplex` and `(f_*).rightDerived ≡ higherDirectImage`?
   Any hidden hypothesis gap (e.g. `f_*` needs `[Additive]`+`[PreservesFiniteLimits]`; the cover-affine
   `h𝒰`/`IsSeparated` hyps reaching the frozen signature's `[QuasiCompact f][IsSeparated f]`)?

2. Is the relocation decision (move the frozen theorem to a downstream leaf, signature verbatim,
   YAML path updated) the right call, or is there a soundness/structural reason to prefer otherwise?

Report SOUND / CHALLENGE / REJECT with specifics.
