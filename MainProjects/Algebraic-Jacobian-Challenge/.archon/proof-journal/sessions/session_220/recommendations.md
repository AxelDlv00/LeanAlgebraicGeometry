# Recommendations — for the iter-221 plan agent

## Status of the iter-220 must-fix (already resolved by review)

- **lvb ts220 must-fix — `\lean{}` name mismatch on `def:presheaf_internal_hom`** — **RESOLVED THIS
  ITER.** I corrected the marker to `\lean{PresheafOfModules.InternalHom.internalHom}`. The next
  `sync_leanok` will add `\leanok` to the block (body is axiom-clean). No plan-agent action needed.

## HIGH — clear the cheap blueprint + Lean hygiene items BEFORE dispatching sub-step 3

These are small and removing them now avoids the next prover formalizing against a stale chapter / a
fragile instance. All are ride-along-sized.

1. **Blueprint (lvb ts220 minor):** split `lem:internal_hom_isSheaf` (L2653) into two `\lean{}` pins —
   one for the presheaf-level sheaf-condition verification, one for the
   `AlgebraicGeometry.Scheme.Modules.dual` object construction. As written it pins only the output
   object and hides the intermediate sheaf-condition step, which the sub-step-3/4 prover will need
   named. Dispatch a blueprint-writer on `Picard_TensorObjSubstrate.tex` for this (it also unblocks
   the HARD GATE for the next prover round on the dual/sheafify blocks).
2. **Lean docstring/status hygiene (lean-auditor ts220 major):** the ride-along cleanup was skipped
   this iter (line-shift risk near the sorries). Have the next TS prover (or a refactor pass) fix:
   - module-level status block **L37–45** — claims all 4 pinned decls carry `sorry`, but `tensorObj`
     / `tensorObj_functoriality` are now closed sorry-free;
   - `internalHomObjModule` docstring **L1122** — says `internalHom` "is the remaining downstream
     build", but it was assembled this iter in the same block.
3. **Lean instance hygiene (lean-auditor ts220 major):** add `@[implicit_reducible]` to
   `internalHomObjModule` (L1117) to match its companion `homModule` (L1082). It is a class-type
   `def`; the compiler warns, and without the attribute instance-search for the `Module`/`SMul`
   produced by it may silently fail in downstream elaboration of `r • m` (e.g. when the dual / eval
   sub-steps use `internalHom`). `internalHom` itself currently compiles (the Module was passed
   explicitly via `@ofPresheaf`), so this is forward-looking, not a current break — but cheapest to
   fix before sub-step 3 leans on it.

## MEDIUM — continue the funded build at sub-step 3 (dual + evaluation)

The funded Decision-1 build is on track (sub-step 2 of 5 retired, axiom-clean, on its success bar).
Next chunk, all over the single-universe `Opens X` base (`Category.{u,u}`):

- **sub-step 3a — `PresheafOfModules.dual`** (`def:presheaf_dual`, L2584): `M^∨ := internalHom M (𝟙_…)`.
  Trivial alias once the monoidal unit object is named. Blueprint ADEQUATE per lvb.
- **sub-step 3b — `PresheafOfModules.internalHomEval`** (`lem:internal_hom_eval`, L2604): the
  open-by-open contraction `s ⊗ φ ↦ φ(s)`. Blueprint ADEQUATE.
- Reusable tricks now banked for this chunk (PROJECT_STATUS Knowledge Base + `[[ts-assoc-flatness-gap]]`):
  the `hom_app_heq`/`subst` device for `Over.map` pseudofunctoriality; the explicit-`@ofPresheaf`
  pattern for the CommRingCat/RingCat carrier diamond; the single-universe-section requirement.

**Mode:** mathlib-build (no-sorry invariant). Success bar for iter-221: `dual` aliased + `internalHomEval`
built axiom-clean (sheafification = sub-step 4, a separate chunk).

## DO NOT RETRY

- **`exists_tensorObj_inverse` (L1733)** — infra-bound; needs the *sheaf-level* dual (sub-steps 3–5,
  not yet built). FORBIDDEN until the sheaf-level dual + eval + sheafification land. Re-dispatching
  `prove` here is guaranteed churn (the iter-214 d.1 "dual-shaped helper-sorry" anti-pattern). Both
  review subagents confirm the L1733 `sorry` is an authorized, well-documented placeholder.
- **`addCommGroup_via_tensorObj` (L1777)** — downstream of the inverse; same gate.
- **`isLocallyInjective_whiskerLeft_of_W` (L632)** — the vestigial whiskering sorry; its re-route
  onto the closed `tensorObj_restrict_iso` + deletion remains DEFERRED (needs SheafOfModules morphism
  descent, per `[[ts-assoc-flatness-gap]]`). Not on the critical path; do not spend a prover round on it.

## Progress-critic watch item (carried forward)

The first genuine churn signal for this sub-phase is: a prover round that produces only more
value-module-style helpers (no named new construction, no assembly). iter-220 did NOT trip this (it
assembled `internalHom`). If iter-221 returns sub-step 3 with only wrappers and no `dual`/`eval`,
run a mathlib-analogist (api-alignment) on the dual/eval idiom before re-dispatching. Track this lane
by **sub-step retirement vs the ~6–12 iter estimate (elapsed 2)**, NOT sorry trajectory.

## Reusable proof patterns discovered this iter

- **`hom_app_heq` + `subst`** cracks `Over.map` pseudofunctor coherence: for a Hom `φ` of presheaves
  of modules and an object-equality `h : X = Y`, `HEq (φ.app X) (φ.app Y)` by `subst h; rfl`; then
  `eq_of_heq (hom_app_heq φ <objeq>)` discharges `map_id`/`map_comp` that are not `rfl` because
  `Over.mapId_eq`/`Over.mapComp_eq` are only propositional.
- **Explicit `@ofPresheaf`** for the CommRingCat/RingCat carrier diamond: pass the per-object `Module`
  instance positionally (`fun X => internalHomObjModule X.unop M N`) rather than via `letI` (which is
  kernel-rejected); the def's `respectTransparency false` accepts the defeq carriers.
- **Single-universe section** for `ofPresheaf` assembly: `ofPresheaf` forces the `Ab`-presheaf into
  `Type u`, so state the assembled object over `{D : Type u} [Category.{u,u} D]` (the `Opens X` site).
- `AddCommGrpCat.of`/`.ofHom` (not `AddCommGrp.of`); presheaf functoriality into `AddCommGrpCat` needs
  `apply AddCommGrpCat.hom_ext; refine AddMonoidHom.ext fun φ => ?_`.
