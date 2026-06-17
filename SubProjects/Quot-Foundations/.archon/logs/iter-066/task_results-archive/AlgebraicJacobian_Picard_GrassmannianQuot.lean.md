# AlgebraicJacobian/Picard/GrassmannianQuot.lean — iter-066

## Headline

**`tautologicalQuotient` is CLOSED, axiom-clean.** The full rectangular chain landed exactly
per the plan: `matrixEndRect` / `matrixEndRect_comp` / `matrixEndRect_pullback` →
adjunction-transpose toolkit (`glueLift_cond_iff` + helpers) →
`tautologicalQuotientComponent_transpose` → `tautologicalQuotient_overlap` → L1973 sorry
filled. Sorry count **2 → 1** (only `represents` remains). Build green via REAL
`lake build AlgebraicJacobian.Picard.GrassmannianQuot`: **89s cold module, no kernel
timeout, no OOM** (8319 jobs total). `lean_verify` on `tautologicalQuotient`,
`tautologicalQuotient_overlap`, `matrixEndRect_pullback`: only
`propext`/`Classical.choice`/`Quot.sound`.

## New declarations (all axiom-clean, in build order)

### Rectangular matrix API (namespace `AlgebraicGeometry.Grassmannian`)
- `matrixToFreeIso_inv` (@[simp], rfl) — `(matrixToFreeIso M N _ _).inv = matrixEnd N`.
- `matrixEndRect` (`def:gr_matrixEndRect`) — d×r matrix ↦ `free (Fin r) ⟶ free (Fin d)`,
  same biproduct assembly as `matrixEnd`/`chartQuotientMap`.
- `biproduct_matrix_comp_rect` (private) — rectangular `biproduct.matrix` composition.
- `matrixEndRect_comp` (@[reassoc], `lem:gr_matrixEndRect_comp`) —
  `matrixEndRect M ≫ matrixEnd N = matrixEndRect (N * M)` (order convention as directed).
- `ιFree_matrixEndRect` — row-sum expansion on free injections.
- `matrixEndRect_pullback` (`lem:gr_matrixEndRect_pullback`) — **NOTE the base-changed
  matrix is `M.map ⇑(hom (appTop p))`, NOT `mapMatrix` — `RingHom.mapMatrix` is
  square-only.** Same skeleton as `matrixEnd_pullback` (two `key` lemmas, one per rank).
- `chartQuotientMap_eq_matrixEndRect` (rfl) — `u^I = matrixEndRect (inj X^I)`.

### Scheme.Modules toolkit (generic, namespace `AlgebraicGeometry.Scheme.Modules`)
- `pullbackCongr_inv_app_free` (@[reassoc], subst) — inv-side congruence absorption.
- `pullbackComp_inv_app_free_map` (@[reassoc]) —
  `(pullbackComp b a).inv.app (free) ≫ (pullback b).map Q_a.hom = Q_{b≫a}.hom ≫ Q_b.inv`;
  proof needs `erw [← pullbackFreeIso_comp]` (plain rw misses through the diamond).
- `homEquiv_comp_unit_pushforwardComp` — **the leg-transpose engine**: `homEquiv_a(c) ≫
  (a_* unit_b ≫ pushforwardComp.hom.app) = homEquiv_{b≫a}(pullbackComp.inv.app ≫ b^* c)`.
  Route: `homEquiv_unit`+unit-naturality (inner transpose), `Adjunction.comp_homEquiv`,
  `homEquiv_conjugateEquiv_app` + Mathlib's `conjugateEquiv_pullbackComp_inv`. Final
  regrouping must be term-mode (`homEquiv_naturality_right` as rw matches the wrong
  occurrence).
- `homEquiv_comp_pushforwardCongr` (subst) — transpose across the `pushforwardCongr` cast.
- `glueLift_cond_iff` — the `(i,j)`-component of `glueLift`'s equalizing hypothesis ↔ the
  pullback-level identity `f_ij^*(c i) = congr ∘ (t≫f)^*(c j) ∘ g_ij⁻¹`. Calc with
  congrArg-steps (positional rw of `homEquiv_naturality_right` fires inside the wrong
  homEquiv argument — logged dead end).

