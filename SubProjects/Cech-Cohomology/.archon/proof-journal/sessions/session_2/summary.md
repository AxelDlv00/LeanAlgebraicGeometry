# Session 2 (iter-002) — review summary

## Metadata
- Iteration: 002. Prover model: sonnet. Single prover lane (P1, file `CechHigherDirectImage.lean`).
- Sorry count: **3 → 2** (one closed: `CechNerve` L91). Remaining: `CechAcyclic.affine` (L774),
  `cech_computes_higherDirectImage` (L811) — both intentionally out-of-scope, genuinely blocked.
- Targets attempted: `pushPullMap_comp` (P1 primary), `CechNerve` (P2 stretch). **Both solved,
  both axiom-clean** (`propext`, `Classical.choice`, `Quot.sound` only — I re-verified with
  `lean_verify` on `AlgebraicGeometry.pushPullMap_comp` and `AlgebraicGeometry.CechNerve`).
- `lake`/diagnostics: file compiles; only style warnings (long lines L257–259). No errors.

## P1 — `pushPullMap_comp` (composition functor law) — SOLVED

The plan agent dispatched this as a "build-and-prove the non-existent decl" lane. The prover
found the **opposite**: `pushPullMap_comp` and its whole dependency chain were **already written**
by a prior iter, but the file was **red** — a supporting lemma `pushPull_pentagon` (~L545) had a
hard `rewrite` failure, so nothing in the cone compiled.

### Attempt 1 (failed) — the planner-recommended mate-calculus route
Routing via `conjugateEquiv_comp` + injectivity of `conjugateEquiv` to the pullback-side
`pseudofunctor_associativity` → **`(deterministic) timeout at whnf, 200000 heartbeats`**. This is
the *same* kernel `whnf` blow-up the planner's blocker note attributed only to the pushforward
`erw` grind. **The recommended conjugateEquiv route is itself infeasible** — a Knowledge-Base
correction (see below).

### Attempt 2 (success) — bypass conjugateEquiv via `rawPushPullMap`
The real lever was fixing `pushPull_pentagon`. The prior `cancel` sub-proof used
`rw [reassoc_of% h1, reassoc_of% h2]`, which failed: `h1`/`h2` stated objects in composed-functor
form `(F ⋙ G).obj` while the goal carried them applied `G.obj (F.obj _)` — definitionally equal
but **not syntactically**, so `reassoc_of%` would not fire. Errors seen along the way:
`Tactic rewrite failed: motive is not type correct`, then `Did not find an occurrence of the
pattern ... (pullbackComp b (a ≫ p₁)).inv.app F`.

Fix:
```
simp only [Functor.comp_obj] at h1 h2 ⊢   -- align (F⋙G).obj → G.obj (F.obj _)
rw [reassoc_of% h1, reassoc_of% h2]        -- now the ≫ object args agree syntactically
```
Fixing that one lemma compiled `pushPullMap_comp` (`exact rawPushPullMap_comp …`) and its whole
cone (`rawPushPullMap_self(_gen)`, `pushPullMap_eq_raw`, etc.). The landed proof reduces
`pushPullMap → rawPushPullMap` via the `rfl`-lemma `pushPullMap_eq_raw`, then applies
`rawPushPullMap_comp`, which `subst`s the two over-triangle equalities (trivialising all
`eqToHom` transports) and uses `pushPull_unit_comp` + `pushPull_pentagon`. **It never touches
`conjugateEquiv`.**

## P2 — `CechNerve` (stretch) — SOLVED

Once `pushPullFunctor` is a genuine functor (needs both `pushPullMap_id` and `pushPullMap_comp`),
the nerve assembles from off-the-shelf parts with no hand-built coherence:
1. `coverCechNerveOver` — lift the geometric backbone to `SimplicialObject (Over X)` via
   `Over.lift (coverCechNerve 𝒰).left (coverCechNerve 𝒰).hom`.
2. `coverCechNerveOverAug` — augment to `SimplicialObject.Augmented (Over X)` with point the
   **terminal** `Over.mk (𝟙 X)` (`Over.mkIdTerminal`); coherence `w` is automatic by terminal
   uniqueness (`Over.mkIdTerminal.hom_ext`) — no diagram chase.
3. `CechNerve` — `.rightOp` flips simplicial→cosimplicial, then
   `CosimplicialObject.Augmented.whiskeringObj … (pushPullFunctor F)` transports structure +
   augmentation through `G`.

