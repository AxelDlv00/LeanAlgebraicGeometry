# Session 207 — review of iter-207

## Metadata

- **Iteration**: 207 (single prover lane: Lane TS, `mathlib-build` mode).
- **File touched**: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (only).
- **Sorry trajectory**: global **80 → 80** (net 0). TS file **3 → 3**
  (`tensorObj_restrict_iso`, `exists_tensorObj_inverse`,
  `addCommGroup_via_tensorObj` all unchanged). No new sorry introduced.
- **Build**: GREEN. Axioms: kernel-only `{propext, Classical.choice, Quot.sound}`
  for the new declarations (`lean_verify`). Zero `axiom` declarations
  project-wide (blueprint-doctor confirms). 25th+ consecutive zero-axiom build.
- **COE**: not dispatched (escalation pause honored, 4th consecutive iter).

## What landed (the productive half)

Three axiom-clean declarations implementing blueprint
`lem:restrictscalars_laxmonoidal`, ~lines 95–176 of the TS file:

- `PresheafOfModules.restrictScalarsLaxε` — the lax unit, assembled sectionwise
  from `Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (α.app X).hom)`.
- `PresheafOfModules.restrictScalarsLaxμ` — the lax tensorator, sectionwise.
- `PresheafOfModules.restrictScalarsLaxMonoidal` (instance) — the full
  `LaxMonoidal` structure on `PresheafOfModules.restrictScalars α` for a
  morphism `α` of presheaves of commutative rings.

This is permanent, reusable Mathlib-supplement infrastructure. It IS the iter-207
plan's stated PRIMARY mathlib-build target, and it was delivered clean.

The proof technique (reusable — see Knowledge Base): each presheaf-level
lax-monoidal field reduces *sectionwise* to the already-proven `ModuleCat`-level
fact via `ext1 Z; exact Functor.LaxMonoidal.<law> (F := ModuleCat.restrictScalars
(α.app Z).hom) ...`. The two non-coherence fields (ε/μ naturality) needed `erw`
chains (not `simp`) because the rewrites sit under definitional unfolding:
- ε: `ext r; dsimp; erw [PresheafOfModules.unit_map_one, ModuleCat.restrictScalars_η,
  ModuleCat.restrictScalars_η]; simp only [map_one]; erw [PresheafOfModules.unit_map_one]`
- μ: `refine ModuleCat.MonoidalCategory.tensor_ext (fun m₁ m₂ ↦ ?_); dsimp;
  erw [PresheafOfModules.Monoidal.tensorObj_map_tmul, ModuleCat.restrictScalars_μ_tmul,
  ModuleCat.restrictScalars_μ_tmul, PresheafOfModules.Monoidal.tensorObj_map_tmul]; rfl`
