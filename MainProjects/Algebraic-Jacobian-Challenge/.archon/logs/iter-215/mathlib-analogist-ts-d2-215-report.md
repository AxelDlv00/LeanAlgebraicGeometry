# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
ts-d2-215

## Iteration
215

## Structural problem

A filtered-colimit functor commutes with a *relative* tensor product over a *varying* base ring:
for filtered `R : C ⥤ RingCat`, pointwise `R(i)`-modules `F, M : C ⥤ Ab`, a natural iso
`colim_i (F(i) ⊗_{R(i)} M(i)) ≅ (colim F) ⊗_{colim R} (colim M)` over `colim R`. Specialised to
`C = (OpenNhds x)ᵒᵖ`: `(F ⊗ᵖ_R M)_x ≅ F_x ⊗_{R_x} M_x`, and downstream
`(F ◁ g)_x ≅ LinearMap.lTensor F_x (g_x)`. This is ingredient **d.2** of the `(J.W).IsMonoidal`
route-(e) build.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `…/ModuleCat/Presheaf/ColimitFunctor.lean` (`ModuleColimit`, `jointly_surjective₂/₃`) | category theory / module-presheaf colimits | medium | ANALOGUE_FOUND |
| `…/Sites/Point/Monoidal.lean` (`presheafFiber.Monoidal`) | sheaf-point fiber functors (fixed base) | medium | ANALOGUE_FOUND (skeleton) |
| `…/LinearAlgebra/TensorProduct/DirectLimit.lean` (`directLimitLeft`) | commutative algebra (fixed ring) | high | PARTIAL_ANALOGUE |

## Buildability verdict (directive's primary ask): **(b)** — buildable, requires a substantial new sub-construction

Not (a) routine; not (c) deeply blocked. The named sub-construction is **the relative-tensor
comparison map `(F ⊗ᵖ M)_x → F_x ⊗_{R_x} M_x` on `ColimitFunctor.ModuleColimit` plus its iso proof**
— the varying-ring analogue of `presheafFiber.Monoidal`. The ~150–250 LOC estimate is realistic;
risk is **MODERATE, not swamp-level**, because the part that would otherwise be the swamp — the
colimit-module-with-scalar-action plumbing — is **already built** in `ColimitFunctor.lean`, and this
construction is Joël Riou's explicit written TODO there ("Define fiber functors on categories of
(pre)sheaves of modules").

### Why not (a)
- No single lemma to instantiate: the comparison map and the bijectivity proof must be authored.
- The varying ring blocks verbatim reuse of `directLimitLeft` (fixed `CommSemiring R`) and of
  `IsColimit.tensor` applied to the *relative* tensor (the cocones live in different `ModuleCat
  (R(U))`, not one fixed monoidal category).
- A reconciliation sub-task exists: the stalk uses an `(OpenNhds x)ᵒᵖ` colimit
  (`Stalk.lean`, `colimit.isColimit`) while the reusable joint-surjectivity API lives on
  `ColimitFunctor.ModuleColimit`. Bridging these is Riou's "refactor Stalk.lean" TODO, done locally.

### Why not (c)
Every load-bearing ingredient is present and recent (citations below). The gap is one authored
construction, not absent foundations.

## Building blocks present (project's pinned Mathlib, rev `b80f227`, lean 4.30.0-rc2)

- **Module stalk over the stalk ring** — `ModuleCat/Stalk.lean`: instance L165 (RingCat) / L190
  (CommRingCat); `germ_smul` L200. Built via `CategoryTheory.Limits.IsColimit.module` (L123),
  `colimit.smul` (L42), `IsColimit.ι_smul` (L135). Exposes the colimit + germ-smul presentation the
  comparison map tensors through. (Confirms memory `ts-module-stalk-exists`: stalk infra DOES exist.)
- **The varying-ring colimit module with the right API** — `…/Presheaf/ColimitFunctor.lean`:
  `ModuleColimit` (L68), `coconeSMul` (L79) and `smul_eq` (L103) [scalar action via the underlying
  `AddCommGrp` `IsColimit.tensor` cocone], `ιM_jointly_surjective` (L109), `jointly_surjective₂`
  (L147), `jointly_surjective₃` (L159), `jointly_surjective₃'` (L172), universal property `homEquiv`
  (L240), `colimitFunctor` (L350). **Header TODO names d.2 as the intended next step.**
