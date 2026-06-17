# Mathlib Analogist Report

## Mode
api-alignment

## Slug
pushforward-restriction

## Iteration
061

## Question
Build `AlgebraicGeometry.pushforward_commutes_restriction`
(`e_i.functor.obj (H.over U_i) ≅ (Φ.functor.obj H).over V_i` for `φ : X ≅ Y`,
`Φ = Scheme.Modules.pushforwardEquivOfIso φ`). Confirm whether Mathlib already provides this
commutation, whether `pushforwardPushforwardEquivalence` is the canonical tool, and whether
`Scheme.Modules.over W` is the right "restrict to an open" abstraction.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Mathlib carries the comparison iso / qcoh-preservation under pushforward | NEEDS_MATHLIB_GAP_FILL | informational |
| 2. `pushforwardPushforwardEquivalence` is the canonical tool (vs. slicker idiom) | PROCEED | informational |
| 3. `over` is the right abstraction (vs. parallel API) | ALIGN_WITH_MATHLIB | informational |

## Answers to the three asks

**1. Does Mathlib already carry this? — NO.** Verified against the project's pinned Mathlib:
- The comparison iso does not exist (no `over`-vs-`pushforward` commutation in
  `PushforwardContinuous.lean`).
- There is **no** `IsQuasicoherent`-preservation lemma for `pushforward`/`pullback`/`restrict`/iso
  anywhere in `Mathlib/`. The only `IsQuasicoherent` *instance* is `tilde`
  (`Tilde.lean:394`); the only non-trivial constructors are `IsQuasicoherent.of_coversTop`
  (`Quasicoherent.lean:377`), its engine `QuasicoherentData.bind` (`Quasicoherent.lean:360`), and
  same-site `QuasicoherentData.ofIsIso` (`Quasicoherent.lean:323`). Confirms `analogies/need1-transport.md`'s
  iter-060 finding — the gap is real and still open.

**2. Is `pushforwardPushforwardEquivalence` canonical, or is there a slicker idiom? — CANONICAL and
NECESSARY; no slicker idiom.** `QuasicoherentData.bind`'s `presentation` field
(`Quasicoherent.lean:369-375`) uses exactly `pushforwardPushforwardEquivalence` for the identical
transport (with `Over.iteratedSliceEquiv`; the project swaps in the homeomorphism-induced opens-site
equivalence). The equivalence — not a bare `pushforward` — is *required* because `Presentation.map`
consumes a **colimit-preserving** functor, and `SheafOfModules.pushforward` is a *right* adjoint
(does not preserve colimits). So no single-`pushforwardComp`/associativity shortcut can replace it.
The comparison *iso* is short (the `restrictFunctorAdjCounitIso` recipe, `Sheaf.lean:335`:
`pushforwardComp(=Iso.refl) ≪≫ pushforwardCongr ≪≫ pushforwardComp.symm`); the prover's ~100-150 LOC
is the irreducible site-equivalence assembly (`Over U_i ≌ Over V_i` + `IsContinuous` + coherences
`H₁ H₂`), which this route cannot avoid. Building blocks exist: `Over.map/forget/star` continuity
(`Sites/Over.lean:283/243/335`) and `Opens.map` continuity (`Topology/Sheaves/Functors.lean:126`).

**3. Is `Scheme.Modules.over W` the right abstraction? — YES; keep it.** `over` is Mathlib's
`SheafOfModules.over = pushforward (𝟙)` (`PushforwardContinuous.lean:53`), the slice-site restriction
that `QuasicoherentData`/`IsQuasicoherent` is *defined on* (`Quasicoherent.lean:201,208`); proving
qcoh via `of_coversTop` forces `IsQuasicoherent ((Φ H).over V_i)`, so `over` is mandatory, not a
parallel API. The project already uses Mathlib's `over` directly (no local redefinition). The
parallel-API trap to avoid is Mathlib's *other* restriction, `Scheme.Modules.restrict`
(open-immersion morphism, `Sheaf.lean:319`): it speaks the geometric-morphism language, not the
slice-site language the qcoh definition needs — do not route the qcoh assembly through it.

## Informational

- Decision 1 (NEEDS_MATHLIB_GAP_FILL): the gap is upstream; the project must build it, which is
  expected for this new infrastructure. The intended route reuses the correct Mathlib machinery.
- Decision 2 (PROCEED): `pushforwardPushforwardEquivalence` is the right and only tool; cost estimate
  stands but is irreducible, not a sign of a wrong API.
- Decision 3 (ALIGN_WITH_MATHLIB): no shipped code diverges (project already uses `over`); this is a
  guardrail — keep `over`, avoid `Scheme.Modules.restrict` for qcoh.

## Concrete recommendation
PROCEED. Mirror `QuasicoherentData.bind`'s `presentation` field almost verbatim: prove
`isQuasicoherent_pushforwardEquivOfIso (φ : X ≅ Y) (H) [H.IsQuasicoherent]` via `of_coversTop` over
the image cover `fun i => φ.inv ⁻¹ᵁ (q.X i)`; per `i` build
`e_i := pushforwardPushforwardEquivalence <homeo-induced Over U_i ≌ Over V_i> (𝟙) (𝟙) H₁ H₂`, then
`(q.presentation i).map e_i.inverse (.refl _)).ofIsIso <comparison>.hom`, with the comparison iso as
the `pushforwardComp ≪≫ pushforwardCongr ≪≫ pushforwardComp.symm` composite (template
`restrictFunctorAdjCounitIso`). Do not build a standalone bespoke `pushforward_commutes_restriction`
divorced from `bind`'s shape; do not use `Scheme.Modules.restrict`. This discharges the `hqc` sorry
at `OpenImmersionPushforward.lean:532`.

## Persistent file
- `analogies/pushforward-commutes-restriction.md` — full design rationale + citations.

Overall verdict: PROCEED with `pushforwardPushforwardEquivalence` + `over` — both are the canonical
(and, for the equivalence, necessary) Mathlib idioms; the commutation is a genuine upstream gap best
filled as a near-verbatim copy of `QuasicoherentData.bind`.
