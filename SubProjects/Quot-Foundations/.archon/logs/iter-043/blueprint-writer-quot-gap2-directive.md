Target: blueprint/src/chapters/Picard_QuotScheme.tex

Action: Patch the gap2 block `lem:qcoh_section_localization_basicOpen` (@~2477) and add 5 missing
blocks, so the gap2 + Piece-A prover lanes clear the HARD GATE. Source of truth for exact decl
shapes/deps: `.archon/task_results/AlgebraicJacobian/Picard/QuotScheme.md` (the iter-042 prover
hand-off, sections "Piece A", "Piece B", "Needs blueprint entry").

### 1. Add 4 helper lemma blocks (coverage debt — all already proved axiom-clean in Lean)
For each: `\begin{lemma}...\end{lemma}` with `\label{}`, `\lean{}`, accurate `\uses{}`, one-line informal proof.
- `restrictₗ` — `\lean{AlgebraicGeometry.Scheme.Modules.restrictₗ}`. Γ(X,U)-linear section restriction
  `Γ(M,U)→Γ(M,V)` for `i:V⟶U` (codomain via `Module.compHom`). Proof: `map_smul'` = `Scheme.Modules.map_smul`.
- `restrictBasicOpenₗ` — `\lean{AlgebraicGeometry.Scheme.Modules.restrictBasicOpenₗ}`. Γ(X,U)-linear restriction
  to `X.basicOpen f` (scalar-tower form). Proof: `map_smul` + `algebraMap_smul` + the `algebraMap = X.presheaf.map` defeq.
- `fromSpec_image_top_section_coherence` — `\lean{AlgebraicGeometry.Scheme.Modules.fromSpec_image_top_section_coherence}`.
  The gap2 section-coherence crux: `ρ(σ f)=f`, i.e. the section ring iso σ is the identity up to eqToHom-transport
  along `eT : fromSpec''ᵁ⊤ = U`. Deps (Mathlib): `IsAffineOpen.fromSpec_app_self`, `Scheme.Hom.appIso_hom'`/`appLE`,
  `fromSpec_preimage_self`, presheaf `Subsingleton`.
- `section_localization_hfr_aux_general` — `\lean{AlgebraicGeometry.Scheme.Modules.section_localization_hfr_aux_general}`.
  The gap2-CORE transport: for an affine open immersion `j:Spec S⟶X` with `IsIso (fromTildeΓ ((pullback j).obj M))`,
  the restriction `Γ(M,j''ᵁ⊤)→Γ(M,j''ᵁD(f'))` is `IsLocalizedModule (powers f)`. Deps: `gammaPullbackImageIso`
  (+`_hom_semilinear`/`_hom_naturality`), `gammaImageRingEquiv`, `isLocalizedModule_restrict_of_isIso_fromTildeΓ`,
  `isLocalizedModule_of_ringEquiv_semilinear`, `Submonoid.map_powers`.

### 2. Add Piece A block (NEW Mathlib-absent gap — QC preserved under pullback along fromSpec)
New `\begin{lemma}` `\label{lem:qcoh_pullback_fromSpec}`, `\lean{AlgebraicGeometry.Scheme.Modules.isQuasicoherent_pullback_fromSpec}`
(suggested name; prover may rename — flag if so). Statement: for `[M.IsQuasicoherent]` and `hU : IsAffineOpen U`,
`((pullback hU.fromSpec).obj M).IsQuasicoherent`. Route (decompose into the two real steps, each its own paragraph):
`(pullback hU.fromSpec).obj M = (pullback isoSpec.inv).obj ((pullback U.ι).obj M)`; reduce to "restriction of a QC
sheaf along an open immersion is QC", proved by building `QuasicoherentData` for `(pullback U.ι).obj M` from M's data
`q` by intersecting the cover with U (`{U ⊓ q.X i}`) and pulling the slice presentations back along the pullback functor
(`SheafOfModules.Presentation.map` preserves colimits + free via `pullbackObjFreeIso`); the slice→geometric machinery
`def:over_restrict_presentation` / `def:presentation_pullback_iota_of_quasicoherentData` already exists for cover members,
so the one new step is refining `q` to a cover of `U`. `\uses{}` those existing defs. Mark it Mathlib-absent in a `% NOTE`.

### 3. Fix the gap2 proof sketch (Defects 1+2)
Rewrite the "Remaining ingredient" paragraph (@~2555–2564): DROP the "sole genuinely new piece" framing — the general-U
transport `section_localization_hfr_aux_general` ALREADY EXISTS. Re-point the route at: instantiate that core at
`j = hU.fromSpec` (supplying `hP1` via Piece A `lem:qcoh_pullback_fromSpec` + gap1), then bridge to `restrictBasicOpenₗ`
via the proven crux `fromSpec_image_top_section_coherence` (the `ρF=f` coherence) — name BOTH lemmas explicitly in the sketch.

### 4. Update gap2 `\uses{}`
Add to `lem:qcoh_section_localization_basicOpen`'s statement `\uses{}`: `lem:qcoh_pullback_fromSpec` and the 4 helper labels above
(use the labels you assign). Keep existing entries.

Constraints: NO `\leanok` (sync owns it). Citation discipline only where you quote a new source; the 4 helpers + Piece A are
Archon-original infra (no external SOURCE QUOTE needed beyond the existing Stacks anchors already in the chapter). Out of scope:
G1-core block (already correct), FBC, GF, GR chapters.
