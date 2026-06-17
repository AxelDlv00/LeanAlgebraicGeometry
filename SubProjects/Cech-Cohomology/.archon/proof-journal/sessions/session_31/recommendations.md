# Recommendations — after iter-031 (for the iter-032 plan agent)

## HIGH — clear the `\leanok` false-negative (blueprint-infra, blocks DAG accuracy)
**Regenerate `blueprint/lean_decls`** (run `leanblueprint` / the lean-decls extraction step). The 11
new `…Fam` declarations are NOT in `lean_decls` (grep: 0 matches). As a result the two CechBridge named
blocks `lem:section_cech_complex_mapop_iso` (line 2601) and `lem:injective_cech_acyclic` (line 2662)
did NOT get `\leanok` from this iter's `sync_leanok`, even though the decls (both Fam and non-Fam) are
proven and axiom-clean. This is a false-negative from a stale generated file, NOT a Lean defect. After
regeneration the next `sync_leanok` will restore `\leanok` on both blocks. (Review agent cannot fix:
`\leanok` is sync's domain; `lean_decls` is a generated file outside the review write-domain.) Source:
`task_results/lean-vs-blueprint-checker-cechbridge-iter031.md` (the "major").

## HIGH — decompose `lem:qcoh_localized_sections` into P1a + P1b BEFORE assigning a P1 prover
The blueprint proof sketch (L3897–3913) is under-specified and silently elides two sub-gaps, neither
in Mathlib. Dispatch the **blueprint-writer** (chapter `Cohomology_CechHigherDirectImage.tex`,
authorize `references/**`) to add two sub-lemmas and extend `\uses`:
- **P1a — affine restriction infrastructure.** State: `[IsQuasicoherent F]` on `Spec R` + `f : R` ⟹
  `F|_{D(f)}` is a `(Spec R_f).Modules` object that is `IsQuasicoherent` / admits a `.Presentation`,
  refining `QuasicoherentData F`'s arbitrary-open cover down to basic opens via P0 + `Presentation.map`
  along `D(f_j) ⟶ X(φ j)`. Name the Mathlib morphisms used (`IsAffineOpen.basicOpen_isAffineOpen`,
  `AlgebraicGeometry.basicOpenInclusion`, `Scheme.Modules.pullback`, …) or flag explicitly as a new
  Mathlib gap. This is the load-bearing piece.
- **P1b — `IsLocalizedModule` local on a finite spanning cover** (pure algebra, independent). State:
  if `Ideal.span (range f_j) = ⊤` and each `Γ(X,F) → Γ(D(f_j),F)` is `IsLocalizedModule` at `f_j`,
  then `Γ(X,F) → Γ(D(f),F)` is `IsLocalizedModule` for `{f^k}`. Provable standalone via
  `IsLocalizedModule.mk` (3 fields: `map_units`, `surj`, `exists_of_eq`). Genuinely reusable — build
  as its own lemma. (Confirmed absent from Mathlib: only `IsLocalizedModule.mk`/`.of_linearEquiv`.)

A `% NOTE:` documenting this was added to the block this review. After the writer round, re-run the
blueprint-reviewer scoped to that chapter (same-iter fast path) before sending a P1a/P1b prover.

## HIGH — coverage debt: 9 unmatched `…Fam` helpers (planner bundles into existing `\lean{}` lists)
`archon dag-query unmatched` (10 nodes; 1 is the dead `CechAcyclic.affine`). The 9 new CechBridge
helpers below have no blueprint entry — bundle each name into the `\lean{}` list of the related
existing block (no new prose, mirroring how the non-Fam originals are listed):
- 6 public: `homCechCosimplicialFam`, `homCechComplexFam`, `homCechSectionIsoAppFam`,
  `homCechSectionCosimplicialIsoFam`, `cechComplex_hom_identificationFam`, `homCechComplexMapOpIsoFam`
  → into `lem:cech_complex_hom_identification` and `lem:cech_complex_op_identification`.
- 3 private: `homCechSectionIsoApp_hom_πFam`, `homCechCosimplicial_δFam`, `homCechComplex_d_eqFam`
  → bundle into a related decl's `\lean{}` (private is NOT exempt from `unmatched`).
(Doing this in the SAME writer round as the P1 decomposition is cheapest.)

## READY — AffineSerreVanishing lane can now discharge `BasisCovSystem.injective_acyclic`
`injective_cech_acyclicFam (U : ι → Opens ↥X) (I) [Injective I] (p) (hp : 0 < p)` is cover-agnostic
and available. The 02KG design fork (⊤-vs-`D(f)`) is now fully dissolved on both the free side
(iter-030) and the bridge side (this iter). The `AffineSerreVanishing.lean` lane (`affineCoverSystem`,
`affine_surj_of_vanishing`, `standard_cover_cofinal`) can consume it directly — no
restriction-of-injectives detour. Confirm `AffineSerreVanishing`'s blueprint chapter clears the HARD
GATE before dispatching. NOTE: `affine_surj_of_vanishing` still needs the
`SheafOfModules.toSheaf.PreservesEpimorphisms` gap-fill (per Knowledge Base / Archon memory).

## Blocked — do NOT re-assign these as single mathlib-build lanes
- **`qcoh_localized_sections` (P1) as one lane**: blocked on P1a + P1b (above). Re-issue ONLY after
  the blueprint decomposition lands. A 3rd consecutive QcohTilde PARTIAL on the same recipe is the
  CHURNING trigger named in the iter-031 plan — the corrective is the P1a/P1b split, NOT another
  mathlib-build round on the undivided P1.
- **`lem:tilde_preserves_kernels` / `tildePreservesFiniteLimits`** (the sole DAG ∞-gap, descendant of
  the 01I8 route): no informal proof yet (`~` lacks `PreservesFiniteLimits` in Mathlib). It is a
  sub-gap of P1a's downstream. Write the informal proof (dag-walker / blueprint-writer) before any
  prover; do not send a prover at an ∞-node.

## Reusable proof patterns discovered this iter
- **`…Fam` mirror recipe**: only `cech*Simplicial`/`cech*Complex`-shaped decls need a `…Fam` twin;
  open-indexed/category-generic helpers (`pi_mapIso_hom_eq`, `freeYonedaHomAddEquiv_naturality`,
  `freeYoneda`, `opCoproductIsoProduct`, `piComparison`, `opFunctor`) apply verbatim. `coverInterOpenFam
  U σ` is defeq `⨅ k, U (σ k)`, lining up with `sectionCechComplex U` with no `eqToHom`.
- **Spec topology gotchas**: `isBasis_iff_nbhd`'s `{U}{x}` are implicit — apply inline, don't pre-bind.
  `Opens.mem_iSup` must be applied via `.1` (defeq-lenient), not `rw`, when the collection is
  `(Spec R).Opens` (`↥(Spec R)` vs `PrimeSpectrum ↑R`). `(Spec R).carrier` is `rfl`-equal to
  `PrimeSpectrum ↑R`; `PrimeSpectrum.basicOpen g` is accepted directly as `(Spec R).Opens`.

## Notes (LOW)
- lean-auditor minor: CechBridge module-doc header mentions `cech_eq_cohomology_of_basis` /
  `affine_serre_vanishing` as "(planned)"; harmless stale aspirational doc, planner may refresh.
- The informal-agent external-LLM tool is unavailable in this env (`env | grep` shows only
  `GEMINI_CLI_IDE_*`, no usable API key) — provers cannot fall back to it for P1a/P1b sketches.
