# Iter-241 — objectives detail

## Lane 1 (CRITICAL PATH) — `Picard/TensorObjSubstrate.lean`, A.1.c substrate `IsInvertible.pullback` via Route Z [mathlib-build]

iter-240 landed the two coherence linchpins axiom-clean (`pullbackObjUnitToUnit_comp` — the named
"genuinely-new ingredient" — and `unitToPushforwardObjUnit_comp`). `pullbackUnitIso` did NOT close: a
Lean TC-resolution accident (NOT math, NOT a design-shape problem — confirmed by mathlib-analogist
pbu-canon). Blueprint: `Picard_TensorObjSubstrate.tex` § `sec:tensorobj_pullback_monoidality`
(`lem:pullback_unit_iso`, `lem:pullbackObjUnitToUnit_comp`, `lem:unitToPushforwardObjUnit_comp`;
gate CLEARS, blueprint-reviewer ts241-fastpath).

**THE FIX (mathlib-analogist pbu-canon, api-alignment; persistent `analogies/pbu-canon.md` — READ IT):**
the `pullbackObjUnitToUnit`/`IsIso` signature is CANONICAL (it is Mathlib's own, mirrors
`Functor.Monoidal.μIso`). The block is the `rw [coherence]; infer_instance` anti-pattern: a stale local
`haveI : IsIso (pbu …)` shadows the global `OfFinal` instance and fails to unify the buried
`IsRightAdjoint`/`Final` implicits. **Do NOT** close the composite's `IsIso` with `infer_instance`, and
do NOT add a `@[instance] lemma` wrapper (relocates the same collision). Instead use Mathlib's own
**bundled-`asIso` / `Iso`-level idiom**, exactly as `pullbackObjFreeIso` does in
`Mathlib/Algebra/Category/ModuleCat/Sheaf/PullbackFree.lean`:

1. Add a thin wrapper `pullbackObjUnitToUnitIso φ [F.Final] := asIso (pullbackObjUnitToUnit φ)` (the
   analogue of `μIso`); optionally an `Iso`-level restatement of `pullbackObjUnitToUnit_comp`
   (analogue of `μIso_hom`).
2. In the per-chart lemma, build each component as a NAMED `Iso` at a clean site where the only
   in-scope steering instance is the matching `(Opens.map _).Final` — this freezes the implicits:
   - `iA := (Scheme.Modules.pullbackComp V.ι f).symm.app _` (NatIso component; `.hom`/`.inv` iso
     unconditionally via `Iso.isIso_hom`/`Iso.isIso_inv` — no `Final`);
   - `iC := asIso (pullbackObjUnitToUnit V.ι.toRingCatSheafHom)` built ONCE in a local `have`;
   - cancel with `CategoryTheory.IsIso.of_isIso_comp_left` then `IsIso.of_isIso_comp_right`; the middle
     leg `(Scheme.Modules.pullback V.ι).map (pbu f)` is the residual `IsIso` target (bundle via
     `Functor.mapIso` if helpful).
   Reason at the `Iso` level throughout; `(asIso e).hom`'s iso-ness comes from the global `Iso.isIso_hom`
   instance (no `IsRightAdjoint`/`Final` implicit), so no `IsIso (pbu ?)` synthesis goal ever collides
   with a stale local `haveI`.
3. Globalize `pullbackUnitIso` via the axiom-clean `isIso_of_isIso_restrict` (L567).
4. Reuse the `i1…i7`/naturality chain of `IsLocallyTrivial.pullback` (`LineBundlePullback.lean:156-193`)
   and the now-proved `pullbackObjUnitToUnit_comp` for the per-chart composite.

