# Mathlib Analogist Report

## Mode
api-alignment

## Slug
loctriv-bridge

## Iteration
245

## Question
Adjudicate the iter-243/244 verdict ("commit the general strong-monoidal inverse-image
pullback build; the local-triviality route is blocked because `IsInvertible ⟹ IsLocallyTrivial`
for `Scheme.Modules` is Mathlib-scale") against analyst rpf-bridge ("the invertible-pair
comparison iso `f^*(M⊗N) ≅ f^*M ⊗ f^*N` is a cheap chart-chase via the proven
`IsLocallyTrivial.pullback`"). Q1: forward-bridge cost. Q2: comparison iso on locally-trivial
pairs via chart-chase, with no general filtered-colimit machinery. Q3: bottom line — is the
consumer-restricted route materially cheaper than the committed 20–38-iter build?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1 — forward bridge `IsInvertible ⟹ IsLocallyTrivial` | NEEDS_MATHLIB_GAP_FILL (real gap, but OFF critical path — do not build) | informational |
| Q2 — `pullbackTensorIso` restricted to locally-trivial pairs | ALIGN_WITH_MATHLIB (oplax-δ + local-reduction idiom; ~200–400 LOC) | major |
| Q3 — is the committed general strong-monoidal build necessary? | NO — cheaper route exists; general build is divergent-with-cost | major |

## Bottom line (Q3)

**The committed general build is NOT necessary, and there is a materially cheaper route
restricted to the locally-trivial pairs the consumer needs.** rpf-bridge's *direction* is
right but under-scoped; iter-243's "general build necessary" rests on two errors:

1. It treats the forward bridge `IsInvertible ⟹ IsLocallyTrivial` as the blocker, but that
   bridge is **off the critical path**. The consumer carrier `OnProduct`
   (`LineBundlePullback.lean:130`) is `{ M // IsLocallyTrivial M }` — defined via
   `IsLocallyTrivial`, not `IsInvertible`. Only the EASY reverse direction
   `IsLocallyTrivial ⟹ IsInvertible` (`exists_tensorObj_inverse`, L672) is used. The hard
   forward bridge is never needed.
2. The iter-242 "no free oplax ⇒ preserves invertibles" note (L1147-1173) prices the GENERAL
   iso-ness of δ and uses the counterexample `Γ(ℙ¹,𝒪(1)) = 0`. That counterexample is about
   the **lax** tensorator of **pushforward** (right adjoint / global sections), NOT the
   **oplax** δ of **pullback** (left adjoint). Pullback PROVABLY preserves local triviality
   (`IsLocallyTrivial.pullback`, axiom-clean), so δ IS an iso on loc-triv objects — the
   geometric content is exactly local triviality + `pullbackUnitIso`, both already in hand.

## Major

**Q2 — build `pullbackTensorIso` on locally-trivial pairs via the oplax-δ chart-chase, not
the general strong-monoidal build.** The canonical comparison map already exists
(`pullbackTensorMap` = δ_sheaf, L1199, a sorry-free `def`). Show it is an iso via the proven
`isIso_of_isIso_restrict` (L546) on the cover `{f⁻¹(Uᵢ)}`, where `Uᵢ` trivialises both M and N
on X (common refinement, as in the proven `tensorObj_isLocallyTrivial`, L515). On each
`f⁻¹(Uᵢ)`:
- (i) δ-naturality replaces `M|_{Uᵢ}, N|_{Uᵢ}` by `𝒪` — FREE from Mathlib
  `Functor.OplaxMonoidal.δ_natural`;
- (ii) δ on the unit pair `(𝒪,𝒪)` is an iso via `pullbackUnitIso` (axiom-clean, iso for ALL
  f) + Mathlib `δ_comp_η_tensorHom` / `δ_comp_tensorHom_η` + unitors;
- (iii) δ commutes with the open-immersion base-change square `gᵢ : f⁻¹(Uᵢ) → Uᵢ` — the
  tensorator analog of the ALREADY-BUILT, axiom-clean `pullbackObjUnitToUnit_comp` (L902,
  ~85 LOC mate calculus), backed by Mathlib `Functor.OplaxMonoidal.comp_δ` and the project's
  `conjugateEquiv_pullbackComp_inv`.

Decomposition / estimate: (D1') δ sheaf-level naturality in (M,N) ~40 LOC · (D2') δ_(𝒪,𝒪)
iso ~40–80 LOC · (D3') δ vs open-immersion base-change square ~80–150 LOC · (D4') chart-chase
assembly mirroring `IsLocallyTrivial.pullback`/`tensorObj_isLocallyTrivial` ~50–100 LOC ·
(D5') `IsInvertible.pullback`/group-hom wrapper ~15 LOC. Total **~200–400 LOC / ~8–16 iters**,
versus 20–38 for the general build. The irreducible blocker is (D3') — genuine new work, but
bounded, Mathlib-supported, and demonstrated feasible (its unit analog is done and axiom-clean).

**This is materially cheaper because it sidesteps D2 and D3 of the committed build entirely** —
no concrete inverse-image (Lan along `Opens.map f.base`) and no Mathlib-absent filtered-colimit
/⊗ interchange. It uses only the ABSTRACT oplax δ (mate of pushforward's lax structure,
`presheafPullbackOplaxMonoidal`, L1138, already built), reducing iso-ness to the unit case.

## Informational

**Q1 — the forward bridge IS Mathlib-scale (iter-243 correct), but should not be built.**
`IsInvertible M = ∃N, tensorObj M N ≅ 𝒪` supplies **no** finite-presentation datum for M as a
`SheafOfModules` through any Mathlib lemma. Mathlib's "invertible ⟹ finite/projective/locally
free" results (`Module.Invertible`, `Mathlib.RingTheory.PicardGroup`; the
`Module.Invertible.instLocalizationLocalizedModule` rpf-bridge cited) live at the
module-over-`CommRing` / `LocalizedModule` level and concern base change of a module over a
ring — they do not produce a `SheafOfModules`-level trivialisation. There is **no** stalk-iso ⟹
neighborhood-iso spreading-out for `SheafOfModules`/`Scheme.Modules` at the pin (the project's
`isIso_of_isIso_restrict` is global-from-a-GIVEN-cover, not single-stalk spread-out). So
rpf-bridge's "cheap via `Module.Invertible`" claim is wrong (wrong abstraction level), and
iter-243's "Mathlib-scale" claim is right — but the point is moot, because the consumer uses
`IsLocallyTrivial` directly and pullback-preservation of it is already proven.

**Axiom profiles confirmed (`lean_verify`, all `propext`/`Classical.choice`/`Quot.sound`, no
`sorryAx`):** `IsLocallyTrivial.pullback`, `tensorObj_isLocallyTrivial`, `pullbackUnitIso`,
`tensorObj_restrict_iso`. (The source-scan "opaque" flag at TensorObjSubstrate.lean:467 is the
word "opaque" inside a code comment, not a `sorry` — not in the axiom closure.) The
`IsLocallyTrivial.pullback` "typed sorry" docstring is stale; the `i1 ≪≫ … ≪≫ i7` chart-chase
is complete.

**Adversarial check passed.** The cheaper route does NOT secretly re-import the Mathlib-scale
forward bridge (it lives entirely in `IsLocallyTrivial`, the consumer carrier) and does NOT
re-import the concrete inverse-image model (it uses the abstract oplax δ and reduces iso-ness
to the unit case, where `pullbackUnitIso` is unconditional). One residual risk to verify when
implementing: sheaf-level naturality of `pullbackTensorMap` in (M,N) must be assembled from the
naturality of its pieces (`δ_natural`, `sheafificationCompPullback`, `pullbackValIso`,
`sheafifyTensorUnitIso`) — plausible but part of (D1').

## Persistent file
- `analogies/invertible-loctriv-bridge.md` — full decision rationale captured for future iters.

Overall verdict: the general strong-monoidal pullback build is unnecessary for the relative
Picard consumer — pivot to the locally-trivial-restricted route (upgrade the already-built
oplax δ `pullbackTensorMap` to an iso via `isIso_of_isIso_restrict` over `{f⁻¹(Uᵢ)}`, reducing
to `pullbackUnitIso` on units), ~200–400 LOC / ~8–16 iters, with the δ-vs-base-change-square
coherence (proven-feasible unit analog: `pullbackObjUnitToUnit_comp`) as the only irreducible
new sub-step.
