# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
ana258-d3

## Iteration
258

## Structural problem
Monoidality of the composite-of-left-adjoints connecting iso `pullbackComp` (Sq2b in D3′): that
`pullbackComp` intertwines the oplax tensorator δ of the single composite pullback with the composite
oplax δ (`G.map(δ F) ≫ δ G` = `comp_δ`) of `pullback φ ⋙ pullback ψ`. Abstractly: for adjunctions
`adjᵢⱼ` with lax-monoidal right adjoints and a **monoidal** right-adjoint composition iso
`e₀₁₂ = pushforwardComp`, the induced left-adjoint iso `leftAdjointCompIso(…,e₀₁₂) = pullbackComp` is a
monoidal natural iso `(F₀₁⋙F₁₂, comp_δ) ≅ (F₀₂, leftAdjointOplaxMonoidal)`.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `Adjunction.leftAdjointOplaxMonoidal` + `leftAdjointOplaxMonoidal_δ` (Functor.lean:1009/1063) | cat-theory mate calculus | low | ANALOGUE_FOUND |
| `Adjunction.conjugateEquiv_leftAdjointCompIso_inv` (CompositionIso.lean:82) | cat-theory mate calculus | low | ANALOGUE_FOUND |
| project `pullbackObjUnitToUnit_comp` (TensorObjSubstrate.lean:910) — η-twin | project / mate calculus | medium | ANALOGUE_FOUND |
| `Adjunction.isMonoidal_comp` (Functor.lean:990) | cat-theory monoidal adjunctions | medium (sub-routine) | PARTIAL_ANALOGUE |

## Decision for the planner
**DISPATCHABLE THIS ITER via route (b) — hand mate-calculus, at the `PresheafOfModules` level.** Route
(a) "use `isMonoidal_comp` wholesale" is INSUFFICIENT: `isMonoidal_comp` proves only that the
*composite adjunction* `adj.comp adj'` is monoidal; it does not transport across the iso `pullbackComp`
to the *single* functor/adjunction, which is exactly the missing content. The iter-256 "mirror failed"
verdict was about the FULL `pullbackTensorMap` (a non-transpose 4-fold composite) and does **not** bind
Sq2b: the Sq2b δ *is* an adjunction transpose (`leftAdjointOplaxMonoidal` defines δ := `homEquiv.symm`),
so the transpose recipe that already compiles for the η-twin `pullbackObjUnitToUnit_comp` ports
directly with η→δ.

## Top suggestion
Add a standalone presheaf-level lemma (its own ~100–180 LOC sub-lemma, the iter-257 "Sq2b" work item),
proven by mirroring the COMPILING `pullbackObjUnitToUnit_comp` (TensorObjSubstrate.lean:910-1000) with
η replaced by δ:

1. **State it at PresheafOfModules level**, about `PresheafOfModules.pullbackComp φ'_f φ'_h`
   (Pullback.lean:131, signature `pullback φ'_f ⋙ pullback φ'_h ≅ pullback (φ'_f ≫ whiskerLeft F.op
   φ'_h)`) and `δ (PresheafOfModules.pullback (φ'_f ≫ whiskerLeft F.op φ'_h))`. Using the *composite
   ring map spelling* `φ'_f ≫ whiskerLeft F.op φ'_h` (not bare `(toRingCatSheafHom (h≫f)).hom`) makes
   the `(F := Opens.map f.base ⋙ Opens.map h.base)`/associativity pinning come from `pullbackComp`'s
   own type — this dissolves iter-257 friction (2). Reconcile to `pullback φ'_{h≫f}` only at the very
   end via finding (1)'s `rfl` reconcile `toRingCatSheafHom_comp_hom_reconcile`.