Dead end: initially used `.leftOp` (un-ops the codomain — wrong); needs `.rightOp` with a type
ascription `(coverCechNerveOver 𝒰 : SimplexCategoryᵒᵖ ⥤ Over X)` because `SimplicialObject (Over X)`
doesn't reducibly expose its `ᵒᵖ` shape. `CechNerve` was relocated from L83 to just before
`relativeCechComplexOfNerve` (forward-pointer comment left at old site; `\lean{}` pin unchanged).
`CechComplex` (defined via `CechNerve`) is now transitively axiom-clean too.

## Reviewer findings (read the full reports; do not re-read here)

- **lean-auditor** (`task_results/lean-auditor-iter002.md`): mathematically sound, **0 must-fix**.
  5 **major** = stale comment clusters in `CechHigherDirectImage.lean` that still call
  `pushPullMap_comp`/`CechNerve` "remaining"/"the single genuine hole" (L84–88, L161–183,
  L245–293, L410–449, L739–745) — now false. Minor: dangling cross-ref to
  `Picard/TensorObjSubstrate.lean` (L87, file not in this project), stale "six main declarations"
  header (L35, lists four), three large `maxHeartbeats` overrides (L404/467/533), blanket
  `import Mathlib`. **No `\leanok` laundering.** Fixes need `.lean` edits → next prover/refactor.
- **lean-vs-blueprint-checker** (`task_results/lean-vs-blueprint-checker-cechhdi.md`): the two
  focus decls faithfully implement their blueprint blocks; signatures correct, bodies axiom-clean.
  **0 must-fix.** 1 **major** = the `lem:push_pull_comp` proof *sketch* describes the
  `conjugateEquiv_comp` route that was abandoned as infeasible; a prover following it literally
  would fail. I added a `% NOTE:` flagging this (below); the plan agent should dispatch a
  blueprint-writer to rewrite the sketch to the `rawPushPullMap`/`subst`/pentagon route.

## `\leanok` sync anomaly (investigated, NOT papered over)

`lem:push_pull_id`, `lem:push_pull_comp`, `lem:push_pull_unit_mate`, `lem:push_pull_transport_cancel`
all have **complete, verified, axiom-clean** proofs but carry **no `\leanok`** on statement or
proof. `sync_leanok-state.json` reports `iter: 2` but `added: 0, removed: 0, chapters_touched: []`,
and its `sha: c42d466` does **not** match working-tree `HEAD: 62a7d82` (the prover's edits are
uncommitted in the working tree). This looks like a **sync timing / sha mismatch** — sync ran
against a tree where these proofs were not yet closed — **not** laundering and **not** a real
proof gap (I confirmed the proofs compile). I did **not** touch `\leanok` (out of my domain).
Next sync_leanok pass should add these four; if it does not, the loop's sync ordering vs. commit
point needs inspection. Surfaced for the planner in `recommendations.md`.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:push_pull_comp`: added `% NOTE:` on the proof
  block — the sketch's `conjugateEquiv_comp` route is infeasible (whnf blow-up); landed proof
  uses `rawPushPullMap`/`subst`/`pushPull_pentagon`. Directs the planner to a blueprint-writer.

No `\mathlibok` added (both landed decls are project proofs, not Mathlib re-exports). No `\lean{}`
corrections needed (no renames — `pushPullMap_comp`/`CechNerve` kept their planned names). No
stale `\notready` (none present).

## Blueprint doctor
`logs/iter-002/blueprint-doctor.md`: one finding — `Cohomology_AcyclicResolution.tex` covers
`AlgebraicJacobian/Cohomology/AcyclicResolution.lean`, which does not exist yet (expected forward
reference; the file is scheduled for iter-003 scaffolding once the P4 anchor must-fix lands). No
orphan chapters, no broken refs. Carried into `recommendations.md`.

## DAG state
0 ∞-gaps. Frontier = 5 ready nodes (`def:right_acyclic`, `lem:injective_resolution_of_ses`,
`lem:cech_to_cohomology_on_basis`, `lem:cech_augmented_resolution`, `lem:higher_direct_image_presheaf`).
`unmatched` = 12 `lean_aux` helpers with no blueprint block (1-to-1 coverage debt) — listed in
`recommendations.md`.
