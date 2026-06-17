# Project Progress

## Current Stage
prover  (iter-004 prover round: close the 4 scaffold sorries laid by the iter-004 refactor)

## Stages
- [x] init
- [x] autoformalize
- [ ] prover
- [ ] polish

## Big-picture context

This project formalizes the Jacobian of a smooth proper geometrically irreducible curve over a field, following Christian Merten's challenge (`references/challenge.lean`). The nine declarations in `archon-protected.yaml` are the deliverables — their signatures are frozen.

`STRATEGY.md` describes the multi-phase build-out path (Phases A–E). The 9 protected sorries continue to be blocked behind missing Mathlib infrastructure; the iter-004 refactor opens two parallel low-coupling helper tracks (Phase A steps 2–4 wiring; Phase C step 3 codomain change) that the upcoming prover round will close.

## Iteration 004 — post-refactor verification (PASS)

The iter-004 refactor (`task_results/refactor.md`) is verified by the plan agent:

- **Compile**: `lake build` exits 0; `lean_diagnostic_messages` per-file confirms only the expected sorry warnings, no errors.
- **Sorry counts**: total 14 (was 10 pre-refactor; +4 new scaffold sites). Per file:
  - `Cohomology/StructureSheafAb.lean` (NEW) — 3 sorries (L34 `instHasSheafify_Opens_AddCommGrp`, L42 `instHasExt_Sheaf_Opens_AddCommGrp`, L54 `Scheme.toAbSheaf`).
  - `Picard/FunctorAb.lean` (NEW) — 1 sorry (L41 `Scheme.PicardFunctorAb`).
  - `Picard/Functor.lean` — 1 sorry (L185 `PicardFunctor.representable`, deferred indefinitely; not in scope of this prover round).
  - `Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` — 9 protected sorries (untouched).
- **Signatures**: all four scaffold signatures match the directive verbatim — namespaces (`AlgebraicGeometry.Cohomology` for the two instances, `AlgebraicGeometry.Scheme` for the def and the `PicardFunctorAb`), universe annotations (`.{u}` on each category, `HasExt.{u+1}` on the sheaf category), and source category (`(Over (Spec (CommRingCat.of k)))ᵒᵖ` for `PicardFunctorAb`).
- **Imports**: `AlgebraicJacobian.lean` umbrella now imports the two new files in dependency order. Side-effect of the refactor: the umbrella's existing imports were also reordered to follow the dependency tree. No declarations were renamed or moved.
- **Protected**: `archon-protected.yaml` unchanged. No protected declaration was edited.
- **Blueprint**: `Cohomology_StructureSheafAb.tex` and `Picard_FunctorAb.tex` already exist (written by this plan agent in iter-004 pre-refactor); both are wired into `content.tex`. The `\lean{...}` macros resolve to the four new declarations exactly. No marker changes are due — the prover has not yet run.
- **Axioms**: no new `axiom` declarations anywhere (only the 14 sorries).
- **Forbidden shortcuts**: none — the refactor laid scaffold only, no proofs were filled.

The refactor is therefore accepted. Iteration 004 now advances to the prover round, with two parallel objectives (one per new file).

## Current Objectives — iter-004 prover round

Two parallel agents, one per new file. **Do not** assign any objective on the protected files (`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`) or on `Picard/Functor.lean` (its representability sorry is deferred indefinitely; see "Known dead ends").

### Objective 1 — `AlgebraicJacobian/Cohomology/StructureSheafAb.lean` (Phase A steps 2–4 wiring)

Close the **three** sorries in this file:

- **L34** `AlgebraicGeometry.Cohomology.instHasSheafify_Opens_AddCommGrp` — `HasSheafify (Opens.grothendieckTopology X) AddCommGrpCat.{u}` for `X : TopCat.{u}`.
- **L42** `AlgebraicGeometry.Cohomology.instHasExt_Sheaf_Opens_AddCommGrp` — `HasExt.{u+1} (Sheaf (Opens.grothendieckTopology X) AddCommGrpCat.{u})` for `X : TopCat.{u}`.
- **L54** `AlgebraicGeometry.Scheme.toAbSheaf` — for `C : Scheme.{u}`, the abelian-group sheaf on `Opens.grothendieckTopology C.toTopCat` obtained by composing `C.sheaf` with `forget₂ CommRingCat RingCat ⋙ forget₂ RingCat AddCommGrpCat`.