- `set_option backward.isDefEq.respectTransparency false` is required (mirrors
  Mathlib's own `PresheafOfModules.Monoidal` setup).

## The defining finding (the unproductive half) — the iter-207 premise was DISPROVEN

The iter-207 plan committed to option (a) "a bounded ~40–90 LOC mathlib-build"
on the explicit premise (from `analogies/mate207.md` + two consults) that the
sectionwise lax instance was **the SOLE remaining project-side ingredient** for
`tensorObj_restrict_iso`, with everything else (the mate δ, the `comp`, the
flat-exactness upgrade) already in Mathlib. The plan ARMED a reversal
pre-commitment: "the prover finding the sectionwise instance cannot unblock the
iso ⇒ escalate."

**That reversal signal FIRED.** The prover built the lax instance axiom-clean,
then found that it does NOT unblock the iso. Two structural blockers:

1. **Ring-layer mismatch (fatal for the δ-route).** The scheme module ring
   presheaf is `RingCat`-valued: `f.toRingCatSheafHom.hom` lands in
   `PresheafOfModules` over `X.ringCatSheaf.obj` (RingCat), which has **no
   monoidal structure** — `inferInstance` for the `MonoidalCategory` fails — so
   `(pushforward φ).LaxMonoidal` and its δ cannot even be *stated* there. The
   file's Steps 1–2 (`restrictFunctorIsoPullback` + `sheafificationCompPullback`)
   deposit the residual at exactly this RingCat layer. Meanwhile `tensorObj`
   itself uses the *CommRingCat*-valued `X.presheaf`. The δ-route and the
   `tensorObj` definition live at **different ring layers**.
2. **Composition wall (at the CommRingCat level).** Even there,
   `pushforward φ` (codomain `F.op ⋙ ?R`, `F.op` outermost) and
   `restrictScalarsLaxMonoidal` (needs `?S ⋙ forget₂`, `forget₂` outermost)
   **cannot be composed by instance resolution** — a `⋙`-vs-`forget₂`
   associativity mismatch. The prover built a `pushforwardLaxMonoidal` instance
   attempting this; it would not typecheck; it was REMOVED (no dead code, no new
   sorry).

So `analogies/mate207.md`'s "sole project-side gap" claim was **incorrect**. The
prover's own memory (`ts-restrict-iso-residual.md`) and task result record this.

## Process correctness

- The reversal pre-commitment fired exactly as armed — this is the loop working
  as designed. TS now joins COE in the **multi-step / structural-re-route
  regime**; it is no longer a "one instance away" lane. This is the THIRD time
  the TS lane has landed "the foundational input" while the critical-path sorry
  count did not move (iter-205 cone-reduction, iter-206 two reduction steps,
  iter-207 the lax instance) — the same recession pattern that drove the COE
  escalation. The next planner MUST NOT autopilot another TS helper round.
- COE pause honored (4th iter). Correct.
- blueprint-doctor: **no structural findings** (all chapters `\input`'d, all
  refs resolve, no `axiom` decls).
- `sync_leanok` ran for iter-207 (sha 90ee645e, added 1, touched the TS
  chapter): the added `\leanok` is the statement-block marker on
  `lem:tensorobj_restrict_iso` (the decl exists with a sorry body, so a
  statement-level `\leanok` is correct; no proof-level `\leanok`).

## Subagent findings

- **lean-auditor iter207** (`task_results/lean-auditor-iter207.md`): **PASS,
  0 must-fix-this-iter.** The 3 new decls honest & axiom-clean; no dead code from
  the removed `pushforwardLaxMonoidal` attempt; TS sorry count confirmed = 3.
  2 pre-existing majors carried forward (held lanes: `RelPicFunctor.lean:266`
  TODO excuse-comment, `IdentityComponent.lean:391` "sanctioned temporary sorry"
  docstring); 1 minor (stale iter-number annotations in the TS docstring).
- **lean-vs-blueprint-checker ts-iter207**
  (`task_results/lean-vs-blueprint-checker-ts-iter207.md`): **1 must-fix** — the
  blueprint `lem:tensorobj_restrict_iso` proof + `% NOTE` falsely claim the lax
  instance is the "SOLE remaining project-side ingredient"; this blocks the next
  TS prover and needs a blueprint-writer rewrite (review added a corrective
  `% NOTE:` flag this iter). It pins the actual residual: a presheaf-level
  strong-monoidal `(PresheafOfModules.pullback φ.hom).Monoidal` lift (absent in
  Mathlib), or the line-bundle sectionwise re-route. **1 major** — missing
  `\lean` pin on `lem:restrictscalars_laxmonoidal` (review added it this iter).

Findings landed in `recommendations.md §0`.

## Blueprint markers updated (manual)

- `Picard_TensorObjSubstrate.tex`, `lem:restrictscalars_laxmonoidal`: added
  `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` pin (the prover landed
  this exact decl, axiom-clean; previously the block had no pin so `sync_leanok`
  could not mark it). Also added a `% NOTE:` flagging that the lemma's "sole
  ingredient" half is disproven.
- `Picard_TensorObjSubstrate.tex`, `lem:tensorobj_restrict_iso`: added a
  `% NOTE:` recording that the chapter's proof is NOT formalizable as written —
  the lax instance does not unblock the iso (ring-layer mismatch + composition
  wall); a structural re-route is required, not one further instance.

(No `\mathlibok` added: `restrictScalarsLaxMonoidal` is a project-local lift with
genuine discharged proof obligations, not a direct Mathlib re-export.)
(No `\leanok` touched — owned by `sync_leanok`.)

## Recommendations

See `recommendations.md`. Headline: STOP treating TS as "one instance away";
the next planner must pick a structural re-route (options a/b/c) or pause TS and
pivot — this is now a planner decision, not a prover dispatch.
