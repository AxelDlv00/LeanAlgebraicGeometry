# AlgebraicJacobian/Picard/GrassmannianQuot.lean — iter-064

## Headline

**C2 (`bundleTransition_cocycle`) is CLOSED, axiom-clean.** The full (b)→(c)→C2 chain landed
this session, plus the first rider `universalQuotient` (CLOSED) and a structured partial for
`tautologicalQuotient` (new `glueLift` primitive + per-chart components; one sorry at the
overlap-compatibility condition). Sorry count **4 → 2**. Build green, 40s cold
(`lake build AlgebraicJacobian.Picard.GrassmannianQuot`, kernel-validated — not just LSP).
`lean_verify` on `bundleTransition_cocycle` and `universalQuotient`: only
`propext`/`Classical.choice`/`Quot.sound`.

## Decl-ordering refactor (staged but not executed by the planner — done here)

The comparison cluster (`pullbackObjUnitToUnit_id/_comp`, `pullbackFreeIso_id/_comp`,
`homEquiv_conjugateEquiv_app`, `pullbackBaseChangeTransport_matrixToFreeIso`) sat AFTER the
C2 sorry despite task_pending claiming it had been relocated. Moved it (verbatim, no
renames) to before the C2 theorem, with namespace re-balancing. One gotcha hit and fixed:
the cluster ends inside a re-opened `namespace AlgebraicGeometry.Grassmannian`, so naive
insertion created a nested duplicate namespace; fixed by deleting the spurious re-open and
re-opening before `functor` instead.

## (b) baseChange_bridge chain (lines ~1460–1680)

### `baseChange_bridge_gammaSpec` — RESOLVED (new)
- `(ΓSpecIso A).inv ≫ (Spec.map φ).appTop = φ ≫ (ΓSpecIso B).inv`, from
  `Scheme.ΓSpecIso_naturality` via `Iso.inv_comp_eq` + assoc.

### `tripleOverlapSections` (σ) — NEW DEF
- `S_I = R^I[1/(P^I_J·P^I_K)] ⟶ Γ(V_IJK,⊤)` := `ΓSpecIso.inv ≫ (awayPullbackIso …).hom.appTop`.
  The common codomain conjugation of the three bridges.

### `baseChange_bridge_left` / `_right` — RESOLVED (new)
- **Key trick (load-bearing): `(Y := Spec (CommRingCat.of (Localization.Away …)))` named-arg
  ascription on `Scheme.Hom.appTop`.** Without it, `appTop`'s domain is `Γ(chartOverlap …)`
  while `ΓSpecIso` produces `Γ(Spec (of …))` — print-identical, defeq, NOT syntactic — and
  `Matrix.map_map`/`rw [← Category.assoc]` silently fail downstream. The ascription pins the
  Spec-typed representation at the statement level and dissolves the whole class of failures.
- Scheme-level leg: `pullback.fst = (awayPullbackIso …).hom ≫ Spec.map (ofHom awayInclLeft)`
  via `awayPullbackIso_inv_fst` (plain term application works through the HasPullback
  diamond) + `Iso.inv_comp_eq`.
- Tail: `rw [hp, Scheme.Hom.comp_appTop]` then a TERM-MODE assoc/congrArg/assoc chain
  (positional `rw [← Category.assoc]` misses the comp node — defeq middle-object mismatch).

### `baseChange_bridge_transition` — RESOLVED (new)
- `chartTransition' ≫ fst = W.hom ≫ Spec.map (ofHom (Θ_IJ ∘ awayInclRight))`:
  `rw [chartTransition']; simp only [Category.assoc]; erw [hfst]` (the `erw` fires the
  fst-leg lemma through the HasPullback diamond — Cells `chartTransition'_fac` precedent),
  then the three `Spec.map`s collapse in a FRESH homogeneous `have` (`← Spec.map_comp ×2`,
  `← ofHom_comp ×2`, `awayMulCommEquiv_comp_awayInclLeft` absorbs the order-swap into
  `awayInclRight`), transported back by `congrArg (W.hom ≫ ·)`.
- Final appTop step: `rw [hp]` FAILS here (composite under `appTop`, comp-node mismatch) —
  use `refine (congrArg (fun m => ΓSpecIso.inv ≫ appTop m) hp).trans ?_` instead.

### `baseChange_bridge` (matrix assembly) — RESOLVED (new)
- States `B * A = C` over `Γ(V_IJK,⊤)` for the three appTop∘ΓSpecIso.inv-mapped Cramer
  inverses (with the `Y :=` ascriptions, matching what the transport produces).
