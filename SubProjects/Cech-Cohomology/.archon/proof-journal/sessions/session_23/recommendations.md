# Recommendations for the next plan iteration (post iter-023)

## Headline
The 4-iter CHURNING bottleneck on Route 2 is **broken**: `cechFreeEvalEngineIso` landed
axiom-clean. Route 2 is now genuinely CONVERGING — the named target `cechFreeComplex_quasiIso`
is reduced to one well-scoped construction (engine augmentation H₀ identification + Arrow-iso
transfer), with every prerequisite in-file. No structural pivot needed.

## HIGH — blueprint-coverage gate before the next prover round (must-fix-this-iter, blueprint-side)
Both LVB checkers and the dag-query agree: a **blueprint-writer pass is required before dispatching
provers** on either lane, to restore the 1-to-1 Lean↔blueprint correspondence and to give the next
prover an adequate sketch. The HARD GATE will otherwise hold these files.

1. **FreePresheafComplex — pin the engine-augmentation cluster.** New `lean_aux` decls with no
   blueprint block: `cechEngineAug0`, `cechEngineAug0_ι`, `cechEngineD_comp_aug`,
   `cechEngineComplexAug`, `cechEngineComplex_exactAt` (candidate new block `lem:cech_engine_acyclic`),
   `freeYonedaEval_iso_of_le_hom_eq_aug`, `freeYonedaEval_iso_of_le_natural`. Bundle the privates
   (`cechFreeEval_X_ι_inv`, `cechFreeEvalEngine_X_inv_hom_ι`, `cechFreeEvalEngine_map_ι`,
   `freeYonedaAug_app_comp`, `cechFree_d_ι`, `cechFreeEvalEngine_comm`) into a related decl's
   `\lean{...}` list (private does NOT exempt from `unmatched`). Then expand the
   `lem:cech_free_eval_nonempty` proof sketch to describe the degree-0 (H₀≅O_X(V)) route, since that
   is the next prover's actual work.

2. **CechBridge — pin the two new core lemmas + expand `ses_cech_h1`.**
   `sectionCech_objD_exact_of_isZero_homology` and `sectionCech_one_coboundary_of_isZero_homology`
   are unmatched; add `\lean{...}` blocks (the latter is the `\uses{def:cech_complex}` core of
   `lem:ses_cech_h1` — give it a dedicated block, e.g. `lem:cech_one_coboundary`, or fold into
   `lem:ses_cech_h1`'s `\lean` list). The `lem:ses_cech_h1` proof sketch currently lacks Mathlib API
   hints for the two remaining sheaf-theoretic steps; expand with the located API (see below).

### Full `unmatched` list (15 nodes — Step 6 coverage debt)
FreePresheafComplex (13): `cechEngineAug0`, `cechEngineAug0_ι`, `cechEngineComplexAug`,
`cechEngineComplex_exactAt`, `cechEngineD_comp_aug`, `cechFreeEvalEngine_X_inv_hom_ι`,
`cechFreeEvalEngine_comm`, `cechFreeEvalEngine_map_ι`, `cechFreeEval_X_ι_inv`, `cechFree_d_ι`,
`freeYonedaAug_app_comp`, `freeYonedaEval_iso_of_le_hom_eq_aug`, `freeYonedaEval_iso_of_le_natural`.
CechBridge (2): `sectionCech_objD_exact_of_isZero_homology`, `sectionCech_one_coboundary_of_isZero_homology`.

## HIGH — closest-to-completion target: finish `cechFreeComplex_quasiIso` (Route 2)
After the blueprint pass, dispatch FreePresheafComplex scoped to **(2) `cechFreeEval_quasiIso_of_nonempty`**
(the only real remaining math) then **(3)** the 5-line assembly. Recipe is fully spelled out in
`task_results/FreePresheafComplex.md` §(2),(3):
- Positive degrees: trivial via `cechFreeEvalEngineIso` (homologyMap of the iso) + `cechEngineComplex_exactAt`.
- Degree 0 (the work): `H₀(engine) ≅ O_X(V)` via `ChainComplex.toSingle₀Equiv` (using `cechEngineD_exact`/
  `cechEnginePrepend_spec` at n=0) + the nonempty identification `(eval V).obj(coverStructurePresheaf 𝒰) ≅ O_X(V)`,
  then `quasiIso_of_arrow_mk_iso`.
- (3) one-liner: `quasiIso_of_evaluation` + `by_cases` (nonempty=(2), empty=`cechFreeEval_quasiIso_of_isEmpty`).
  Watch `op`/`unop`: `quasiIso_of_evaluation` quantifies `V : (Opens X)ᵒᵖ`.

Once (3) lands, the queued `injective_cech_acyclic` (CechBridge, gated on it) becomes a one-step assembly.

## MEDIUM — `ses_cech_h1` (CechBridge): scaffold the two sheaf-theoretic pieces, do NOT one-shot
The Čech core is done; the residual is pure sheaf theory and was correctly left absent. Next round:
scaffold (mathlib-build) the two pieces separately, then assemble:
1. **Local-surjectivity extraction**: `CategoryTheory.Sheaf.isLocallySurjective_iff_epi` +
   `PresheafOfModules.IsLocallySurjective` → from `Epi(G→H)` get a cover with each `s|_{𝒰 i}` lifting to `G(𝒰 i)`.
2. **Cocycle + coboundary**: differences `c σ = s_{σ1}|_σ − s_{σ0}|_σ` land in F; feed the landed
   `sectionCech_one_coboundary_of_isZero_homology` to get `t_i ∈ F(𝒰 i)`.
3. **Gluing**: `SheafOfModules.isSheaf` + `Presheaf.IsSheaf.amalgamate` over the cover sieve to glue `s_i − t_i`.
Consider a `mathlib-analogist` (api-alignment) consult on the `Epi → IsLocallySurjective → section lift`
bridge and the cover-sieve amalgamation for `SheafOfModules` over a scheme before the prover round — both
are flagged as absent in directly-usable form.

## MEDIUM — lean-auditor finding (Lean-side, non-blocking)
- **MAJOR (stale docstring)**: `FreePresheafComplex.lean:14–22` module docstring still says the file
  "owns" `cechFreeComplex_quasiIso`, which is not built. The `(not yet built)` parenthetical mitigates
  it. The next prover that touches the file should correct the "owns" framing (review agent cannot edit
  `.lean`). Full report: `task_results/lean-auditor-iter023.md`.

## LOW (notes, not action items)
- `cechFreeEvalEngine_comm` uses 7 consecutive `erw` (correct but fragile per auditor — inherent to the
  defeq-not-syntactic free-complex indexing; not worth refactoring while it compiles).
- `cechEngineX` is a `noncomputable abbrev` with no transparency-rationale comment; `cechEngineD_comp_aug`
  has one `erw` that could be `simp` (cosmetic).

## Do-NOT-retry / blockers
- Do NOT dispatch a prover at P3 general-F (`01I8` `F≅~(ΓF)`) — near-∞-effort, no formalizable sketch
  yet; defer to the 02KG consumer phase (planner D3, still valid).
- Do NOT re-attempt `ses_cech_h1` as a single all-or-nothing build — it needs the two scaffolded sheaf
  pieces first (above).
- Do NOT use `rw [Category.assoc]`/`rw [Preadditive.comp_sum]`/`rw [← Functor.map_comp]` on free-complex
  compositions — they fail silently on the defeq-not-syntactic middle objects. Use `erw` / `refine (term).trans`.
