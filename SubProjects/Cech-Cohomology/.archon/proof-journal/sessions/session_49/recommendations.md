# Recommendations for the next plan iteration (post iter-049)

## TOP — blueprint must-fix BEFORE re-dispatching Lane 1 (HARD GATE)
The `lem:affine_cech_vanishing_qcoh` proof sketch is **mathematically incomplete** (lean-vs-blueprint
`iter049-asv`, must-fix). It says "apply `lem:cech_acyclic_affine` to `~M` over any standard cover", but
that lemma requires the cover to span ALL of `Spec R` (`Ideal.span (range s) = ⊤`), whereas the standard
cover is of a **proper** `D(f)`. The missing step is **change of base to `R_f = Localization.Away f`**.
Before sending a prover at the residual `htilde`, dispatch a **blueprint-writer** on
`Cohomology_CechHigherDirectImage.tex` to:
- (a) add a blueprint block for `affine_cover_span_localizationAway` (the `R_f` spanning condition) — or an
  inline remark;
- (b) expand `lem:affine_cech_vanishing_qcoh`'s proof to spell the `R_f` change-of-base: the section Čech
  complex over the cover of `D(f)` is a complex of `R_f`-modules; each `Γ(D(gσ), ~_R M) = M[1/gσ]` is an
  `R_f`-module (f already inverted), and over `R_f` the family `{gᵢ/1}` spans `⊤`, so
  `sectionCech_affine_vanishing` over `R_f` applies after a change-of-space iso of cochain complexes;
- (c) blueprint blocks (or `\uses`-linked sub-lemma chain) for the residual `htilde` decomposition, so the
  next Lane-1 prover gets a formalization-ready leaf rather than a multi-session monolith.
The new helper `cechCohomology_isZero_of_iso` and the two `_of_tildeVanishing` reduction lemmas also need
blueprint entries (see Coverage debt below).

## Closest-to-completion / highest-value next targets
1. **The residual `htilde` (change-of-base-to-`R_f` Čech-complex iso)** — the SINGLE leaf both
   `affine_cech_vanishing_qcoh` and `affine_serre_vanishing` now bottom out at. The prover handed off a
   precise decomposition (task_results/AffineSerreVanishing.md), in dependency order:
   1. **[DONE]** `affine_cover_span_localizationAway` — `{gᵢ/1}` spans `R_f`.
   2. `M_f` as `ModuleCat R_f` + per-σ iso `Γ(D_R(gσ),~_R M) ≅ Γ(D_{R_f}(gσ/1),~_{R_f} M_f)` (both are
      `M[1/gσ]`; the localization map is iso since `f` is already inverted). The restriction infra in
      `QcohRestrictBasicOpen.lean` (`modulesRestrictBasicOpen`, `modulesRestrictBasicOpenIso`,
      `presentationModulesRestrictBasicOpen`) is the intended engine.
   3. The cosimplicial-Ab iso `sectionCechCosimplicial (D_R g) (~_R M) ≅ sectionCechCosimplicial (D_{R_f}
      g/1) (~_{R_f} M_f)`, degreewise = product of the (2) isos, then `(alternatingCofaceMapComplex
      Ab).mapIso` for the cochain-complex iso.
   4. Assemble: transport `sectionCech_affine_vanishing R_f M_f (g/1)
      (affine_cover_span_localizationAway …)` along the (3) iso, feed the `_of_tildeVanishing` lemmas.
   This is genuinely multi-session infra (comparable to the keystone chain). Consider an **effort-breaker**
   on the residual once it has a blueprint node, to expose the sub-leaves as separate ready frontier nodes.
   Note the `CechAcyclic` module machinery (`sectionToModuleAddEquiv`, `dDiff_exact`, `phi`, `dCoeff`) is
   `private` — an `R_f`-direct re-derivation is NOT available; the change-of-space route is forced.

