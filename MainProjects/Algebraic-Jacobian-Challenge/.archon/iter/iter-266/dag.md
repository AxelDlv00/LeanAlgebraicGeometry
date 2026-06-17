# DAG iter-266 narrative

## Objective this iteration

Eliminate the blueprint ∞-holes. The injected coverage summary listed 10
infinity-source declarations; `leandag build` confirmed 36 total ∞-effort nodes
(36 = 10 root blueprint declarations whose informal proofs were missing + their
∞ closure, alongside lean-aux sorry nodes).

## Diagnosis

All 10 blueprint ∞-sources had **empty `proof_tex`**. Cause: each is a
top-level theorem whose proof either lived in a separate `\section{Proof
decomposition}` / combined-proof block (not inside the theorem environment) or
was simply never written. leandag attributes a `\begin{proof}` only to the
immediately-preceding declaration, so combined proofs left the other theorems
with empty bodies → ∞.

Two were trivial and fixed directly:
- `lem:Scheme_AffineCoverMVSquare_corners` (Cohomology_MayerVietoris) — vestigial
  umbrella lemma, no `\lean{}`, no consumers, duplicated the four proved
  `…_X1…X4` corner lemmas → **removed** (isolation/removal call confirmed by the
  reviewer afterwards).
- `thm:Scheme_module_finite_HModule_prime_of_affine_curve`
  (Cohomology_StructureSheafModuleK) — proved sorry-free in Lean → added a short
  specialisation `\begin{proof}` ("proved directly in Lean").

## Dispatches

Four `blueprint-writer`s (parallel), each adding/redistributing informal proofs:

| Writer | Chapter | Work | Result |
|---|---|---|---|
| dag-identitycomponent266 | Picard_IdentityComponent | split 2 combined proofs into 5 per-theorem `\begin{proof}` blocks | COMPLETE |
| dag-rigiditykbar266 | RigidityKbar | assembled proof of `thm:rigidity_over_kbar` (C.2.b–e) | COMPLETE |
| dag-flattening266 | Picard_FlatteningStratification | assembled proof of `thm:flattening_stratification_exists` | COMPLETE |
| dag-codimone266 | Albanese_CodimOneExtension | proof of `lem:smooth_algebra_krull_dim_formula` (Stacks 00OE) | COMPLETE |

All four reported no strategy-modifying findings and no reference-retriever
dispatches (every source was already in `references/` and cited in-chapter).

Then one direct `\lean{}` fix:
- `lem:geometricallyConnected_of_connected_of_section` — namespace corrected
  `AlgebraicGeometry.GroupScheme.IdentityComponent.…` → `…GroupScheme.…`
  (the real Lean decl is a `private theorem` in `namespace GroupScheme`).
  This matched the node AND removed one lean-aux ∞ (the lemma already had a proof).

## blueprint-reviewer (dag266) findings

Whole-blueprint audit. Verdicts on the 6 touched chapters: all `complete: true`;
`correct: true` for RigidityKbar, FlatteningStratification, MayerVietoris;
`correct: partial` for IdentityComponent (one spurious `\uses{}`),
CodimOneExtension (documented Kähler-rank→Krull-dim bridge residual),
StructureSheafModuleK (pre-existing unmatched `\lean{}`). **No must-fix blockers.**
`unknown_uses: []` confirmed (the new `\uses{}` chains all resolve).

Acted on:
- **wire-up**: removed spurious `\uses{thm:identity_component_open_subgroup}` from
  the `lem:geometricallyConnected_of_connected_of_section` proof (the Stacks
  037Q/04KV argument never invokes it).

Noted for downstream (review agent's `\lean{}` domain), NOT chased this iter —
25 **unmatched `\lean{}`** entries (pre-existing name drift, not ∞ sources):
`Cohomology_StructureSheafModuleK` (4: `…IsAffineHModuleHomFinite`,
`…prime_zero_of_isAffineHModuleHomFinite`, `…prime_of_affine`,
`…prime_of_affine_curve`); `Picard_LineBundlePullback` (6:
`pullback_compatible_with_tensorobj`, `pullback_tensor_iso`,
`pullback0_tensor_iso`, `pullback_tensor_iso_loctriv`,
`isinvertible_implies_locallytrivial`, `isinvertible_pullback`);
`Picard_TensorObjSubstrate`/`RelPicFunctor` (5: `rel_pic_addcommgroup_via_tensorobj`,
`baseMap_pullbackComp_apply`, `baseMap_pullback_comp_apply`,
`baseMap_pullbackCongr_apply`, `baseMap_inv_step3_open_immersion`);
`AbelianVarietyRigidity` (2: `hom_Ga_to_av_trivial`, `hom_from_Ga_trivial`);
`RigidityKbar` S3 lemmas (4: `S3_sep_1/2`, `S3_pi_1/2`);
`Albanese_AlbaneseUP` (`albaneseUP` → `Pic0.albanese_universal_property`);
`Cohomology_MayerVietoris` (`Abelian.Ext.chgUnivLinearEquiv`);
`Albanese_CodimOneExtension` (`…ringKrullDim_localization_eq_relativeDimension`,
not yet landed). These belong to the loop's review agent (`\lean{}` corrections)
and the prover frontier; reconciling 25 cross-file renames is out of proportion
to the DAG benefit (none is an ∞ source).

## leandag stats: before → after

| metric | before | after |
|---|---|---|
| ∞-effort nodes (total) | 36 | 25 |
| ∞ blueprint-labelled | 10 | **0** |
| ∞ lean-aux (prover sorries) | 26 | 25 |
| broken `\uses{}` | 0 | 0 |
| blueprint nodes | 544 | 543 (corners removed) |
| effort done (Lean chars) | 673,253 | 673,253 |

## What remains

The blueprint roadmap is mathematically complete (0 blueprint ∞). The remaining
25 ∞ are lean-aux `sorry` declarations — the active A.1.c.sub frontier, the
A.2.c `⟨sorry⟩` representability instances, and internal decomposition helpers —
which the prover loop discharges. No external reference was unobtainable this
iter; no `TO_USER.md` action needed.

## Subagent skips

- strategy-critic: STRATEGY.md was NOT modified this iteration (no route/phase/
  decomposition change — purely informal-proof fills + one `\lean{}` namespace fix
  + one vestigial-lemma removal). The dag-phase strategy-critic trigger ("dag phase
  that touched STRATEGY.md") does not fire; prior verdict sc264 SOUND with no live
  challenge, unchanged.