Blueprint: `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` (`thm:HasSheafify_Opens_AddCommGrp`, `thm:HasExt_Sheaf_Opens_AddCommGrp`, `def:Scheme_toAbSheaf`).

**Plan-agent live Mathlib probe (iter-004) confirms each sorry is closeable:**

1. **`instHasSheafify_Opens_AddCommGrp`** — expected closure: `inferInstance` after universe pinning. The probe ran
   ```
   example (X : TopCat.{u}) :
       HasSheafify (Opens.grothendieckTopology X) AddCommGrpCat.{u} := inferInstance
   ```
   and it succeeded. The instance is composed by Mathlib from `HasWeakSheafify.{…}` plus the preservation-of-finite-limits side condition; both are pre-existing for the `Opens` topology and `AddCommGrpCat`. Mirror the universe-pinning style of the iter-003 `instHasSheafCompose_…` closure (`AlgebraicJacobian/Cohomology/SheafCompose.lean`): annotate each category with `.{u}` so the implicit universe variables in the Mathlib-side instance unify on the nose.
2. **`instHasExt_Sheaf_Opens_AddCommGrp`** — expected closure: `CategoryTheory.HasExt.standard _`. The probe ran
   ```
   noncomputable example (X : TopCat.{u}) :
       HasExt.{u+1} (Sheaf (Opens.grothendieckTopology X) AddCommGrpCat.{u}) :=
     HasExt.standard _
   ```
   and it succeeded. `HasExt.standard` produces a `HasExt` instance from any abelian category (the abelian instance on `Sheaf (Opens.gT X) AddCommGrpCat.{u}` is automatic via the iter-003 `HasSheafCompose` plus Objective 1's `HasSheafify`). The morphism universe of the sheaf category forces the annotation `HasExt.{u+1}`; do not change it. If the bare `HasExt.standard _` does not type-check on first try, look for the explicit anonymous-typeclass placeholder pattern (`HasExt.standard (C := …)`).
3. **`Scheme.toAbSheaf`** — expected closure: a one-line term obtained by composing the iter-003 `HasSheafCompose` instance with `C.sheaf`:
   ```
   noncomputable def toAbSheaf (C : Scheme.{u}) :
       Sheaf (Opens.grothendieckTopology C.toTopCat) AddCommGrpCat.{u} :=
     (sheafCompose (Opens.grothendieckTopology C.toTopCat)
       (forget₂ CommRingCat RingCat ⋙ forget₂ RingCat AddCommGrpCat)).obj C.sheaf
   ```
   The functor `sheafCompose J F` is Mathlib's bundled "post-compose with `F`" on the sheaf category; its `obj` map applied to `C.sheaf : Sheaf (Opens.gT X) CommRingCat` produces the desired `Sheaf (Opens.gT X) AddCommGrpCat`. The `HasSheafCompose` instance on the forget composite is `instHasSheafCompose_forget_CommRing_AddCommGrp` from `Cohomology/SheafCompose.lean` (iter-003) — it should be picked up automatically by typeclass resolution; ensure the universe annotations on the two `forget₂` factors are consistent (`forget₂ CommRingCat.{u} RingCat.{u}` and `forget₂ RingCat.{u} AddCommGrpCat.{u}`, matching iter-003's instance).

If any of the three closures requires more than typeclass plumbing — e.g.\ the probe-style closure does not type-check verbatim and an additional lemma is needed — do not bypass the issue with `decide`/`trivial`/`Discrete PUnit` shortcuts. Document the obstruction in `task_results/Cohomology_StructureSheafAb.lean.md` and let the next plan-agent round re-route. The plan agent's probe confirms the math is in Mathlib; only the Lean-side packaging may need a small adjustment (e.g.\ explicit instance arguments).

