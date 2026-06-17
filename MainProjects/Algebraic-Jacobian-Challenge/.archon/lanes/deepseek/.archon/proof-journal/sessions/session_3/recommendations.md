# Recommendations for iter-006 (next plan-agent iteration)

## Headline

Iter-005 closed both helper-scaffold definition objectives (`instHasSheafCompose_forget_CommRing_AddCommGrp`, `PicardFunctor`) under the standard axioms. Net sorry count: 12 → 10 (9 protected + 1 deferred `PicardFunctor.representable`). The project is in a clean compile state, ready for iter-006 to scaffold and attack the next layer.

## Recommended primary track for iter-006

**Phase A step 2 — `HasSheafify (Opens.gT X) AddCommGrpCat`.** This is the immediate successor of `HasSheafCompose` and the next link in the chain `HasSheafCompose → HasSheafify → HasExt → Module k on H¹ → Serre finiteness → genus`.

- Plan agent first-action: verify whether Mathlib's `HasSheafify` infrastructure (currently strongest for `Type u`-valued sheaves on a Grothendieck topology) is *directly* applicable to `AddCommGrpCat`-valued sheaves on the topology of opens. If yes, scaffold the instance in a new `AlgebraicJacobian/Cohomology/Sheafify.lean` (or extend `Cohomology/SheafCompose.lean`). If not, the refactor agent must construct the sheafification by hand — a significantly larger scaffold.
- Search probes before scaffolding: `lean_leansearch "HasSheafify AddCommGrpCat"`, `lean_local_search "HasSheafify"`, `lean_loogle "HasSheafify _ AddCommGrpCat"`. Also check `Mathlib.CategoryTheory.Sites.Sheafification` and successor files.
- The body of the eventual prover task will likely use the algebraic-forget-functor preservation (analogous to this session's `comp_preservesLimits` route), plus possibly a transfer along the closure of `HasSheafCompose`.
- Estimated complexity: comparable to this session's Track 1 if Mathlib's sheafification API is ready; significantly larger if not.

## Recommended parallel low-coupling track for iter-006

**Phase C step 3 — étale sheafification of `PicardFunctor`.** The iter-005 helpers `PicardFunctor.fiberMap` and `PicardFunctor.quotMap` are reusable as entry points.

- Plan agent first-action: scaffold a new `AlgebraicJacobian/Picard/EtaleSheaf.lean` (or extend `Picard/Functor.lean`) with a definition of the étale-sheafified Picard functor. The étale Grothendieck topology on `(Over (Spec (CommRingCat.of k)))` is the missing input — `lean_local_search "étale topology"` / `lean_leansearch "etale Grothendieck topology scheme"` to identify whether Mathlib `b80f227` carries the étale topology on `Sch / Spec k`.
- If the étale topology is missing, the refactor agent must construct it (or a coarse stand-in like the Zariski topology, with documentation that this is not the intended target).
- Mathlib API to lean on: `presheafToSheaf` (general Grothendieck-topology sheafification), `Mathlib.AlgebraicGeometry.EllipticCurve.Pullbacks`, étale-related files in `Mathlib.AlgebraicGeometry.EtaleMorphism` and `Mathlib.AlgebraicGeometry.PreSheafedSpace`.
- This track does *not* unblock `representable`; it produces the standard étale-sheaf relative Picard whose representability would be the FGA theorem.

## What to NOT re-issue

- **`PicardFunctor.representable`** (`Picard/Functor.lean` L185). FGA-level theorem. Honest closure requires: (1) `LineBundle` refinement (gated on `MonoidalCategory X.Modules`), (2) the FGA representability argument via Hilbert schemes / quotient stacks. Both are multi-iteration projects. Closing on the global-sections approximation is forbidden. Wait until at least both prerequisites are in motion.
- **The 9 protected sorries** (`Genus.lean` × 1, `Jacobian.lean` × 5, `AbelJacobi.lean` × 3). All blocked behind upstream Mathlib infrastructure or `representable`. The 5 `Jacobian.lean` sorries collapse to `representable` once that lands; the 3 `AbelJacobi.lean` sorries unblock once `Jacobian` is constructed; `genus` unblocks at the end of Phase A.
- **`LineBundle` direct refinement.** Deepening `LineBundle` to the bespoke invertible-quasi-coherent definition is gated on `MonoidalCategory X.Modules`, which is genuinely absent in Mathlib `b80f227` (verified session 2). Building it is a multi-iteration project; do not issue as a primary objective.

## Reusable proof patterns (for iter-006 prover briefings)

The plan agent should propagate these patterns into iter-006 prover briefings. Each is justified by a session-3 use case (referenced in `summary.md`).

1. **Universe pinning when chaining `PreservesLimitsOfSize` instances.** Explicit `.{u}` annotations on each category are required for the elaborator to hit the consumer-side `{u, u}` shape. (`Limits.comp_preservesLimits` use case.)
2. **Snake_case lemma names in `CategoryTheory.Limits.Preserves.Basic`.** `comp_preservesLimits`, not `compPreservesLimits`. Try snake_case first on `Unknown identifier` errors in the Limits API.
3. **`Type u` morphisms are wrapped in `TypeCat.Hom`.** `α → β` is not `α ⟶ β`. Use `TypeCat.ofHom` to lift a function. Recurs in any `_ ⥤ Type u` definition.
4. **`pullback.hom_ext` + simp lemmas for fiber-product functoriality.** Direct `rw [pullback.map_comp]` fails due to path-dependent commuting-square proofs. Prove `comp_fst` / `comp_snd` simp lemmas via `pullback.lift_fst` / `pullback.lift_snd`, then close functoriality via `pullback.hom_ext`.
5. **`QuotientGroup.eq_one_iff` for descent through `QuotientGroup.lift`.** Mathlib's canonical lemma is the bare-coercion form `↑x = 1 ↔ x ∈ N`, not via `mk'`. Loogle on `QuotientGroup.mk ?x = 1 ↔ ?x ∈ ?N` surfaces it.
6. **Source-category for relative functors should be `(Over (Spec k))ᵒᵖ`, not `Schemeᵒᵖ`.** A generic `S : Scheme` has no canonical structure map to `Spec k`. Match the convention from `Jacobian.lean`.

## Open questions for the plan agent

1. **Refactor scope for iter-006.** Is the plan to advance Phase A step 2 (track 1 above), Phase C step 3 (track 2 above), or both in parallel? Both are honest, low-coupling next steps. The session 2 / session 3 pattern of "two parallel low-coupling tracks" appears stable and could continue.
2. **`MonoidalCategory X.Modules`.** Has Mathlib advanced past `b80f227` since iter-003? If yes, re-probing is worthwhile; if no, the `LineBundle` refinement gate remains.
3. **Forward-compatibility documentation.** The blueprint chapters now carry `% NOTE:` flags about the `LineBundle` global-sections approximation flowing through to `PicardFunctor`. These notes should remain in place until the `LineBundle` refinement lands. Consider whether the plan agent wants to consolidate the note into a single project-wide caveat in `STRATEGY.md` or leave them per-chapter.
