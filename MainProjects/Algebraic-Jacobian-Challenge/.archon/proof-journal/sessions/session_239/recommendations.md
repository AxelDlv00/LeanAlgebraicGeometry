# Recommendations — after iter-239

## CRITICAL — two blueprint-adequacy gates must clear before the respective prover lanes re-dispatch

Both review subagents flagged that the active chapters' proof sketches misdirect a prover. These are HARD-GATE
blockers for the next plan agent: **do not re-dispatch the affected prover lane until a blueprint-writer fixes
the chapter and a scoped re-review clears it.**

1. **`Picard_TensorObjSubstrate.tex` § `sec:tensorobj_pullback_monoidality` — MUST-FIX, route is unformalizable.**
   (lean-vs-blueprint-checker-tensorobjsubstrate, `task_results/lean-vs-blueprint-checker-tensorobjsubstrate.md`.)
   The proof sketch for `lem:pullback_tensor_iso` Step 2 ("presheaf pullback is sectionwise extension of scalars;
   assemble sectionwise `extendScalars` tensorators") is **factually wrong** at the pinned commit:
   `PresheafOfModules.pullback φ = (pushforward _).leftAdjoint` has no sectionwise formula, so the recipe cannot
   typecheck. All three blocks (`lem:pullback_tensor_iso`/`pullback_unit_iso`/`isinvertible_pullback`) must be
   **rewritten** to the local-chart-finality pivot (via `isIso_of_isIso_restrict`) or the flat-restricted
   alternative, with a `% NOTE:` documenting the abstract-pullback wall and naming the landed
   `sheafifyTensorUnitIso` as the RHS bridge. This is the same pivot the HIGH item below describes — the
   blueprint rewrite is the prerequisite for re-dispatch.

2. **`Cohomology_FlatBaseChange.tex` `lem:pushforward_spec_tilde_iso` — MAJOR, proof sketch misdirects.**
   (lean-vs-blueprint-checker-flatbasechange, `task_results/lean-vs-blueprint-checker-flatbasechange.md`.)
   Movement (2) describes a "D(a)-level ring equation" that **neither exists nor is needed** — the actual
   `gammaPushforwardIsoAt` construction uses the SAME ⊤-level equation (`globalSectionsIso_hom_comp_specMap_appTop`)
   at every open. A prover following it literally would hunt for an unprovable equation. The blueprint-writer
   should: (a) correct movement (2); (b) add a `% NOTE:` documenting the carrier-instance wall that blocks the
   `hloc` naturality square; (c) add `\lean{}` blocks pinning the two new decls `gammaPushforwardIsoAt`
   (after `lem:gammaPushforwardIso`) and `tildeRestriction_isLocalizedModule` (after `lem:powers_restrictScalars`).

## MAJOR — documentation rot on `tensorObj_assoc_iso` (TensorObjSubstrate.lean) — STILL unfixed since iter-238

Both lean-auditor-ts239 and lean-vs-blueprint-checker-tensorobjsubstrate re-flag (carried from iter-238): the
`tensorObj_assoc_iso` **docstring** (L296–340) and the **file STATUS block** (L44–46) still claim the decl is
"sorry-transitive only through route-(e) `isLocallyInjective_whiskerLeft_of_W`", but the body uses route-(d)
(`W_whisker{Left,Right}_of_W` + `isIso_sheafification_map_of_W`) and has NO such dependency. This actively
misrepresents the decl's dependency graph. Fix is a prover/refactor edit to the Lean comments (outside the
review agent's write domain). Schedule a comment-cleanup pass. Report: `task_results/lean-auditor-ts239.md`.

## MEDIUM — workflow/runtime noise embedded in source comments

(lean-auditor-ts239.) Two source comments contain runtime/workflow state that will be immediately stale:
`TensorObjSubstrate.lean:971` ("Informal agent unavailable this iter: MOONSHOT key 401…") inside the HANDOFF
block, and `FlatBaseChange.lean:205` ("See `task_results` for the full attempt log" — a non-navigable runtime
path). Strip on the next prover/refactor touch of those files.

## HIGH — `IsInvertible.pullback` substrate (TensorObjSubstrate.lean): the dispatched recipe is DEAD; do a design pass before re-dispatch

The plan-agent recipe ("presheaf pullback is strong-monoidal sectionwise via `(extendScalars f).Monoidal`;
assemble the sectionwise tensorators") is **structurally impossible**, verified live: `(Sheaf|Presheaf)OfModules.pullback`
is `(pushforward _).leftAdjoint`, an abstract left adjoint with **no sectionwise / stalkwise formula** in the
pinned Mathlib. There is no sectionwise `(pullback φ).obj` to attach an `extendScalars` tensorator to.

**Do NOT re-dispatch the sectionwise-`extendScalars` recipe.** This is the first prover round on this target
(UNCLEAR/fresh per progress-critic ts239), so it is not yet a churn-stall — but the next round must change the
approach, not retry. Two routes, ranked by the prover's handoff:

1. **Local-chart-finality** via the already-axiom-clean `isIso_of_isIso_restrict` (L567) + the local FINAL map
   `g = f.resLE U V` (how `IsLocallyTrivial.pullback` handles general `f`, `LineBundlePullback.lean` L156).
   First sub-step = build the Mathlib-absent naturality cluster `pullbackObjUnitToUnit` / `pullbackComp` /
   `restrictFunctorIsoPullback` (a handful of lemmas). For `pullbackTensorIso` this is harder (no canonical
   sheaf comparison map) — transport the presheaf oplax `δ` to the sheaf level, then apply the same local
   trick; the **landed** `sheafifyTensorUnitIso` is the RHS reconciliation it consumes.
2. **STRATEGIC, cheapest:** the RPF structure maps are the projection `π_T : C ×_S T → T` (FLAT, since
   `C → Spec k` is flat) and base changes thereof (also flat). A **FLAT-restricted** `IsInvertible.pullback`,
   or carrying functoriality on the already-general `IsLocallyTrivial.pullback` and bridging to `IsInvertible`
   only at the group law, may avoid the general pullback-monoidal build entirely. **Caveat:** the
   `IsLocallyTrivial ⟹ IsInvertible` reverse bridge is the hard deferred dual-gluing, so
   "forward-then-pullback-then-reverse" is NOT a shortcut.

**Action for the plan agent:** run a **mathlib-analogist** (cross-domain-inspiration: "abstract left-adjoint
pullback of sheaves of modules — does Mathlib identify it sectionwise/stalkwise anywhere, e.g. via `extendScalars`
on stalks or a Kan-extension formula?") AND a **strategy-critic** pass on the FLAT-restricted alternative,
BEFORE committing a prover to route (1). The blueprint chapter `Picard_TensorObjSubstrate.tex` §
`sec:tensorobj_pullback_monoidality` describes the now-dead recipe — it needs a writer pass to record the
abstract-pullback wall and the chosen pivot before the next prover round (HARD GATE: do not re-dispatch the
target until the chapter reflects the real route).

## HIGH — FlatBaseChange `hloc` / `pushforward_spec_tilde_iso`: reversing signal is ARMED

The iter-239 plan armed an explicit reversing signal: *a 4th sorry-flat iter on this lane triggers a route
pivot, NOT a 5th blueprint expansion.* This iter is that 4th flat iter on the affine close (`affineBaseChange_pushforward_iso`
still sorry; the hard commitment carried since iter-237 is again unmet). **However**, real recovery occurred:
two genuinely-needed axiom-clean bricks landed (`gammaPushforwardIsoAt` = blueprint movement (1); `tildeRestriction_isLocalizedModule`
= the `R'`-side localization input), and the residual is now sharply localized to the single `hloc(a)` obligation.

**Do NOT re-expand the blueprint and do NOT re-dispatch a verbatim `hloc` round** (the `Module.compHom` letI /
`restrictScalars` carrier wall is now in its 4th recurrence — 234, 236, 237, 239). The prover named two concrete
unblocks:
- **(a)** Prove naturality of `gammaPushforwardIsoAt` in its open argument (a `NatTrans`-style lemma: the iso
  commutes with the `Γ`-restriction maps on both sides). Then the `of_linearEquiv` finish closes `hloc`.
- **(b)** Pivot to the **tower** route (avoids the square): peel `ρ` (by defeq, as the OBJECT does in
  `gammaPushforwardIsoAt`) as `restrictScalars gsR (restrictScalars appTop σ₁)`, apply
  `IsLocalizedModule.powers_restrictScalars` (R←Γ via `gsR`) then again (Γ←Γ via `appTop`) then
  `IsLocalizedModule.of_restrictScalars` (Γ←R' via `gsR'`). Risk: the same `Module`/`Algebra` instance-matching
  wall at each tower level.
- **(c)** If the carrier wall resists a 5th time, **pivot the architecture**: a direct scheme-level
  `IsQuasicoherent`-of-affine-pushforward criterion instead of routing through `hloc`. This is the planner's
  armed structural pivot — pick it if (a)/(b) do not land in ONE round.

Recommend a **mathlib-analogist** consult on whether a basic-open `IsLocalizedModule` identification of an
affine-pushforward section exists, in parallel with attempting (a). Keep the two new bricks and the
`pushforward_spec_tilde_iso` skeleton regardless.

## MEDIUM — Informal agent is down (no external sketch affordance)

Both provers tried `archon-informal-agent.py --provider auto`; `MOONSHOT_API_KEY` returns **HTTP 401 Invalid
Authentication** (same as iter-234/236) and no other provider key (`DEEPSEEK/OPENAI/OPENROUTER/GEMINI_API_KEY`)
is set. The "second opinion when stuck on an approach" tool is unavailable — material on two stuck/blocked
lanes. **User action:** provision a valid key (rotate `MOONSHOT_API_KEY`, or set one of the alternatives).
Surfaced in TO_USER.md.

## Reusable proof patterns discovered (this iter)
- **Rewrite the equation, not pointwise, for CommRingCat-coerced ModuleCat homs.** `∘ₗ` will not unify the
  `∘ₛₗ` pattern when a leg is a `ModuleCat.Hom.hom` over a `CommRingCat` coercion; `LinearMap.comp_apply`/
  `comp_assoc`/`simp [coe_comp]` all no-fire. Use `LinearEquiv.eq_comp_toLinearMap_symm` to rewrite the
  equation, then `IsLocalizedModule.of_linearEquiv_right`. (Closed `tildeRestriction_isLocalizedModule`.)
- **`basicOpen 1 = ⊤` inside a dependent type:** `▸` and `simpa only [PrimeSpectrum.basicOpen_one]` do not
  rewrite inside `tilde.toOpen M (basicOpen 1)`; use `have h := inferInstance; rw [basicOpen_one] at h; exact h`.
- **`sheafifyTensorUnitIso` statement shape:** must spell `PresheafOfModules.Monoidal.tensorObj (R := X.presheaf)`
  (not `MonoidalCategory.tensorObj`) and give the left-whisker object explicitly, or `MonoidalCategoryStruct`
  synthesis on the `Sheaf.val` carrier fails at elaboration.

## Known blockers — do NOT re-assign without a structural change
- **FlatBaseChange `hloc` via `letI Module.compHom`:** the `R`-action is not consumed by `LinearMap.restrictScalars R`
  (4th recurrence of the carrier wall). Element-free `gammaPushforwardIsoAt`-naturality or the tower route only.
- **`IsInvertible.pullback` via sectionwise `extendScalars`:** structurally impossible (abstract left-adjoint
  pullback has no sectionwise formula). Local-chart-finality or FLAT-restricted variant only.

## Closest-to-completion / what to prioritize
- The FlatBaseChange `hloc` is one well-localized obligation away from closing the affine lane — but only if
  approach (a) or (b) breaks the carrier wall in ONE round; otherwise take the (c) architectural pivot.
- The `IsInvertible.pullback` substrate gates the entire RPF carrier re-base (the critical path) — resolving
  its route (design pass) is higher-leverage than the engine lane, but needs the analogist/strategy input first.
