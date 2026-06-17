# Mathlib Analogist Report

## Mode
api-alignment

## Slug
pbu-canon

## Iteration
241

## Question
(1) Is `SheafOfModules.pullbackObjUnitToUnit`'s instance-shape canonical, or is the project
fighting a design mismatch? (2) What is the canonical Mathlib idiom for transporting `IsIso`
across a coherence equation `pbu(h;f) = … ; … ; …` without re-triggering instance synthesis
on the components? (3) Will this instance-canonicity issue RECUR in Phase 2/3?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Comparison-map / `IsIso`-instance signature is canonical | PROCEED | informational |
| Idiom for transporting `IsIso` across the coherence eqn | ALIGN_WITH_MATHLIB | major (proof-level, not shipped-signature) |
| Recurrence in Phase 2/3 | PROCEED | informational |

## Answer to Q1 — the shape IS canonical; you are NOT fighting a design mismatch

`pullbackObjUnitToUnit` and its iso instance are *Mathlib's own*, in
`.lake/packages/mathlib/Mathlib/Algebra/Category/ModuleCat/Sheaf/PullbackFree.lean`:

- `pullbackObjUnitToUnit φ := ((pullbackPushforwardAdjunction φ).homEquiv _ _).symm
  (unitToPushforwardObjUnit φ)` — literally the adjunction-mate of the concrete
  pushforward-side map.
- `instance [F.Final] : IsIso (pullbackObjUnitToUnit φ)` — proved via
  `isIso_iff_coyoneda_map_bijective` + `bijective_pushforwardSections`. Instance-arg list
  (from hover): `[F.IsContinuous J K] [J.HasSheafCompose (forget₂ RingCat AddCommGrpCat)]
  [K.HasSheafCompose (forget₂ …)] [(pushforward φ).IsRightAdjoint] [F.Final]`.

Those "buried implicits" are NOT design noise: `IsContinuous`/`HasSheafCompose`/
`IsRightAdjoint` are precisely the data required to *define* `pushforward`/`pullback`/the
adjunction, and `F.Final` is the genuine mathematical hypothesis. This is the standard
Mathlib shape for "an adjunction-mate comparison that is iso under a hypothesis". The
closest direct precedent is `CategoryTheory.Functor.Monoidal.μIso`
(`Mathlib.CategoryTheory.Monoidal.Functor`): the monoidal lax-comparison `μ` is exposed as a
**bundled `Iso`** keyed on `[F.Monoidal]`, with `μIso_hom : (μIso F X Y).hom = μ F X Y` —
Mathlib hands out the `Iso`, it does not publish a bare `IsIso (μ …)` and reason about it on
composites. So the project's signature usage is identical to Mathlib's idiom. The wall is a
Lean typeclass-resolution accident, not a signature problem.

## Answer to Q2 — the canonical idiom: bundle as `asIso`, reason at the `Iso` level

Do NOT close `IsIso` of the `rw`-produced composite with `infer_instance`. Mathlib's idiom —
used in the SAME file by `pullbackObjFreeIso`, which builds
`(asIso (sigmaComparison _ _)).symm ≪≫ Sigma.mapIso (fun _ ↦ asIso (pullbackObjUnitToUnit φ))`
— is to wrap each comparison in `asIso` at a clean construction site and compose at the
`Iso` level. For the project's cancellation goal ("from `IsIso (A ≫ B ≫ C)` with `A`, `C`
iso, get `IsIso B`"):

1. `iA := (Scheme.Modules.pullbackComp V.ι f).symm.app _` — a `NatIso` component; its
   `.hom`/`.inv` are iso **unconditionally** via `CategoryTheory.Iso.isIso_hom` /
   `Iso.isIso_inv` (no `Final` involved).
2. `iC := asIso (pullbackObjUnitToUnit V.ι.toRingCatSheafHom)` — built ONCE in a local
   `have`, where the only in-scope instance steering synthesis is the matching
   `(Opens.map V.ι.base).Final`; this *freezes* the `IsRightAdjoint`/`Final` implicits into
   the term.
3. Cancel with `CategoryTheory.IsIso.of_isIso_comp_left`
   (`(f g) [IsIso f] [IsIso (f ≫ g)] : IsIso g`, in `Mathlib.CategoryTheory.Iso`) then
   `IsIso.of_isIso_comp_right`; the middle leg `(Scheme.Modules.pullback V.ι).map (pbu f)`
   stays as the residual `IsIso` target. Use `Functor.mapIso` / `Functor.mapIso_hom`
   (`Mathlib.CategoryTheory.Iso`) if you want the pullback leg bundled too.