### Grassmannian assembly
- `tautologicalQuotient_overlap` (`lem:gr_tautologicalQuotient_overlap`,
  maxHeartbeats 1600000) — the transposed overlap identity. Structure:
  (1) `hcomp_ring`/`heq`: `t_IJ ≫ f_JI = Spec.map θ̃_IJ` via `IsLocalization.Away.lift_comp`;
  (2) bridges `hbb`/`hbe` from `baseChange_bridge_gammaSpec` with **X:= AND Y:= Spec
  ascriptions on `appTop`** (both sides, unlike the triple-overlap case);
  (3) matrix bridges `hBmat`/`hEmat` (Matrix.map_map/coe_comp fusion; the AlgHom→RingHom
  coercion gap absorbed by a defeq `have hXJ` restatement of
  `universalMatrix_map_transitionPreMap`);
  (4) matrix core `hmin_img`/`hmat`: `X^I_J · ((X^I_J)⁻¹ X^I) = X^I` — only needs
  `universalMinorInv_mul_cancel` + `imageMatrix` def (term-mode calc; rectangular
  heterogeneous `HMul` blocks `rw [← Matrix.mul_assoc]`);
  (5) `h2`/`h5` = `matrixEndRect_pullback` in glue-datum phrasing, `h6` = bundle transition
  inverse in `Q ≫ matrixEnd ≫ Q⁻¹` form (`change` + `simp only [bundleTransition, …]; rfl`);
  (6) `hLfin`/`hRfin` collapse to the common normal form; (7) one fully term-mode
  `congrArg`/`Eq.trans` chain assembles everything.
- `tautologicalQuotientComponent_transpose`
  (`lem:gr_tautologicalQuotientComponent_transpose`) — thin instance of `glueLift_cond_iff`
  (the `tautologicalQuotientComponent`↔homEquiv and `scheme d r`↔`glued` defeqs absorbed by
  the decl typecheck).
- `tautologicalQuotient` (`def:tautological_quotient`) — **sorry replaced** by
  `(transpose p.1 p.2).mpr (overlap p.1 p.2)`.

## Load-bearing tricks / dead ends (for the next prover)

- **`RingHom.mapMatrix` is square-only** — every rectangular base change must be spelled
  `M.map ⇑f`. This silently re-shapes statements if forgotten.
- **NEW failure mode discovered: identical source text elaborates with different invisible
  implicits under different expected types.** Concretely: `(pullback f).map
  (chartQuotientMap …)` gets `Functor.map`'s implicit object args spelled `affineChart`-side
  when standalone but glue-datum-side under a composition's expected type; similarly
  `Matrix.map`'s carrier implicit `β` flips between `Γ(Spec L,⊤)` and `Γ(V_IJ,⊤)` forms.
  Effect: `rw [h]` fails even when the goal LITERALLY shows `h`'s LHS verbatim. Fix
  pattern: (a) state every reusable `have` self-contained (its own single elaboration),
  (b) connect haves only by `congrArg`/`congrArg₂`/`Eq.trans` (defeq-absorbing), never
  positional rw across two independently-elaborated spellings.
- `congrArg₂ (· ≫ ·) h5 h6` substitutes two composite factors at once without restating
  the giant matrices.
- `Spec.map_comp` cannot fire while the comp node's middle object is `chartOverlap`-spelled;
  a `change` re-typing at `Spec`-spelled objects dissolves it (heq).
- The double-overlap case needs NO `awayPullbackIso`/`tripleOverlapSections` — both legs
  are literally `Spec.map` of ring homs; `baseChange_bridge_gammaSpec` suffices.
- `simp only [Category.assoc]` can FAIL to reassociate mixed-provenance comp nodes (e.g.
  `(map u) ≫ g.inv` where the middle object was defeq-unified from two spellings) — same
  class as the rw failures; term-mode is the reliable route.

## `represents` (the 1 remaining sorry)

