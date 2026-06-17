# Mathlib-analogist directive

## Mode: api-alignment

## Question
We want to open a prover lane next iter for `lem:higher_direct_image_presheaf` (Stacks Tag 01XJ),
which states: for `f : X ⟶ S` and `F` a (quasi-coherent) sheaf of modules, the higher direct image
`R^i f_* F` is the **sheafification** of the presheaf `V ↦ H^i(f⁻¹(V), F)` on `S`. In the project
`R^i f_* F = ((pushforward f).rightDerived i).obj F` for `F : X.Modules` (`= Scheme.Modules`,
a `SheafOfModules`). We need to know whether this is feasible to formalize on TODAY's Mathlib, and
the cleanest API path.

Specifically, confirm or refute the availability of each building block, with the exact Mathlib
declaration name + namespace when it exists, or "ABSENT" when it does not:

1. The abstract statement "`R^i f_* = sheafify(V ↦ H^i(f⁻¹V, -))`" for sheaves of abelian groups
   (`Sheaf J AddCommGrp`) — does Mathlib have a derived-functor/sheafification comparison we could
   port? (Strategy notes claim it exists only for `Sheaf J AddCommGrpCat`, not for `Scheme.Modules`.)
2. Sheafification for `PresheafOfModules` / `SheafOfModules` — `PresheafOfModules.sheafification`,
   `sheafificationAdjunction`, and whether sheafification preserves the (co)limits / homology needed
   to commute past `H^i` (e.g. is it exact, does it preserve finite limits?).
3. Right-derived functors of `pushforward` on `Scheme.Modules`: `Functor.rightDerived`,
   `HasInjectiveResolutions (Scheme.Modules X)` (or `X.Modules`) — present? The project already
   assumes `[HasInjectiveResolutions X.Modules]` for the protected target; confirm that typeclass is
   inhabitable/available in Mathlib for `SheafOfModules`.
4. Cohomology `H^i(U, F)` of a sheaf of modules restricted to an open / over `f⁻¹(V)` as a functor of
   `V` — what is the Mathlib idiom (`RightDerived` of global sections, `Sheaf.cohomology`, ...)? Does
   restriction-along-open-immersion + global-sections compose the way 01XJ needs?

## What I need back
- A PROCEED / ALIGN-WITH-MATHLIB / NOT-FEASIBLE-YET verdict on opening this lane next iter.
- If PROCEED: the recommended API skeleton (which Mathlib functors/adjunctions to compose, in order),
  and an estimate of how much is project-side new infrastructure vs. Mathlib-provided.
- If NOT-FEASIBLE-YET: the precise missing ingredient(s) and whether they are buildable project-side
  via the Mathlib-gradient approach (one lemma at a time) or genuinely blocked.
- Note the design already sketched in `analogies/p5a-01xj.md` (read it) and say whether it still holds.

This is a read-only scouting pass to decide whether `higher_direct_image_presheaf` becomes a parallel
lane next iter. It does NOT block this iter's work.
