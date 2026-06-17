# Project Status

## Overall Progress

- **Total sorry**: 10 (down from 12 at the start of iter-005). Of these:
  - **9 protected** (the deliverables in `archon-protected.yaml`, blocked on Phase A / C / E Mathlib infrastructure):
    - `AlgebraicJacobian/Genus.lean`: 1 (`AlgebraicGeometry.genus` L87)
    - `AlgebraicJacobian/Jacobian.lean`: 5 (`Jacobian` L68, `instGrpObj` L85, `smoothOfRelativeDimension_genus` L92, `instIsProper` L100, `instGeometricallyIrreducible` L107)
    - `AlgebraicJacobian/AbelJacobi.lean`: 3 (`ofCurve` L34, `comp_ofCurve` L39, `exists_unique_ofCurve_comp` L49)
  - **1 deferred** (intentionally kept as `sorry` per directive):
    - `AlgebraicJacobian/Picard/Functor.lean`: 1 (`PicardFunctor.representable` L185) — closing on the global-sections-approximate `LineBundle` would silently assert representability of the wrong functor.
- **Solved this session (iter-005 / session 3)**:
  - `AlgebraicJacobian/Cohomology/SheafCompose.lean` — `AlgebraicGeometry.Cohomology.instHasSheafCompose_forget_CommRing_AddCommGrp`. Honest 5-line closure via `Limits.comp_preservesLimits` + `hasSheafCompose_of_preservesLimitsOfSize`. Only standard axioms (`propext` / `Classical.choice` / `Quot.sound`).
  - `AlgebraicJacobian/Picard/Functor.lean` — `AlgebraicGeometry.Scheme.PicardFunctor` (definition only). Plus 8 helper lemmas: `fiberMap`, `fiberMap_comp_snd`, `fiberMap_comp_fst`, `fiberMap_id`, `fiberMap_comp`, `quotMap`, `quotMap_mk`, `quotMap_id`, `quotMap_comp`. Source-category change `Schemeᵒᵖ → (Over (Spec _))ᵒᵖ` documented in file docstring and task result. Only standard axioms. **Note:** the underlying `LineBundle` is still the global-sections approximation from session 2; this flows through to `PicardFunctor` values on non-affine `S` but the *construction itself* is correct.
- **Partial / deferred**: `PicardFunctor.representable` — statement formalized, proof intentionally `sorry` until `LineBundle` refinement and FGA representability machinery land.
- **Blocked** (all 9 protected declarations, unchanged from session 2):
  - `AlgebraicGeometry.genus` — Phase A (coherent sheaf cohomology of structure sheaf). One step closer this session: `HasSheafCompose` for the `CommRing → Ab` forget composite is now closed.
  - `AlgebraicGeometry.Jacobian` and four instances — Phase C; collapse to `PicardFunctor.representable`.
  - `AlgebraicGeometry.Jacobian.ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp` — structurally blocked by `Jacobian C`. The **uniqueness** half of `exists_unique_ofCurve_comp` is reachable from session 2's `eq_of_eqOnOpen` once `Jacobian C` is constructed.
