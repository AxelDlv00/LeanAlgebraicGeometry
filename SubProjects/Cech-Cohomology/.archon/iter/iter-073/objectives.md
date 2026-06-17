# iter-073 objectives — detail

## Lane 1: CechSectionIdentification.lean (`prove`)
Build confirmed GREEN (`lake env lean`, exit 0) with exactly 2 sorries; no errors.

### Leaf A (do FIRST) — `sectionCechAugV_π` (decl 2074, sorry 2081)
Degree-0 augmentation seam. Project `sectionCechAugV` onto σ-leg via PROVED `pushPull_sigma_iso_π`;
augmentation factors through terminal of `Over X` (collapses `a₀(σ)≫aug` to canonical
`Over.mk j_σ ⟶ Over.mk 𝟙X`, no `a₀` unwinding); `pushPull_leg_sections` gives the plain restriction
`Γ(V,F)→Γ(⨅_l(U_{σl}∩V),F)` = RHS `homOfLE (stubInterLeV …)`. No coface combinatorics.
Blueprint `lem:sectionCechAugV_π`. Closing it ⇒ Stub 6 sorry-free + satisfies the CONVERGING watch-flag.

### Leaf B (the wall) — `coreIso_comm_leg` (decl 1518, sorry 1536)
Per-leg naturality. Blueprint `lem:coreIso_comm_leg` (proof sketch L8806–8825). Unwind
`coreIso_objIso (p+1)` = `pushPull_eval_prod_iso` reindexed by `coverInterOpen_inf_distrib`; factors via
`pushPull_sigma_iso`→product→`pushPull_leg_sections`. Project σ'-leg via `pushPull_sigma_iso_π`; nerve
coface δ^nerve_k acts as F-restriction along k-th face inclusion = `sectionCechFaceRestr σ' k`. ELEMENTWISE
on sums (no `Preadditive.comp_sum`/`Functor.map_sum`). If stalls → typed sub-sorries on (a) σ'-leg proj,
(b) section-functor product proj, (c) `pushPull_leg_sections`, (d) `coverInterOpen_inf_distrib` reindex.

## Coverage debt — CLEARED (27→0) by blueprint-writer `covdebt073`.
## Gate — PASS (blueprint-reviewer `iter073`).