- **Relative tensor preserves colimits** — `…/Presheaf/Monoidal.lean`:
  `PreservesColimitsOfSize (tensorLeft F)` (L237) / `(tensorRight F)` (L243), proved sectionwise via
  `evaluation`. This is the varying-ring counterpart of the fixed-base template's preservation
  hypothesis — already discharged. Also `tensorObj` (L62), `tensorObj_obj` (rfl, L169).
- **Tensor of colimit cocones is a colimit** — `…/Monoidal/Limits/Colimits.lean`: `IsColimit.tensor`
  (L73, needs `PreservesColimit₂` + `IsSifted`; filtered ⟹ sifted), `Cocone.tensor` (L65).
- **Element-level iso model (fixed ring)** — `…/TensorProduct/DirectLimit.lean`: `directLimitLeft`
  (L78), `directLimitRight` (L97); `Module.DirectLimit` (`Algebra/Colimit/Module.lean:61`).
- **Proof skeleton** — `…/Sites/Point/Monoidal.lean`: `presheafFiber.OplaxMonoidal` (L35), δ-iso via
  `isColimitPresheafFiberCocone.tensor` + `coconePointUniqueUpToIso` (L95-98),
  `.ofOplaxMonoidal` upgrade (L100).

## Genuinely absent
- The comparison map and its iso proof (Riou's TODO). No varying-ring colimit-tensor lemma exists;
  `directLimitLeft` and `Module.DirectLimit` are both fixed-ring.

## Project state grounding
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean` already has the d.1 layer axiom-clean:
`stalkLinearMap` (L535), `stalkLinearMap_germ` (L576), `stalkLinearMap_bijective_of_isIso` (L597),
`stalkLinearEquivOfIsIso` (L610). The open sorry is `isLocallyInjective_whiskerLeft_of_W` (L411);
its in-file comment (L439-441) already pinpoints d.2 ("identify `(F ◁ g)_x` with
`LinearMap.lTensor F_x (stalkLinearMap g x)`") as the absent piece. d.2 extends exactly this layer.

## Top suggestion

Build d.2 against `ColimitFunctor.ModuleColimit`, not raw `Stalk.lean`. Follow the skeleton in
`Sites/Point/Monoidal.lean:35-100` (define the comparison `δ` by the colimit universal property;
prove it iso via "tensor of colimit cocones is a colimit cocone"), **but** replace its
`IsColimit.tensor`-on-the-monoidal-tensor step — which does not transfer, since the relative tensor
is over a varying ring — with `IsColimit.tensor` on the **underlying `AddCommGrp` cocones**, i.e. the
very cocone `ColimitFunctor.lean` already forms in `coconeSMul`/`jointly_surjective₂`. Then prove the
comparison `R_x`-linear and bijective: surjectivity from `jointly_surjective₂`, injectivity from a
filtered-colimit relation lemma. First file to touch:
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, extending the `stalkLinearMap` layer with a
bilinear `stalkTensorComparison` and the `stalkLinearMap g x = lTensor F_x (g_x)` identification that
discharges `isLocallyInjective_whiskerLeft_of_W` (L411). First sub-step (Riou's refactor TODO, done
locally): bridge the `(OpenNhds x)ᵒᵖ` stalk colimit to `ModuleColimit` so `jointly_surjective₂/₃`
apply.

**Schedule caveat feeding the escalate decision:** d.2 is a new ~150–250 LOC monoidal construction
with a fiddly linear iso proof. It will realistically NOT close `isLocallyInjective_whiskerLeft_of_W`
axiom-clean in a single prover iter. The progress-critic's FINAL one-iter gate (sorry must decrease
this iter, no soft-land) is in direct tension with d.2's true size. The lane is feasible and the
route is concrete and Mathlib-blessed; the honest expectation is multi-iter, so a continue decision
should budget accordingly rather than expect a one-iter close.

## Discarded
- Base-change reduction to fixed-ring `directLimitLeft` (`AlgebraTensorModule.cancelBaseChange`
  diagram-wise): a valid alternative assembly but spends several change-of-rings lemmas per stage,
  costlier than the direct `ColimitFunctor` build; kept only as fallback.
- `Sites/Point/IsMonoidalW.lean` instance reuse — confirmed (per directive) template-only; fixed base.

## Persistent file
- `analogies/ts-d2-feasibility-215.md` — analogue list + building-block inventory for future iters.

Overall verdict: d.2 is **buildable (verdict b)** from present, recent Mathlib — it is Joël Riou's
named TODO with the colimit-scalar plumbing already in `ColimitFunctor.lean` — but it is an authored
~150–250 LOC construction (comparison map + iso proof), moderate risk, and realistically multi-iter,
so it will not satisfy a one-iter sorry-decrease gate.
