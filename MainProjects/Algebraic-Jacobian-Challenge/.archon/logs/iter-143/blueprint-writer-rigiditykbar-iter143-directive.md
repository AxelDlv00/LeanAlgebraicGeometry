# Blueprint Writer Directive

## Slug
rigiditykbar-iter143

## Target chapter

`blueprint/src/chapters/RigidityKbar.tex` (currently 1349 LOC; iter-141
Wave 3 expansion landed +125 LOC of d_app + d_map + IsIso recipes).

## Strategy context

This chapter holds the named declaration `rigidity_over_kbar` (M2.a) and
the inventory of the shared cotangent-vanishing pile (pieces (i)+(ii)+(iii)).
Piece (i.b) Step 2 is in-flight at iter-143, with iter-142 closing the
d_map sub-sorry substantively (the FIRST strict-count closure on this
route since iter-138). d_app + IsIso remain as the two open sub-sorries
on this route.

**Iter-142 empirical lessons from d_map closure** (per
`task_results/Cotangent_GrpObj.lean.md` iter-142 prover report):

1. **`change` must be fully explicit on both LHS and RHS** when the
   goal crosses `pushforward₀`-annotated definitions. The iter-140
   prover hit a deterministic `whnf` timeout at maxHeartbeats=200000
   with a `_`-placeholder RHS; the iter-142 fix is to spell both sides
   out. This rule applies regardless of whether the equation is
   `_ = 0`-shape or `_ = _`-shape (codified iter-142 Knowledge Base).

2. **`NatTrans.naturality_apply` must be packaged via `rw [show ... from ...]`**
   when the goal carries `RingCat.Hom.hom` / `CommRingCat.Hom.hom`-form
   terms. The bare lemma produces `ConcreteCategory.hom`-form equalities
   that don't unify with the goal's kernel form. The packaging:

   ```lean
   rw [show ((Scheme.Hom.toRingCatSheafHom (snd G G).left).hom.app Y).hom
             ((G.left.presheaf.map f).hom x) =
           ((G ⊗ G).left.presheaf.map ((Opens.map (snd G G).left.base).op.map f)).hom
             (((Scheme.Hom.toRingCatSheafHom (snd G G).left).hom.app X).hom x) from
         NatTrans.naturality_apply
           (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom f x]
   ```

3. **`PresheafOfModules.pushforward_obj_map_apply'`** is the named
   Mathlib lemma (iter-141 mathlib-analogist `d-app-d-map-recipe-shape`
   located at `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:99–106`)
   for unfolding `((pushforward ψ).obj LHS).map f` on the RHS — but
   in iter-142 the unfolding is achieved by `change` instead, so the
   named lemma was not invoked explicitly. The chapter should record
   both options for d_app.

**Iter-143 corrective context (per `progress-critic-iter143` +
`strategy-critic-iter143`)**:

- Iter-143 dispatches a **refactor subagent** in parallel with this
  writer to extract the IsIso residual `letI := isIso_of_app_iso_module
  ... (fun _ => sorry)` (`Cotangent/GrpObj.lean:719–721`) into a named
  sorry-bodied theorem `basechange_along_proj_two_inv_app_isIso`.
- After the refactor, the iter-143 prover lane targets ONLY the d_app
  sub-sorry (narrowed from the BUNDLED 3-sub-sorry shape of iter-142).
