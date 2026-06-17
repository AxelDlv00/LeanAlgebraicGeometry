# Session 55 (iter-055) — Recommendations for next plan iter

## TOP — escalations (do NOT re-queue identical prover rounds)

1. **GF `genericFlatness` — ESCALATE the open-immersion flat-epimorphism base change as a dedicated
   `mathlib-build` lane (pure ring/module theory).** The geometric + algebraic plumbing is DONE; the sole
   remaining sorry (FlatteningStratification L3192) needs one ring/module lemma:
   `IsBaseChange Γ(S,U) (id : M →ₗ[Γ(S,V)] M)` from the open immersion `U ↪ V` (a flat ring epimorphism,
   `R ⊗_{A_f} R ≅ R`). Consumer `gf_flat_of_isBaseChange_id` is built and waiting. Deadline iter-055 was
   MISSED — this is a route gap, not effort. Precise statement: `informal/gf_openImmersion_isBaseChange.md`.
   Counterexample confirms the naive "flat-over-A_f + tower ⟹ flat-over-R" is FALSE; the epimorphism is
   essential. Effort-break / blueprint the flat-epi lemma before dispatch.

2. **SNAP — give a dedicated multi-iter budget OR split into 3 sub-objectives.** The presheaf promotion is
   constructible (CommRing routing de-risked, all categorical ingredients verified present) but heavy. The next
   brick `T` (triple-tensor presheaf) hit a 200k-heartbeat `whnf` wall — a perf problem, NOT a Mathlib gap.
   Split: (a) `T`-presheaf with `maxHeartbeats 800000` + explicit `simp only` lists (avoid bare `simp; rfl`;
   consider building `T` by re-using `relTensorDomainPresheaf` twice); (b) 3 nat-transes (`aLnat`/`aRnat`
   semilinearity via `P.map_smul`/`Q.map_smul`; `piNat` via `tensorObj_map_tmul`) + `evaluationJointlyReflectsColimits`
   lift + `relativeTensorCoequalizerIso` apex iso; (c) crux `isIso_sheafification_whiskerRight_unit` + the
   stalk bridge (ℤ-whiskered-row inversion via `TopCat.Presheaf.stalk` — module-sheaf stalks do NOT exist;
   `GrothendieckTopology.W.monoidal` is Day-convolution, inapplicable pointwise).

3. **GR-quot `glue` — blueprint-expand the module-descent sub-pieces BEFORE dispatch.** `glue` (L271) gates
   universalQuotient/tautologicalQuotient/represents (3 sorries). It is descent of sheaves of modules along
   `Scheme.GlueData` with no Mathlib turn-key — a multi-hundred-line build. Supporting infra
   (`pullbackBaseChangeTransport`, `glueData_bridge_*`, C1/C2 cocycle hyps) is already in place. Expand:
   (1) glued presheaf `Γ(glued-M,V)` via `existsUnique_gluing'` on cover `{ιᵢ}`; (2) O_glued-module structure;
   (3) sheaf condition; then C2 feeds the cocycle. Do NOT dispatch a speculative partial body.

## MEDIUM — blueprint coverage debt (planner authors prose; review cannot)

Run after this iter; 6 `lean_aux` unmatched nodes (5 new helpers + `opensTopology` intentional private). New
helpers needing `\lean{}` blocks:
- **FLAT** `AlgebraicGeometry.gf_section_span_flat_descent` — span-descent core (`Module.flat_of_isLocalized_span`).
  Should re-pin `lem:gf_section_localization_flat_descent` (see `% NOTE:` I added).
- **FLAT** `AlgebraicGeometry.gf_flat_of_isBaseChange_id` — per-piece base descent (one-line
  `Module.Flat.isBaseChange` consumer of the missing flat-epi ingredient).
- **GR-quot** `AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_comp` — composite free-pullback coherence
  (analogue of `pullbackFreeIso_id`); used directly in `functor.map_comp`. Add `lem:gr_pullbackFreeIso_comp`.