- Proof: `congrArg CommRingCat.Hom.hom` on the three bridges, `simp only [hom_comp,
  hom_ofHom]`, then `simp only [RingHom.mapMatrix_apply, Matrix.map_map, ← RingHom.coe_comp,
  hL, hR, hT]` fuses each factor to `M.map ⇑(σ.comp h)`; a `calc` (fresh sub-goals — the
  `↥(of R)` vs `R` carrier reps block positional rw on the simp-produced goal) splits the
  σ-layer, recombines via `Matrix.map_mul.symm`, applies L1
  (`bundleTransition_cocycle_matrix`) via `congrArg (·.map ⇑σ)`, and refuses.
- **Dead end logged:** `simp only [RingHom.coe_comp, ← Matrix.map_map]` over-splits the
  fused `Θ ∘ ιR` and breaks the match with L1 — split exactly the outer σ-layer only.

## (c) `bundleTransition_cocycle_transport` — RESOLVED (new, hom-level C2)

- `set_option maxHeartbeats 1600000 in` (isDefEq cost of the cast collapses; Cells
  precedent). Structure:
  1. Three `have eIJ/eJK/eIK := pullbackBaseChangeTransport_matrixToFreeIso _ _ _ _ _ _ _`
     with the statements spelled in glue-datum phrasing + `Y :=` ascriptions; the
     `bundleTransitionData` g-argument unifies with the
     `pullbackFreeIso ≪≫ matrixToFreeIso ≪≫ symm` pattern by defeq. No friction.
  2. `have hbridge := baseChange_bridge d r I.1 J.1 K.1 I.2 J.2 K.2` restated in glue-datum
     phrasing — the chartIncl↔`(theGlueData).f` defeq is absorbed by the `have` check.
  3. `rw [eIJ, eJK, eIK]; simp only [Category.assoc]` then the three NEW generic
     cast-collapse lemmas (see below) — all fired as `rw`s.
  4. matrixEnd fusion: **`rw [reassoc_of% matrixEnd_comp]` FAILS** (mixed-provenance comp
     nodes), and **`rw [← Category.assoc]` grabs the scheme-level composite inside
     `pullbackFreeIso`'s argument** — pure term-mode instead:
     `(Category.assoc _ _ _).symm.trans (congrArg (· ≫ Q.inv) ((matrixEnd_comp _ _).trans
     (congrArg matrixEnd hbridge)))`, then `exact congrArg (Q.hom ≫ ·) hfuse`.

## New generic cast-collapse lemmas (Scheme.Modules namespace, all `subst`+simp, @[reassoc])

- `pullbackFreeIso_inv_congr_hom` : `Q_φ⁻¹ ≫ pullbackCongr(h).app(free) ≫ Q_ψ = 𝟙`
- `pullbackCongr_hom_app_free` : `pullbackCongr(h).app(free) ≫ Q_ψ = Q_φ`
- `pullbackFreeIso_inv_congr` : `Q_φ⁻¹ ≫ pullbackCongr(h).app(free) = Q_ψ⁻¹`
These are the `pullbackFreeIso_trans_symm_eqToIso` discipline applied to `pullbackCongr`:
generic in the (equal) morphisms, so the kernel never whnfs a concrete immersion.

## C2 `bundleTransition_cocycle` — RESOLVED

- `apply Iso.ext; simp only [Iso.trans_hom]; exact bundleTransition_cocycle_transport …`,
  with `set_option maxHeartbeats 1600000` (whnf cost of unifying the inferred `.app _`
  underscores across the diamond). Axiom-clean.

## Rider 1 `universalQuotient` — RESOLVED

- Direct: `Scheme.Modules.glue (theGlueData d r) (fun I => free (Fin d))
  (bundleTransitionData d r) (fun I => bundleTransition_self d r I.1 I.2)
  (fun I J K => bundleTransition_cocycle d r I J K)`. The C1 eqToIso proof-irrelevance defeq
  is accepted without friction. Axiom-clean.

## Rider 2 `tautologicalQuotient` — PARTIAL (structured; 1 sorry)

- NEW generic primitive **`Scheme.Modules.glueLift`** (placed right after `glue`): lifts a
  family `k i : W ⟶ (ι_i)_* M_i` with overlap condition `hk` into `glue D M g _ _`, via
  `equalizer.lift (Pi.lift k)` + `Pi.hom_ext` + `simp only [Category.assoc, Pi.lift_π,
  Pi.lift_π_assoc]`. **Gotcha:** `limit.lift_π` does NOT see through the `Pi.π` def — use
  `Limits.Pi.lift_π`/`Pi.lift_π_assoc`.
- **Dead end logged:** `equalizer.lift` directly against `… ⟶ universalQuotient d r` at the
  CONCRETE instantiation fails instance synthesis (`HasProduct`/`HasEqualizer` on the
  glue-unfolded beta-redex families; local `haveI` does not rescue it). The generic-context
  `glueLift` (same elaboration environment as `glue`, where the instances demonstrably
  resolve) is the fix.