2. **Lane 2 — `cechAugmented_exact` (P5a) was dispatched but NO prover ran this iter.** Re-dispatch it: it
   is independent of 02KG, gating only on `qcoh_iso_tilde_sections` (done). The iter-049 planner already
   realigned its blueprint proof to the stalk-at-prime "one `f_i` is a unit" contracting-homotopy argument.
   Investigate why only one prover produced output (logs show a single prover lane —
   `AlgebraicJacobian_Cohomology_AffineSerreVanishing.jsonl`; no `CechHigherDirectImage` task_result).

## Reusable proof patterns discovered
- **Coefficient-iso Čech transport:** `cechCohomology_isZero_of_iso` — `IsZero.of_iso` of the homology
  functor applied to `sectionCechComplexFunctor.mapIso e`. Reuse to transport Čech vanishing along any
  presheaf-of-modules iso.
- **R_f spanning from a cover of D(f):** `← PrimeSpectrum.iSup_basicOpen_eq_top_iff`, then
  `simp [← comap_basicOpen]`, `map_iSup`, `← hcov`, `comap_basicOpen`, and `D(unit)=⊤` via
  `IsLocalization.Away.algebraMap_isUnit` + `Ideal.eq_top_of_isUnit_mem`.
- **`Ext` resolution performance:** reactivate the file-local `attribute [local instance] hasExtModules`
  (the `HasExt.standard` instance from `AbsoluteCohomology.lean`) in any file using `Ext` over
  `(Spec R).Modules`, AND spell `CategoryTheory.Abelian.Ext` fully-qualified — both dodge the slow
  `HasSmallLocalizedHom` / overload-resolution typeclass timeouts (20000-heartbeat deterministic timeout).

## Coverage debt — 4 new lean_aux nodes need blueprint entries (planner authors prose)
All in `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`, chapter `Cohomology_CechHigherDirectImage.tex`:
- `AlgebraicGeometry.affine_cover_span_localizationAway` — deps: `PrimeSpectrum.iSup_basicOpen_eq_top_iff`,
  `PrimeSpectrum.comap_basicOpen`, `map_iSup`, `IsLocalization.Away.algebraMap_isUnit`,
  `Ideal.eq_top_of_isUnit_mem`. (The `R_f` spanning leaf — wire into `lem:affine_cech_vanishing_qcoh`'s
  expanded proof.)
- `AlgebraicGeometry.cechCohomology_isZero_of_iso` — deps: `sectionCechComplexFunctor`,
  `HomologicalComplex.homologyFunctor`, `IsZero.of_iso`.
- `AlgebraicGeometry.affine_cech_vanishing_qcoh_of_tildeVanishing` — deps: `qcoh_iso_tilde_sections`
  (+ instance `isIso_fromTildeΓ_of_quasicoherent`), `cechCohomology_isZero_of_iso`, `affineCoverSystem`.
  (The reduced seed; specializes to `lem:affine_cech_vanishing_qcoh` once `htilde` lands.)
- `AlgebraicGeometry.affine_serre_vanishing_of_tildeVanishing` — deps:
  `affine_cech_vanishing_qcoh_of_tildeVanishing`, `cech_eq_cohomology_of_basis`, `jShriekOU`,
  `affineCoverSystem`. (The reduced top; specializes to `lem:affine_serre_vanishing`.)
Plus the 1 pre-existing dead node `AlgebraicGeometry.CechAcyclic.affine` (still `sorry`, superseded — the
planner may want to formally retire it).

## Do NOT
- Do NOT re-dispatch Lane 1 at the residual `htilde` as a single monolithic build before the blueprint
  change-of-base sketch + sub-leaf decomposition is written — the prover already identified this is
  multi-session infra and would otherwise re-derive the decomposition from scratch.
- Do NOT treat the two blueprint-named targets (`affine_serre_vanishing`, `affine_cech_vanishing_qcoh`) as
  formalized — they are reduced-not-proven; their `\lean{}` pins are aspirational. sync_leanok correctly
  left them without `\leanok`.