**Forbidden shortcuts** for this objective: `:= sorry`-still, `:= ()`/`:= PUnit`/any vacuous-sheaf placeholder, `decide`, `trivial`, new `axiom` declarations. The construction must produce the actual Mathlib `HasSheafify` / `HasExt` / sheaf-composition output.

**Reusable patterns from prior iterations:**

- **Universe pinning** (iter-003): explicit `.{u}` on each category in a chain of `PreservesLimitsOfSize`-style instances. Apply to all three closures.
- **Snake_case lemma names** in `CategoryTheory.Limits.Preserves.Basic` (iter-003).
- **`Type u` morphisms wrapped in `TypeCat.Hom`** (iter-003) — relevant if an underlying-set lemma is invoked.

After closing all three sorries, list any `\leanok` candidates in the task result so the review agent can update the blueprint markers.

### Objective 2 — `AlgebraicJacobian/Picard/FunctorAb.lean` (Phase C step 3 codomain change)

Close the **single** sorry in this file:

- **L41** `AlgebraicGeometry.Scheme.PicardFunctorAb` — for `C : Over (Spec (CommRingCat.of k))`, the contravariant functor `(Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u}` whose underlying-set functor agrees on the nose with `PicardFunctor C` (Chapter `Picard_Functor.tex`).

Blueprint: `blueprint/src/chapters/Picard_FunctorAb.tex` (`def:Pic_functorAb`).

**Expected closure**: a concrete `Functor` constructor analogous to the iter-003 `PicardFunctor` (`AlgebraicJacobian/Picard/Functor.lean` L158–174), with the codomain wrapped in `AddCommGrpCat`:

```
noncomputable def PicardFunctorAb
    (C : Over (Spec (CommRingCat.of k))) :
    (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u} where
  obj S := AddCommGrpCat.of
    (Pic (Limits.pullback C.hom S.unop.hom) ⧸
      (Pic.pullback (Limits.pullback.snd C.hom S.unop.hom)).range)
  map {_ _} f := AddCommGrpCat.ofHom (PicardFunctor.quotMap C f.unop)
  map_id _ := by
    -- reduce to PicardFunctor.quotMap_id
    ...
  map_comp f g := by
    -- reduce to PicardFunctor.quotMap_comp
    ...
```

The helper lemmas are already in `Picard/Functor.lean`:

