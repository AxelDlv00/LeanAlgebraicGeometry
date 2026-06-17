# Mathlib Analogist: snap-route
**Mode:** cross-domain | **Iter:** 050

## Analogues Found
- **Route (b) "build at presheaf, Γ at end" is ILLUSORY (negative meta-finding).** It gives the
  WRONG ring (`Γ(sh P) ≠ Γ(P)`; presheaf section ring = tensor algebra on `Γ(L)`), and every
  fix — defining the degree-additive mult, the associator map, or lax-monoidality of `sh`/`Γ_sheaf`
  — collapses to the SAME crux `η_P ⊗ η_Q ∈ W` ⟺ `IsIso(sh.map(η_P ▷ Q))`. **The crux is
  irreducible** for any associative ring on the correct sheaf sections. (Same pattern as iter-043
  FBC illusory pivot.) Do NOT attempt route (b).
- **Analogue 1 [NEW, TOP, present bricks]: abelian-`J.W` coequalizer transfer.** Mathlib already
  has the ABELIAN crux: `GrothendieckTopology.W.monoidal` + `Presheaf.isSheaf_functorEnrichedHom`
  (`Sites/Monoidal.lean`). Transfer to modules: `W(η_P ▷ Q)` ⟺ (`W_iff_isIso_map_of_adjunction`,
  `W = J.W.inverseImage toPresheaf`, `ModuleCat/Sheaf/Localization.lean:48`) `J.W` of the underlying
  abelian map = induced map on the relative-tensor coequalizer `coeq(P⊗_ℤR₀⊗_ℤQ ⇉ P⊗_ℤQ)`. Abelian
  sheafification `a` is a LEFT ADJOINT (preserves coequalizers); `a(η_P ⊗_ℤ –)` iso by abelian
  `W.monoidal` ⇒ induced map on coeq iso ⇒ crux. Cost medium-high; risk = exposing the coequalizer
  presentation of the module-presheaf relative tensor.
- **Analogue 2: stalkwise-iso criterion (Stacks proof).** `(η_P ▷ Q)_x = (η_P)_x ⊗ 1` iso (functor
  preserves stalk iso; no right-exactness). Needs module-sheaf stalk theory — ABSENT. High cost.
- **Analogue 3: Day reflection (snap-assoc A2, reconfirmed).** Needs `MonoidalClosed(PresheafOfModules)`
  — CONFIRMED ABSENT (only `Rep`/distributive exist; PshMod not a plain functor cat). High cost.
- **Analogue 4: scope sidestep.** No Mathlib "section ring/Proj of abstract invertible sheaf" idiom
  that dodges coherence (`Proj` takes a CONCRETE graded ring). Only crux-free path = present `L`
  concretely (very ample ⇒ quotient of homogeneous coord ring) or defer the ring, building only the
  graded module / Hilbert data. A scope decision, not a Lean lemma.

## Top Suggestion
Add one helper to `AlgebraicJacobian/Picard/SectionGradedRing.lean`:
`IsIso ((sheafification).map (η_P ▷ Q))` via Analogue 1 — reduce by
`GrothendieckTopology.W_iff_isIso_map_of_adjunction` to `J.W` of the underlying abelian morphism,
then abelian-`W.monoidal` + left-adjoint-preserves-coequalizers. Read `Sites/Monoidal.lean`,
`Sites/Localization.lean`, `ModuleCat/Sheaf/Localization.lean:48`. Scout the coequalizer presentation
of the relative tensor FIRST (lone risk). This single iso unblocks `tensorPowAdd` → `sectionsMul_assoc`
→ graded-ring assembly. If plumbing balloons, fall back to Analogue 4 (scope change).

## Discarded
- Presheaf section ring + Γ-at-end: wrong object; η@⊤ a ring hom but not iso → no associativity transport.
- `Rep`/functor-category `MonoidalClosed` → PshMod: PshMod not a plain functor cat (restriction-of-scalars).
- snap-assoc A4 local-freeness alone: insufficient (still needs associator map + absent invertibility
  predicate + absent "module-sheaf iso ⟺ locally iso").
- Generic monoidal-functor inverse-image `W.IsMonoidal`: `toPresheaf` not strong monoidal
  (`⊗_{R₀}≠⊗_ℤ`) — Analogue 1 routes around it via the ℤ-tensor coequalizer.

## Persistent file
- `analogies/snap-route.md` written (full reduction chain + route details).

Overall verdict: crux `IsIso(sh.map(η_P ▷ Q))` is irreducible (route (b) dead); cheapest
present-bricks route = abelian-`J.W` coequalizer transfer (Analogue 1).