- IsIso closure (Route (b'2) items 2–4) is deferred to iter-144+ as a
  separate prover round on the newly-named theorem.

The blueprint chapter's recipes must reflect these correctives so
iter-144+ provers can read them as the canonical recipe source.

## Required content (per `blueprint-reviewer-iter143` soon-severity items)

### Edit 1: Elevate iter-142 empirical lessons into the d_app recipe

Find the d_app closure-recipe block in `RigidityKbar.tex`
(approximately L672–L703; the section starts with the d_app sub-goal
heading inside `lem:GrpObj_omega_basechange_proj_inv_derivation` or
the `\subsection*{d_app}`-style heading).

Modify the recipe to elevate the three iter-142 empirical lessons:

1. **Add a NOTE at the top of the d_app recipe** named
   "Iter-142 empirical lessons (d_map closure transferable to d_app)":
   - Rule 1: any `change` block must spell both LHS and RHS fully;
     `_`-placeholders on either side of an equation crossing
     `pushforward₀`-annotated definitions cause a deterministic `whnf`
     timeout (iter-140 d_map attempt; iter-142 d_map fix). The d_app
     goal crosses the **same** `pullbackPushforwardAdjunction.homEquiv.symm`-
     transposed term as d_map, so this rule applies to d_app too.
   - Rule 2: `NatTrans.naturality_apply` packaging via
     `rw [show ... from NatTrans.naturality_apply ...]` is the
     pattern for goals with `RingCat.Hom.hom` / `CommRingCat.Hom.hom`-
     form terms. The d_app categorical chase also routes through
     ψ-naturality, so this packaging will be needed.
   - Rule 3: `PresheafOfModules.pushforward_obj_map_apply'`
     (`Pushforward.lean:99–106`) is the named lemma for the kernel-form
     unfolding; in iter-142 d_map closure it was achieved via `change`
     instead, but the named lemma is the explicit alternative.

2. **Decompose the d_app Step 3 (adjunction-transpose) chase into
   explicit ~20–40 LOC sub-steps**. The iter-142 prover identified
   this as the load-bearing residual after the `change`-skeleton
   landed. Concretely, the chapter should walk through:
   - 3.a: `(fst G G).w` + `(snd G G).w` to get `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom`
     in `Over (Spec k)` (~3–5 LOC).
   - 3.b: `LocallyRingedSpace.comp_c_app` (or `PresheafedSpace.comp_c_app`)
     to lift the categorical equality to c-component level: apply
     it twice (once to each side of 3.a's identity) to derive
     `G.hom.c.app X ≫ (fst).left.c.app (G.hom⁻¹X) = G.hom.c.app X ≫ (snd).left.c.app (G.hom⁻¹X)`
     (~10–15 LOC).
   - 3.c: Transpose through `TopCat.Presheaf.pullbackPushforwardAdjunction.homEquiv.symm`:
     construct the witness `h : Source ⟶ ((pullback fst.left.base).obj G.left.presheaf).obj (snd⁻¹X)`
     such that `(φ_LHS.app (snd⁻¹X)).comp h = (ψ.app X).comp (φ_G.app X)`.
     This is the **load-bearing ~20–40 LOC bespoke chase**; per the
     iter-141 + iter-142 mathlib-analogists, no Mathlib shortcut exists
     (Decision 2 of `analogies/d-app-d-map-recipe-shape.md`:
     `NEEDS_MATHLIB_GAP_FILL`). The chapter should describe the chase
     mathematically (in terms of inverse-image presheaves and
     colimit-presented restriction maps) so the prover can construct
     `h` term-mode.
   - 3.d: Discharge with `(CommRingCat.KaehlerDifferential.D _).d_map _`
     (the `ModuleCat.Derivation.d_map` `@[simp]` lemma at
     `Mathlib/Algebra/Category/ModuleCat/Differentials/Basic.lean:80`):
     `change` to align the argument shape, then `exact`. (~5–10 LOC).

3. **Update the d_app LOC envelope** to ~40–80 LOC (iter-142 carry-over
   estimate, validated empirically). The existing chapter prose may
   carry an earlier 50–90 LOC envelope from iter-141 — replace with
   the iter-142 empirical 40–80 LOC band.

### Edit 2: Add IsIso recipe NOTE pointing at the refactored named theorem

Find the IsIso closure-recipe block at approximately L943–L1073 (Route
(b'2) items 2–4). Add a NOTE at the top of the block:

> **Iter-143 Lean-shape refactor (in-Lean only; recipe unchanged).** The
> in-Lean encoding of the IsIso residual has been refactored
> iter-143 from the in-line `letI := isIso_of_app_iso_module
> (basechange_along_proj_two_inv G) (fun _ => sorry)` pattern (which
> hid the sorry inside a `letI` body and propagated a sorry-tainted
> iso to downstream `simp` consumers) into a named sorry-bodied
> theorem `basechange_along_proj_two_inv_app_isIso` at
> `Cotangent/GrpObj.lean`. The named theorem carries the per-open
> obligation `∀ X, IsIso ((basechange_along_proj_two_inv G).app X)`
> directly; the consuming declaration
> `relativeDifferentialsPresheaf_basechange_along_proj_two` invokes
> the named theorem inside its `letI`. The recipe below
> (items 2–4 of Route (b'2)) **is unchanged**: it now closes the
> named theorem's body rather than filling a `(fun _ => sorry)`
> argument. This was performed per `lean-auditor-review142` MAJOR
> finding + `progress-critic-iter143` CHURNING primary corrective +
> `strategy-critic-iter143` definition-level diagnostic on the
> IsIso `letI` shape.

### Edit 3: Decompose IsIso Route (b'2) items 2-4 into concrete prover-ready sub-recipes (optional follow-on; soon-severity)

`strategy-critic-iter143` recommended decomposing items 2–4 with
"concrete LSP-level recipes (mirror the d_map empirical pattern
where applicable)". If you have remaining budget after Edits 1+2,
you may add 2–3 sentences each per item:

- Item 2 (Chart-level `Algebra.IsPushout`-from-affine-product helper,
  ~80–150 LOC): name the Mathlib chain (`CommRingCat.isPushout_iff_isPushout`
  + `pullbackSpecIso` + `isPullback_SpecMap_of_isPushout`).
- Item 3 (`((pullback ψ).obj M).obj X` chart-unfolding helper
  `pullbackObjEquivTensor`, ~30–60 LOC): name the shape (definitional
  equality on `pushforward.leftAdjoint.obj`).
- Item 4 (Per-open identification with
  `KaehlerDifferential.tensorKaehlerEquiv.symm` via
  `tensorKaehlerEquiv_symm_D_tmul`, ~80–150 LOC): name the algebraic
  Kähler-tensor equivalence and how it composes with items 2+3.

This is OPTIONAL — iter-143 prover lane does not target IsIso, so
this Edit 3 is for the iter-144+ prover lane's benefit.

### Edit 4: Mark iter-142 d_map block as `\leanok` candidate (in-prose status update)

Find the d_map sub-recipe block (approximately L747–L801). Add a
status note at the top:

> **Iter-142 status: CLOSED substantively in
> `AlgebraicJacobian/Cotangent/GrpObj.lean:638–674`**. The 3-step
> ALIGN_WITH_MATHLIB chase recipe below was applied with two empirical
> refinements: (i) the explicit `change` spells both LHS and RHS
> (not just LHS); (ii) `NatTrans.naturality_apply` is packaged via
> `rw [show ... from ...]` (kernel-form alignment). See above d_app
> recipe NOTE for the rule generalization; see
> `task_results/Cotangent_GrpObj.lean.md` iter-142 for the in-Lean
> closure.

DO NOT add `\leanok` markers yourself — that is the deterministic
`sync_leanok` phase's domain (see CLAUDE.md § Blueprint Marker
Vocabulary). Just record the in-prose status note.

## Out of scope

- DO NOT modify the `lem:rigidity_over_kbar` statement block or proof
  block (M2.a body; gated on the full pile close).
- DO NOT modify the piece (ii) `ContainConstants` / `KaehlerDifferential.D`
  prose (iter-143+ target; iter-138 path (b) verdict landed).
- DO NOT modify the piece (iii) absolute-Frobenius prose (iter-144+
  scoping gate).
- DO NOT modify the piece (i.c.1/i.c.2/i.c.3) decomposition prose
  (iter-137 strategy-critic decomposition; iter-143+ Main composition
  gates these).
- DO NOT add new `\leanok` / `\mathlibok` / `\notready` markers.
- DO NOT add new `\lean{...}` hints to existing blocks unless they
  point at the post-refactor declaration name
  `basechange_along_proj_two_inv_app_isIso` (Edit 2's NOTE).

## References

- `task_results/Cotangent_GrpObj.lean.md` (iter-142 prover report) —
  contains the d_map empirical closure pattern + the d_app explicit
  `change`-skeleton + the IsIso narrowing rationale.
- `analogies/d-app-d-map-recipe-shape.md` (iter-141 mathlib-analogist)
  — d_map ALIGN_WITH_MATHLIB; d_app NEEDS_MATHLIB_GAP_FILL Step 3
  classification.
- `analogies/isiso-basechange-along-proj-two-inv.md` (iter-139
  mathlib-analogist) — Route (b'2) Decision 2 items 1–4 breakdown.
- `analogies/kaehler-tensorequiv-presheafpullback.md` (iter-137
  mathlib-analogist) — Step 2 universal-property route recipe.

## Expected outcome

After your edits:
- The d_app recipe (L672–L703-ish) is augmented with a "Iter-142
  empirical lessons" NOTE at the top + decomposed Step 3 sub-recipe
  ~20–40 LOC.
- The IsIso recipe (L943–L1073-ish) is augmented with the iter-143
  refactor NOTE pointing at the post-refactor named theorem.
- The d_map sub-recipe (L747–L801-ish) carries the iter-142 closed
  status note (in-prose only; no `\leanok`).
- Optionally, items 2/3/4 of Route (b'2) carry concrete sub-recipe
  notes.
- LOC delta: ~+30–80 LOC of new prose; no deletions.
- `leanblueprint pdf` (or local plasTeX compile) should still build
  cleanly; no broken `\uses{...}` cross-refs.

Report your edits + any cross-chapter findings in your task_results
file. Surface in "Notes for Plan Agent" any inconsistencies you spot
between this chapter and the pointer chapter
`AlgebraicJacobian_Cotangent_GrpObj.tex` (one informational item
already known: the pointer chapter L46–L49 lists the three sub-sorries
as "d_app + d_map + IsIso" — iter-142 closed d_map; the pointer text
should track the live three).