- NEW `tautologicalQuotientComponent`: the adjoint transpose along `ι_I` of
  `(pullbackFreeIso (ι_I) (Fin r)).hom ≫ chartQuotientMap d r I.1 I.2`.
- `tautologicalQuotient := glueLift … (fun I => component I) (fun p => sorry)` — the sorry
  is the **overlap compatibility of the chart quotients**, the only remaining content.
  Concrete plan for the next session: transpose `hk p` under the pullback–pushforward
  adjunction of the overlap immersion (the `homEquiv_conjugateEquiv_app` /
  `conjugateEquiv_pullbackComp_inv` toolkit is already in-file); the resulting pullback-level
  identity is `bundleTransition.hom ∘ f_IJ^* u^I = (t_IJ ≫ f_JI)^* u^J` after free-pullback
  comparisons; its matrix core is `X^J ↦ (X^I_J)⁻¹ X^I` =
  `universalMatrix_map_transitionPreMap`/`imageMatrix` (Cells, public). Needs a RECTANGULAR
  analogue of `matrixEnd_pullback` (for the `r → d` matrix morphism `chartQuotientMap` —
  same proof skeleton: `Cofan.IsColimit.hom_ext` over `ιFree`, `scalarEnd_pullback` per
  entry) and a rectangular `matrixEnd_comp` (square ∘ rectangular). Estimate 300–600 LOC.

## `represents` (L2156) — NOT ATTEMPTED

Rides on `tautologicalQuotient` + the full functor-of-points bijection (Nitsure §1
local-to-global inverse). Out of reach until rider 2 closes.

## Lemmas/markers for review agent

- Ready for `\leanok` (sync will pick up automatically): `lem:gr_baseChange_bridge_gammaSpec`,
  `lem:gr_baseChange_bridge_left`, `lem:gr_baseChange_bridge_right`,
  `lem:gr_baseChange_bridge_transition`, `lem:gr_baseChange_bridge`,
  `lem:gr_bundleCocycle_transport`, `lem:gr_bundleCocycle_mul` (proof closed),
  `def:gr_universal_quotient_sheaf` (closed).
- The `% NOTE: forward declaration … not yet realised` comments on the five
  `baseChange_bridge*` blocks and on `bundleTransition_cocycle_transport` in
  `Picard_GrassmannianQuot.tex` are now stale — review agent should drop them.
- New unpinned decls the planner may want blueprint blocks for: `tripleOverlapSections`,
  `pullbackFreeIso_inv_congr_hom`, `pullbackCongr_hom_app_free`, `pullbackFreeIso_inv_congr`,
  `Scheme.Modules.glueLift` (natural home: the `def:gr_modules_glueHom` neighbourhood),
  `tautologicalQuotientComponent`.

## Summary

- Sorry count: **4 → 2**.
- Closed: `bundleTransition_cocycle` (C2) and `universalQuotient` — both axiom-clean,
  kernel-validated via real `lake build` (40s cold, no OOM, no kernel timeout).
- New proven infrastructure: `baseChange_bridge_gammaSpec`, `baseChange_bridge_left/right/
  transition`, `baseChange_bridge`, `bundleTransition_cocycle_transport`,
  `tripleOverlapSections`, 3 generic pullbackCongr cast-collapse lemmas,
  `Scheme.Modules.glueLift`, `tautologicalQuotientComponent`.
- Still open: `tautologicalQuotient` (ONE sorry: the overlap-compatibility condition inside
  an otherwise complete `glueLift` assembly — genuine partial, not a re-pin) and
  `represents` (untouched, rides on the former).
- Adjacent sorries beyond assignment: attempted rider 2 (partial as above); rider 3
  (`represents`) requires rider 2 first.

## Why I stopped

`Real progress`: closed 2 sorries — `bundleTransition_cocycle` (the iter-061→064 C2 target)
and `universalQuotient`; sorry count 4 → 2. Additionally `tautologicalQuotient` went from a
bare sorry to a structured `glueLift` assembly whose single sorry is the named
overlap-compatibility condition (genuine partial progress with compiling helper defs).

I stopped at the `tautologicalQuotient` condition because it needs net-new infrastructure
(a rectangular `matrixEnd_pullback`/`matrixEnd_comp` for the `r → d` chart quotient plus the
adjunction-transpose bookkeeping of the two equalizer legs, est. 300–600 LOC) that does not
fit the remaining session; the concrete recipe is written above and all needed Cells
ingredients are public. Informal agent: no API key in env (only `GEMINI_CLI_IDE_*` harness
vars, no `GEMINI_API_KEY` etc.) — documented, consistent with the PROGRESS standing note.
