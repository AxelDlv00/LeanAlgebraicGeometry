# Refactor directive — iter-235 — add the `IsQuasicoherent` hypothesis (soundness fix)

## File (only)
`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

## Why
A mathlib-analogist consult (verified against Mathlib) found a CRITICAL soundness defect: the two
theorems below are FALSE as currently typed. They claim the base-change map is an isomorphism for an
ARBITRARY `F : X.Modules`, but Stacks 02KH requires `F` quasi-coherent — over an affine open a general
`F` is not `tilde M`, so the affine tilde-dictionary / `cancelBaseChange` proof cannot apply. Neither
declaration is in `archon-protected.yaml`, and a project-wide grep shows NO downstream consumer (only
the file itself + log snapshots), so the signature may be amended safely.

The correct hypothesis is the Mathlib typeclass `SheafOfModules.IsQuasicoherent` (confirmed via loogle:
`SheafOfModules.IsQuasicoherent (M : SheafOfModules R) : Prop`; `tilde M` carries the instance
`AlgebraicGeometry.instIsQuasicoherent…SpecTilde`). For `F : X.Modules` it is written `[F.IsQuasicoherent]`.

## Change (both theorems)
Add an instance-implicit `[F.IsQuasicoherent]` immediately AFTER the `(F : X.Modules)` binder, preserving
every other binder, the conclusion, and the docstrings verbatim:

1. `affineBaseChange_pushforward_iso` (~line 213):
   `theorem affineBaseChange_pushforward_iso (h : IsPullback g' f' f g) [IsAffineHom f]
       (F : X.Modules) [F.IsQuasicoherent] :
       IsIso (pushforwardBaseChangeMap f g f' g' h.w F) := by … (body unchanged: keep the existing
       reduction `rw [Modules.isIso_iff_isIso_app_affineOpens]; intro U; … sorry`)`

2. `flatBaseChange_pushforward_isIso` (~line 246):
   `theorem flatBaseChange_pushforward_isIso (h : IsPullback g' f' f g) [Flat g]
       [QuasiCompact f] [QuasiSeparated f] (F : X.Modules) [F.IsQuasicoherent] :
       IsIso (pushforwardBaseChangeMap f g f' g' h.w F) := by … (body unchanged: `sorry`)`

The bodies stay exactly as they are (the two `sorry`s remain — you are NOT proving anything; this is a
signature soundness fix only). If adding `[F.IsQuasicoherent]` requires the ambient
`SheafOfModules.IsQuasicoherent` instance prerequisites to be carried as additional `variable`s/instance
binders for the file to elaborate, add the minimal instance binders needed and report exactly what you
added. If the file cannot be made to elaborate with the hypothesis, STOP and report the precise blocker
rather than leaving it broken.

## Verify
`lake env lean` (or the project build) on `FlatBaseChange.lean` must be GREEN with exactly the two
pre-existing `sorry` warnings (no new errors). Report the axiom status is unchanged (still 2 sorries).

## Out of scope
Do NOT touch `pushforwardBaseChangeMap` (the map is correctly defined for all `F`), the 3 locality
lemmas, or any other declaration. Do NOT add/remove imports beyond what the hypothesis strictly needs.