2. **Forget₂ pin (friction 1) is sidestepped** by working at presheaf level: `δ` is taken w.r.t.
   `presheafPullbackOplaxMonoidal` (TensorObjSubstrate.lean:1146), whose hypothesis already fixes the
   spelling `φ' : (S₀⋙forget₂) ⟶ F.op⋙(R₀⋙forget₂)` — bind `φ'` exactly as `pullbackTensorMap` does
   at lines 1217-1218. No `Scheme`/`forget₂` reasoning enters Sq2b; it re-enters only when D3′ consumes
   Sq2b, and there the reconcile is finding (1)'s `rfl`.
3. **Proof skeleton (η→δ port of lines 915-1000):**
   - `apply (PresheafOfModules.pullbackPushforwardAdjunction (φ'_f ≫ whiskerLeft F.op φ'_h)).homEquiv _ _ |>.injective`.
   - LHS: rewrite `δ` via Mathlib's `Adjunction.leftAdjointOplaxMonoidal_δ` (the δ-side bridge that
     REPLACES the project's `…homEquiv_pullbackObjUnitToUnit`; δ is a Mathlib def so no project lemma
     is needed) → `(unit ⊗ₘ unit) ≫ μ(pushforward φ'_{comp})`.
   - RHS: transpose `pullbackComp.inv`/`.hom` to `pushforwardComp` via
     `Adjunction.conjugateEquiv_leftAdjointCompIso_inv` (= presheaf form of the already-used
     `conjugateEquiv_pullbackComp_inv`), `Adjunction.unit_conjugateEquiv`, `Adjunction.comp_unit_app`.
   - Residual goal: the **lax-μ composition coherence of `PresheafOfModules.pushforward` across
     `pushforwardComp`** — concrete/sectionwise, expected `rfl` or short `ext`-chain (cf. the η-twin
     `unitToPushforwardObjUnit_comp` closes by `rfl`, TensorObjSubstrate.lean:881, and
     `pushforwardComp_hom_app_app = 𝟙`, Sheaf.lean:214).
   - Two-argument `tensorHom`/`δ_natural` bookkeeping (absent in the η-twin): copy line-for-line from
     `Adjunction.isMonoidal_comp` (Functor.lean:995-999):
     `simp only [comp_δ, ← tensorHom_comp_tensorHom, δ_natural_assoc, comp_unit_app, comp_counit_app,
     Functor.comp_map, …]`.
   - Use `erw` (not `rw`) for the `Category.assoc`/`Functor.map_comp` steps where
     `Scheme.Modules.pullback`/`SheafOfModules.pullback` appear in defeq-but-not-syntactic form, per
     the η-twin's documented gotcha (TensorObjSubstrate.lean:906-909).

First project file to touch: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, inserting the Sq2b
lemma just above `pullbackTensorMap_restrict` (line 2148) and consuming it in that proof's Sq2 step.

## Discarded
- Route (a) "bundle `pullback` as `Functor.Monoidal` and invoke `isMonoidal_comp` wholesale" — kept as
  a bookkeeping sub-routine only; it cannot close the cross-iso transport (see Decision).
- A fully-general upstream `leftAdjointCompIso`-is-monoidal lemma — more work than the direct mate
  proof (requires packaging "monoidal natural iso" and proving `pushforwardComp` monoidal abstractly);
  the direct η→δ port reuses infrastructure already compiling in-project.
- `Adjunction.leftAdjointOplaxMonoidal_δ` transport-of-`leftAdjointCompIso` as a ready Mathlib lemma —
  confirmed ABSENT (CompositionIso.lean carries only unitality/associativity pseudofunctor coherences,
  no monoidal compatibility; no `leftAdjointOplaxMonoidal`-of-composite lemma exists).

## Persistent file
- `analogies/d3sq2b258.md` — analogue list + porting recipe captured for future iters.

Overall verdict: D3′ Sq2b is dispatchable to a prover THIS iter via a η→δ port of the compiling
`pullbackObjUnitToUnit_comp`, stated at PresheafOfModules level (dissolving all three iter-257
frictions); no structural refactor is needed first.
