# Session 3 — first prover round on the iter-004 helper scaffolds

## Metadata

- **Session number:** 3 (iteration 005 in `.archon/logs/iter-003/`; the prover log lives at `.archon/logs/iter-003/provers-combined.jsonl` per the dispatcher's path convention).
- **Stage:** prover.
- **Model:** `claude-opus-4-7` (logged as `model: "opus"` in `provers-combined.jsonl`).
- **Sorry count before session:** 12 (9 protected + 3 iter-004 helper-scaffold sorries: `instHasSheafCompose_forget_CommRing_AddCommGrp`, `PicardFunctor`, `PicardFunctor.representable`).
- **Sorry count after session:** 10 (9 protected + 1 deferred: `PicardFunctor.representable`).
- **Net closed this session:** 2 (`instHasSheafCompose_forget_CommRing_AddCommGrp`, `PicardFunctor`).
- **Files edited:** `AlgebraicJacobian/Cohomology/SheafCompose.lean` (3 Edits to one instance body), `AlgebraicJacobian/Picard/Functor.lean` (1 full Write replacing the iter-004 scaffold). `Genus.lean` was reached by a third prover invocation, which correctly stopped per directive and made no edit.
- **Compilation:** `lake build` exits 0; `lake env lean AlgebraicJacobian.lean` exits 0; `lean_diagnostic_messages` confirms only the expected 10 sorry warnings, no errors. Per-file:
  - `Cohomology/SheafCompose.lean` — `[]` (0 errors / 0 warnings, 0 sorry).
  - `Picard/Functor.lean` — 1 sorry warning at L185 (`representable`, deferred), 0 errors.
  - `Picard/LineBundle.lean` — `[]` (unchanged from session 2).
  - `Rigidity.lean` — `[]` (unchanged from session 2).
  - `Genus.lean` — 1 sorry warning at L87 (unchanged, protected).
  - `Jacobian.lean` — 5 sorry warnings at L68 / L85 / L92 / L100 / L107 (unchanged, protected).
  - `AbelJacobi.lean` — 3 sorry warnings at L34 / L39 / L49 (unchanged, protected).
- **Targets attempted:** 2 helper-scaffold targets (objective 1 + objective 2 of `PROGRESS.md`); the 3 protected files were excluded by directive; the `representable` sorry was excluded by directive.
- **Top-level summary:** both helper-scaffold definition objectives **resolved** under the standard axioms only (`propext`, `Classical.choice`, `Quot.sound`). The `PicardFunctor.representable` sorry is intentionally left in place — closing it on the global-sections-approximate `LineBundle` would assert representability of the wrong functor. The Picard functor itself is built honestly on the existing iter-003 `Pic.pullback` API; the underlying `LineBundle` approximation flows through to `PicardFunctor`'s values on non-affine `S` (smaller subgroups than the true relative Picard) but the *construction* itself is correct.

## Per-target outcomes

### Target 1 — `AlgebraicGeometry.Cohomology.instHasSheafCompose_forget_CommRing_AddCommGrp` (Cohomology/SheafCompose.lean L38)

**Status: SOLVED.**

Iter-004 scaffold body was `:= sorry`. The prover closed it with a 5-line term-mode body. Three attempts:

1. **Attempt 1 — `inferInstance`.**
   - Code: `:= inferInstance` (relying on Mathlib's `hasSheafCompose_of_preservesLimitsOfSize` plus `compPreservesLimits` chains).
   - Lean error: `failed to synthesize (Opens.grothendieckTopology ↑X).HasSheafCompose ...; (deterministic) timeout at typeclass, maximum number of heartbeats (20000) has been reached`.
   - Result: FAILED.
   - Insight: pure `inferInstance` blows the heartbeat budget; typeclass search through `PreservesLimitsOfSize` for a 2-step composite is too deep. Must register the composite-preservation instance explicitly.

2. **Attempt 2 — explicit `haveI` with `Limits.compPreservesLimits` (camelCase guess).**
   - Code:
     ```lean
     haveI : PreservesLimits
         (CategoryTheory.forget₂ CommRingCat RingCat ⋙
           CategoryTheory.forget₂ RingCat AddCommGrpCat) :=
       Limits.compPreservesLimits _ _
     CategoryTheory.hasSheafCompose_of_preservesLimitsOfSize _
     ```
   - Lean error: `Unknown identifier 'Limits.compPreservesLimits'; failed to synthesize instance of type class PreservesLimitsOfSize.{u_1, u_1, u_2, u_2, u_2 + 1, u_2 + 1} (forget₂ CommRingC...)`.
   - Result: FAILED.
   - Insight: the lemma name is **snake_case** `Limits.comp_preservesLimits`, not `Limits.compPreservesLimits`. Also the universes need pinning: the Grothendieck topology of opens of `TopCat.{u}` demands `PreservesLimitsOfSize.{u, u}`, but without explicit universes the elaborator cannot reconcile the synthesized `PreservesLimitsOfSize.{?, ?}`.

3. **Attempt 3 — pin universes to `u`, snake_case `Limits.comp_preservesLimits`, target `PreservesLimitsOfSize.{u, u}`.**
   - Code (final 5-line body):
     ```lean
     haveI : PreservesLimitsOfSize.{u, u}
         (CategoryTheory.forget₂ CommRingCat.{u} RingCat.{u} ⋙
           CategoryTheory.forget₂ RingCat.{u} AddCommGrpCat.{u}) :=
       Limits.comp_preservesLimits _ _
     CategoryTheory.hasSheafCompose_of_preservesLimitsOfSize _
     ```
   - Diagnostics: `[]` (clean).
   - Result: SUCCESS.
   - Insight: explicit `.{u}` on each category pins the elaboration into the consumer's expected `{u, u}` shape. The two component preservation instances (`CommRingCat.forget₂Ring_preservesLimitsOfSize`, `RingCat.forget₂AddCommGroup_preservesLimitsOfSize`) infer automatically once the composite is registered. Final body is well under the directive's 20-line budget.

**Final proof structure (SheafCompose.lean L38–L46):** explicit `haveI` for `PreservesLimitsOfSize.{u, u}` of the composite via `Limits.comp_preservesLimits`, then closure by `CategoryTheory.hasSheafCompose_of_preservesLimitsOfSize`.

**Key Mathlib lemmas used:**
- `CategoryTheory.Limits.comp_preservesLimits` — composite of limit-preserving functors preserves limits.
- `CategoryTheory.hasSheafCompose_of_preservesLimitsOfSize` (Mathlib `Sites/Whiskering.lean` L155) — `[PreservesLimitsOfSize.{v₁, max u₁ v₁} F] → J.HasSheafCompose F`.
- `CommRingCat.forget₂Ring_preservesLimitsOfSize` and `RingCat.forget₂AddCommGroup_preservesLimitsOfSize` (Mathlib, auto-resolved).

**Axiom hygiene:** `propext`, `Classical.choice`, `Quot.sound` only. No new axioms. Verified via `#print axioms`.

### Target 2 — `AlgebraicGeometry.Scheme.PicardFunctor` (Picard/Functor.lean L158)

**Status: SOLVED** (definition only — `representable` deferred per directive).

Iter-004 scaffold left two sorries: `PicardFunctor` (definition, L65) and `PicardFunctor.representable` (theorem, L81). Per directive, the prover filled the first only. Significant attempts:

1. **Attempt 1 — bare `MonoidHom` / function as `Type u` morphism.**
   - Code (excerpt): `map {_ _} f := PicardFunctor.quotMap C f.unop` (treating the `MonoidHom` directly as a `Type u` morphism).
   - Lean error: `Type mismatch — f has type α →* β / α → β / fun x ↦ f x, but is expected to have type α ⟶ β`.
   - Result: FAILED (multiple variations: `f`, `⇑f`, `f.toFun`, `fun x ↦ f x`, `this`, …).
   - Insight: in Mathlib `b80f227`, **morphisms in `Type u` are wrapped in `TypeCat.Hom`** — `α → β` is *not* definitionally `α ⟶ β`. Discovered by searching `Mathlib.CategoryTheory.Types.Basic`, `Yoneda.lean`, and `Sites/Types.lean`.

2. **Attempt 2 — wrap with `TypeCat.ofHom`, build the helpers `fiberMap` / `quotMap` first.**
   - Code (final, summarized):
     ```lean
     noncomputable def PicardFunctor (C : Over (Spec (CommRingCat.of k))) :
         (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ Type u where
       obj S := Pic (Limits.pullback C.hom S.unop.hom) ⧸
         (Pic.pullback (Limits.pullback.snd C.hom S.unop.hom)).range
       map {_ _} f := TypeCat.ofHom fun x ↦ PicardFunctor.quotMap C f.unop x
       map_id _ := by
         apply TypeCat.Hom.ext; apply TypeCat.Fun.ext; funext x
         change PicardFunctor.quotMap C (𝟙 _) x = x
         simp
       map_comp f g := by
         apply TypeCat.Hom.ext; apply TypeCat.Fun.ext; funext x
         change PicardFunctor.quotMap C (f ≫ g).unop x =
           PicardFunctor.quotMap C g.unop (PicardFunctor.quotMap C f.unop x)
         rw [unop_comp, PicardFunctor.quotMap_comp]; rfl
     ```
   - Result: SUCCESS, after ~10 sub-attempts on `quotMap` itself (see below).
   - Insight: the definition factors cleanly into `fiberMap` (the induced map on fiber products via `pullback.map`) and `quotMap` (the descent through `QuotientGroup.lift`). `pullback.hom_ext` plus the `fiberMap_comp_fst` / `fiberMap_comp_snd` simp lemmas are robust against the path-dependent commuting-square proofs that `pullback.map_comp` carries.

3. **Sub-attempt: `quotMap` kernel-containment side condition.**
   - Initial guess `QuotientGroup.mk'_eq_one_iff_mem` failed (`Unknown identifier`).
   - Loogle revealed `QuotientGroup.eq_one_iff` — `↑x = 1 ↔ x ∈ N` (without `mk'`).
   - Final body:
     ```lean
     QuotientGroup.lift _
       ((QuotientGroup.mk' _).comp (Pic.pullback (fiberMap C f)))
       (by
         rintro x ⟨m, rfl⟩
         simp only [MonoidHom.mem_ker, MonoidHom.coe_comp,
                    Function.comp_apply, QuotientGroup.mk'_apply]
         rw [QuotientGroup.eq_one_iff]
         refine ⟨Pic.pullback f.left m, ?_⟩
         rw [← MonoidHom.comp_apply (Pic.pullback (Limits.pullback.snd C.hom S₂.hom)),
             ← Pic.pullback_comp, ← fiberMap_comp_snd, Pic.pullback_comp,
             MonoidHom.comp_apply])
     ```
   - Result: SUCCESS.
   - Insight: the descent uses the commutative square `fiberMap C f ≫ pullback.snd S₂ = pullback.snd S₁ ≫ f.left` (which is `pullback.lift_snd` specialized) to send `range(p_{S₁}^*)` into `range(p_{S₂}^*)` via `Pic.pullback (fiberMap C f)`.

**Source-category change** (signature note, recorded in `task_results/Picard_Functor.lean.md`): the iter-004 scaffold had `PicardFunctor C : Schemeᵒᵖ ⥤ Type u`. A generic `S : Scheme` does not come with a structure morphism to `Spec k`, so the fiber product `C ×_k S` is not canonically defined. Following the blueprint's `Sch_k = Sch / Spec k` setup and the convention already used in `Jacobian.lean`, the prover changed the source to `(Over (Spec (CommRingCat.of k)))ᵒᵖ`. Consequences:

- The fiber product is canonically `Limits.pullback C.hom S.unop.hom`.
- `PicardFunctor.representable` correspondingly asks for a representing object inside `Over (Spec k)` — which is exactly the `k`-scheme meaning of "Picard scheme".
- `PicardFunctor` is not in `archon-protected.yaml`; the signature change is permitted.
- No downstream consumers reference `PicardFunctor` yet (verified by `Grep`); zero downstream impact this iteration.
- The `representable` typeclass hypotheses (`SmoothOfRelativeDimension 1 C.hom`, `IsProper C.hom`, `GeometricallyIrreducible C.hom`) are preserved verbatim.

**Final API surface (Picard/Functor.lean):**
- `noncomputable def PicardFunctor (C : Over (Spec (CommRingCat.of k))) : (Over (Spec _))ᵒᵖ ⥤ Type u`
- `noncomputable def PicardFunctor.fiberMap` — induced map on fiber products via `pullback.map`.
- `@[simp, reassoc] lemma PicardFunctor.fiberMap_comp_snd` — the universal-property identity.
- `@[simp, reassoc] lemma PicardFunctor.fiberMap_comp_fst`.
- `@[simp] lemma PicardFunctor.fiberMap_id`.
- `lemma PicardFunctor.fiberMap_comp` — functoriality of `fiberMap`.
- `noncomputable def PicardFunctor.quotMap` — induced map on the quotient via `QuotientGroup.lift`.
- `@[simp] lemma PicardFunctor.quotMap_mk` — quotient-naturality identity.
- `@[simp] lemma PicardFunctor.quotMap_id`.
- `lemma PicardFunctor.quotMap_comp` — functoriality of `quotMap`.
- `theorem PicardFunctor.representable : (PicardFunctor C).IsRepresentable := sorry` — **deferred**.

**Key Mathlib lemmas used:**
- `CategoryTheory.Limits.pullback.map`, `pullback.lift_snd`, `pullback.lift_fst`, `pullback.map_id`, `pullback.hom_ext`.
- `CategoryTheory.Over.w`, `CategoryTheory.Over.comp_left`.
- `CategoryTheory.Limits.HasPullback` for schemes (auto-resolved).
- `QuotientGroup.lift`, `QuotientGroup.mk'`, `QuotientGroup.eq_one_iff`.
- `TypeCat.ofHom`, `TypeCat.Hom.ext`, `TypeCat.Fun.ext` (for the `Type u` morphism plumbing).
- This project (iter-003): `Pic`, `Pic.pullback`, `Pic.pullback_id`, `Pic.pullback_comp`.

**Axiom hygiene:** `PicardFunctor` and all helpers depend only on `propext`, `Classical.choice`, `Quot.sound`. No `sorryAx`, no new axioms. Verified via `#print axioms` for `fiberMap`, `fiberMap_id`, `fiberMap_comp`, `quotMap`, `quotMap_id`, `quotMap_comp`, `PicardFunctor`.

### Target 3 — `AlgebraicGeometry.Scheme.PicardFunctor.representable`
**Status: BLOCKED (deferred by directive).**

The `sorry` remains in place. Per `PROGRESS.md` "Forbidden", per the file's forward-compatibility note, and per the blueprint chapter's "Forward-compatibility note": closing this on top of the global-sections-approximate `LineBundle` would silently assert representability of the wrong functor. Honest closure requires (i) refining `LineBundle` to the bespoke invertible-quasi-coherent definition (gated on Mathlib's `MonoidalCategory X.Modules`, currently absent in `b80f227`) and (ii) implementing the FGA representability argument via Hilbert schemes / quotient stacks — both multi-iteration projects.

### Target 4 — protected files (`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`)
**Status: NOT_STARTED (per directive).**

Per `PROGRESS.md` objective 3, the 3 protected files (9 protected sorries) were not assigned. The dispatcher invoked one prover against `Genus.lean`; that prover correctly stopped, made no edits, and wrote a one-line `task_results/AlgebraicJacobian_Genus.lean.md` referencing `PROGRESS.md`. The protected files retain their session-1 / session-2 state.

## Key findings / proof patterns discovered

1. **Universe pinning for typeclass-driven `PreservesLimitsOfSize` chains.** When a downstream consumer demands `PreservesLimitsOfSize.{u, u} F` for a *specific* universe `u`, registering a universe-polymorphic `haveI : PreservesLimitsOfSize.{?, ?} F` is not enough — explicit `.{u}` annotations on each category are needed so the elaborator unifies into the consumer's expected shape. This pattern likely recurs across the Mathlib `Sites` / `Whiskering` API. **Use case:** `Cohomology/SheafCompose.lean` (this session).
2. **Snake_case lemma names in `Mathlib.CategoryTheory.Limits.Preserves.Basic`.** The composite-preservation lemma is `comp_preservesLimits`, not `compPreservesLimits`. Lean 4 Mathlib has migrated several CategoryTheory lemmas to snake_case for consistency with general Lean 4 naming conventions; camelCase guesses are unreliable. **Generalisation:** when an `Unknown identifier` error is reported on a CategoryTheory lemma name, try the snake_case variant before broader search.
3. **`Type u` category morphisms are wrapped in `TypeCat.Hom` in current Mathlib.** A bare `α → β` is not definitionally `α ⟶ β` in `Type u`'s `Category` instance — `TypeCat.ofHom` is required to lift a function. This recurs whenever building a `Functor _ _ ⥤ Type u`. **Use case:** `PicardFunctor.map` in `Picard/Functor.lean` (this session). **Generalisation:** when a "type mismatch — `α → β` but expected `α ⟶ β`" error appears on a `Type u`-valued functor's `map` field, immediately reach for `TypeCat.ofHom` instead of cycling through `⇑f`, `f.toFun`, `fun x ↦ f x`, ascription, etc.
4. **`pullback.hom_ext` + simp lemmas beats `pullback.map_comp` for functoriality.** Direct rewriting on `pullback.map_comp` for fiber-product functoriality fails because the surrounding proof terms (the `pullback.map`'s commuting squares) carry path-dependent proofs that don't unify under `rw`. The robust pattern is: prove `fiberMap_comp_fst` / `fiberMap_comp_snd` as standalone simp lemmas via `pullback.lift_fst` / `pullback.lift_snd`, then close `fiberMap_comp` via `pullback.hom_ext` + `simp`. **Use case:** `PicardFunctor.fiberMap_comp` (this session).
5. **`QuotientGroup.eq_one_iff`, not `QuotientGroup.mk'_eq_one_iff_mem`.** Mathlib uses the bare-coercion form `↑x = 1 ↔ x ∈ N` (not via `mk'`). This is the canonical lemma for descent through `QuotientGroup.lift`. Loogle (`QuotientGroup.mk ?x = 1 ↔ ?x ∈ ?N`) surfaces it; manual guesses with `mk'_…` in the name fail. **Use case:** `PicardFunctor.quotMap` (this session).
6. **Source-category choice for relative functors.** A generic `S : Scheme` has no canonical structure morphism to `Spec k`, so functors of the form "depends on a fiber product over `Spec k`" must be defined on `(Over (Spec k))ᵒᵖ`, not `Schemeᵒᵖ`. This is a recurring pattern in relative algebraic geometry — every "relative-X functor" should take `S : Over (Spec k)` rather than `S : Scheme + IsAffine S` etc. **Use case:** `PicardFunctor` source change in this session; will recur in any future étale-sheafification work.
7. **The `representable`-on-approximation forbidden shortcut.** When the underlying object is a *first-approximation* (in this project, `LineBundle` is the global-sections approximation `CommRing.Pic Γ(X, ⊤)`), the *representability* of the derived functor on this approximation is not the same statement as the true representability. Closing the approximate-representability sorry would silently assert the wrong theorem. The directive's "Forbidden" rule, the file docstring, the blueprint chapter, and `PROGRESS.md` all agree: keep the sorry. **Use case:** `PicardFunctor.representable` (kept as `sorry` this session).

## Blueprint markers updated

- `Cohomology_SheafCompose.tex`, `thm:HasSheafCompose_forget` — added `\leanok` to the `\begin{theorem}` block (declaration `AlgebraicGeometry.Cohomology.instHasSheafCompose_forget_CommRing_AddCommGrp` exists at L38 of `SheafCompose.lean`, file compiles, 0 sorry, 0 error, 0 new axiom).
- `Cohomology_SheafCompose.tex`, proof of `thm:HasSheafCompose_forget` — added `\leanok` to the `\begin{proof}` block (verified 0 sorry / 0 axiom).
- `Picard_Functor.tex`, `def:Pic_functor` — added `\leanok` to the `\begin{definition}` block (declaration `AlgebraicGeometry.Scheme.PicardFunctor` exists at L158 of `Functor.lean`, file compiles, 0 sorry on this declaration). Added two `% NOTE:` flags above the block: (a) the source-category change from `Schemeᵒᵖ` to `(Over (Spec (CommRingCat.of k)))ᵒᵖ` (Lean realization detail), (b) the global-sections approximation flowing through from `LineBundle`. The `\lean{...}` macro already pointed to the correct name.
- `Picard_Functor.tex`, `thm:Pic_representable` — added `\leanok` to the `\begin{theorem}` block (declaration `AlgebraicGeometry.Scheme.PicardFunctor.representable` exists at L185 of `Functor.lean`; per the marker vocabulary, statement is "formalized with at least a `sorry`"). Added a `% NOTE:` flag explaining that the proof block must remain unmarked until Phase B/C deepens `LineBundle`. **No `\leanok` on the proof block** — the proof is `sorry` and the closure is forbidden by directive.
- No `\lean{...}` macro renames were required — every closed declaration is at the name the chapter already cites.
- No `\notready` markers exist anywhere in the project; none were added.

## Recommendations for next session

See `recommendations.md` in this folder for the full plan-agent briefing. Headline:

1. Iter-005 closed both helper-scaffold definition objectives. The project is ready for iter-006 to either (a) advance Phase A step 2 (`HasSheafify (Opens.gT X) AddCommGrpCat`) — the natural successor to this session's `HasSheafCompose` closure — or (b) advance Phase C step 3 (étale sheafification of `PicardFunctor`) using the `fiberMap` / `quotMap` helpers as entry points. Both feed into the long-term unblock chain for `Genus.lean` and `Jacobian.lean` respectively.
2. The 9 protected sorries plus `PicardFunctor.representable` (deferred) remain blocked exactly as recorded in session 2 / session 3. Do not re-issue them as direct objectives.
3. `LineBundle` refinement (deepen from the global-sections approximation to the bespoke invertible-quasi-coherent definition) remains the gating prerequisite for honestly closing `representable`. No further direct attack on `LineBundle` until Mathlib's `MonoidalCategory X.Modules` lands or is built.
