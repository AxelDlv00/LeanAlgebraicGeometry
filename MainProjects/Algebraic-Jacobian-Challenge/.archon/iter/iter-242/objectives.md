# Iter-242 — objectives detail

## Lane 1 (CRITICAL PATH) — `Picard/TensorObjSubstrate.lean`, A.1.c substrate Phase 2 `pullbackTensorIso` [mathlib-build]

iter-241 closed Phase 1 (`pullbackUnitIso`) axiom-clean. The remaining cost of `IsInvertible.pullback` is
Phase 2 `pullbackTensorIso : f^*(M⊗N) ≅ f^*M ⊗ f^*N`. The iter-240 "build a comparison map + finality
chart-chase" plan is RETRACTED — there is no comparison map at the sheaf level (the abstract left adjoint
has no sectionwise value). The mathlib-analogist (`analogies/pullback-tensor.md`) found the correct route,
and the strategy-critic ts242 verified the construction is sound and gap-free.

**THE ROUTE (Mathlib PR #36599 mirror; blueprint `lem:pullback_tensor_iso`):**
1. **Concrete strong-monoidal pullback `P`.** Build `P = sheafify ∘ (sectionwise extension of scalars)`
   (the presheaf inverse image followed by sheafification — same `SheafOfModules.sheafificationCompPullback`
   shape used in `tensorObj_restrict_iso`). Equip `P` with a strong-monoidal structure: tensorator =
   `TensorProduct.AlgebraTensorModule.distribBaseChange` (the strong-monoidal core of Mathlib's
   `(extendScalars φ).Monoidal`, `ModuleCat/Monoidal/Adjunction.lean`, PR #36599 — VERIFIED in-tree at the
   pin) sheafified; unit = the landed `sheafifyTensorUnitIso`.
2. **`P ⊣ pushforward f`.** Exhibit the adjunction (universal property of sheafified extension of scalars).
   This is the single genuine build obligation; if it is Mathlib-absent at the pin, it IS the mathlib-build
   target (not a blueprint gap) — build it axiom-clean.
3. **`pullbackTensorIso` = three-iso composite (strategy-critic ts242 refinement — the CHEAP path).**
   `Scheme.Modules.pullback f` is defeq `(pushforward f).leftAdjoint`; both adjunctions share the right
   adjoint `pushforward f`, so `Adjunction.leftAdjointUniq` gives a BARE functor iso `pullback f ≅ P`.
   Then define
     `pullbackTensorIso := leftAdjointUniq.app (M⊗N) ≪≫ P.tensorator M N ≪≫ (leftAdjointUniq whiskered on each factor)`,
   every leg an iso ⇒ the composite is an iso AUTOMATICALLY. **Do NOT** attempt to register a
   `MonoidalCategory`/`Functor.Monoidal` instance on the abstract `Scheme.Modules.pullback` (heavier, and
   strategy-critic confirmed it is NOT needed for `IsInvertible.pullback`). This is structurally identical
   to the iter-217 `tensorObj_restrict_iso` closure (`leftAdjointUniq` precedent).

**Phase 3 — `IsInvertible.pullback` (blueprint `lem:isinvertible_pullback`).** If Phase 2 lands this iter,
attempt Phase 3 in the SAME dispatch (progress-critic ts242 note): composite
`pullbackTensorIso⁻¹ ≫ f^*e ≫ pullbackUnitIso` on the existing witness `e : M⊗N ≅ 𝒪_X`. Iso-level by
construction.

**Verified ingredients** (analyst + strategy-critic, all present at the pin): `distribBaseChange`
(`Mathlib.LinearAlgebra.TensorProduct.Tower`); `extendScalars` monoidal machinery
(`Mathlib.Algebra.Category.ModuleCat.Monoidal.Adjunction`, `extendScalars_μ`/`_δ`); `Adjunction.leftAdjointUniq`
(`(F⊣G)→(F'⊣G)→(F≅F')`); `SheafOfModules.sheafificationCompPullback`; `sheafifyTensorUnitIso` (landed).

**Negative results — do NOT pursue (analyst pullback-tensor):** (i) "an (op)lax monoidal functor preserves
invertibles for free" is FALSE (`Γ(ℙ¹,𝒪(1))=0`) — the comparison MUST be shown to be an iso; (ii) the
locally-free route (`IsLocallyTrivial M → IsInvertible M`) revives the shelved dual-gluing arc.

**Secondary cleanup (lean-auditor ts241 MAJOR):** delete the now-stale HANDOFF comment block at
TensorObjSubstrate.lean ~L1120–1172 (it predates the iter-241 resolution and asserts `pullbackUnitIso` is
"NOT closable" + `pullbackObjUnitToUnit` iso "only for Final/open-immersion f" — both now false). The
accurate section note at ~L1011–1035 already records the resolution.

mathlib-build: no sorry pins. Do NOT touch the group-law section or the deferred dual-bridge sorries
(`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`).

## Lane 2 (engine, parallel) — `Cohomology/FlatBaseChange.lean`, pullback-of-tilde dictionary [mathlib-build]

iter-241 closed `pushforward_spec_tilde_iso`. The affine close `affineBaseChange_pushforward_iso` needs the
PULLBACK companion dictionary (the iter-241 prover + `informal/affineBaseChange_pushforward_iso.md` both name
it as the next brick).

**TARGET 1 — `pullback_spec_tilde_iso` (blueprint `lem:pullback_spec_tilde_iso`, NEW this iter).**
`(Spec φ)^* (M̃) ≅ (R'⊗_R M)~` as `(Spec R')`-modules, natural in `M`. Source = Stacks Tag 01I9
`lemma-widetilde-pullback` part (1) (`references/stacks-schemes.tex` L1241–1269). This is the pullback
analogue of the just-closed `pushforward_spec_tilde_iso`: pullback along `Spec φ` is extension of scalars
`— ⊗_R R'`; the global sections of the pulled-back sheaf are `R'⊗_R M`; the comparison is the base-change
unit. **progress-critic ts242 monitoring note:** the pushforward direction took 4 iters on a
`restrictScalars` carrier wall — use `ext`/`rfl` idioms early (per the iter-241 `restrictScalarsCongr`
lesson), NOT `rw`-matching on restricted-scalar morphisms; if the `IsLocalizedModule`/base-change instance
for `R'⊗_R M` does not synthesize cleanly, report early rather than accumulating helpers.

**TARGET 2 — `affineBaseChange_pushforward_iso` (blueprint `lem:affine_base_change_pushforward`).** With
both dictionaries in hand, close the affine base change: the locality reduction is already in the body
(`Modules.isIso_iff_isIso_app_affineOpens`); the two dictionaries identify both sides as iterated tensor
products; the remaining crux is identifying the abstract adjoint-mate `pushforwardBaseChangeMap.app U` with
the concrete `TensorProduct.AlgebraTensorModule.cancelBaseChange : (R'⊗_R A)⊗_A M ≅ R'⊗_R M` (no flatness).
Attempt this after Target 1 lands; if the adjoint-mate↔cancelBaseChange identification proves intractable
this iter, leave its documented partial (no bare sorry) and hand off.

Do NOT attempt `flatBaseChange_pushforward_isIso` (L~704; deep Čech + flatness, out of scope).

mathlib-build: no sorry pins.