- **GR-quot** `AlgebraicGeometry.Scheme.Modules.homEquiv_conjugateEquiv_app` — general mate/conjugate
  compatibility of `Adjunction.homEquiv`; used in `pullbackObjUnitToUnit_comp`. Add a mate-compatibility block.
- **SNAP** `AlgebraicGeometry.Scheme.Modules.relTensorDomainPresheaf` — Step-1 domain presheaf
  `U↦Γ(U,P)⊗_ℤΓ(U,Q)`; add as ingredient of `lem:relativeTensor_as_coequalizer`
  (`def:relTensorDomainPresheaf`). Proof relies only on `TensorProduct.map` functoriality.

Also (lvb-flat major #2/#3/#4, `% NOTE:`-flagged this iter): re-pin/restructure the 3 stale blocks
(`lem:gf_section_localization_flat_descent`, `lem:gf_flat_locality_assembly`, `lem:gf_stalk_flat_over_base`)
whose `\lean{}` point at non-existent decls. lvb-grquot major: blueprint proof sketch for
`lem:gr_pullbackObjUnitToUnit_comp` under-specifies the mate-compatibility decomposition — add the helper step.

## LOW — stale `.lean` comments (prover/refactor domain; review cannot edit `.lean`)
- GrassmannianQuot ~L170-173: `glue` section docblock says C1/C2 cocycle hyps "remain to be added" — both
  `_hC1`/`_hC2` ARE in the signature. Correct to "signature complete; body remains."
- GrassmannianQuot ~L844: `represents` NOTE lists `functor` as a remaining dep — `functor` is now closed.
- FLAT ~L538-540: stale "iter-018 foundation"/"L4 closed iter-021" mid-proof comments.
- `gf_base_localization_comparison`: persisting IsLocalization-prose vs Module.Flat-Lean mismatch since
  iter-054 (NOTE in place; resolve by downgrading prose or strengthening Lean — assembly only consumes flatness).

## Do NOT retry without structural change
- **GF stalk route** (`gf_stalk_flat_over_base`): DEAD — `SheafOfModules.stalk` absent from Mathlib. The
  source-span route is the live one; the only residue is the flat-epi base change (TOP §1).
- **SNAP `T`-presheaf via bare `simp; rfl` element induction:** confirmed 200k-heartbeat wall. Use explicit
  `simp only` lists / re-use the Step-1 functor; do NOT re-dispatch the naive form.
- **GR-quot `glue` speculative body:** blueprint-expand first (TOP §3); do not send a prover at the raw
  multi-hundred-line construction.

## Reusable proof patterns discovered
- **Mathlib `exists_basicOpen_le_affine_inter`** packages the entire cross-chart basic-open realisation
  (`g`, `ḡ`, `D g = D ḡ`, `x ∈ D g`) — replaces manual `IsLocalization.surj''` + `basicOpen_mul`. Unblocked a
  2-iter STUCK.
- **Modules-diamond term-mode discipline** (GR-quot): `rw` cannot find right-assoc sub-composites under the
  Modules category diamond → pure term-mode `calc`/`.trans` + explicit `Category.assoc`/`whisker_eq`/`eq_whisker`/
  `congrArg`; avoid `set`; trailing bare `rfl` for defeq residue; restate cofan-comparison lemmas with explicit
  `pullbackFreeIso` types (defeq `pullbackObjFreeIso` blocks `congrArg`); watch base-ring-sheaf shift in `ιFree (R := …)`.
- **Presheaf-of-modules apex CommRing routing** (SNAP): use `R ⋙ forget₂ CommRingCat RingCat` form (Monoidal.lean
  L31 instance) so `CommRing (R₀.obj U)` fires and matches `tensorObj_obj` — never hand-roll `inferInstanceAs`
  on the ringCatSheaf carrier (Module diamond).
