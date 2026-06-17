# Effort Breaker Report

## Slug
corecomm072

## Target
`lem:coreIso_comm` (`AlgebraicGeometry.coreIso_comm`)

## Status
COMPLETE — target re-expressed as a 3-link `\uses`-chain cut along the two recorded seams
(S1 per-coface square, split further into a per-leg piece; S2 alternating-sum bookkeeping).

## Effort before → after
- target `effort_local`: 2242 → **1330**
- sub-lemmas added: 3 (leg → coface → sum)
- target `dep_count`: 4 → 2 (now `lem:coreIso_comm_sum`, `lem:coreIso_obj_iso`)

## Chain added (target ← sum ← coface ← leg)
- `\label{lem:coreIso_comm_leg}` `\lean{AlgebraicGeometry.coreIso_comm_leg}` — **S1, finest.**
  Per-leg naturality: for fixed coface index `k` and multi-index `σ' : Fin(p+2)→I`, the
  `σ'`-coordinate of `G_V(Ψ(δ^nerve_k)) · (objIso (p+1)).hom` (through `sectionCechProductEquiv`)
  equals `sectionCechFaceRestr(σ', k)` applied to the `(σ'∘d_k)`-coordinate of `(objIso p).hom`.
  This is the actual unwinding through `pushPull_eval_prod_iso` → `pushPull_sigma_iso` →
  `PreservesProduct.iso` → `pushPull_leg_sections`, plus the open-meet identity.
  `effort_local ≈ 1602`. `\uses{lem:coreIso_obj_iso, lem:pushPull_eval_prod_iso,
  lem:pushPull_sigma_iso, lem:pushPull_leg_sections, lem:section_cech_product_equiv,
  lem:coverInterOpen_inf_distrib}`.
- `\label{lem:coreIso_comm_coface}` `\lean{AlgebraicGeometry.coreIso_comm_coface}` — **S1 map form.**
  Per-coface square `(objIso p).hom · δ^sec_k = G_V(Ψ(δ^nerve_k)) · (objIso (p+1)).hom`, proved by
  coordinatewise extensionality through `sectionCechProductEquiv`: LHS coordinate is
  `sectionCechFaceRestr` (the `Pi.lift` projection underlying `section_cech_objd_apply`),
  RHS coordinate is the leg lemma. `effort_local ≈ 985`. `\uses{lem:coreIso_comm_leg,
  lem:section_cech_product_equiv, lem:section_cech_objd_apply}`.
- `\label{lem:coreIso_comm_sum}` `\lean{AlgebraicGeometry.coreIso_comm_sum}` — **S2 (the recorded
  Lean blocker).** Full-differential square `(objIso p).hom · d^p = d^p · (objIso (p+1)).hom`,
  stated/proved ELEMENTWISE via `sectionCech_objD_apply`: both sides are pointwise `∑_k (-1)^k(…)`,
  matched summand-by-summand by `coreIso_comm_coface` under `Finset.sum_congr` — deliberately
  avoiding the `Preadditive.comp_sum`/`Functor.map_sum` route that clashes with the bundled
  `AddCommGrpCat`-hom representation of `objD` (the iter-067 stuck point). `effort_local ≈ 1167`.
  `\uses{lem:coreIso_comm_coface, lem:section_cech_objd_apply, lem:section_cech_product_equiv}`.
- Target `lem:coreIso_comm` proof rewritten to: "the square is the assembly of
  `lem:coreIso_comm_sum`; degreewise squares promote `objIso` to a complex iso via
  `isoOfComponents`." Statement+proof `\uses{lem:coreIso_comm_sum, lem:coreIso_obj_iso}`.
  The degree-0 `h_compat` paragraph is preserved unchanged.

## Still hard (re-break candidates)
- `lem:coreIso_comm_leg` (≈1602) — the largest remaining single piece, but it is the irreducible
  mathematical content (the 4-stub push–pull unwinding on one product leg). If the prover stalls,
  re-dispatch the breaker to split it sentence-wise along the three identifications inside
  `pushPull_eval_prod_iso`: (a) `pushPull_sigma_iso` coproduct→product on the σ'-leg, (b) the
  `PreservesProduct.iso` / section-functor projection, (c) `pushPull_leg_sections` rewrite of the
  leg as `Γ(U_σ' ∩ V, F)`, then (d) the `coverInterOpen_inf_distrib` reindex to the meet form.

## Could not decompose (strategy items)
- None. Every gap the original `sorry` crossed is covered: S1 (geometry/leg) by `…_leg`+`…_coface`,
  S2 (alternating-sum bookkeeping) by `…_sum`.

## References consulted
- None retrieved — the decomposition re-expresses the existing in-file proof sketch; all cited
  blocks (`pushPull_*`, `section_cech_*`, `coverInterOpen_inf_distrib`, `coreIso_obj_iso`) are
  pre-existing and DONE.

## Notes for dispatcher
- New `\lean{}` names assigned by convention (verified FREE in repo — grep over
  `AlgebraicJacobian/` + `blueprint/` returned nothing): `AlgebraicGeometry.coreIso_comm_leg`,
  `AlgebraicGeometry.coreIso_comm_coface`, `AlgebraicGeometry.coreIso_comm_sum`. The prover should
  scaffold these three new declarations in `CechSectionIdentification.lean` and rewire the existing
  `coreIso_comm` body (currently one `sorry` at ~line 1506) to `exact coreIso_comm_sum …` once the
  chain is filled.
- No new macros needed — all notation (`\operatorname{sectionCechFaceRestr}`,
  `\operatorname{pushPullObj}`, `G_V`, `\Psi`, `\mathrm{objIso}`) is already in the chapter.
- Graph verified: `lem:coreIso_comm` effort 2242→1330, three new nodes present with dep_counts
  6/3/3, no broken `\uses`. NO `\leanok` added (the pre-existing statement-level `\leanok` on
  `coreIso_comm`, owned by sync, left untouched).
