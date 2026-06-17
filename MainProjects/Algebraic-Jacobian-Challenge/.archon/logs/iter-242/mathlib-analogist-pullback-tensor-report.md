# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
pullback-tensor

## Iteration
242

## Structural problem
Transfer a strong-monoidal tensorator comparison `F(A ⊗ B) ≅ F A ⊗ F B` to a functor `F`
defined ONLY as an abstract left adjoint `(pushforward).leftAdjoint` between monoidal
categories of sheaves of modules (`⊗ = sheafify(presheaf-⊗)` over a varying structure ring),
enough to conclude `IsInvertible M → IsInvertible (f^* M)`.

## HEADLINE: the directive's premise is stale
`Adjunction.leftAdjointOplaxMonoidal` and the whole doctrinal-adjunction tensorator machinery
**are present at the project's pin** (`mathlib b80f227`, 2026-04-20). They were added by
PR #36599 ("the monoidal adjunction between the extension and the restriction of scalars",
merged 2026-03-20), which the pin postdates. So Q1 = YES (Mathlib has tensorator-from-adjunction)
and Q3 (bump) is **moot — no bump needed, it is already in-tree**.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `CategoryTheory.Adjunction.leftAdjointOplaxMonoidal` (`Monoidal/Functor.lean:1009`) | category theory / mates | high (bundled) · medium (hand-port) | ANALOGUE_FOUND |
| `ModuleCat.(extendScalars f).Monoidal` + `Monoidal/Adjunction.lean` (PR #36599) | comm. algebra / base change | high (honest cost) | ANALOGUE_FOUND |
| `Module.Invertible` localization-stability (`RingTheory/PicardGroup.lean`) | comm. algebra / Pic | high, off-path | PARTIAL_ANALOGUE |

## Top suggestion
Follow Mathlib's OWN recipe from PR #36599 rather than the adjunction-mate route. The decisive
observation: in `Mathlib/Algebra/Category/ModuleCat/Monoidal/Adjunction.lean`, Mathlib builds
the LEFT adjoint's strong-monoidal structure **explicitly** —
`instance : (extendScalars f).Monoidal` (line 42) via `Functor.CoreMonoidal.toMonoidal` with
the tensorator `TensorProduct.AlgebraTensorModule.distribBaseChange` — and only THEN derives the
RIGHT adjoint's lax structure from the adjunction (`restrictScalars.LaxMonoidal :=
adj.rightAdjointLaxMonoidal`, line 102). So the right move for the project is:

1. Build a *concrete* strong-monoidal pullback `P = sheafify ∘ (sectionwise extendScalars)`,
   reusing `distribBaseChange` (the linear-algebra strong-monoidal core) and the project's
   existing `sheafifyTensorUnitIso` brick.
2. Prove `P ⊣ pushforward`.
3. Transport `P.Monoidal` to the abstract `Scheme.Modules.pullback` along
   `Adjunction.leftAdjointUniq` (already used in iter-217 for `tensorObj_restrict_iso`). This
   dissolves the "abstract adjoint has no sectionwise formula" obstacle: the abstract adjoint is
   iso to the concrete one, and the monoidal structure travels along that iso.

This yields `pullbackTensorIso` as a genuine iso. First project file to touch: a new
monoidal-pullback file feeding `AlgebraicJacobian/Picard/LineBundlePullback.lean`. Read in
Mathlib: `CategoryTheory/Monoidal/Functor.lean:885-1094` and
`Algebra/Category/ModuleCat/Monoidal/Adjunction.lean`.

## Why NOT the bare `leftAdjointOplaxMonoidal` route
It is the precedent the directive suspected and it exists, but it is not plug-and-play:
- It requires `MonoidalCategory (SheafOfModules 𝒪)` instances — **the project has none**
  (it carries `Scheme.Modules.tensorObj` as a bespoke sheafified tensor, no bundled monoidal
  category; this is precisely why `picCommGroup` was built by hand on `IsInvertible`).
- It requires `(pushforward f).LaxMonoidal` — **absent from Mathlib** (no monoidal structure on
  `SheafOfModules.pushforward`), and that lax `μ` is itself nontrivial to build.
- It produces only an OPLAX map `δ : f^*(M⊗N) → f^*M⊗f^*N`, **not the iso** the recipe needs.
  Strong-monoidality (each `δ` iso) is genuine content the adjunction does not give.
The mate FORMULA (`δ X Y := (adj.homEquiv).symm ((unit⊗unit) ≫ μ_G)`, line 1011) is
hand-portable for a single object pair if one ever wants just the map — but it does not address
iso-ness, so it does not finish the job on its own.

## Negative result (closes a tempting shortcut)
"A (op)lax monoidal functor preserves invertible objects automatically" is FALSE: `Γ` is lax
monoidal but `Γ(P¹,O(1)) = 0` is not an invertible module. So one cannot use the oplax `δ` plus a
"preserves-invertibles" lemma to dodge proving `δ` is an iso. No such free lemma exists or can.

## Q2 (locally-free route) assessment
The "pullback preserves local triviality" half is ALREADY DONE in the project:
`IsLocallyTrivial.pullback` (`LineBundlePullback.lean:156`). So Q2 reduces to the bridge
`IsLocallyTrivial M → IsInvertible M` (build the tensor-inverse of a locally-trivial sheaf) —
the project's known-stuck `dual_restrict_iso`/`exists_tensorObj_inverse` arc, explicitly demoted
in [[ts232-carrier-pivot]]. Mathlib offers `Module.Invertible` localization-stability and
invertible⇔free-rank-1 characterizations, but only over a single ring; there is NO Mathlib
stalk-of-abstract-pullback formula (only `restrictStalkNatIso` for OPEN IMMERSIONS), and the
locally-free⇒tensor-invertible gluing is the gap. Verdict: higher cost/risk than the monoidal
route, and it revives an arc the project deliberately shelved. Do not prefer it.

## Discarded
- `hasRightDualOfEquivalence` (`Monoidal/Rigid/OfEquivalence.lean`): requires `F.IsEquivalence`;
  pullback is not an equivalence.
- Op-dualizing `rightAdjointLaxMonoidal` to synthesize the missing dual direction: unnecessary —
  `leftAdjointOplaxMonoidal` already exists, and the direction is not the real blocker (the
  `MonoidalCategory` instance + iso-ness are).

## Persistent file
- `analogies/pullback-tensor.md` — analogue list + the corrected-premise note for future iters.

Overall verdict: the doctrinal-adjunction tensorator machinery the directive thought was absent
is in fact in the pinned Mathlib, but the project's lack of a `MonoidalCategory (SheafOfModules)`
instance and the genuine need for an *iso* (not an oplax map) mean the project should mirror
Mathlib's PR #36599 pattern — build a concrete strong-monoidal pullback and transport it via
`leftAdjointUniq` — rather than invoke the bundled adjunction API directly.