**Phase 2 — `pullbackTensorIso` (`f^*(M⊗N) ≅ f^*M⊗f^*N`), POINTWISE iso, attempt after Phase 1.**
Build `pullbackObjTensorToTensor` (analogue of `pullbackObjUnitToUnit`); prove iso by the same finality
chart-chase. **Apply the SAME bundled-`asIso` idiom** (mathlib-analogist Q3: Phase 2 WILL hit the
identical TC wall if it again routes through `rw + infer_instance`; with the bundled idiom it is
mechanical). DESCOPED: do NOT build the full `OplaxMonoidal f^*` / `CoreMonoidal.ofOplaxMonoidal`
packaging (off-path; `leftAdjointOplaxMonoidal` absent). `sheafifyTensorUnitIso` (~L884) is the RHS
reconciliation after `SheafOfModules.sheafificationCompPullback`.

**Phase 3 — `IsInvertible.pullback`.** Composite `pullbackTensorIso⁻¹ ≫ f^*e ≫ pullbackUnitIso` on the
existing witness (Stacks `lemma-pullback-invertible`, blueprinted `lem:isinvertible_pullback`). Iso-level
by construction (mathlib-analogist Q3: NO recurrence here).

mathlib-build: no sorry pins. Land Phase 1 axiom-clean (the recipe is now precise — expected to close),
attempt Phase 2 + 3; hand off a precise decomposition if Phase 2 doesn't close. Do NOT touch the
group-law section or the deferred dual-bridge sorries (`exists_tensorObj_inverse` L693,
`addCommGroup_via_tensorObj` L1181).

## Lane 2 (engine, parallel) — `Cohomology/FlatBaseChange.lean`, close `pushforward_spec_tilde_iso` via the NatIso refactor [prove]

progress-critic ts241 = **STUCK**; corrective = the NatIso refactor as a ONE-SHOT structural attempt
(NOT another helper round on the failed `hsq` rewrites). Blueprint: `Cohomology_FlatBaseChange.tex`
`lem:pushforward_spec_tilde_iso` + the new `lem:gammaPushforwardIsoAt_naturality` (gate CLEARS,
blueprint-reviewer ts241-fastpath; must-fix resolved).

**The structural pivot (review iter-240 + blueprint fbc-natiso):** repackage `gammaPushforwardIsoAt` as
a genuine `NatIso` via `NatIso.ofComponents` of the per-open `e_U`. Then naturality-in-the-open (the
`hsq` residual) is the definitional `naturality` field / `NatTrans.naturality` — sidestepping the
`restrictScalarsComp'App` rewrite-matching pathology entirely. `gammaPushforwardIsoAt` lives in THIS
file; its only consumers (`gammaPushforwardTildeIso`, `pushforward_spec_tilde_iso_of_isLocalizedModule`)
use only `.app U`, which `NatIso` provides — so the refactor is consumer-safe.

Then: the per-`a` `hloc(a)` follows from the `⊤`-level localization (`tildeRestriction_isLocalizedModule`
via `algebraize [φ.hom]` + `@IsLocalizedModule.powers_restrictScalars`, both VERIFIED landed iter-240) +
the NatIso open-naturality square at `D(a) ⊆ ⊤` — NO per-`a` hand-proved section square. Feed
`{hloc(a)}` to `pushforward_spec_tilde_iso_of_isLocalizedModule` (L395, axiom-clean) ⇒ close
`pushforward_spec_tilde_iso` ⇒ close `affineBaseChange_pushforward_iso` (L470). Do NOT attempt the L492
`flatBaseChange_pushforward_isIso` (deep Čech+flatness; documented).

**HARD TRIP-WIRE (progress-critic ts241 STUCK, EXPLICIT):** the sorry count on
`pushforward_spec_tilde_iso` MUST strictly decrease this iter. If it stays flat AGAIN after the NatIso
refactor, Route B PAUSES immediately — the next step is the Mathlib bump (#37189,
`isIso_fromTildeΓ_pushforward`, collapses the def to ~3 lines), NOT another in-tree rewrite round. This
is a hard condition, recorded in `iter/iter-241/plan.md`.