NOT closed. What it needs (now precisely scoped, docstring updated in-file):
1. **`glueRestrictionIso`** — chart restriction isomorphisms
   `(pullback (D.ι i)).obj (glue D M g hC1 hC2) ≅ M i` of the descent equalizer. This is
   where `_hC1`/`_hC2` get consumed; net-new construction (the iter-056 glue note
   anticipated it "downstream"). Without it neither local freeness nor epi-ness of the
   universal quotient is provable.
2. `universalQuotient_isLocallyFreeOfRank` + `Epi (tautologicalQuotient d r)` (local on
   the glued scheme via the chart cover + `chartQuotientMap_epi`).
3. The Nitsure §1 functor-of-points bijection itself (forward: ψ ↦ rqPullback ψ of the
   tautological pair; inverse: chart-by-chart maps to `U^I` glued by the glued-scheme
   universal property; naturality).
   Estimate: ≥ 2 further full sessions; `glueRestrictionIso` is the natural next atom.

## Hygiene done (planner directive)

- `represents` docstring NOTE rewritten (was claiming the closed bundle cocycle as the gap;
  now names `glueRestrictionIso` as the actual remaining ingredient).
- Phantom lemma name `PresheafOfModules.pushforward_map_app_apply'` removed from the two
  comments (~L1026/L1033).
- The dead `task_results/` pointer comment at the old L1973 went away with the sorry fill.

## Markers for review agent

- `sync_leanok` will pick up: `def:tautological_quotient` (proof now closed),
  `lem:gr_tautologicalQuotient_overlap`, `lem:gr_tautologicalQuotientComponent_transpose`,
  `def:gr_matrixEndRect`, `lem:gr_matrixEndRect_pullback`, `lem:gr_matrixEndRect_comp`.
- New unpinned decls the planner may want blueprint blocks for:
  `Scheme.Modules.glueLift_cond_iff`, `Scheme.Modules.homEquiv_comp_unit_pushforwardComp`,
  `Scheme.Modules.homEquiv_comp_pushforwardCongr`,
  `Scheme.Modules.pullbackComp_inv_app_free_map`,
  `Scheme.Modules.pullbackCongr_inv_app_free`, `matrixToFreeIso_inv`,
  `ιFree_matrixEndRect`, `chartQuotientMap_eq_matrixEndRect`.

## Summary

- Sorry count: **2 → 1**.
- Closed: `tautologicalQuotient` (the L1973 overlap condition) — axiom-clean,
  kernel-validated via real `lake build` (89s cold, no OOM, no kernel timeout).
- New proven infrastructure: `matrixEndRect` + `_comp` + `_pullback` +
  `chartQuotientMap_eq_matrixEndRect`, `Scheme.Modules.glueLift_cond_iff` + the
  adjunction-transpose toolkit (4 lemmas), `tautologicalQuotientComponent_transpose`,
  `tautologicalQuotient_overlap`.
- Still open: `represents` (the only remaining sorry; scoped above — gated on the net-new
  `glueRestrictionIso` construction, not on anything in this session's chain).
- Adjacent sorries: `represents` assessed and scoped; partial scaffolding NOT left in the
  file because its first atom (`glueRestrictionIso`) is a self-contained new construction
  better assigned as its own objective (and the session wall-clock risk made securing the
  closed result the priority).

## Why I stopped

`Real progress`: closed 1 sorry — `tautologicalQuotient` (sorry count 2 → 1), the
iter-064→066 GR-quot target, via ~600 LOC of new axiom-clean infrastructure (the full
5-decl blueprint chain plus a generic glueLift-transpose toolkit). I did not attempt the
`represents` body beyond scoping it precisely (docstring + this report): its first
ingredient `glueRestrictionIso` is a fresh multi-hundred-LOC construction consuming the
C1/C2 hypotheses of the descent equalizer, out of reach of the remaining session
wall-clock (PROGRESS standing note: prover sessions killed at ~10–16 min; securing the
kernel-validated close + this report took priority). Informal agent: no API key in env
(PROGRESS standing note), not needed — no Mathlib gap was hit.
