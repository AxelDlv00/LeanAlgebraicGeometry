# Iter 049 — Objectives detail

## Dispatched prover lanes (2)

### Lane 1 — SectionGradedRing.lean [mathlib-build]
- `sectionsMul` (`def:sectionMul`) — frontier-ready, associator-independent. Γ-bilinear
  `Γ(F)⊗_{Γ(𝒪)}Γ(G)→Γ(F⊗G)` via objectwise presheaf-⊗ at top open + Γ(sheafification unit η).
- `tensorPowAdd` (`lem:sheafTensorPow_add`) — Analogue-4 (`analogies/snap-assoc.md`): structural maps =
  `sheafification`(α/λ/ρ/β from `PresheafOfModules.monoidalCategory`); local-iso via η-locally-id; induction
  on m (base=left unitor; step=assoc/braid/assoc+IH-whisker, `Nat.succ_add`).
- coverage hygiene: 10 layer-1 helpers → `private`.

### Lane 2 — FlatteningStratification.lean [mathlib-build]
- seam-1 1a/1b/1c + assembly (Stacks 01PB). Build new decls. G1-assembly + G3 OUT OF SCOPE (iter-050).

## Gate record
- blueprint-reviewer `iter049` (pre-reset): SNAP `def:sectionMul` PASS; `lem:sheafTensorPow_add` must-fix
  (structural-map construction); GF seam-1 PASS; G3 FAIL (math errors); grquot not yet reviewed.
- Fixes: SNAP construction paragraph (hand); G3 rewrite (writer `g3fix`); macro typos (hand).
- blueprint-clean `iter049`: purified 3 chapters.
- blueprint-reviewer `iter049-recheck` (fast path): SectionGradedRing + FlatteningStratification + new
  GrassmannianQuot ALL complete+correct. Gate satisfied.

## GR-quot consult (not a prover lane)
- mathlib-analogist `grquot-infra`: NEEDS_MATHLIB_GAP_FILL — module-gluing over `Scheme.GlueData` +
  `IsLocallyFreeOfRank` absent ⇒ infra-build precedes scaffold (iter-050). `chartQuotientMap`/`φ*`/`represents`
  PROCEED-now. `analogies/grquot-infra.md`.

## Root-cause of the iter-048 miss
plan-validate `failed_all_noop`: objective said "BUILD" (not a `_SCAFFOLD_RE` keyword) on a 0-sorry file ⇒
dropped. Fixed: both lanes carry "scaffold … do not yet exist" on the filename header line.