- `PicardFunctor.quotMap : (Pic ... ⧸ ...) →* (Pic ... ⧸ ...)` is the underlying `MonoidHom`. `AddCommGrpCat.ofHom` should accept it directly (a commutative-group `MonoidHom` is also an `AddMonoidHom` under Mathlib's additive-multiplicative duality on `Pic`; if the bundled-instance idiom requires an explicit `MonoidHom.toAdditive`-style transport, the prover may need to either (a) keep `Pic` multiplicative and use an `AddCommGrpCat`-valued idiom that accepts a `MonoidHom`, or (b) reformulate the quotient as additive). The blueprint chapter explicitly endorses path (a) ("wrapped via `AddCommGrpCat.ofHom`"); confirm this lines up with Mathlib's bundled-category API before resorting to (b).
- `PicardFunctor.quotMap_id` (`@[simp]`) — reduces to `MonoidHom.id _`.
- `PicardFunctor.quotMap_comp` — `quotMap C (g ≫ f) = (quotMap C g).comp (quotMap C f)`.

`map_id` and `map_comp` should reduce to these via `AddCommGrpCat.ofHom_id` / `AddCommGrpCat.ofHom_comp` (or whichever lemmas Mathlib `b80f227` ships under `AddCommGrpCat.ofHom`). Use `lean_local_search` / `lean_loogle` to find the exact lemma names if unsure.

**Forbidden shortcuts** for this objective: `:= sorry`-still, `:= Discrete PUnit`/vacuous-functor placeholder, returning a constant `0` group, redefining `obj` to discard the quotient. The construction must reproduce the exact group `Pic (C ×_k S) / p_S^* Pic(S)` that `PicardFunctor C` already returns at the underlying-set level.

**Reusable patterns from prior iterations:**

- **`(Over (Spec k))ᵒᵖ` source category** (iter-003) — keep this verbatim; the source category was already chosen at iter-003 to match the iter-002 `Pic.pullback` API.
- **`fiberMap` / `quotMap` helpers** (iter-003) — already in scope via `import AlgebraicJacobian.Picard.Functor`. Use them directly; do not re-derive.
- **`AddCommGrpCat.ofHom` of a `MonoidHom`** — if Mathlib `b80f227` requires an `AddMonoidHom` instead, search for `AddCommGrpCat.ofHom`'s actual signature first and adapt.

After closing the sorry, list `\leanok` candidates in the task result for the review agent.

### Difficulty estimate / parallelism

Objective 1 is "three pieces of typeclass plumbing" — moderate, ~20 LOC including imports and namespace boilerplate; the bulk is universe-pinning fights.
Objective 2 is "one concrete `Functor` constructor on top of two existing helper lemmas" — easy, ~25 LOC. The `map_id` / `map_comp` proofs are one-liners after the `obj` / `map` shape is right.

Both are independent: `FunctorAb.lean` does not import `StructureSheafAb.lean`, and vice-versa. The two prover agents run in parallel.

## Anticipated post-prover state

If both objectives close honestly:

- Sorry count: 14 → 10 (back to the 10 pre-refactor: 9 protected + 1 deferred `representable`).
- Blueprint markers: `\leanok` on the four new declaration statements; `\leanok` on the proofs of `thm:HasSheafify_Opens_AddCommGrp`, `thm:HasExt_Sheaf_Opens_AddCommGrp`; `\leanok` on `def:Scheme_toAbSheaf` (statement only — it's a definition); `\leanok` on `def:Pic_functorAb` (statement only). The review agent updates these.
- After this round, **the abelian-group level of `H^n(C, O_C)` is well-defined** as `(Scheme.toAbSheaf C).H n` (using Mathlib's `Sheaf.H` API + the new `HasExt` instance). The remaining work to an honest `genus` is Phase A step 5 (`Module k` structure on `H¹`) and step 6 (Serre finiteness); both are deferred to iter-005+.

If a prover hits an obstruction not foreseen by the plan-agent probe — e.g.\ Mathlib's bundled-category API requires a different idiom for `AddCommGrpCat.ofHom` of a `MonoidHom`, or the universe-pinning style does not transfer cleanly from the iter-003 `HasSheafCompose` closure — they should document it in `task_results/<file>.lean.md` and stop. The plan agent will re-route in the next iteration.

## Reusable proof patterns (for the upcoming prover briefings)

1. **Universe pinning when chaining `PreservesLimitsOfSize` / `HasSheafify` instances** (iter-003) — explicit `.{u}` annotations on each category. Apply to all three Objective-1 closures.
2. **Snake_case lemma names in `CategoryTheory.Limits.Preserves.Basic`** (iter-003).
3. **`Type u` morphisms wrapped in `TypeCat.Hom`** (iter-003) — relevant if an underlying-set lemma is invoked.
4. **`pullback.hom_ext` + simp lemmas for fiber-product functoriality** (iter-003).
5. **`QuotientGroup.eq_one_iff` for descent through `QuotientGroup.lift`** (iter-003) — already inside `quotMap`; the prover only consumes it for Objective 2.
6. **Source-category `(Over (Spec k))ᵒᵖ` for relative functors** (iter-003) — `PicardFunctorAb` keeps the same source as `PicardFunctor`.
7. **First-approximation pattern** (iter-002) — the `LineBundle` first-approximation flows through `PicardFunctor` to `PicardFunctorAb`; the codomain change is purely typeclass.
8. **`HasExt.standard` for an abelian sheaf category** (new, iter-004 probe) — produces `HasExt` from any abelian category; the abelian instance comes from `HasSheafify`.
9. **`sheafCompose J F` to post-compose a sheaf with a functor on the codomain** (new, iter-004) — Mathlib bundled functor on the sheaf category; takes a `HasSheafCompose J F` instance.

## Known dead ends (do not retry)

- The 9 protected sorries (`Genus.lean` × 1, `Jacobian.lean` × 5, `AbelJacobi.lean` × 3) — all blocked behind upstream Mathlib infrastructure (Phase A step 5/6 for `genus`; Phase C representability for `Jacobian`; Phase C + Phase E for `AbelJacobi`). Do not assign as direct prover objectives.
- `PicardFunctor.representable` (`Picard/Functor.lean` L185) — closing on the global-sections-approximate `LineBundle` is a forbidden shortcut. Honest closure requires `LineBundle` refinement (gated on `MonoidalCategory X.Modules`) plus the FGA argument. Multi-iteration; do not retry.
- `LineBundle` direct refinement — gated on `MonoidalCategory X.Modules` (absent in `b80f227`). Multi-iteration; do not issue as a primary objective.
- `HasWeakSheafify Scheme.etaleTopology AddCommGrpCat` — genuine Mathlib gap (verified iter-004 `lean_run_code` probe). Multi-iteration; not in scope of this prover round.
- Vacuous-functor closures (`Discrete PUnit`, etc.) — destroy the downstream Picard chain; rejected on sight.
- Vacuous-sheaf closures for the Phase A wiring (`PUnit.{u+1}`-valued sheaves, etc.) — destroy the downstream cohomology chain; rejected on sight.
- New `axiom` declarations — forbidden by plan-agent rules.
- Symmetric topological-equality form of rigidity (`∀ x ∈ U, g₁.left.base x = g₂.left.base x ⇒ g₁ = g₂`) — false in characteristic `p` (Frobenius). Resolved iter-002 with the scheme-level form.
- `MonoidalCategory X.Modules` is absent in `b80f227` (verified iter-002); building it is multi-iteration, not in scope.

## Output protocol

Each prover writes to `task_results/<file>.lean.md`. Required content:

- which sorries were closed (line numbers and declaration names);
- which sorries (if any) were left open and why (with a clear obstruction summary the plan agent can act on next iteration);
- the actual closure body (fenced code block) for each closed sorry, so the plan agent can verify quickly without re-reading the whole file;
- any minor name adjustments required by Mathlib `b80f227` (analogous to iter-003's `Opens.grothendieckTopology` rename or the `(Over (Spec k))ᵒᵖ` source-category reshape);
- whether any `axiom` declarations were considered (the answer must be "no");
- proposed `\leanok` markers (on which `thm:…` or `def:…` blocks).

The plan agent will independently verify (sorry count + `lean_diagnostic_messages` + axiom check via `lean_verify` + blueprint consistency via `leanblueprint checkdecls`) before declaring the round accepted.

## Related state files

- `STRATEGY.md` — five-phase build-out plan; revision log records iter-001 through iter-004 changes. Iter-004 entry records the substantive Phase A revision (steps 2–3 inferable from Mathlib).
- `task_pending.md` — consolidated gap report and helper-target index. Track B steps 2–4 + Track C step 3 codomain change marked as "scaffolded; prover round in flight".
- `task_done.md` — iter-002 closures (`eq_of_eqOnOpen`, `LineBundle`, `instCommGroupLineBundle`, `Pic.pullback`) and iter-003 closures (`instHasSheafCompose_…`, `PicardFunctor` definition).
- `task_results/refactor.md` — iter-004 refactor agent's report (verified above).
- `REFACTOR_DIRECTIVE.md` — iter-004 directive, executed by the refactor agent. Will be cleared by this plan-agent run (the loop runs at most one refactor per iteration).
- `PROJECT_STATUS.md` — written by the iter-003 review agent (session 3). Will be updated by the review agent after this prover round.
- `proof-journal/sessions/session_1/` — iter-001 review.
- `proof-journal/sessions/session_2/` — iter-002 review.
- `proof-journal/sessions/session_3/` — iter-003 review with full recommendations for iter-004.
