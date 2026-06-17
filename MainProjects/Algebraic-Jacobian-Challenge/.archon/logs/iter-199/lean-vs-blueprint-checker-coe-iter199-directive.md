# Lean ↔ Blueprint Checker — CodimOneExtension iter199

## Files in scope

- Lean: `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- Blueprint: `blueprint/src/chapters/Albanese_CodimOneExtension.tex`

## Iter-199 changes

Lean: 4 new axiom-clean substrate helpers added (L466, L527, L568, L612):
- `cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue` (L466)
- `cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue` (L527)
- `finrank_cotangentSpace_of_formallySmooth_residue` (L568)
- `finrank_cotangentSpace_of_bijective_algebraMap_residue` (L612)

Docstring updates on `isRegularLocalRing_stalk_of_smooth` L687-L875
reflecting Stage 6 sub-gap (ii.A) RESOLVED, sub-gap (ii.B) Stacks 00OE
remains as the sole gap. File-level sorry count: 3 → 3 (unchanged).

Blueprint: plan-phase iter-199 added the `\lean{AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth}`
pin to `lem:smooth_to_regular_local_ring` (L556) and replaced the stale
`_aux` pin on `lem:stage6_regular_stalk_assembly` with a NOTE.

## What to check (bidirectional)

1. The blueprint's `lem:cotangent_kahler_over_field` is reportedly pinned
   to `Algebra.KaehlerDifferential.cotangent_iso_residue_tensor_kaehler`
   (a Mathlib-style placeholder), but the iter-199 prover landed the
   corresponding Lean target under a different name. Identify the
   correct pin update and confirm the prover task report's
   recommendation:
   - `cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue` (iso form)
   - OR `finrank_cotangentSpace_of_bijective_algebraMap_residue` (closed-point bundled).
2. Is the chapter's Stage 6 split (ii.A) ↔ (ii.B) accurately reflecting
   that (ii.A) is now substrate-landed and (ii.B) remains?
3. Any other stale `\lean{...}` pins?
4. The new substrate helpers — should any get their own standalone
   blueprint pin?
