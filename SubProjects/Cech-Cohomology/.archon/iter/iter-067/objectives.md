# Iter-067 objectives

## Lane 1 — `CechSectionIdentification.lean` (`prove`)

Close the 3 residual sorries; closing all ⟹ CSI sorry-free ⟹ `CechAugmentedResolution.hSec` (229) wireable.

1. **`coreIso` (1492)** — build the new 3-lemma chain, then assemble:
   - `coverInterOpen_inf_eq_iInf_inf` (`lem:coverInterOpen_inf_distrib`) — `Opens` lattice fact, `inf` over
     nonempty `iInf`. effort 595.
   - `coreIso_objIso` (`lem:coreIso_obj_iso`) — degreewise object iso via `pushPull_eval_prod_iso` + `Pi.mapIso`/
     `eqToIso` reindex. effort 1213.
   - `coreIso_comm` (`lem:coreIso_comm`) — per-`(p,p+1)` differential commutation via `sectionCechProductEquiv` +
     `sectionCech_objD_apply`. effort 2242 — the genuine wall.
   - assemble `coreIso := HomologicalComplex.Hom.isoOfComponents coreIso_objIso coreIso_comm`.
2. **`hcompat` (1504)** — the p=0 instance of `coreIso_comm` (evaluated `cechAugmentation` through `objIso 0` = ε);
   closes definitionally through the `restrictScalars(𝟙)`/`toPresheaf` adapter. Discharge alongside `coreIso_comm`.
3. **Stub 6 `cechSection_contractible` (1585)** — `Homotopy (𝟙 (D'_aug)) 0` with `V ≤ coverOpen 𝒰 i_fix`.
   Positive degrees via `CombinatorialCech.depHomotopy`/`depHomotopy_spec` (prepend `i_fix`); degree-0 augmentation
   node via the explicit `π_{i_fix}` identity. Verify `depHomotopy`/`depHomotopy_spec` signatures first.

Blueprint: `Cohomology_CechHigherDirectImage.tex` — `lem:coverInterOpen_inf_distrib`, `lem:coreIso_obj_iso`,
`lem:coreIso_comm`, `lem:cechSection_complex_iso`, `lem:cechSection_contractible`. Gate CLEARED
(blueprint-reviewer `rescope067`).

Priority: `coreIso` chain first (unblocks `hcompat` + all of Stub 5). If `coreIso_comm` or Stub 6 stalls "near
budget", hand off the precise residual (typed sub-lemma) — do NOT brute-force or re-decompose what's at the
fine floor.

## No second lane
OpenImm DONE (P5a-consumer complete); CechAugmentedResolution.hSec gated on this lane; P5b frozen + gated on
P5a-resolution. progress-critic confirmed no under-dispatch — CSI is the sole active route and its 3 sorries are
strictly sequential (no parallelism available).