Why this dissolves the block: `(asIso e).hom`'s iso-ness comes from the *global*
`Iso.isIso_hom` instance, which has no `IsRightAdjoint`/`Final` implicit. So no downstream
`IsIso (pbu ?)` synthesis goal ever exists to collide with a stale local
`haveI : IsIso (pbu g)`. The current failure is exactly that collision: Lean tries the local
`haveI` first (head `IsIso (pbu ?)` matches), fails to unify the `Prop`-valued
`(pushforward φ).IsRightAdjoint` / `F.Final` implicit terms (defeq, not syntactically eq at
reducible transparency), and aborts instead of backtracking to the global `OfFinal` instance.

Recommended concrete move, mirroring `μIso`: add a thin project-local wrapper
`pullbackObjUnitToUnitIso φ [F.Final] := asIso (pullbackObjUnitToUnit φ)` plus, if helpful,
an `Iso`-level restatement of `pullbackObjUnitToUnit_comp` (the analogue of `μIso_hom`), and
route the chart-chase through it. Of the prover's three listed fixes, option (1) (named
type-ascribed `Iso`s before the rewrite) is the right one; this report makes it precise and
ties it to the Mathlib precedent. Option (2) (a `@[instance] lemma` wrapper) only relocates
the same `IsRightAdjoint`/`Final` unification and is NOT recommended.

## Answer to Q3 — recurrence: Phase 2 yes (same fix), Phase 3 no; NOT a signature bottleneck

The root cause is the `rw [coherence]; infer_instance` pattern on a composite, not the `pbu`
signature. Therefore:

- **Phase 2** (`pullbackObjTensorToTensor`, proved iso by the same finality chart-chase) WILL
  hit the identical wall *if* it again routes through `rw + infer_instance`. It is the direct
  analogue of `μ`/`μIso`, so adopt the bundled-iso idiom there too — then it is mechanical.
- **Phase 3** (`pullbackTensorIso⁻¹ ≫ f^*e ≫ pullbackUnitIso`) will NOT recur: it composes
  already-bundled `Iso`s, i.e. it is iso-level reasoning by construction.

Crucially: because the *shape is canonical*, there is nothing to refactor in the
comparison-map API (and it is upstream Mathlib regardless). The cheaper, correct path is the
one-time adoption of the bundled-`asIso` idiom as the project's standard pattern for these
finality-keyed comparisons — a per-proof idiom applied uniformly, not a signature/instance
refactor and not a throwaway local hack.

## Major

- Idiom for transporting `IsIso` across the coherence equation: align the chart-chase proof
  in `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (HANDOFF block, lines ~1011–1049) to
  the bundled-`asIso` / `Iso`-level pattern Mathlib uses in `PullbackFree.lean`
  (`pullbackObjFreeIso`) and `CategoryTheory.Monoidal.Functor` (`μIso`). The current
  `rw [pullbackObjUnitToUnit_comp …]; infer_instance` cannot close because stale local
  `haveI : IsIso (pbu …)` hypotheses shadow the global `OfFinal` instance and fail to unify
  the buried `IsRightAdjoint`/`Final` implicits. This is proof-level (no shipped signature is
  wrong), hence Major rather than Must-fix-this-iter.

## Informational

- Q1 (signature canonical) and Q3 (recurrence) are PROCEED: the project uses Mathlib's exact
  API correctly; no upstream or project signature change is warranted or possible.
- Mathlib precedents cited: `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree`
  (`pullbackObjUnitToUnit`, `instance … IsIso …`, `pullbackObjFreeIso`);
  `Mathlib.CategoryTheory.Monoidal.Functor` (`Functor.Monoidal.μIso`, `μIso_hom`);
  `Mathlib.CategoryTheory.Iso` (`IsIso.of_isIso_comp_left`, `Iso.isIso_hom`, `Functor.mapIso`,
  `Functor.mapIso_hom`).

## Persistent file
- `analogies/pbu-canon.md` — design-rationale captured for future iters.

Overall verdict: the `pbu` signature is canonical (mirrors `Functor.Monoidal.μIso`); the
block is a Lean TC-resolution accident on `rw`-composites, fixed once and for all by Mathlib's
own bundled-`asIso`/`Iso`-level idiom (per `pullbackObjFreeIso`), which also pre-empts the
Phase-2 recurrence — no signature refactor is needed or possible.