- **Untouched (candidates for iter-006 refactor)**:
  - **Track 1 (recommended primary):** `AlgebraicJacobian/Cohomology/Sheafify.lean` (proposed; would house Phase A step 2 — `HasSheafify (Opens.gT X) AddCommGrpCat` — natural successor of this session's `HasSheafCompose` closure).
  - **Track 2 (recommended parallel low-coupling):** `AlgebraicJacobian/Picard/EtaleSheaf.lean` (proposed; would house Phase C step 3 — étale sheafification of `PicardFunctor` — using this session's `fiberMap` / `quotMap` as entry points).

## Files in scope and compilation status

| File | Sorries | Compiles? | Notes |
|---|---|---|---|
| `AlgebraicJacobian/Genus.lean` | 1 | yes | Unchanged this session (protected, excluded). |
| `AlgebraicJacobian/Jacobian.lean` | 5 | yes | Unchanged this session (protected, excluded). |
| `AlgebraicJacobian/AbelJacobi.lean` | 3 | yes | Unchanged this session (protected, excluded). |
| `AlgebraicJacobian/Rigidity.lean` | 0 | yes | Closed session 2. |
| `AlgebraicJacobian/Picard/LineBundle.lean` | 0 | yes | Closed session 2 (first-approximation). |
| `AlgebraicJacobian/Cohomology/SheafCompose.lean` | **0** | yes | **Sole sorry closed this session.** |
| `AlgebraicJacobian/Picard/Functor.lean` | **1** | yes | **Definition closed this session**; `representable` deferred. |

Verification: `lake build` exits 0 with 10 sorry warnings; `lake env lean AlgebraicJacobian.lean` exits 0; `lean_diagnostic_messages` per-file confirms no errors.

## Blueprint marker status (after session 3 updates)

| Chapter | Block | Statement | Proof | Notes |
|---|---|---|---|---|
| Genus.tex | `def:genus` | `\leanok` | (sorry) | Unchanged from session 1. |
| Jacobian.tex | `def:Pic_functor` | (none, % NOTE) | n/a | Phase C — superseded by Picard_Functor.tex chapter (now formalized). |
| Jacobian.tex | `thm:Pic_representable` | (none, % NOTE) | n/a | Phase C — superseded by Picard_Functor.tex chapter. |
| Jacobian.tex | `def:Jacobian` | `\leanok` | (sorry) | Unchanged. |
| Jacobian.tex | `thm:Jacobian_grpObj` | `\leanok` | (sorry) | Unchanged. |
| Jacobian.tex | `thm:Jacobian_smooth_genus` | `\leanok` | (sorry) | Unchanged. |
| Jacobian.tex | `thm:Jacobian_proper` | `\leanok` | (sorry) | Unchanged. |
| Jacobian.tex | `thm:Jacobian_geomIrred` | `\leanok` | (sorry) | Unchanged. |
| AbelJacobi.tex | `def:ofCurve` | `\leanok` | (sorry) | Unchanged. |
| AbelJacobi.tex | `lem:comp_ofCurve` | `\leanok` | (sorry) | Unchanged. |
| AbelJacobi.tex | `thm:exists_unique_ofCurve_comp` | `\leanok` | (sorry) | Unchanged. |
| Rigidity.tex | `thm:GrpObj_eq_of_eqOnOpen` | `\leanok` | `\leanok` | Closed session 2. |
| Picard_LineBundle.tex | `def:Scheme_LineBundle` | `\leanok` | n/a | Closed session 2 (first-approximation). |
| Picard_LineBundle.tex | `thm:Scheme_Pic_commGroup` | `\leanok` | `\leanok` | Closed session 2. |
| Picard_LineBundle.tex | `thm:Scheme_Pic_pullback` | `\leanok` | `\leanok` | Closed session 2. |
| Cohomology_SheafCompose.tex | `thm:HasSheafCompose_forget` | `\leanok` (added) | `\leanok` (added) | **Updated this session.** Phase A step 1 closed. |
| Picard_Functor.tex | `def:Pic_functor` | `\leanok` (added) | n/a | **Updated this session.** Two `% NOTE:` flags: source-category change, LineBundle approximation. |
| Picard_Functor.tex | `thm:Pic_representable` | `\leanok` (added) | (sorry) | **Statement marker added this session.** Proof block intentionally unmarked — `% NOTE:` explains forbidden-shortcut closure. |

## Knowledge Base

### Proof Patterns (reusable across targets)

- **Universe pinning when chaining `PreservesLimitsOfSize` instances** (session 3). Explicit `.{u}` annotations on each category are required for the elaborator to match the consumer-side `{u, u}` shape. **Use case:** `Cohomology/SheafCompose.lean`.
- **Snake_case lemma names in `CategoryTheory.Limits.Preserves.Basic`** (session 3). `comp_preservesLimits`, not `compPreservesLimits`. Try snake_case first on `Unknown identifier` errors. **Use case:** ditto.
- **`Type u` morphisms are wrapped in `TypeCat.Hom`** (session 3). `α → β` is not `α ⟶ β`; use `TypeCat.ofHom` to lift functions. **Use case:** `PicardFunctor.map`.
- **`pullback.hom_ext` + simp lemmas for fiber-product functoriality** (session 3). Direct `rw [pullback.map_comp]` fails due to path-dependent commuting-square proofs. Prove `comp_fst` / `comp_snd` standalone via `pullback.lift_fst` / `pullback.lift_snd`, then close functoriality via `hom_ext`. **Use case:** `PicardFunctor.fiberMap_comp`.
- **`QuotientGroup.eq_one_iff` for descent through `QuotientGroup.lift`** (session 3). Mathlib's canonical lemma is the bare-coercion form `↑x = 1 ↔ x ∈ N`, not via `mk'`. **Use case:** `PicardFunctor.quotMap`.
- **Source-category `(Over (Spec k))ᵒᵖ` for relative functors** (session 3). A generic `S : Scheme` has no structure map to `Spec k`; match the `Jacobian.lean` convention. **Use case:** `PicardFunctor`.
- **First-approximation pattern** (session 2). When the ideal Mathlib API is missing, define the target as the closest non-vacuous existing structure correct on a documented sub-class. Document the limitation in (a) file docstring, (b) task result, (c) blueprint via `% NOTE:`, (d) recommendations. **Use case:** `LineBundle` (session 2), inherited by `PicardFunctor` (session 3).
- **Typeclass shape-matching via ascription** (session 2). When `IsX a := proof` does not satisfy a downstream `IsX b` even with `a = b` by `rfl`, ascribe: `haveI : IsX b := (proof : IsX a)`. **Use case:** `IsSeparated (Y.left ↘ Spec _)` in `Rigidity.lean`.
- **Prefer dedicated `_ι`-style lemmas to manual `_iff` rewrites** (session 2). Coercion forms diverge across `f.base` / `TopCat.Hom.hom f.base` / `⇑f`. **Use case:** `Scheme.PartialMap.Opens.isDominant_ι`.
- **`CommRing.Pic.mapRingHom_comp_mapRingHom` runs backward** relative to natural pull-back composition; expect `.symm` (session 2).
- **Forbidden-shortcut sanity check** (session 1). Reduce a candidate against a forced-genus-zero / forced-vacuous test before accepting.
- **`lean_run_code` for definitional-equality probes** (session 1, reused sessions 2 / 3).
- **Search-trail-as-evidence** (session 1). Each task result records a numbered search trail; future iterations re-execute to detect when Mathlib fills a gap.
- **Forbidden-on-approximation pattern** (session 3). When the underlying object is a first-approximation, the *representability* of a derived functor on this approximation is not the same statement as the true representability. Closing the approximate-representability sorry asserts the wrong theorem. **Use case:** `PicardFunctor.representable`.

### Known Blockers (do not retry)

- **`MonoidalCategory X.Modules` absent in Mathlib `b80f227`** (verified session 2). Building it is multi-iteration. Gates the `LineBundle` refinement.
- **The 9 protected sorries** (sessions 1 / 2 / 3). Do not assign as direct prover objectives.
- **`PicardFunctor.representable`** (session 3). FGA-level theorem. Honest closure requires `LineBundle` refinement + FGA argument. Closing on the approximation is forbidden.
- **Symmetric-form rigidity statement is mathematically false in characteristic `p`** (session 2). Frobenius counterexample. Use scheme-level form.

### Forbidden shortcuts (documented, do not re-evaluate)

- `genus C := 0` or any constant — false in genus ≥ 1.
- `Jacobian C := 𝟙_ (Over (Spec _))` — would force `genus C = 0`.
- `ofCurve P := toUnit C ≫ η[Jacobian C]` — falsifies `exists_unique_ofCurve_comp`.
- `LineBundle X := Unit / PUnit / X.Modules` — vacuous or wrong type.
- `PicardFunctor C := Discrete PUnit` or analogous vacuous functor — wrong type.
- Closing `PicardFunctor.representable` on the global-sections-approximate `LineBundle` — silently asserts the wrong representability theorem.
- New `axiom` declarations.

## Next-iteration recommendation (for the plan agent)

See `proof-journal/sessions/session_3/recommendations.md` for the full briefing. Headline:

- **Track 1 (primary):** Phase A step 2 (`HasSheafify (Opens.gT X) AddCommGrpCat`) — natural successor of this session's `HasSheafCompose` closure. Plan agent first probes whether Mathlib's `HasSheafify` API directly applies; if not, scaffold by hand.
- **Track 2 (parallel, low-coupling):** Phase C step 3 (étale sheafification of `PicardFunctor`) — uses this session's `fiberMap` / `quotMap` as entry points. Plan agent first probes whether the étale topology on `Sch / Spec k` is in Mathlib `b80f227`.
- Do **not** re-issue `representable`, the 9 protected sorries, or direct `LineBundle` refinement.

## Last Updated

2026-05-06T07:00:00Z (review agent, post-session 3 / iter-005)
