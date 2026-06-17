# Recommendations — next plan iter (post iter-045)

## 0. Headline
Both lanes returned PARTIAL with real progress: **+4 axiom-clean defs, 0 new sorry, build GREEN.**
- **FBC**: the 8-iter structural unknown (build adjR/β, conjugate-comparable, core coherence) is **RESOLVED
  in Lean**. Keystone NOT closed → **PARKED** per the armed kill-criterion. Off critical path.
- **GF-G1**: locality reduction DONE; full G1 blocked on the **finite-type base case** (Mathlib-absent
  sheaf-epi⟹module-surjectivity bridge). This is now the live GF bottleneck.

## 1. Coverage debt — 4 unmatched `lean_aux` nodes (blueprint blocks needed) [MEDIUM, do this iter]
`archon dag-query unmatched` = 4. Each new non-private def needs a blueprint block to restore the 1-to-1
Lean↔tex correspondence (planner authors the prose; review agent cannot). Dispatch a blueprint-writer:
- **`AlgebraicGeometry.keystoneAdjR`** (FlatBaseChange.lean L1755) — depth-3 right adjunction of the keystone
  conjugate pair. Deps: `ModuleCat.extendRestrictScalarsAdj`, `tilde.adjunction`,
  `Scheme.Modules.pullbackPushforwardAdjunction`, `pullbackSpecIso`, `Algebra.TensorProduct.includeLeftRingHom`.
  Suggested label `def:keystone_adjR` under `Cohomology_FlatBaseChange.tex` near `lem:..._legs_conj`.
- **`AlgebraicGeometry.keystoneBeta`** (FlatBaseChange.lean L1772) — comparison nat-iso `R₁≅R₂`. Deps:
  `Scheme.Modules.pushforwardComp`, `gammaPushforwardNatIso`, `isoWhiskerLeft/Right`, `associator`,
  `moduleSpecΓFunctor`. Suggested label `def:keystone_beta`.
- **`AlgebraicGeometry.finite_localizedModule_of_isLocalizedModule`** (FlatteningStratification.lean L2173) —
  model-independence of localized-module finiteness. Deps: `IsLocalizedModule.linearEquiv`,
  `IsLocalization.algEquiv`, `Module.End.isUnit_iff`, `IsLocalization.mk'_spec`, `Submodule.span_induction`.
  Suggested home: helper under `sec:gf_geometric_bridges`.
- **`AlgebraicGeometry.gf_finite_sections_of_basicOpen_finite_cover`** (FlatteningStratification.lean L2231) —
  the **locality half** of G1. Deps: `Module.Finite.of_localizationSpan_finite`,
  `IsAffineOpen.isLocalization_basicOpen`, the gap2 keystone `Scheme.Modules.isLocalizedModule_basicOpen`,
  the helper above.

Also: the lvb-fbc checker flags the `_legs_conj` proof sketch as under-specified for the two-stage
φ/ψ-Spec-layer assembly — but since FBC is PARKED, defer the sketch expansion until/unless FBC resumes.

## 2. GF-G1 finite-type base case — needs blueprint split + effort-break BEFORE a prover lane [HIGH]
The remaining gap is the Mathlib-absent bridge: *`SheafOfModules.IsFiniteType` generating-sections epi ⟹
module-level surjectivity on affine global sections* (`Γ(X,V)^I → Γ(F,V)` surjective via stalkwise
surjectivity + stalk = localized module). Multi-piece geometric build (stalk=`LocalizedModule`;
epi⟺stalkwise-epi for sheaves of modules; `free I` sheaf sections = `Γ^I`; assemble surjectivity).
**Action:** (a) split blueprint `lem:gf_qcoh_fintype_finite_sections` into "locality reduction" (DONE this
iter) + "finite-type base case" (the gap); (b) dispatch an **effort-breaker** on the base case to expose
small ready sub-lemmas; (c) only then a prover lane. Do NOT send a prover at the full G1 form as-is — it
will block (the base case is larger than one session, and mathlib-build forbids a typed sorry).
Cover extraction `QuotScheme.exists_finite_basicOpen_cover_le_quasicoherentData` already exists; the
`LocalGeneratorsData` analogue is the easy topological front once the base case lands.

## 3. Lean-auditor majors/minors [LOW — cosmetic, optional]
- **Major×2 + minor×5** = (a) the 4 unmatched-node coverage debt (covered in §1); (b) stale iteration
  numbering in docstrings (`iter-177+` in `genericFlatness`/`QuotScheme`; `iter-176` file-skeleton notes;
  `iter-174+` in `RelativeSpec.lean:216` `UniversalProperty`). All carried from the original repo; confusing
  relative to iter-045 but no mathematical harm. Optional docstring cleanup; not a prover lane.
- The 9 "must-fix" are ALL pre-existing tracked open obligations (the 4 FBC sorries, `genericFlatness`, the 4
  QuotScheme protected scaffold stubs) — treat as the ongoing proof-obligation queue, NOT new problems.

## 4. Do NOT retry (blocked / dead ends)
- **FBC keystone `_legs_conj` — PARKED. No prover lane until user steer.** In-loop options exhausted across
  8 iters (037–044) + this final armed round. The conjugate route AND the affine-tilde-transport pivot both
  funnel through this keystone. The structural unknowns are now resolved (adjR/β built, conjugate-comparable,
  coherence verified); the residual two-stage transport is a dedicated multi-hundred-LOC build, not in-loop
  polish. Dead ends within it: monolithic depth-5 β (7-iter trap); `sections_direct` (illusory, iter-043);
  positional `rw`/`simp`/`erw`/`conv` on factor-3 `(pushforwardComp g' (Spec φ)).hom` under the `X.Modules`
  diamond (iter-044 instance-path divergence).
- **Global `Module Γ(X,U) Γ(F, X.basicOpen f)` instance via `Module.compHom`** — typeclass resolution LOOP.
  Keep compHom module + scalar-tower LOCAL (`letI`/`haveI`) per basic open.
- **`Module.Finite.of_isLocalizedModule` for the per-`g` finiteness transfer** — wrong direction (needs
  global `Module.Finite R M`). Use the new `finite_localizedModule_of_isLocalizedModule`.

## 5. Closest-to-ready next lanes
- **QUOT residue** (annihilator reverse inclusion, P2) in QuotScheme.lean — deferred from iter-045 (file
  was racing the FlatteningStratification import-add). The import is now landed, so QuotScheme is free for a
  prover lane next iter. Check the blueprint gate first.
- **GF-G1 base case** — only after the §2 blueprint split + effort-break.
- The frontier (`archon dag-query frontier` = 8) also lists `def:sectionGradedRing`,
  `lem:modules_annihilator_ideal`, `lem:composite_immersion_flocus_basicOpen`,
  `lem:gamma_image_iso_semilinear_top` as ready nodes — candidates if QUOT/GF lanes need a parallel partner.
